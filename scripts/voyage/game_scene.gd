# 5분 항해의 디오라마·보트 생활공간·발견·낚시 상호작용을 관리한다.
extends Control

const FISHING_SESSION_SCRIPT = preload("res://scripts/voyage/fishing_session.gd")
const DECOR_CATALOG_SCRIPT = preload("res://scripts/decor/boat_decor_catalog.gd")
const DECOR_VISUAL_ASSETS_SCRIPT = preload("res://scripts/decor/decor_visual_assets.gd")

const SPEED_NAMES: Array[String] = ["느림", "보통", "빠름"]
const SPEED_MULTIPLIERS: Array[float] = [0.65, 1.0, 1.45]
const LETTER_TEXTS: Array[String] = [
	"오늘은 아무것도 증명하지 않아도 괜찮아요.",
	"조용한 바다는 당신의 속도를 기다려줍니다.",
	"작은 항해도 충분히 멀리 갈 수 있어요."
]
const SCENERY_NAMES: Array[String] = ["일출", "비", "고래", "밤바다"]
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
const MOOD_SKY_COLORS := {
	"평온": Color(0.58, 0.76, 0.86, 1.0),
	"지침": Color(0.60, 0.72, 0.80, 1.0),
	"외로움": Color(0.55, 0.69, 0.82, 1.0),
	"설렘": Color(0.66, 0.80, 0.88, 1.0),
}
const FIRST_DISCOVERY_MIN_SECONDS := 18.0
const FIRST_DISCOVERY_MAX_SECONDS := 30.0
const DISCOVERY_MIN_SECONDS := 35.0
const DISCOVERY_MAX_SECONDS := 60.0
const DISCOVERY_OFFER_SECONDS := 18.0
const FISHING_WAIT_MIN_SECONDS := 6.0
const FISHING_WAIT_MAX_SECONDS := 12.0

var _fishing_session = FISHING_SESSION_SCRIPT.new()
var _decor_catalog = DECOR_CATALOG_SCRIPT.new()
var _decor_visual_assets = DECOR_VISUAL_ASSETS_SCRIPT.new()
var _discovery_wait_remaining := 0.0
var _discovery_offer_remaining := 0.0
var _drift_phase := 0.0
var _diorama_camera_base_position := Vector3.ZERO
var _appreciation_camera_base_position := Vector3.ZERO
var _boat_space_base_position := Vector3.ZERO


func _ready() -> void:
	randomize()
	if not GameState.voyage_active:
		GameState.begin_voyage(GameState.selected_mood)
	_diorama_camera_base_position = $VoyageWorld/DioramaCameraRig.position
	_appreciation_camera_base_position = $VoyageWorld/AppreciationCameraRig.position
	_boat_space_base_position = $VoyageWorld/BoatSpace.position
	_apply_mood_tone()
	_apply_stored_boat_decor()
	%TakePhotoButton.pressed.connect(_take_photo)
	%AppreciationButton.pressed.connect(_toggle_appreciation_mode)
	%SpeedButton.pressed.connect(_cycle_speed)
	%FishingButton.pressed.connect(_handle_fishing_action)
	%DecorButton.pressed.connect(_open_decor_panel)
	%InteractButton.pressed.connect(_open_interaction_panel)
	%DecorSlotOption.item_selected.connect(_on_decor_slot_selected)
	%DecorItemOption.item_selected.connect(_on_decor_item_selected)
	%DecorApplyButton.pressed.connect(_apply_selected_decor)
	%DecorClearButton.pressed.connect(_clear_selected_decor)
	%DecorCloseButton.pressed.connect(_close_decor_panel)
	%InteractionTargetOption.item_selected.connect(_on_interaction_target_selected)
	%InteractionPerformButton.pressed.connect(_perform_selected_interaction)
	%InteractionCloseButton.pressed.connect(_close_interaction_panel)
	%LetterButton.pressed.connect(_record_pending_letter)
	%SceneryButton.pressed.connect(_record_pending_scenery)
	%AlbumButton.pressed.connect(_open_album)
	%NextVoyageButton.pressed.connect(_start_next_voyage)
	_populate_decor_slot_options()
	if GameState.pending_discovery_type != "":
		_discovery_offer_remaining = DISCOVERY_OFFER_SECONDS
	else:
		_schedule_next_discovery(GameState.remaining_seconds >= 299.9)
	_sync_discovery_buttons()
	_apply_appreciation_mode()
	var message := "동반자가 곁에서 조용히 바다를 바라봅니다."
	if GameState.remaining_seconds < 299.9 and not GameState.voyage_record_created:
		message = "바다로 돌아왔습니다. 이어서 천천히 항해합니다."
	elif GameState.voyage_record_created:
		message = "오늘의 항해 기록이 남아 있습니다. 더 머물거나 다음 항해를 준비해도 좋아요."
	_update_ui(message)


func _process(delta: float) -> void:
	_apply_drift_motion(delta)
	_advance_fishing(delta)
	_advance_ambient_discovery(delta)
	var completed_now := GameState.tick_voyage(delta)
	if completed_now:
		GameState.complete_voyage()
		_sync_next_voyage_button()
		_update_ui("오늘의 항해 기록이 만들어졌습니다. 더 머물거나 다음 항해를 준비해도 좋아요.")
	else:
		_update_ui()


