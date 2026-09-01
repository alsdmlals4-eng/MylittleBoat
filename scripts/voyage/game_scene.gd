# 5분 보트 휴식의 디오라마·보트 생활공간·낚시 상호작용을 관리한다.
extends Control

const FISHING_SESSION_SCRIPT = preload("res://scripts/voyage/fishing_session.gd")
const DECOR_CATALOG_SCRIPT = preload("res://scripts/decor/boat_decor_catalog.gd")
const DECOR_VISUAL_ASSETS_SCRIPT = preload("res://scripts/decor/decor_visual_assets.gd")
const IDENTITY_VISUAL_CATALOG_SCRIPT = preload("res://scripts/identity/identity_visual_catalog.gd")
const TIME_OF_DAY_CATALOG_SCRIPT = preload("res://scripts/voyage/time_of_day_catalog.gd")
const REAL_TIME_ATMOSPHERE_RESOLVER_SCRIPT = preload("res://scripts/voyage/real_time_atmosphere_resolver.gd")
const DRIFT_SCENERY_DIRECTOR_SCRIPT = preload("res://scripts/voyage/drift_scenery_director.gd")
const LOOK_AROUND_PRESENTATION_ROUTER_SCRIPT = preload("res://scripts/voyage/look_around_presentation_router.gd")
const SEA_FLOW_SHADER = preload("res://assets/shaders/voyage_split_sea_flow.gdshader")
const LOOK_AROUND_FOREGROUND_KEY_SHADER = preload("res://assets/shaders/look_around_foreground_chroma_key.gdshader")
const SEASONAL_CLOUD_TEXTURE = preload("res://assets/images/runtime/voyage/seasonal_parallax/bright-spring-clouds-chroma.png")

const SPEED_NAMES: Array[String] = ["느림", "보통", "빠름"]
const SPEED_MULTIPLIERS: Array[float] = [0.65, 1.0, 1.45]
const FORWARD_SURGE_DISTANCE := 0.16
const LATERAL_CURRENT_DISTANCE := 0.022
const FORWARD_SURGE_FREQUENCY := 0.45
const LATERAL_CURRENT_FREQUENCY := 0.28
const TITLE_IDLE_MOTION_MULTIPLIER := 0.42
const BACKGROUND_FLOW_UNITS_PER_SECOND := 0.012
const MOTION_COMFORT_NAMES := {
	"standard": "기본",
	"gentle": "잔잔",
	"still": "고요",
}
const POSTCARD_LABELS := {
	"dawn": "새벽 물결의 포스트카드",
	"bright": "밝은 바다의 포스트카드",
	"sunset": "노을 물결의 포스트카드",
	"night": "인디고 밤바다의 포스트카드",
}
const SKY_TEXTURE_PATHS := {
	"dawn": "res://assets/images/runtime/voyage/split/dawn-static-sky.png",
	"bright": "res://assets/images/runtime/voyage/split/bright-static-sky.png",
	"sunset": "res://assets/images/runtime/voyage/split/sunset-static-sky.png",
	"night": "res://assets/images/runtime/voyage/split/night-static-sky.png",
}
const SEA_TEXTURE_PATHS := {
	"dawn": "res://assets/images/runtime/voyage/split/dawn-flowing-sea.png",
	"bright": "res://assets/images/runtime/voyage/split/bright-flowing-sea.png",
	"sunset": "res://assets/images/runtime/voyage/split/sunset-flowing-sea.png",
	"night": "res://assets/images/runtime/voyage/split/night-flowing-sea.png",
}
const WATER_CONTACT_MODULATES := {
	"dawn": Color(0.78, 0.88, 1.0, 0.32),
	"bright": Color(0.9, 0.96, 1.0, 0.36),
	"sunset": Color(1.0, 0.72, 0.58, 0.30),
	"night": Color(0.5, 0.66, 1.0, 0.22),
}
const WATERLINE_CONTACT_MODULATES := {
	"dawn": Color(0.8, 0.9, 1.0, 0.36),
	"bright": Color(0.9, 0.97, 1.0, 0.42),
	"sunset": Color(1.0, 0.78, 0.64, 0.34),
	"night": Color(0.58, 0.76, 1.0, 0.24),
}
const FISH_NAMES: Array[String] = ["정어리", "전갱이", "고등어", "도미"]
const FISHING_OUTCOME_IDS: Array[String] = ["catch", "quiet"]
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
const AMBIENT_SCENERY_PASS_DURATION_SECONDS := 14.0
const AMBIENT_SCENERY_PASS_MIN_TRAVEL_OFFSET_X := 21.0
const AMBIENT_SCENERY_PASS_FADE_FRACTION := 0.12
const SEASONAL_CLOUD_PHASE_PER_SECOND := 0.38
const SEASONAL_CLOUD_HORIZONTAL_DISTANCE := 0.72

var _fishing_session = FISHING_SESSION_SCRIPT.new()
var _next_fishing_outcome_index := 0
var _decor_catalog = DECOR_CATALOG_SCRIPT.new()
var _decor_visual_assets = DECOR_VISUAL_ASSETS_SCRIPT.new()
var _identity_visual_catalog = IDENTITY_VISUAL_CATALOG_SCRIPT.new()
var _time_of_day_catalog = TIME_OF_DAY_CATALOG_SCRIPT.new()
var _real_time_atmosphere_resolver = REAL_TIME_ATMOSPHERE_RESOLVER_SCRIPT.new()
var _drift_scenery_director = DRIFT_SCENERY_DIRECTOR_SCRIPT.new()
var _drift_phase := 0.0
var _background_flow_offset := 0.0
var _diorama_camera_base_position := Vector3.ZERO
var _look_around_camera_base_position := Vector3.ZERO
var _appreciation_camera_base_position := Vector3.ZERO
var _ambient_scenery_pass_base_positions: Array[Vector3] = []
var _ambient_scenery_pass_tween: Tween
var _ambient_scenery_pass_start_offset_x := 0.0
var _ambient_scenery_pass_end_offset_x := 0.0
var _seasonal_cloud_layer_base_positions: Array[Vector3] = []
var _seasonal_cloud_phase := 0.0
var _seasonal_island_layer_base_positions: Array[Vector3] = []
var _seasonal_island_active := false
var _seasonal_island_progress := 0.0
var _seasonal_island_start_offset_x := 0.0
var _seasonal_island_end_offset_x := 0.0
var _boat_space_base_position := Vector3.ZERO
var _boat_space_base_rotation := Vector3.ZERO
var _boat_water_contact_base_position := Vector3.ZERO
var _boat_water_contact_base_scale := Vector3.ONE
var _boat_water_contact_base_modulate := Color.WHITE
var _boat_waterline_contact_base_position := Vector3.ZERO
var _boat_waterline_contact_base_scale := Vector3.ONE
var _boat_waterline_contact_base_modulate := Color.WHITE
var _time_of_day_background_color := Color(0.58, 0.76, 0.86, 1.0)
var _rest_menu_open := false
var _active_atmosphere_id := "bright"
var _active_season_id := ""
var _application_in_foreground := true
var _look_around_mode := false
var _look_around_angle_id := "front"
var _look_around_presentation_router = LOOK_AROUND_PRESENTATION_ROUTER_SCRIPT.new()
var _photo_capture_in_progress := false
var _title_waiting := false


