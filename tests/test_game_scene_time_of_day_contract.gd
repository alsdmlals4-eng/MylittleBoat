# 게임 화면의 네 시간대가 같은 장소에 공유 적용되는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	_expect(packed_scene != null, "game.tscn must load")
	if game_state == null or packed_scene == null:
		_finish()
		return

	var bright := await _capture_scene_tone(packed_scene, game_state, "bright", "평온")
	var dawn := await _capture_scene_tone(packed_scene, game_state, "dawn", "평온")
	var sunset := await _capture_scene_tone(packed_scene, game_state, "sunset", "평온")
	var night := await _capture_scene_tone(packed_scene, game_state, "night", "평온")
	var excited_bright := await _capture_scene_tone(packed_scene, game_state, "bright", "설렘")

	_expect(bright.get("diorama_modulate", Color.BLACK) == Color.WHITE, "Bright must preserve the approved Bright sea art")
	_expect(bright.get("appreciation_modulate", Color.BLACK) == Color.WHITE, "Bright must preserve the Appreciation sea art")
	_expect(dawn.get("background", Color.BLACK) != bright.get("background", Color.BLACK), "Dawn must visibly differ from Bright")
	_expect(sunset.get("background", Color.BLACK) != bright.get("background", Color.BLACK), "Sunset must visibly differ from Bright")
	_expect(night.get("background", Color.BLACK) != bright.get("background", Color.BLACK), "Night must visibly differ from Bright")
	_expect(night.get("diorama_modulate", Color.WHITE) != Color.WHITE, "Night must tint the Diorama backdrop")
	_expect(night.get("appreciation_modulate", Color.WHITE) != Color.WHITE, "Night must tint the Appreciation backdrop")
	_expect(night.get("diorama_modulate", Color.BLACK) == night.get("appreciation_modulate", Color.BLACK), "both cameras must share one Night backdrop treatment")
	_expect(night.get("light_energy", 0.0) < bright.get("light_energy", 0.0), "Night must use a gentler key light than Bright")
	_expect(bright.get("background", Color.BLACK) != excited_bright.get("background", Color.BLACK), "mood must remain a subtle variation within Bright")

	game_state.select_time_of_day("bright")
	game_state.selected_mood = "평온"
	game_state.reset_session()
	_finish()


func _capture_scene_tone(packed_scene: PackedScene, game_state, time_of_day: String, mood: String) -> Dictionary:
	game_state.reset_session()
	game_state.voyage_active = true
	game_state.remaining_seconds = 300.0
	game_state.selected_mood = mood
	game_state.select_time_of_day(time_of_day)
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame

	var world_environment := scene.get_node_or_null("VoyageWorld/WorldEnvironment") as WorldEnvironment
	var light := scene.get_node_or_null("VoyageWorld/SunLight") as DirectionalLight3D
	var diorama_backdrop := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop") as Sprite3D
	var appreciation_backdrop := scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeaBackdrop") as Sprite3D
	var result := {
		"background": world_environment.environment.background_color if world_environment != null and world_environment.environment != null else Color.BLACK,
		"light_energy": light.light_energy if light != null else 0.0,
		"diorama_modulate": diorama_backdrop.modulate if diorama_backdrop != null else Color.BLACK,
		"appreciation_modulate": appreciation_backdrop.modulate if appreciation_backdrop != null else Color.BLACK,
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
		print("PASS: game scene time-of-day contract")
		quit(0)
	else:
		printerr("FAILED: %d game scene time-of-day assertions" % _failures)
		quit(1)

