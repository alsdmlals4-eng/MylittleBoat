# GameState가 물고기와 완료 항해 기록만 로컬 ledger로 저장하는지 검증한다.
extends SceneTree

const STORAGE_PATH := "user://test_memory_ledger_state.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var state := root.get_node_or_null("GameState")
	_expect(state != null, "GameState autoload must exist")
	if state == null:
		_finish()
		return
	_expect(state.has_method("set_memory_ledger_storage_path"), "GameState must expose isolated memory-ledger storage")
	_expect(state.has_method("load_memory_ledger"), "GameState must restore durable fish and voyage records")
	if not state.has_method("set_memory_ledger_storage_path") or not state.has_method("load_memory_ledger"):
		_finish()
		return
	_cleanup_test_storage()
	state.set_memory_ledger_storage_path(STORAGE_PATH)
	state.fish.clear()
	state.voyage_records.clear()
	state.letters.clear()
	state.load_memory_ledger()
	_expect(state.fish.is_empty() and state.voyage_records.is_empty(), "empty isolated ledger must not create fish or voyage records")

	state.begin_voyage()
	var together_time_before: float = state.together_time_seconds
	state.add_fish("정어리")
	state.remaining_seconds = 0.0
	state.complete_voyage()
	_expect(state.fish == ["정어리"], "caught fish must become a durable local memory")
	_expect(state.voyage_records == ["오늘의 항해 · 사진 0 · 풍경 0 · 편지 0 · 물고기 1"], "completed voyage must become one durable local summary")
	_expect(is_equal_approx(state.together_time_seconds, together_time_before), "memory ledger writing must not change together time")

	state.add_letter("저장 대상이 아닌 보류 편지")
	state.fish.clear()
	state.voyage_records.clear()
	state.letters.clear()
	state.load_memory_ledger()
	_expect(state.fish == ["정어리"], "saved fish must restore through GameState after a simulated restart")
	_expect(state.voyage_records == ["오늘의 항해 · 사진 0 · 풍경 0 · 편지 0 · 물고기 1"], "saved voyage summary must restore through GameState after a simulated restart")
	_expect(state.letters.is_empty(), "delayed bottle letters must not restore from the local memory ledger")

	state.reset_session()
	state.set_memory_ledger_storage_path("user://memory_ledger_v1.cfg")
	state.load_memory_ledger()
	_cleanup_test_storage()
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
		print("PASS: memory-ledger state contract")
		quit(0)
	else:
		printerr("FAILED: %d memory-ledger state assertions" % _failures)
		quit(1)
