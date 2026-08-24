# Resting-pet technical placeholder.
# It exists to validate low-pressure idle timing and scene composition, not final pet art.
extends Node3D

const RESTING_STATES: Array[String] = ["watch_sea", "rest", "nap", "glance"]
const MIN_IDLE_SECONDS := 12.0
const MAX_IDLE_SECONDS := 24.0

var _resting_state := "watch_sea"
var _next_idle_seconds := 16.0
var _elapsed := 0.0
var _breath_phase := 0.0
var _base_scale := Vector3.ONE


func _ready() -> void:
	_base_scale = scale


func _process(delta: float) -> void:
	var safe_delta := maxf(delta, 0.0)
	_elapsed += safe_delta
	_breath_phase += safe_delta * 0.75

	# Subtle breathing only; no attention-demanding bounce or notification.
	var breath := 1.0 + sin(_breath_phase) * 0.012
	scale = Vector3(_base_scale.x, _base_scale.y * breath, _base_scale.z)

	if _elapsed >= _next_idle_seconds:
		_elapsed = 0.0
		_advance_resting_state()
		_next_idle_seconds = randf_range(MIN_IDLE_SECONDS, MAX_IDLE_SECONDS)


func get_resting_state() -> String:
	return _resting_state


func get_next_idle_seconds() -> float:
	return _next_idle_seconds


func has_care_obligation() -> bool:
	return false


func _advance_resting_state() -> void:
	var current_index := RESTING_STATES.find(_resting_state)
	if current_index < 0:
		current_index = 0
	_resting_state = RESTING_STATES[(current_index + 1) % RESTING_STATES.size()]

	# Keep visual changes tiny and readable as posture shifts, never as a demand.
	match _resting_state:
		"watch_sea":
			rotation.y = 0.0
		"rest":
			rotation.y = 0.08
		"nap":
			rotation.y = -0.06
		"glance":
			rotation.y = 0.18
