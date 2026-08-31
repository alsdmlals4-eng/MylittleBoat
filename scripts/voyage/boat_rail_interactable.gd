# 보트 난간의 선택형 휴식 상호작용을 제공한다.
extends Node3D

const INTERACTION_SCRIPT = preload("res://scripts/interaction/low_pressure_interactable.gd")

var _interaction = INTERACTION_SCRIPT.new()


func _ready() -> void:
	_interaction.configure("rail", "보트 난간", [
		{"id": "lean", "label": "기대기", "message": "난간에 기대어 파도를 천천히 바라봅니다."},
		{"id": "look_at_sea", "label": "바다 바라보기", "message": "난간 너머의 잔잔한 바다를 바라봅니다."},
		{"id": "listen_to_waves", "label": "파도 소리 듣기", "message": "난간에 기대어 작은 물결 소리를 듣습니다.", "moment_id": "rail_listen_to_waves"},
	])


func get_actions(actor_context: Dictionary = {}) -> Array[Dictionary]:
	return _interaction.get_actions(actor_context)


func can_interact(actor_context: Dictionary, action_id: String) -> bool:
	return _interaction.can_interact(actor_context, action_id)


func perform(actor_context: Dictionary, action_id: String) -> Dictionary:
	return _interaction.perform(actor_context, action_id)
