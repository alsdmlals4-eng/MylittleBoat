# 승인 봄섬의 카메라별 공간 불일치와 단일 world-space 배치의 한계를 검사하는 진단 전용 도구다.
extends SceneTree

const CAMERAS := ["DioramaCameraRig/DioramaCamera3D", "AppreciationCameraRig/AppreciationCamera3D", "LookAroundCameraRig/LookAroundCamera3D"]
var output_directory := ""
var samples: Array[Dictionary] = []
var capture_errors := 0

func _init() -> void:
	call_deferred("run")

func run() -> void:
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
	game.set_application_foreground(false)
	game.apply_real_time_visual_context_for_tests(12, 4)
	game._apply_drift_motion(0.0)
	game._show_seasonal_island_layer(load("res://assets/images/runtime/voyage/seasonal_parallax/bright-spring-islet.png"), 1.0)
	game._apply_seasonal_island_progress(0.5)
	var normal := game.get_node("VoyageWorld/" + CAMERAS[0] + "/SeasonalIslandLayer") as Sprite3D
	var appreciation := game.get_node("VoyageWorld/" + CAMERAS[1] + "/SeasonalIslandLayer") as Sprite3D
	var separation := normal.global_position.distance_to(appreciation.global_position)
	var original_world := normal.global_transform
	await sample(game, "baseline-normal", normal.global_position)
	game._toggle_appreciation_mode()
	await sample(game, "baseline-appreciation", appreciation.global_position)
	game._toggle_appreciation_mode()
	# 실행 중 복제만 비교하며 production Scene/asset은 변경하지 않는다.
	var trial := normal.duplicate() as Sprite3D
	trial.name = "WorldSpaceIslandProbe"
	game.get_node("VoyageWorld").add_child(trial)
	trial.global_transform = original_world
	normal.hide()
	appreciation.hide()
	await sample(game, "trial-normal", trial.global_position)
	game._toggle_appreciation_mode()
	await sample(game, "trial-appreciation", trial.global_position)
	game._toggle_appreciation_mode()
	game.set_look_around_mode(true)
	await sample(game, "trial-look-around", trial.global_position)
	var report := {
		"role": "DIAGNOSTIC_ONLY_NOT_PRODUCTION_IMPLEMENTATION",
		"camera_local_island_world_separation": separation,
		"look_around_has_production_island": game.has_node("VoyageWorld/" + CAMERAS[2] + "/SeasonalIslandLayer"),
		"world_trial_position_unchanged": trial.global_transform.is_equal_approx(original_world),
		"samples": samples,
		"motion_time_evidence": "NOT_RUN_STATIC_PROJECTION_PROBE",
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
	for path in paths:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	quit(0 if file != null and capture_errors == 0 else 2)

func sample(_game: Node, label: String, world_position: Vector3) -> void:
	await process_frame
	var camera := root.get_camera_3d()
	var screen := camera.unproject_position(world_position)
	samples.append({"label": label, "camera": str(camera.get_path()), "world": [world_position.x, world_position.y, world_position.z], "screen": [screen.x, screen.y], "behind": camera.is_position_behind(world_position)})
	if DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		var error := root.get_texture().get_image().save_png(output_directory.path_join(label + ".png"))
		if error != OK:
			capture_errors += 1
			printerr("Screenshot save failed: " + label)
