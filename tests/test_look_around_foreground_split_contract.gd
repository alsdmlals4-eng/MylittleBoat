# 네 방향 둘러보기가 분리 foreground와 흐르는 바다를 함께 쓰는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const FOREGROUND_KEY_SHADER_PATH := "res://assets/shaders/look_around_foreground_chroma_key.gdshader"
const FOREGROUND_PATHS := {
	"port": "res://assets/images/runtime/voyage/look_around/foreground_split/port-foreground.png",
	"starboard": "res://assets/images/runtime/voyage/look_around/foreground_split/starboard-foreground.png",
	"aft": "res://assets/images/runtime/voyage/look_around/foreground_split/aft-foreground.png",
	"overhead": "res://assets/images/runtime/voyage/look_around/foreground_split/overhead-foreground.png",
}
const VIEW_ANGLES := {
	"port": Vector2(76.0, 0.0),
	"starboard": Vector2(-76.0, 0.0),
	"aft": Vector2(120.0, 0.0),
	"overhead": Vector2(0.0, 32.0),
}

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(ResourceLoader.exists(FOREGROUND_KEY_SHADER_PATH), "Look Around foreground chroma-key shader must exist")
	var shader_source := FileAccess.get_file_as_string(FOREGROUND_KEY_SHADER_PATH)
	_expect(shader_source.contains("depth_prepass_alpha"), "foreground shader must use the Godot 4 transparent depth-prepass render mode")
	_expect(not shader_source.contains("depth_draw_alpha_prepass"), "foreground shader must not use the invalid legacy depth render-mode spelling")
	_expect(shader_source.contains("ALPHA"), "foreground shader must output alpha for the technical matte")
	for foreground_path in FOREGROUND_PATHS.values():
		_expect(ResourceLoader.exists(str(foreground_path)), "locked Look Around foreground asset must exist: %s" % foreground_path)
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	_expect(packed_scene != null, "game.tscn must load")
	if packed_scene == null:
		_finish()
		return

	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame
	var controller := scene.get_node_or_null("VoyageWorld/LookAroundCameraRig")
	var sky := scene.get_node_or_null("VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/SkyBackdrop") as Sprite3D
	var sea := scene.get_node_or_null("VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/SeaBackdrop") as Sprite3D
	var foreground := scene.get_node_or_null("VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/LookAroundForeground") as Sprite3D
	var normal_card := scene.get_node_or_null("VoyageWorld/BoatSpace/FinalDioramaCard") as Sprite3D
	_expect(controller != null, "Look Around controller must exist")
	_expect(sky != null, "Look Around must retain the static sky layer")
	_expect(sea != null and sea.material_override is ShaderMaterial, "Look Around must retain the flowing sea shader layer")
	_expect(foreground != null and foreground.material_override is ShaderMaterial, "Look Around must provide a chroma-keyed foreground Sprite3D above the sea")
	_expect(scene.has_method("set_look_around_mode"), "game scene must expose Look Around mode routing")
	if controller != null and foreground != null and scene.has_method("set_look_around_mode"):
		scene.call("set_look_around_mode", true)
		for angle_id in FOREGROUND_PATHS.keys():
			var angles: Vector2 = VIEW_ANGLES[angle_id] as Vector2
			controller.call("set_view_angles", angles.x, angles.y)
			await process_frame
			_expect(str(scene.call("get_look_around_display_angle_id")) == angle_id, "Look Around must keep the %s display angle" % angle_id)
			_expect(foreground.visible, "%s foreground must be visible" % angle_id)
			_expect(foreground.texture != null and foreground.texture.resource_path == str(FOREGROUND_PATHS[angle_id]), "%s must use its exact locked foreground asset" % angle_id)
			var foreground_material := foreground.material_override as ShaderMaterial
			_expect(foreground_material != null and foreground_material.get_shader_parameter("source_texture") == foreground.texture, "%s chroma-key shader must receive the same foreground texture" % angle_id)
			_expect(sky != null and sky.visible, "%s must keep static sky visible behind the foreground" % angle_id)
			_expect(sea != null and sea.visible and sea.material_override is ShaderMaterial, "%s must keep flowing sea visible behind the foreground" % angle_id)
			_expect(normal_card != null and not normal_card.visible, "%s must hide the duplicated normal diorama card" % angle_id)

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
		print("PASS: Look Around foreground split contract")
		quit(0)
	else:
		printerr("FAILED: %d Look Around foreground split assertions" % _failures)
		quit(1)
