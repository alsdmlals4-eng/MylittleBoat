# 5분 항해의 디오라마·감상 카메라와 발견·낚시 상호작용을 관리한다.
extends Control

const FISHING_SESSION_SCRIPT = preload("res://scripts/voyage/fishing_session.gd")

const SPEED_NAMES: Array[String] = ["느림", "보통", "빠름"]
const SPEED_MULTIPLIERS: Array[float] = [0.65, 1.0, 1.45]
const LETTER_TEXTS: Array[String] = [
	"오늘은 아무것도 증명하지 않아도 괜찮아요.",
	"조용한 바다는 당신의 속도를 기다려줍니다.",
	"작은 항해도 충분히 멀리 갈 수 있어요."
]
const SCENERY_NAMES: Array[String] = ["일출", "비", "고래", "밤바다"]
const FISH_NAMES: Array[String] = ["정어리", "전갱이", "고등어", "도미"]

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
var _discovery_wait_remaining := 0.0
var _discovery_offer_remaining := 0.0
var _drift_phase := 0.0
var _diorama_camera_base_position := Vector3.ZERO
var _appreciation_camera_base_position := Vector3.ZERO
var _boat_base_position := Vector3.ZERO
var _avatar_base_position := Vector3.ZERO
var _pet_base_position := Vector3.ZERO


func _ready() -> void:
	randomize()
	if not GameState.voyage_active:
		GameState.begin_voyage(GameState.selected_mood)

	_diorama_camera_base_position = $VoyageWorld/DioramaCameraRig.position
	_appreciation_camera_base_position = $VoyageWorld/AppreciationCameraRig.position
	_boat_base_position = $VoyageWorld/BoatBow.position
	_avatar_base_position = $VoyageWorld/PlayerAvatarPlaceholder.position
	_pet_base_position = $VoyageWorld/RestingPetPlaceholder.position
	_apply_mood_tone()

	%TakePhotoButton.pressed.connect(_take_photo)
	%AppreciationButton.pressed.connect(_toggle_appreciation_mode)
	%SpeedButton.pressed.connect(_cycle_speed)
	%FishingButton.pressed.connect(_handle_fishing_action)
	%LetterButton.pressed.connect(_record_pending_letter)
	%SceneryButton.pressed.connect(_record_pending_scenery)
	%AlbumButton.pressed.connect(_open_album)
	%NextVoyageButton.pressed.connect(_start_next_voyage)

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


## Applies only a subtle sky shift so mood changes interpretation without becoming good/bad weather.
func _apply_mood_tone() -> void:
	var world_environment := $VoyageWorld/WorldEnvironment as WorldEnvironment
	if world_environment.environment == null:
		return
	var mood_color: Color = MOOD_SKY_COLORS.get(GameState.selected_mood, MOOD_SKY_COLORS["평온"])
	world_environment.environment.background_color = mood_color


## Adds a simple photo record to the album.
func _take_photo() -> void:
	GameState.add_photo("사진 %d - %s의 바다" % [GameState.photos.size() + 1, GameState.selected_mood])
	_update_ui("사진을 한 장 남겼습니다. 동반자가 가까이 다가옵니다.")


## Toggles quiet appreciation mode and switches between diorama life and sea-focused viewing.
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


## Cycles drift rhythm between slow, normal, and fast without changing rewards or voyage duration.
func _cycle_speed() -> void:
	GameState.speed_index = (GameState.speed_index + 1) % SPEED_NAMES.size()
	_update_ui("표류 리듬을 %s으로 바꿨습니다." % SPEED_NAMES[GameState.speed_index])


## Applies subtle shared boat-space bob plus camera drift without changing progression.
func _apply_drift_motion(delta: float) -> void:
	var speed_index := clampi(GameState.speed_index, 0, SPEED_MULTIPLIERS.size() - 1)
	_drift_phase += maxf(delta, 0.0) * SPEED_MULTIPLIERS[speed_index]
	$VoyageWorld/DioramaCameraRig.position.y = _diorama_camera_base_position.y + sin(_drift_phase * 1.2) * 0.018
	$VoyageWorld/AppreciationCameraRig.position.y = _appreciation_camera_base_position.y + sin(_drift_phase * 1.2) * 0.025
	var boat_bob := sin(_drift_phase * 1.05 + 0.45) * 0.035
	$VoyageWorld/BoatBow.position.y = _boat_base_position.y + boat_bob
	$VoyageWorld/PlayerAvatarPlaceholder.position.y = _avatar_base_position.y + boat_bob
	$VoyageWorld/RestingPetPlaceholder.position.y = _pet_base_position.y + boat_bob


func _schedule_next_discovery(first_discovery: bool = false) -> void:
	if GameState.pending_discovery_type != "":
		return
	if first_discovery:
		_discovery_wait_remaining = randf_range(FIRST_DISCOVERY_MIN_SECONDS, FIRST_DISCOVERY_MAX_SECONDS)
	else:
		_discovery_wait_remaining = randf_range(DISCOVERY_MIN_SECONDS, DISCOVERY_MAX_SECONDS)


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


## Creates one optional ambient discovery instead of vending a reward from a permanent button.
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


## Starts, cancels, or resolves one low-friction fishing wait.
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
	%TakePhotoButton.visible = controls_visible
	%SpeedButton.visible = controls_visible
	%FishingButton.visible = controls_visible
	%AlbumButton.visible = controls_visible
	%AppreciationButton.visible = true
	%AppreciationButton.text = "감상 끝내기" if GameState.appreciation_mode else "감상모드"
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


## Returns to mood selection only after this voyage has been recorded. Accumulated memories stay in GameState.
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
