# 항해 상태와 누적 기억 계약을 실제 GameState AutoLoad로 검증한다.
extends SceneTree

const COMFORT_STORAGE_PATH := "user://test_calm_voyage_comfort.cfg"
const MEMORY_LEDGER_STORAGE_PATH := "user://test_calm_voyage_memory_ledger.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var state := root.get_node_or_null("GameState")
	_expect(state != null, "GameState autoload must exist")
	if state == null:
		_finish()
		return

	_remove_memory_ledger_storage()
	state.set_memory_ledger_storage_path(MEMORY_LEDGER_STORAGE_PATH)
	state.photos.clear()
	state.sceneries.clear()
	state.letters.clear()
	state.fish.clear()
	state.voyage_records.clear()
	state.reset_session()
	_expect(state.has_method("set_comfort_storage_path"), "GameState must expose isolated comfort storage")
	_expect(state.has_method("set_motion_comfort_profile"), "GameState must expose a local motion comfort selector")
	_expect(state.has_method("get_motion_comfort_profile"), "GameState must expose the selected motion comfort profile")
	_expect(state.has_method("get_motion_comfort_scale"), "GameState must expose a normalized motion amplitude")
	if state.has_method("set_comfort_storage_path") and state.has_method("set_motion_comfort_profile") and state.has_method("get_motion_comfort_profile") and state.has_method("get_motion_comfort_scale"):
		_remove_test_file()
		state.set_comfort_storage_path(COMFORT_STORAGE_PATH)
		var remaining_before_comfort: float = float(state.remaining_seconds)
		var speed_before_comfort: int = int(state.speed_index)
		var together_before_comfort: float = float(state.together_time_seconds)
		state.set_motion_comfort_profile("gentle")
		_expect(state.get_motion_comfort_profile() == "gentle", "GameState must expose the selected local comfort profile")
		_expect(is_equal_approx(state.get_motion_comfort_scale(), 0.5), "gentle comfort must halve automatic motion amplitude")
		_expect(is_equal_approx(state.remaining_seconds, remaining_before_comfort), "comfort must not change voyage timer")
		_expect(state.speed_index == speed_before_comfort, "comfort must not change drift speed")
		_expect(is_equal_approx(state.together_time_seconds, together_before_comfort), "comfort must not grant together time")
		_remove_test_file()

	state.complete_voyage()
	_expect(state.voyage_records.is_empty(), "complete_voyage must not create an orphan record when no voyage is active")

	var together_time_before_memories: float = state.together_time_seconds
	state.add_photo("테스트 사진")
	state.add_scenery("테스트 풍경")
	state.add_letter("테스트 편지")
	_expect(is_equal_approx(state.together_time_seconds, together_time_before_memories), "photo, scenery, and letter memories must not create together time")
	var together_time_before_reset: float = state.together_time_seconds

	state.reset_session()
	_expect(state.photos.size() == 1, "reset_session must keep accumulated photos")
	_expect(state.sceneries.size() == 1, "reset_session must keep accumulated scenery")
	_expect(state.letters.size() == 1, "reset_session must keep accumulated letters")
	_expect(is_equal_approx(state.together_time_seconds, together_time_before_reset), "reset_session must keep accumulated together time")

	_expect(state.has_method("begin_voyage"), "GameState must expose direct begin_voyage")
	state.begin_voyage()
	_expect(state.voyage_active, "begin_voyage must activate the voyage")
	_expect(is_equal_approx(state.remaining_seconds, 300.0), "begin_voyage must start the 5-minute baseline")
	var source := FileAccess.get_file_as_string("res://scripts/core/game_state.gd")
	_expect(not source.contains("selected_mood"), "mood must not remain product state")
	_expect(not source.contains("selected_time_of_day"), "saved time preference must not remain product state")

	var early_records: int = state.voyage_records.size()
	state.complete_voyage()
	_expect(state.voyage_records.size() == early_records, "complete_voyage must not record an active voyage before its timer reaches zero")

	var fish_before: int = state.fish.size()
	var together_time_before_fish: float = state.together_time_seconds
	state.add_fish("정어리")
	state.add_fish("전갱이")
	_expect(state.fish.size() == fish_before + 2, "add_fish must append fish memories")
	_expect(is_equal_approx(state.together_time_seconds, together_time_before_fish), "repeat fishing must not create together time")

	state.remaining_seconds = 0.0
	var records_before: int = state.voyage_records.size()
	state.complete_voyage()
	state.complete_voyage()
	_expect(state.voyage_records.size() == records_before + 1, "complete_voyage must create exactly one record after the active voyage reaches zero")
	_expect(state.voyage_records.back().begins_with("오늘의 항해"), "voyage record must use neutral direct-voyage copy")

	state.set_memory_ledger_storage_path("user://memory_ledger_v1.cfg")
	_remove_memory_ledger_storage()
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _remove_test_file() -> void:
	if FileAccess.file_exists(COMFORT_STORAGE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(COMFORT_STORAGE_PATH))


func _remove_memory_ledger_storage() -> void:
	if FileAccess.file_exists(MEMORY_LEDGER_STORAGE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(MEMORY_LEDGER_STORAGE_PATH))


func _finish() -> void:
	if _failures == 0:
		print("PASS: calm voyage state contract")
		quit(0)
	else:
		printerr("FAILED: %d calm voyage state assertions" % _failures)
		quit(1)
