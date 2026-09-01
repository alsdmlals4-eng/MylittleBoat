# 밝은 봄 계절 레이어가 시각 전용 라우팅과 기존 명소 선택을 보존하는지 검증한다.
extends SceneTree

const RESOLVER_PATH := "res://scripts/voyage/real_time_atmosphere_resolver.gd"
const DIRECTOR_PATH := "res://scripts/voyage/drift_scenery_director.gd"
const GAME_SCENE_PATH := "res://scenes/game.tscn"
const CAPTURE_SCRIPT_PATH := "res://tests/capture_bright_spring_seasonal_parallax.gd"
const SEASONAL_ISLAND_ID := "MLB-AMB-SEASONAL-ISLAND-001"
const SEASONAL_ISLAND_TEXTURE_PATH := "res://assets/images/runtime/voyage/seasonal_parallax/bright-spring-islet.png"
const SEASONAL_CLOUD_TEXTURE_PATH := "res://assets/images/runtime/voyage/seasonal_parallax/bright-spring-clouds-chroma.png"
const CHROMA_KEY_SHADER_PATH := "res://assets/shaders/look_around_foreground_chroma_key.gdshader"
const CLOUD_CAMERA_PATHS := [
	"VoyageWorld/DioramaCameraRig/DioramaCamera3D",
	"VoyageWorld/LookAroundCameraRig/LookAroundCamera3D",
	"VoyageWorld/AppreciationCameraRig/AppreciationCamera3D",
]
const ISLAND_CAMERA_PATHS := [
	"VoyageWorld/DioramaCameraRig/DioramaCamera3D",
	"VoyageWorld/AppreciationCameraRig/AppreciationCamera3D",
]

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(ResourceLoader.exists(RESOLVER_PATH), "real-time atmosphere resolver must exist")
	_expect(ResourceLoader.exists(DIRECTOR_PATH), "drift scenery director must exist")
	_expect(ResourceLoader.exists(SEASONAL_ISLAND_TEXTURE_PATH), "approved bright spring island texture must be runtime-loadable")
	if not ResourceLoader.exists(RESOLVER_PATH) or not ResourceLoader.exists(DIRECTOR_PATH):
		_finish()
		return

	var resolver = (load(RESOLVER_PATH) as Script).new()
	_expect(resolver.has_method("resolve_season_for_month"), "resolver must expose deterministic visual-only month routing")
	if resolver.has_method("resolve_season_for_month"):
		_expect(resolver.call("resolve_season_for_month", 3) == "spring", "March must select the visual-only spring bucket")
		_expect(resolver.call("resolve_season_for_month", 5) == "spring", "May must select the visual-only spring bucket")
		_expect(str(resolver.call("resolve_season_for_month", 2)).is_empty(), "February must safely use the existing non-seasonal fallback")
		_expect(str(resolver.call("resolve_season_for_month", 13)).is_empty(), "invalid month must not create a seasonal bucket")

	var seasonal_event := _find_seasonal_bright_event()
	_expect(not seasonal_event.is_empty(), "bright spring must make the approved flower island selectable")
	if not seasonal_event.is_empty():
		_expect(str(seasonal_event.get("motif_id", "")) == SEASONAL_ISLAND_ID, "bright spring event must select the exact approved island id")
		_expect(str(seasonal_event.get("backdrop_texture_path", "")) == SEASONAL_ISLAND_TEXTURE_PATH, "bright spring event must use the exact canonical island texture")
		_expect(bool(seasonal_event.get("use_seasonal_island_layer", false)), "bright spring event must route through the dedicated island layer")
		_expect(not bool(seasonal_event.get("button", false)), "seasonal scenery must not create an interaction control")
		_expect(not seasonal_event.has("destination"), "seasonal scenery must not create a destination")

	await _verify_scene_consumers()
	await _verify_seasonal_motion_and_progression_boundary()
	_verify_temporal_renderer_evidence_contract()
	_finish()


func _find_seasonal_bright_event() -> Dictionary:
	for candidate_seed in range(1, 1025):
		var director = (load(DIRECTOR_PATH) as Script).new()
		seed(candidate_seed)
		director.set_next_event_seconds_for_tests(0.0)
		var result: Variant = director.call("advance", 0.1, "bright", "spring")
		if result is Dictionary and str(result.get("motif_id", "")) == SEASONAL_ISLAND_ID:
			return Dictionary(result)
	return {}


