# 항해 상태와 누적 기억 계약을 검증한다.
extends SceneTree

var _failures := 0


func _init() -> void:
	var state_script := load("res://scripts/core/game_state.gd")
	_expect(state_script != null, "GameState script must load")
	if state_script == null:
		_finish()
		return

	var state: Node = state_script.new()
	state.add_photo("테스트 사진")
	state.add_scenery("테스트 풍경")
	state.add_letter("테스트 편지")
	var affection_before_reset: int = state.companion_affection

	state.reset_session()
	_expect(state.photos.size() == 1, "reset_session must keep accumulated photos")
	_expect(state.sceneries.size() == 1, "reset_session must keep accumulated scenery")
	_expect(state.letters.size() == 1, "reset_session must keep accumulated letters")
	_expect(state.companion_affection == affection_before_reset, "reset_session must keep companion progress")

	_expect(state.has_method("begin_voyage"), "GameState must expose begin_voyage(mood)")
	if state.has_method("begin_voyage"):
		state.call("begin_voyage", "설렘")
		_expect(state.selected_mood == "설렘", "begin_voyage must store selected mood")
		_expect(bool(state.get("voyage_active")), "begin_voyage must activate the voyage")
		_expect(is_equal_approx(float(state.get("remaining_seconds")), 300.0), "begin_voyage must start the 5-minute baseline")

	var fish_value: Variant = state.get("fish")
	_expect(fish_value is Array, "GameState must own a fish memory collection")
	_expect(state.has_method("add_fish"), "GameState must expose add_fish(entry)")
	if state.has_method("add_fish") and fish_value is Array:
		var fish_before: int = fish_value.size()
		state.call("add_fish", "정어리")
		_expect((state.get("fish") as Array).size() == fish_before + 1, "add_fish must append one fish memory")

	var voyage_records_value: Variant = state.get("voyage_records")
	_expect(voyage_records_value is Array, "GameState must own voyage_records")
	_expect(state.has_method("complete_voyage"), "GameState must expose complete_voyage()")
	if state.has_method("complete_voyage") and voyage_records_value is Array:
		var records_before: int = voyage_records_value.size()
		state.call("complete_voyage")
		state.call("complete_voyage")
		_expect((state.get("voyage_records") as Array).size() == records_before + 1, "complete_voyage must create exactly one record per voyage")

	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: calm voyage state contract")
		quit(0)
	else:
		printerr("FAILED: %d calm voyage state assertions" % _failures)
		quit(1)
