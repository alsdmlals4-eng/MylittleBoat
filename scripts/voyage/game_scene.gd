# 5분 항해의 디오라마·보트 생활공간·발견·낚시 상호작용을 관리한다.
extends Control

const FISHING_SESSION_SCRIPT = preload("res://scripts/voyage/fishing_session.gd")
const DECOR_CATALOG_SCRIPT = preload("res://scripts/decor/boat_decor_catalog.gd")
const DECOR_VISUAL_ASSETS_SCRIPT = preload("res://scripts/decor/decor_visual_assets.gd")
const IDENTITY_VISUAL_CATALOG_SCRIPT = preload("res://scripts/identity/identity_visual_catalog.gd")
const TIME_OF_DAY_CATALOG_SCRIPT = preload("res://scripts/voyage/time_of_day_catalog.gd")
const REAL_TIME_ATMOSPHERE_RESOLVER_SCRIPT = preload("res://scripts/voyage/real_time_atmosphere_resolver.gd")
const DRIFT_SCENERY_DIRECTOR_SCRIPT = preload("res://scripts/voyage/drift_scenery_director.gd")
const DISTANT_SCENERY_SCENE = preload("res://scenes/distant_scenery.tscn")
const DISTANT_SCENERY_TEXTURES := {
	"buoy": preload("res://assets/images/runtime/scenery/distant_buoy_storybook.png"),
	"islet": preload("res://assets/images/runtime/scenery/distant_islet_storybook.png"),
	"lighthouse": preload("res://assets/images/runtime/scenery/distant_lighthouse_storybook.png"),
}
const SEA_BACKDROP_TEXTURES := {
	"default": preload("res://assets/images/runtime/storybook/sea_bright_storybook.png"),
	"night": preload("res://assets/images/runtime/storybook/sea_night_indigo_rain_storybook.png"),
}
const DISTANT_SCENERY_LABELS := {
	"buoy": "작은 부표",
	"islet": "작은 섬",
	"lighthouse": "먼 등대",
}

const SPEED_NAMES: Array[String] = ["느림", "보통", "빠름"]
const SPEED_MULTIPLIERS: Array[float] = [0.65, 1.0, 1.45]
const FISH_NAMES: Array[String] = ["정어리", "전갱이", "고등어", "도미"]
const DECOR_SLOT_NODE_NAMES := {
	"bow_left": "BowLeft",
	"bow_right": "BowRight",
	"center_left": "CenterLeft",
	"center_right": "CenterRight",
	"rear_left": "RearLeft",
	"rear_right": "RearRight",
	"rail_accent": "RailAccent",
	"pet_corner": "PetCorner",
}
const FISHING_WAIT_MIN_SECONDS := 6.0
const FISHING_WAIT_MAX_SECONDS := 12.0
const ATMOSPHERE_REFRESH_SECONDS := 30.0
const DISTANT_SCENERY_DRIFT_PER_SECOND := 8.0
const MEMORY_NOTIFICATION_SECONDS := 2.5
const DISTANT_SCENERY_SIZES := {
	"buoy": Vector2(48, 96),
	"islet": Vector2(156, 88),
	"lighthouse": Vector2(72, 128),
}

var _fishing_session = FISHING_SESSION_SCRIPT.new()
var _decor_catalog = DECOR_CATALOG_SCRIPT.new()
var _decor_visual_assets = DECOR_VISUAL_ASSETS_SCRIPT.new()
var _identity_visual_catalog = IDENTITY_VISUAL_CATALOG_SCRIPT.new()
var _time_of_day_catalog = TIME_OF_DAY_CATALOG_SCRIPT.new()
var _real_time_atmosphere_resolver = REAL_TIME_ATMOSPHERE_RESOLVER_SCRIPT.new()
var _drift_scenery_director = DRIFT_SCENERY_DIRECTOR_SCRIPT.new()
var _active_distant_scenery: Array[Control] = []
var _memory_notification_remaining := 0.0
var _drift_phase := 0.0
var _diorama_camera_base_position := Vector3.ZERO
var _appreciation_camera_base_position := Vector3.ZERO
var _boat_space_base_position := Vector3.ZERO
var _time_of_day_background_color := Color(0.58, 0.76, 0.86, 1.0)
var _rest_menu_open := false
var _current_atmosphere_id := ""
var _application_foreground := true
var _atmosphere_tween: Tween


