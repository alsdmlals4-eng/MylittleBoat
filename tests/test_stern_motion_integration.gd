# 승인된 분리 외형의 실제 연결과 카메라·탑승자 연동, 정지를 검사한다.
extends SceneTree

var failures := 0

func _init() -> void:
	call_deferred("run_checks")

func expect(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		printerr("FAIL: " + message)

func run_checks() -> void:
	var state := root.get_node("GameState")
	var paths: Array[String] = []
	for kind in ["comfort", "together_time", "memory_ledger", "identity", "boat_decor"]:
		var path := "user://test_stern_motion_%s.cfg" % kind
		paths.append(path)
		preload("res://tests/helpers/config_store_test_cleanup.gd").remove_store(path)
		state.call("set_%s_storage_path" % kind, path)
	state.reset_session()
	state.set_selected_player_style("c_loose_knit")
	state.set_selected_pet_type("dog")
	state.set_motion_comfort_profile("standard")
	var game := load("res://scenes/game.tscn").instantiate() as Control
	root.add_child(game)
	await process_frame
	game.set_process(false)
	game.set_application_foreground(true)
	var card := game.get_node("VoyageWorld/BoatSpace/FinalDioramaCard") as Sprite3D
	expect(card.texture is ViewportTexture, "approved parts must replace the old flattened default image")
	var player := card.get_node_or_null("PartsViewport/Player") as Sprite2D
	var pet := card.get_node_or_null("PartsViewport/Pet") as Sprite2D
	expect(player != null and pet != null, "player and pet must have independent motion consumers")
	var view := card.get_node_or_null("PartsViewport") as SubViewport
	expect(view != null and view.render_target_update_mode != SubViewport.UPDATE_ALWAYS, "hidden assembly must not render continuously")
	if card.texture is ViewportTexture and DisplayServer.get_name() != "headless":
		await RenderingServer.frame_post_draw
		var assembled := card.texture.get_image()
		var pink_pixels := 0
		var opaque_pixels := 0
		for y in assembled.get_height():
			for x in assembled.get_width():
				var color := assembled.get_pixel(x, y)
				opaque_pixels += int(color.a > 0.5)
				if color.a > 0.5 and minf(color.r - color.g, color.b - color.g) > 0.15:
					pink_pixels += 1
		expect(pink_pixels == 0, "composited parts must not retain opaque magenta key fringe: %d" % pink_pixels)
		expect(opaque_pixels > 10000, "visible assembly must produce foreground pixels, not an empty viewport")
		for shader_path in ["res://assets/shaders/stern_parts_despill.gdshader", "res://assets/shaders/stern_cushion_surface.gdshader"]:
			await check_neutral_color(shader_path)
	var camera := game.get_node("VoyageWorld/DioramaCameraRig") as Node3D
	# GPU await 중 OS focus가 바뀔 수 있으므로 수동 모션 표본의 활성 조건을 다시 지정한다.
	game.set_application_foreground(true)
	var initial_camera := camera.position
	game._apply_drift_motion(1.0)
	expect(absf(camera.position.z - initial_camera.z) < 0.001, "title must not start forward travel")
	game.start_voyage_from_title()
	var before_camera := camera.position
	var player_rotation := player.rotation if player != null else 0.0
	for step in 120:
		game._apply_drift_motion(1.0 / 60.0)
	expect(absf(camera.position.z - before_camera.z) > 0.1, "camera must follow voyage travel, not only bob vertically")
	if player != null and pet != null:
		expect(absf(player.rotation - player_rotation) > 0.0001, "occupant must respond independently to hull motion")
		expect(player.position.x < pet.position.x, "pet must remain beside the player")
	state.set_motion_comfort_profile("still")
	game._apply_drift_motion(0.0)
	var frozen_camera := camera.position
	var frozen_player := player.transform if player != null else Transform2D.IDENTITY
	game._apply_drift_motion(2.0)
	expect(camera.position.is_equal_approx(frozen_camera), "still must freeze camera travel")
	if player != null:
		expect(player.transform.is_equal_approx(frozen_player), "still must freeze secondary motion")
	state.set_motion_comfort_profile("standard")
	game._apply_drift_motion(0.0)
	frozen_camera = camera.position
	game.set_application_foreground(false)
	game._apply_drift_motion(2.0)
	expect(camera.position.is_equal_approx(frozen_camera), "inactive must freeze travel")
	game.set_application_foreground(true)
	game.set("_voyage_visual_distance", 10000.0)
	game._apply_drift_motion(0.01)
	expect(absf(camera.position.z) < 520.0, "long resting sessions must keep shared world coordinates bounded")
	game._open_decor_panel()
	await process_frame
	var preview := game.get_node("DecorPanel/DecorVBox/DecorPreview/DecorPreviewViewport") as SubViewport
	var preview_camera := preview.get_node("PreviewWorld/PreviewCameraRig/PreviewCamera3D") as Camera3D
	var preview_card := preview.get_node("PreviewWorld/BoatSpace/FinalDioramaCard") as Sprite3D
	var center := preview_camera.unproject_position(preview_card.global_position)
	expect(center.distance_to(Vector2(preview.size) * 0.5) < 4.0, "decor preview must center the new assembled boat")
	state.set_selected_pet_type("rabbit")
	game._apply_identity_visuals()
	game._apply_camera_mode()
	expect(not card.visible, "camera refresh must not show the default dog boat over another selected pet")
	expect(is_equal_approx(preview_camera.fov, 48.0) and preview_camera.rotation.is_equal_approx(Vector3.ZERO), "alternate identity must restore the original preview camera")
	state.set_selected_pet_type("dog")
	game._apply_identity_visuals()
	game._apply_camera_mode()
	expect(card.visible and is_equal_approx(preview_camera.fov, 24.0), "return to dog must restore the new preview")
	game._close_decor_panel()
	game.queue_free()
	await process_frame
	var soundscape := root.get_node_or_null("RestingSoundscape")
	if soundscape != null and soundscape.has_method("release_ocean_bed_for_shutdown"):
		soundscape.release_ocean_bed_for_shutdown()
	for _frame in 4:
		await process_frame
	for path in paths:
		preload("res://tests/helpers/config_store_test_cleanup.gd").remove_store(path)
	print("STERN_MOTION_FAILURES=%d" % failures)
	quit(1 if failures else 0)

func check_neutral_color(shader_path: String) -> void:
	# 중성색 진단 fixture이며 게임 그림을 생성하는 코드가 아니다.
	var fixture := Image.create(16, 16, false, Image.FORMAT_RGBA8)
	fixture.fill(Color(0.6, 0.6, 0.6, 1.0))
	var view := SubViewport.new()
	view.size = Vector2i(16, 16)
	view.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(view)
	var sprite := Sprite2D.new()
	sprite.centered = false
	sprite.texture = ImageTexture.create_from_image(fixture)
	var material := ShaderMaterial.new()
	material.shader = load(shader_path)
	sprite.material = material
	view.add_child(sprite)
	await process_frame
	await RenderingServer.frame_post_draw
	var actual := view.get_texture().get_image().get_pixel(8, 8)
	expect(absf(actual.r - 0.6) < 0.03, "technical shader must preserve non-key source brightness: %s %s" % [shader_path, actual])
	view.queue_free()
	await process_frame
