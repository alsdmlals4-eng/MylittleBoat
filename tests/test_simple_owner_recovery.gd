# 다섯 저장 소유자의 원본 보존과 명시 복구 연결을 실제 격리 파일로 검증한다.
extends SceneTree

const CLEANUP = preload("res://tests/helpers/config_store_test_cleanup.gd")
const CASES := [
	["boat_decor_persistence", "save", "load", "boat_decor", "items", [{"bow_left": "lantern"}, {"pet_corner": "moon"}], [{"bow_left": "mug"}, {}], {"decor": {"bow_left": "lantern"}, "appearances": {"pet_corner": "moon"}}],
	["cosmetic_identity_profile", "save", "load", "identity", "player_style_id", ["a_soft_hooded", "cat"], ["b_short_cape", "rabbit"], {"player_style_id": "a_soft_hooded", "pet_type_id": "cat"}],
	["together_time_persistence", "save_seconds", "load_seconds", "together_time", "seconds", [12.5], [21.0], 12.5],
	["ambient_memory_persistence", "save_entries", "load_entries", "ambient_memory", "entries", [["first", "second"]], [["third"]], ["first", "second"]],
	["memory_ledger_persistence", "save_entries", "load_entries", "memory_ledger", "fish", [["fish one", "fish two"], ["voyage one"]], [["fish three"], ["voyage two"]], {"fish": ["fish one", "fish two"], "voyage_records": ["voyage one"]}],
]
var failures := 0

class RejectPending extends "res://scripts/core/recoverable_config_store.gd":
	func _save(_config: ConfigFile, _path: String) -> Error:
		return ERR_FILE_CANT_WRITE

func _init() -> void:
	call_deferred("run")

func run() -> void:
	for row in CASES:
		check_owner(row)
	print("SIMPLE_OWNER_RECOVERY_FAILURES=%d" % failures)
	quit(1 if failures else 0)

func save_owner(owner: Variant, row: Array, index: int) -> int:
	var args: Array = row[index].duplicate(true)
	if row[0] in ["ambient_memory_persistence", "memory_ledger_persistence"]:
		for i in args.size():
			var entries: Array[String] = []
			entries.assign(args[i])
			args[i] = entries
	return owner.callv(row[1], args)

