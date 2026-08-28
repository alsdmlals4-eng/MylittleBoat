# 자동 풍경 기억이 중복을 포함해 GameState와 로컬 저장 사이를 왕복하는지 검증한다.
extends SceneTree

const TEST_SAVE_PATH := "user://ambient_memory_game_state_roundtrip.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_remove_test_save()
	var state := root.get_node_or_null("GameState")
	_expect(state != null, "GameState autoload must exist")
	if state == null:
		_finish()
		return

	_expect(state.has_method("set_ambient_memory_storage_path"), "GameState must isolate ambient memory storage for a round-trip contract")
	if state.has_method("set_ambient_memory_storage_path"):
		state.sceneries.clear()
		state.call("set_ambient_memory_storage_path", TEST_SAVE_PATH)
		state.add_ambient_scenery("지나간 작은 부표")
		state.add_ambient_scenery("지나간 작은 부표")
		_expect(state.sceneries.size() == 2, "two equal ambient sightings must remain two in the current album")
		state.sceneries.clear()
		state.load_ambient_memories()
		_expect(state.sceneries == ["지나간 작은 부표", "지나간 작은 부표"], "saved duplicate ambient sightings must restore in order")
		state.call("set_ambient_memory_storage_path", "user://ambient_memories_v1.cfg")
	_remove_test_save()
	_finish()


func _remove_test_save() -> void:
	if FileAccess.file_exists(TEST_SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_SAVE_PATH))


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: ambient GameState duplicate round-trip contract")
		quit(0)
	else:
		printerr("FAILED: %d ambient GameState duplicate round-trip assertions" % _failures)
		quit(1)
