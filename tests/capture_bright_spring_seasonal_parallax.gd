# 밝은 봄의 구름·꽃섬 분리 합성이 실제 normal과 감상 화면에 렌더되는 증거를 저장한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-09-01-bright-spring-seasonal-parallax"
const GAME_SCENE_PATH := "res://scenes/game.tscn"
const DIRECTOR_SCRIPT = preload("res://scripts/voyage/drift_scenery_director.gd")
const SEASONAL_ISLAND_ID := "MLB-AMB-SEASONAL-ISLAND-001"
const SEASONAL_ISLAND_TEXTURE_PATH := "res://assets/images/runtime/voyage/seasonal_parallax/bright-spring-islet.png"
const SEASONAL_CLOUD_TEXTURE_PATH := "res://assets/images/runtime/voyage/seasonal_parallax/bright-spring-clouds-chroma.png"
const CHROMA_KEY_SHADER_PATH := "res://assets/shaders/look_around_foreground_chroma_key.gdshader"
const NORMAL_CAPTURE_FILE := "bright_spring_normal_540x960.png"
const APPRECIATION_CAPTURE_FILE := "bright_spring_appreciation_540x960.png"
const MOTION_EARLY_CAPTURE_FILE := "bright_spring_normal_motion_early_540x960.png"
const MOTION_LATE_CAPTURE_FILE := "bright_spring_normal_motion_late_540x960.png"
const MIN_UPPER_CLOUD_BRIGHT_SAMPLES := 100
const MOTION_EARLY_WAIT_SECONDS := 6.5
const MOTION_MID_WAIT_SECONDS := 0.5
const MOTION_LATE_WAIT_SECONDS := 0.5
const MIN_MOTION_HORIZONTAL_DELTA_PIXELS := 80.0


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(540, 960)
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		_fail("could not create seasonal parallax evidence directory")
		return
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_fail("GameState autoload must exist")
		return
	game_state.reset_session()
	game_state.begin_voyage()
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	if packed_scene == null:
		_fail("game scene must load")
		return
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame
	scene.set_application_foreground(false)
	if not scene.has_method("apply_real_time_visual_context_for_tests"):
		await _cleanup(scene, game_state)
		_fail("game scene must expose the deterministic bright spring visual context")
		return
	if not await _prepare_bright_spring_capture(scene):
		await _cleanup(scene, game_state)
		return
	_set_gameplay_ui_visible(scene, false)
	await create_timer(MOTION_EARLY_WAIT_SECONDS).timeout
	var early_motion_image := await _save_runtime_image(MOTION_EARLY_CAPTURE_FILE, true)
	if early_motion_image == null:
		await _cleanup(scene, game_state)
		return
	await create_timer(MOTION_MID_WAIT_SECONDS).timeout
	if str(scene.call("get_active_atmosphere_id")) != "bright" or str(scene.call("get_active_season_id")) != "spring":
		await _cleanup(scene, game_state)
		_fail("capture must retain the injected bright spring context during the real drift interval")
		return
	var normal_image := await _save_runtime_image(NORMAL_CAPTURE_FILE, true)
	if normal_image == null:
		await _cleanup(scene, game_state)
		return
	await create_timer(MOTION_LATE_WAIT_SECONDS).timeout
	var late_motion_image := await _save_runtime_image(MOTION_LATE_CAPTURE_FILE, true)
	if late_motion_image == null or not _assert_visible_island_motion(early_motion_image, late_motion_image):
		await _cleanup(scene, game_state)
		return
	scene.call("_toggle_appreciation_mode")
	await RenderingServer.frame_post_draw
	var appreciation_image := await _save_runtime_image(APPRECIATION_CAPTURE_FILE)
	if appreciation_image == null:
		await _cleanup(scene, game_state)
		return
	await _cleanup(scene, game_state)
	print("PASS: bright spring seasonal parallax GPU captures")
	quit(0)


func _prepare_bright_spring_capture(scene: Node) -> bool:
	scene.call("apply_real_time_visual_context_for_tests", 12, 4)
	if str(scene.call("get_active_atmosphere_id")) != "bright" or str(scene.call("get_active_season_id")) != "spring":
		_fail("capture must restore the injected bright spring context after display focus notifications")
		return false
	if not _trigger_no_save_seasonal_island(scene):
		return false
	return _assert_seasonal_render_route(scene)


func _trigger_no_save_seasonal_island(scene: Node) -> bool:
	var director = scene.get("_drift_scenery_director")
	var event_seed := _find_no_save_seasonal_island_seed()
	if director == null or event_seed < 0:
		_fail("could not select a no-save bright spring island event")
		return false
	director.set_foreground(true)
	director.set_next_event_seconds_for_tests(0.0)
	seed(event_seed)
	scene.call("_advance_drift_scenery", 0.1)
	return true


func _assert_seasonal_render_route(scene: Node) -> bool:
	var normal_cloud := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeasonalCloudLayer") as Sprite3D
	var normal_island := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeasonalIslandLayer") as Sprite3D
	var appreciation_island := scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeasonalIslandLayer") as Sprite3D
	if normal_cloud == null or normal_island == null or appreciation_island == null:
		_fail("normal and Appreciation seasonal layers must exist")
		return false
	var cloud_material := normal_cloud.material_override as ShaderMaterial
	if not normal_cloud.visible or normal_cloud.texture == null or normal_cloud.texture.resource_path != SEASONAL_CLOUD_TEXTURE_PATH:
		_fail("bright spring normal camera must visibly bind the approved cloud texture")
		return false
	if cloud_material == null or cloud_material.shader == null or cloud_material.shader.resource_path != CHROMA_KEY_SHADER_PATH:
		_fail("bright spring cloud must use the existing chroma-key shader")
		return false
	if not normal_island.visible or normal_island.texture == null or normal_island.texture.resource_path != SEASONAL_ISLAND_TEXTURE_PATH:
		_fail("normal camera must visibly bind the approved seasonal island texture")
		return false
	if not appreciation_island.visible or appreciation_island.texture == null or appreciation_island.texture.resource_path != SEASONAL_ISLAND_TEXTURE_PATH:
		_fail("Appreciation camera must receive the same active seasonal island")
		return false
	return true


