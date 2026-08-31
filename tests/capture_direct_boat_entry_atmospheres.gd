# 직행 보트 화면의 현실 시간 분위기와 먼 풍경 런타임 증거를 저장한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-29-direct-boat-entry"
const IDENTITY_TEST_SAVE_PATH := "user://capture_direct_entry_identity.cfg"
const DECOR_TEST_SAVE_PATH := "user://capture_direct_entry_decor.cfg"


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(540, 960)
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		_fail("could not create direct-entry evidence directory")
		return
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_fail("GameState autoload must exist")
		return
	_remove_test_saves()
	game_state.set_identity_storage_path(IDENTITY_TEST_SAVE_PATH)
	game_state.set_boat_decor_storage_path(DECOR_TEST_SAVE_PATH)
	game_state.boat_decor.clear()
	game_state.boat_decor_appearances.clear()
	game_state.set_selected_player_style("c_loose_knit")
	game_state.set_selected_pet_type("dog")
	for capture_state in [
		{"hour": 6, "file": "dawn_normal_540x960.png"},
		{"hour": 12, "file": "bright_normal_540x960.png"},
		{"hour": 18, "file": "sunset_normal_540x960.png"},
		{"hour": 22, "file": "night_normal_540x960.png"},
	]:
		if not await _capture_atmosphere(game_state, int(capture_state["hour"]), str(capture_state["file"])):
			_restore_game_state(game_state)
			return
	if not await _capture_distant_scenery(game_state):
		_restore_game_state(game_state)
		return
	_restore_game_state(game_state)
	print("PASS: direct boat entry atmosphere runtime captures")
	quit(0)


func _capture_atmosphere(game_state: Node, hour: int, file_name: String) -> bool:
	game_state.reset_session()
	var scene := _instantiate_game_scene()
	if scene == null:
		return false
	scene.call("apply_real_time_atmosphere_for_hour", hour)
	await _wait_for_frames(10)
	var menu_button := scene.get_node_or_null("RestMenuButton") as Button
	var bottom_panel := scene.get_node_or_null("BottomPanel") as Control
	if menu_button == null or not menu_button.visible or bottom_panel == null or bottom_panel.visible:
		_fail("direct capture must keep the quiet menu closed")
		scene.queue_free()
		await process_frame
		return false
	var saved := _save_runtime_image(file_name)
	scene.queue_free()
	await process_frame
	return saved


func _capture_distant_scenery(game_state: Node) -> bool:
	game_state.reset_session()
	var scene := _instantiate_game_scene()
	if scene == null:
		return false
	scene.call("apply_real_time_atmosphere_for_hour", 12)
	scene.call("_spawn_distant_scenery", "islet", false)
	var distant_layer := scene.get_node_or_null("DistantSceneryLayer") as Control
	if distant_layer == null or distant_layer.get_child_count() != 1:
		_fail("distant scenery capture must create one visible prop")
		scene.queue_free()
		await process_frame
		return false
	var distant_prop := distant_layer.get_child(0) as TextureRect
	if distant_prop == null:
		_fail("distant scenery capture prop must be a TextureRect")
		scene.queue_free()
		await process_frame
		return false
	distant_prop.position.x = 24.0
	await _wait_for_frames(10)
	var saved := _save_runtime_image("bright_distant_islet_540x960.png")
	scene.queue_free()
	await process_frame
	return saved


func _instantiate_game_scene() -> Node:
	var packed_scene := load("res://scenes/game.tscn") as PackedScene
	if packed_scene == null:
		_fail("game scene must load")
		return null
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	return scene


func _wait_for_frames(frame_count: int) -> void:
	for _frame in frame_count:
		await process_frame


func _save_runtime_image(file_name: String) -> bool:
	var image := root.get_texture().get_image()
	if image == null or image.is_empty():
		_fail("empty runtime image for %s" % file_name)
		return false
	var output_path := "%s/%s" % [EVIDENCE_DIRECTORY, file_name]
	if image.save_png(output_path) != OK:
		_fail("could not save %s" % file_name)
		return false
	print("SAVED: %s (%dx%d)" % [output_path, image.get_width(), image.get_height()])
	return true


func _remove_test_saves() -> void:
	for path in [IDENTITY_TEST_SAVE_PATH, DECOR_TEST_SAVE_PATH]:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))


func _restore_game_state(game_state: Node) -> void:
	game_state.reset_session()
	game_state.set_identity_storage_path("user://identity_profile_v1.cfg")
	game_state.set_boat_decor_storage_path("user://boat_decor_v1.cfg")
	game_state.load_boat_decor()
	_remove_test_saves()


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