func _ready() -> void:
	randomize()
	_title_waiting = not GameState.voyage_active
	if _title_waiting:
		GameState.reset_session()
	_diorama_camera_base_position = $VoyageWorld/DioramaCameraRig.position
	_look_around_camera_base_position = $VoyageWorld/LookAroundCameraRig.position
	_appreciation_camera_base_position = $VoyageWorld/AppreciationCameraRig.position
	for scenery_pass in _get_ambient_scenery_passes():
		_ambient_scenery_pass_base_positions.append(scenery_pass.position)
	for cloud_layer in _get_seasonal_cloud_layers():
		_seasonal_cloud_layer_base_positions.append(cloud_layer.position)
	for island_layer in _get_seasonal_island_layers():
		_seasonal_island_layer_base_positions.append(island_layer.position)
	_boat_space_base_position = $VoyageWorld/BoatSpace.position
	_boat_space_base_rotation = $VoyageWorld/BoatSpace.rotation
	_boat_water_contact_base_position = $VoyageWorld/BoatWaterContact.position
	_boat_water_contact_base_scale = $VoyageWorld/BoatWaterContact.scale
	_boat_water_contact_base_modulate = $VoyageWorld/BoatWaterContact.modulate
	_boat_waterline_contact_base_position = $VoyageWorld/BoatWaterlineContact.position
	_boat_waterline_contact_base_scale = $VoyageWorld/BoatWaterlineContact.scale
	_boat_waterline_contact_base_modulate = $VoyageWorld/BoatWaterlineContact.modulate
	_configure_main_final_composite_decor_visibility()
	_apply_time_of_day_tone()
	_apply_stored_boat_decor()
	%TakePhotoButton.pressed.connect(_take_photo)
	%StartVoyageButton.pressed.connect(start_voyage_from_title)
	%RestMenuButton.pressed.connect(open_rest_menu)
	%AppreciationButton.pressed.connect(_toggle_appreciation_mode)
	%LookAroundButton.pressed.connect(_toggle_look_around_mode)
	%SpeedButton.pressed.connect(_cycle_speed)
	%ComfortButton.pressed.connect(_cycle_motion_comfort)
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
	%AtmosphereRefreshTimer.timeout.connect(refresh_real_time_atmosphere)
	%AmbientSceneryReturnTimer.timeout.connect(_restore_active_atmosphere_backdrop)
	%DistantSceneryFadeTimer.timeout.connect(_hide_distant_scenery)
	$VoyageWorld/LookAroundCameraRig.angle_changed.connect(_on_look_around_angle_changed)
	_populate_identity_options()
	_populate_decor_slot_options()
	set_application_foreground(true)
	if _title_waiting:
		_apply_title_waiting_presentation()
	else:
		_apply_voyage_presentation()
	_apply_appreciation_mode()
	if _title_waiting:
		_apply_title_waiting_presentation()
	var message := "동반자가 곁에서 조용히 바다를 바라봅니다."
	if GameState.remaining_seconds < 299.9 and not GameState.voyage_record_created:
		message = "바다로 돌아왔습니다. 이어서 천천히 항해합니다."
	elif GameState.voyage_record_created:
		message = "오늘의 항해 기록이 남아 있습니다. 더 머물거나 다음 항해를 준비해도 좋아요."
	_update_ui(message)


func _process(delta: float) -> void:
	_apply_drift_motion(delta)
	if _title_waiting:
		return
	_advance_fishing(delta)
	_advance_drift_scenery(delta)
	if _application_in_foreground:
		GameState.advance_together_time(delta)
	var completed_now := GameState.tick_voyage(delta)
	if completed_now:
		GameState.complete_voyage()
		_sync_next_voyage_button()
		_update_ui("오늘의 항해 기록이 만들어졌습니다. 더 머물거나 다음 항해를 준비해도 좋아요.")
	else:
		_update_ui()


func _notification(what: int) -> void:
	if not is_node_ready():
		return
	if what == NOTIFICATION_APPLICATION_FOCUS_IN or what == NOTIFICATION_APPLICATION_RESUMED:
		set_application_foreground(true)
		refresh_real_time_atmosphere()
	elif what == NOTIFICATION_APPLICATION_FOCUS_OUT or what == NOTIFICATION_APPLICATION_PAUSED:
		set_application_foreground(false)


## Keeps foreground lifecycle ownership local to the voyage scene.
func set_application_foreground(is_foreground: bool) -> void:
	_application_in_foreground = is_foreground
	_drift_scenery_director.set_foreground(is_foreground)
	if not is_foreground:
		GameState.flush_together_time()


func _exit_tree() -> void:
	GameState.flush_together_time()


func _apply_time_of_day_tone() -> String:
	return refresh_real_time_atmosphere()


## Applies a deterministic local-hour atmosphere for automated capture and contracts.
func apply_real_time_atmosphere_for_hour(hour: int) -> String:
	return _apply_visual_context(_real_time_atmosphere_resolver.resolve_hour(hour), "")