func _ready() -> void:
	randomize()
	if not GameState.voyage_active:
		GameState.begin_voyage()
	_diorama_camera_base_position = $VoyageWorld/DioramaCameraRig.position
	_appreciation_camera_base_position = $VoyageWorld/AppreciationCameraRig.position
	_boat_space_base_position = $VoyageWorld/BoatSpace.position
	%AtmosphereRefreshTimer.timeout.connect(_refresh_real_time_atmosphere)
	%AtmosphereRefreshTimer.start(ATMOSPHERE_REFRESH_SECONDS)
	_refresh_real_time_atmosphere(false)
	_apply_stored_boat_decor()
	%RestMenuButton.pressed.connect(_toggle_rest_menu)
	%TakePhotoButton.pressed.connect(_take_photo)
	%AppreciationButton.pressed.connect(_toggle_appreciation_mode)
	%SpeedButton.pressed.connect(_cycle_speed)
	%FishingButton.pressed.connect(_handle_fishing_action)
	%DecorButton.pressed.connect(_open_decor_panel)
	%InteractButton.pressed.connect(_open_interaction_panel)
	%DecorSlotOption.item_selected.connect(_on_decor_slot_selected)
	%DecorItemOption.item_selected.connect(_on_decor_item_selected)
	%PlayerStyleOption.item_selected.connect(_on_player_style_selected)
	%PetTypeOption.item_selected.connect(_on_pet_type_selected)
	%DecorApplyButton.pressed.connect(_apply_selected_decor)
	%DecorClearButton.pressed.connect(_clear_selected_decor)
	%DecorCloseButton.pressed.connect(_close_decor_panel)
	%InteractionTargetOption.item_selected.connect(_on_interaction_target_selected)
	%InteractionPerformButton.pressed.connect(_perform_selected_interaction)
	%InteractionCloseButton.pressed.connect(_close_interaction_panel)
	%AlbumButton.pressed.connect(_open_album)
	%NextVoyageButton.pressed.connect(_start_next_voyage)
	_populate_identity_options()
	_populate_decor_slot_options()
	_apply_appreciation_mode()
	var message := "동반자가 곁에서 조용히 바다를 바라봅니다."
	if GameState.remaining_seconds < 299.9 and not GameState.voyage_record_created:
		message = "바다로 돌아왔습니다. 이어서 천천히 항해합니다."
	elif GameState.voyage_record_created:
		message = "오늘의 항해 기록이 남아 있습니다. 더 머물거나 다음 항해를 준비해도 좋아요."
	_update_ui(message)


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_APPLICATION_FOCUS_IN, NOTIFICATION_APPLICATION_RESUMED:
			set_application_foreground(true)
		NOTIFICATION_APPLICATION_FOCUS_OUT, NOTIFICATION_APPLICATION_PAUSED:
			set_application_foreground(false)


func set_application_foreground(is_foreground: bool) -> void:
	_application_foreground = is_foreground
	if _application_foreground:
		_refresh_real_time_atmosphere(true)


func is_application_foreground() -> bool:
	return _application_foreground


func _refresh_real_time_atmosphere(allow_transition: bool = true) -> void:
	_apply_time_of_day_tone(_real_time_atmosphere_resolver.resolve_system_time(), allow_transition)


func apply_real_time_atmosphere_for_hour(hour: int) -> String:
	var atmosphere_id := _real_time_atmosphere_resolver.resolve_hour(hour)
	_apply_time_of_day_tone(atmosphere_id, false)
	return atmosphere_id


