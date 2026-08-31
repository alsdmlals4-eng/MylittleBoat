# 기본 항해 화면의 둘러보기 카메라 드래그와 시점 분류를 관리한다.
extends Node3D

signal angle_changed(angle_id: String)

@export var mouse_sensitivity := 0.12
@export var touch_sensitivity := 0.12
@export var min_pitch_degrees := -16.0
@export var max_pitch_degrees := 38.0
@export var min_yaw_degrees := -135.0
@export var max_yaw_degrees := 135.0
@export var side_angle_threshold_degrees := 52.0
@export var aft_angle_threshold_degrees := 112.0
@export var overhead_pitch_threshold_degrees := 28.0

@onready var _controlled_camera := get_node_or_null("LookAroundCamera3D") as Camera3D

var _dragging := false
var _yaw_degrees := 0.0
var _pitch_degrees := 0.0
var _last_angle_id := "front"


func _ready() -> void:
	_pitch_degrees = clampf(rad_to_deg(rotation.x), min_pitch_degrees, max_pitch_degrees)
	_yaw_degrees = clampf(rad_to_deg(rotation.y), min_yaw_degrees, max_yaw_degrees)
	_apply_camera_rotation()
	_last_angle_id = get_angle_id()


func _is_input_active() -> bool:
	return _controlled_camera != null and _controlled_camera.current


func _unhandled_input(event: InputEvent) -> void:
	if not _is_input_active():
		_dragging = false
		return

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		_dragging = event.pressed
	elif event is InputEventMouseMotion and _dragging:
		_rotate_from_delta(event.relative, mouse_sensitivity)
		get_viewport().set_input_as_handled()
	elif event is InputEventScreenDrag:
		_rotate_from_delta(event.relative, touch_sensitivity)
		get_viewport().set_input_as_handled()


func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_MOUSE_EXIT:
		_dragging = false


func set_view_angles(yaw_degrees: float, pitch_degrees: float) -> void:
	_yaw_degrees = clampf(yaw_degrees, min_yaw_degrees, max_yaw_degrees)
	_pitch_degrees = clampf(pitch_degrees, min_pitch_degrees, max_pitch_degrees)
	_apply_camera_rotation()


func get_angle_id() -> String:
	if _pitch_degrees >= overhead_pitch_threshold_degrees:
		return "overhead"
	if absf(_yaw_degrees) >= aft_angle_threshold_degrees:
		return "aft"
	if _yaw_degrees >= side_angle_threshold_degrees:
		return "port"
	if _yaw_degrees <= -side_angle_threshold_degrees:
		return "starboard"
	return "front"


func _rotate_from_delta(delta: Vector2, sensitivity: float) -> void:
	set_view_angles(
		_yaw_degrees - delta.x * sensitivity,
		_pitch_degrees - delta.y * sensitivity,
	)


func _apply_camera_rotation() -> void:
	rotation_degrees = Vector3(_pitch_degrees, _yaw_degrees, 0.0)
	var next_angle_id := get_angle_id()
	if next_angle_id == _last_angle_id:
		return
	_last_angle_id = next_angle_id
	angle_changed.emit(next_angle_id)
