# 5분 보트 휴식의 디오라마·보트 생활공간·낚시 상호작용을 관리한다.
extends Control

const FISHING_SESSION_SCRIPT = preload("res://scripts/voyage/fishing_session.gd")
const DECOR_CATALOG_SCRIPT = preload("res://scripts/decor/boat_decor_catalog.gd")
const DECOR_VISUAL_ASSETS_SCRIPT = preload("res://scripts/decor/decor_visual_assets.gd")
const IDENTITY_VISUAL_CATALOG_SCRIPT = preload("res://scripts/identity/identity_visual_catalog.gd")
const TIME_OF_DAY_CATALOG_SCRIPT = preload("res://scripts/voyage/time_of_day_catalog.gd")
const REAL_TIME_ATMOSPHERE_RESOLVER_SCRIPT = preload("res://scripts/voyage/real_time_atmosphere_resolver.gd")
const DRIFT_SCENERY_DIRECTOR_SCRIPT = preload("res://scripts/voyage/drift_scenery_director.gd")
<<<<<<< HEAD
const LOOK_AROUND_PRESENTATION_ROUTER_SCRIPT = preload("res://scripts/voyage/look_around_presentation_router.gd")

const SPEED_NAMES: Array[String] = ["느림", "보통", "빠름"]
const SPEED_MULTIPLIERS: Array[float] = [0.65, 1.0, 1.45]
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
const ATMOSPHERE_TEXTURE_PATHS := {
	"dawn": "res://assets/images/runtime/voyage/dawn-arches-waterfall-water-only.png",
	"bright": "res://assets/images/runtime/voyage/bright-open-sea-water-only.png",
	"sunset": "res://assets/images/runtime/voyage/sunset-sandstone-cove-water-only.png",
	"night": "res://assets/images/runtime/voyage/night-indigo-rain-bay-water-only.png",
}
const WATER_CONTACT_MODULATES := {
	"dawn": Color(0.78, 0.88, 1.0, 0.32),
	"bright": Color(0.9, 0.96, 1.0, 0.36),
	"sunset": Color(1.0, 0.72, 0.58, 0.30),
	"night": Color(0.5, 0.66, 1.0, 0.22),
}
=======
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
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
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
const ATMOSPHERE_REFRESH_SECONDS := 30.0
const DISTANT_SCENERY_DRIFT_PER_SECOND := 8.0
const MEMORY_NOTIFICATION_SECONDS := 2.5
const DISTANT_SCENERY_SIZES := {
	"buoy": Vector2(48, 96),
	"islet": Vector2(156, 88),
	"lighthouse": Vector2(72, 128),
}

var _fishing_session = FISHING_SESSION_SCRIPT.new()
var _next_fishing_outcome_index := 0
var _decor_catalog = DECOR_CATALOG_SCRIPT.new()
var _decor_visual_assets = DECOR_VISUAL_ASSETS_SCRIPT.new()
var _identity_visual_catalog = IDENTITY_VISUAL_CATALOG_SCRIPT.new()
var _time_of_day_catalog = TIME_OF_DAY_CATALOG_SCRIPT.new()
var _real_time_atmosphere_resolver = REAL_TIME_ATMOSPHERE_RESOLVER_SCRIPT.new()
var _drift_scenery_director = DRIFT_SCENERY_DIRECTOR_SCRIPT.new()
<<<<<<< HEAD
=======
var _active_distant_scenery: Array[Control] = []
var _memory_notification_remaining := 0.0
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
var _drift_phase := 0.0
var _diorama_camera_base_position := Vector3.ZERO
var _look_around_camera_base_position := Vector3.ZERO
var _appreciation_camera_base_position := Vector3.ZERO
var _diorama_backdrop_base_position := Vector3.ZERO
var _appreciation_backdrop_base_position := Vector3.ZERO
var _boat_space_base_position := Vector3.ZERO
var _boat_space_base_rotation := Vector3.ZERO
var _boat_water_contact_base_position := Vector3.ZERO
var _boat_water_contact_base_scale := Vector3.ONE
var _boat_water_contact_base_modulate := Color.WHITE
var _time_of_day_background_color := Color(0.58, 0.76, 0.86, 1.0)
var _rest_menu_open := false
<<<<<<< HEAD
var _active_atmosphere_id := "bright"
var _application_in_foreground := true
var _look_around_mode := false
var _look_around_angle_id := "front"
var _look_around_presentation_router = LOOK_AROUND_PRESENTATION_ROUTER_SCRIPT.new()
var _photo_capture_in_progress := false
=======
var _current_atmosphere_id := ""
var _application_foreground := true
var _atmosphere_tween: Tween
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564


func _ready() -> void:
	randomize()
	if not GameState.voyage_active:
		GameState.begin_voyage()
	_diorama_camera_base_position = $VoyageWorld/DioramaCameraRig.position
	_look_around_camera_base_position = $VoyageWorld/LookAroundCameraRig.position
	_appreciation_camera_base_position = $VoyageWorld/AppreciationCameraRig.position
	_diorama_backdrop_base_position = ($VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop as Sprite3D).position
	_appreciation_backdrop_base_position = ($VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeaBackdrop as Sprite3D).position
	_boat_space_base_position = $VoyageWorld/BoatSpace.position