func _process(delta: float) -> void:
	_apply_drift_motion(delta)
	_advance_fishing(delta)
	_advance_distant_scenery(delta)
	_advance_memory_notification(delta)
	var completed_now := GameState.tick_voyage(delta)
	if completed_now:
		GameState.complete_voyage()
		_sync_next_voyage_button()
		_update_ui("오늘의 항해 기록이 만들어졌습니다. 더 머물거나 다음 항해를 준비해도 좋아요.")
	else:
		_update_ui()


func _apply_time_of_day_tone(atmosphere_id: String, allow_transition: bool = false) -> void:
	var tone := _time_of_day_catalog.get_visual_tone(atmosphere_id)
	_time_of_day_background_color = tone["background_color"] as Color
	var world_environment := $VoyageWorld/WorldEnvironment as WorldEnvironment
	var sun_light := $VoyageWorld/SunLight as DirectionalLight3D
	var backdrop_modulate := tone["backdrop_modulate"] as Color
	_apply_sea_backdrop_art(atmosphere_id)
	var should_transition := allow_transition and _current_atmosphere_id != "" and _current_atmosphere_id != atmosphere_id
	_current_atmosphere_id = atmosphere_id
	if not should_transition:
		_apply_atmosphere_values(world_environment, sun_light, tone, backdrop_modulate)
		return
	if _atmosphere_tween != null and _atmosphere_tween.is_valid():
		_atmosphere_tween.kill()
	_atmosphere_tween = create_tween().set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	if world_environment.environment != null:
		_atmosphere_tween.tween_property(world_environment.environment, "background_color", _time_of_day_background_color, 1.5)
		_atmosphere_tween.parallel().tween_property(world_environment.environment, "ambient_light_color", tone["ambient_color"] as Color, 1.5)
		_atmosphere_tween.parallel().tween_property(world_environment.environment, "ambient_light_energy", float(tone["ambient_energy"]), 1.5)
	_atmosphere_tween.parallel().tween_property(sun_light, "light_color", tone["light_color"] as Color, 1.5)
	_atmosphere_tween.parallel().tween_property(sun_light, "light_energy", float(tone["light_energy"]), 1.5)
	_atmosphere_tween.parallel().tween_property($VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop, "modulate", backdrop_modulate, 1.5)
	_atmosphere_tween.parallel().tween_property($VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeaBackdrop, "modulate", backdrop_modulate, 1.5)
	_atmosphere_tween.parallel().tween_property($VoyageWorld/BoatSpace/BoatWaterlineOverlay, "modulate", backdrop_modulate, 1.5)


func _apply_atmosphere_values(world_environment: WorldEnvironment, sun_light: DirectionalLight3D, tone: Dictionary, backdrop_modulate: Color) -> void:
	if world_environment.environment != null:
		world_environment.environment.background_color = _time_of_day_background_color
		world_environment.environment.ambient_light_color = tone["ambient_color"] as Color
		world_environment.environment.ambient_light_energy = float(tone["ambient_energy"])
	sun_light.light_color = tone["light_color"] as Color
	sun_light.light_energy = float(tone["light_energy"])
	$VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop.modulate = backdrop_modulate
	$VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeaBackdrop.modulate = backdrop_modulate
	$VoyageWorld/BoatSpace/BoatWaterlineOverlay.modulate = backdrop_modulate


func _apply_sea_backdrop_art(atmosphere_id: String) -> void:
	var texture_key := "night" if atmosphere_id == "night" else "default"
	var backdrop_texture := SEA_BACKDROP_TEXTURES[texture_key] as Texture2D
	$VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop.texture = backdrop_texture
	$VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeaBackdrop.texture = backdrop_texture


func _take_photo() -> void:
	GameState.add_photo("사진 %d - 오늘의 바다" % [GameState.photos.size() + 1])
	_update_ui("사진을 한 장 남겼습니다. 동반자가 가까이 다가옵니다.")


func _toggle_appreciation_mode() -> void:
	if _fishing_session.is_waiting() or _fishing_session.is_bite_ready():
		_fishing_session.cancel()
		%FishingButton.text = "낚시"
		_set_fishing_status("")
	GameState.appreciation_mode = not GameState.appreciation_mode
	_apply_appreciation_mode()
	var message := "감상모드로 전환했습니다. 바다만 천천히 바라봅니다." if GameState.appreciation_mode else "보트 디오라마로 돌아왔습니다."
	_update_ui(message)


