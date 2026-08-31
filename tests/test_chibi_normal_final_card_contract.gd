# 기본 보트 카드가 승인된 치비 전경 재질을 실제로 소비하는지 검증한다.
extends SceneTree

const BOAT_SPACE_SCENE_PATH := "res://scenes/boat_space.tscn"
const CHROMA_MATTE_TEXTURE_PATH := "res://assets/images/runtime/voyage/normal_chibi/chibi-normal-rear-chroma-key.png"
const CHROMA_SHADER_PATH := "res://shaders/chibi_normal_chroma_key.gdshader"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed_scene := load(BOAT_SPACE_SCENE_PATH) as PackedScene
	_expect(packed_scene != null, "boat space scene must load")
	if packed_scene == null:
		_finish()
		return
	var boat_space := packed_scene.instantiate()
	root.add_child(boat_space)
	await process_frame
	var final_card := boat_space.get_node_or_null("FinalDioramaCard") as Sprite3D
	_expect(final_card != null, "boat space must expose the normal final diorama card")
	if final_card != null:
		_expect(final_card.texture != null and final_card.texture.resource_path == CHROMA_MATTE_TEXTURE_PATH, "normal final diorama card must use the approved chibi chroma foreground")
		var material := final_card.material_override as ShaderMaterial
		_expect(material != null, "normal final diorama card must use the chibi chroma material")
		if material != null:
			_expect(material.shader != null and material.shader.resource_path == CHROMA_SHADER_PATH, "normal final diorama material must use the chibi chroma shader")
			var bound_texture := material.get_shader_parameter("matte_texture") as Texture2D
			_expect(bound_texture != null and bound_texture.resource_path == CHROMA_MATTE_TEXTURE_PATH, "normal final diorama material must bind the chibi matte texture explicitly")
	boat_space.queue_free()
	await process_frame
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: chibi normal final card contract")
		quit(0)
	else:
		printerr("FAILED: %d chibi normal final card assertions" % _failures)
		quit(1)
