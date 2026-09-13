# 항해 화면의 자동 움직임 편안함 설정을 로컬에 저장하고 정규화한다.
class_name ComfortPreferences
extends RefCounted

const DEFAULT_PATH := "user://comfort_preferences_v1.cfg"
const PROFILE_ORDER: Array[String] = ["standard", "gentle", "still"]
const MOTION_SCALES := {
	"standard": 1.0,
	"gentle": 0.5,
	"still": 0.0,
}

var _path: String
var _store := preload("res://scripts/core/recoverable_config_store.gd").new()
var _last_storage_result: Dictionary = {}


func _init(path: String = DEFAULT_PATH) -> void:
	_path = path


func save_profile(profile: String) -> Error:
	return _save_value("profile", normalize_profile(profile))


func save_ocean_volume(volume: float) -> Error:
	if not is_finite(volume) or volume < 0.0 or volume > 1.0:
		return ERR_INVALID_PARAMETER
	return _save_value("ocean_volume", volume)


func load_ocean_volume() -> float:
	var config := _load_config()
	if config == null:
		return 1.0
	var value: Variant = config.get_value("comfort", "ocean_volume", 1.0)
	if not (value is float or value is int):
		return 1.0
	return float(value) if is_finite(float(value)) and float(value) >= 0.0 and float(value) <= 1.0 else 1.0


func _save_value(key: String, value: Variant) -> Error:
	var read_result := _store.read_validated(_path, _validate)
	var config: ConfigFile = read_result.config
	if read_result.status not in ["OK", "ABSENT"]:
		_last_storage_result = _store.write_validated(_path, ConfigFile.new(), _validate)
		_last_storage_result.error = read_result.error if read_result.error != OK else ERR_FILE_CORRUPT
		return _last_storage_result.error
	if config == null:
		config = ConfigFile.new()
	config.set_value("comfort", key, value)
	_last_storage_result = _store.write_validated(_path, config, _validate)
	return OK if _last_storage_result.status == "COMMITTED" else _last_storage_result.error


func load_profile() -> String:
	var config := _load_config()
	if config == null:
		return "standard"
	return normalize_profile(str(config.get_value("comfort", "profile", "standard")))


func get_last_storage_result() -> Dictionary:
	return _last_storage_result.duplicate()


func recover_primary() -> Dictionary:
	_last_storage_result = _store.recover_primary(_path, _validate)
	return get_last_storage_result()


func _load_config() -> ConfigFile:
	_last_storage_result = _store.read_validated(_path, _validate)
	return _last_storage_result.config


func _validate(config: ConfigFile) -> bool:
	if config.has_section_key("comfort", "profile"):
		var profile: Variant = config.get_value("comfort", "profile")
		if not profile is String or profile not in PROFILE_ORDER:
			return false
	if config.has_section_key("comfort", "ocean_volume"):
		var volume: Variant = config.get_value("comfort", "ocean_volume")
		if not (volume is float or volume is int) or not is_finite(float(volume)) or float(volume) < 0.0 or float(volume) > 1.0:
			return false
	return true


func normalize_profile(profile: String) -> String:
	return profile if profile in PROFILE_ORDER else "standard"


func get_motion_scale(profile: String) -> float:
	return float(MOTION_SCALES[normalize_profile(profile)])
