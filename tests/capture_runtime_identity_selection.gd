# 선택된 외형 조합의 headless 런타임 화면 증거를 저장한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-27-runtime-identity-selection"
const GAME_STATE_TEST_SAVE_PATH := "user://capture_identity_selection.cfg"
const BOAT_DECOR_TEST_SAVE_PATH := "user://capture_runtime_identity_decor.cfg"


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
	_remove_test_save()
	_remove_decor_test_save()
	game_state.set_identity_storage_path(GAME_STATE_TEST_SAVE_PATH)
	game_state.set_boat_decor_storage_path(BOAT_DECOR_TEST_SAVE_PATH)
	game_state.load_boat_decor()
	if not await _capture_pair(game_state, "c_loose_knit", "dog", "c_dog"):
		_restore_game_state_storage(game_state)
		return
	if not await _capture_pair(game_state, "b_short_cape", "otter", "b_otter"):
		_restore_game_state_storage(game_state)
		return
	_restore_game_state_storage(game_state)
	print("PASS: runtime identity selection captures")
	quit(0)


func _capture_pair(game_state: Node, player_style_id: String, pet_type_id: String, prefix: String) -> bool:
	game_state.reset_session()
	if game_state.appreciation_mode:
		_fail("capture pair %s must begin in diorama mode" % prefix)
		return false
	game_state.set_selected_player_style(player_style_id)
	game_state.set_selected_pet_type(pet_type_id)
	var packed_scene := load("res://scenes/game.tscn") as PackedScene
	if packed_scene == null:
		_fail("game scene must load")
		return false
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await _wait_for_frames(10)
	if not _save_runtime_image("normal_540x960_%s.png" % prefix):
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
	if not _save_runtime_image("appreciation_540x960_%s.png" % prefix):
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


func _remove_test_save() -> void:
	if FileAccess.file_exists(GAME_STATE_TEST_SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(GAME_STATE_TEST_SAVE_PATH))


func _remove_decor_test_save() -> void:
	if FileAccess.file_exists(BOAT_DECOR_TEST_SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(BOAT_DECOR_TEST_SAVE_PATH))


func _restore_game_state_storage(game_state: Node) -> void:
	game_state.reset_session()
	game_state.set_identity_storage_path("user://identity_profile_v1.cfg")
	game_state.set_boat_decor_storage_path("user://boat_decor_v1.cfg")
	game_state.load_boat_decor()
	_remove_test_save()
	_remove_decor_test_save()


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
