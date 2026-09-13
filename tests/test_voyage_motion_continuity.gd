# 실제 수면 shader의 전진 방향·반복 연속성과 게임의 정지 계약을 검사한다.
extends SceneTree

var failures := 0
var storage_paths: Array[String] = []

func _init() -> void:
	call_deferred("run_checks")

func expect(value: bool, message: String) -> void:
	if not value:
		failures += 1
		printerr("FAIL: " + message)

func run_checks() -> void:
	var state := root.get_node("GameState")
	for kind in ["comfort", "together_time", "memory_ledger"]:
		var path := "user://test_motion_continuity_%s.cfg" % kind
		storage_paths.append(path)
		state.call("set_%s_storage_path" % kind, path)
	state.reset_session()
	state.set_motion_comfort_profile("standard")
	var game := load("res://scenes/game.tscn").instantiate() as Control
	root.add_child(game)
	await process_frame
	game.set_process(false)
	game.start_voyage_from_title()
	game.set_application_foreground(true)
	game._apply_drift_motion(1.0)
	var before: float = game.get_background_flow_offset()
	state.set_motion_comfort_profile("still")
	game._apply_drift_motion(1.0)
	expect(is_equal_approx(before, game.get_background_flow_offset()), "still must stop ambient water, not just the boat")
	state.set_motion_comfort_profile("standard")
	game.set_application_foreground(false)
	before = game.get_forward_water_flow_offset()
	var remaining: float = state.remaining_seconds
	game._process(1.0)
	expect(is_equal_approx(remaining, state.remaining_seconds), "inactive voyage clock must not outrun frozen presentation")
	game._apply_drift_motion(1.0)
	expect(is_equal_approx(before, game.get_forward_water_flow_offset()), "backgrounded presentation must not advance")
	game.set_application_foreground(true)
	var camera := game.get_node("VoyageWorld/LookAroundCameraRig")
	var sea := camera.get_node("LookAroundCamera3D/SeaBackdrop") as Sprite3D
	camera.set_view_angles(90.0, 0.0)
	game._apply_drift_motion(0.0)
	var right = sea.material_override.get_shader_parameter("travel_direction")
	camera.set_view_angles(-90.0, 0.0)
	game._apply_drift_motion(0.0)
	var left = sea.material_override.get_shader_parameter("travel_direction")
	expect(right is Vector2 and left is Vector2, "water requires a view-relative travel vector")
	if right is Vector2 and left is Vector2:
		expect(right.distance_to(-left) < 0.001, "opposite world views must reverse the entire water vector")
		expect(right.distance_to(Vector2(-0.886258, -0.463191)) < 0.001, "side water must retain world heading, not assume the default 3/4 camera points straight ahead")
	game.queue_free()
	await process_frame
	# autoload 소리는 Scene 교체 때 유지하되 테스트 종료 전에는 먼저 해제한다.
	root.get_node("RestingSoundscape").release_ocean_bed_for_shutdown()
	for _frame in 4:
		await process_frame
	if DisplayServer.get_name() != "headless":
		await check_shader()
	else:
		print("SKIP: GPU shader assertions require display renderer")
	for path in storage_paths:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	print("MOTION_CONTINUITY_FAILURES=%d" % failures)
	quit(1 if failures else 0)

func check_shader() -> void:
	# Coordinate ramp is a diagnostic fixture, never a game art asset.
	var ramp := Image.create(256, 256, false, Image.FORMAT_RGBA8)
	for y in 256:
		for x in 256:
			ramp.set_pixel(x, y, Color(float(x) / 255.0, float(y) / 255.0, 0.0, 1.0))
	var view := SubViewport.new()
	view.size = Vector2i(256, 256)
	view.own_world_3d = true
	view.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(view)
	var camera := Camera3D.new()
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.size = 2.0
	camera.position.z = 2.0
	view.add_child(camera)
	var sprite := Sprite3D.new()
	sprite.texture = ImageTexture.create_from_image(ramp)
	sprite.pixel_size = 2.0 / 256.0
	var mat := ShaderMaterial.new()
	mat.shader = load("res://assets/shaders/voyage_split_sea_flow.gdshader")
	mat.set_shader_parameter("source_texture", sprite.texture)
	sprite.material_override = mat
	view.add_child(sprite)
	var a := await sample(view, mat, 0.9999)
	var b := await sample(view, mat, 0.0001)
	var wrap_error := absf(a.g - b.g) + absf(a.r - b.r)
	expect(wrap_error < 0.01, "flow cycle must not jump at 1 -> 0; error=%f" % wrap_error)
	print("SHADER_WRAP_ERROR=%f" % wrap_error)
	# The half-cycle boundary must be equally seamless.
	a = await sample(view, mat, 0.4999)
	b = await sample(view, mat, 0.5001)
	expect(absf(a.g - b.g) + absf(a.r - b.r) < 0.01, "second flow layer must reset invisibly")
	view.queue_free()
	await process_frame

func sample(view: SubViewport, mat: ShaderMaterial, phase: float) -> Color:
	mat.set_shader_parameter("forward_flow_offset", phase)
	await process_frame
	await RenderingServer.frame_post_draw
	return view.get_texture().get_image().get_pixel(80, 230)
