# 물고기와 완료 항해 기록만 로컬 ledger에서 안전하게 복원되는지 검증한다.
extends SceneTree

const PERSISTENCE_PATH := "res://scripts/core/memory_ledger_persistence.gd"
const STORAGE_PATH := "user://test_memory_ledger_persistence.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_cleanup_test_storage()
	_expect(ResourceLoader.exists(PERSISTENCE_PATH), "memory-ledger persistence owner must exist")
	if not ResourceLoader.exists(PERSISTENCE_PATH):
		_finish()
		return
	_write_raw_config("")
	var persistence: Variant = (load(PERSISTENCE_PATH) as Script).new(STORAGE_PATH)
	var missing_entries: Dictionary = persistence.load_entries()
	_expect(missing_entries == {"fish": [], "voyage_records": []}, "missing memory ledger must restore empty fish and voyage-record lists")
	var fish_entries: Array[String] = ["정어리", "별빛 멸치"]
	var voyage_entries: Array[String] = ["오늘의 항해 · 사진 1 · 풍경 0 · 편지 0 · 물고기 1"]
	_expect(persistence.save_entries(fish_entries, voyage_entries) == OK, "memory ledger must save fish and completed voyage records")
	_expect(persistence.load_entries() == {"fish": fish_entries, "voyage_records": voyage_entries}, "saved memory ledger must restore fish and voyage records in their original order")
	_write_raw_config("[memory_ledger]\nfish=[\"첫 물고기\", 3, \"  \"]\nvoyage_records=[\"첫 항해\", false, \"\"]\nletters=[\"보류 편지\"]\n")
	var restored_entries: Dictionary = persistence.load_entries()
	_expect(restored_entries == {"fish": ["첫 물고기"], "voyage_records": ["첫 항해"]}, "malformed or blank ledger values must be omitted while valid fish and voyage records stay ordered")
	_expect(not restored_entries.has("letters"), "memory ledger must never restore delayed bottle letters")
	_finish()


func _write_raw_config(contents: String) -> void:
	var file := FileAccess.open(STORAGE_PATH, FileAccess.WRITE)
	_expect(file != null, "test must be able to write its isolated memory ledger")
	if file != null:
		file.store_string(contents)


func _cleanup_test_storage() -> void:
	DirAccess.remove_absolute(ProjectSettings.globalize_path(STORAGE_PATH))


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	_cleanup_test_storage()
	if _failures == 0:
		print("PASS: memory-ledger persistence contract")
		quit(0)
	else:
		printerr("FAILED: %d memory-ledger persistence assertions" % _failures)
		quit(1)
