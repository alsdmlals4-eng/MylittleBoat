# 섬 저장 형식을 검증하고 기존 복구 저장소의 거래·원본 보존에 연결한다.
extends RefCounted

const Backend = preload("res://scripts/core/recoverable_config_store.gd")
var _path: String
var _farm: RefCounted
var _backend: RefCounted

func _init(path: String, farm: RefCounted, backend: RefCounted = null) -> void:
	_path = path
	_farm = farm
	_backend = backend if backend != null else Backend.new()

func _result(status: String, error: int = OK, snapshot: Dictionary = {}) -> Dictionary:
	return {"status": status, "error": error, "snapshot": snapshot.duplicate(true)}

func _valid(config: ConfigFile) -> bool:
	return config.has_section_key("island", "snapshot") and _farm.validate_snapshot(config.get_value("island", "snapshot"))

func _preflight() -> Dictionary:
	# 미래 primary/backup/pending 어느 것도 구버전 fallback으로 숨기지 않는다.
	var io_error := OK
	for suffix in ["", ".last_good", ".pending"]:
		var path: String = _path + suffix
		if DirAccess.dir_exists_absolute(path):
			io_error = ERR_FILE_CANT_READ
			continue
		if not FileAccess.file_exists(path): continue
		var config := ConfigFile.new()
		var error := config.load(path)
		if error != OK:
			if not error in [ERR_PARSE_ERROR, ERR_FILE_CORRUPT]: io_error = error
			continue
		var value: Variant = config.get_value("island", "snapshot", null)
		if value is Dictionary and typeof(value.get("schema_version")) == TYPE_INT and value.schema_version > 1:
			return _result("UNSUPPORTED_VERSION", ERR_INVALID_DATA)
	if io_error != OK: return _result("IO_ERROR", io_error)
	return _result("OK")

func load_state() -> Dictionary:
	var preflight := _preflight()
	if preflight.status != "OK": return preflight
	var read: Dictionary = _backend.read_validated(_path, _valid)
	var snapshot: Dictionary = {}
	if read.config != null and _valid(read.config):
		snapshot = read.config.get_value("island", "snapshot").duplicate(true)
	if read.status == "IO_ERROR": return _result("IO_ERROR", read.error)
	if FileAccess.file_exists(_path + ".pending") or FileAccess.file_exists(_path + ".recovery.json"):
		return _result("RECOVERY_REQUIRED", read.error, snapshot)
	if read.status == "RECOVERED": return _result("RECOVERY_REQUIRED", read.error, snapshot)
	if read.status == "ABSENT" and FileAccess.file_exists(_path + ".last_good"):
		return _result("CORRUPT", ERR_INVALID_DATA)
	return _result(read.status, read.error, snapshot)

func commit(snapshot: Dictionary) -> Dictionary:
	var current := load_state()
	if current.status == "UNSUPPORTED_VERSION": return current
	if not current.status in ["OK", "ABSENT"]:
		return _result("RECOVERY_REQUIRED", current.error)
	if not _farm.validate_snapshot(snapshot): return _result("NOT_COMMITTED", ERR_INVALID_DATA)
	var config := ConfigFile.new()
	config.set_value("island", "snapshot", snapshot.duplicate(true))
	return _backend.write_validated(_path, config, _valid)

func recover() -> Dictionary:
	var preflight := _preflight()
	if preflight.status != "OK": return preflight
	return _backend.recover_primary(_path, _valid)
