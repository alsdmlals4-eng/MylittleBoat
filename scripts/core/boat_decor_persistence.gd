# 보트 꾸미기와 외형만 로컬 ConfigFile에 저장하고 복원한다.
class_name BoatDecorPersistence
extends RefCounted

const DEFAULT_PATH := "user://boat_decor_v1.cfg"

var _path: String


func _init(path: String = DEFAULT_PATH) -> void:
	_path = path


func save(decor: Dictionary, appearances: Dictionary) -> Error:
	var config := ConfigFile.new()
	config.set_value("boat_decor", "items", _string_dictionary(decor))
	config.set_value("boat_decor", "appearances", _string_dictionary(appearances))
	return config.save(_path)


func load() -> Dictionary:
	var config := ConfigFile.new()
	if config.load(_path) != OK:
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