func check_owner(row: Array) -> void:
	var path: String = "user://test_r07b1_" + row[0] + ".cfg"
	CLEANUP.remove_store(path)
	var owner: Variant = load("res://scripts/core/" + row[0] + ".gd").new(path)
	# Removing owner integration must fail before the recovery API is called.
	expect(save_owner(owner, row, 5) == OK, row[0] + " first save")
	var first := FileAccess.get_file_as_bytes(path)
	expect(owner.call(row[2]) == row[7], row[0] + " first roundtrip and ordering")
	expect(save_owner(owner, row, 6) == OK, row[0] + " update")
	expect(FileAccess.file_exists(path + ".last_good"), row[0] + " update retains last good")
	if FileAccess.file_exists(path + ".last_good"):
		expect(FileAccess.get_file_as_bytes(path + ".last_good") == first, row[0] + " exact last-good bytes")
	var has_api: bool = owner.has_method("get_last_storage_result") and owner.has_method("recover_primary")
	expect(has_api, row[0] + " exposes explicit storage status and recovery")
	if not has_api:
		CLEANUP.remove_store(path)
		return
	expect(owner.get_last_storage_result().status == "COMMITTED", row[0] + " save success means committed")
	var config := ConfigFile.new()
	config.load(path)
	config.set_value("future", "opaque", {"payload": [3, "keep"]})
	config.set_value(row[3], "future_key", "keep")
	config.save(path)
	expect(save_owner(owner, row, 5) == OK, row[0] + " update with unknown keys")
	config.load(path)
	expect(config.get_value("future", "opaque") == {"payload": [3, "keep"]}, row[0] + " preserves unknown section")
	expect(config.get_value(row[3], "future_key") == "keep", row[0] + " preserves unknown owner key")
	if row[0] == "boat_decor_persistence":
		config.set_value("boat_decor", "items", {"bow_left": "future_item", "future_slot": "lantern"})
		config.set_value("boat_decor", "appearances", {"pet_corner": "future_appearance"})
		config.save(path)
		expect(save_owner(owner, row, 6) != OK, "future decor strings block ambiguous replacement")
		expect(owner.get_last_storage_result().status == "NOT_COMMITTED", "unsupported decor reports uncommitted save")
		config.load(path)
		expect(config.get_value("boat_decor", "items") == {"bow_left": "future_item", "future_slot": "lantern"}, "unsupported decor IDs stay intact")
		expect(config.get_value("boat_decor", "appearances") == {"pet_corner": "future_appearance"}, "unsupported appearance stays intact")
		var unsupported_bytes := FileAccess.get_file_as_bytes(path)
		for suffix in [".pending", ".recovery.json"]:
			var unresolved := FileAccess.open(path + suffix, FileAccess.WRITE)
			unresolved.store_string("[future]\nvalue=1\n" if suffix == ".pending" else '{"status":"RECOVERY_REQUIRED"}')
			unresolved.close()
			var unresolved_bytes := FileAccess.get_file_as_bytes(path + suffix)
			expect(save_owner(owner, row, 6) != OK, "unsupported plus unresolved transaction blocks write")
			expect(owner.get_last_storage_result().status == "RECOVERY_REQUIRED", "unresolved " + suffix + " takes precedence over unsupported IDs")
			expect(FileAccess.get_file_as_bytes(path) == unsupported_bytes, "unresolved unsupported source bytes remain intact")
			expect(FileAccess.get_file_as_bytes(path + suffix) == unresolved_bytes, "unresolved evidence remains intact")
			expect(owner.recover_primary().status == "COMMITTED", "explicit recovery resolves transaction without dropping unknown IDs")
			expect(save_owner(owner, row, 6) == ERR_UNAVAILABLE, "unsupported protection remains after explicit recovery")
			expect(owner.get_last_storage_result().status == "NOT_COMMITTED", "resolved unsupported file reports uncommitted replacement")
		CLEANUP.remove_store(path)
		expect(save_owner(owner, row, 5) == OK, "reset valid decor fixture")
	# Make the last-good payload exactly the first known value, then damage primary.
	expect(save_owner(owner, row, 6) == OK, row[0] + " prepare backup")
	var broken := "[".to_utf8_buffer()
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_buffer(broken)
	file.close()
	var broken_hash := FileAccess.get_sha256(path)
	var old_errors := Engine.print_error_messages
	Engine.print_error_messages = false
	expect(owner.call(row[2]) == row[7], row[0] + " reads verified backup")
	expect(owner.get_last_storage_result().status == "RECOVERED", row[0] + " read recovery is explicit")
	expect(FileAccess.get_file_as_bytes(path) == broken, row[0] + " load does not repair bytes")
	expect(not FileAccess.file_exists(path + ".recovery.json"), row[0] + " load does not create receipt")
	expect(save_owner(owner, row, 6) != OK, row[0] + " backup read does not authorize write")
	expect(owner.get_last_storage_result().status == "RECOVERY_REQUIRED", row[0] + " writer locks")
	expect(FileAccess.get_file_as_bytes(path) == broken, row[0] + " rejected save preserves primary")
	expect(owner.recover_primary().status == "COMMITTED", row[0] + " explicit restore commits")
	Engine.print_error_messages = old_errors
	expect(FileAccess.get_file_as_bytes(path + ".recovery." + broken_hash) == broken, row[0] + " archived damaged bytes")
	expect(owner.call(row[2]) == row[7], row[0] + " restored primary roundtrip")
	expect(save_owner(owner, row, 6) == OK, row[0] + " restored writer can commit")
	CLEANUP.remove_store(path)
	var invalid_values: Array = [false, 42, ["valid", 3], {"slot": 3}, {3: "item"}]
	if row[0] == "together_time_persistence":
		invalid_values = [false, "bad", -1.0, NAN, INF]
	elif row[0] == "cosmetic_identity_profile":
		invalid_values.append("future_style")
	for i in invalid_values.size():
		var invalid_path := path.trim_suffix(".cfg") + "_invalid_%d.cfg" % i
		CLEANUP.remove_store(invalid_path)
		var invalid_owner: Variant = load("res://scripts/core/" + row[0] + ".gd").new(invalid_path)
		config = ConfigFile.new()
		config.set_value(row[3], row[4], invalid_values[i])
		config.save(invalid_path)
		var original := FileAccess.get_file_as_bytes(invalid_path)
		invalid_owner.call(row[2])
		expect(invalid_owner.get_last_storage_result().status == "CORRUPT", row[0] + " invalid disk value status %d" % i)
		expect(FileAccess.get_file_as_bytes(invalid_path) == original, row[0] + " invalid load preserves bytes")
		expect(save_owner(invalid_owner, row, 5) != OK, row[0] + " invalid disk value blocks overwrite %d" % i)
		expect(FileAccess.get_file_as_bytes(invalid_path) == original, row[0] + " invalid save preserves bytes")
		CLEANUP.remove_store(invalid_path)
	# Missing optional keys are compatible and unrelated data remains intact.
	config = ConfigFile.new()
	config.set_value("future", "opaque", "keep")
	config.save(path)
	owner = load("res://scripts/core/" + row[0] + ".gd").new(path)
	owner.call(row[2])
	expect(owner.get_last_storage_result().status == "OK", row[0] + " missing optional keys are valid")
	expect(save_owner(owner, row, 5) == OK, row[0] + " optional-key file can update")
	var committed_bytes := FileAccess.get_file_as_bytes(path)
	owner._store = RejectPending.new()
	expect(save_owner(owner, row, 6) == ERR_FILE_CANT_WRITE, row[0] + " propagates actual store failure")
	expect(owner.get_last_storage_result().status == "NOT_COMMITTED", row[0] + " staging failure is not success")
	expect(FileAccess.get_file_as_bytes(path) == committed_bytes, row[0] + " failed owner write preserves bytes")
	expect(owner.recover_primary().status == "COMMITTED", row[0] + " failed staging intent can recover")
	CLEANUP.remove_store(path)
	var secondary_key: String = {"boat_decor_persistence": "appearances", "cosmetic_identity_profile": "pet_type_id", "memory_ledger_persistence": "voyage_records"}.get(row[0], "")
	if not secondary_key.is_empty():
		for i in invalid_values.size():
			var secondary_path := path.trim_suffix(".cfg") + "_secondary_%d.cfg" % i
			CLEANUP.remove_store(secondary_path)
			var secondary_owner: Variant = load("res://scripts/core/" + row[0] + ".gd").new(secondary_path)
			config = ConfigFile.new()
			config.set_value(row[3], secondary_key, invalid_values[i])
			config.save(secondary_path)
			var original := FileAccess.get_file_as_bytes(secondary_path)
			secondary_owner.call(row[2])
			expect(secondary_owner.get_last_storage_result().status == "CORRUPT", row[0] + " secondary invalid status %d" % i)
			expect(save_owner(secondary_owner, row, 5) != OK, row[0] + " secondary invalid blocks overwrite %d" % i)
			expect(FileAccess.get_file_as_bytes(secondary_path) == original, row[0] + " secondary invalid preserves bytes")
			CLEANUP.remove_store(secondary_path)

func expect(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		printerr("FAIL: " + message)
