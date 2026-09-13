# 보트 꾸미기와 외형만 로컬 ConfigFile에 저장하고 복원한다.
class_name BoatDecorPersistence
extends RefCounted

const DEFAULT_PATH := "user://boat_decor_v1.cfg"

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
	if _last_storage_result.config != null:
		return _last_storage_result.config
	# Legacy fallback is read-only; schema-invalid bytes remain barred from saving.
	if _last_storage_result.status == "CORRUPT" and _last_storage_result.error == ERR_INVALID_DATA:
		var legacy := ConfigFile.new()
		if legacy.load(_path) == OK:
			return legacy
	return null


func _validate(config: ConfigFile) -> bool:
	for key in ["items", "appearances"]:
		var value: Variant = config.get_value("boat_decor", key, {})
		if not value is Dictionary:
			return false
		for slot in value:
			if not slot is String or not value[slot] is String:
				return false
	return true


func save(decor: Dictionary, appearances: Dictionary) -> Error:
	var existing := _store.read_validated(_path, _validate)
	if existing.status == "OK" and _has_unsupported_ids(existing.config):
		_last_storage_result = {"status": "NOT_COMMITTED", "error": ERR_UNAVAILABLE, "source_path": _path}
		return ERR_UNAVAILABLE
	var config := ConfigFile.new()
	config.set_value("boat_decor", "items", _string_dictionary(decor))
	config.set_value("boat_decor", "appearances", _string_dictionary(appearances))
	_last_storage_result = _store.write_validated(_path, config, _validate)
	return OK if _last_storage_result.status == "COMMITTED" else _last_storage_result.error


func _has_unsupported_ids(config: ConfigFile) -> bool:
	var catalog := preload("res://scripts/decor/boat_decor_catalog.gd").new()
	var visuals := preload("res://scripts/decor/decor_visual_assets.gd").new()
	var items: Dictionary = config.get_value("boat_decor", "items", {})
	var appearances: Dictionary = config.get_value("boat_decor", "appearances", {})
	for slot in items:
		if slot not in catalog.get_slot_ids() or items[slot] not in catalog.get_item_ids():
			return true
	for slot in appearances:
		if slot not in catalog.get_slot_ids() or appearances[slot] not in visuals.get_cushion_appearance_ids():
			return true
	return false


func load() -> Dictionary:
	var config := _load_config()
	if config == null:
		return {"decor": {}, "appearances": {}}
	return {
		"decor": _string_dictionary(config.get_value("boat_decor", "items", {})),
		"appearances": _string_dictionary(config.get_value("boat_decor", "appearances", {})),
	}


func _string_dictionary(value: Variant) -> Dictionary:
	if not value is Dictionary:
		return {}
	var result: Dictionary = {}
	for key in value:
		if typeof(key) == TYPE_STRING and typeof(value[key]) == TYPE_STRING:
			result[key] = value[key]
	return result
