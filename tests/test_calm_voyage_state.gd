# 항해 상태와 누적 기억 계약을 실제 GameState AutoLoad로 검증한다.
extends SceneTree

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var state := root.get_node_or_null("GameState")
	_expect(state != null, "GameState autoload must exist")
	if state == null:
		_finish()
		return

	state.photos.clear()
	state.sceneries.clear()
	state.letters.clear()
	state.fish.clear()
	state.voyage_records.clear()
	state.companion_affection = 1
	state.reset_session()

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
	state.begin_voyage("설렘")
	_expect(state.selected_mood == "설렘", "begin_voyage must store selected mood")
	_expect(state.voyage_active, "begin_voyage must activate the voyage")
	_expect(is_equal_approx(state.remaining_seconds, 300.0), "begin_voyage must start the 5-minute baseline")

	var fish_before: int = state.fish.size()
	state.add_fish("정어리")
	_expect(state.fish.size() == fish_before + 1, "add_fish must append one fish memory")

	var records_before: int = state.voyage_records.size()
	state.complete_voyage()
	state.complete_voyage()
	_expect(state.voyage_records.size() == records_before + 1, "complete_voyage must create exactly one record per voyage")

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
