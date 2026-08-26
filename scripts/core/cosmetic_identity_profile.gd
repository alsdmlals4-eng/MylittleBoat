# 외형 선택만 별도 로컬 ConfigFile에 저장하고 복원한다.
class_name CosmeticIdentityProfile
extends RefCounted

const DEFAULT_PATH := "user://identity_profile_v1.cfg"
const CATALOG_SCRIPT = preload("res://scripts/identity/identity_visual_catalog.gd")

var _path: String
var _catalog = CATALOG_SCRIPT.new()


func _init(path: String = DEFAULT_PATH) -> void:
	_path = path


func save(player_style_id: String, pet_type_id: String) -> Error:
	var config := ConfigFile.new()
	config.set_value("identity", "player_style_id", normalize_player_style(player_style_id))
	config.set_value("identity", "pet_type_id", normalize_pet_type(pet_type_id))
	return config.save(_path)


func load() -> Dictionary:
	var config := ConfigFile.new()
	if config.load(_path) != OK:
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
