# 동반자와 난간의 짧은 휴식 반응이 실제 결과를 돌려주는지 검증한다.
extends SceneTree

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var pet_script := load("res://scripts/voyage/resting_pet_placeholder.gd") as Script
	_expect(pet_script != null, "resting pet interaction owner must load")
	if pet_script != null:
		var pet := Node3D.new()
		pet.set_script(pet_script)
		root.add_child(pet)
		await process_frame
		_expect(_has_action(pet.call("get_actions", {}), "rest_together"), "pet must offer a quiet rest-together action")
		var pet_result: Dictionary = pet.call("perform", {}, "rest_together")
		_expect(bool(pet_result.get("ok", false)), "rest-together action must complete")
		_expect(str(pet_result.get("moment_id", "")) == "pet_rest_together", "pet rest must identify its short private moment")
		_expect(pet.call("get_resting_state") == "rest", "pet rest must use the existing calm resting pose")
		pet.queue_free()
		await process_frame

	var rail_script := load("res://scripts/voyage/boat_rail_interactable.gd") as Script
	_expect(rail_script != null, "boat rail interaction owner must load")
	if rail_script != null:
		var rail := Node3D.new()
		rail.set_script(rail_script)
		root.add_child(rail)
		await process_frame
		_expect(_has_action(rail.call("get_actions", {}), "listen_to_waves"), "rail must offer a quiet listen-to-waves action")
		var rail_result: Dictionary = rail.call("perform", {}, "listen_to_waves")
		_expect(bool(rail_result.get("ok", false)), "listen-to-waves action must complete")
		_expect(str(rail_result.get("moment_id", "")) == "rail_listen_to_waves", "rail action must identify its short private moment")
		_expect(not str(rail_result.get("message", "")).is_empty(), "interaction result must retain a player-facing quiet message")
		rail.queue_free()
		await process_frame
	_finish()


func _has_action(actions: Array, action_id: String) -> bool:
	for action in actions:
		if action is Dictionary and str(action.get("id", "")) == action_id:
			return true
	return false


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: interaction content contract")
		quit(0)
	else:
		printerr("FAILED: %d interaction content assertions" % _failures)
		quit(1)