func _verify_scene_consumers() -> void:
	_expect(ResourceLoader.exists(GAME_SCENE_PATH), "game scene must exist for seasonal consumers")
	_expect(ResourceLoader.exists(SEASONAL_CLOUD_TEXTURE_PATH), "approved bright spring cloud texture must be runtime-loadable")
	_expect(ResourceLoader.exists(CHROMA_KEY_SHADER_PATH), "seasonal cloud must reuse the existing chroma-key shader")
	if not ResourceLoader.exists(GAME_SCENE_PATH):
		return
	var scene := (load(GAME_SCENE_PATH) as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame
	_expect(scene.has_method("apply_real_time_visual_context_for_tests"), "game scene must accept deterministic hour and month context")
	_expect(scene.has_method("get_active_season_id"), "game scene must expose the active visual-only season for contracts")
	for camera_path in CLOUD_CAMERA_PATHS:
		var cloud := scene.get_node_or_null("%s/SeasonalCloudLayer" % camera_path) as Sprite3D
		_expect(cloud != null, "%s must own a named seasonal cloud layer" % camera_path)
		if cloud != null:
			_expect(cloud.texture != null and cloud.texture.resource_path == SEASONAL_CLOUD_TEXTURE_PATH, "%s cloud layer must use the exact approved cloud texture" % camera_path)
			var cloud_material := cloud.material_override as ShaderMaterial
			_expect(cloud_material != null and cloud_material.shader != null and cloud_material.shader.resource_path == CHROMA_KEY_SHADER_PATH, "%s cloud layer must reuse the approved chroma-key shader" % camera_path)
	var look_around_foreground := scene.get_node_or_null("VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/LookAroundForeground") as Sprite3D
	var look_around_cloud := scene.get_node_or_null("VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/SeasonalCloudLayer") as Sprite3D
	_expect(look_around_foreground != null and look_around_cloud != null and look_around_foreground.material_override != look_around_cloud.material_override, "seasonal cloud material must not overwrite the angle-foreground texture binding")
	for camera_path in ISLAND_CAMERA_PATHS:
		var island := scene.get_node_or_null("%s/SeasonalIslandLayer" % camera_path) as Sprite3D
		_expect(island != null, "%s must own a named seasonal island layer" % camera_path)
		if island != null:
			_expect(island.texture != null and island.texture.resource_path == SEASONAL_ISLAND_TEXTURE_PATH, "%s island layer must use the exact approved island texture" % camera_path)
	_verify_distant_island_geometry(scene)
	var look_around_island := scene.get_node_or_null("VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/SeasonalIslandLayer")
	_expect(look_around_island == null, "Look Around must retain its angle-specific foreground policy without a seasonal island layer")
	if scene.has_method("apply_real_time_visual_context_for_tests"):
		scene.call("apply_real_time_visual_context_for_tests", 12, 4)
		_expect(scene.call("get_active_season_id") == "spring", "injected April must enable the visual-only spring bucket")
		var diorama_cloud := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeasonalCloudLayer") as Sprite3D
		_expect(diorama_cloud != null and diorama_cloud.visible, "bright spring must activate the current normal-camera cloud layer")
		scene.call("apply_real_time_visual_context_for_tests", 12, 6)
		_expect(scene.call("get_active_season_id") == "", "injected June must return to the current non-seasonal fallback")
		_expect(diorama_cloud != null and not diorama_cloud.visible, "non-spring bright time must hide the seasonal cloud layer")
	scene.queue_free()
	await process_frame


func _verify_distant_island_geometry(scene: Node) -> void:
	var camera := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D") as Camera3D
	var sea := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop") as Sprite3D
	var ambient_scenery := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/AmbientSceneryPass") as Sprite3D
	var island := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeasonalIslandLayer") as Sprite3D
	_expect(camera != null and sea != null and ambient_scenery != null and island != null, "distant-island geometry needs the real normal camera, sea, ambient pass, and island layer")
	if camera == null or sea == null or ambient_scenery == null or island == null or island.texture == null:
		return
	_expect(island.position.z > sea.position.z, "seasonal island must remain in front of the flowing sea so its transparent distant silhouette can render")
	_expect(island.region_enabled, "seasonal island must crop the transparent source canvas before entering the distant background route")
	var rendered_region := island.region_rect if island.region_enabled else Rect2(Vector2.ZERO, island.texture.get_size())
	_expect(rendered_region.position.x > 0.0 and rendered_region.position.y > 0.0 and rendered_region.end.x < island.texture.get_width() and rendered_region.end.y < island.texture.get_height(), "seasonal island region must exclude the source image's empty margins")
	var viewport_height_ratio := rendered_region.size.y * island.pixel_size / (2.0 * absf(island.position.z) * tan(deg_to_rad(camera.fov) * 0.5))
	_expect(viewport_height_ratio <= 0.30, "seasonal island must occupy a distant horizon scale instead of the boat-overlapping foreground scale")


func _verify_seasonal_motion_and_progression_boundary() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist for seasonal progression guards")
	if game_state == null:
		return
	var original_profile := str(game_state.motion_comfort_profile)
	var before_photos: int = game_state.photos.size()
	var before_fish: int = game_state.fish.size()
	var before_records: int = game_state.voyage_records.size()
	var before_together_time: float = game_state.together_time_seconds
	var standard_motion := await _sample_seasonal_motion("standard")
	var gentle_motion := await _sample_seasonal_motion("gentle")
	var still_motion := await _sample_seasonal_motion("still")
	game_state.motion_comfort_profile = original_profile
	_expect(bool(standard_motion.get("island_visible", false)), "bright spring event must render through the dedicated island layer")
	_expect(float(standard_motion.get("cloud_delta", 0.0)) > 0.0001, "standard comfort must advance the slow cloud parallax")
	_expect(float(standard_motion.get("island_delta", 0.0)) > 0.0001, "standard comfort must advance the seasonal island transit")
	_expect(float(gentle_motion.get("cloud_delta", 0.0)) > 0.0 and float(gentle_motion.get("cloud_delta", 0.0)) < float(standard_motion.get("cloud_delta", 0.0)), "gentle comfort must reduce cloud parallax without freezing it")
	_expect(float(gentle_motion.get("island_delta", 0.0)) > 0.0 and float(gentle_motion.get("island_delta", 0.0)) < float(standard_motion.get("island_delta", 0.0)), "gentle comfort must reduce island transit without freezing it")
	_expect(is_zero_approx(float(still_motion.get("cloud_delta", 0.0))), "still comfort must freeze cloud parallax")
	_expect(is_zero_approx(float(still_motion.get("island_delta", 0.0))), "still comfort must freeze island transit")
	_expect(game_state.photos.size() == before_photos, "seasonal visuals must not create a photo")
	_expect(game_state.fish.size() == before_fish, "seasonal visuals must not create fish")
	_expect(game_state.voyage_records.size() == before_records, "seasonal visuals must not create a voyage record")
	_expect(is_equal_approx(game_state.together_time_seconds, before_together_time), "seasonal visuals must not alter together-time semantics")


func _verify_temporal_renderer_evidence_contract() -> void:
	_expect(ResourceLoader.exists(CAPTURE_SCRIPT_PATH), "seasonal renderer evidence script must exist")
	if not ResourceLoader.exists(CAPTURE_SCRIPT_PATH):
		return
	var source := FileAccess.get_file_as_string(CAPTURE_SCRIPT_PATH)
	_expect(source.contains("MOTION_EARLY_CAPTURE_FILE"), "renderer evidence must retain an early in-transit island frame")
	_expect(source.contains("MOTION_LATE_CAPTURE_FILE"), "renderer evidence must retain a late in-transit island frame")
	_expect(source.contains("MIN_MOTION_HORIZONTAL_DELTA_PIXELS"), "renderer evidence must require a meaningful horizontal island displacement")
	_expect(source.contains("_get_distant_island_center_x"), "renderer evidence must locate the rendered island rather than infer movement from a timer")


func _sample_seasonal_motion(profile: String) -> Dictionary:
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		return {}
	game_state.motion_comfort_profile = profile
	var scene := (load(GAME_SCENE_PATH) as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame
	scene.set_application_foreground(false)
	scene.call("apply_real_time_visual_context_for_tests", 12, 4)
	var director = scene.get("_drift_scenery_director")
	var event_seed := _find_no_save_seasonal_bright_seed()
	if director == null or event_seed < 0:
		scene.queue_free()
		await process_frame
		return {}
	director.set_foreground(true)
	director.set_next_event_seconds_for_tests(0.0)
	seed(event_seed)
	scene.call("_advance_drift_scenery", 0.1)
	var cloud := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeasonalCloudLayer") as Sprite3D
	var island := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeasonalIslandLayer") as Sprite3D
	var cloud_start_x := cloud.position.x if cloud != null else 0.0
	var island_start_x := island.position.x if island != null else 0.0
	scene.call("_apply_drift_motion", 1.0)
	var result := {
		"island_visible": island != null and island.visible,
		"cloud_delta": absf(cloud.position.x - cloud_start_x) if cloud != null else 0.0,
		"island_delta": absf(island.position.x - island_start_x) if island != null else 0.0,
	}
	scene.queue_free()
	await process_frame
	return result


func _find_no_save_seasonal_bright_seed() -> int:
	for candidate_seed in range(1, 1025):
		var director = (load(DIRECTOR_PATH) as Script).new()
		seed(candidate_seed)
		director.set_next_event_seconds_for_tests(0.0)
		var event: Variant = director.call("advance", 0.1, "bright", "spring")
		if event is Dictionary and str(event.get("motif_id", "")) == SEASONAL_ISLAND_ID and not bool(event.get("save_memory", true)):
			return candidate_seed
	return -1


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: seasonal parallax contract")
		quit(0)
	else:
		printerr("FAILED: %d seasonal parallax assertions" % _failures)
		quit(1)
