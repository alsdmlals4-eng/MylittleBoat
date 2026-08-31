# 함께한 시간이 활성 항해에서만 로컬로 누적되는지 검증한다.
extends SceneTree

const STORAGE_PATH := "user://test_together_time_state.cfg"
const MEMORY_LEDGER_STORAGE_PATH := "user://test_together_time_state_memory_ledger.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var state := root.get_node_or_null("GameState")
	_expect(state != null, "GameState autoload must exist")
	if state == null:
		_finish()
		return
	_expect(state.has_method("set_together_time_storage_path"), "GameState must expose isolated together-time storage")
	_expect(state.has_method("advance_together_time"), "GameState must expose active together-time accumulation")
	_expect(state.has_method("flush_together_time"), "GameState must flush local together time")
	_expect(state.has_method("load_together_time"), "GameState must restore local together time")
	if not state.has_method("set_together_time_storage_path") or not state.has_method("advance_together_time") or not state.has_method("flush_together_time") or not state.has_method("load_together_time"):
		_finish()
		return
	_clear_test_storage()
	_clear_memory_ledger_storage()
	state.set_together_time_storage_path(STORAGE_PATH)
	state.set_memory_ledger_storage_path(MEMORY_LEDGER_STORAGE_PATH)
	state.together_time_seconds = 0.0
	state.reset_session()
	state.advance_together_time(3.0)
	_expect(is_zero_approx(state.together_time_seconds), "inactive voyage must not accumulate together time")

	state.begin_voyage()
	state.advance_together_time(2.5)
	_expect(is_equal_approx(state.together_time_seconds, 2.5), "active voyage must accumulate the passed delta")
	state.advance_together_time(-4.0)
	_expect(is_equal_approx(state.together_time_seconds, 2.5), "negative delta must not decrease or add together time")

	state.add_photo("테스트 사진")
	state.add_scenery("테스트 풍경")
	state.add_letter("테스트 편지")
	state.add_fish("정어리")
	_expect(is_equal_approx(state.together_time_seconds, 2.5), "optional memories must not add together time")

	state.remaining_seconds = 0.0
	state.complete_voyage()
	state.advance_together_time(1.0)
	_expect(is_equal_approx(state.together_time_seconds, 3.5), "post-record resting in the same voyage must keep accumulating")
	state.flush_together_time()
	state.together_time_seconds = 0.0
	state.load_together_time()
	_expect(is_equal_approx(state.together_time_seconds, 3.5), "flushed together time must restore locally")
	state.set_memory_ledger_storage_path("user://memory_ledger_v1.cfg")
	_clear_memory_ledger_storage()
	_finish()


func _clear_test_storage() -> void:
	var file := FileAccess.open(STORAGE_PATH, FileAccess.WRITE)
	_expect(file != null, "test must be able to clear its isolated ConfigFile")
	if file != null:
		file.store_string("")


func _clear_memory_ledger_storage() -> void:
	if FileAccess.file_exists(MEMORY_LEDGER_STORAGE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(MEMORY_LEDGER_STORAGE_PATH))


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: together time state contract")
		quit(0)
	else:
		printerr("FAILED: %d together-time state assertions" % _failures)
		quit(1)