func get_active_camera_mode() -> String:
	return "appreciation" if GameState.appreciation_mode else "diorama"


func _apply_camera_mode() -> void:
	$VoyageWorld/DioramaCameraRig/DioramaCamera3D.current = not GameState.appreciation_mode
	$VoyageWorld/AppreciationCameraRig/AppreciationCamera3D.current = GameState.appreciation_mode
	$VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop.visible = not GameState.appreciation_mode
	$VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeaBackdrop.visible = GameState.appreciation_mode


func apply_boat_decor(slot_id: String, item_id: String, appearance_id: String = "") -> bool:
	if not _decor_catalog.is_compatible(slot_id, item_id):
		return false
	var slot: Node = _get_decor_slot(slot_id)
	if slot == null or not slot.has_method("apply_item"):
		return false
	if not bool(slot.call("apply_item", item_id, appearance_id)):
		return false
	GameState.set_boat_decor(slot_id, item_id)
	if item_id == "pet_cushion" and slot.has_method("get_appearance_id"):
		GameState.set_boat_decor_appearance(slot_id, str(slot.call("get_appearance_id")))
	else:
		GameState.set_boat_decor_appearance(slot_id, "")
	_sync_identity_decor_visuals()
	return true


func clear_boat_decor(slot_id: String) -> void:
	var slot: Node = _get_decor_slot(slot_id)
	if slot != null and slot.has_method("apply_item"):
		slot.call("apply_item", "")
	GameState.set_boat_decor(slot_id, "")
	_sync_identity_decor_visuals()


func _apply_stored_boat_decor() -> void:
	for slot_id in _decor_catalog.get_slot_ids():
		var item_id := GameState.get_boat_decor(slot_id)
		if item_id == "":
			clear_boat_decor(slot_id)
		elif not apply_boat_decor(slot_id, item_id, GameState.get_boat_decor_appearance(slot_id)):
			clear_boat_decor(slot_id)


func _get_decor_slot(slot_id: String) -> Node:
	if not DECOR_SLOT_NODE_NAMES.has(slot_id):
		return null
	return get_node_or_null("VoyageWorld/BoatSpace/BoatDecorSlots/%s" % str(DECOR_SLOT_NODE_NAMES[slot_id]))


func _sync_identity_decor_visuals() -> void:
	var identity_visual_router := $VoyageWorld/BoatSpace/IdentityVisualRouter
	if identity_visual_router != null and identity_visual_router.has_method("apply_selection"):
		identity_visual_router.apply_selection(GameState.get_selected_player_style(), GameState.get_selected_pet_type())
	if identity_visual_router != null and identity_visual_router.has_method("sync_decor_from_state"):
		identity_visual_router.sync_decor_from_state()


func _populate_identity_options() -> void:
	%PlayerStyleOption.clear()
	for player_style_id in _identity_visual_catalog.get_player_style_ids():
		%PlayerStyleOption.add_item(_identity_visual_catalog.get_player_label(player_style_id))
		%PlayerStyleOption.set_item_metadata(%PlayerStyleOption.item_count - 1, player_style_id)
	%PetTypeOption.clear()
	for pet_type_id in _identity_visual_catalog.get_pet_type_ids():
		%PetTypeOption.add_item(_identity_visual_catalog.get_pet_label(pet_type_id))
		%PetTypeOption.set_item_metadata(%PetTypeOption.item_count - 1, pet_type_id)
	_select_option_by_metadata(%PlayerStyleOption, GameState.get_selected_player_style())
	_select_option_by_metadata(%PetTypeOption, GameState.get_selected_pet_type())


func _on_player_style_selected(index: int) -> void:
	if index < 0 or index >= %PlayerStyleOption.item_count:
		return
	%PlayerStyleOption.select(index)
	GameState.set_selected_player_style(str(%PlayerStyleOption.get_item_metadata(index)))
	_sync_identity_decor_visuals()


