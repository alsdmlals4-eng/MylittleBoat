# 네 시간대의 두 카메라 런타임 화면 증거를 저장한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-27-four-time-atmosphere"
const IDENTITY_TEST_SAVE_PATH := "user://capture_four_time_identity.cfg"
const TIME_OF_DAY_CATALOG_SCRIPT = preload("res://scripts/voyage/time_of_day_catalog.gd")


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(540, 960)
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		_fail("could not create runtime evidence directory")
		return
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_fail("GameState autoload must exist")
		return
	_remove_identity_test_save()
	game_state.set_identity_storage_path(IDENTITY_TEST_SAVE_PATH)
	game_state.set_selected_player_style("c_loose_knit")
	game_state.set_selected_pet_type("dog")
	var time_of_day_catalog = TIME_OF_DAY_CATALOG_SCRIPT.new()
	for time_of_day_id in time_of_day_catalog.get_time_of_day_ids():
		if not await _capture_pair(game_state, time_of_day_id):
			_restore_identity_storage(game_state)
			return
	_restore_identity_storage(game_state)
	print("PASS: four-time atmosphere runtime captures")
	quit(0)


func _capture_pair(game_state: Node, time_of_day_id: String) -> bool:
	game_state.reset_session()
	game_state.selected_mood = "평온"
	game_state.select_time_of_day(time_of_day_id)
	var packed_scene := load("res://scenes/game.tscn") as PackedScene
	if packed_scene == null:
		_fail("game scene must load")
		return false
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await _wait_for_frames(10)
	if not _save_runtime_image("%s_normal_540x960.png" % time_of_day_id):
		scene.queue_free()
		await process_frame
		return false
	var appreciation_button := scene.get_node_or_null("BottomPanel/ButtonGrid/AppreciationButton") as Button
	if appreciation_button == null:
		_fail("appreciation button must exist")
		scene.queue_free()
		await process_frame
		return false
	appreciation_button.emit_signal("pressed")
	await _wait_for_frames(10)
	if not _save_runtime_image("%s_appreciation_540x960.png" % time_of_day_id):
		scene.queue_free()
		await process_frame
		return false
	scene.queue_free()
	await process_frame
	return true


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


func _remove_identity_test_save() -> void:
	if FileAccess.file_exists(IDENTITY_TEST_SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(IDENTITY_TEST_SAVE_PATH))


func _restore_identity_storage(game_state: Node) -> void:
	game_state.reset_session()
	game_state.select_time_of_day("bright")
	game_state.set_identity_storage_path("user://identity_profile_v1.cfg")
	_remove_identity_test_save()


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
