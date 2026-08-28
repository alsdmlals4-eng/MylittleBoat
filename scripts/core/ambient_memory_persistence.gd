# 자동 저장되는 주변 풍경 기억을 로컬 ConfigFile에 보관한다.
class_name AmbientMemoryPersistence
extends RefCounted

const DEFAULT_PATH := "user://ambient_memories_v1.cfg"

var _path: String


func _init(path: String = DEFAULT_PATH) -> void:
	_path = path


func save(entries: Array[String]) -> Error:
	var config := ConfigFile.new()
	config.set_value("ambient_memory", "sceneries", entries)
	return config.save(_path)


func load() -> Array[String]:
	var config := ConfigFile.new()
	if config.load(_path) != OK:
		return []
	var stored = config.get_value("ambient_memory", "sceneries", [])
	if not stored is Array:
		return []
	var result: Array[String] = []
	for entry in stored:
		if entry is String and not entry.strip_edges().is_empty():
			result.append(entry)
	return result