<<<<<<< HEAD
	_boat_space_base_rotation = $VoyageWorld/BoatSpace.rotation
	_boat_water_contact_base_position = $VoyageWorld/BoatWaterContact.position
	_boat_water_contact_base_scale = $VoyageWorld/BoatWaterContact.scale
	_boat_water_contact_base_modulate = $VoyageWorld/BoatWaterContact.modulate
	_configure_main_final_composite_decor_visibility()
	_apply_time_of_day_tone()
=======
	%AtmosphereRefreshTimer.timeout.connect(_refresh_real_time_atmosphere)
	%AtmosphereRefreshTimer.start(ATMOSPHERE_REFRESH_SECONDS)
	_refresh_real_time_atmosphere(false)
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
	_apply_stored_boat_decor()
	%RestMenuButton.pressed.connect(_toggle_rest_menu)
	%TakePhotoButton.pressed.connect(_take_photo)
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
<<<<<<< HEAD
	%AtmosphereRefreshTimer.timeout.connect(refresh_real_time_atmosphere)
	%AmbientSceneryReturnTimer.timeout.connect(_restore_active_atmosphere_backdrop)
	%DistantSceneryFadeTimer.timeout.connect(_hide_distant_scenery)
	$VoyageWorld/LookAroundCameraRig.angle_changed.connect(_on_look_around_angle_changed)
	_populate_identity_options()
	_populate_decor_slot_options()
	set_application_foreground(true)
	close_rest_menu()
=======
	_populate_identity_options()
	_populate_decor_slot_options()
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
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
	if not _application_foreground:
		return
	_apply_drift_motion(delta)
	_advance_fishing(delta)
<<<<<<< HEAD
	_advance_drift_scenery(delta)
	if _application_in_foreground:
		GameState.advance_together_time(delta)
=======
	_advance_distant_scenery(delta)
	_advance_memory_notification(delta)
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
	var completed_now := GameState.tick_voyage(delta)
	if completed_now:
		GameState.complete_voyage()
		_sync_next_voyage_button()
		_update_ui("오늘의 항해 기록이 만들어졌습니다. 더 머물거나 다음 항해를 준비해도 좋아요.")
	else:
		_update_ui()


<<<<<<< HEAD
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
	return _apply_atmosphere_id(_real_time_atmosphere_resolver.resolve_hour(hour))


## Refreshes the visual-only atmosphere from the device's current local time.
func refresh_real_time_atmosphere() -> String:
	return _apply_atmosphere_id(_real_time_atmosphere_resolver.resolve_system_time())


func get_active_atmosphere_id() -> String:
	return _active_atmosphere_id


func _apply_atmosphere_id(time_of_day_id: String) -> String:
	var normalized_time_of_day := _time_of_day_catalog.normalize_time_of_day(time_of_day_id)
	_reset_temporary_ambient_backdrop_positions()
	var tone := _time_of_day_catalog.get_visual_tone(normalized_time_of_day)
	_active_atmosphere_id = normalized_time_of_day
=======
func _apply_time_of_day_tone(atmosphere_id: String, allow_transition: bool = false) -> void:
	var tone := _time_of_day_catalog.get_visual_tone(atmosphere_id)
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
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
<<<<<<< HEAD
	var backdrop_modulate := tone["backdrop_modulate"] as Color
	var backdrop_texture := load(str(ATMOSPHERE_TEXTURE_PATHS[normalized_time_of_day])) as Texture2D
	for backdrop in [
		$VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop as Sprite3D,
		$VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/SeaBackdrop as Sprite3D,
		$VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeaBackdrop as Sprite3D,
	]:
		backdrop.modulate = backdrop_modulate
		if backdrop_texture != null:
			backdrop.texture = backdrop_texture
	var water_contact := $VoyageWorld/BoatWaterContact as Sprite3D
	if water_contact != null:
		water_contact.modulate = WATER_CONTACT_MODULATES[normalized_time_of_day] as Color
		_boat_water_contact_base_modulate = water_contact.modulate
	_apply_look_around_presentation()
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
=======
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
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564


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
	$VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop.visible = not use_appreciation and not use_look_around
	$VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/SeaBackdrop.visible = use_look_around
	$VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeaBackdrop.visible = use_appreciation
	_apply_look_around_presentation()