func _find_no_save_seasonal_island_seed() -> int:
	for candidate_seed in range(1, 1025):
		var director = DIRECTOR_SCRIPT.new()
		seed(candidate_seed)
		director.set_next_event_seconds_for_tests(0.0)
		var event := Dictionary(director.advance(0.1, "bright", "spring"))
		if str(event.get("motif_id", "")) == SEASONAL_ISLAND_ID and not bool(event.get("save_memory", true)):
			return candidate_seed
	return -1


func _set_gameplay_ui_visible(scene: Node, is_visible: bool) -> void:
	for node_path in ["TopPanel", "BottomPanel", "RestMenuButton", "DistantSceneryLabel"]:
		var node := scene.get_node_or_null(node_path) as CanvasItem
		if node != null:
			node.visible = is_visible


func _save_runtime_image(file_name: String, requires_clear_boat_lane: bool = false) -> Image:
	RenderingServer.force_draw(true)
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	if image == null or image.is_empty():
		_fail("empty runtime image for %s" % file_name)
		return null
	var output_path := "%s/%s" % [EVIDENCE_DIRECTORY, file_name]
	if image.save_png(output_path) != OK:
		_fail("could not save %s" % file_name)
		return null
	if not _has_visible_upper_cloud_mark(image):
		_fail("seasonal cloud must leave a visible upper-sky mark in %s" % file_name)
		return null
	if requires_clear_boat_lane and not _has_clear_boat_lane(image):
		_fail("seasonal island must remain above the boat lane in %s" % file_name)
		return null
	if requires_clear_boat_lane and not _has_visible_distant_island_mark(image):
		_fail("seasonal island must remain visibly present in the distant horizon band in %s" % file_name)
		return null
	print("SAVED: %s (%dx%d)" % [output_path, image.get_width(), image.get_height()])
	return image


func _has_visible_upper_cloud_mark(image: Image) -> bool:
	var bright_sample_count := 0
	var upper_y_limit := int(image.get_height() * 0.40)
	for y in range(0, upper_y_limit, 2):
		for x in range(0, image.get_width(), 2):
			var pixel := image.get_pixel(x, y)
			if pixel.r >= 0.88 and pixel.g >= 0.86 and pixel.b >= 0.86:
				bright_sample_count += 1
	return bright_sample_count >= MIN_UPPER_CLOUD_BRIGHT_SAMPLES


func _has_clear_boat_lane(image: Image) -> bool:
	var island_like_sample_count := 0
	var lower_y_start := int(image.get_height() * 0.64)
	for y in range(lower_y_start, image.get_height(), 2):
		for x in range(0, image.get_width(), 2):
			if x >= 145 and x <= 405:
				continue
			if _is_island_like_pixel(image.get_pixel(x, y)):
				island_like_sample_count += 1
	return island_like_sample_count <= 12


func _has_visible_distant_island_mark(image: Image) -> bool:
	var island_like_sample_count := 0
	var horizon_y_start := int(image.get_height() * 0.40)
	var horizon_y_end := int(image.get_height() * 0.63)
	for y in range(horizon_y_start, horizon_y_end, 2):
		for x in range(0, image.get_width(), 2):
			if _is_island_like_pixel(image.get_pixel(x, y)):
				island_like_sample_count += 1
	return island_like_sample_count >= 20


func _assert_visible_island_motion(early_image: Image, late_image: Image) -> bool:
	var early_center_x := _get_distant_island_center_x(early_image)
	var late_center_x := _get_distant_island_center_x(late_image)
	if early_center_x < 0.0 or late_center_x < 0.0:
		_fail("seasonal island motion frames must both contain a horizon island silhouette")
		return false
	if absf(late_center_x - early_center_x) < MIN_MOTION_HORIZONTAL_DELTA_PIXELS:
		_fail("seasonal island must visibly traverse the horizon between renderer motion frames")
		return false
	print("MOTION_DELTA_PIXELS=%.1f" % absf(late_center_x - early_center_x))
	return true


func _get_distant_island_center_x(image: Image) -> float:
	var min_x := image.get_width()
	var max_x := -1
	var horizon_y_start := int(image.get_height() * 0.40)
	var horizon_y_end := int(image.get_height() * 0.63)
	for y in range(horizon_y_start, horizon_y_end, 2):
		for x in range(0, image.get_width(), 2):
			if _is_island_like_pixel(image.get_pixel(x, y)):
				min_x = mini(min_x, x)
				max_x = maxi(max_x, x)
	if max_x < 0:
		return -1.0
	return (float(min_x) + float(max_x)) * 0.5


func _is_island_like_pixel(pixel: Color) -> bool:
	var grass_like := pixel.g >= 0.45 and pixel.g >= pixel.r * 1.12 and pixel.g >= pixel.b * 1.18
	var flower_like := pixel.r >= 0.78 and pixel.b >= 0.52 and pixel.g <= 0.70
	return grass_like or flower_like


func _cleanup(scene: Node, game_state: Node) -> void:
	scene.queue_free()
	await process_frame
	game_state.reset_session()


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