## Refreshes the visual-only atmosphere from the device's current local time.
func refresh_real_time_atmosphere() -> String:
	return _apply_visual_context(_real_time_atmosphere_resolver.resolve_system_time(), _real_time_atmosphere_resolver.resolve_system_season())


func get_active_atmosphere_id() -> String:
	return _active_atmosphere_id


## Applies deterministic local clock inputs only to visual routing for contracts and captures.
func apply_real_time_visual_context_for_tests(hour: int, month: int) -> String:
	return _apply_visual_context(
		_real_time_atmosphere_resolver.resolve_hour(hour),
		_real_time_atmosphere_resolver.resolve_season_for_month(month),
	)


func get_active_season_id() -> String:
	return _active_season_id


func _apply_atmosphere_id(time_of_day_id: String) -> String:
	return _apply_visual_context(time_of_day_id, _active_season_id)


func _apply_visual_context(time_of_day_id: String, season_id: String) -> String:
	var normalized_time_of_day := _time_of_day_catalog.normalize_time_of_day(time_of_day_id)
	var normalized_season := "spring" if season_id == "spring" else ""
	_clear_ambient_scenery_passes()
	var tone := _time_of_day_catalog.get_visual_tone(normalized_time_of_day)
	_active_atmosphere_id = normalized_time_of_day
	_active_season_id = normalized_season
	_time_of_day_background_color = tone["background_color"] as Color
	var world_environment := $VoyageWorld/WorldEnvironment as WorldEnvironment
	if world_environment.environment != null:
		world_environment.environment.background_color = _time_of_day_background_color
		world_environment.environment.ambient_light_color = tone["ambient_color"] as Color
		world_environment.environment.ambient_light_energy = float(tone["ambient_energy"])
	var sun_light := $VoyageWorld/SunLight as DirectionalLight3D
	sun_light.light_color = tone["light_color"] as Color
	sun_light.light_energy = float(tone["light_energy"])
	_apply_split_backdrop_textures(normalized_time_of_day, tone["backdrop_modulate"] as Color)
	var water_contact := $VoyageWorld/BoatWaterContact as Sprite3D
	if water_contact != null:
		water_contact.modulate = WATER_CONTACT_MODULATES[normalized_time_of_day] as Color
		_boat_water_contact_base_modulate = water_contact.modulate
	var waterline_contact := $VoyageWorld/BoatWaterlineContact as Sprite3D
	if waterline_contact != null:
		waterline_contact.modulate = WATERLINE_CONTACT_MODULATES[normalized_time_of_day] as Color
		_boat_waterline_contact_base_modulate = waterline_contact.modulate
	_configure_seasonal_cloud_layers()
	_apply_look_around_presentation()
	_refresh_seasonal_cloud_visibility()
	return _active_atmosphere_id


func _take_photo() -> void:
	if _photo_capture_in_progress:
		return
	set_look_around_mode(false)
	_capture_voyage_postcard()


func _capture_voyage_postcard() -> void:
	_photo_capture_in_progress = true
	var capture_nodes: Array[CanvasItem] = [
		$TopPanel,
		$BottomPanel,
		%RestMenuButton,
		%DistantSceneryLabel,
	]
	var previous_visibility: Array[bool] = []
	for node in capture_nodes:
		previous_visibility.append(node.visible)
		node.visible = false
	await RenderingServer.frame_post_draw
	var image := get_viewport().get_texture().get_image()
	for index in capture_nodes.size():
		capture_nodes[index].visible = previous_visibility[index]
	_photo_capture_in_progress = false
	if image == null or image.is_empty():
		_update_ui("사진을 남기지 못했어요. 바다를 계속 바라봐도 좋아요.")
		return
	var postcard_label := str(POSTCARD_LABELS.get(_active_atmosphere_id, "오늘 바다의 포스트카드"))
	if GameState.record_photo_memory(image, postcard_label, _active_atmosphere_id):
		_update_ui("사진 한 장이 항해 포스트카드로 남았습니다.")
		return
	_update_ui("사진을 남기지 못했어요. 바다를 계속 바라봐도 좋아요.")


func _toggle_appreciation_mode() -> void:
	set_look_around_mode(false)
	if _fishing_session.is_waiting() or _fishing_session.is_bite_ready() or _fishing_session.is_quiet_ready():
		_fishing_session.cancel()
		%FishingButton.text = "낚시"
		_set_fishing_status("")
	GameState.appreciation_mode = not GameState.appreciation_mode
	_apply_appreciation_mode()
	var message := "감상모드로 전환했습니다. 바다만 천천히 바라봅니다." if GameState.appreciation_mode else "보트 디오라마로 돌아왔습니다."
	_update_ui(message)


func _toggle_look_around_mode() -> void:
	set_look_around_mode(not _look_around_mode)
	_update_ui("주변을 천천히 둘러봅니다." if _look_around_mode else "기본 3/4 시점으로 돌아왔습니다.")


## Keeps Look Around as local presentation state without changing GameState progression.
func set_look_around_mode(is_active: bool) -> void:
	_look_around_mode = is_active
	if _look_around_mode:
		GameState.appreciation_mode = false
		var look_around_controller := $VoyageWorld/LookAroundCameraRig
		look_around_controller.set_view_angles(0.0, 0.0)
		_look_around_angle_id = "front"
	_apply_appreciation_mode()


func _on_look_around_angle_changed(angle_id: String) -> void:
	_look_around_angle_id = angle_id
	_apply_look_around_presentation()


func get_look_around_requested_angle_id() -> String:
	return _look_around_angle_id


func get_look_around_display_angle_id() -> String:
	return _look_around_presentation_router.get_display_angle_id(_look_around_angle_id)


func get_active_camera_mode() -> String:
	if _look_around_mode:
		return "look_around"
	return "appreciation" if GameState.appreciation_mode else "diorama"


