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
	var normal_heading := Vector2(camera.global_basis.z.x, camera.global_basis.z.z).normalized()
	for rig_name in ["LookAroundCameraRig", "AppreciationCameraRig"]:
		var other := game.get_node("VoyageWorld/" + rig_name) as Node3D
		var heading := Vector2(other.global_basis.z.x, other.global_basis.z.z).normalized()
		expect(normal_heading.dot(heading) > 0.999, "neutral cameras must share voyage heading: " + rig_name)
		var sea := other.get_child(0).get_node("SeaBackdrop") as Sprite3D
		game._apply_background_flow_to_backdrop(sea)
		var direction: Vector2 = sea.material_override.get_shader_parameter("travel_direction")
		expect(direction.distance_to(Vector2(-0.463191, 0.886258)) < 0.001, "neutral 3/4 camera must include the actual route's lateral component: " + rig_name)
		if rig_name == "LookAroundCameraRig":
			expect(camera.global_basis.z.dot(other.global_basis.z) > 0.999, "neutral look-around must retain normal framing before user drag")
			other.set_view_angles(76.0, 0.0)
			expect(other.get_angle_id() == "port", "world heading offset must not change relative port classification")
			game._apply_background_flow_to_backdrop(sea)
			direction = sea.material_override.get_shader_parameter("travel_direction")
			expect(direction.distance_to(Vector2(-0.971989, -0.235027)) < 0.001, "port water must follow the world route even after crossing its side-on direction")
			other.set_view_angles(0.0, 0.0)
			expect(camera.global_basis.z.dot(other.global_basis.z) > 0.999, "neutral reset must restore the original world reference")
		else:
			other.get_child(0).current = true
			var drag := InputEventScreenDrag.new()
			drag.relative = Vector2(750.0, 0.0)
			other._unhandled_input(drag)
			game._apply_background_flow_to_backdrop(sea)
			direction = sea.material_override.get_shader_parameter("travel_direction")
			expect(direction.distance_to(Vector2(0.886258, 0.463191)) < 0.001, "appreciation water must include reference heading and user rotation")
			drag.relative = -drag.relative
			other._unhandled_input(drag)
	camera.get_child(0).current = true
	_verify_world_water_directions(game)
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

func _verify_world_water_directions(game: Control) -> void:
	var rig := game.get_node("VoyageWorld/DioramaCameraRig") as Node3D
	var sea := rig.get_node("DioramaCamera3D/SeaBackdrop") as Sprite3D
	var original := rig.rotation
	# Literal cardinal fixtures catch a sign reversal and accidental use of input-relative angles.
	for fixture in [[-180.0, Vector2(0, 1)], [-90.0, Vector2(-1, 0)], [0.0, Vector2(0, -1)], [90.0, Vector2(1, 0)]]:
		for pitch in [-45.0, -9.0, 8.0]:
			rig.rotation_degrees = Vector3(pitch, fixture[0], 0)
			game._apply_background_flow_to_backdrop(sea)
			var direction: Vector2 = sea.material_override.get_shader_parameter("travel_direction")
			expect(direction.distance_to(fixture[1]) < 0.001, "diorama cardinal heading must remain independent of pitch: %s/%s" % [fixture[0], pitch])
	rig.rotation = original
	# Rotating the common world must not change camera-relative passage.
	var world := game.get_node("VoyageWorld") as Node3D
	var world_rotation := world.rotation
	world.rotation.y = 0.7
	game._apply_background_flow_to_backdrop(sea)
	var rotated: Vector2 = sea.material_override.get_shader_parameter("travel_direction")
	expect(rotated.distance_to(Vector2(-0.463191, 0.886258)) < 0.001, "route and camera must use the same global coordinate frame")
	world.rotation = world_rotation
	game._apply_background_flow()