func _on_pet_type_selected(index: int) -> void:
	if index < 0 or index >= %PetTypeOption.item_count:
		return
	%PetTypeOption.select(index)
	GameState.set_selected_pet_type(str(%PetTypeOption.get_item_metadata(index)))
	_sync_identity_decor_visuals()


func _select_option_by_metadata(option: OptionButton, value: String) -> void:
	for index in option.item_count:
		if str(option.get_item_metadata(index)) == value:
			option.select(index)
			return
	if option.item_count > 0:
		option.select(0)


func _populate_decor_slot_options() -> void:
	%DecorSlotOption.clear()
	for slot_id in _decor_catalog.get_slot_ids():
		%DecorSlotOption.add_item(_decor_catalog.get_slot_label(slot_id))
		%DecorSlotOption.set_item_metadata(%DecorSlotOption.item_count - 1, slot_id)
	if %DecorSlotOption.item_count > 0:
		%DecorSlotOption.select(0)
	_refresh_decor_item_options()


func _on_decor_slot_selected(_index: int) -> void:
	_refresh_decor_item_options()


func _on_decor_item_selected(_index: int) -> void:
	_refresh_decor_appearance_options()


func _refresh_decor_item_options() -> void:
	%DecorItemOption.clear()
	var slot_id := _get_selected_metadata(%DecorSlotOption)
	if slot_id == "":
		return
	var compatible_items := _decor_catalog.get_compatible_item_ids(slot_id)
	var stored_item := GameState.get_boat_decor(slot_id)
	var stored_index := -1
	for item_id in compatible_items:
		var definition := _decor_catalog.get_item_definition(item_id)
		%DecorItemOption.add_item(str(definition.get("label", item_id)))
		var index: int = %DecorItemOption.item_count - 1
		%DecorItemOption.set_item_metadata(index, item_id)
		if item_id == stored_item:
			stored_index = index
	if %DecorItemOption.item_count > 0:
		%DecorItemOption.select(stored_index if stored_index >= 0 else 0)
	_refresh_decor_appearance_options()


func _refresh_decor_appearance_options() -> void:
	%DecorAppearanceOption.clear()
	var item_id := _get_selected_metadata(%DecorItemOption)
	var slot_id := _get_selected_metadata(%DecorSlotOption)
	var is_pet_cushion := item_id == "pet_cushion"
	%DecorAppearanceOption.visible = is_pet_cushion
	if not is_pet_cushion:
		return
	var stored_appearance := GameState.get_boat_decor_appearance(slot_id)
	var selected_index := 0
	for appearance_id in _decor_visual_assets.get_cushion_appearance_ids():
		%DecorAppearanceOption.add_item(_decor_visual_assets.get_cushion_appearance_label(appearance_id))
		var index: int = %DecorAppearanceOption.item_count - 1
		%DecorAppearanceOption.set_item_metadata(index, appearance_id)
		if appearance_id == stored_appearance:
			selected_index = index
	if %DecorAppearanceOption.item_count > 0:
		%DecorAppearanceOption.select(selected_index)


func _apply_selected_decor() -> void:
	var slot_id := _get_selected_metadata(%DecorSlotOption)
	var item_id := _get_selected_metadata(%DecorItemOption)
	if slot_id == "" or item_id == "":
		return
	var appearance_id := _get_selected_metadata(%DecorAppearanceOption) if item_id == "pet_cushion" else ""
	if apply_boat_decor(slot_id, item_id, appearance_id):
		var definition := _decor_catalog.get_item_definition(item_id)
		_update_ui("%s에 %s을 조용히 놓았습니다." % [_decor_catalog.get_slot_label(slot_id), str(definition.get("label", item_id))])
		_refresh_interaction_targets()


func _clear_selected_decor() -> void:
	var slot_id := _get_selected_metadata(%DecorSlotOption)
	if slot_id == "":
		return
	clear_boat_decor(slot_id)
	_update_ui("%s 자리를 비웠습니다. 잃는 것은 없습니다." % _decor_catalog.get_slot_label(slot_id))
	_refresh_decor_item_options()
	_refresh_interaction_targets()