func _apply_camera_mode() -> void:
	var use_appreciation := GameState.appreciation_mode
	var use_look_around := _look_around_mode and not use_appreciation
	$VoyageWorld/DioramaCameraRig/DioramaCamera3D.current = not use_appreciation and not use_look_around
	$VoyageWorld/LookAroundCameraRig/LookAroundCamera3D.current = use_look_around
	$VoyageWorld/AppreciationCameraRig/AppreciationCamera3D.current = use_appreciation
	_set_camera_split_backdrop_visible("DioramaCameraRig/DioramaCamera3D", not use_appreciation and not use_look_around)
	_set_camera_split_backdrop_visible("LookAroundCameraRig/LookAroundCamera3D", use_look_around)
	_set_camera_split_backdrop_visible("AppreciationCameraRig/AppreciationCamera3D", use_appreciation)
	_apply_look_around_presentation()


## Applies approved angle art without mutating voyage or local cosmetic state.
func _apply_look_around_presentation() -> void:
	var look_around_backdrop := $VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/SeaBackdrop as Sprite3D
	var look_around_sky := $VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/SkyBackdrop as Sprite3D
	var look_around_foreground := $VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/LookAroundForeground as Sprite3D
	var final_diorama_card := $VoyageWorld/BoatSpace/FinalDioramaCard as Sprite3D
	if not _look_around_mode:
		var inactive_tone := _time_of_day_catalog.get_visual_tone(_active_atmosphere_id)
		_apply_split_backdrop_textures(_active_atmosphere_id, inactive_tone["backdrop_modulate"] as Color)
		if look_around_foreground != null:
			look_around_foreground.visible = false
		final_diorama_card.visible = true
		return

	var display_angle_id := get_look_around_display_angle_id()
	if display_angle_id == "front":
		var tone := _time_of_day_catalog.get_visual_tone(_active_atmosphere_id)
		_apply_split_backdrop_textures(_active_atmosphere_id, tone["backdrop_modulate"] as Color)
		look_around_sky.visible = true
		look_around_backdrop.visible = true
		if look_around_foreground != null:
			look_around_foreground.visible = false
		final_diorama_card.visible = true
		return

	var asset_path := _look_around_presentation_router.get_runtime_angle_asset_path(display_angle_id)
	var angle_texture := load(asset_path) as Texture2D
	if angle_texture == null or look_around_foreground == null:
		final_diorama_card.visible = true
		return
	var tone := _time_of_day_catalog.get_visual_tone(_active_atmosphere_id)
	_apply_split_backdrop_textures(_active_atmosphere_id, tone["backdrop_modulate"] as Color)
	look_around_sky.visible = true
	look_around_backdrop.visible = true
	look_around_foreground.texture = angle_texture
	_ensure_look_around_foreground_material(look_around_foreground)
	var foreground_material := look_around_foreground.material_override as ShaderMaterial
	foreground_material.set_shader_parameter("source_texture", angle_texture)
	look_around_foreground.visible = true
	final_diorama_card.visible = false


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
	_refresh_decor_preview()
	return true


func clear_boat_decor(slot_id: String) -> void:
	var slot: Node = _get_decor_slot(slot_id)
	if slot != null and slot.has_method("apply_item"):
		slot.call("apply_item", "")
	GameState.set_boat_decor(slot_id, "")
	_sync_identity_decor_visuals()
	_refresh_decor_preview()


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
	if identity_visual_router != null and identity_visual_router.has_method("sync_decor_from_state"):
		identity_visual_router.sync_decor_from_state()


func _configure_main_final_composite_decor_visibility() -> void:
	var identity_visual_router := $VoyageWorld/BoatSpace/IdentityVisualRouter
	if identity_visual_router != null and identity_visual_router.has_method("set_suppress_technical_decor_for_final_composite"):
		identity_visual_router.call("set_suppress_technical_decor_for_final_composite", true)


func _refresh_decor_preview() -> void:
	if %DecorPreview.has_method("refresh_from_state"):
		%DecorPreview.call("refresh_from_state")


func _populate_identity_options() -> void:
	%PlayerStyleOption.clear()
	var selected_player_style := GameState.get_selected_player_style()
	for player_style_id in _identity_visual_catalog.get_player_style_ids():
		%PlayerStyleOption.add_item(_identity_visual_catalog.get_player_label(player_style_id))
		var player_index: int = %PlayerStyleOption.item_count - 1
		%PlayerStyleOption.set_item_metadata(player_index, player_style_id)
		if player_style_id == selected_player_style:
			%PlayerStyleOption.select(player_index)
	%PetTypeOption.clear()
	var selected_pet_type := GameState.get_selected_pet_type()
	for pet_type_id in _identity_visual_catalog.get_pet_type_ids():
		%PetTypeOption.add_item(_identity_visual_catalog.get_pet_label(pet_type_id))
		var pet_index: int = %PetTypeOption.item_count - 1
		%PetTypeOption.set_item_metadata(pet_index, pet_type_id)
		if pet_type_id == selected_pet_type:
			%PetTypeOption.select(pet_index)


func _on_player_style_selected(_index: int) -> void:
	var player_style_id := _get_selected_metadata(%PlayerStyleOption)
	if player_style_id == "":
		return
	GameState.set_selected_player_style(player_style_id)
	_apply_identity_visuals()
	_update_ui("플레이어 외형을 조용히 바꿨습니다.")


func _on_pet_type_selected(_index: int) -> void:
	var pet_type_id := _get_selected_metadata(%PetTypeOption)
	if pet_type_id == "":
		return
	GameState.set_selected_pet_type(pet_type_id)
	_apply_identity_visuals()
	_update_ui("동반자의 모습을 조용히 바꿨습니다.")


func _apply_identity_visuals() -> void:
	var identity_visual_router := $VoyageWorld/BoatSpace/IdentityVisualRouter
	if identity_visual_router != null and identity_visual_router.has_method("apply_selection"):
		identity_visual_router.call(
			"apply_selection",
			GameState.get_selected_player_style(),
			GameState.get_selected_pet_type()
		)
	if identity_visual_router != null and identity_visual_router.has_method("sync_decor_from_state"):
		identity_visual_router.call("sync_decor_from_state")
	_refresh_decor_preview()


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
	set_look_around_mode(false)
	if GameState.appreciation_mode:
		return
	$InteractionPanel.visible = false
	if %DecorPreview.has_method("show_from_state"):
		%DecorPreview.call("show_from_state")
	$DecorPanel.visible = true
	_populate_identity_options()
	_refresh_decor_item_options()


