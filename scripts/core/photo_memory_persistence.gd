# 실제 항해 사진 PNG와 포스트카드 메타데이터를 로컬에서 함께 관리한다.
class_name PhotoMemoryPersistence
extends RefCounted

const DEFAULT_CONFIG_PATH := "user://voyage_postcards_v1.cfg"
const DEFAULT_IMAGE_DIRECTORY := "user://voyage_postcards_v1"
const MAX_PNG_BYTES := 32 * 1024 * 1024
const MAX_IMAGE_AXIS := 4096
const MAX_IMAGE_PIXELS := 16777216
static var _crc_table: PackedInt64Array = []

var _config_path: String
var _image_directory: String
var _store := preload("res://scripts/core/recoverable_config_store.gd").new()
var _last_storage_result: Dictionary = {}


func _init(config_path: String = DEFAULT_CONFIG_PATH, image_directory: String = DEFAULT_IMAGE_DIRECTORY) -> void:
	_config_path = config_path
	_image_directory = image_directory


func save_photo(image: Image, label: String, atmosphere_id: String) -> Dictionary:
	_last_storage_result = {"status": "NOT_COMMITTED", "error": ERR_INVALID_DATA, "source_path": _config_path}
	var normalized_label := label.strip_edges()
	var normalized_atmosphere := atmosphere_id.strip_edges()
	if image == null or image.is_empty() or normalized_label.is_empty() or normalized_atmosphere.is_empty():
		return {"ok": false}
	if image.get_width() > MAX_IMAGE_AXIS or image.get_height() > MAX_IMAGE_AXIS or image.get_width() * image.get_height() > MAX_IMAGE_PIXELS:
		return {"ok": false}
	var read_result := _store.read_validated(_config_path, _validate)
	# 복구 읽기는 새 쓰기의 원본 승인이 아니다. helper가 원본을 보존하고 잠근다.
	if read_result.status not in ["OK", "ABSENT"] or FileAccess.file_exists(_config_path + ".pending") or FileAccess.file_exists(_config_path + ".recovery.json"):
		_last_storage_result = _store.write_validated(_config_path, null, _validate)
		return {"ok": false}
	var ledger: ConfigFile = read_result.config if read_result.config != null else ConfigFile.new()
	var entries: Array[Dictionary] = []
	entries.assign(ledger.get_value("voyage_postcards", "entries", []).duplicate(true))
	if not _safe_owned_path(_image_directory, true):
		return {"ok": false}
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(_image_directory)) != OK:
		return {"ok": false}
	var id := _next_id(entries)
	var image_path := _image_directory.path_join("%s.png" % id)
	var receipt_path := _receipt_path(id)
	var png := image.save_png_to_buffer()
	if png.is_empty() or png.size() > MAX_PNG_BYTES:
		return {"ok": false}
	var digest := _bytes_hash(png)
	var receipt := {"id": id, "image_path": image_path, "png_hash": digest, "original_hash": FileAccess.get_sha256(_config_path) if FileAccess.file_exists(_config_path) else "", "original_absent": not FileAccess.file_exists(_config_path)}
	# PNG보다 먼저 사진 소유 의도를 남겨 두 파일 사이의 중단을 식별한다.
	if not _write_photo_receipt(receipt_path, receipt):
		return {"ok": false}
	if _write_png(image_path, png) != OK or FileAccess.get_sha256(image_path) != digest:
		_last_storage_result = {"status": "RECOVERY_REQUIRED", "error": ERR_FILE_CANT_WRITE, "source_path": _config_path}
		return {"ok": false}
	var entry := {
		"id": id,
		"label": normalized_label,
		"atmosphere_id": normalized_atmosphere,
		"image_path": image_path,
	}
	entries.append(entry)
	ledger.set_value("voyage_postcards", "entries", entries)
	_last_storage_result = _store.write_validated(_config_path, ledger, _validate)
	if _last_storage_result.status != "COMMITTED":
		# 결과가 확정되고 이번 바이트임을 확인한 경우에만 이번 PNG를 정리한다.
		if _last_storage_result.status == "NOT_COMMITTED" and resolve_photo_path(entry) == image_path and FileAccess.get_sha256(image_path) == digest:
			if DirAccess.remove_absolute(image_path) == OK:
				DirAccess.remove_absolute(receipt_path)
		return {"ok": false}
	DirAccess.remove_absolute(receipt_path)
	entry["ok"] = true
	return entry


func load_entries() -> Array[Dictionary]:
	_last_storage_result = _store.read_validated(_config_path, _validate)
	var config := _store.config_for_legacy_read(_config_path, _last_storage_result)
	if config == null:
		return []
	return _normalize_entries(config.get_value("voyage_postcards", "entries", []))


func get_last_storage_result() -> Dictionary:
	return _last_storage_result.duplicate(true)


func recover_primary() -> Dictionary:
	_last_storage_result = _store.recover_primary(_config_path, _validate)
	return get_last_storage_result()


func _validate(config: ConfigFile) -> bool:
	if not config.has_section_key("voyage_postcards", "entries"):
		return false
	var entries: Variant = config.get_value("voyage_postcards", "entries")
	if not entries is Array:
		return false
	for entry in entries:
		if not entry is Dictionary:
			return false
		for field in ["id", "label", "atmosphere_id", "image_path"]:
			var value: Variant = entry.get(field)
			if not value is String or value.strip_edges().is_empty():
				return false
	return true


func resolve_photo_path(entry: Dictionary) -> String:
	var id: Variant = entry.get("id")
	var path: Variant = entry.get("image_path")
	if not id is String or not path is String or not _safe_component(id):
		return ""
	var expected := _image_directory.path_join(id + ".png")
	if path != expected or not _safe_owned_path(expected) or not FileAccess.file_exists(expected):
		return ""
	return expected


