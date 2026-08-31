# 승인된 후면 3/4 기본 항해 전경과 시점이 실제 소비되는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const BOAT_SPACE_SCENE_PATH := "res://scenes/boat_space.tscn"
const REAR_APPROVED_SOURCE_PATH := "res://docs/visual/approved/2026-08-30-chibi-normal-rear/chibi-normal-rear-3-4-approved-source.png"
const REAR_CHROMA_MATTE_PATH := "res://assets/images/runtime/voyage/normal_chibi/chibi-normal-rear-chroma-key.png"
const REAR_CARD_PIXEL_SIZE := 0.0037

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(ResourceLoader.exists(REAR_APPROVED_SOURCE_PATH), "approved rear three-quarter source must be preserved in the repository")
	_expect(ResourceLoader.exists(REAR_CHROMA_MATTE_PATH), "rear three-quarter chroma matte must be runtime-loadable")

	var boat_space_scene := load(BOAT_SPACE_SCENE_PATH) as PackedScene
	_expect(boat_space_scene != null, "boat space scene must load")
	if boat_space_scene != null:
		var boat_space := boat_space_scene.instantiate()
		root.add_child(boat_space)
		await process_frame
		var final_card := boat_space.get_node_or_null("FinalDioramaCard") as Sprite3D
		_expect(final_card != null and final_card.texture != null and final_card.texture.resource_path == REAR_CHROMA_MATTE_PATH, "normal final card must consume the approved rear three-quarter matte")
		_expect(final_card != null and is_equal_approx(final_card.pixel_size, REAR_CARD_PIXEL_SIZE), "rear card must compensate for its quieter source framing with a readable normal-play size")
		var material := final_card.material_override as ShaderMaterial if final_card != null else null
		_expect(material != null and material.get_shader_parameter("matte_texture") != null and (material.get_shader_parameter("matte_texture") as Texture2D).resource_path == REAR_CHROMA_MATTE_PATH, "normal material must bind the rear matte explicitly")
		boat_space.queue_free()
		await process_frame

	var game_scene := load(GAME_SCENE_PATH) as PackedScene
	_expect(game_scene != null, "game scene must load")
	if game_scene != null:
		var scene := game_scene.instantiate()
		root.add_child(scene)
		await process_frame
		var diorama_rig := scene.get_node_or_null("VoyageWorld/DioramaCameraRig") as Node3D
		var look_around_rig := scene.get_node_or_null("VoyageWorld/LookAroundCameraRig") as Node3D
		_expect(diorama_rig != null and diorama_rig.position.z < 0.0, "normal diorama camera must look from the stern side")
		_expect(diorama_rig != null and diorama_rig.rotation.y < -2.0, "normal diorama camera must face the boat from its rear three-quarter angle")
		_expect(look_around_rig != null and look_around_rig.position.z > 0.0, "Look Around default rig must stay independent from the new normal rear camera")
		scene.queue_free()
		await process_frame
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: rear normal voyage contract")
		quit(0)
	else:
		printerr("FAILED: %d rear normal voyage assertions" % _failures)
		quit(1)
