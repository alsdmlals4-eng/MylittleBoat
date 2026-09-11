# 실제 process 시간으로 항해를 촬영하며 phase·선체 접점과 저장 격리를 기록한다.
extends SceneTree

var output := ""
var paths: Array[String] = []

func _init() -> void:
	call_deferred("capture")

func capture() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or not args[0].is_absolute_path() or DisplayServer.get_name() == "headless":
		printerr("Requires display renderer and one absolute, empty output directory")
		quit(2)
		return
	output = args[0]
	if DirAccess.dir_exists_absolute(output):
		printerr("Refusing to overwrite an existing evidence directory")
		quit(2)
		return
	DirAccess.make_dir_recursive_absolute(output)
	root.size = Vector2i(540, 960)
	var state := root.get_node("GameState")
	for kind in ["comfort", "together_time", "memory_ledger"]:
		var path := "user://test_realtime_motion_%s.cfg" % kind
		paths.append(path)
		state.call("set_%s_storage_path" % kind, path)
	state.reset_session()
	state.set_motion_comfort_profile("standard")
	state.speed_index = 1
	var game := load("res://scenes/game.tscn").instantiate() as Control
	root.add_child(game)
	await process_frame
	game.apply_real_time_atmosphere_for_hour(12)
	# Start uses the actual title button signal, not a hand-advanced drift phase.
	game.get_node("%StartVoyageButton").pressed.emit()
	game.set_application_foreground(true)
	var rows: Array[Dictionary] = []
	var start := Time.get_ticks_msec()
	var next_capture := 0.0
	var frame := 0
	while float(Time.get_ticks_msec() - start) / 1000.0 < 30.2:
		await process_frame
		# The automated host can own OS focus. Explicit foreground fixture, real delta.
		# This tests running presentation, not operating-system focus delivery.
		game.set_application_foreground(true)
		var elapsed := float(Time.get_ticks_msec() - start) / 1000.0
		if elapsed < next_capture:
			continue
		await RenderingServer.frame_post_draw
		var picture := root.get_texture().get_image()
		picture.save_png(output.path_join("frame_%03d.png" % frame))
		var boat: Vector3 = game.get_node("VoyageWorld/BoatSpace").position
		var contact: Vector3 = game.get_node("VoyageWorld/BoatWaterContact").position
		rows.append({"seconds": elapsed, "phase": game.get_forward_water_flow_offset(), "ambient_phase": game.get_background_flow_offset(), "foreground": game.get("_application_in_foreground"), "boat": [boat.x, boat.y, boat.z], "contact": [contact.x, contact.y, contact.z], "remaining_seconds": state.remaining_seconds})
		frame += 1
		next_capture += 0.2
	var file := FileAccess.open(output.path_join("telemetry.json"), FileAccess.WRITE)
	file.store_string(JSON.stringify({"mode": "REALTIME_PROCESS_EXPLICIT_FOREGROUND_NO_MANUAL_DELTA", "frames": rows, "renderer": RenderingServer.get_current_rendering_method(), "viewport": [540, 960]}, "\t"))
	file.close()
	game.queue_free()
	await process_frame
	for path in paths:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	print("REALTIME_CAPTURE_FRAMES=%d OUTPUT=%s" % [frame, output])
	quit()
