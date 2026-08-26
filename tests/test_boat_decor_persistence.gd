# 보트 꾸미기 로컬 저장과 손상 파일 fail-closed 계약을 검증한다.
extends SceneTree

const PERSISTENCE_PATH := "res://scripts/core/boat_decor_persistence.gd"
const TEST_SAVE_PATH := "user://boat_decor_persistence_contract.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_remove_test_save()
	_expect(ResourceLoader.exists(PERSISTENCE_PATH), "boat decor persistence service must exist")
	if ResourceLoader.exists(PERSISTENCE_PATH):
		var persistence_script := load(PERSISTENCE_PATH)
		_expect(persistence_script != null, "boat decor persistence service must load")
		if persistence_script != null:
			var store = persistence_script.new(TEST_SAVE_PATH)
			_expect(store.has_method("save"), "persistence service must save decor")
			_expect(store.has_method("load"), "persistence service must load decor")
			if store.has_method("save") and store.has_method("load"):
				var save_result = store.save({"bow_left": "lantern", "pet_corner": "pet_cushion"}, {"pet_corner": "moon"})
				_expect(save_result == OK, "valid cosmetic decor must save")
				var restored: Dictionary = store.load()
				_expect(restored.get("decor", {}) == {"bow_left": "lantern", "pet_corner": "pet_cushion"}, "decor must survive a new persistence read")
				_expect(restored.get("appearances", {}) == {"pet_corner": "moon"}, "cushion appearance must survive a new persistence read")

				var invalid_config := ConfigFile.new()
				invalid_config.set_value("boat_decor", "items", 42)
				invalid_config.set_value("boat_decor", "appearances", ["moon"])
				_expect(invalid_config.save(TEST_SAVE_PATH) == OK, "test must create a wrong-typed local save")
				var invalid_result: Dictionary = store.load()
				_expect(invalid_result.get("decor", {}) == {}, "wrong-typed save must restore an empty decor dictionary")
				_expect(invalid_result.get("appearances", {}) == {}, "wrong-typed save must restore an empty appearance dictionary")

	_remove_test_save()
	_finish()


func _remove_test_save() -> void:
	var absolute_path := ProjectSettings.globalize_path(TEST_SAVE_PATH)
	if FileAccess.file_exists(TEST_SAVE_PATH):
		DirAccess.remove_absolute(absolute_path)


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: boat decor persistence contract")
		quit(0)
	else:
		printerr("FAILED: %d boat decor persistence assertions" % _failures)
		quit(1)
