# 구형 메뉴 배경 대신 보트·바다·두 카메라가 시작 장면에 있는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
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
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: direct-entry diorama contract")
		quit(0)
	else:
		printerr("FAILED: %d direct-entry diorama assertions" % _failures)
		quit(1)
