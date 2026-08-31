# 함께한 시간 하나만 로컬 ConfigFile에 저장하고 복원한다.
class_name TogetherTimePersistence
extends RefCounted

const DEFAULT_PATH := "user://together_time_v1.cfg"

var _path: String


func _init(path: String = DEFAULT_PATH) -> void:
	_path = path


func save_seconds(value: float) -> Error:
	var config := ConfigFile.new()
	config.set_value("together_time", "seconds", _normalize_seconds(value))
	return config.save(_path)


func load_seconds() -> float:
	var config := ConfigFile.new()
	if config.load(_path) != OK:
		return 0.0
	var raw_value: Variant = config.get_value("together_time", "seconds", 0.0)
	if typeof(raw_value) != TYPE_FLOAT and typeof(raw_value) != TYPE_INT:
		return 0.0
	return _normalize_seconds(float(raw_value))


func _normalize_seconds(value: float) -> float:
	if is_nan(value) or is_inf(value) or value < 0.0:
		return 0.0
	return value