func _apply_mood_tone() -> void:
	var world_environment := $VoyageWorld/WorldEnvironment as WorldEnvironment
	if world_environment.environment == null:
		return
	var mood_color: Color = MOOD_SKY_COLORS.get(GameState.selected_mood, MOOD_SKY_COLORS["평온"])
	world_environment.environment.background_color = mood_color


func _take_photo() -> void:
	GameState.add_photo("사진 %d - %s의 바다" % [GameState.photos.size() + 1, GameState.selected_mood])
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
	return true


func clear_boat_decor(slot_id: String) -> void:
	var slot: Node = _get_decor_slot(slot_id)
	if slot != null and slot.has_method("apply_item"):
		slot.call("apply_item", "")
	GameState.set_boat_decor(slot_id, "")


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


func _schedule_next_discovery(first_discovery: bool = false) -> void:
	if GameState.pending_discovery_type != "":
		return
	_discovery_wait_remaining = randf_range(FIRST_DISCOVERY_MIN_SECONDS, FIRST_DISCOVERY_MAX_SECONDS) if first_discovery else randf_range(DISCOVERY_MIN_SECONDS, DISCOVERY_MAX_SECONDS)


func _advance_ambient_discovery(delta: float) -> void:
	if GameState.appreciation_mode:
		return
	if GameState.pending_discovery_type != "":
		_discovery_offer_remaining = maxf(0.0, _discovery_offer_remaining - maxf(delta, 0.0))
		if _discovery_offer_remaining <= 0.0:
			GameState.clear_pending_discovery()
			_sync_discovery_buttons()
			_schedule_next_discovery()
			_update_ui("작은 발견은 파도 너머로 조용히 지나갔습니다.")
		return
	_discovery_wait_remaining = maxf(0.0, _discovery_wait_remaining - maxf(delta, 0.0))
	if _discovery_wait_remaining <= 0.0:
		_spawn_ambient_discovery()


func _spawn_ambient_discovery() -> void:
	if GameState.pending_discovery_type != "":
		return
	if randi() % 2 == 0:
		var letter: String = str(LETTER_TEXTS.pick_random())
		GameState.set_pending_discovery("letter", letter)
		_update_ui("물결 사이로 작은 병 하나가 천천히 떠올랐습니다.")
	else:
		var scenery: String = str(SCENERY_NAMES.pick_random())
		GameState.set_pending_discovery("scenery", scenery)
		_update_ui("멀리서 %s 풍경이 눈에 들어옵니다." % scenery)
	_discovery_offer_remaining = DISCOVERY_OFFER_SECONDS
	_sync_discovery_buttons()


func _record_pending_letter() -> void:
	if GameState.pending_discovery_type != "letter":
		return
	var letter := GameState.pending_discovery_value
	GameState.add_letter(letter)
	GameState.clear_pending_discovery()
	_sync_discovery_buttons()
	_schedule_next_discovery()
	_update_ui("병 속 편지를 읽고 기억에 남겼습니다: %s" % letter)


func _record_pending_scenery() -> void:
	if GameState.pending_discovery_type != "scenery":
		return
	var scenery := GameState.pending_discovery_value
	GameState.add_scenery(scenery)
	GameState.clear_pending_discovery()
	_sync_discovery_buttons()
	_schedule_next_discovery()
	_update_ui("%s 풍경을 오늘의 기억으로 남겼습니다." % scenery)


func _sync_discovery_buttons() -> void:
	var controls_visible := not GameState.appreciation_mode
	%LetterButton.visible = controls_visible and GameState.pending_discovery_type == "letter"
	%SceneryButton.visible = controls_visible and GameState.pending_discovery_type == "scenery"


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
	var controls_visible := not GameState.appreciation_mode
	$TopPanel.visible = controls_visible
	$BottomPanel.offset_top = -56.0 if GameState.appreciation_mode else -176.0
	$BottomPanel/ButtonGrid.columns = 1 if GameState.appreciation_mode else 2
	%TakePhotoButton.visible = controls_visible
	%SpeedButton.visible = controls_visible
	%FishingButton.visible = controls_visible
	%DecorButton.visible = controls_visible
	%InteractButton.visible = controls_visible
	%AlbumButton.visible = controls_visible
	%AppreciationButton.visible = true
	%AppreciationButton.text = "감상 끝내기" if GameState.appreciation_mode else "감상모드"
	if GameState.appreciation_mode:
		$DecorPanel.visible = false
		$InteractionPanel.visible = false
	_apply_camera_mode()
	_sync_discovery_buttons()
	_sync_next_voyage_button()
	%FishingStatusLabel.visible = controls_visible and %FishingStatusLabel.text != ""


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
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _update_ui(message: String = "") -> void:
	%MoodStatusLabel.text = "마음: %s / 동반자 Lv %d" % [GameState.selected_mood, GameState.companion_affection]
	%TimerLabel.text = _format_time(GameState.remaining_seconds)
	%SpeedButton.text = "속도: %s" % SPEED_NAMES[clampi(GameState.speed_index, 0, SPEED_NAMES.size() - 1)]
	if message != "":
		%StatusLabel.text = message


func _format_time(seconds: float) -> String:
	var total_seconds := int(ceil(seconds))
	var minutes := int(total_seconds / 60)
	var seconds_left := total_seconds % 60
	return "%02d:%02d" % [minutes, seconds_left]
