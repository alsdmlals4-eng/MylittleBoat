# 자동 저장되는 주변 풍경 기억이 로컬에서 안전하게 복원되는지 검증한다.
extends SceneTree

const PERSISTENCE_PATH := "res://scripts/core/ambient_memory_persistence.gd"
const TEST_SAVE_PATH := "user://ambient_memory_persistence_contract.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_remove_test_save()
	_expect(ResourceLoader.exists(PERSISTENCE_PATH), "ambient memory persistence must exist")
	if ResourceLoader.exists(PERSISTENCE_PATH):
		var persistence = load(PERSISTENCE_PATH).new(TEST_SAVE_PATH)
		var test_entries: Array[String] = ["지나간 작은 섬", "지나간 등대"]
		_expect(persistence.load() == [], "missing ambient memory file must start empty")
		_expect(persistence.save(test_entries) == OK, "ambient memories must save locally")
		_expect(persistence.load() == test_entries, "saved ambient memories must restore in order")
	_remove_test_save()
	_finish()


func _remove_test_save() -> void:
	if FileAccess.file_exists(TEST_SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_SAVE_PATH))


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: ambient memory persistence contract")
		quit(0)
	else:
		printerr("FAILED: %d ambient memory persistence assertions" % _failures)
		quit(1)
