# 실제 항해 경로가 장거리 경계와 정지에서 보트·카메라·접점을 연속 유지하는지 검사한다.
extends SceneTree

var failures := 0
var paths: Array[String] = []

func _init() -> void:
	call_deferred("run")

func expect(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		printerr("FAIL: " + message)

func run() -> void:
	var state := root.get_node("GameState")
	for kind in ["comfort", "together_time", "memory_ledger", "identity", "boat_decor", "ambient_memory"]:
		var path := "user://test_route_%s.cfg" % kind
		paths.append(path)
		state.call("set_%s_storage_path" % kind, path)
	state.reset_session()
	state.set_motion_comfort_profile("standard")
	state.speed_index = 1
	var game := load("res://scenes/game.tscn").instantiate() as Control
	root.add_child(game)
	await process_frame
	game.set_process(false)
	game.set_application_foreground(true)
	var camera := game.get_node("VoyageWorld/DioramaCameraRig") as Node3D
	var start := camera.position
	game._apply_drift_motion(10.0)
	expect(is_equal_approx(camera.position.z, start.z), "title must not travel")
	game.start_voyage_from_title()
	state.speed_index = 1
	var remaining: float = state.remaining_seconds
	game._apply_drift_motion(1599.0)
	var before := camera.position.z
	game._apply_drift_motion(2.0)
	print("ROUTE_SAMPLE before=%f after=%f start=%f comfort=%f" % [before, camera.position.z, start.z, state.get_motion_comfort_scale()])
	expect(absf(camera.position.z - before - 0.64) < 0.001, "512-unit boundary must not teleport boat and camera backwards")
	expect(absf(camera.position.z - start.z - 512.32) < 0.001, "travel distance must survive multiple route segments")
	var route := game.get_node_or_null("VoyageWorld/VoyageRoute") as Path3D
	expect(route != null, "production game must consume a real Path3D route")
	if route != null:
		expect(absf(route.get_node("BoatProgress").global_position.z - 512.32) < 0.001, "path follower must own reached world position")
	var boat := game.get_node("VoyageWorld/BoatSpace") as Node3D
	var contact := game.get_node("VoyageWorld/BoatWaterContact") as Node3D
	expect(absf(boat.position.z - contact.position.z + 0.35) < 0.001, "water contact must share route translation")
	state.set_motion_comfort_profile("still")
	game._apply_drift_motion(0.0)
	var frozen := camera.position
	game._apply_drift_motion(120.0)
	expect(camera.position.is_equal_approx(frozen), "still comfort must retain reached route position")
	state.set_motion_comfort_profile("standard")
	game.set_application_foreground(false)
	game._apply_drift_motion(120.0)
	expect(is_equal_approx(camera.position.z, frozen.z), "background must not advance route")
	expect(is_equal_approx(state.remaining_seconds, remaining), "visual route must not advance rewards or voyage duration")
	game.queue_free()
	await process_frame
	# 구간 경계의 작은 프레임 이동과 잘못된 입력을 실제 route consumer로 검사한다.
	var route_script := load("res://scripts/voyage/voyage_route.gd")
	if route_script != null:
		var boundary_route := Path3D.new()
		boundary_route.set_script(route_script)
		var follower := PathFollow3D.new()
		follower.name = "BoatProgress"
		boundary_route.add_child(follower)
		root.add_child(boundary_route)
		boundary_route.advance_distance(127.9)
		for index in range(1, 21):
			boundary_route.advance_distance(0.01)
			expect(absf(follower.global_position.z - (127.9 + index * 0.01)) < 0.001, "small frames must cross 128 without position discontinuity")
		var reached := follower.global_position
		for invalid_distance in [-1.0, NAN, INF, 0.0]:
			boundary_route.advance_distance(invalid_distance)
			expect(follower.global_position.is_equal_approx(reached), "invalid distance must preserve reached route")
		boundary_route.queue_free()
		await process_frame
	root.get_node("RestingSoundscape").release_ocean_bed_for_shutdown()
	for path in paths:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	print("ROUTE_CONTINUITY_FAILURES=%d" % failures)
	quit(1 if failures else 0)
