# 선택된 외형 카드를 보트 디오라마의 실제 표시 경로에 적용한다.
extends Node

const CATALOG_SCRIPT = preload("res://scripts/identity/identity_visual_catalog.gd")
const DECOR_VISUAL_ASSETS_SCRIPT = preload("res://scripts/decor/decor_visual_assets.gd")

var _catalog = CATALOG_SCRIPT.new()
var _decor_visual_assets = DECOR_VISUAL_ASSETS_SCRIPT.new()
var _player_style_id := "c_loose_knit"
var _pet_type_id := "dog"

@onready var _boat_space := get_parent()
@onready var _final_diorama_card := _boat_space.get_node_or_null("FinalDioramaCard") as Sprite3D
@onready var _shared_hull_pass := _boat_space.get_node_or_null("BoatBow/VisualStudy/StorybookHullPass") as Node3D
@onready var _avatar_cards := _boat_space.get_node_or_null("PlayerAvatarPlaceholder/VisualStudy/AvatarCards")
@onready var _pet_cards := _boat_space.get_node_or_null("RestingPetPlaceholder/VisualStudy/PetCards")
@onready var _default_avatar_card := _boat_space.get_node_or_null("PlayerAvatarPlaceholder/VisualStudy/StorybookCDefault") as Node3D
@onready var _default_pet_card := _boat_space.get_node_or_null("RestingPetPlaceholder/VisualStudy/StorybookDogDefault") as Node3D
@onready var _pet_corner_slot := _boat_space.get_node_or_null("BoatDecorSlots/PetCorner") as Node3D
@onready var _rail_accent_slot := _boat_space.get_node_or_null("BoatDecorSlots/RailAccent") as Node3D
@onready var _storybook_pet_cushion_surface := _boat_space.get_node_or_null("StorybookPetCushionSurface") as Sprite3D
@onready var _storybook_postcard_surface := _boat_space.get_node_or_null("StorybookPostcardSurface") as Sprite3D


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
	_sync_final_composite_decor(is_default)


func sync_decor_from_state() -> void:
	var is_default: bool = _player_style_id == _catalog.DEFAULT_PLAYER_STYLE and _pet_type_id == _catalog.DEFAULT_PET_TYPE
	_sync_final_composite_decor(is_default)


func get_active_visual_route() -> Dictionary:
	var is_default: bool = _player_style_id == _catalog.DEFAULT_PLAYER_STYLE and _pet_type_id == _catalog.DEFAULT_PET_TYPE
	return {
		"mode": "final_composite" if is_default else "layered_subjects",
		"player_style_id": _player_style_id,
		"pet_type_id": _pet_type_id,
	}


func _sync_final_composite_decor(is_default: bool) -> void:
	if _pet_corner_slot != null:
		_pet_corner_slot.visible = not is_default
	if _rail_accent_slot != null:
		_rail_accent_slot.visible = not is_default
	var cushion_active := is_default and GameState.get_boat_decor("pet_corner") == "pet_cushion"
	if _storybook_pet_cushion_surface != null:
		_storybook_pet_cushion_surface.visible = cushion_active
		_set_cushion_surface_texture(_decor_visual_assets.load_texture_if_available(_decor_visual_assets.get_cushion_texture_path(GameState.get_boat_decor_appearance("pet_corner"))) if cushion_active else null)
	var postcard_active := is_default and GameState.get_boat_decor("rail_accent") == "postcard"
	if _storybook_postcard_surface != null:
		_storybook_postcard_surface.visible = postcard_active
		_storybook_postcard_surface.texture = _decor_visual_assets.load_texture_if_available(_decor_visual_assets.get_postcard_texture_path()) if postcard_active else null


func _set_cushion_surface_texture(texture: Texture2D) -> void:
	if _storybook_pet_cushion_surface == null:
		return
	_storybook_pet_cushion_surface.texture = texture
	var material := _storybook_pet_cushion_surface.material_override as ShaderMaterial
	if material != null:
		material.set_shader_parameter("source_texture", texture)


func _set_group_visibility(group: Node, selected_id: String, group_visible: bool) -> void:
	if group == null:
		return
	for child in group.get_children():
		var visual := child as Node3D
		if visual != null:
			visual.visible = group_visible and visual.name == selected_id