func _close_decor_panel() -> void:
	if %DecorPreview.has_method("hide_preview"):
		%DecorPreview.call("hide_preview")
	$DecorPanel.visible = false


func _open_interaction_panel() -> void:
	set_look_around_mode(false)
	if GameState.appreciation_mode:
		return
	_close_decor_panel()
	$InteractionPanel.visible = true
	_refresh_interaction_targets()


func _close_interaction_panel() -> void:
	$InteractionPanel.visible = false


## Opens the optional rest actions after the direct boat view is already visible.
func open_rest_menu() -> void:
	if GameState.appreciation_mode:
		return
	_rest_menu_open = true
	$BottomPanel.visible = true
	$TopPanel.visible = true
	%RestMenuButton.visible = false


## Returns from optional rest actions to the low-UI boat view.
func close_rest_menu() -> void:
	_rest_menu_open = false
	$BottomPanel.visible = GameState.appreciation_mode
	$TopPanel.visible = false
	%RestMenuButton.visible = not GameState.appreciation_mode


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


func _cycle_motion_comfort() -> void:
	GameState.cycle_motion_comfort_profile()
	_update_ui("파도를 %s하게 조절했습니다." % _get_motion_comfort_name())


func _get_motion_comfort_name() -> String:
	return str(MOTION_COMFORT_NAMES.get(GameState.get_motion_comfort_profile(), "기본"))


## Returns the visual-only current offset used by all active sea backdrops.
func get_background_flow_offset() -> float:
	return _background_flow_offset


func _get_sea_backdrops() -> Array[Sprite3D]:
	return [
		$VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop as Sprite3D,
		$VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/SeaBackdrop as Sprite3D,
		$VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeaBackdrop as Sprite3D,
	]


func _get_sky_backdrops() -> Array[Sprite3D]:
	return [
		$VoyageWorld/DioramaCameraRig/DioramaCamera3D/SkyBackdrop as Sprite3D,
		$VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/SkyBackdrop as Sprite3D,
		$VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SkyBackdrop as Sprite3D,
	]


func _get_seasonal_cloud_layers() -> Array[Sprite3D]:
	return [
		$VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeasonalCloudLayer as Sprite3D,
		$VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/SeasonalCloudLayer as Sprite3D,
		$VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeasonalCloudLayer as Sprite3D,
	]


func _is_bright_spring_visual_active() -> bool:
	return _active_atmosphere_id == "bright" and _active_season_id == "spring"


func _set_camera_split_backdrop_visible(camera_path: String, is_visible: bool) -> void:
	var camera := get_node_or_null("VoyageWorld/%s" % camera_path) as Camera3D
	if camera == null:
		return
	var sky_backdrop := camera.get_node_or_null("SkyBackdrop") as Sprite3D
	var sea_backdrop := camera.get_node_or_null("SeaBackdrop") as Sprite3D
	var seasonal_cloud_layer := camera.get_node_or_null("SeasonalCloudLayer") as Sprite3D
	if sky_backdrop != null:
		sky_backdrop.visible = is_visible
	if sea_backdrop != null:
		sea_backdrop.visible = is_visible
	if seasonal_cloud_layer != null:
		seasonal_cloud_layer.visible = is_visible and _is_bright_spring_visual_active()


func _apply_split_backdrop_textures(time_of_day_id: String, backdrop_modulate: Color) -> void:
	var sky_texture := load(str(SKY_TEXTURE_PATHS[time_of_day_id])) as Texture2D
	var sea_texture := load(str(SEA_TEXTURE_PATHS[time_of_day_id])) as Texture2D
	for sky_backdrop in _get_sky_backdrops():
		if sky_backdrop == null:
			continue
		sky_backdrop.modulate = backdrop_modulate
		sky_backdrop.material_override = null
		if sky_texture != null:
			sky_backdrop.texture = sky_texture
	for sea_backdrop in _get_sea_backdrops():
		if sea_backdrop == null:
			continue
		sea_backdrop.modulate = backdrop_modulate
		if sea_texture != null:
			sea_backdrop.texture = sea_texture
		_ensure_sea_flow_material(sea_backdrop)
		_apply_background_flow_to_backdrop(sea_backdrop)


func _ensure_sea_flow_material(backdrop: Sprite3D) -> void:
	var flow_material := backdrop.material_override as ShaderMaterial
	if flow_material != null and flow_material.shader == SEA_FLOW_SHADER:
		return
	flow_material = ShaderMaterial.new()
	flow_material.shader = SEA_FLOW_SHADER
	backdrop.material_override = flow_material


func _ensure_look_around_foreground_material(foreground: Sprite3D) -> void:
	var foreground_material := foreground.material_override as ShaderMaterial
	if foreground_material != null and foreground_material.shader == LOOK_AROUND_FOREGROUND_KEY_SHADER:
		return
	foreground_material = ShaderMaterial.new()
	foreground_material.shader = LOOK_AROUND_FOREGROUND_KEY_SHADER
	foreground.material_override = foreground_material


func _configure_seasonal_cloud_layers() -> void:
	for cloud_layer in _get_seasonal_cloud_layers():
		if cloud_layer == null:
			continue
		cloud_layer.texture = SEASONAL_CLOUD_TEXTURE
		_ensure_seasonal_cloud_material(cloud_layer)
		var cloud_material := cloud_layer.material_override as ShaderMaterial
		cloud_material.set_shader_parameter("source_texture", SEASONAL_CLOUD_TEXTURE)


func _ensure_seasonal_cloud_material(cloud_layer: Sprite3D) -> void:
	if cloud_layer.has_meta("seasonal_cloud_material_bound"):
		return
	var cloud_material := ShaderMaterial.new()
	cloud_material.shader = LOOK_AROUND_FOREGROUND_KEY_SHADER
	cloud_layer.material_override = cloud_material
	cloud_layer.set_meta("seasonal_cloud_material_bound", true)


