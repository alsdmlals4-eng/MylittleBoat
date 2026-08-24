# 바다 감상용 Appreciation Camera의 PC 마우스와 모바일 화면 드래그 회전을 관리한다.
extends Node3D

@export var mouse_sensitivity := 0.12
@export var touch_sensitivity := 0.12
@export var min_pitch_degrees := -28.0
@export var max_pitch_degrees := 18.0

@onready var _controlled_camera := get_node_or_null("AppreciationCamera3D") as Camera3D

var _dragging := false
var _yaw_degrees := 0.0
var _pitch_degrees := -6.0


func _ready() -> void:
	_pitch_degrees = clampf(rad_to_deg(rotation.x), min_pitch_degrees, max_pitch_degrees)
	_yaw_degrees = rad_to_deg(rotation.y)
	_apply_camera_rotation()


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


func _rotate_from_delta(delta: Vector2, sensitivity: float) -> void:
	_yaw_degrees -= delta.x * sensitivity
	_pitch_degrees = clampf(_pitch_degrees - delta.y * sensitivity, min_pitch_degrees, max_pitch_degrees)
	_apply_camera_rotation()


func _apply_camera_rotation() -> void:
	rotation_degrees = Vector3(_pitch_degrees, _yaw_degrees, 0.0)
