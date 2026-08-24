# 항해 화면이 상태 연속성·감상·발견·낚시 의미를 실제 UI로 표현하는지 검증한다.
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
	var take_photo_button := scene.get_node_or_null("BottomPanel/ButtonGrid/TakePhotoButton") as Button
	var appreciation_button := scene.get_node_or_null("BottomPanel/ButtonGrid/AppreciationButton") as Button
	var speed_button := scene.get_node_or_null("BottomPanel/ButtonGrid/SpeedButton") as Button
	var letter_button := scene.get_node_or_null("BottomPanel/ButtonGrid/LetterButton") as Button
	var scenery_button := scene.get_node_or_null("BottomPanel/ButtonGrid/SceneryButton") as Button
	var album_button := scene.get_node_or_null("BottomPanel/ButtonGrid/AlbumButton") as Button
	var fishing_button := scene.get_node_or_null("BottomPanel/ButtonGrid/FishingButton") as Button
	var fishing_status := scene.get_node_or_null("TopPanel/TopVBox/FishingStatusLabel") as Label
	var camera_rig := scene.get_node_or_null("VoyageWorld/CameraRig") as Node3D

	_expect(timer_label != null and timer_label.text == "02:03", "game scene must resume GameState.remaining_seconds after a scene round trip")
	_expect(letter_button != null and not letter_button.visible, "letter action must stay hidden until an ambient letter exists")
	_expect(scenery_button != null and not scenery_button.visible, "scenery action must stay hidden until an ambient scenery exists")
	_expect(fishing_button != null, "game scene must expose optional FishingButton")
	_expect(fishing_status != null, "game scene must expose FishingStatusLabel")

	if appreciation_button != null and take_photo_button != null and speed_button != null and album_button != null:
		appreciation_button.emit_signal("pressed")
		await process_frame
		_expect(appreciation_button.visible, "AppreciationButton must remain visible so appreciation mode can be exited")
		_expect(not take_photo_button.visible, "appreciation mode must hide TakePhotoButton")
		_expect(not speed_button.visible, "appreciation mode must hide SpeedButton")
		_expect(not album_button.visible, "appreciation mode must hide AlbumButton")

	if camera_rig != null and scene.has_method("_cycle_speed"):
		var before_y := camera_rig.position.y
		scene.call("_cycle_speed")
		scene.call("_process", 0.5)
		_expect(not is_equal_approx(camera_rig.position.y, before_y), "speed control must produce observable drift/bob motion")
	else:
		_expect(false, "game scene must provide camera rig and speed behavior")

	_expect(scene.has_method("_spawn_ambient_discovery"), "game scene must schedule ambient discoveries instead of permanent reward buttons")
	_expect(scene.has_method("_handle_fishing_action"), "game scene must connect the calm fishing interaction")

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
