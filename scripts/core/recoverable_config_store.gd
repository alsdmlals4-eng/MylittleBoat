# 소유자가 검증한 설정을 단계 저장하고 정상본과 복구 증거를 보존한다.
class_name RecoverableConfigStore
extends RefCounted

static var _busy: Dictionary = {}
static var _locked: Dictionary = {}

func read_validated(path: String, validate: Callable) -> Dictionary:
	var primary := _read(path, validate)
	if _exists(path + ".recovery.json"):
		var receipt: Variant = JSON.parse_string(FileAccess.get_file_as_string(path + ".recovery.json"))
		if not _valid_receipt(receipt):
			return {"status": "IO_ERROR", "config": null, "source_path": path, "error": ERR_INVALID_DATA}
		if receipt.get("original_absent", false):
			return {"status": "ABSENT", "config": null, "source_path": path, "error": ERR_FILE_CORRUPT}
		var original_hash: String = receipt.get("original_hash", "")
		if not original_hash.is_empty() and _hash(path) != original_hash:
			var original := _read(path + ".last_good", validate)
			if original.status == "OK" and _hash(path + ".last_good") == original_hash:
				original.status = "RECOVERED"
				original.error = ERR_FILE_CORRUPT
				return original
			return {"status": "CORRUPT", "config": null, "source_path": path, "error": ERR_FILE_CORRUPT}
	if primary.status == "OK":
		return primary
	var backup := _read(path + ".last_good", validate)
	if backup.status == "OK":
		backup.status = "RECOVERED"
		backup.error = primary.error
		return backup
	return primary

func write_validated(path: String, candidate: ConfigFile, validate: Callable) -> Dictionary:
	if _busy.has(path):
		return _result("NOT_COMMITTED", ERR_BUSY, path)
	_busy[path] = true
	var result := _write(path, candidate, validate)
	_busy.erase(path)
	return result

func _write(path: String, candidate: ConfigFile, validate: Callable) -> Dictionary:
	if _is_locked(path) or _exists(path + ".pending"):
		return _lock(path)
	var old := _read(path, validate)
	if old.status == "ABSENT" and _exists(path + ".last_good"):
		return _lock(path)
	if old.status not in ["OK", "ABSENT"]:
		_archive(path)
		return _lock(path)
	if candidate == null or not validate.is_valid() or not validate.call(candidate):
		return _result("NOT_COMMITTED", ERR_INVALID_DATA, path)
	# Unknown owner keys belong to their original owner even when omitted by a candidate.
	var merged := ConfigFile.new()
	if old.config != null:
		merged.parse(old.config.encode_to_text())
	for section in candidate.get_sections():
		for key in candidate.get_section_keys(section):
			merged.set_value(section, key, candidate.get_value(section, key))
	if not validate.call(merged):
		return _result("NOT_COMMITTED", ERR_INVALID_DATA, path)
	var old_hash := _hash(path) if old.status == "OK" else ""
	if old.status == "OK" and old_hash.is_empty():
		return _result("NOT_COMMITTED", ERR_FILE_CANT_READ, path)
	# Record original absence before staging can leave an interrupted first-save file.
	if not _write_receipt(path, {"status": "RECOVERY_REQUIRED", "original_absent": old.status == "ABSENT", "original_hash": old_hash}):
		return _result("NOT_COMMITTED", ERR_FILE_CANT_WRITE, path)
	var pending := path + ".pending"
	var error := _save(merged, pending)
	if error != OK:
		return _result("NOT_COMMITTED", error, path)
	var staged := _read(pending, validate)
	if staged.status != "OK" or staged.config.encode_to_text() != merged.encode_to_text():
		return _result("NOT_COMMITTED", ERR_FILE_CORRUPT, path)
	if old.status == "OK":
		if _exists(path + ".last_good") and _read(path + ".last_good", validate).status != "OK" and not _archive(path + ".last_good"):
			return _result("NOT_COMMITTED", ERR_FILE_CANT_WRITE, path)
		error = _copy(path, path + ".last_good")
		if error != OK or _hash(path + ".last_good") != old_hash:
			return _result("NOT_COMMITTED", ERR_FILE_CANT_WRITE, path)
	var candidate_hash := _hash(pending)
	error = _replace(pending, path)
	var committed := _read(path, validate)
	if error == OK and not candidate_hash.is_empty() and committed.status == "OK" and _hash(path) == candidate_hash:
		if _unlock(path, false):
			return _result("COMMITTED", OK, path)
		return _lock(path)
	if not _archive(path):
		return _lock(path)
	if old.status == "ABSENT":
		if _remove(path) == OK and not _exists(path) and _unlock(path):
			return _result("NOT_COMMITTED", ERR_FILE_CANT_WRITE, path)
	elif _copy(path + ".last_good", path) == OK:
		var restored := _read(path, validate)
		if restored.status == "OK" and _hash(path) == old_hash and _unlock(path):
			return _result("NOT_COMMITTED", ERR_FILE_CANT_WRITE, path)
	return _lock(path)

func recover_primary(path: String, validate: Callable) -> Dictionary:
	if _busy.has(path):
		return _result("RECOVERY_REQUIRED", ERR_BUSY, path)
	_busy[path] = true
	var result := _recover(path, validate)
	_busy.erase(path)
	return result

