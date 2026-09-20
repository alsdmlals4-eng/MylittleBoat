# 섬 전용 저장의 미래 버전 보호와 실패·복구를 실제 파일로 검사한다.
extends SceneTree

const Farm = preload("res://scripts/island/farm_state.gd")
var failures := 0
var checks := 0
var body_completed := false
var directory := "user://test_island_p1_save_%d_%d" % [OS.get_process_id(), Time.get_ticks_usec()]
var owned_files: Array[String] = []

class FaultStore extends "res://scripts/core/recoverable_config_store.gd":
	var mode := ""
	var replaced := false
	func _save(config: ConfigFile, path: String) -> Error:
		return ERR_FILE_CANT_WRITE if mode == "stage" else super._save(config, path)
	func _copy(source: String, target: String) -> Error:
		return ERR_FILE_CANT_WRITE if mode == "copy" and target.ends_with(".last_good") else super._copy(source, target)
	func _replace(source: String, target: String) -> Error:
		if mode == "replace": return ERR_FILE_CANT_WRITE
		replaced = true
		return super._replace(source, target)
	func _load(config: ConfigFile, path: String) -> Error:
		if mode == "readback" and replaced and path.ends_with(".cfg"):
			replaced = false
			return ERR_FILE_CANT_READ
		return super._load(config, path)
	func _remove(path: String) -> Error:
		return ERR_FILE_CANT_WRITE if mode == "unlock" and path.ends_with(".recovery.json") else super._remove(path)

func _init() -> void: call_deferred("run")

func expect(condition: bool, message: String) -> void:
	checks += 1
	if not condition:
		failures += 1
		printerr("FAIL: " + message)

func seed_snapshot(path: String, snapshot: Dictionary) -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("island", "snapshot", snapshot)
	cfg.set_value("other_owner", "retain", "unchanged")
	expect(cfg.save(path) == OK, "fixture write")

func hashes() -> Dictionary:
	var result := {}
	for name in DirAccess.get_files_at(directory):
		result[name] = FileAccess.get_sha256(directory.path_join(name))
	return result

func run() -> void:
	expect(ResourceLoader.exists("res://scripts/island/island_save_store.gd"), "planned island store exists")
	if failures == 0:
		expect(not DirAccess.dir_exists_absolute(directory), "collision abort")
		if failures == 0:
			expect(DirAccess.make_dir_recursive_absolute(directory) == OK, "isolated directory")
			test_body()
			expect(body_completed, "test body completed without script exception")
			for name in DirAccess.get_files_at(directory): owned_files.append(directory.path_join(name))
			for path in owned_files: expect(DirAccess.remove_absolute(path) == OK, "owned cleanup")
			expect(DirAccess.remove_absolute(directory) == OK, "directory cleanup")
	print("island_save: %d checks, %d failures" % [checks, failures])
	quit(0 if failures == 0 else 1)

func test_body() -> void:
	var script: Variant = load("res://scripts/island/island_save_store.gd")
	var farm := Farm.new(Farm.load_catalog("res://data/island/crops.json").crops)
	var good := farm.new_snapshot(1000.0)
	var path := directory.path_join("farm.cfg")
	var store: Variant = script.new(path, farm)
	expect(store.load_state().status == "ABSENT", "true absence")
	expect(store.commit(good).status == "COMMITTED", "first save")
	expect(store.load_state().snapshot == good, "roundtrip")
	seed_snapshot(path, good)
	expect(store.commit(good).status == "COMMITTED", "repeat save")
	var cfg := ConfigFile.new()
	cfg.load(path)
	expect(cfg.get_value("other_owner", "retain") == "unchanged", "other owner preserved")
	for suffix in ["", ".last_good", ".pending"]:
		var future_path := directory.path_join("future_%d.cfg" % suffix.length())
		seed_snapshot(future_path, good)
		seed_snapshot(future_path + ".last_good", good)
		var future := good.duplicate(true)
		future.schema_version = 2
		seed_snapshot(future_path + suffix, future)
		var protected: Variant = script.new(future_path, farm)
		var before := hashes()
		expect(protected.load_state().status == "UNSUPPORTED_VERSION", "future load " + suffix)
		expect(protected.commit(good).status == "UNSUPPORTED_VERSION", "future commit " + suffix)
		expect(protected.recover().status == "UNSUPPORTED_VERSION", "future recovery " + suffix)
		expect(hashes() == before, "all future bytes and entries preserved")
	var bad := good.duplicate(true)
	bad.revision = true
	seed_snapshot(path, bad)
	var before := hashes()
	expect(store.load_state().status == "RECOVERY_REQUIRED", "backup read only")
	expect(store.load_state().snapshot == good, "backup safe view")
	expect(hashes() == before, "read no write")
	expect(store.commit(good).status == "RECOVERY_REQUIRED", "cannot overwrite corruption")
	expect(store.recover().status == "COMMITTED", "explicit recovery")
	expect(store.load_state().status == "OK", "reload after recovery")
	for kind in ["nan", "negative", "crop", "missing", "version"]:
		bad = good.duplicate(true)
		match kind:
			"nan": bad.saved_at_utc = NAN
			"negative": bad.saved_at_utc = -1.0
			"crop": bad.plots.plot_01.crop_id = "alien"
			"missing": bad.plots.erase("plot_06")
			"version": bad.schema_version = 2
		before = hashes()
		expect(store.commit(bad).status == "NOT_COMMITTED", "invalid candidate " + kind)
		expect(hashes() == before, "invalid candidate nonmutating")
	for mode in ["stage", "copy", "replace", "readback", "unlock"]:
		var fault_path := directory.path_join(mode + ".cfg")
		if mode != "stage": seed_snapshot(fault_path, good)
		var fault := FaultStore.new()
		fault.mode = mode
		var fault_store: Variant = script.new(fault_path, farm, fault)
		var candidate := good.duplicate(true)
		candidate.revision = 1
		var result: Dictionary = fault_store.commit(candidate)
		expect(result.status in ["NOT_COMMITTED", "RECOVERY_REQUIRED"], "fault result " + mode)
		var fresh: Variant = script.new(fault_path, farm)
		if mode in ["stage", "copy", "unlock"]:
			expect(fresh.load_state().status == "RECOVERY_REQUIRED", "transaction lock " + mode)
			expect(fresh.commit(good).status == "RECOVERY_REQUIRED", "no auto overwrite " + mode)
			expect(FileAccess.file_exists(fault_path + ".recovery.json"), "recovery evidence " + mode)
		expect(fresh.recover().status == "COMMITTED", "explicit fault recovery " + mode)
		expect(fresh.load_state().status == ("ABSENT" if mode == "stage" else "OK"), "verified recovery state " + mode)
		if mode == "stage": expect(not FileAccess.file_exists(fault_path), "no automatic initial save")
		else: expect(fresh.load_state().snapshot == good, "original state restored " + mode)
	var broken_path := directory.path_join("invalid.cfg")
	seed_snapshot(broken_path, {"wrong": true})
	var broken: Variant = script.new(broken_path, farm)
	expect(broken.load_state().status == "CORRUPT", "malformed without backup")
	var missing := directory.path_join("missing.cfg")
	seed_snapshot(missing + ".last_good", good)
	expect(script.new(missing, farm).load_state().status == "RECOVERY_REQUIRED", "backup is not absence")
	body_completed = true