func _refresh_seasonal_cloud_visibility() -> void:
	for cloud_layer in _get_seasonal_cloud_layers():
		if cloud_layer == null:
			continue
		var parent_camera := cloud_layer.get_parent() as Camera3D
		cloud_layer.visible = _is_bright_spring_visual_active() and parent_camera != null and parent_camera.current


func _apply_background_flow_to_backdrop(backdrop: Sprite3D) -> void:
	if backdrop == null:
		return
	var flow_material := backdrop.material_override as ShaderMaterial
	if flow_material == null or flow_material.shader != SEA_FLOW_SHADER:
		return
	flow_material.set_shader_parameter("source_texture", backdrop.texture)
	flow_material.set_shader_parameter("flow_offset", _background_flow_offset)


func _apply_background_flow() -> void:
	for backdrop in _get_sea_backdrops():
		_apply_background_flow_to_backdrop(backdrop)


func _apply_drift_motion(delta: float) -> void:
	var speed_index := clampi(GameState.speed_index, 0, SPEED_MULTIPLIERS.size() - 1)
	var comfort_scale := GameState.get_motion_comfort_scale()
	var visual_motion_multiplier := SPEED_MULTIPLIERS[speed_index] if not _title_waiting else TITLE_IDLE_MOTION_MULTIPLIER
	var safe_delta := maxf(delta, 0.0)
	_drift_phase += safe_delta * visual_motion_multiplier
	_background_flow_offset = fposmod(
		_background_flow_offset + safe_delta * BACKGROUND_FLOW_UNITS_PER_SECOND * visual_motion_multiplier,
		1.0,
	)
	_apply_background_flow()
	_apply_seasonal_parallax_motion(safe_delta, visual_motion_multiplier, comfort_scale)
	$VoyageWorld/DioramaCameraRig.position.y = _diorama_camera_base_position.y + sin(_drift_phase * 1.2) * 0.018 * comfort_scale
	$VoyageWorld/LookAroundCameraRig.position.y = _look_around_camera_base_position.y + sin(_drift_phase * 1.2) * 0.018 * comfort_scale
	$VoyageWorld/AppreciationCameraRig.position.y = _appreciation_camera_base_position.y + sin(_drift_phase * 1.2) * 0.025 * comfort_scale
	var boat_bob_signal := sin(_drift_phase * 1.05 + 0.45)
	var boat_bob := boat_bob_signal * 0.052 * comfort_scale
	var forward_surge := sin(_drift_phase * FORWARD_SURGE_FREQUENCY) * FORWARD_SURGE_DISTANCE * comfort_scale
	var lateral_current := sin(_drift_phase * LATERAL_CURRENT_FREQUENCY) * LATERAL_CURRENT_DISTANCE * comfort_scale
	$VoyageWorld/BoatSpace.position = _boat_space_base_position + Vector3(lateral_current, boat_bob, forward_surge)
	$VoyageWorld/BoatSpace.rotation = _boat_space_base_rotation + Vector3(0.0, 0.0, sin(_drift_phase * 0.82 + 0.2) * deg_to_rad(1.15) * comfort_scale)
	var water_contact := $VoyageWorld/BoatWaterContact as Sprite3D
	if water_contact != null:
		var contact_breath := 1.0 + sin(_drift_phase * 1.05 - 0.2) * 0.045 * comfort_scale
		var surge_emphasis := 1.0 + absf(forward_surge) * 0.72
		water_contact.position = _boat_water_contact_base_position + Vector3(lateral_current, boat_bob * 0.92, forward_surge)
		water_contact.scale = _boat_water_contact_base_scale * contact_breath * surge_emphasis
		var contact_modulate := _boat_water_contact_base_modulate
		contact_modulate.a *= 0.9 + maxf(boat_bob_signal, 0.0) * 0.16
		water_contact.modulate = contact_modulate
	var waterline_contact := $VoyageWorld/BoatWaterlineContact as Sprite3D
	if waterline_contact != null:
		var waterline_breath := 1.0 + sin(_drift_phase * 1.05 - 0.15) * 0.022 * comfort_scale
		waterline_contact.position = _boat_waterline_contact_base_position + Vector3(lateral_current, boat_bob * 0.96, forward_surge)
		waterline_contact.scale = _boat_waterline_contact_base_scale * waterline_breath
		var waterline_modulate := _boat_waterline_contact_base_modulate
		waterline_modulate.a *= 0.92 + maxf(boat_bob_signal, 0.0) * 0.12
		waterline_contact.modulate = waterline_modulate


func _apply_seasonal_parallax_motion(safe_delta: float, visual_motion_multiplier: float, comfort_scale: float) -> void:
	var seasonal_motion_delta := safe_delta * visual_motion_multiplier * comfort_scale
	if _is_bright_spring_visual_active():
		_seasonal_cloud_phase += seasonal_motion_delta * SEASONAL_CLOUD_PHASE_PER_SECOND
		var cloud_offset_x := sin(_seasonal_cloud_phase) * SEASONAL_CLOUD_HORIZONTAL_DISTANCE
		for index in _get_seasonal_cloud_layers().size():
			if index >= _seasonal_cloud_layer_base_positions.size():
				continue
			_get_seasonal_cloud_layers()[index].position = _seasonal_cloud_layer_base_positions[index] + Vector3(cloud_offset_x, 0.0, 0.0)
	if _seasonal_island_active and seasonal_motion_delta > 0.0:
		_seasonal_island_progress = minf(
			1.0,
			_seasonal_island_progress + seasonal_motion_delta / AMBIENT_SCENERY_PASS_DURATION_SECONDS,
		)
		_apply_seasonal_island_progress(_seasonal_island_progress)


## Starts persistent voyage state only after the player leaves the title boat view.
func start_voyage_from_title() -> void:
	if not _title_waiting:
		return
	GameState.begin_voyage()
	_title_waiting = false
	_apply_voyage_presentation()
	_update_ui("동반자와 함께 천천히 항해를 시작합니다.")


func _apply_title_waiting_presentation() -> void:
	$TitleOverlay.visible = true
	_rest_menu_open = false
	$TopPanel.visible = false
	$BottomPanel.visible = false
	%RestMenuButton.visible = false
	$DecorPanel.visible = false
	$InteractionPanel.visible = false
	%DistantSceneryLabel.visible = false