## Applies approved angle art without mutating voyage or local cosmetic state.
func _apply_look_around_presentation() -> void:
	var look_around_backdrop := $VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/SeaBackdrop as Sprite3D
	var final_diorama_card := $VoyageWorld/BoatSpace/FinalDioramaCard as Sprite3D
	if not _look_around_mode:
		final_diorama_card.visible = true
		return

	var display_angle_id := get_look_around_display_angle_id()
	if display_angle_id == "front":
		var front_texture := load(str(ATMOSPHERE_TEXTURE_PATHS[_active_atmosphere_id])) as Texture2D
		if front_texture != null:
			look_around_backdrop.texture = front_texture
		var tone := _time_of_day_catalog.get_visual_tone(_active_atmosphere_id)
		look_around_backdrop.modulate = tone["backdrop_modulate"] as Color
		final_diorama_card.visible = true
		return

	var asset_path := _look_around_presentation_router.get_runtime_angle_asset_path(display_angle_id)
	var angle_texture := load(asset_path) as Texture2D
	if angle_texture == null:
		final_diorama_card.visible = true
		return
	look_around_backdrop.texture = angle_texture
	look_around_backdrop.modulate = Color.WHITE
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
	if identity_visual_router != null and identity_visual_router.has_method("apply_selection"):
		identity_visual_router.apply_selection(GameState.get_selected_player_style(), GameState.get_selected_pet_type())
	if identity_visual_router != null and identity_visual_router.has_method("sync_decor_from_state"):
		identity_visual_router.sync_decor_from_state()


<<<<<<< HEAD
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
=======
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
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564


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


func _apply_drift_motion(delta: float) -> void:
	var speed_index := clampi(GameState.speed_index, 0, SPEED_MULTIPLIERS.size() - 1)
	var comfort_scale := GameState.get_motion_comfort_scale()
	_drift_phase += maxf(delta, 0.0) * SPEED_MULTIPLIERS[speed_index]
	$VoyageWorld/DioramaCameraRig.position.y = _diorama_camera_base_position.y + sin(_drift_phase * 1.2) * 0.018 * comfort_scale
	$VoyageWorld/LookAroundCameraRig.position.y = _look_around_camera_base_position.y + sin(_drift_phase * 1.2) * 0.018 * comfort_scale
	$VoyageWorld/AppreciationCameraRig.position.y = _appreciation_camera_base_position.y + sin(_drift_phase * 1.2) * 0.025 * comfort_scale
	var boat_bob_signal := sin(_drift_phase * 1.05 + 0.45)
	var boat_bob := boat_bob_signal * 0.052 * comfort_scale
	$VoyageWorld/BoatSpace.position.y = _boat_space_base_position.y + boat_bob
	$VoyageWorld/BoatSpace.rotation = _boat_space_base_rotation + Vector3(0.0, 0.0, sin(_drift_phase * 0.82 + 0.2) * deg_to_rad(1.15) * comfort_scale)
	var water_contact := $VoyageWorld/BoatWaterContact as Sprite3D
	if water_contact != null:
		var contact_breath := 1.0 + sin(_drift_phase * 1.05 - 0.2) * 0.028 * comfort_scale
		water_contact.position = _boat_water_contact_base_position + Vector3(0.0, boat_bob * 0.12, 0.0)
		water_contact.scale = _boat_water_contact_base_scale * contact_breath
		var contact_modulate := _boat_water_contact_base_modulate
		contact_modulate.a *= 0.88 + maxf(boat_bob_signal, 0.0) * 0.18
		water_contact.modulate = contact_modulate


<<<<<<< HEAD
func _advance_drift_scenery(delta: float) -> void:
	var event := _drift_scenery_director.advance(delta, _active_atmosphere_id)
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
	)


func _show_temporary_ambient_scenery_backdrop(texture_path: String, backdrop_offset_x: float) -> void:
	if texture_path.is_empty():
		return
	var scenery_texture := load(texture_path) as Texture2D
	if scenery_texture == null:
		return
	var diorama_backdrop := $VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop as Sprite3D
	var appreciation_backdrop := $VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeaBackdrop as Sprite3D
	diorama_backdrop.texture = scenery_texture
	appreciation_backdrop.texture = scenery_texture
	diorama_backdrop.position = _diorama_backdrop_base_position + Vector3(backdrop_offset_x, 0.0, 0.0)
	appreciation_backdrop.position = _appreciation_backdrop_base_position + Vector3(backdrop_offset_x, 0.0, 0.0)
	%AmbientSceneryReturnTimer.start()


func _restore_active_atmosphere_backdrop() -> void:
	_apply_atmosphere_id(_active_atmosphere_id)


func _reset_temporary_ambient_backdrop_positions() -> void:
	var diorama_backdrop := $VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop as Sprite3D
	var appreciation_backdrop := $VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeaBackdrop as Sprite3D
	diorama_backdrop.position = _diorama_backdrop_base_position
	appreciation_backdrop.position = _appreciation_backdrop_base_position


func _hide_distant_scenery() -> void:
	%DistantSceneryLabel.visible = false
=======
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
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564


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
<<<<<<< HEAD
	var controls_visible := not GameState.appreciation_mode
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
=======
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
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
	%AppreciationButton.text = "감상 끝내기" if GameState.appreciation_mode else "감상모드"
	%LookAroundButton.text = "기본 시점" if _look_around_mode else "둘러보기"
	if GameState.appreciation_mode:
		_close_decor_panel()
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
