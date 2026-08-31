# 네 현실 시간대가 승인 풍경과 양쪽 카메라에 함께 적용되는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const BRIGHT_TEXTURE_PATH := "res://assets/images/runtime/voyage/bright-open-sea-water-only.png"
const DAWN_TEXTURE_PATH := "res://assets/images/runtime/voyage/dawn-arches-waterfall-water-only.png"
const SUNSET_TEXTURE_PATH := "res://assets/images/runtime/voyage/sunset-sandstone-cove-water-only.png"
const NIGHT_TEXTURE_PATH := "res://assets/images/runtime/voyage/night-indigo-rain-bay-water-only.png"
const BOAT_WATER_CONTACT_TEXTURE_PATH := "res://assets/images/runtime/voyage/boat-water-contact-ripple.png"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	for texture_path in [BRIGHT_TEXTURE_PATH, DAWN_TEXTURE_PATH, SUNSET_TEXTURE_PATH, NIGHT_TEXTURE_PATH]:
		_expect(ResourceLoader.exists(texture_path), "approved runtime atmosphere texture must exist: %s" % texture_path)
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
	_expect(bright.get("diorama_texture_path", "") == BRIGHT_TEXTURE_PATH, "Bright uses the approved direct-entry image")
	_expect(dawn.get("diorama_texture_path", "") == DAWN_TEXTURE_PATH, "Dawn uses the approved sea-arches image")
	_expect(sunset.get("diorama_texture_path", "") == SUNSET_TEXTURE_PATH, "Sunset uses the approved sandstone-cove image")
	_expect(night.get("diorama_texture_path", "") == NIGHT_TEXTURE_PATH, "Night uses the approved indigo-rain image")
	_expect(night.get("diorama_texture_path", "") == night.get("appreciation_texture_path", ""), "both cameras must share one Night texture")
	_expect(night.get("diorama_modulate", Color.WHITE) == night.get("appreciation_modulate", Color.BLACK), "both cameras must share one Night tone")
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
	var diorama_backdrop := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop") as Sprite3D
	var appreciation_backdrop := scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeaBackdrop") as Sprite3D
	var water_contact := scene.get_node_or_null("VoyageWorld/BoatWaterContact") as Sprite3D
	result = {
		"atmosphere_id": scene.get_active_atmosphere_id() if scene.has_method("get_active_atmosphere_id") else "",
		"background": world_environment.environment.background_color if world_environment != null and world_environment.environment != null else Color.BLACK,
		"light_energy": light.light_energy if light != null else 0.0,
		"diorama_modulate": diorama_backdrop.modulate if diorama_backdrop != null else Color.BLACK,
		"appreciation_modulate": appreciation_backdrop.modulate if appreciation_backdrop != null else Color.BLACK,
		"diorama_texture_path": diorama_backdrop.texture.resource_path if diorama_backdrop != null and diorama_backdrop.texture != null else "",
		"appreciation_texture_path": appreciation_backdrop.texture.resource_path if appreciation_backdrop != null and appreciation_backdrop.texture != null else "",
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
