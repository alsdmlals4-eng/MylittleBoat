# 스토리북 아트 카드와 기존 메시 fallback의 표시 상태를 전환한다.
extends Sprite3D

@export var fallback_nodes: Array[NodePath] = []


func _ready() -> void:
	refresh_visual()


func refresh_visual() -> void:
	var has_art := texture != null
	visible = has_art
	for fallback_path in fallback_nodes:
		var fallback := get_node_or_null(fallback_path) as VisualInstance3D
		if fallback != null:
			fallback.visible = not has_art
