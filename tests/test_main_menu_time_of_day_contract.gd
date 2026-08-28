# 구형 메인 메뉴 시간대 선택이 현실 시간 자동 분위기로 대체됐는지 검증한다.
extends SceneTree

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var state_source := FileAccess.get_file_as_string("res://scripts/core/game_state.gd")
	var scene_source := FileAccess.get_file_as_string("res://scenes/game.tscn")
	_expect(not state_source.contains("selected_time_of_day"), "GameState must not keep an atmosphere preference")
	_expect(not state_source.contains("select_time_of_day"), "GameState must not expose manual time selection")
	_expect(not scene_source.contains("TimeOfDayOption"), "first boat scene must not show a time selector")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: automatic-atmosphere entry contract")
		quit(0)
	else:
		printerr("FAILED: %d automatic-atmosphere entry assertions" % _failures)
		quit(1)
