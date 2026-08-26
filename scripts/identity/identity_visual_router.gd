# 선택된 외형 카드를 보트 디오라마의 실제 표시 경로에 적용한다.
extends Node

const CATALOG_SCRIPT = preload("res://scripts/identity/identity_visual_catalog.gd")

var _catalog = CATALOG_SCRIPT.new()
var _player_style_id := "c_loose_knit"
var _pet_type_id := "dog"

@onready var _boat_space := get_parent()
@onready var _final_diorama_card := _boat_space.get_node_or_null("FinalDioramaCard") as Sprite3D
@onready var _shared_hull_pass := _boat_space.get_node_or_null("BoatBow/VisualStudy/StorybookHullPass") as Node3D
@onready var _avatar_cards := _boat_space.get_node_or_null("PlayerAvatarPlaceholder/VisualStudy/AvatarCards")
@onready var _pet_cards := _boat_space.get_node_or_null("RestingPetPlaceholder/VisualStudy/PetCards")
@onready var _default_avatar_card := _boat_space.get_node_or_null("PlayerAvatarPlaceholder/VisualStudy/StorybookCDefault") as Node3D
@onready var _default_pet_card := _boat_space.get_node_or_null("RestingPetPlaceholder/VisualStudy/StorybookDogDefault") as Node3D


func _ready() -> void:
	apply_selection(GameState.get_selected_player_style(), GameState.get_selected_pet_type())


func apply_selection(player_style_id: String, pet_type_id: String) -> void:
	_player_style_id = _catalog.normalize_player_style(player_style_id)
	_pet_type_id = _catalog.normalize_pet_type(pet_type_id)
	var is_default: bool = _player_style_id == _catalog.DEFAULT_PLAYER_STYLE and _pet_type_id == _catalog.DEFAULT_PET_TYPE
	if _final_diorama_card != null:
		_final_diorama_card.visible = is_default
	if _shared_hull_pass != null:
		_shared_hull_pass.visible = not is_default
	_set_group_visibility(_avatar_cards, _player_style_id, not is_default)
	_set_group_visibility(_pet_cards, _pet_type_id, not is_default)
	if _default_avatar_card != null:
		_default_avatar_card.visible = not is_default and _player_style_id == _catalog.DEFAULT_PLAYER_STYLE
	if _default_pet_card != null:
		_default_pet_card.visible = not is_default and _pet_type_id == _catalog.DEFAULT_PET_TYPE


func get_active_visual_route() -> Dictionary:
	var is_default: bool = _player_style_id == _catalog.DEFAULT_PLAYER_STYLE and _pet_type_id == _catalog.DEFAULT_PET_TYPE
	return {
		"mode": "final_composite" if is_default else "layered_subjects",
		"player_style_id": _player_style_id,
		"pet_type_id": _pet_type_id,
	}


func _set_group_visibility(group: Node, selected_id: String, group_visible: bool) -> void:
	if group == null:
		return
	for child in group.get_children():
		var visual := child as Node3D
		if visual != null:
			visual.visible = group_visible and visual.name == selected_id