func _recover(path: String, validate: Callable) -> Dictionary:
	var primary := _read(path, validate)
	var source := path if primary.status == "OK" else path + ".last_good"
	if _exists(path + ".recovery.json"):
		var receipt: Variant = JSON.parse_string(FileAccess.get_file_as_string(path + ".recovery.json"))
		if not _valid_receipt(receipt):
			return _lock(path)
		if receipt.get("original_absent", false):
			if not _archive(path) or not _archive(path + ".pending"):
				return _lock(path)
			if _remove(path) == OK and not _exists(path) and _remove(path + ".pending") == OK and _unlock(path):
				return _result("COMMITTED", OK, path)
			return _lock(path)
		var original_hash: String = receipt.get("original_hash", "")
		if not original_hash.is_empty() and _hash(path) != original_hash:
			source = path + ".last_good"
			if _hash(source) != original_hash:
				return _lock(path)
	var good := _read(source, validate)
	if good.status != "OK":
		return _lock(path)
	var good_hash := _hash(source)
	if good_hash.is_empty() or not _archive(path) or not _archive(path + ".pending"):
		return _lock(path)
	if source != path and _copy(source, path) != OK:
		return _lock(path)
	var restored := _read(path, validate)
	if restored.status != "OK" or _hash(path) != good_hash:
		return _lock(path)
	if _remove(path + ".pending") != OK or not _unlock(path):
		return _lock(path)
	return _result("COMMITTED", OK, path)

func _read(path: String, validate: Callable) -> Dictionary:
	if not _exists(path):
		return {"status": "ABSENT", "config": null, "source_path": path, "error": ERR_FILE_NOT_FOUND}
	var config := ConfigFile.new()
	var error := _load(config, path)
	if error != OK:
		return {"status": "CORRUPT" if error in [ERR_PARSE_ERROR, ERR_FILE_CORRUPT] else "IO_ERROR", "config": null, "source_path": path, "error": error}
	if not validate.is_valid() or not validate.call(config):
		return {"status": "CORRUPT", "config": null, "source_path": path, "error": ERR_INVALID_DATA}
	return {"status": "OK", "config": config, "source_path": path, "error": OK}

func _archive(path: String) -> bool:
	if not _exists(path):
		return true
	var digest := _hash(path)
	if digest.is_empty():
		return false
	var destination := path + ".recovery." + digest
	if _exists(destination):
		return _hash(destination) == digest
	return _copy(path, destination) == OK and _hash(destination) == digest

func _is_locked(path: String) -> bool:
	if _locked.has(path):
		return true
	if not _exists(path + ".recovery.json"):
		return false
	return true

func _valid_receipt(receipt: Variant) -> bool:
	if not receipt is Dictionary or receipt.get("status", "") != "RECOVERY_REQUIRED":
		return false
	if not receipt.has("original_absent") and not receipt.has("original_hash"):
		return true
	if not receipt.get("original_absent") is bool or not receipt.get("original_hash") is String:
		return false
	var digest: String = receipt.original_hash
	if receipt.original_absent:
		return digest.is_empty()
	return digest.length() == 64 and digest.is_valid_hex_number()

func _lock(path: String) -> Dictionary:
	_locked[path] = true
	# Do not overwrite an earlier interrupted-transaction receipt.
	if not _exists(path + ".recovery.json"):
		_write_receipt(path, {"status": "RECOVERY_REQUIRED"})
	return _result("RECOVERY_REQUIRED", ERR_FILE_CORRUPT, path)

func _unlock(path: String, preserve_receipt: bool = true) -> bool:
	if preserve_receipt and not _archive(path + ".recovery.json"):
		return false
	if _remove(path + ".recovery.json") != OK:
		return false
	_locked.erase(path)
	return true

func _write_receipt(path: String, receipt: Dictionary) -> bool:
	var file := FileAccess.open(path + ".recovery.json", FileAccess.WRITE)
	if file == null:
		return false
	file.store_string(JSON.stringify(receipt))
	file.flush()
	var error := file.get_error()
	file.close()
	return error == OK and JSON.parse_string(FileAccess.get_file_as_string(path + ".recovery.json")) == receipt

func _result(status: String, error: Error, path: String) -> Dictionary:
	return {"status": status, "error": error, "source_path": path}

func _exists(path: String) -> bool:
	return FileAccess.file_exists(path)

func _hash(path: String) -> String:
	return FileAccess.get_sha256(path) if _exists(path) else ""

func _load(config: ConfigFile, path: String) -> Error:
	return config.load(path)

func _save(config: ConfigFile, path: String) -> Error:
	return config.save(path)

func _copy(source: String, destination: String) -> Error:
	return DirAccess.copy_absolute(ProjectSettings.globalize_path(source), ProjectSettings.globalize_path(destination))

func _replace(source: String, destination: String) -> Error:
	return DirAccess.rename_absolute(ProjectSettings.globalize_path(source), ProjectSettings.globalize_path(destination))

func _remove(path: String) -> Error:
	return DirAccess.remove_absolute(ProjectSettings.globalize_path(path)) if _exists(path) else OK
