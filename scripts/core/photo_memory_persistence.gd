# 실제 항해 사진 PNG와 포스트카드 메타데이터를 로컬에서 함께 관리한다.
class_name PhotoMemoryPersistence
extends RefCounted

const DEFAULT_CONFIG_PATH := "user://voyage_postcards_v1.cfg"
const DEFAULT_IMAGE_DIRECTORY := "user://voyage_postcards_v1"

var _config_path: String
var _image_directory: String


func _init(config_path: String = DEFAULT_CONFIG_PATH, image_directory: String = DEFAULT_IMAGE_DIRECTORY) -> void:
	_config_path = config_path
	_image_directory = image_directory


func save_photo(image: Image, label: String, atmosphere_id: String) -> Dictionary:
	var normalized_label := label.strip_edges()
	var normalized_atmosphere := atmosphere_id.strip_edges()
	if image == null or normalized_label.is_empty() or normalized_atmosphere.is_empty():
		return {"ok": false}
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_image_directory)) != OK:
		return {"ok": false}
	var id := _next_id()
	var image_path := _image_directory.path_join("%s.png" % id)
	if image.save_png(image_path) != OK:
		return {"ok": false}
	var entries := load_entries()
	var entry := {
		"id": id,
		"label": normalized_label,
		"atmosphere_id": normalized_atmosphere,
		"image_path": image_path,
	}
	entries.append(entry)
	if _save_entries(entries) != OK:
		DirAccess.remove_absolute(ProjectSettings.globalize_path(image_path))
		return {"ok": false}
	entry["ok"] = true
	return entry


func load_entries() -> Array[Dictionary]:
	var config := ConfigFile.new()
	if config.load(_config_path) != OK:
		return []
	return _normalize_entries(config.get_value("voyage_postcards", "entries", []))


func _save_entries(entries: Array[Dictionary]) -> Error:
	var config := ConfigFile.new()
	config.set_value("voyage_postcards", "entries", _normalize_entries(entries))
	return config.save(_config_path)


func _normalize_entries(value: Variant) -> Array[Dictionary]:
	if not value is Array:
		return []
	var entries: Array[Dictionary] = []
	for raw_entry in value:
		if not raw_entry is Dictionary:
			continue
		var id := str(raw_entry.get("id", "")).strip_edges()
		var label := str(raw_entry.get("label", "")).strip_edges()
		var atmosphere_id := str(raw_entry.get("atmosphere_id", "")).strip_edges()
		var image_path := str(raw_entry.get("image_path", "")).strip_edges()
		if id.is_empty() or label.is_empty() or atmosphere_id.is_empty() or image_path.is_empty():
			continue
		if not FileAccess.file_exists(image_path):
			continue
		entries.append({
			"id": id,
			"label": label,
			"atmosphere_id": atmosphere_id,
			"image_path": image_path,
		})
	return entries


func _next_id() -> String:
	var base_id := "postcard_%d" % int(Time.get_unix_time_from_system())
	var candidate := base_id
	var suffix := 2
	while FileAccess.file_exists(_image_directory.path_join("%s.png" % candidate)):
		candidate = "%s_%d" % [base_id, suffix]
		suffix += 1
	return candidate
