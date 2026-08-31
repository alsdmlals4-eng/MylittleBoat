# 자동 풍경 기억만 저장되고 함께한 시간과 다른 기억은 바꾸지 않는지 검증한다.
extends SceneTree

const STORAGE_PATH := "user://test_ambient_memory_state.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var state := root.get_node_or_null("GameState")
	_expect(state != null, "GameState autoload must exist")
	if state == null:
		_finish()
		return
	_expect(state.has_method("set_ambient_memory_storage_path"), "GameState must expose isolated ambient-memory storage")
	_expect(state.has_method("record_ambient_memory"), "GameState must expose the named ambient-memory writer")
	_expect(state.has_method("load_ambient_memories"), "GameState must restore ambient memories")
	if not state.has_method("set_ambient_memory_storage_path") or not state.has_method("record_ambient_memory") or not state.has_method("load_ambient_memories"):
		_finish()
		return
	_cleanup_test_storage()
	state.set_ambient_memory_storage_path(STORAGE_PATH)
	state.ambient_memories.clear()
	state.sceneries.clear()
	state.add_scenery("테스트 fixture 풍경")
	state.load_ambient_memories()
	_expect(state.ambient_memories.is_empty() and state.sceneries.is_empty(), "generic scenery helper must not become durable ambient memory")

	state.begin_voyage()
	var together_time_before: float = state.together_time_seconds
	state.record_ambient_memory("  멀리 바위 아치 사이로 잔잔한 물줄기가 보입니다.  ")
	_expect(state.ambient_memories == ["멀리 바위 아치 사이로 잔잔한 물줄기가 보입니다."], "named writer must add one normalized ambient-memory entry")
	_expect(state.sceneries == ["멀리 바위 아치 사이로 잔잔한 물줄기가 보입니다."], "Album scenery consumer must receive the persisted ambient entry")
	_expect(is_equal_approx(state.together_time_seconds, together_time_before), "ambient-memory writing must not change together time")

	state.ambient_memories.clear()
	state.sceneries.clear()
	state.load_ambient_memories()
	_expect(state.ambient_memories == ["멀리 바위 아치 사이로 잔잔한 물줄기가 보입니다."], "saved ambient memory must restore through GameState")
	_expect(state.sceneries == ["멀리 바위 아치 사이로 잔잔한 물줄기가 보입니다."], "restored ambient memory must populate the Album scenery consumer")
	_finish()


func _cleanup_test_storage() -> void:
	DirAccess.remove_absolute(ProjectSettings.globalize_path(STORAGE_PATH))


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	_cleanup_test_storage()
	if _failures == 0:
		print("PASS: ambient-memory state contract")
		quit(0)
	else:
		printerr("FAILED: %d ambient-memory state assertions" % _failures)
		quit(1)
