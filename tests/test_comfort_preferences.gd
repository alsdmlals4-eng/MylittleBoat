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
	_expect(preferences.has_method("get_last_storage_result"), "comfort must expose recovery state")
	_expect(preferences.load_profile() == "standard", "missing comfort file must restore standard motion")
	_expect(preferences.save_profile("gentle") == OK, "valid gentle profile must save locally")
	_expect(preferences.load_profile() == "gentle", "saved comfort profile must round-trip")
	_expect(preferences.has_method("save_ocean_volume"), "comfort owner must persist ocean volume without replacing motion choice")
	if preferences.has_method("save_ocean_volume"):
		_expect(is_equal_approx(preferences.load_ocean_volume(), 1.0), "legacy motion-only file must keep original ocean mix")
		_expect(preferences.save_ocean_volume(0.25) == OK, "quiet ocean setting must save")
		_expect(preferences.load_profile() == "gentle", "audio save must preserve motion choice")
		_expect(preferences.save_profile("still") == OK, "motion change must still save")
		_expect(is_equal_approx(preferences.load_ocean_volume(), 0.25), "motion save must preserve audio choice")
		_expect(preferences.save_ocean_volume(0.0) == OK and is_zero_approx(preferences.load_ocean_volume()), "mute must survive reload")
		_expect(preferences.save_ocean_volume(NAN) == ERR_INVALID_PARAMETER, "non-finite gain must be rejected")
		_expect(is_zero_approx(preferences.load_ocean_volume()), "invalid gain must not overwrite mute")
		_expect(preferences.save_ocean_volume(2.0) == ERR_INVALID_PARAMETER, "gain above original mix must be rejected")
		_expect(preferences.save_ocean_volume(-0.1) == ERR_INVALID_PARAMETER, "negative gain must be rejected")
		_write_raw_config("[comfort]\nprofile=\"still\"\nocean_volume=0.5\n\n[future]\nretained=\"keep\"\n")
		preferences.save_ocean_volume(0.75)
		var preserved := ConfigFile.new()
		preserved.load(STORAGE_PATH)
		_expect(preserved.get_value("future", "retained", "") == "keep", "audio update must preserve unrelated preference keys")
		_write_raw_config("[comfort]\nocean_volume=\"wrong\"\n")
		_expect(is_equal_approx(preferences.load_ocean_volume(), 0.5), "invalid persisted type recovers verified last good gain")
		_expect(preferences.get_last_storage_result().status == "RECOVERED", "backup reading is exposed separately")
		_write_raw_config("[comfort]\nocean_volume=[\n")
		var damaged_bytes := FileAccess.get_file_as_bytes(STORAGE_PATH)
		var previous_output := Engine.print_error_messages
		Engine.print_error_messages = false
		var error: Error = preferences.save_ocean_volume(0.0)
		Engine.print_error_messages = previous_output
		_expect(error == ERR_PARSE_ERROR, "malformed preference must reject disk write")
		_expect(FileAccess.get_file_as_bytes(STORAGE_PATH) == damaged_bytes, "malformed preference bytes must remain available for recovery")
	_expect(preferences.normalize_profile("unknown") == "standard", "unknown motion profile must normalize to standard")
	_expect(is_equal_approx(preferences.get_motion_scale("standard"), 1.0), "standard profile must preserve approved motion amplitude")
	_expect(is_equal_approx(preferences.get_motion_scale("gentle"), 0.5), "gentle profile must halve automatic motion amplitude")
	_expect(is_zero_approx(preferences.get_motion_scale("still")), "still profile must remove automatic motion amplitude")
	_write_raw_config("[comfort]\nprofile=\"invalid\"\n")
	_expect(preferences.load_profile() == "still", "malformed stored profile recovers last good profile")
	_expect(preferences.recover_primary().status == "COMMITTED", "owner exposes explicit verified recovery")
	_expect(preferences.save_profile("gentle") == OK, "owner writes again only after verified recovery")
	_remove_test_file()
	_finish()


func _write_raw_config(contents: String) -> void:
	var file := FileAccess.open(STORAGE_PATH, FileAccess.WRITE)
	_expect(file != null, "test must be able to write its isolated comfort ConfigFile")
	if file != null:
		file.store_string(contents)


func _remove_test_file() -> void:
	preload("res://tests/helpers/config_store_test_cleanup.gd").remove_store(STORAGE_PATH)


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
