# 승인된 치비 대체 외형과 쿠션이 실제 항해 화면에서 함께 읽히는지 기록한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-31-approved-alternate-chibi-family"
const IDENTITY_TEST_SAVE_PATH := "user://capture_approved_alternate_chibi_identity.cfg"
const DECOR_TEST_SAVE_PATH := "user://capture_approved_alternate_chibi_decor.cfg"
const GAME_SCENE_PATH := "res://scenes/game.tscn"


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(540, 960)
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		_fail("could not create approved alternate chibi evidence directory")
		return
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_fail("GameState autoload must exist")
		return
	_prepare_isolated_storage(game_state)
	if not await _capture_pair(game_state, "a_soft_hooded", "cat", "stripe", "a_cat_stripe_540x960.png"):
		_restore_storage(game_state)
		return
	if not await _capture_pair(game_state, "b_short_cape", "rabbit", "moon", "b_rabbit_moon_540x960.png"):
		_restore_storage(game_state)
		return
	if not await _capture_pair(game_state, "a_soft_hooded", "otter", "stripe", "a_otter_stripe_540x960.png"):
		_restore_storage(game_state)
		return
	_restore_storage(game_state)
	print("PASS: approved alternate chibi family runtime captures")
	quit(0)


func _prepare_isolated_storage(game_state: Node) -> void:
	DirAccess.remove_absolute(ProjectSettings.globalize_path(IDENTITY_TEST_SAVE_PATH))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(DECOR_TEST_SAVE_PATH))
	game_state.set_identity_storage_path(IDENTITY_TEST_SAVE_PATH)
	game_state.set_boat_decor_storage_path(DECOR_TEST_SAVE_PATH)
	game_state.boat_decor.clear()
	game_state.boat_decor_appearances.clear()
	game_state.reset_session()
	game_state.voyage_active = true
	game_state.remaining_seconds = 300.0


func _capture_pair(game_state: Node, player_style_id: String, pet_type_id: String, cushion_appearance: String, output_file_name: String) -> bool:
	game_state.set_selected_player_style(player_style_id)
	game_state.set_selected_pet_type(pet_type_id)
	game_state.boat_decor.clear()
	game_state.boat_decor_appearances.clear()
	game_state.set_boat_decor("pet_corner", "pet_cushion")
	game_state.set_boat_decor_appearance("pet_corner", cushion_appearance)
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	if packed_scene == null:
		_fail("game scene must load")
		return false
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await _wait_for_frames(12)
	if not scene.has_method("set_application_foreground"):
		scene.queue_free()
		await process_frame
		_fail("game scene must expose foreground control")
		return false
	scene.call("set_application_foreground", false)
	if not _save_runtime_image(output_file_name):
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
		_fail("could not save %s" % output_path)
		return false
	print("SAVED: %s (%dx%d)" % [output_path, image.get_width(), image.get_height()])
	return true


func _restore_storage(game_state: Node) -> void:
	game_state.reset_session()
	game_state.set_identity_storage_path("user://identity_profile_v1.cfg")
	game_state.set_boat_decor_storage_path("user://boat_decor_v1.cfg")
	game_state.load_boat_decor()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(IDENTITY_TEST_SAVE_PATH))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(DECOR_TEST_SAVE_PATH))


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
