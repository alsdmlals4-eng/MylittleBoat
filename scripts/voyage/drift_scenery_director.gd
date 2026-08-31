<<<<<<< HEAD
# 포그라운드에 머문 시간만 저밀도 풍경 장면으로 바꾼다.
class_name DriftSceneryDirector
extends RefCounted

const FIRST_EVENT_MIN_SECONDS := 90.0
const FIRST_EVENT_MAX_SECONDS := 150.0
const FOLLOW_UP_EVENT_MIN_SECONDS := 120.0
const FOLLOW_UP_EVENT_MAX_SECONDS := 180.0
const EVENT_EMIT_CHANCE := 0.65
const AMBIENT_MOTIFS_BY_ATMOSPHERE := {
	"dawn": [
		{
			"id": "MLB-AMB-MOTIF-001",
			"label": "안개 너머 바다 아치의 작은 물줄기가 조용히 퍼집니다.",
			"backdrop_texture_path": "res://assets/images/runtime/voyage/ambient_motifs/dawn-sea-arch-waterfall.png",
			"backdrop_offset_x": 8.0,
		},
	],
	"bright": [
		{
			"id": "MLB-AMB-MOTIF-002",
			"label": "얕은 물 아래 해초 리본이 빛을 따라 천천히 흔들립니다.",
			"backdrop_texture_path": "res://assets/images/runtime/voyage/ambient_motifs/bright-seagrass-sandbar.png",
			"backdrop_offset_x": 8.0,
		},
		{
			"id": "MLB-AMB-MOTIF-003",
			"label": "먼 흰 절벽 위로 작은 새 두 마리가 지나갑니다.",
			"backdrop_texture_path": "res://assets/images/runtime/voyage/ambient_motifs/bright-chalk-cliffs-birds.png",
			"backdrop_offset_x": -8.0,
		},
	],
	"sunset": [
		{
			"id": "MLB-AMB-MOTIF-004",
			"label": "따뜻한 사암 코브의 빛이 물 위에 길게 번집니다.",
			"backdrop_texture_path": "res://assets/images/runtime/voyage/ambient_motifs/sunset-sandstone-cove.png",
			"backdrop_offset_x": -8.0,
		},
		{
			"id": "MLB-AMB-MOTIF-005",
			"label": "낮은 갈대섬 곁으로 분홍 구름 그림자가 스쳐 갑니다.",
			"backdrop_texture_path": "res://assets/images/runtime/voyage/ambient_motifs/sunset-reed-islet.png",
			"backdrop_offset_x": 8.0,
		},
	],
	"night": [
		{
			"id": "MLB-AMB-MOTIF-006",
			"label": "먼 푸른 빛과 작은 해파리 불빛이 잔잔히 숨 쉽니다.",
			"backdrop_texture_path": "res://assets/images/runtime/voyage/ambient_motifs/night-bioluminescent-band.png",
			"backdrop_offset_x": 8.0,
		},
	],
}

var _is_foreground := true
var _foreground_elapsed_seconds := 0.0
var _next_event_seconds := 0.0
var _has_scheduled_first_opportunity := false
var _last_motif_id_by_atmosphere: Dictionary = {}


func _init() -> void:
	_schedule_next_event()


func set_foreground(is_foreground: bool) -> void:
	_is_foreground = is_foreground


func advance(delta: float, atmosphere_id: String) -> Dictionary:
	if not _is_foreground or delta <= 0.0:
		return {}
	_foreground_elapsed_seconds += delta
	if _foreground_elapsed_seconds < _next_event_seconds:
		return {}
	_has_scheduled_first_opportunity = true
	var should_emit := randf() < EVENT_EMIT_CHANCE
	_schedule_next_event()
	if not should_emit:
		return {}
	var motif := _pick_motif_for_atmosphere(atmosphere_id)
	if motif.is_empty():
		return {}
	var save_memory := randi_range(0, 2) == 0
	return {
		"motif_id": str(motif["id"]),
		"label": str(motif["label"]),
		"save_memory": save_memory,
		"backdrop_texture_path": str(motif["backdrop_texture_path"]),
		"backdrop_offset_x": float(motif["backdrop_offset_x"]),
	}


func get_foreground_elapsed_seconds() -> float:
	return _foreground_elapsed_seconds


## Makes the next quiet opportunity deterministic without changing its display chance.
func set_next_event_seconds_for_tests(seconds_from_now: float) -> void:
	_next_event_seconds = _foreground_elapsed_seconds + maxf(0.0, seconds_from_now)


## Exposes the scheduled opportunity only for deterministic cadence contracts.
func get_next_event_seconds_for_tests() -> float:
	return _next_event_seconds


func _pick_motif_for_atmosphere(atmosphere_id: String) -> Dictionary:
	var motifs: Array = Array(AMBIENT_MOTIFS_BY_ATMOSPHERE.get(atmosphere_id, []))
	if motifs.is_empty():
		return {}
	var available_motifs: Array = motifs.duplicate()
	var previous_motif_id := str(_last_motif_id_by_atmosphere.get(atmosphere_id, ""))
	if motifs.size() > 1 and not previous_motif_id.is_empty():
		available_motifs = []
		for motif in motifs:
			if str(motif["id"]) != previous_motif_id:
				available_motifs.append(motif)
	var selected_motif := Dictionary(available_motifs.pick_random())
	_last_motif_id_by_atmosphere[atmosphere_id] = str(selected_motif["id"])
	return selected_motif


func _schedule_next_event() -> void:
	var wait_seconds := randf_range(FOLLOW_UP_EVENT_MIN_SECONDS, FOLLOW_UP_EVENT_MAX_SECONDS)
	if not _has_scheduled_first_opportunity:
		wait_seconds = randf_range(FIRST_EVENT_MIN_SECONDS, FIRST_EVENT_MAX_SECONDS)
	_next_event_seconds = _foreground_elapsed_seconds + wait_seconds
=======
# 활성 화면 시간에만 지나가는 먼 풍경 기회를 관리한다.
class_name DriftSceneryDirector
extends RefCounted

const SCENERY_IDS: Array[String] = ["buoy", "islet", "lighthouse"]

var _rng := RandomNumberGenerator.new()
var _active_seconds := 0.0
var _next_scenery_second := 0.0


func _init(seed_value: int = 0) -> void:
	_rng.seed = seed_value if seed_value != 0 else randi()
	_next_scenery_second = _rng.randf_range(90.0, 150.0)


func get_active_seconds() -> float:
	return _active_seconds


func advance(delta: float, is_foreground: bool) -> Dictionary:
	if not is_foreground or delta <= 0.0:
		return {}
	_active_seconds += delta
	if _active_seconds < _next_scenery_second:
		return {}
	var scenery_id := str(SCENERY_IDS[_rng.randi_range(0, SCENERY_IDS.size() - 1)])
	_next_scenery_second += _rng.randf_range(90.0, 150.0)
	return {
		"show_scenery": true,
		"scenery_id": scenery_id,
		"save_memory": _rng.randf() < 0.45,
	}
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
