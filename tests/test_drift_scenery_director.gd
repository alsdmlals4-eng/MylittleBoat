# 전경에 머문 시간만 먼 풍경 기회로 바뀌는지 검증한다.
extends SceneTree

const DIRECTOR_PATH := "res://scripts/voyage/drift_scenery_director.gd"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(ResourceLoader.exists(DIRECTOR_PATH), "drift scenery director must exist")
	if not ResourceLoader.exists(DIRECTOR_PATH):
		_finish()
		return
	var director = load(DIRECTOR_PATH).new(12345)
	_expect(is_equal_approx(director.get_active_seconds(), 0.0), "new scenery director starts empty")
	director.advance(151.0, false)
	_expect(is_equal_approx(director.get_active_seconds(), 0.0), "background time must not advance scenery")
	var event: Dictionary = director.advance(151.0, true)
	_expect(is_equal_approx(director.get_active_seconds(), 151.0), "foreground time advances scenery")
	_expect(bool(event.get("show_scenery", false)), "first foreground window shows distant scenery")
	_expect(["buoy", "islet", "lighthouse"].has(str(event.get("scenery_id", ""))), "event must choose an approved distant scenery ID")
	_expect(not event.has("reward"), "scenery event must not expose a reward")
	_expect(event.has("save_memory") and event.get("save_memory") is bool, "event may only offer passive memory saving")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: drifting scenery director contract")
		quit(0)
	else:
		printerr("FAILED: %d drifting scenery assertions" % _failures)
		quit(1)
