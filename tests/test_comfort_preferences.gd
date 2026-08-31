# 움직임 편안함 설정이 local ConfigFile에서 안전하게 복원되는지 검증한다.
extends SceneTree

const PERSISTENCE_PATH := "res://scripts/core/comfort_preferences.gd"
const STORAGE_PATH := "user://test_comfort_preferences.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_remove_test_file()
	_expect(ResourceLoader.exists(PERSISTENCE_PATH), "comfort-preferences persistence owner must exist")
	if not ResourceLoader.exists(PERSISTENCE_PATH):
		_finish()
		return
	var preferences: Variant = (load(PERSISTENCE_PATH) as Script).new(STORAGE_PATH)
	_expect(preferences.load_profile() == "standard", "missing comfort file must restore standard motion")
	_expect(preferences.save_profile("gentle") == OK, "valid gentle profile must save locally")
	_expect(preferences.load_profile() == "gentle", "saved comfort profile must round-trip")
	_expect(preferences.normalize_profile("unknown") == "standard", "unknown motion profile must normalize to standard")
	_expect(is_equal_approx(preferences.get_motion_scale("standard"), 1.0), "standard profile must preserve approved motion amplitude")
	_expect(is_equal_approx(preferences.get_motion_scale("gentle"), 0.5), "gentle profile must halve automatic motion amplitude")
	_expect(is_zero_approx(preferences.get_motion_scale("still")), "still profile must remove automatic motion amplitude")
	_write_raw_config("[comfort]\nprofile=\"invalid\"\n")
	_expect(preferences.load_profile() == "standard", "malformed stored profile must safely restore standard")
	_remove_test_file()
	_finish()


func _write_raw_config(contents: String) -> void:
	var file := FileAccess.open(STORAGE_PATH, FileAccess.WRITE)
	_expect(file != null, "test must be able to write its isolated comfort ConfigFile")
	if file != null:
		file.store_string(contents)


func _remove_test_file() -> void:
	if FileAccess.file_exists(STORAGE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(STORAGE_PATH))


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: comfort-preferences persistence contract")
		quit(0)
	else:
		printerr("FAILED: %d comfort-preferences persistence assertions" % _failures)
		quit(1)
