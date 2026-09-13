# 자동 풍경 기억만 로컬 ConfigFile에 저장하고 복원한다.
class_name AmbientMemoryPersistence
extends RefCounted

const DEFAULT_PATH := "user://ambient_memory_v1.cfg"

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
	var entries: Variant = config.get_value("ambient_memory", "entries", [])
	if not entries is Array:
		return false
	for entry in entries:
		if not entry is String:
			return false
	return true


func save_entries(entries: Array[String]) -> Error:
	var config := ConfigFile.new()
	config.set_value("ambient_memory", "entries", _normalize_entries(entries))
	_last_storage_result = _store.write_validated(_path, config, _validate)
	return OK if _last_storage_result.status == "COMMITTED" else _last_storage_result.error


func load_entries() -> Array[String]:
	var config := _load_config()
	if config == null:
		return []
	return _normalize_entries(config.get_value("ambient_memory", "entries", []))


func _normalize_entries(value: Variant) -> Array[String]:
	if not value is Array:
		return []
	var entries: Array[String] = []
	for raw_entry in value:
		if typeof(raw_entry) != TYPE_STRING:
			continue
		var entry := str(raw_entry).strip_edges()
		if not entry.is_empty():
			entries.append(entry)
	return entries
