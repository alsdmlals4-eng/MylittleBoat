# C+강아지 최종 합성 화면의 승인 장식 배치를 저장한다.
extends SceneTree

const EVIDENCE_PATH := "res://docs/evidence/2026-08-27-final-composite-decor/floral-cushion-postcard_540x960.png"
const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-27-final-composite-decor"
const IDENTITY_TEST_SAVE_PATH := "user://capture_final_composite_identity.cfg"
const DECOR_TEST_SAVE_PATH := "user://capture_final_composite_decor.cfg"
const RUNTIME_CAPTURE_GUARD_SCRIPT = preload("res://scripts/visual/runtime_capture_guard.gd")


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(540, 960)
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		_fail("could not create final composite decor evidence directory")
		return
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_fail("GameState autoload must exist")
		return
	var runtime_capture_guard = RUNTIME_CAPTURE_GUARD_SCRIPT.new()
	if not runtime_capture_guard.get_unavailable_texture_paths(runtime_capture_guard.REQUIRED_TEXTURE_PATHS).is_empty():
		_fail("required imported runtime textures unavailable")
		return
	_remove_test_saves()
	game_state.set_identity_storage_path(IDENTITY_TEST_SAVE_PATH)
	game_state.set_boat_decor_storage_path(DECOR_TEST_SAVE_PATH)
	game_state.boat_decor.clear()
	game_state.boat_decor_appearances.clear()
	game_state.set_selected_player_style("c_loose_knit")
	game_state.set_selected_pet_type("dog")
	game_state.set_boat_decor("pet_corner", "pet_cushion")
	game_state.set_boat_decor_appearance("pet_corner", "floral")
	game_state.set_boat_decor("rail_accent", "postcard")
	game_state.reset_session()
	game_state.selected_mood = "평온"
	game_state.select_time_of_day("bright")
	var scene := (load("res://scenes/game.tscn") as PackedScene).instantiate()
	root.add_child(scene)
	for _frame in 10:
		await process_frame
	var image := root.get_texture().get_image()
	if image == null or image.is_empty() or image.save_png(EVIDENCE_PATH) != OK:
		scene.queue_free()
		await process_frame
		_restore_state(game_state)
		_fail("could not save final composite decor capture")
		return
	scene.queue_free()
	await process_frame
	_restore_state(game_state)
	print("PASS: final composite decor runtime capture")
	quit(0)


func _restore_state(game_state: Node) -> void:
	game_state.reset_session()
	game_state.select_time_of_day("bright")
	game_state.set_identity_storage_path("user://identity_profile_v1.cfg")
	game_state.boat_decor.clear()
	game_state.boat_decor_appearances.clear()
	game_state.set_boat_decor_storage_path("user://boat_decor_v1.cfg")
	game_state.load_boat_decor()
	_remove_test_saves()


func _remove_test_saves() -> void:
	for test_save_path in [IDENTITY_TEST_SAVE_PATH, DECOR_TEST_SAVE_PATH]:
		if FileAccess.file_exists(test_save_path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(test_save_path))


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