func load_photo_image(entry: Dictionary) -> Image:
	var path := resolve_photo_path(entry)
	if path.is_empty():
		return null
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null or file.get_length() < 45 or file.get_length() > MAX_PNG_BYTES:
		return null
	var header := file.get_buffer(33)
	if header.size() != 33 or header.slice(0, 8) != PackedByteArray([137, 80, 78, 71, 13, 10, 26, 10]) or _be32(header, 8) != 13 or header.slice(12, 16).get_string_from_ascii() != "IHDR":
		return null
	var width := _be32(header, 16)
	var height := _be32(header, 20)
	if width < 1 or height < 1 or width > MAX_IMAGE_AXIS or height > MAX_IMAGE_AXIS or width * height > MAX_IMAGE_PIXELS:
		return null
	file.seek(0)
	var bytes := file.get_buffer(file.get_length())
	file.close()
	if not _complete_png(bytes):
		return null
	var image := Image.new()
	if image.load_png_from_buffer(bytes) != OK or image.is_empty():
		return null
	return image


func _complete_png(bytes: PackedByteArray) -> bool:
	var offset := 8
	var has_data := false
	if _crc_table.is_empty():
		for index in 256:
			var value: int = index
			for bit in 8:
				value = (value >> 1) ^ (0xedb88320 if value & 1 else 0)
			_crc_table.append(value)
	while offset + 12 <= bytes.size():
		var length := _be32(bytes, offset)
		if length > bytes.size() - offset - 12:
			return false
		var crc := 0xffffffff
		for index in range(offset + 4, offset + 8 + length):
			crc = _crc_table[(crc ^ bytes[index]) & 255] ^ (crc >> 8)
		if (crc ^ 0xffffffff) != _be32(bytes, offset + 8 + length):
			return false
		var kind := bytes.slice(offset + 4, offset + 8).get_string_from_ascii()
		if kind == "IHDR" and (offset != 8 or length != 13):
			return false
		if kind == "IDAT":
			has_data = true
		if kind == "IEND":
			return length == 0 and has_data and offset + 12 == bytes.size()
		offset += length + 12
	return false


func _be32(bytes: PackedByteArray, offset: int) -> int:
	return (int(bytes[offset]) << 24) | (int(bytes[offset + 1]) << 16) | (int(bytes[offset + 2]) << 8) | int(bytes[offset + 3])


func _safe_component(value: String) -> bool:
	if value.is_empty() or value != value.strip_edges():
		return false
	for character in value:
		if not character.to_lower() in "abcdefghijklmnopqrstuvwxyz0123456789_-":
			return false
	return true


func _safe_owned_path(path: String, allow_missing: bool = false) -> bool:
	# user:// 자체는 앱 신뢰 경계다. 그 아래 모든 성분의 link/reparse를 검사한다.
	if OS.get_name() not in ["Windows", "Linux", "macOS", "Android", "iOS"] or not path.begins_with("user://") or "\\" in path:
		return false
	var parts := path.trim_prefix("user://").split("/", false)
	if parts.is_empty() or "//" in path.trim_prefix("user://"):
		return false
	var current := "user://"
	for part in parts:
		if part in [".", ".."] or ":" in part or part.is_empty():
			return false
		var directory := DirAccess.open(current)
		if directory == null:
			return false
		if directory.is_link(part):
			return false
		if not directory.file_exists(part) and not directory.dir_exists(part):
			return allow_missing and _safe_component(part) and part == parts[-1]
		current = current.path_join(part)
	return true


func _receipt_path(id: String) -> String:
	return _image_directory.path_join(id + ".photo_pending.json")


func _write_photo_receipt(path: String, receipt: Dictionary) -> bool:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(receipt))
	file.flush()
	var error := file.get_error()
	file.close()
	return error == OK and JSON.parse_string(FileAccess.get_file_as_string(path)) == receipt


func _write_png(path: String, bytes: PackedByteArray) -> Error:
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		return FileAccess.get_open_error()
	file.store_buffer(bytes)
	file.flush()
	var error := file.get_error()
	file.close()
	return error


func _bytes_hash(bytes: PackedByteArray) -> String:
	var hashing := HashingContext.new()
	hashing.start(HashingContext.HASH_SHA256)
	hashing.update(bytes)
	return hashing.finish().hex_encode()


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
		# 이미지 누락은 기록 삭제가 아니다. 앨범이 unavailable 상태로 표시한다.
		var entry: Dictionary = raw_entry.duplicate(true)
		entry.merge({"id": id, "label": label, "atmosphere_id": atmosphere_id, "image_path": image_path}, true)
		entries.append(entry)
	return entries


func _next_id(entries: Array[Dictionary]) -> String:
	var base_id := "postcard_%d" % int(Time.get_unix_time_from_system())
	var candidate := base_id
	var suffix := 2
	var reserved_ids: Array[String] = []
	for entry in entries:
		reserved_ids.append(str(entry["id"]))
	var directory := DirAccess.open(_image_directory)
	while candidate in reserved_ids or FileAccess.file_exists(_image_directory.path_join("%s.png" % candidate)) or DirAccess.dir_exists_absolute(_image_directory.path_join("%s.png" % candidate)) or FileAccess.file_exists(_receipt_path(candidate)) or DirAccess.dir_exists_absolute(_receipt_path(candidate)) or directory.is_link(candidate + ".png") or directory.is_link(candidate + ".photo_pending.json"):
		candidate = "%s_%d" % [base_id, suffix]
		suffix += 1
	return candidate
