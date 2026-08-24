# 선택형 저압력 상호작용의 공통 행동 계약을 관리한다.
extends RefCounted

var _target_id := ""
var _display_name := ""
var _actions: Array[Dictionary] = []
var _state: Dictionary = {}


func configure(target_id: String, display_name: String, actions: Array) -> void:
	_target_id = target_id
	_display_name = display_name
	_actions.clear()
	_state.clear()
	for action in actions:
		if action is Dictionary:
			_actions.append(action.duplicate(true))


func get_actions(actor_context: Dictionary = {}) -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for action in _actions:
		result.append(action.duplicate(true))
	return result


func can_interact(actor_context: Dictionary, action_id: String) -> bool:
	return _find_action(action_id) >= 0


func perform(actor_context: Dictionary, action_id: String) -> Dictionary:
	var action_index := _find_action(action_id)
	if action_index < 0:
		return {
			"ok": false,
			"target_id": _target_id,
			"action_id": action_id,
			"message": "",
			"state": _state.duplicate(true),
		}

	var action: Dictionary = _actions[action_index]
	var toggle_key := str(action.get("toggle_key", ""))
	if toggle_key != "":
		_state[toggle_key] = not bool(_state.get(toggle_key, false))

	return {
		"ok": true,
		"target_id": _target_id,
		"display_name": _display_name,
		"action_id": action_id,
		"message": str(action.get("message", "")),
		"state": _state.duplicate(true),
	}


func get_state() -> Dictionary:
	return _state.duplicate(true)


func _find_action(action_id: String) -> int:
	for index in _actions.size():
		if str(_actions[index].get("id", "")) == action_id:
			return index
	return -1
