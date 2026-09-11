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
		_expect(final_card.texture is ViewportTexture, "normal final diorama card must use the newly approved layered foreground")
		_expect(final_card.material_override == null, "RGBA viewport output must not use the legacy chroma material")
		_expect(final_card.get_node_or_null("PartsViewport/SternRail") != null, "new composition must keep the stern rail in front of the occupants")
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
