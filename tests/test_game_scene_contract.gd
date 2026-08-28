# 항해 화면이 선택 없이 시작하고 선택형 휴식 행동을 보존하는지 검증한다.
extends SceneTree

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

	var packed_scene := load("res://scenes/game.tscn") as PackedScene
	_expect(packed_scene != null, "game.tscn must load")
	if packed_scene == null:
		_finish()
		return

	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame

	var timer_label := scene.get_node_or_null("TopPanel/TopVBox/TimerLabel") as Label
	var rest_menu_button := scene.get_node_or_null("RestMenuButton") as Button
	var bottom_panel := scene.get_node_or_null("BottomPanel") as Control
	var take_photo_button := scene.get_node_or_null("BottomPanel/ButtonGrid/TakePhotoButton") as Button
	var appreciation_button := scene.get_node_or_null("BottomPanel/ButtonGrid/AppreciationButton") as Button
	var speed_button := scene.get_node_or_null("BottomPanel/ButtonGrid/SpeedButton") as Button
	var fishing_button := scene.get_node_or_null("BottomPanel/ButtonGrid/FishingButton") as Button
	var decor_button := scene.get_node_or_null("BottomPanel/ButtonGrid/DecorButton") as Button
	var interact_button := scene.get_node_or_null("BottomPanel/ButtonGrid/InteractButton") as Button
	var album_button := scene.get_node_or_null("BottomPanel/ButtonGrid/AlbumButton") as Button
	var camera_rig := scene.get_node_or_null("VoyageWorld/DioramaCameraRig") as Node3D

	_expect(timer_label != null and timer_label.text == "02:03", "game scene must resume GameState.remaining_seconds after a scene round trip")
	_expect(rest_menu_button != null and rest_menu_button.visible, "game scene must expose a quiet menu button")
	_expect(bottom_panel != null and not bottom_panel.visible, "game scene must begin as a clean boat view")
	if rest_menu_button != null:
		rest_menu_button.emit_signal("pressed")
		await process_frame
	_expect(bottom_panel != null and bottom_panel.visible, "menu button must reveal optional actions")
	_expect(take_photo_button != null and appreciation_button != null and speed_button != null, "menu must retain photo, appreciation, and speed actions")
	_expect(fishing_button != null and decor_button != null and interact_button != null and album_button != null, "menu must retain optional calm actions")

	if appreciation_button != null and take_photo_button != null and speed_button != null and album_button != null:
		appreciation_button.emit_signal("pressed")
		await process_frame
		_expect(appreciation_button.visible, "AppreciationButton must remain visible so appreciation mode can be exited")
		_expect(not take_photo_button.visible, "appreciation mode must hide TakePhotoButton")
		_expect(not speed_button.visible, "appreciation mode must hide SpeedButton")
		_expect(not album_button.visible, "appreciation mode must hide AlbumButton")
		appreciation_button.emit_signal("pressed")
		await process_frame

	if camera_rig != null and scene.has_method("_cycle_speed"):
		var before_y := camera_rig.position.y
		scene.call("_cycle_speed")
		scene.call("_process", 0.5)
		_expect(not is_equal_approx(camera_rig.position.y, before_y), "speed control must produce observable diorama drift/bob motion")
	else:
		_expect(false, "game scene must provide diorama camera rig and speed behavior")

	var source := FileAccess.get_file_as_string("res://scripts/voyage/game_scene.gd")
	_expect(not source.contains("main_menu.tscn"), "next voyage must not return to a selection screen")
	_expect(not source.contains("selected_mood"), "game scene must not depend on removed mood state")

	scene.queue_free()
	await process_frame
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: calm voyage game scene contract")
		quit(0)
	else:
		printerr("FAILED: %d calm voyage scene assertions" % _failures)
		quit(1)
