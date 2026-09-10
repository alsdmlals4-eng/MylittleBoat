# 이미지 모델의 녹색 기술 배경 후보를 기존 셰이더로 격리 렌더하고 alpha를 검증한다.
extends SceneTree

func _init() -> void:
	call_deferred("_render")

func _render() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 3 or DisplayServer.get_name() == "headless":
		printerr("Use display renderer in isolated project: -- input.png output.png shader.gdshader")
		quit(2)
		return
	if FileAccess.file_exists(args[1]):
		printerr("Refusing to overwrite output")
		quit(2)
		return
	var source := Image.load_from_file(args[0])
	if source == null or source.is_empty() or source.get_width() > 4096 or source.get_height() > 4096:
		quit(2)
		return
	var shader := Shader.new()
	shader.code = FileAccess.get_file_as_string(args[2])
	var texture := ImageTexture.create_from_image(source)
	var material := ShaderMaterial.new()
	material.shader = shader
	material.set_shader_parameter("matte_texture", texture)
	var viewport := SubViewport.new()
	viewport.size = source.get_size()
	viewport.transparent_bg = true
	viewport.own_world_3d = true
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	var sprite := Sprite3D.new()
	sprite.texture = texture
	sprite.pixel_size = 0.001
	sprite.material_override = material
	viewport.add_child(sprite)
	var camera := Camera3D.new()
	camera.projection = Camera3D.PROJECTION_ORTHOGONAL
	camera.size = source.get_height() * sprite.pixel_size
	camera.position.z = 2.0
	viewport.add_child(camera)
	camera.make_current()
	for _index in 4:
		await process_frame
		await RenderingServer.frame_post_draw
	var rendered := viewport.get_texture().get_image()
	var transparent := 0
	var opaque := 0
	for y in rendered.get_height():
		for x in rendered.get_width():
			var alpha := rendered.get_pixel(x, y).a
			transparent += int(alpha == 0.0)
			opaque += int(alpha > 0.99)
	var valid := rendered.get_size() == source.get_size() and transparent > 100 and opaque > 100
	for point in [Vector2i.ZERO, Vector2i(source.get_width()-1, 0), Vector2i(0, source.get_height()-1), source.get_size()-Vector2i.ONE]:
		valid = valid and rendered.get_pixelv(point).a == 0.0
	var error := rendered.save_png(args[1]) if valid else ERR_INVALID_DATA
	print("MATTE_RENDER size=%s transparent=%d opaque=%d result=%d" % [rendered.get_size(), transparent, opaque, error])
	viewport.queue_free()
	await process_frame
	quit(0 if error == OK else 1)