func _open_decor_panel() -> void:
	if GameState.appreciation_mode:
		return
	$InteractionPanel.visible = false
	$DecorPanel.visible = true
	_refresh_decor_item_options()


func _close_decor_panel() -> void:
	$DecorPanel.visible = false


func _open_interaction_panel() -> void:
	if GameState.appreciation_mode:
		return
	$DecorPanel.visible = false
	$InteractionPanel.visible = true
	_refresh_interaction_targets()


func _close_interaction_panel() -> void:
	$InteractionPanel.visible = false


func get_interaction_target_ids() -> Array[String]:
	var result: Array[String] = []
	for target_id in ["pet", "rail"]:
		var node := _get_interaction_target_node(target_id)
		if node != null and node.has_method("get_actions") and not node.call("get_actions", {}).is_empty():
			result.append(target_id)
	for slot_id in _decor_catalog.get_slot_ids():
		var slot := _get_decor_slot(slot_id)
		if slot == null or GameState.get_boat_decor(slot_id) == "":
			continue
		if slot.has_method("get_actions") and not slot.call("get_actions", {}).is_empty():
			result.append("decor:%s" % slot_id)
	return result


func perform_interaction(target_id: String, action_id: String) -> Dictionary:
	var target := _get_interaction_target_node(target_id)
	if target == null or not target.has_method("can_interact") or not target.has_method("perform"):
		return {"ok": false, "target_id": target_id, "action_id": action_id, "message": ""}
	if not bool(target.call("can_interact", {}, action_id)):
		return {"ok": false, "target_id": target_id, "action_id": action_id, "message": ""}
	return target.call("perform", {}, action_id)


func _get_interaction_target_node(target_id: String) -> Node:
	if target_id == "pet":
		return get_node_or_null("VoyageWorld/BoatSpace/RestingPetPlaceholder")
	if target_id == "rail":
		return get_node_or_null("VoyageWorld/BoatSpace/BoatRail")
	if target_id.begins_with("decor:"):
		return _get_decor_slot(target_id.trim_prefix("decor:"))
	return null


func _get_interaction_target_label(target_id: String) -> String:
	if target_id == "pet":
		return "동반자"
	if target_id == "rail":
		return "보트 난간"
	if target_id.begins_with("decor:"):
		var slot_id := target_id.trim_prefix("decor:")
		var item_id := GameState.get_boat_decor(slot_id)
		var definition := _decor_catalog.get_item_definition(item_id)
		return "%s · %s" % [_decor_catalog.get_slot_label(slot_id), str(definition.get("label", item_id))]
	return target_id


func _refresh_interaction_targets() -> void:
	%InteractionTargetOption.clear()
	for target_id in get_interaction_target_ids():
		%InteractionTargetOption.add_item(_get_interaction_target_label(target_id))
		%InteractionTargetOption.set_item_metadata(%InteractionTargetOption.item_count - 1, target_id)
	if %InteractionTargetOption.item_count > 0:
		%InteractionTargetOption.select(0)
	_refresh_interaction_actions()


func _on_interaction_target_selected(_index: int) -> void:
	_refresh_interaction_actions()


func _refresh_interaction_actions() -> void:
	%InteractionActionOption.clear()
	var target_id := _get_selected_metadata(%InteractionTargetOption)
	var target := _get_interaction_target_node(target_id)
	if target == null or not target.has_method("get_actions"):
		return
	var actions: Array = target.call("get_actions", {})
	for action in actions:
		if not action is Dictionary:
			continue
		var action_id := str(action.get("id", ""))
		if action_id == "":
			continue
		%InteractionActionOption.add_item(str(action.get("label", action_id)))
		%InteractionActionOption.set_item_metadata(%InteractionActionOption.item_count - 1, action_id)
	if %InteractionActionOption.item_count > 0:
		%InteractionActionOption.select(0)


