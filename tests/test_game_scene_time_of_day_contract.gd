# 네 현실 시간대가 승인 풍경과 양쪽 카메라에 함께 적용되는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const SKY_TEXTURE_PATHS := {
	"bright": "res://assets/images/runtime/voyage/split/bright-static-sky.png",
	"dawn": "res://assets/images/runtime/voyage/split/dawn-static-sky.png",
	"sunset": "res://assets/images/runtime/voyage/split/sunset-static-sky.png",
	"night": "res://assets/images/runtime/voyage/split/night-static-sky.png",
}
const SEA_TEXTURE_PATHS := {
	"bright": "res://assets/images/runtime/voyage/split/bright-flowing-sea.png",
	"dawn": "res://assets/images/runtime/voyage/split/dawn-flowing-sea.png",
	"sunset": "res://assets/images/runtime/voyage/split/sunset-flowing-sea.png",
	"night": "res://assets/images/runtime/voyage/split/night-flowing-sea.png",
}
const BOAT_WATER_CONTACT_TEXTURE_PATH := "res://assets/images/runtime/voyage/boat-water-contact-ripple.png"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	for texture_path in SKY_TEXTURE_PATHS.values():
		_expect(ResourceLoader.exists(texture_path), "approved static sky atmosphere texture must exist: %s" % texture_path)
	for texture_path in SEA_TEXTURE_PATHS.values():
		_expect(ResourceLoader.exists(texture_path), "approved flowing sea atmosphere texture must exist: %s" % texture_path)
	_expect(ResourceLoader.exists(BOAT_WATER_CONTACT_TEXTURE_PATH), "boat-water contact texture must exist")
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	_expect(packed_scene != null, "game.tscn must load")
	if packed_scene == null:
		_finish()
		return

	var bright := await _capture_scene_tone(packed_scene, 12)
	var dawn := await _capture_scene_tone(packed_scene, 6)
	var sunset := await _capture_scene_tone(packed_scene, 18)
	var night := await _capture_scene_tone(packed_scene, 22)
	_expect(bright.get("atmosphere_id", "") == "bright", "12:00 must apply Bright")
	_expect(dawn.get("atmosphere_id", "") == "dawn", "06:00 must apply Dawn")
	_expect(sunset.get("atmosphere_id", "") == "sunset", "18:00 must apply Sunset")
	_expect(night.get("atmosphere_id", "") == "night", "22:00 must apply Night")
	_expect(bright.get("diorama_sky_texture_path", "") == SKY_TEXTURE_PATHS["bright"], "Bright uses the approved static sky image")
	_expect(dawn.get("diorama_sky_texture_path", "") == SKY_TEXTURE_PATHS["dawn"], "Dawn uses the approved static sky image")
	_expect(sunset.get("diorama_sky_texture_path", "") == SKY_TEXTURE_PATHS["sunset"], "Sunset uses the approved static sky image")
	_expect(night.get("diorama_sky_texture_path", "") == SKY_TEXTURE_PATHS["night"], "Night uses the approved static sky image")
	_expect(bright.get("diorama_sea_texture_path", "") == SEA_TEXTURE_PATHS["bright"], "Bright uses the approved flowing sea image")
	_expect(dawn.get("diorama_sea_texture_path", "") == SEA_TEXTURE_PATHS["dawn"], "Dawn uses the approved flowing sea image")
	_expect(sunset.get("diorama_sea_texture_path", "") == SEA_TEXTURE_PATHS["sunset"], "Sunset uses the approved flowing sea image")
	_expect(night.get("diorama_sea_texture_path", "") == SEA_TEXTURE_PATHS["night"], "Night uses the approved flowing sea image")
	_expect(night.get("diorama_sky_texture_path", "") == night.get("appreciation_sky_texture_path", ""), "both cameras must share one Night sky texture")
	_expect(night.get("diorama_sea_texture_path", "") == night.get("appreciation_sea_texture_path", ""), "both cameras must share one Night sea texture")
	_expect(night.get("diorama_modulate", Color.WHITE) == night.get("appreciation_modulate", Color.BLACK), "both cameras must share one Night tone")
	_expect((sunset.get("diorama_modulate", Color.WHITE) as Color).r < 0.9, "Sunset split layers must not receive an orange-overload red multiplier")
	_expect(bright.get("water_contact_texture_path", "") == BOAT_WATER_CONTACT_TEXTURE_PATH, "normal diorama must retain the one approved water-contact layer")
	_expect(night.get("light_energy", 0.0) < bright.get("light_energy", 0.0), "Night must use a gentler key light than Bright")
	_finish()


func _capture_scene_tone(packed_scene: PackedScene, hour: int) -> Dictionary:
	var game_state := root.get_node_or_null("GameState")
	if game_state != null:
		game_state.reset_session()
		game_state.voyage_active = true
		game_state.remaining_seconds = 300.0
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame
	var result := {}
	if scene.has_method("apply_real_time_atmosphere_for_hour"):
		scene.apply_real_time_atmosphere_for_hour(hour)
	var world_environment := scene.get_node_or_null("VoyageWorld/WorldEnvironment") as WorldEnvironment
	var light := scene.get_node_or_null("VoyageWorld/SunLight") as DirectionalLight3D
	var diorama_sky := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SkyBackdrop") as Sprite3D
	var appreciation_sky := scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SkyBackdrop") as Sprite3D
	var diorama_sea := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop") as Sprite3D
	var appreciation_sea := scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeaBackdrop") as Sprite3D
	var water_contact := scene.get_node_or_null("VoyageWorld/BoatWaterContact") as Sprite3D
	result = {
		"atmosphere_id": scene.get_active_atmosphere_id() if scene.has_method("get_active_atmosphere_id") else "",
		"background": world_environment.environment.background_color if world_environment != null and world_environment.environment != null else Color.BLACK,
		"light_energy": light.light_energy if light != null else 0.0,
		"diorama_modulate": diorama_sea.modulate if diorama_sea != null else Color.BLACK,
		"appreciation_modulate": appreciation_sea.modulate if appreciation_sea != null else Color.BLACK,
		"diorama_sky_texture_path": diorama_sky.texture.resource_path if diorama_sky != null and diorama_sky.texture != null else "",
		"appreciation_sky_texture_path": appreciation_sky.texture.resource_path if appreciation_sky != null and appreciation_sky.texture != null else "",
		"diorama_sea_texture_path": diorama_sea.texture.resource_path if diorama_sea != null and diorama_sea.texture != null else "",
		"appreciation_sea_texture_path": appreciation_sea.texture.resource_path if appreciation_sea != null and appreciation_sea.texture != null else "",
		"water_contact_texture_path": water_contact.texture.resource_path if water_contact != null and water_contact.texture != null else "",
	}
	scene.queue_free()
	await process_frame
	return result


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: game scene real-time atmosphere contract")
		quit(0)
	else:
		printerr("FAILED: %d game scene real-time atmosphere assertions" % _failures)
		quit(1)
