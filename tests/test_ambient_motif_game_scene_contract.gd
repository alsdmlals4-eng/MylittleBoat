# 승인 자연 명소가 물 배경을 덮지 않고 normal·감상 화면을 가로질러 흐르는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const DIRECTOR_PATH := "res://scripts/voyage/drift_scenery_director.gd"
const BASE_BRIGHT_SKY_TEXTURE_PATH := "res://assets/images/runtime/voyage/split/bright-static-sky.png"
const BASE_BRIGHT_SEA_TEXTURE_PATH := "res://assets/images/runtime/voyage/split/bright-flowing-sea.png"
const BRIGHT_MOTIF_PATHS := [
	"res://assets/images/runtime/voyage/ambient_motifs/bright-seagrass-sandbar.png",
	"res://assets/images/runtime/voyage/ambient_motifs/bright-chalk-cliffs-birds.png",
]
const EXPECTED_PASS_START_OFFSET_X_BY_PATH := {
	"res://assets/images/runtime/voyage/ambient_motifs/bright-seagrass-sandbar.png": 21.0,
	"res://assets/images/runtime/voyage/ambient_motifs/bright-chalk-cliffs-birds.png": -21.0,
}

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	_expect(ResourceLoader.exists(GAME_SCENE_PATH), "game scene must exist")
	if game_state == null or not ResourceLoader.exists(GAME_SCENE_PATH):
		_finish()
		return
	game_state.reset_session()
	game_state.begin_voyage()
	# 시간 경과 자체가 아니라 풍경 연출의 저장 상태 부작용만 측정한다.
	# 실시간 프레임 대기는 이동 Tween을 검증하기 위해 필요하다.
	var before_photos: int = int(game_state.photos.size())
	var before_fish: int = int(game_state.fish.size())
	var before_records: int = int(game_state.voyage_records.size())
	var before_together_time: float = float(game_state.together_time_seconds)
	var scene := (load(GAME_SCENE_PATH) as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame
	scene.apply_real_time_atmosphere_for_hour(12)
	var motif_seed := _find_no_save_bright_motif_seed()
	_expect(motif_seed >= 0, "a deterministic bright approved motif must be selectable without saving a memory")
	if motif_seed >= 0:
		var director = scene.get("_drift_scenery_director")
		director.set_next_event_seconds_for_tests(0.0)
		seed(motif_seed)
		scene.call("_advance_drift_scenery", 0.1)
		scene.set_application_foreground(false)
		var normal_backdrop := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop") as Sprite3D
		var appreciation_backdrop := scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeaBackdrop") as Sprite3D
		var normal_sky := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SkyBackdrop") as Sprite3D
		var appreciation_sky := scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SkyBackdrop") as Sprite3D
		var normal_pass := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/AmbientSceneryPass") as Sprite3D
		var appreciation_pass := scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/AmbientSceneryPass") as Sprite3D
		var diorama_camera := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D") as Camera3D
		var scenery_label := scene.get_node_or_null("DistantSceneryLabel") as Label
		var scenery_timer := scene.get_node_or_null("AmbientSceneryReturnTimer") as Timer
		_expect(normal_sky != null and normal_sky.texture != null and normal_sky.texture.resource_path == BASE_BRIGHT_SKY_TEXTURE_PATH, "bright scenery must preserve the normal static sky")
		_expect(appreciation_sky != null and appreciation_sky.texture != null and appreciation_sky.texture.resource_path == BASE_BRIGHT_SKY_TEXTURE_PATH, "bright scenery must preserve the Appreciation static sky")
		_expect(normal_backdrop != null and normal_backdrop.texture != null and normal_backdrop.texture.resource_path == BASE_BRIGHT_SEA_TEXTURE_PATH, "bright scenery must preserve the normal flowing sea")
		_expect(appreciation_backdrop != null and appreciation_backdrop.texture != null and appreciation_backdrop.texture.resource_path == BASE_BRIGHT_SEA_TEXTURE_PATH, "bright scenery must preserve the Appreciation flowing sea")
		_expect(normal_backdrop != null and is_zero_approx(normal_backdrop.position.x), "bright scenery must not shift the normal flowing sea")
		_expect(appreciation_backdrop != null and is_zero_approx(appreciation_backdrop.position.x), "bright scenery must not shift the Appreciation flowing sea")
		_expect(normal_pass != null and normal_pass.visible and normal_pass.texture != null and normal_pass.texture.resource_path in BRIGHT_MOTIF_PATHS, "bright scenery must use an approved normal-camera pass card")
		_expect(appreciation_pass != null and appreciation_pass.visible and appreciation_pass.texture != null and appreciation_pass.texture.resource_path in BRIGHT_MOTIF_PATHS, "bright scenery must use an approved Appreciation-camera pass card")
		_expect(normal_pass != null and is_equal_approx(normal_pass.pixel_size, 0.02), "bright scenery pass must overscan vertically so a hard horizontal image edge cannot cross the boat view")
		_expect(appreciation_pass != null and is_equal_approx(appreciation_pass.pixel_size, 0.02), "Appreciation scenery pass must use the same vertical overscan")
		if normal_pass != null and normal_pass.texture != null:
			var expected_offset_x := float(EXPECTED_PASS_START_OFFSET_X_BY_PATH.get(normal_pass.texture.resource_path, 0.0))
			_expect(is_equal_approx(normal_pass.position.x, expected_offset_x), "bright scenery pass must begin from the authored horizon side")
			_expect(appreciation_pass != null and is_equal_approx(appreciation_pass.position.x, expected_offset_x), "bright scenery pass must begin from the same horizon side in Appreciation mode")
			var initial_pass_x := normal_pass.position.x
			await create_timer(0.35).timeout
			_expect(not is_equal_approx(normal_pass.position.x, initial_pass_x), "bright scenery pass must move across the horizon over live frames")
			_expect(normal_pass.modulate.a > 0.0, "bright scenery pass must fade in instead of appearing as a hard backdrop swap")
		_expect(diorama_camera != null and diorama_camera.keep_aspect == Camera3D.KEEP_HEIGHT, "portrait motif visibility must preserve the approved tight diorama camera framing")
		_expect(scenery_label != null and scenery_label.visible and not scenery_label.text.is_empty(), "ambient motif must retain one quiet non-interactive label")
		_expect(scenery_timer != null and not scenery_timer.is_stopped(), "ambient motif must schedule its existing temporary return")
		scene.call("_restore_active_atmosphere_backdrop")
		_expect(normal_backdrop != null and normal_backdrop.texture != null and normal_backdrop.texture.resource_path == BASE_BRIGHT_SEA_TEXTURE_PATH, "restoring the current atmosphere must return to the normal bright flowing sea")
		_expect(normal_sky != null and normal_sky.texture != null and normal_sky.texture.resource_path == BASE_BRIGHT_SKY_TEXTURE_PATH, "restoring the current atmosphere must retain the normal bright static sky")
		_expect(normal_backdrop != null and is_zero_approx(normal_backdrop.position.x), "restoring the current atmosphere must recenter the normal flowing sea")
		_expect(appreciation_backdrop != null and is_zero_approx(appreciation_backdrop.position.x), "restoring the current atmosphere must recenter the Appreciation flowing sea")
		_expect(normal_pass != null and not normal_pass.visible, "restoring the current atmosphere must hide the normal scenery pass")
		_expect(appreciation_pass != null and not appreciation_pass.visible, "restoring the current atmosphere must hide the Appreciation scenery pass")
		_expect(game_state.photos.size() == before_photos, "ambient scenery must not create a photo")
		_expect(game_state.fish.size() == before_fish, "ambient scenery must not create fish")
		_expect(game_state.voyage_records.size() == before_records, "ambient scenery must not create a voyage record")
		_expect(is_equal_approx(game_state.together_time_seconds, before_together_time), "ambient scenery must not alter together-time semantics")
	scene.queue_free()
	await process_frame
	game_state.reset_session()
	_finish()


func _find_no_save_bright_motif_seed() -> int:
	for candidate_seed in range(1, 257):
		var director = (load(DIRECTOR_PATH) as Script).new()
		seed(candidate_seed)
		director.set_next_event_seconds_for_tests(0.0)
		var event := Dictionary(director.advance(0.1, "bright"))
		if not event.is_empty() and not bool(event.get("save_memory", true)):
			return candidate_seed
	return -1


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: ambient motif game scene contract")
		quit(0)
	else:
		printerr("FAILED: %d ambient motif game scene assertions" % _failures)
		quit(1)
