# 저장 중단과 손상에서 정상본 및 쓰기 잠금의 보존을 검사한다.
extends SceneTree

const SCRIPT := "res://scripts/core/recoverable_config_store.gd"
var DIR := "user://test_recoverable_config_store_%d_%d" % [OS.get_process_id(), Time.get_ticks_usec()]
var PATH: String
var owned_files: Array[String] = []
var failures := 0

class FaultStore extends "res://scripts/core/recoverable_config_store.gd":
	var fail_stage := false
	var fail_readback := false
	var fail_rollback := false
	var replaced := false
	var fault_kind := ""
	func _save(config: ConfigFile, path: String) -> Error:
		if fault_kind == "partial_stage":
			super._save(config, path)
			return ERR_FILE_CANT_WRITE
		return ERR_FILE_CANT_WRITE if fail_stage else super._save(config, path)
	func _replace(source: String, destination: String) -> Error:
		var error := super._replace(source, destination)
		replaced = true
		return error
	func _load(config: ConfigFile, path: String) -> Error:
		if fault_kind == "pending_read" and path.ends_with(".pending"):
			return ERR_FILE_CANT_READ
		if replaced and fail_readback and path.ends_with(".cfg"):
			fail_readback = false
			return ERR_FILE_CANT_READ
		return super._load(config, path)
	func _copy(source: String, destination: String) -> Error:
		if fault_kind == "backup_copy" and destination.ends_with(".last_good"):
			return ERR_FILE_CANT_WRITE
		if replaced and fail_rollback and source.ends_with(".last_good"):
			return ERR_FILE_CANT_WRITE
		return super._copy(source, destination)
	func _hash(path: String) -> String:
		return "" if fault_kind == "backup_hash" and path.ends_with(".last_good") else super._hash(path)
	func _write_receipt(path: String, receipt: Dictionary) -> bool:
		return false if fault_kind == "receipt_write" else super._write_receipt(path, receipt)
	func _remove(path: String) -> Error:
		if fault_kind == "unlock" and path.ends_with(".recovery.json"):
			return ERR_FILE_CANT_WRITE
		if fault_kind == "absence_remove" and path.ends_with(".cfg"):
			return ERR_FILE_CANT_WRITE
		return super._remove(path)

func _init() -> void:
	call_deferred("run")

func valid(config: ConfigFile) -> bool:
	return config.has_section_key("test", "value") and config.get_value("test", "value") is int

func candidate(value: int) -> ConfigFile:
	var config := ConfigFile.new()
	config.set_value("test", "value", value)
	return config

