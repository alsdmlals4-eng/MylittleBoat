# 함께한 시간 저장값이 손상 없이 복원되는지 검증한다.
extends SceneTree

const PERSISTENCE_PATH := "res://scripts/core/together_time_persistence.gd"
const STORAGE_PATH := "user://test_together_time_persistence.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_cleanup_test_storage()
	_expect(ResourceLoader.exists(PERSISTENCE_PATH), "together-time persistence owner must exist")
	if not ResourceLoader.exists(PERSISTENCE_PATH):
		_finish()
		return
	var persistence: Variant = (load(PERSISTENCE_PATH) as Script).new(STORAGE_PATH)
	_expect(is_zero_approx(persistence.load_seconds()), "missing local together-time file must restore zero")
	_expect(persistence.save_seconds(125.5) == OK, "persistence must save a positive total")
	_expect(is_equal_approx(persistence.load_seconds(), 125.5), "saved together time must round-trip exactly")
	_write_raw_config("[together_time]\nseconds=-9.0\n")
	_expect(is_zero_approx(persistence.load_seconds()), "negative saved together time must normalize to zero")
	_write_raw_config("[together_time]\nseconds=\"bad\"\n")
	_expect(is_zero_approx(persistence.load_seconds()), "non-numeric saved together time must normalize to zero")
	_finish()


func _write_raw_config(contents: String) -> void:
	var file := FileAccess.open(STORAGE_PATH, FileAccess.WRITE)
	_expect(file != null, "test must be able to write its isolated ConfigFile")
	if file == null:
		return
	file.store_string(contents)


func _cleanup_test_storage() -> void:
	DirAccess.remove_absolute(ProjectSettings.globalize_path(STORAGE_PATH))


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	_cleanup_test_storage()
	if _failures == 0:
		print("PASS: together time persistence contract")
		quit(0)
	else:
		printerr("FAILED: %d together-time persistence assertions" % _failures)
		quit(1)