func _perform_selected_interaction() -> void:
	var target_id := _get_selected_metadata(%InteractionTargetOption)
	var action_id := _get_selected_metadata(%InteractionActionOption)
	if target_id == "" or action_id == "":
		return
	var result := perform_interaction(target_id, action_id)
	if bool(result.get("ok", false)):
		_update_ui(str(result.get("message", "")))


func _get_selected_metadata(option: OptionButton) -> String:
	if option == null or option.item_count <= 0 or option.selected < 0:
		return ""
	return str(option.get_item_metadata(option.selected))


func _cycle_speed() -> void:
	GameState.speed_index = (GameState.speed_index + 1) % SPEED_NAMES.size()
	_update_ui("표류 리듬을 %s으로 바꿨습니다." % SPEED_NAMES[GameState.speed_index])


func _apply_drift_motion(delta: float) -> void:
	var speed_index := clampi(GameState.speed_index, 0, SPEED_MULTIPLIERS.size() - 1)
	_drift_phase += maxf(delta, 0.0) * SPEED_MULTIPLIERS[speed_index]
	$VoyageWorld/DioramaCameraRig.position.y = _diorama_camera_base_position.y + sin(_drift_phase * 1.2) * 0.018
	$VoyageWorld/AppreciationCameraRig.position.y = _appreciation_camera_base_position.y + sin(_drift_phase * 1.2) * 0.025
	var boat_bob := sin(_drift_phase * 1.05 + 0.45) * 0.035
	$VoyageWorld/BoatSpace.position.y = _boat_space_base_position.y + boat_bob


func _advance_distant_scenery(delta: float) -> void:
	var event := _drift_scenery_director.advance(delta, _application_foreground)
	if bool(event.get("show_scenery", false)):
		_spawn_distant_scenery(str(event.get("scenery_id", "")), bool(event.get("save_memory", false)))
	if not _application_foreground:
		return
	for scenery in _active_distant_scenery.duplicate():
		if not is_instance_valid(scenery):
			_active_distant_scenery.erase(scenery)
			continue
		scenery.position.x += DISTANT_SCENERY_DRIFT_PER_SECOND * maxf(delta, 0.0)
		if scenery.position.x > size.x + 24.0:
			scenery.queue_free()
			_active_distant_scenery.erase(scenery)


func _spawn_distant_scenery(scenery_id: String, save_memory: bool) -> void:
	var texture = DISTANT_SCENERY_TEXTURES.get(scenery_id, null)
	if texture == null:
		return
	var instance := DISTANT_SCENERY_SCENE.instantiate() as TextureRect
	if instance == null:
		return
	instance.texture = texture
	var scenery_size := DISTANT_SCENERY_SIZES.get(scenery_id, Vector2(80, 80)) as Vector2
	instance.size = scenery_size
	instance.position = Vector2(-scenery_size.x, 386.0 - scenery_size.y)
	$DistantSceneryLayer.add_child(instance)
	_active_distant_scenery.append(instance)
	if save_memory:
		var scenery_label := str(DISTANT_SCENERY_LABELS.get(scenery_id, "먼 풍경"))
		GameState.add_ambient_scenery("지나간 %s" % scenery_label)
		_show_memory_notification("%s을 조용히 남겼습니다." % scenery_label)


func _show_memory_notification(message: String) -> void:
	%MemoryNotificationLabel.text = message
	%MemoryNotificationLabel.visible = true
	_memory_notification_remaining = MEMORY_NOTIFICATION_SECONDS


func _advance_memory_notification(delta: float) -> void:
	if _memory_notification_remaining <= 0.0:
		return
	_memory_notification_remaining = maxf(0.0, _memory_notification_remaining - maxf(delta, 0.0))
	if _memory_notification_remaining <= 0.0:
		%MemoryNotificationLabel.visible = false


