# 치비 정상 원화의 기술 매트가 독립 3D 재질에서 투명 전경으로 보이는지 검증한다.
extends SceneTree

const CHROMA_MATTE_TEXTURE_PATH := "res://assets/images/runtime/voyage/normal_chibi/chibi-normal-rear-chroma-key.png"
const CHROMA_SHADER_PATH := "res://shaders/chibi_normal_chroma_key.gdshader"
const MACHINE_EVIDENCE_DIRECTORY := "user://machine-test-evidence/chibi-normal-material-proof"
const EVIDENCE_FILE_NAME := "chibi_normal_chroma_material_proof_540x960.png"
const BACKGROUND_COLOR := Color(0.035, 0.075, 0.16, 1.0)

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(540, 960)
	var matte_texture := load(CHROMA_MATTE_TEXTURE_PATH) as Texture2D
	var chroma_shader := load(CHROMA_SHADER_PATH) as Shader
	_expect(matte_texture != null, "material proof requires the imported chibi chroma matte texture")
	_expect(chroma_shader != null, "material proof requires a custom chroma-key shader")
	if matte_texture == null or chroma_shader == null:
		_finish()
		return

	var proof_world := Node3D.new()
	root.add_child(proof_world)
	_add_blue_world_environment(proof_world)
	_add_current_camera(proof_world)
	_add_chibi_foreground(proof_world, matte_texture, chroma_shader)
	await _wait_for_frames(12)
	RenderingServer.force_draw(true)
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	_expect(image != null and not image.is_empty(), "material proof must render a readable GPU image")
	if image != null and not image.is_empty():
		_expect(_save_evidence(image), "material proof must save its runtime evidence image")
		_expect(_count_vivid_green_pixels(image) == 0, "green technical matte must not remain visible in the rendered foreground")
		_expect(_count_warm_foreground_pixels(image) > 450, "rendered foreground must retain the warm boat and character colors")
	proof_world.queue_free()
	await process_frame
	await _release_runtime_soundscape_for_test_shutdown()
	_finish()


func _add_blue_world_environment(proof_world: Node3D) -> void:
	var environment := Environment.new()
	environment.background_mode = Environment.BG_COLOR
	environment.background_color = BACKGROUND_COLOR
	environment.ambient_light_source = Environment.AMBIENT_SOURCE_COLOR
	environment.ambient_light_color = Color.WHITE
	environment.ambient_light_energy = 1.0
	var world_environment := WorldEnvironment.new()
	world_environment.environment = environment
	proof_world.add_child(world_environment)


func _add_current_camera(proof_world: Node3D) -> void:
	var camera := Camera3D.new()
	camera.position = Vector3(0.0, 0.0, 6.0)
	camera.current = true
	proof_world.add_child(camera)


func _add_chibi_foreground(proof_world: Node3D, matte_texture: Texture2D, chroma_shader: Shader) -> void:
	var material := ShaderMaterial.new()
	material.shader = chroma_shader
	material.set_shader_parameter("matte_texture", matte_texture)
	var foreground := Sprite3D.new()
	foreground.name = "ChibiNormalChromaProofForeground"
	foreground.texture = matte_texture
	foreground.pixel_size = 0.004
	foreground.billboard = BaseMaterial3D.BILLBOARD_ENABLED
	foreground.no_depth_test = true
	foreground.material_override = material
	proof_world.add_child(foreground)


func _count_vivid_green_pixels(image: Image) -> int:
	var count := 0
	for y in range(0, image.get_height(), 2):
		for x in range(0, image.get_width(), 2):
			var pixel := image.get_pixel(x, y)
			if pixel.g > 0.55 and pixel.g > pixel.r + 0.22 and pixel.g > pixel.b + 0.22:
				count += 1
	return count


func _count_warm_foreground_pixels(image: Image) -> int:
	var count := 0
	for y in range(0, image.get_height(), 2):
		for x in range(0, image.get_width(), 2):
			var pixel := image.get_pixel(x, y)
			if pixel.r > 0.55 and pixel.r > pixel.b + 0.14 and pixel.g > 0.32:
				count += 1
	return count


func _save_evidence(image: Image) -> bool:
	var absolute_directory := ProjectSettings.globalize_path(MACHINE_EVIDENCE_DIRECTORY)
	var directory_result := DirAccess.make_dir_recursive_absolute(absolute_directory)
	if directory_result != OK:
		printerr("material proof evidence directory error: %s" % error_string(directory_result))
		return false
	var output_path := absolute_directory.path_join(EVIDENCE_FILE_NAME)
	var save_result := image.save_png(output_path)
	if save_result != OK:
		printerr("material proof evidence save error for %s: %s" % [output_path, error_string(save_result)])
	return save_result == OK


func _release_runtime_soundscape_for_test_shutdown() -> void:
	var soundscape := root.get_node_or_null("RestingSoundscape")
	if soundscape != null and soundscape.has_method("release_ocean_bed_for_shutdown"):
		soundscape.call("release_ocean_bed_for_shutdown")
	await _wait_for_frames(4)


func _wait_for_frames(frame_count: int) -> void:
	for _frame in frame_count:
		await process_frame


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: chibi normal chroma material proof")
		quit(0)
	else:
		printerr("FAILED: %d chibi normal chroma material proof assertions" % _failures)
		quit(1)
