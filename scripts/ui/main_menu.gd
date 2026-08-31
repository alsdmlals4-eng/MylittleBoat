# 과거 메뉴 자료의 외형 선택을 보존하되 시작 경로는 책임지지 않는다.
extends Control

const IDENTITY_CATALOG_SCRIPT = preload("res://scripts/identity/identity_visual_catalog.gd")
const TIME_OF_DAY_CATALOG_SCRIPT = preload("res://scripts/voyage/time_of_day_catalog.gd")
const REAL_TIME_ATMOSPHERE_RESOLVER_SCRIPT = preload("res://scripts/voyage/real_time_atmosphere_resolver.gd")
const ATMOSPHERE_BACKGROUNDS := {
	"dawn": preload("res://assets/images/ui/main_menu/main_menu_dawn_storybook_v1.png"),
	"bright": preload("res://assets/images/ui/main_menu/main_menu_bright_storybook_v1.png"),
	"sunset": preload("res://assets/images/ui/main_menu/main_menu_sunset_storybook_v1.png"),
	"night": preload("res://assets/images/ui/main_menu/main_menu_night_storybook_v1.png"),
}

var _identity_catalog = IDENTITY_CATALOG_SCRIPT.new()
var _time_of_day_catalog = TIME_OF_DAY_CATALOG_SCRIPT.new()
var _real_time_atmosphere_resolver = REAL_TIME_ATMOSPHERE_RESOLVER_SCRIPT.new()


func _ready() -> void:
	_connect_mood_button(%CalmButton)
	_connect_mood_button(%TiredButton)
	_connect_mood_button(%LonelyButton)
	_connect_mood_button(%ExcitedButton)
	%IdentityButton.pressed.connect(_show_identity_panel)
	%IdentityCloseButton.pressed.connect(_hide_identity_panel)
	%PlayerStyleOption.item_selected.connect(_on_player_style_selected)
	%PetTypeOption.item_selected.connect(_on_pet_type_selected)
	_populate_identity_options()
	%TimeOfDayOption.visible = false
	_refresh_identity_summary()
	refresh_atmosphere_background()


func _connect_mood_button(button: Button) -> void:
	button.pressed.connect(func() -> void:
		_start_voyage()
	)


## Starts a new direct voyage while keeping accumulated memories.
func _start_voyage() -> void:
	GameState.begin_voyage()
	get_tree().change_scene_to_file("res://scenes/game.tscn")


func _show_identity_panel() -> void:
	%IdentityPanel.visible = true
	_refresh_identity_summary()


func _hide_identity_panel() -> void:
	%IdentityPanel.visible = false


func _populate_identity_options() -> void:
	%PlayerStyleOption.clear()
	for player_style_id in _identity_catalog.get_player_style_ids():
		%PlayerStyleOption.add_item(_identity_catalog.get_player_label(player_style_id))
		%PlayerStyleOption.set_item_metadata(%PlayerStyleOption.item_count - 1, player_style_id)
	%PetTypeOption.clear()
	for pet_type_id in _identity_catalog.get_pet_type_ids():
		%PetTypeOption.add_item(_identity_catalog.get_pet_label(pet_type_id))
		%PetTypeOption.set_item_metadata(%PetTypeOption.item_count - 1, pet_type_id)
	_select_option_by_id(%PlayerStyleOption, GameState.get_selected_player_style())
	_select_option_by_id(%PetTypeOption, GameState.get_selected_pet_type())


func _on_player_style_selected(index: int) -> void:
	if index < 0 or index >= %PlayerStyleOption.item_count:
		return
	%PlayerStyleOption.select(index)
	GameState.set_selected_player_style(str(%PlayerStyleOption.get_item_metadata(index)))
	_refresh_identity_summary()


func _on_pet_type_selected(index: int) -> void:
	if index < 0 or index >= %PetTypeOption.item_count:
		return
	%PetTypeOption.select(index)
	GameState.set_selected_pet_type(str(%PetTypeOption.get_item_metadata(index)))
	_refresh_identity_summary()


## Applies a local-time atmosphere only if this legacy surface is intentionally opened.
func refresh_atmosphere_background() -> void:
	var current_time_of_day := _time_of_day_catalog.normalize_time_of_day(_real_time_atmosphere_resolver.resolve_system_time())
	%AtmosphereBackground.texture = ATMOSPHERE_BACKGROUNDS[current_time_of_day] as Texture2D


func _refresh_identity_summary() -> void:
	%IdentitySummaryLabel.text = "내 모습: %s\n동반자: %s" % [
		_identity_catalog.get_player_label(GameState.get_selected_player_style()),
		_identity_catalog.get_pet_label(GameState.get_selected_pet_type()),
	]


func _select_option_by_id(option: OptionButton, selected_id: String) -> void:
	for index in range(option.item_count):
		if str(option.get_item_metadata(index)) == selected_id:
			option.select(index)
			return
