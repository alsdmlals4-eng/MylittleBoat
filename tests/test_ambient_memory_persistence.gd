# 자동 풍경 기억이 로컬 파일에서 안전하게 복원되는지 검증한다.
extends SceneTree

const PERSISTENCE_PATH := "res://scripts/core/ambient_memory_persistence.gd"
const STORAGE_PATH := "user://test_ambient_memory_persistence.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_cleanup_test_storage()
	_expect(ResourceLoader.exists(PERSISTENCE_PATH), "ambient-memory persistence owner must exist")
	if not ResourceLoader.exists(PERSISTENCE_PATH):
		_finish()
		return
	_write_raw_config("")
	var persistence: Variant = (load(PERSISTENCE_PATH) as Script).new(STORAGE_PATH)
	_expect(persistence.load_entries().is_empty(), "missing ambient-memory file must restore an empty list")
	var entries: Array[String] = ["멀리 바위 아치 사이로 잔잔한 물줄기가 보입니다.", "해안의 모래빛 절벽이 물 위에 길게 번집니다."]
	_expect(persistence.save_entries(entries) == OK, "ambient-memory persistence must save valid entries")
	_expect(persistence.load_entries() == entries, "saved ambient memories must restore in their original order")
	_write_raw_config("[ambient_memory]\nentries=[\"첫 풍경\", 3, \"  \", \"둘째 풍경\"]\n")
	_expect(persistence.load_entries() == ["첫 풍경", "둘째 풍경"], "malformed or blank ambient-memory entries must be omitted")
	_finish()


func _write_raw_config(contents: String) -> void:
	var file := FileAccess.open(STORAGE_PATH, FileAccess.WRITE)
	_expect(file != null, "test must be able to write its isolated ConfigFile")
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
		print("PASS: ambient-memory persistence contract")
		quit(0)
	else:
		printerr("FAILED: %d ambient-memory persistence assertions" % _failures)
		quit(1)
