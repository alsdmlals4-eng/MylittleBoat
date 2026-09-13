# 승인 봄섬의 공통 세계 위치와 실제 이동·시점 전환을 지정된 새 폴더에 촬영한다.
extends SceneTree

const CAMERAS := ["DioramaCameraRig/DioramaCamera3D", "AppreciationCameraRig/AppreciationCamera3D", "LookAroundCameraRig/LookAroundCamera3D"]
var output_directory := ""
var samples: Array[Dictionary] = []
var capture_errors := 0

func _init() -> void:
	call_deferred("run")

func run() -> void:
	if DisplayServer.get_name() == "headless":
		printerr("GPU capture requires a display renderer; no runtime image evidence produced")
		quit(2)
		return
	var args := OS.get_cmdline_user_args()
	if args.size() != 1 or not args[0].is_absolute_path() or DirAccess.dir_exists_absolute(args[0]):
		printerr("Provide a new absolute evidence directory")
		quit(2)
		return
	output_directory = args[0]
	if DirAccess.make_dir_recursive_absolute(output_directory) != OK:
		quit(2)
		return
	root.size = Vector2i(540, 960)
	root.gui_disable_input = true
	var state := root.get_node("GameState")
	var paths: Array[String] = []
	for kind in ["comfort", "together_time", "memory_ledger", "identity", "boat_decor", "ambient_memory"]:
		var path := "user://test_world_probe_%s.cfg" % kind
		paths.append(path)
		state.call("set_%s_storage_path" % kind, path)
	state.begin_voyage()
	var game := load("res://scenes/game.tscn").instantiate() as Control
	game.set_script(load("res://tests/fixtures/capture_clock_game.gd"))
	root.add_child(game)
	current_scene = game
	await process_frame
	game.set_process(false)
	game.set_application_foreground(true)
	game.apply_real_time_visual_context_for_tests(12, 4)
	game.start_voyage_from_title()
	state.speed_index = 1
	state.motion_comfort_profile = "standard"
	game._apply_drift_motion(0.0)
	game._show_seasonal_island_layer(load("res://assets/images/runtime/voyage/seasonal_parallax/bright-spring-islet.png"), 1.0)
	var island := game.get_node("VoyageWorld/SeasonalIslandLayer") as Sprite3D
	var original_world := island.global_position
	game._apply_drift_motion(5.0)
	await sample(game, "normal-5s", island.global_position)
	game._toggle_appreciation_mode()
	await sample(game, "appreciation-5s", island.global_position)
	game._toggle_appreciation_mode()
	game.set_look_around_mode(true)
	await sample(game, "look-neutral-5s", island.global_position)
	game.get_node("VoyageWorld/LookAroundCameraRig").set_view_angles(20.0, 0.0)
	await sample(game, "look-left-5s", island.global_position)
	game.set_look_around_mode(false)
	game._apply_drift_motion(10.0)
	await sample(game, "normal-15s", island.global_position)
	var world_unchanged := island.global_position.is_equal_approx(original_world)
	game._apply_drift_motion(40.0)
	await sample(game, "normal-passed", island.global_position)
	var cleared := not island.visible
	game._show_seasonal_island_layer(load("res://assets/images/runtime/voyage/seasonal_parallax/bright-spring-islet.png"), -1.0)
	game._apply_drift_motion(5.0)
	await sample(game, "opposite-5s", island.global_position)
	game.set_look_around_mode(true)
	game.get_node("VoyageWorld/LookAroundCameraRig").set_view_angles(-35.0, 0.0)
	await sample(game, "look-opposite-5s", island.global_position)
	for row in samples:
		if row.label in ["normal-5s", "appreciation-5s", "look-neutral-5s", "look-left-5s", "look-opposite-5s"] and row.get("island_pixel_samples", 0) < 100:
			capture_errors += 1
			printerr("Approved island not visible in required camera sample: " + str(row.label))
	var report := {
		"role": "PRODUCTION_WORLD_ISLAND_MANUAL_DELTA_GPU_SAMPLES",
		"world_position_unchanged_during_pass": world_unchanged,
		"cleared_after_pass": cleared,
		"renderer": RenderingServer.get_current_rendering_method(),
		"capture_errors": capture_errors,
		"samples": samples,
		"motion_time_evidence": "EXPLICIT_DELTA_NOT_REALTIME",
	}
	var file := FileAccess.open(output_directory.path_join("projection.json"), FileAccess.WRITE)
	if file == null:
		printerr("Cannot write projection report")
	else:
		file.store_string(JSON.stringify(report, "\t"))
		file.close()
	print(JSON.stringify(report))
	game.queue_free()
	await process_frame
	root.get_node("RestingSoundscape").release_ocean_bed_for_shutdown()
	for _frame in 4:
		await process_frame
	for path in paths:
		preload("res://tests/helpers/config_store_test_cleanup.gd").remove_store(path)
	quit(0 if file != null and capture_errors == 0 and world_unchanged and cleared else 2)

func sample(_game: Node, label: String, world_position: Vector3) -> void:
	await process_frame
	var camera := root.get_camera_3d()
	var screen := camera.unproject_position(world_position)
	samples.append({"label": label, "camera": str(camera.get_path()), "world": [world_position.x, world_position.y, world_position.z], "screen": [screen.x, screen.y], "behind": camera.is_position_behind(world_position)})
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		var picture := root.get_texture().get_image()
		var grass_samples := 0
		var min_x := picture.get_width()
		var max_x := -1
		for y in range(380, 850, 2):
			for x in range(0, picture.get_width(), 2):
				var pixel := picture.get_pixel(x, y)
				if pixel.g >= 0.45 and pixel.g >= pixel.r * 1.12 and pixel.g >= pixel.b * 1.18:
					grass_samples += 1
					min_x = mini(min_x, x)
					max_x = maxi(max_x, x)
		samples[-1]["island_pixel_samples"] = grass_samples
		samples[-1]["island_pixel_x_bounds"] = [min_x, max_x]
		var error := picture.save_png(output_directory.path_join(label + ".png"))
		if error != OK:
			capture_errors += 1
			printerr("Screenshot save failed: " + label)
