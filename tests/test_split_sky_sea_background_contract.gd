# 하늘과 바다를 분리한 항해 배경이 시간대와 카메라에 일관되게 적용되는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const SEA_FLOW_SHADER_PATH := "res://assets/shaders/voyage_split_sea_flow.gdshader"
const SKY_TEXTURE_PATHS := {
	"dawn": "res://assets/images/runtime/voyage/split/dawn-static-sky.png",
	"bright": "res://assets/images/runtime/voyage/split/bright-static-sky.png",
	"sunset": "res://assets/images/runtime/voyage/split/sunset-static-sky.png",
	"night": "res://assets/images/runtime/voyage/split/night-static-sky.png",
}
const SEA_TEXTURE_PATHS := {
	"dawn": "res://assets/images/runtime/voyage/split/dawn-flowing-sea.png",
	"bright": "res://assets/images/runtime/voyage/split/bright-flowing-sea.png",
	"sunset": "res://assets/images/runtime/voyage/split/sunset-flowing-sea.png",
	"night": "res://assets/images/runtime/voyage/split/night-flowing-sea.png",
}
const SPLIT_CAMERA_PATHS := [
	"VoyageWorld/DioramaCameraRig/DioramaCamera3D",
	"VoyageWorld/LookAroundCameraRig/LookAroundCamera3D",
	"VoyageWorld/AppreciationCameraRig/AppreciationCamera3D",
]

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	for time_of_day_id in SKY_TEXTURE_PATHS:
		_expect(ResourceLoader.exists(str(SKY_TEXTURE_PATHS[time_of_day_id])), "static sky texture must exist for %s" % time_of_day_id)
		_expect(ResourceLoader.exists(str(SEA_TEXTURE_PATHS[time_of_day_id])), "flowing sea texture must exist for %s" % time_of_day_id)
	_expect(ResourceLoader.exists(SEA_FLOW_SHADER_PATH), "split sea layer must use its own dedicated flow shader")

	var game_state := root.get_node_or_null("GameState")
	if game_state != null:
		game_state.reset_session()
		game_state.voyage_active = true
		game_state.remaining_seconds = 300.0
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	_expect(packed_scene != null, "game scene must load")
	if packed_scene == null:
		_finish()
		return

	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame
	for time_of_day_id in SKY_TEXTURE_PATHS:
		if scene.has_method("apply_real_time_atmosphere_for_hour"):
			scene.call("apply_real_time_atmosphere_for_hour", _hour_for_time_of_day(str(time_of_day_id)))
		_assert_split_layers(scene, str(time_of_day_id))

	var flow_before := float(scene.call("get_background_flow_offset")) if scene.has_method("get_background_flow_offset") else 0.0
	scene.call("_apply_drift_motion", 1.0)
	var flow_after := float(scene.call("get_background_flow_offset")) if scene.has_method("get_background_flow_offset") else flow_before
	_expect(absf(flow_after - flow_before) > 0.001, "only the sea layer must retain continuous visual motion")
	for camera_path in SPLIT_CAMERA_PATHS:
		var sea_backdrop := scene.get_node_or_null("%s/SeaBackdrop" % camera_path) as Sprite3D
		if sea_backdrop != null and sea_backdrop.material_override is ShaderMaterial:
			var material := sea_backdrop.material_override as ShaderMaterial
			_expect(is_equal_approx(float(material.get_shader_parameter("flow_offset")), flow_after), "all split sea cameras must receive the same flow offset")

	scene.queue_free()
	await process_frame
	_finish()


func _assert_split_layers(scene: Node, time_of_day_id: String) -> void:
	for camera_path in SPLIT_CAMERA_PATHS:
		var sky_backdrop := scene.get_node_or_null("%s/SkyBackdrop" % camera_path) as Sprite3D
		var sea_backdrop := scene.get_node_or_null("%s/SeaBackdrop" % camera_path) as Sprite3D
		_expect(sky_backdrop != null, "every normal/front/appreciation camera must retain a dedicated SkyBackdrop")
		_expect(sea_backdrop != null, "every normal/front/appreciation camera must retain a dedicated SeaBackdrop")
		if sky_backdrop != null:
			_expect(sky_backdrop.texture != null and sky_backdrop.texture.resource_path == str(SKY_TEXTURE_PATHS[time_of_day_id]), "sky must stay on the exact static %s asset" % time_of_day_id)
			_expect(sky_backdrop.material_override == null, "SkyBackdrop must never receive the water-flow material")
		if sea_backdrop != null:
			_expect(sea_backdrop.texture != null and sea_backdrop.texture.resource_path == str(SEA_TEXTURE_PATHS[time_of_day_id]), "sea must use the exact flowing %s asset" % time_of_day_id)
			_expect(sea_backdrop.material_override is ShaderMaterial, "SeaBackdrop must own the flow material")
			if sea_backdrop.material_override is ShaderMaterial:
				var material := sea_backdrop.material_override as ShaderMaterial
				_expect(material.shader != null and material.shader.resource_path == SEA_FLOW_SHADER_PATH, "SeaBackdrop must use the split sea-flow shader")


func _hour_for_time_of_day(time_of_day_id: String) -> int:
	match time_of_day_id:
		"dawn":
			return 6
		"sunset":
			return 18
		"night":
			return 22
		_:
			return 12


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: split sky sea background contract")
		quit(0)
	else:
		printerr("FAILED: %d split sky sea background assertions" % _failures)
		quit(1)
