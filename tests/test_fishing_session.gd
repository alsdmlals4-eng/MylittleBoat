# 실패 없는 낚시 세션 상태 전이를 검증한다.
extends SceneTree

var _failures := 0


func _init() -> void:
	const SCRIPT_PATH := "res://scripts/voyage/fishing_session.gd"
	_expect(ResourceLoader.exists(SCRIPT_PATH), "FishingSession script must exist")
	if not ResourceLoader.exists(SCRIPT_PATH):
		_finish()
		return

	var fishing_script := load(SCRIPT_PATH)
	_expect(fishing_script != null, "FishingSession script must load")
	if fishing_script == null:
		_finish()
		return

	var session: RefCounted = fishing_script.new()
	for method_name in ["cast_line", "advance", "is_waiting", "is_bite_ready", "resolve_catch", "cancel"]:
		_expect(session.has_method(method_name), "FishingSession must expose %s" % method_name)

	if _failures > 0:
		_finish()
		return

	session.call("cast_line", 2.0)
	_expect(bool(session.call("is_waiting")), "cast_line must enter WAITING")
	_expect(not bool(session.call("is_bite_ready")), "cast_line must not create an immediate bite")
	_expect(not bool(session.call("advance", 1.0)), "advance before wait completion must not report a bite")
	_expect(bool(session.call("advance", 1.0)), "advance at wait completion must report one bite")
	_expect(bool(session.call("is_bite_ready")), "completed wait must enter BITE_READY")

	var caught := str(session.call("resolve_catch", "정어리"))
	_expect(caught == "정어리", "resolve_catch must return the caught fish name")
	_expect(not bool(session.call("is_waiting")), "resolved catch must leave WAITING")
	_expect(not bool(session.call("is_bite_ready")), "resolved catch must leave BITE_READY")

	session.call("cast_line", 5.0)
	session.call("cancel")
	_expect(not bool(session.call("is_waiting")), "cancel must return to IDLE without penalty")
	_expect(not bool(session.call("is_bite_ready")), "cancel must clear bite state")

	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: fishing session contract")
		quit(0)
	else:
		printerr("FAILED: %d fishing session assertions" % _failures)
		quit(1)
