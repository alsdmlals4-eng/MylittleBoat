<<<<<<< HEAD
# 자동 풍경 기억만 로컬 ConfigFile에 저장하고 복원한다.
class_name AmbientMemoryPersistence
extends RefCounted

const DEFAULT_PATH := "user://ambient_memory_v1.cfg"
=======
# 자동 저장되는 주변 풍경 기억을 로컬 ConfigFile에 보관한다.
class_name AmbientMemoryPersistence
extends RefCounted

const DEFAULT_PATH := "user://ambient_memories_v1.cfg"
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564

var _path: String


func _init(path: String = DEFAULT_PATH) -> void:
	_path = path


<<<<<<< HEAD
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
=======
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
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
