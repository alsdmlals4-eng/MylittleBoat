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
	var config := ConfigFile.new()
	config.set_value("comfort", "profile", normalize_profile(profile))
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
