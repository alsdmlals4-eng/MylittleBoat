# 물고기와 완료 항해 기록만 로컬 ConfigFile에 저장하고 복원한다.
class_name MemoryLedgerPersistence
extends RefCounted

const DEFAULT_PATH := "user://memory_ledger_v1.cfg"

var _path: String


func _init(path: String = DEFAULT_PATH) -> void:
	_path = path


func save_entries(fish_entries: Array[String], voyage_entries: Array[String]) -> Error:
	var config := ConfigFile.new()
	config.set_value("memory_ledger", "fish", _normalize_entries(fish_entries))
	config.set_value("memory_ledger", "voyage_records", _normalize_entries(voyage_entries))
	return config.save(_path)


func load_entries() -> Dictionary:
	var config := ConfigFile.new()
	if config.load(_path) != OK:
		return {"fish": [], "voyage_records": []}
	return {
		"fish": _normalize_entries(config.get_value("memory_ledger", "fish", [])),
		"voyage_records": _normalize_entries(config.get_value("memory_ledger", "voyage_records", [])),
	}


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
