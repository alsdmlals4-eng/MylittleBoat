# 현재 현실 시간 분위기 capture로 대체된 과거 네 시간대 runner를 retire한다.
extends SceneTree

<<<<<<< HEAD
const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-30-water-only-atmosphere-v2"
const IDENTITY_TEST_SAVE_PATH := "user://capture_four_time_identity.cfg"
const DECOR_TEST_SAVE_PATH := "user://capture_four_time_decor.cfg"
const TIME_OF_DAY_CATALOG_SCRIPT = preload("res://scripts/voyage/time_of_day_catalog.gd")
const RUNTIME_CAPTURE_GUARD_SCRIPT = preload("res://scripts/visual/runtime_capture_guard.gd")

=======
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564

func _init() -> void:
	print("HISTORICAL_RETIRED: use res://tests/capture_direct_boat_entry_atmospheres.gd")
	quit(0)
<<<<<<< HEAD


func _capture_pair(game_state: Node, time_of_day_id: String) -> bool:
	game_state.reset_session()
	game_state.voyage_active = true
	game_state.remaining_seconds = 300.0
	var packed_scene := load("res://scenes/game.tscn") as PackedScene
	if packed_scene == null:
		_fail("game scene must load")
		return false
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	var hour := _hour_for_time_of_day(time_of_day_id)
	if not scene.has_method("apply_real_time_atmosphere_for_hour"):
		_fail("game scene must expose injected real-time atmosphere API")
		scene.queue_free()
		await process_frame
		return false
	scene.apply_real_time_atmosphere_for_hour(hour)
	if not scene.has_method("get_active_atmosphere_id") or scene.get_active_atmosphere_id() != time_of_day_id:
		_fail("capture hour must apply requested visual ID: %s" % time_of_day_id)
		scene.queue_free()
		await process_frame
		return false
	await _wait_for_frames(10)
	if not await _save_runtime_image("%s_normal_540x960.png" % time_of_day_id):
		scene.queue_free()
		await process_frame
		return false
	if scene.has_method("open_rest_menu"):
		scene.open_rest_menu()
	var appreciation_button := scene.get_node_or_null("BottomPanel/ButtonGrid/AppreciationButton") as Button
	if appreciation_button == null:
		_fail("appreciation button must exist")
		scene.queue_free()
		await process_frame
		return false
	appreciation_button.emit_signal("pressed")
	await _wait_for_frames(10)
	if not await _save_runtime_image("%s_appreciation_540x960.png" % time_of_day_id):
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
	RenderingServer.force_draw(true)
	await RenderingServer.frame_post_draw
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


func _restore_test_state(game_state: Node) -> void:
	game_state.reset_session()
	game_state.set_identity_storage_path("user://identity_profile_v1.cfg")
	_remove_identity_test_save()
	game_state.boat_decor.clear()
	game_state.boat_decor_appearances.clear()
	game_state.set_boat_decor_storage_path("user://boat_decor_v1.cfg")
	game_state.load_boat_decor()
	_remove_decor_test_save()


func _hour_for_time_of_day(time_of_day_id: String) -> int:
	match time_of_day_id:
		"dawn":
			return 6
		"bright":
			return 12
		"sunset":
			return 18
		"night":
			return 22
	return 12


func _remove_decor_test_save() -> void:
	if FileAccess.file_exists(DECOR_TEST_SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(DECOR_TEST_SAVE_PATH))


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
=======
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
