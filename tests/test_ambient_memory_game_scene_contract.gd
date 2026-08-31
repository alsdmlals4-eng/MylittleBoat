# 자동 풍경 event가 named ambient writer를 통해 다음 실행에도 남는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const DIRECTOR_PATH := "res://scripts/voyage/drift_scenery_director.gd"
const STORAGE_PATH := "user://test_ambient_memory_game_scene.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var state := root.get_node_or_null("GameState")
	_expect(state != null, "GameState autoload must exist")
	_expect(ResourceLoader.exists(GAME_SCENE_PATH), "game scene must exist")
	if state == null or not ResourceLoader.exists(GAME_SCENE_PATH):
		_finish()
		return
	_cleanup_test_storage()
	state.set_ambient_memory_storage_path(STORAGE_PATH)
	state.ambient_memories.clear()
	state.sceneries.clear()
	state.begin_voyage()
	var saved_memory_seed := _find_saved_memory_seed()
	_expect(saved_memory_seed >= 0, "a deterministic scenery event must be able to request ambient-memory storage")
	if saved_memory_seed < 0:
		_finish()
		return
	var scene := (load(GAME_SCENE_PATH) as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame
	scene._drift_scenery_director.set_next_event_seconds_for_tests(0.0)
	seed(saved_memory_seed)
	scene._process(0.1)
	_expect(state.ambient_memories.size() == 1, "saved foreground scenery must use the named durable ambient-memory writer")
	_expect(state.sceneries == state.ambient_memories, "Album scenery consumer must match the durable ambient-memory ledger")
	var saved_entry: String = str(state.ambient_memories.front()) if not state.ambient_memories.is_empty() else ""
	state.ambient_memories.clear()
	state.sceneries.clear()
	state.load_ambient_memories()
	_expect(state.ambient_memories == [saved_entry] and not saved_entry.is_empty(), "foreground scenery memory must restore from local storage")
	scene.queue_free()
	await process_frame
	_finish()


func _find_saved_memory_seed() -> int:
	for candidate_seed in range(1, 257):
		var director = (load(DIRECTOR_PATH) as Script).new()
		seed(candidate_seed)
		director.set_next_event_seconds_for_tests(0.0)
		var event := Dictionary(director.advance(0.1, "bright"))
		if bool(event.get("save_memory", false)):
			return candidate_seed
	return -1


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
		print("PASS: ambient-memory game scene contract")
		quit(0)
	else:
		printerr("FAILED: %d ambient-memory game scene assertions" % _failures)
		quit(1)
