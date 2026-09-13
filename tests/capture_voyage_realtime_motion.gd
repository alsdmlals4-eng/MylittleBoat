# 실제 process 시간으로 항해를 촬영하며 phase·선체 접점과 저장 격리를 기록한다.
extends SceneTree

var output := ""
var paths: Array[String] = []


func _init() -> void:
	call_deferred("capture")

func capture() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() < 1 or args.size() > 2 or not args[0].is_absolute_path() or DisplayServer.get_name() == "headless":
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
	# 촬영 fixture만 입력을 차단한다. 실제 플레이의 입력 검증이 아니다.
	root.gui_disable_input = true
	var state := root.get_node("GameState")
	for kind in ["comfort", "together_time", "memory_ledger", "identity", "boat_decor", "ambient_memory"]:
		var path := "user://test_realtime_motion_%s.cfg" % kind
		paths.append(path)
		state.call("set_%s_storage_path" % kind, path)
	state.reset_session()
	state.set_selected_player_style("c_loose_knit")
	state.set_selected_pet_type("dog")
	state.boat_decor.clear()
	state.boat_decor_appearances.clear()
	state.set_boat_decor("pet_corner", "pet_cushion")
	state.set_boat_decor_appearance("pet_corner", "floral")
	state.set_motion_comfort_profile("standard")
	state.speed_index = 1
	var game := load("res://scenes/game.tscn").instantiate() as Control
	# autoload 초기화 뒤 fixture를 로드한다. --script의 정적 preload는 GameState보다 빠르다.
	game.set_script(load("res://tests/fixtures/capture_clock_game.gd"))
	if not game.has_method("apply_real_time_atmosphere_for_hour"):
		game.free()
		_cleanup_storage()
		printerr("Game script failed to load; capture aborted")
		quit(2)
		return
	root.add_child(game)
	await process_frame
	game.apply_real_time_atmosphere_for_hour(12)
	for _frame in 4:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(output.path_join("title.png"))
	# Start uses the actual title button signal, not a hand-advanced drift phase.
	game.get_node("%StartVoyageButton").pressed.emit()
	game.set_application_foreground(true)
	var seasonal := args.size() == 2 and args[1] == "seasonal"
	if seasonal:
		game.apply_real_time_visual_context_for_tests(12, 4)
		game._show_seasonal_island_layer(load("res://assets/images/runtime/voyage/seasonal_parallax/bright-spring-islet.png"), 1.0)
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
		var camera: Vector3 = game.get_node("VoyageWorld/DioramaCameraRig").position
		var player := game.get_node("VoyageWorld/BoatSpace/FinalDioramaCard/PartsViewport/Player") as Sprite2D
		var pet := game.get_node("VoyageWorld/BoatSpace/FinalDioramaCard/PartsViewport/Pet") as Sprite2D
		rows.append({"seconds": elapsed, "phase": game.get_forward_water_flow_offset(), "ambient_phase": game.get_background_flow_offset(), "foreground": game.get("_application_in_foreground"), "boat": [boat.x, boat.y, boat.z], "contact": [contact.x, contact.y, contact.z], "camera": [camera.x, camera.y, camera.z], "player_rotation": player.rotation, "pet_rotation": pet.rotation, "remaining_seconds": state.remaining_seconds})
		var island := game.get_node("VoyageWorld/SeasonalIslandLayer") as Sprite3D
		rows[-1]["atmosphere"] = game.get_active_atmosphere_id()
		rows[-1]["season"] = game.get_active_season_id()
		rows[-1]["island_progress"] = game.get("_seasonal_island_progress")
		rows[-1]["island_position"] = [island.position.x, island.position.y, island.position.z]
		rows[-1]["island_visible"] = island.visible
		frame += 1
		next_capture += 0.2
	var file := FileAccess.open(output.path_join("telemetry.json"), FileAccess.WRITE)
	file.store_string(JSON.stringify({"mode": "REALTIME_PROCESS_EXPLICIT_FOREGROUND_NO_MANUAL_DELTA", "fixture_input_disabled": true, "fixture_identity": "c_loose_knit/dog", "frames": rows, "renderer": RenderingServer.get_current_rendering_method(), "viewport": [540, 960]}, "\t"))
	file.close()
	game._open_decor_panel()
	for _frame in 4:
		await process_frame
	await RenderingServer.frame_post_draw
	root.get_texture().get_image().save_png(output.path_join("decor-preview.png"))
	game._close_decor_panel()
	game.queue_free()
	await process_frame
	var soundscape := root.get_node_or_null("RestingSoundscape")
	if soundscape != null and soundscape.has_method("release_ocean_bed_for_shutdown"):
		soundscape.release_ocean_bed_for_shutdown()
	for _frame in 4:
		await process_frame
	_cleanup_storage()
	print("REALTIME_CAPTURE_FRAMES=%d OUTPUT=%s" % [frame, output])
	quit()

func _cleanup_storage() -> void:
	for path in paths:
		preload("res://tests/helpers/config_store_test_cleanup.gd").remove_store(path)
