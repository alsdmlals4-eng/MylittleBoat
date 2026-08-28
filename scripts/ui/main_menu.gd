# 구형 시작 메뉴 경로를 첫 보트 화면으로 안전하게 연결한다.
extends Control


func _ready() -> void:
	call_deferred("_enter_direct_boat_scene")


func _enter_direct_boat_scene() -> void:
	if not GameState.voyage_active:
		GameState.begin_voyage()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
