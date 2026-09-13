# 함께한 시간 하나만 로컬 ConfigFile에 저장하고 복원한다.
class_name TogetherTimePersistence
extends RefCounted

const DEFAULT_PATH := "user://together_time_v1.cfg"

var _path: String
var _store := preload("res://scripts/core/recoverable_config_store.gd").new()
var _last_storage_result: Dictionary = {}


func _init(path: String = DEFAULT_PATH) -> void:
	_path = path

func get_last_storage_result() -> Dictionary:
	return _last_storage_result.duplicate()


func recover_primary() -> Dictionary:
	_last_storage_result = _store.recover_primary(_path, _validate)
	return get_last_storage_result()


func _load_config() -> ConfigFile:
	_last_storage_result = _store.read_validated(_path, _validate)
	return _store.config_for_legacy_read(_path, _last_storage_result)


func _validate(config: ConfigFile) -> bool:
	var seconds: Variant = config.get_value("together_time", "seconds", 0.0)
	return (seconds is float or seconds is int) and is_finite(float(seconds)) and float(seconds) >= 0.0


func save_seconds(value: float) -> Error:
	var config := ConfigFile.new()
	config.set_value("together_time", "seconds", _normalize_seconds(value))
	_last_storage_result = _store.write_validated(_path, config, _validate)
	return OK if _last_storage_result.status == "COMMITTED" else _last_storage_result.error


func load_seconds() -> float:
	var config := _load_config()
	if config == null:
		return 0.0
	var raw_value: Variant = config.get_value("together_time", "seconds", 0.0)
	if typeof(raw_value) != TYPE_FLOAT and typeof(raw_value) != TYPE_INT:
		return 0.0
	return _normalize_seconds(float(raw_value))


func _normalize_seconds(value: float) -> float:
	if is_nan(value) or is_inf(value) or value < 0.0:
		return 0.0
	return value