func _apply_voyage_presentation() -> void:
	$TitleOverlay.visible = false
	close_rest_menu()


func _advance_drift_scenery(delta: float) -> void:
	var event := _drift_scenery_director.advance(delta, _active_atmosphere_id, _active_season_id)
	if event.is_empty():
		return
	var label := str(event.get("label", ""))
	if label == "":
		return
	%DistantSceneryLabel.text = label
	%DistantSceneryLabel.visible = true
	%DistantSceneryFadeTimer.start()
	if bool(event.get("save_memory", false)):
		GameState.record_ambient_memory(label)
	_show_temporary_ambient_scenery_backdrop(
		str(event.get("backdrop_texture_path", "")),
		float(event.get("backdrop_offset_x", 0.0)),
		bool(event.get("use_seasonal_island_layer", false)),
	)


func _show_temporary_ambient_scenery_backdrop(texture_path: String, backdrop_offset_x: float, use_seasonal_island_layer: bool = false) -> void:
	if texture_path.is_empty():
		return
	var scenery_texture := load(texture_path) as Texture2D
	if scenery_texture == null:
		return
	if use_seasonal_island_layer:
		_show_seasonal_island_layer(scenery_texture, backdrop_offset_x)
		return
	_clear_ambient_scenery_passes()
	_ambient_scenery_pass_start_offset_x = signf(backdrop_offset_x) * maxf(absf(backdrop_offset_x) * 1.5, AMBIENT_SCENERY_PASS_MIN_TRAVEL_OFFSET_X)
	_ambient_scenery_pass_end_offset_x = -_ambient_scenery_pass_start_offset_x
	for index in _get_ambient_scenery_passes().size():
		var scenery_pass := _get_ambient_scenery_passes()[index]
		scenery_pass.texture = scenery_texture
		scenery_pass.position = _ambient_scenery_pass_base_positions[index] + Vector3(_ambient_scenery_pass_start_offset_x, 0.0, 0.0)
		scenery_pass.modulate = Color(1.0, 1.0, 1.0, 0.0)
		scenery_pass.visible = true
	_ambient_scenery_pass_tween = create_tween().bind_node(self)
	_ambient_scenery_pass_tween.set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	_ambient_scenery_pass_tween.tween_method(_apply_ambient_scenery_pass_progress, 0.0, 1.0, AMBIENT_SCENERY_PASS_DURATION_SECONDS)
	%AmbientSceneryReturnTimer.start()


func _show_seasonal_island_layer(scenery_texture: Texture2D, backdrop_offset_x: float) -> void:
	_clear_ambient_scenery_passes()
	_seasonal_island_active = true
	_seasonal_island_progress = 0.0
	_seasonal_island_start_offset_x = signf(backdrop_offset_x) * maxf(absf(backdrop_offset_x) * 1.5, AMBIENT_SCENERY_PASS_MIN_TRAVEL_OFFSET_X)
	_seasonal_island_end_offset_x = -_seasonal_island_start_offset_x
	for index in _get_seasonal_island_layers().size():
		if index >= _seasonal_island_layer_base_positions.size():
			continue
		var island_layer := _get_seasonal_island_layers()[index]
		island_layer.texture = scenery_texture
		island_layer.position = _seasonal_island_layer_base_positions[index] + Vector3(_seasonal_island_start_offset_x, 0.0, 0.0)
		island_layer.modulate = Color(1.0, 1.0, 1.0, 0.0)
		island_layer.visible = true
	%AmbientSceneryReturnTimer.start()


func _restore_active_atmosphere_backdrop() -> void:
	_apply_atmosphere_id(_active_atmosphere_id)


func _get_ambient_scenery_passes() -> Array[Sprite3D]:
	return [
		$VoyageWorld/DioramaCameraRig/DioramaCamera3D/AmbientSceneryPass as Sprite3D,
		$VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/AmbientSceneryPass as Sprite3D,
	]


func _get_seasonal_island_layers() -> Array[Sprite3D]:
	return [
		$VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeasonalIslandLayer as Sprite3D,
		$VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeasonalIslandLayer as Sprite3D,
	]


func _apply_ambient_scenery_pass_progress(progress: float) -> void:
	var pass_alpha := minf(
		smoothstep(0.0, AMBIENT_SCENERY_PASS_FADE_FRACTION, progress),
		smoothstep(0.0, AMBIENT_SCENERY_PASS_FADE_FRACTION, 1.0 - progress),
	)
	var offset_x := lerpf(_ambient_scenery_pass_start_offset_x, _ambient_scenery_pass_end_offset_x, progress)
	for index in _get_ambient_scenery_passes().size():
		var scenery_pass := _get_ambient_scenery_passes()[index]
		scenery_pass.position = _ambient_scenery_pass_base_positions[index] + Vector3(offset_x, 0.0, 0.0)
		scenery_pass.modulate = Color(1.0, 1.0, 1.0, pass_alpha)


func _apply_seasonal_island_progress(progress: float) -> void:
	var pass_alpha := minf(
		smoothstep(0.0, AMBIENT_SCENERY_PASS_FADE_FRACTION, progress),
		smoothstep(0.0, AMBIENT_SCENERY_PASS_FADE_FRACTION, 1.0 - progress),
	)
	var offset_x := lerpf(_seasonal_island_start_offset_x, _seasonal_island_end_offset_x, progress)
	for index in _get_seasonal_island_layers().size():
		if index >= _seasonal_island_layer_base_positions.size():
			continue
		var island_layer := _get_seasonal_island_layers()[index]
		island_layer.position = _seasonal_island_layer_base_positions[index] + Vector3(offset_x, 0.0, 0.0)
		island_layer.modulate = Color(1.0, 1.0, 1.0, pass_alpha)


