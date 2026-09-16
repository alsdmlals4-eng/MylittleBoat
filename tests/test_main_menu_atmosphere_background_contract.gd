# 과거 메뉴 배경이 아니라 게임 씬이 시작 화면을 책임지는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(ProjectSettings.get_setting("application/run/main_scene", "") == GAME_SCENE_PATH, "startup must not route through the legacy menu background")
	var scene_source := FileAccess.get_file_as_string("res://scripts/voyage/game_scene.gd")
	_expect(scene_source.contains("real_time_atmosphere_resolver"), "game scene must own real-time atmosphere application")
	_expect(not scene_source.contains("selected_time_of_day"), "game scene must not consume a saved time preference")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: direct entry atmosphere owner contract")
		quit(0)
	else:
		printerr("FAILED: %d direct entry atmosphere owner assertions" % _failures)
		quit(1)
