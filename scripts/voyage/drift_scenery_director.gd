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
