# 둘러보기 카메라가 활성 입력과 각도 경계를 안전하게 유지하는지 검증한다.
extends SceneTree

const CONTROLLER_PATH := "res://scripts/voyage/look_around_camera_controller.gd"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var controller_script := load(CONTROLLER_PATH)
	_expect(controller_script != null, "look around camera controller must load")
	if controller_script == null:
		_finish()
		return

	var rig := Node3D.new()
	rig.set_script(controller_script)
	var camera := Camera3D.new()
	camera.name = "LookAroundCamera3D"
	rig.add_child(camera)
	root.add_child(rig)
	await process_frame

	camera.current = false
	var inactive_before := rig.rotation_degrees
	var inactive_drag := InputEventScreenDrag.new()
	inactive_drag.relative = Vector2(32.0, -18.0)
	rig.call("_unhandled_input", inactive_drag)
	_expect(rig.rotation_degrees == inactive_before, "inactive Look Around camera must not consume normal diorama drag")

	camera.current = true
	var touch_drag := InputEventScreenDrag.new()
	touch_drag.relative = Vector2(2000.0, -2000.0)
	rig.call("_unhandled_input", touch_drag)
	var touch_rotation := rig.rotation_degrees
	_expect(touch_rotation != inactive_before, "active mobile screen drag must rotate Look Around")
	_expect(is_equal_approx(touch_rotation.z, 0.0), "Look Around drag must keep the horizon level")
	_expect(touch_rotation.x >= -16.0 and touch_rotation.x <= 38.0, "Look Around touch pitch must remain clamped")
	_expect(touch_rotation.y >= -135.0 and touch_rotation.y <= 135.0, "Look Around touch yaw must remain clamped")

	rig.call("set_view_angles", 0.0, 0.0)
	_expect(str(rig.call("get_angle_id")) == "front", "neutral look direction must select the front composition")
	rig.call("set_view_angles", 76.0, 0.0)
	_expect(str(rig.call("get_angle_id")) == "port", "positive yaw must select the port composition")
	rig.call("set_view_angles", -76.0, 0.0)
	_expect(str(rig.call("get_angle_id")) == "starboard", "negative yaw must select the starboard composition")
	rig.call("set_view_angles", 130.0, 0.0)
	_expect(str(rig.call("get_angle_id")) == "aft", "far side yaw must select the aft composition")
	rig.call("set_view_angles", 0.0, 34.0)
	_expect(str(rig.call("get_angle_id")) == "overhead", "high pitch must select the overhead composition")

	rig.call("set_view_angles", 0.0, 0.0)
	var mouse_down := InputEventMouseButton.new()
	mouse_down.button_index = MOUSE_BUTTON_LEFT
	mouse_down.pressed = true
	rig.call("_unhandled_input", mouse_down)
	var mouse_drag := InputEventMouseMotion.new()
	mouse_drag.relative = Vector2(-36.0, 12.0)
	rig.call("_unhandled_input", mouse_drag)
	var mouse_rotation := rig.rotation_degrees
	_expect(mouse_rotation != Vector3.ZERO, "active PC mouse drag must rotate Look Around")
	_expect(is_equal_approx(mouse_rotation.z, 0.0), "PC Look Around drag must keep the horizon level")

	rig.queue_free()
	await process_frame
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: look around camera input contract")
		quit(0)
	else:
		printerr("FAILED: %d Look Around camera assertions" % _failures)
		quit(1)