func _handle_fishing_action() -> void:
	if _fishing_session.is_bite_ready():
		var fish_name: String = str(FISH_NAMES.pick_random())
		var caught: String = str(_fishing_session.resolve_catch(fish_name))
		if caught != "":
			GameState.add_fish(caught)
			_set_fishing_status("%s 한 마리를 낚아 항해 기억에 남겼습니다." % caught)
			_update_ui("작은 입질 하나가 오늘의 항해에 기억으로 남았습니다.")
		%FishingButton.text = "낚시"
		return
	if _fishing_session.is_waiting():
		_fishing_session.cancel()
		%FishingButton.text = "낚시"
		_set_fishing_status("낚싯줄을 천천히 거두었습니다. 잃는 것은 없습니다.")
		return
	_fishing_session.cast_line(randf_range(FISHING_WAIT_MIN_SECONDS, FISHING_WAIT_MAX_SECONDS))
	%FishingButton.text = "줄 거두기"
	_set_fishing_status("낚싯줄을 던졌습니다. 서두르지 말고 물결을 기다립니다.")


func _advance_fishing(delta: float) -> void:
	if _fishing_session.advance(delta):
		%FishingButton.text = "입질! 낚기"
		_set_fishing_status("가벼운 입질이 왔습니다. 원하면 지금 천천히 낚아 올립니다.")


func _set_fishing_status(message: String) -> void:
	%FishingStatusLabel.text = message
	%FishingStatusLabel.visible = not GameState.appreciation_mode and message != ""


func _apply_appreciation_mode() -> void:
	var action_controls_visible := not GameState.appreciation_mode
	$TopPanel.visible = _rest_menu_open and action_controls_visible
	$BottomPanel.visible = _rest_menu_open
	$BottomPanel.offset_top = -56.0 if GameState.appreciation_mode else -176.0
	$BottomPanel/ButtonGrid.columns = 1 if GameState.appreciation_mode else 2
	%RestMenuButton.visible = action_controls_visible
	%RestMenuButton.text = "닫기" if _rest_menu_open else "메뉴"
	%TakePhotoButton.visible = action_controls_visible
	%SpeedButton.visible = action_controls_visible
	%FishingButton.visible = action_controls_visible
	%DecorButton.visible = action_controls_visible
	%InteractButton.visible = action_controls_visible
	%AlbumButton.visible = action_controls_visible
	%AppreciationButton.visible = _rest_menu_open
	%AppreciationButton.text = "감상 끝내기" if GameState.appreciation_mode else "감상모드"
	if GameState.appreciation_mode:
		$DecorPanel.visible = false
		$InteractionPanel.visible = false
	_apply_camera_mode()
	_sync_next_voyage_button()
	%FishingStatusLabel.visible = _rest_menu_open and action_controls_visible and %FishingStatusLabel.text != ""


func _toggle_rest_menu() -> void:
	if GameState.appreciation_mode:
		return
	_rest_menu_open = not _rest_menu_open
	_apply_appreciation_mode()


func _sync_next_voyage_button() -> void:
	%NextVoyageButton.visible = not GameState.appreciation_mode and GameState.voyage_record_created


func _open_album() -> void:
	if _fishing_session.is_waiting() or _fishing_session.is_bite_ready():
		_fishing_session.cancel()
	get_tree().change_scene_to_file("res://scenes/album.tscn")


func _start_next_voyage() -> void:
	if not GameState.voyage_record_created:
		return
	if _fishing_session.is_waiting() or _fishing_session.is_bite_ready():
		_fishing_session.cancel()
	GameState.begin_voyage()
	get_tree().reload_current_scene()


func _update_ui(message: String = "") -> void:
	%VoyageStatusLabel.text = "동반자와 바다를 보고 있어요."
	%TimerLabel.text = _format_time(GameState.remaining_seconds)
	%SpeedButton.text = "속도: %s" % SPEED_NAMES[clampi(GameState.speed_index, 0, SPEED_NAMES.size() - 1)]
	if message != "":
		%StatusLabel.text = message


func _format_time(seconds: float) -> String:
	var total_seconds := int(ceil(seconds))
	var minutes := int(total_seconds / 60)
	var seconds_left := total_seconds % 60
	return "%02d:%02d" % [minutes, seconds_left]
