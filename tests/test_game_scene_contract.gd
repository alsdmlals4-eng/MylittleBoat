# 보트 휴식 화면의 저밀도 메뉴·감상·낚시·세션 연속성을 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const COMFORT_STORAGE_PATH := "user://test_game_scene_comfort.cfg"
const PHOTO_CONFIG_PATH := "user://test_game_scene_postcards.cfg"
const PHOTO_IMAGE_DIRECTORY := "user://test_game_scene_postcards"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	if game_state == null:
		_finish()
		return

	game_state.reset_session()
	game_state.voyage_active = true
	game_state.remaining_seconds = 123.0
	game_state.speed_index = 1
	game_state.appreciation_mode = false
	_remove_test_file()
	_cleanup_photo_storage()
	if game_state.has_method("set_comfort_storage_path"):
		game_state.set_comfort_storage_path(COMFORT_STORAGE_PATH)
	if game_state.has_method("set_motion_comfort_profile"):
		game_state.set_motion_comfort_profile("standard")
	if game_state.has_method("set_photo_memory_storage"):
		game_state.set_photo_memory_storage(PHOTO_CONFIG_PATH, PHOTO_IMAGE_DIRECTORY)
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	_expect(packed_scene != null, "game.tscn must load")
	if packed_scene == null:
		_finish()
		return

	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame
	var timer_label := scene.get_node_or_null("TopPanel/TopVBox/TimerLabel") as Label
	var voyage_status := scene.get_node_or_null("TopPanel/TopVBox/VoyageStatusLabel") as Label
	var rest_menu_button := scene.get_node_or_null("RestMenuButton") as Button
	var bottom_panel := scene.get_node_or_null("BottomPanel") as Control
	var take_photo_button := scene.get_node_or_null("BottomPanel/ButtonGrid/TakePhotoButton") as Button
	var appreciation_button := scene.get_node_or_null("BottomPanel/ButtonGrid/AppreciationButton") as Button
	var speed_button := scene.get_node_or_null("BottomPanel/ButtonGrid/SpeedButton") as Button
	var album_button := scene.get_node_or_null("BottomPanel/ButtonGrid/AlbumButton") as Button
	var fishing_button := scene.get_node_or_null("BottomPanel/ButtonGrid/FishingButton") as Button
	var fishing_status := scene.get_node_or_null("TopPanel/TopVBox/FishingStatusLabel") as Label
	var distant_scenery_label := scene.get_node_or_null("DistantSceneryLabel") as Label
	var next_voyage_button := scene.get_node_or_null("BottomPanel/ButtonGrid/NextVoyageButton") as Button
	var comfort_button := scene.get_node_or_null("BottomPanel/ButtonGrid/ComfortButton") as Button
	var camera_rig := scene.get_node_or_null("VoyageWorld/DioramaCameraRig") as Node3D
	var boat_space := scene.get_node_or_null("VoyageWorld/BoatSpace") as Node3D
	var can_capture_viewport := DisplayServer.get_name() != "headless"

	_expect(timer_label != null and timer_label.text == "02:03", "game scene must resume GameState.remaining_seconds after a scene round trip")
	_expect(voyage_status != null and not voyage_status.text.contains("마음:"), "first-frame status must remain neutral")
	_expect(rest_menu_button != null and rest_menu_button.visible, "normal view must show a compact rest menu entry")
	_expect(bottom_panel != null and not bottom_panel.visible, "normal view must keep the large action grid closed")
	_expect(fishing_button != null, "game scene must expose optional FishingButton")
	_expect(fishing_status != null, "game scene must expose FishingStatusLabel")
	_expect(distant_scenery_label != null and not distant_scenery_label.visible, "distant scenery must begin as quiet non-interactive context")
	_expect(scene.get_node_or_null("BottomPanel/ButtonGrid/LetterButton") == null, "direct voyage must not expose a letter-recording action")
	_expect(scene.get_node_or_null("BottomPanel/ButtonGrid/SceneryButton") == null, "direct voyage must not expose a scenery-recording action")
	_expect(next_voyage_button != null and not next_voyage_button.visible, "next voyage stays hidden before the five-minute session completes")
	_expect(comfort_button != null, "rest menu must expose an optional ComfortButton")
	if take_photo_button != null and can_capture_viewport:
		var postcard_count_before: int = game_state.photo_memories.size()
		take_photo_button.emit_signal("pressed")
		RenderingServer.force_draw(true)
		await RenderingServer.frame_post_draw
		await process_frame
		_expect(game_state.photo_memories.size() == postcard_count_before + 1, "photo button must save one postcard after a rendered frame")
		_expect(rest_menu_button != null and rest_menu_button.visible, "photo capture must restore compact rest menu visibility")
		_expect(bottom_panel != null and not bottom_panel.visible, "photo capture must restore closed rest menu state")
		_expect(scene.get_active_camera_mode() == "diorama", "photo capture must not switch camera mode")
		if game_state.photo_memories.size() == postcard_count_before + 1:
			_expect(FileAccess.file_exists(str(game_state.photo_memories.back().get("image_path", ""))), "photo button postcard must reference a real local PNG")
	elif take_photo_button != null:
		print("SKIP: headless renderer does not support viewport postcard capture")

	if scene.has_method("open_rest_menu"):
		scene.open_rest_menu()
		_expect(bottom_panel != null and bottom_panel.visible, "rest menu API must reveal optional actions")
		_expect(rest_menu_button != null and not rest_menu_button.visible, "opening rest menu must hide the compact entry")
		if comfort_button != null:
			_expect(comfort_button.visible and comfort_button.text == "파도: 기본", "comfort starts at the approved standard motion profile")
			comfort_button.emit_signal("pressed")
			await process_frame
			_expect(comfort_button.text == "파도: 잔잔", "comfort button cycles to the gentle motion profile")
	else:
		_expect(false, "game scene must provide open_rest_menu")

	if appreciation_button != null and take_photo_button != null and speed_button != null and album_button != null:
		appreciation_button.emit_signal("pressed")
		await process_frame
		_expect(appreciation_button.visible, "AppreciationButton must remain visible so appreciation mode can be exited")
		_expect(not take_photo_button.visible, "appreciation mode must hide TakePhotoButton")
		_expect(not speed_button.visible, "appreciation mode must hide SpeedButton")
		_expect(not album_button.visible, "appreciation mode must hide AlbumButton")
		_expect(comfort_button != null and not comfort_button.visible, "appreciation mode must hide ComfortButton with other optional controls")
		appreciation_button.emit_signal("pressed")
		await process_frame

	if boat_space != null and camera_rig != null and game_state.has_method("set_motion_comfort_profile"):
		var base_boat_position: Vector3 = scene.get("_boat_space_base_position")
		var base_boat_rotation: Vector3 = scene.get("_boat_space_base_rotation")
		var base_camera_position: Vector3 = scene.get("_diorama_camera_base_position")
		var base_boat_y := base_boat_position.y
		var base_boat_roll := base_boat_rotation.z
		var base_camera_y := base_camera_position.y
		scene.set("_drift_phase", 0.0)
		game_state.set_motion_comfort_profile("standard")
		scene.call("_apply_drift_motion", 0.5)
		var standard_boat_offset := absf(boat_space.position.y - base_boat_y)
		var standard_camera_offset := absf(camera_rig.position.y - base_camera_y)
		scene.set("_drift_phase", 0.0)
		game_state.set_motion_comfort_profile("gentle")
		scene.call("_apply_drift_motion", 0.5)
		var gentle_boat_offset := absf(boat_space.position.y - base_boat_y)
		var gentle_camera_offset := absf(camera_rig.position.y - base_camera_y)
		scene.set("_drift_phase", 0.0)
		game_state.set_motion_comfort_profile("still")
		scene.call("_apply_drift_motion", 0.5)
		_expect(is_equal_approx(gentle_boat_offset, standard_boat_offset * 0.5), "gentle comfort must halve visible boat bob at the same drift phase")
		_expect(is_equal_approx(gentle_camera_offset, standard_camera_offset * 0.5), "gentle comfort must halve visible camera bob at the same drift phase")
		_expect(is_equal_approx(boat_space.position.y, base_boat_y), "still comfort must remove automatic boat bob")
		_expect(is_equal_approx(boat_space.rotation.z, base_boat_roll), "still comfort must remove automatic boat roll")
		_expect(is_equal_approx(camera_rig.position.y, base_camera_y), "still comfort must remove automatic camera bob")
	else:
		_expect(false, "game scene must expose boat, camera, and comfort profile behavior")

	if camera_rig != null and scene.has_method("_cycle_speed"):
		game_state.set_motion_comfort_profile("standard")
		var before_y := camera_rig.position.y
		scene.call("_cycle_speed")
		scene.call("_process", 0.5)
		_expect(not is_equal_approx(camera_rig.position.y, before_y), "speed control must produce observable diorama drift/bob motion")
	else:
		_expect(false, "game scene must provide diorama camera rig and speed behavior")

	_expect(scene.has_method("_handle_fishing_action"), "game scene must connect the calm fishing interaction")
	var source := FileAccess.get_file_as_string("res://scripts/voyage/game_scene.gd")
	_expect(not source.contains("main_menu.tscn"), "completed voyages must not return to a setup menu")
	_expect(not source.contains("_spawn_ambient_discovery"), "old action-gated ambient discovery must not remain in the product route")
	_expect(source.contains("drift_scenery_director"), "game scene must consume foreground-only drifting scenery")

	game_state.remaining_seconds = 0.01
	game_state.voyage_record_created = false
	scene.call("_process", 0.02)
	await process_frame
	_expect(next_voyage_button != null and next_voyage_button.visible, "NextVoyageButton must appear after the five-minute voyage record is created")

	scene.queue_free()
	await _release_runtime_soundscape_for_test_shutdown()
	_remove_test_file()
	_cleanup_photo_storage()
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _remove_test_file() -> void:
	if FileAccess.file_exists(COMFORT_STORAGE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(COMFORT_STORAGE_PATH))


func _cleanup_photo_storage() -> void:
	if FileAccess.file_exists(PHOTO_CONFIG_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(PHOTO_CONFIG_PATH))
	var absolute_directory := ProjectSettings.globalize_path(PHOTO_IMAGE_DIRECTORY)
	if not DirAccess.dir_exists_absolute(absolute_directory):
		return
	var directory := DirAccess.open(absolute_directory)
	if directory != null:
		for file_name in directory.get_files():
			DirAccess.remove_absolute(absolute_directory.path_join(file_name))
	DirAccess.remove_absolute(absolute_directory)


# 독립 GPU 검사 종료 전에 AudioServer가 재생 참조를 비울 프레임을 확보한다.
func _release_runtime_soundscape_for_test_shutdown() -> void:
	var soundscape := root.get_node_or_null("RestingSoundscape")
	if soundscape != null and soundscape.has_method("release_ocean_bed_for_shutdown"):
		soundscape.call("release_ocean_bed_for_shutdown")
	for _frame in 4:
		await process_frame


func _finish() -> void:
	if _failures == 0:
		print("PASS: calm voyage game scene contract")
		quit(0)
	else:
		printerr("FAILED: %d calm voyage scene assertions" % _failures)
		quit(1)
