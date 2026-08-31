<<<<<<< HEAD
# 과거 메뉴 배경이 아니라 게임 씬이 시작 화면을 책임지는지 검증한다.
=======
# 구형 메뉴 배경 대신 보트·바다·두 카메라가 시작 장면에 있는지 검증한다.
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
<<<<<<< HEAD
	_expect(ProjectSettings.get_setting("application/run/main_scene", "") == GAME_SCENE_PATH, "startup must not route through the legacy menu background")
	var scene_source := FileAccess.get_file_as_string("res://scripts/voyage/game_scene.gd")
	_expect(scene_source.contains("real_time_atmosphere_resolver"), "game scene must own real-time atmosphere application")
	_expect(not scene_source.contains("selected_time_of_day"), "game scene must not consume a saved time preference")
=======
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	_expect(packed_scene != null, "game.tscn must load")
	if packed_scene == null:
		_finish()
		return
	var scene := packed_scene.instantiate()
	_expect(scene.get_node_or_null("VoyageWorld/BoatSpace") != null, "direct entry must include the boat")
	_expect(scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D") != null, "direct entry must include the normal diorama camera")
	_expect(scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D") != null, "direct entry must preserve the appreciation camera")
	scene.free()
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
<<<<<<< HEAD
		print("PASS: direct entry atmosphere owner contract")
		quit(0)
	else:
		printerr("FAILED: %d direct entry atmosphere owner assertions" % _failures)
=======
		print("PASS: direct-entry diorama contract")
		quit(0)
	else:
		printerr("FAILED: %d direct-entry diorama assertions" % _failures)
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
		quit(1)
