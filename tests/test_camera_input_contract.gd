# 모바일 세로 플레이에서 감상 카메라만 화면 드래그를 소비하는지 검증한다.
extends SceneTree

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var controller_script := load("res://scripts/voyage/boat_camera_controller.gd")
	_expect(controller_script != null, "appreciation camera controller must load")
	if controller_script == null:
		_finish()
		return

	var rig := Node3D.new()
	rig.set_script(controller_script)
	var camera := Camera3D.new()
	camera.name = "AppreciationCamera3D"
	rig.add_child(camera)
	root.add_child(rig)
	await process_frame

	camera.current = false
	var inactive_before := rig.rotation_degrees
	var inactive_drag := InputEventScreenDrag.new()
	inactive_drag.relative = Vector2(28.0, -14.0)
	rig.call("_unhandled_input", inactive_drag)
	_expect(rig.rotation_degrees == inactive_before, "inactive Appreciation Camera must not consume normal diorama drag behavior")

	camera.current = true
	var before_rotation := rig.rotation_degrees
	var drag := InputEventScreenDrag.new()
	drag.relative = Vector2(28.0, -14.0)
	rig.call("_unhandled_input", drag)
	var after_rotation := rig.rotation_degrees

	_expect(after_rotation != before_rotation, "mobile screen drag must rotate the active Appreciation Camera rig")
	_expect(is_equal_approx(after_rotation.z, 0.0), "touch camera rotation must keep the horizon level")
	_expect(after_rotation.x >= -28.0 and after_rotation.x <= 18.0, "touch camera pitch must preserve the existing clamp")

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
		print("PASS: appreciation camera input contract")
		quit(0)
	else:
		printerr("FAILED: %d camera input assertions" % _failures)
		quit(1)