func _clear_ambient_scenery_passes() -> void:
	if _ambient_scenery_pass_tween != null:
		_ambient_scenery_pass_tween.kill()
		_ambient_scenery_pass_tween = null
	if is_instance_valid(%AmbientSceneryReturnTimer):
		%AmbientSceneryReturnTimer.stop()
	_seasonal_island_active = false
	_seasonal_island_progress = 0.0
	for index in _get_ambient_scenery_passes().size():
		var scenery_pass := _get_ambient_scenery_passes()[index]
		scenery_pass.visible = false
		scenery_pass.texture = null
		scenery_pass.modulate = Color.WHITE
		if index < _ambient_scenery_pass_base_positions.size():
			scenery_pass.position = _ambient_scenery_pass_base_positions[index]
	for index in _get_seasonal_island_layers().size():
		if index >= _seasonal_island_layer_base_positions.size():
			continue
		var island_layer := _get_seasonal_island_layers()[index]
		island_layer.visible = false
		island_layer.modulate = Color.WHITE
		island_layer.position = _seasonal_island_layer_base_positions[index]


func _hide_distant_scenery() -> void:
	%DistantSceneryLabel.visible = false


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
	if _fishing_session.is_quiet_ready():
		_fishing_session.resolve_quiet()
		%FishingButton.text = "낚시"
		_set_fishing_status("오늘은 물결만 보고 조용히 낚싯줄을 거두었습니다. 잃는 것은 없습니다.")
		_update_ui("입질이 없어도 바다를 본 시간은 그대로 편안한 항해입니다.")
		return
	if _fishing_session.is_waiting():
		_fishing_session.cancel()
		%FishingButton.text = "낚시"
		_set_fishing_status("낚싯줄을 천천히 거두었습니다. 잃는 것은 없습니다.")
		return
	_fishing_session.cast_line(
		randf_range(FISHING_WAIT_MIN_SECONDS, FISHING_WAIT_MAX_SECONDS),
		_get_next_fishing_outcome_id(),
	)
	%FishingButton.text = "줄 거두기"
	_set_fishing_status("낚싯줄을 던졌습니다. 서두르지 말고 물결을 기다립니다.")


func _advance_fishing(delta: float) -> void:
	if _fishing_session.advance(delta):
		if _fishing_session.is_quiet_ready():
			%FishingButton.text = "조용히 거두기"
			_set_fishing_status("오늘은 입질 없이 잔잔한 물결만 지나갑니다. 원하면 천천히 거둘 수 있어요.")
		else:
			%FishingButton.text = "입질! 낚기"
			_set_fishing_status("가벼운 입질이 왔습니다. 원하면 지금 천천히 낚아 올립니다.")


func _get_next_fishing_outcome_id() -> String:
	var outcome_id := FISHING_OUTCOME_IDS[_next_fishing_outcome_index % FISHING_OUTCOME_IDS.size()]
	_next_fishing_outcome_index += 1
	return outcome_id


func _set_fishing_status(message: String) -> void:
	%FishingStatusLabel.text = message
	%FishingStatusLabel.visible = not GameState.appreciation_mode and message != ""


func _apply_appreciation_mode() -> void:
	var controls_visible := not GameState.appreciation_mode
	_set_normal_boat_foreground_visible(controls_visible)
	$TopPanel.visible = controls_visible and _rest_menu_open
	$BottomPanel.visible = GameState.appreciation_mode or _rest_menu_open
	%RestMenuButton.visible = controls_visible and not _rest_menu_open
	$BottomPanel.offset_top = -56.0 if GameState.appreciation_mode else -176.0
	$BottomPanel/ButtonGrid.columns = 1 if GameState.appreciation_mode else 2
	%TakePhotoButton.visible = controls_visible
	%LookAroundButton.visible = controls_visible
	%SpeedButton.visible = controls_visible
	%ComfortButton.visible = controls_visible
	%FishingButton.visible = controls_visible
	%DecorButton.visible = controls_visible
	%InteractButton.visible = controls_visible
	%AlbumButton.visible = controls_visible
	%AppreciationButton.visible = true
	%AppreciationButton.text = "감상 끝내기" if GameState.appreciation_mode else "감상모드"
	%LookAroundButton.text = "기본 시점" if _look_around_mode else "둘러보기"
	if GameState.appreciation_mode:
		_close_decor_panel()
		$InteractionPanel.visible = false
	_apply_camera_mode()
	_sync_next_voyage_button()
	%FishingStatusLabel.visible = controls_visible and %FishingStatusLabel.text != ""


## 감상 카메라에서 하단 디오라마가 바다 중심 화면과 조작을 가리지 않게 한다.
func _set_normal_boat_foreground_visible(is_visible: bool) -> void:
	$VoyageWorld/BoatSpace.visible = is_visible
	$VoyageWorld/BoatWaterContact.visible = is_visible
	$VoyageWorld/BoatWaterlineContact.visible = is_visible


func _sync_next_voyage_button() -> void:
	%NextVoyageButton.visible = not GameState.appreciation_mode and GameState.voyage_record_created


func _open_album() -> void:
	set_look_around_mode(false)
	if _fishing_session.is_waiting() or _fishing_session.is_bite_ready() or _fishing_session.is_quiet_ready():
		_fishing_session.cancel()
	GameState.flush_together_time()
	get_tree().change_scene_to_file("res://scenes/album.tscn")


func _start_next_voyage() -> void:
	if not GameState.voyage_record_created:
		return
	if _fishing_session.is_waiting() or _fishing_session.is_bite_ready() or _fishing_session.is_quiet_ready():
		_fishing_session.cancel()
	GameState.begin_voyage()
	get_tree().reload_current_scene()


func _update_ui(message: String = "") -> void:
	%VoyageStatusLabel.text = "동반자와 바다를 보고 있어요."
	%TimerLabel.text = _format_time(GameState.remaining_seconds)
	%SpeedButton.text = "속도: %s" % SPEED_NAMES[clampi(GameState.speed_index, 0, SPEED_NAMES.size() - 1)]
	%ComfortButton.text = "파도: %s" % _get_motion_comfort_name()
	if message != "":
		%StatusLabel.text = message


func _format_time(seconds: float) -> String:
	var total_seconds := int(ceil(seconds))
	var minutes := int(total_seconds / 60)
	var seconds_left := total_seconds % 60
	return "%02d:%02d" % [minutes, seconds_left]
