# 런타임 캡처가 실제로 로드 가능한 승인 이미지에서만 시작하는지 검증한다.
extends SceneTree

const GUARD_PATH := "res://scripts/visual/runtime_capture_guard.gd"
const APPROVED_TEXTURE_PATH := "res://assets/images/runtime/storybook/boat_c_dog_diorama_storybook.png"
const MISSING_TEXTURE_PATH := "res://assets/images/runtime/storybook/missing.png"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(ResourceLoader.exists(GUARD_PATH), "runtime capture guard must exist")
	if ResourceLoader.exists(GUARD_PATH):
		var guard = load(GUARD_PATH).new()
		_expect(guard.has_method("get_unavailable_texture_paths"), "capture guard must expose resource availability check")
		if guard.has_method("get_unavailable_texture_paths"):
			var approved_paths: Array[String] = [APPROVED_TEXTURE_PATH]
			var missing_paths: Array[String] = [MISSING_TEXTURE_PATH]
			_expect(guard.get_unavailable_texture_paths(approved_paths).is_empty(), "imported approved texture must be capture-ready")
			_expect(guard.get_unavailable_texture_paths(missing_paths) == missing_paths, "missing texture must block capture")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: runtime capture guard contract")
		quit(0)
	else:
		printerr("FAILED: %d runtime capture guard assertions" % _failures)
		quit(1)
