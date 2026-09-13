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


func _init(path: String = DEFAULT_PATH) -> void:
	_path = path


func save_profile(profile: String) -> Error:
	return _save_value("profile", normalize_profile(profile))


func save_ocean_volume(volume: float) -> Error:
	if not is_finite(volume) or volume < 0.0 or volume > 1.0:
		return ERR_INVALID_PARAMETER
	return _save_value("ocean_volume", volume)


func load_ocean_volume() -> float:
	var config := ConfigFile.new()
	if config.load(_path) != OK:
		return 1.0
	var value: Variant = config.get_value("comfort", "ocean_volume", 1.0)
	if not (value is float or value is int):
		return 1.0
	return float(value) if is_finite(float(value)) and float(value) >= 0.0 and float(value) <= 1.0 else 1.0


func _save_value(key: String, value: Variant) -> Error:
	var config := ConfigFile.new()
	if FileAccess.file_exists(_path):
		var error := config.load(_path)
		if error != OK:
			return error
	config.set_value("comfort", key, value)
	return config.save(_path)


func load_profile() -> String:
	var config := ConfigFile.new()
	if config.load(_path) != OK:
		return "standard"
	return normalize_profile(str(config.get_value("comfort", "profile", "standard")))


func normalize_profile(profile: String) -> String:
	return profile if profile in PROFILE_ORDER else "standard"


func get_motion_scale(profile: String) -> float:
	return float(MOTION_SCALES[normalize_profile(profile)])