func run() -> void:
	expect(ResourceLoader.exists(SCRIPT), "recoverable store must exist")
	if not ResourceLoader.exists(SCRIPT):
		quit(1)
		return
	if DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(DIR)):
		printerr("FAIL: fixture collision; nothing removed")
		quit(1)
		return
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(DIR))
	PATH = DIR + "/owner.cfg"
	var sibling := DIR + "/other_run"
	DirAccess.make_dir_absolute(sibling)
	var sentinel := FileAccess.open(sibling + "/sentinel", FileAccess.WRITE)
	sentinel.store_string("unrelated run")
	sentinel.close()
	var sentinel_hash := FileAccess.get_sha256(sibling + "/sentinel")
	var store: Variant = load(SCRIPT).new()
	expect(store.read_validated(PATH, valid).status == "ABSENT", "missing primary is absent")
	expect(store.write_validated(PATH, candidate(1), valid).status == "COMMITTED", "first commit")
	var original := FileAccess.get_file_as_bytes(PATH)
	expect(store.write_validated(PATH, ConfigFile.new(), valid).status == "NOT_COMMITTED", "invalid candidate rejected")
	expect(FileAccess.get_file_as_bytes(PATH) == original, "rejection preserves bytes")
	candidate(8).save(PATH + ".pending")
	var pending := FileAccess.get_file_as_bytes(PATH + ".pending")
	expect(store.write_validated(PATH, candidate(2), valid).status == "RECOVERY_REQUIRED", "interrupted pending locks writer")
	expect(FileAccess.get_file_as_bytes(PATH + ".pending") == pending, "pending evidence preserved")
	store = load(SCRIPT).new()
	expect(store.write_validated(PATH, candidate(2), valid).status == "RECOVERY_REQUIRED", "lock survives new instance")
	expect(store.recover_primary(PATH, valid).status == "COMMITTED", "explicit recovery verifies primary")
	expect(store.write_validated(PATH, candidate(2), valid).status == "COMMITTED", "verified recovery unlocks writer")
	var file := FileAccess.open(PATH, FileAccess.WRITE)
	file.store_string("broken=[\n")
	file.close()
	var previous := Engine.print_error_messages
	Engine.print_error_messages = false
	expect(store.read_validated(PATH, valid).status == "RECOVERED", "backup may supply read without restoring primary")
	expect(store.write_validated(PATH, candidate(3), valid).status == "RECOVERY_REQUIRED", "backup read cannot unlock")
	expect(store.recover_primary(PATH, valid).status == "COMMITTED", "explicit backup restore")
	Engine.print_error_messages = previous
	expect(store.read_validated(PATH, valid).config.get_value("test", "value") == 1, "last good content restored")
	for mode in ["stage", "rollback", "locked", "absent"]:
		var path: String = DIR + "/" + mode + ".cfg"
		var fault := FaultStore.new()
		if mode != "absent":
			candidate(10).save(path)
		var before := FileAccess.get_file_as_bytes(path) if mode != "absent" else PackedByteArray()
		fault.fail_stage = mode == "stage"
		fault.fail_readback = mode != "stage"
		fault.fail_rollback = mode == "locked"
		var result := fault.write_validated(path, candidate(20), valid)
		expect(result.status == ("RECOVERY_REQUIRED" if mode == "locked" else "NOT_COMMITTED"), mode + " failure status")
		if mode == "locked":
			var restarted: Variant = load(SCRIPT).new()
			var recovered_read: Dictionary = restarted.read_validated(path, valid)
			expect(recovered_read.status == "RECOVERED" and recovered_read.config.get_value("test", "value") == 10, "locked reader keeps last committed value")
			expect(restarted.write_validated(path, candidate(30), valid).status == "RECOVERY_REQUIRED", "failed rollback persists lock")
			expect(restarted.recover_primary(path, valid).status == "COMMITTED", "explicit recovery resolves failed rollback")
			expect(restarted.read_validated(path, valid).config.get_value("test", "value") == 10, "recovery must restore original committed value, not uncommitted replacement")
		elif mode == "absent":
			expect(not FileAccess.file_exists(path), "failed first commit restores original absence")
		else:
			expect(FileAccess.get_file_as_bytes(path) == before, mode + " original bytes preserved")
	var unknown_path := DIR + "/unknown.cfg"
	var unknown := candidate(3)
	unknown.set_value("future", "kept", "retain")
	unknown.save(unknown_path)
	expect(store.write_validated(unknown_path, candidate(4), valid).status == "COMMITTED", "unknown keys may survive candidate omission")
	expect(store.read_validated(unknown_path, valid).config.get_value("future", "kept") == "retain", "unknown key retained by store")
	for value in range(5, 15):
		expect(store.write_validated(unknown_path, candidate(value), valid).status == "COMMITTED", "healthy repeat save")
	var healthy_files := 0
	for name in DirAccess.get_files_at(DIR):
		if name.begins_with("unknown.cfg"):
			healthy_files += 1
	expect(healthy_files == 2, "healthy writes retain only primary and rolling backup")
	var corrupt_path := DIR + "/corrupt.cfg"
	var broken := FileAccess.open(corrupt_path, FileAccess.WRITE)
	broken.store_string("[test]\nvalue=\"wrong\"\n")
	broken.close()
	DirAccess.copy_absolute(ProjectSettings.globalize_path(corrupt_path), ProjectSettings.globalize_path(corrupt_path + ".last_good"))
	var files_before_read := DirAccess.get_files_at(DIR)
	expect(store.read_validated(corrupt_path, valid).status == "CORRUPT", "corrupt primary and backup are not defaults")
	expect(DirAccess.get_files_at(DIR) == files_before_read, "read must not mutate disk before test fixture isolates autoload paths")
	expect(store.recover_primary(corrupt_path, valid).status == "RECOVERY_REQUIRED", "corrupt backup cannot recover")
	var missing_path := DIR + "/missing_with_backup.cfg"
	candidate(5).save(missing_path + ".last_good")
	expect(store.write_validated(missing_path, candidate(8), valid).status == "RECOVERY_REQUIRED", "missing primary with backup is ambiguous and cannot be overwritten")
	var bad_receipt_path := DIR + "/bad_receipt.cfg"
	candidate(7).save(bad_receipt_path)
	var bad_receipt := FileAccess.open(bad_receipt_path + ".recovery.json", FileAccess.WRITE)
	bad_receipt.store_string('{"status":"RECOVERY_REQUIRED","original_absent":"yes"}')
	bad_receipt.close()
	expect(store.recover_primary(bad_receipt_path, valid).status == "RECOVERY_REQUIRED", "unknown receipt schema fails closed")
	expect(FileAccess.file_exists(bad_receipt_path), "malformed receipt must not authorize removal")
	for kind in ["pending_read", "backup_copy", "backup_hash", "receipt_write", "unlock", "absence_remove"]:
		var boundary_path: String = DIR + "/boundary_" + kind + ".cfg"
		var boundary := FaultStore.new()
		boundary.fault_kind = kind
		if kind != "absence_remove":
			candidate(11).save(boundary_path)
		else:
			boundary.fail_readback = true
		var snapshot := FileAccess.get_file_as_bytes(boundary_path) if kind != "absence_remove" else PackedByteArray()
		var boundary_result := boundary.write_validated(boundary_path, candidate(22), valid)
		var uncertain: bool = kind in ["unlock", "absence_remove"]
		expect(boundary_result.status == ("RECOVERY_REQUIRED" if uncertain else "NOT_COMMITTED"), kind + " boundary status")
		if not uncertain:
			expect(FileAccess.get_file_as_bytes(boundary_path) == snapshot, kind + " cannot alter primary")
		else:
			var fresh: Variant = load(SCRIPT).new()
			expect(fresh.write_validated(boundary_path, candidate(33), valid).status == "RECOVERY_REQUIRED", kind + " lock survives instance")
			expect(fresh.recover_primary(boundary_path, valid).status == "COMMITTED", kind + " explicit recovery succeeds")
			if kind == "absence_remove":
				expect(not FileAccess.file_exists(boundary_path), "explicit recovery restores original absence after failed removal")
	for kind in ["pending_read", "partial_stage"]:
		for existed in [false, true]:
			var interrupted_path: String = DIR + "/early_%s_%s.cfg" % [kind, str(existed)]
			if existed:
				candidate(41).save(interrupted_path)
			var early := FaultStore.new()
			early.fault_kind = kind
			expect(early.write_validated(interrupted_path, candidate(42), valid).status == "NOT_COMMITTED", "early staging fails before replacement")
			var fresh: Variant = load(SCRIPT).new()
			expect(fresh.write_validated(interrupted_path, candidate(43), valid).status == "RECOVERY_REQUIRED", "early pending blocks overwrite")
			expect(fresh.recover_primary(interrupted_path, valid).status == "COMMITTED", "recorded first-save absence permits explicit early-stage recovery")
			if existed:
				expect(fresh.read_validated(interrupted_path, valid).config.get_value("test", "value") == 41, "early recovery preserves existing primary")
			else:
				expect(not FileAccess.file_exists(interrupted_path), "early first-save recovery restores absence")
			expect(fresh.write_validated(interrupted_path, candidate(44), valid).status == "COMMITTED", "recovered early stage permits next save")
	for file_name in DirAccess.get_files_at(DIR):
		owned_files.append(DIR.path_join(file_name))
	cleanup()
	expect(FileAccess.get_sha256(sibling + "/sentinel") == sentinel_hash, "sibling fixture preserved")
	DirAccess.remove_absolute(sibling + "/sentinel")
	DirAccess.remove_absolute(sibling)
	DirAccess.remove_absolute(DIR)
	print("PASS: recoverable config store" if failures == 0 else "FAILED: recoverable config store %d" % failures)
	quit(0 if failures == 0 else 1)

func cleanup() -> void:
	if not DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(DIR)):
		return
	for file in owned_files:
		expect(DirAccess.remove_absolute(file) == OK, "owned file cleanup")

func expect(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		printerr("FAIL: " + message)
