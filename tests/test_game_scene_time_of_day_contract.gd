<<<<<<< HEAD
# 네 현실 시간대가 승인 풍경과 양쪽 카메라에 함께 적용되는지 검증한다.
=======
# 게임 화면이 현실 시간 분위기를 시각적으로만 적용하는지 검증한다.
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
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
<<<<<<< HEAD
	for texture_path in [BRIGHT_TEXTURE_PATH, DAWN_TEXTURE_PATH, SUNSET_TEXTURE_PATH, NIGHT_TEXTURE_PATH]:
		_expect(ResourceLoader.exists(texture_path), "approved runtime atmosphere texture must exist: %s" % texture_path)
	_expect(ResourceLoader.exists(BOAT_WATER_CONTACT_TEXTURE_PATH), "boat-water contact texture must exist")
=======
	var game_state := root.get_node_or_null("GameState")
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	_expect(game_state != null, "GameState autoload must exist")
	_expect(packed_scene != null, "game.tscn must load")
	if packed_scene == null:
		_finish()
		return

<<<<<<< HEAD
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
=======
	game_state.reset_session()
	game_state.voyage_active = true
	game_state.remaining_seconds = 180.0
	var before_photos: int = game_state.photos.size()
	var before_scenery: int = game_state.sceneries.size()
	var before_letters: int = game_state.letters.size()
	var before_fish: int = game_state.fish.size()
	var before_affection: int = game_state.companion_affection
	var before_records: int = game_state.voyage_records.size()

	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame
	_expect(scene.has_method("apply_real_time_atmosphere_for_hour"), "game scene must expose an injected-hour atmosphere API")
	_expect(scene.has_method("set_application_foreground"), "game scene must expose application foreground state")
	if not scene.has_method("apply_real_time_atmosphere_for_hour"):
		scene.queue_free()
		await process_frame
		_finish()
		return

	var bright_id: String = str(scene.call("apply_real_time_atmosphere_for_hour", 9))
	var bright := _capture_scene_tone(scene)
	var dawn_id: String = str(scene.call("apply_real_time_atmosphere_for_hour", 5))
	var dawn := _capture_scene_tone(scene)
	var sunset_id: String = str(scene.call("apply_real_time_atmosphere_for_hour", 17))
	var sunset := _capture_scene_tone(scene)
	var night_id: String = str(scene.call("apply_real_time_atmosphere_for_hour", 21))
	var night := _capture_scene_tone(scene)

	_expect(bright_id == "bright" and dawn_id == "dawn" and sunset_id == "sunset" and night_id == "night", "approved hour bands must select the approved atmosphere IDs")
	_expect(dawn.get("background", Color.BLACK) != bright.get("background", Color.BLACK), "Dawn must visibly differ from Bright")
	_expect(sunset.get("background", Color.BLACK) != bright.get("background", Color.BLACK), "Sunset must visibly differ from Bright")
	_expect(night.get("background", Color.BLACK) != bright.get("background", Color.BLACK), "Night must visibly differ from Bright")
	_expect(str(night.get("diorama_texture_path", "")).ends_with("sea_night_indigo_rain_storybook.png"), "Night must use the dedicated indigo-rain sea artwork")
	_expect(night.get("diorama_texture_path", "") == night.get("appreciation_texture_path", ""), "both cameras must use the same Night sea artwork")
	_expect(night.get("diorama_modulate", Color.WHITE) == night.get("appreciation_modulate", Color.BLACK), "both cameras must share one Night backdrop treatment")
	_expect(night.get("waterline_modulate", Color.WHITE) != Color.WHITE, "Night must tint the boat-water contact overlay")
	_expect(night.get("light_energy", 0.0) < bright.get("light_energy", 0.0), "Night must use a gentler key light than Bright")
	_expect(game_state.photos.size() == before_photos and game_state.sceneries.size() == before_scenery and game_state.letters.size() == before_letters and game_state.fish.size() == before_fish, "hour changes must not create memories")
	_expect(game_state.companion_affection == before_affection and game_state.voyage_records.size() == before_records and is_equal_approx(game_state.remaining_seconds, 180.0), "hour changes must not alter progression")
	if scene.has_method("set_application_foreground") and scene.has_method("is_application_foreground"):
		var seconds_before_background: float = float(game_state.remaining_seconds)
		var records_before_background: int = game_state.voyage_records.size()
		scene.call("set_application_foreground", false)
		_expect(not bool(scene.call("is_application_foreground")), "focus-out must pause foreground-only systems")
		scene.call("_process", 60.0)
		_expect(is_equal_approx(game_state.remaining_seconds, seconds_before_background), "background time must not advance the voyage timer")
		_expect(game_state.voyage_records.size() == records_before_background, "background time must not create a voyage record")
		scene.call("set_application_foreground", true)
		_expect(bool(scene.call("is_application_foreground")), "focus-in must resume foreground-only systems")
		scene.call("_process", 1.0)
		_expect(game_state.remaining_seconds < seconds_before_background, "foreground time must resume the voyage timer")

	scene.queue_free()
	await process_frame
	_finish()


func _capture_scene_tone(scene: Node) -> Dictionary:
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
	var world_environment := scene.get_node_or_null("VoyageWorld/WorldEnvironment") as WorldEnvironment
	var light := scene.get_node_or_null("VoyageWorld/SunLight") as DirectionalLight3D
	var diorama_backdrop := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop") as Sprite3D
	var appreciation_backdrop := scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeaBackdrop") as Sprite3D
<<<<<<< HEAD
	var water_contact := scene.get_node_or_null("VoyageWorld/BoatWaterContact") as Sprite3D
	result = {
		"atmosphere_id": scene.get_active_atmosphere_id() if scene.has_method("get_active_atmosphere_id") else "",
=======
	var waterline_overlay := scene.get_node_or_null("VoyageWorld/BoatSpace/BoatWaterlineOverlay") as Sprite3D
	return {
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
		"background": world_environment.environment.background_color if world_environment != null and world_environment.environment != null else Color.BLACK,
		"light_energy": light.light_energy if light != null else 0.0,
		"diorama_modulate": diorama_backdrop.modulate if diorama_backdrop != null else Color.BLACK,
		"appreciation_modulate": appreciation_backdrop.modulate if appreciation_backdrop != null else Color.BLACK,
		"diorama_texture_path": diorama_backdrop.texture.resource_path if diorama_backdrop != null and diorama_backdrop.texture != null else "",
		"appreciation_texture_path": appreciation_backdrop.texture.resource_path if appreciation_backdrop != null and appreciation_backdrop.texture != null else "",
<<<<<<< HEAD
		"water_contact_texture_path": water_contact.texture.resource_path if water_contact != null and water_contact.texture != null else "",
=======
		"waterline_modulate": waterline_overlay.modulate if waterline_overlay != null else Color.WHITE,
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
	}


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
<<<<<<< HEAD
		printerr("FAILED: %d game scene real-time atmosphere assertions" % _failures)
=======
		printerr("FAILED: %d real-time atmosphere assertions" % _failures)
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
		quit(1)
