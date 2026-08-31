<<<<<<< HEAD
# 현실 시각은 메뉴 선택 없이 항해 화면의 시각만 바꾸는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const RESOLVER_PATH := "res://scripts/voyage/real_time_atmosphere_resolver.gd"

=======
# 구형 메인 메뉴 시간대 선택이 현실 시간 자동 분위기로 대체됐는지 검증한다.
extends SceneTree

>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
<<<<<<< HEAD
	_expect(ProjectSettings.get_setting("application/run/main_scene", "") == GAME_SCENE_PATH, "time setup must not block direct boat entry")
	_expect(ResourceLoader.exists(RESOLVER_PATH), "real-time atmosphere resolver must exist")
	if ResourceLoader.exists(RESOLVER_PATH):
		var resolver = load(RESOLVER_PATH).new()
		_expect(resolver.resolve_hour(8) == "dawn", "last dawn hour must remain visual Dawn")
		_expect(resolver.resolve_hour(16) == "bright", "last bright hour must remain visual Bright")
		_expect(resolver.resolve_hour(20) == "sunset", "last sunset hour must remain visual Sunset")
=======
	var state_source := FileAccess.get_file_as_string("res://scripts/core/game_state.gd")
	var scene_source := FileAccess.get_file_as_string("res://scenes/game.tscn")
	_expect(not state_source.contains("selected_time_of_day"), "GameState must not keep an atmosphere preference")
	_expect(not state_source.contains("select_time_of_day"), "GameState must not expose manual time selection")
	_expect(not scene_source.contains("TimeOfDayOption"), "first boat scene must not show a time selector")
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
		print("PASS: direct entry real-time contract")
		quit(0)
	else:
		printerr("FAILED: %d direct entry real-time assertions" % _failures)
=======
		print("PASS: automatic-atmosphere entry contract")
		quit(0)
	else:
		printerr("FAILED: %d automatic-atmosphere entry assertions" % _failures)
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
		quit(1)
