# 외형 선택만 별도 로컬 ConfigFile에 저장하고 복원한다.
class_name CosmeticIdentityProfile
extends RefCounted

const DEFAULT_PATH := "user://identity_profile_v1.cfg"
const CATALOG_SCRIPT = preload("res://scripts/identity/identity_visual_catalog.gd")

var _path: String
var _store := preload("res://scripts/core/recoverable_config_store.gd").new()
var _last_storage_result: Dictionary = {}
var _catalog = CATALOG_SCRIPT.new()


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
	if config.has_section_key("identity", "player_style_id"):
		var style: Variant = config.get_value("identity", "player_style_id")
		if not style is String or style not in _catalog.get_player_style_ids():
			return false
	if config.has_section_key("identity", "pet_type_id"):
		var pet: Variant = config.get_value("identity", "pet_type_id")
		if not pet is String or pet not in _catalog.get_pet_type_ids():
			return false
	return true


func save(player_style_id: String, pet_type_id: String) -> Error:
	var config := ConfigFile.new()
	config.set_value("identity", "player_style_id", normalize_player_style(player_style_id))
	config.set_value("identity", "pet_type_id", normalize_pet_type(pet_type_id))
	_last_storage_result = _store.write_validated(_path, config, _validate)
	return OK if _last_storage_result.status == "COMMITTED" else _last_storage_result.error


func load() -> Dictionary:
	var config := _load_config()
	if config == null:
		return _default_identity()
	return {
		"player_style_id": normalize_player_style(str(config.get_value("identity", "player_style_id", ""))),
		"pet_type_id": normalize_pet_type(str(config.get_value("identity", "pet_type_id", ""))),
	}


func normalize_player_style(value: String) -> String:
	return _catalog.normalize_player_style(value)


func normalize_pet_type(value: String) -> String:
	return _catalog.normalize_pet_type(value)


func _default_identity() -> Dictionary:
	return {
		"player_style_id": _catalog.DEFAULT_PLAYER_STYLE,
		"pet_type_id": _catalog.DEFAULT_PET_TYPE,
	}
