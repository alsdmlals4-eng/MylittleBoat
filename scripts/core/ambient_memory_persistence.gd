# 자동 풍경 기억만 로컬 ConfigFile에 저장하고 복원한다.
class_name AmbientMemoryPersistence
extends RefCounted

const DEFAULT_PATH := "user://ambient_memory_v1.cfg"

var _path: String


func _init(path: String = DEFAULT_PATH) -> void:
	_path = path


func save_entries(entries: Array[String]) -> Error:
	var config := ConfigFile.new()
	config.set_value("ambient_memory", "entries", _normalize_entries(entries))
	return config.save(_path)


func load_entries() -> Array[String]:
	var config := ConfigFile.new()
	if config.load(_path) != OK:
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
