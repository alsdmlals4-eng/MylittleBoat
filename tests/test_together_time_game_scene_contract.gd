# 함께한 시간이 foreground 항해 화면에서만 누적되는지 검증한다.
extends SceneTree

const PRESENTATION_PATH := "res://scripts/companion/together_time_presentation.gd"
const GAME_SCENE_PATH := "res://scenes/game.tscn"
const STORAGE_PATH := "user://test_together_time_game_scene.cfg"
const MEMORY_LEDGER_STORAGE_PATH := "user://test_together_time_game_scene_memory_ledger.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(ResourceLoader.exists(PRESENTATION_PATH), "together-time presentation owner must exist")
	if not ResourceLoader.exists(PRESENTATION_PATH):
		_finish()
		return
	var presentation: Variant = (load(PRESENTATION_PATH) as Script).new()
	_expect(presentation.get_duration_copy(0.0) == "함께한 시간: 잠시", "zero time must use calm non-progress copy")
	_expect(presentation.get_duration_copy(125.0) == "함께한 시간: 2분", "minute copy must floor rather than show seconds")
	_expect(presentation.get_duration_copy(3660.0) == "함께한 시간: 1시간 1분", "hour copy must include a remaining whole minute")
	_expect("Lv" not in presentation.get_relation_copy(125.0), "relation copy must not expose a level")

	var state := root.get_node_or_null("GameState")
	_expect(state != null, "GameState autoload must exist")
	_expect(ResourceLoader.exists(GAME_SCENE_PATH), "game scene must exist")
	if state == null or not ResourceLoader.exists(GAME_SCENE_PATH):
		_finish()
		return
	_clear_test_storage()
	_clear_memory_ledger_storage()
	state.set_together_time_storage_path(STORAGE_PATH)
	state.set_memory_ledger_storage_path(MEMORY_LEDGER_STORAGE_PATH)
	state.together_time_seconds = 0.0
	state.begin_voyage()
	var scene := (load(GAME_SCENE_PATH) as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame

	state.together_time_seconds = 0.0
	scene.set_application_foreground(false)
	scene._process(4.0)
	_expect(is_zero_approx(state.together_time_seconds), "backgrounded game scene must not accumulate together time")

	scene.set_application_foreground(true)
	state.speed_index = 2
	scene._process(2.0)
	_expect(is_equal_approx(state.together_time_seconds, 2.0), "speed must not multiply together time")
	scene.call("_toggle_appreciation_mode")
	scene._process(1.0)
	_expect(is_equal_approx(state.together_time_seconds, 3.0), "Appreciation Camera must share the same together time")

	state.remaining_seconds = 0.0
	state.complete_voyage()
	scene._process(1.0)
	_expect(is_equal_approx(state.together_time_seconds, 4.0), "post-record resting must keep accumulating together time")
	scene.queue_free()
	await process_frame
	state.set_together_time_storage_path("user://together_time_v1.cfg")
	_clear_test_storage()
	state.set_memory_ledger_storage_path("user://memory_ledger_v1.cfg")
	_clear_memory_ledger_storage()
	_finish()


func _clear_test_storage() -> void:
	if FileAccess.file_exists(STORAGE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(STORAGE_PATH))


func _clear_memory_ledger_storage() -> void:
	if FileAccess.file_exists(MEMORY_LEDGER_STORAGE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(MEMORY_LEDGER_STORAGE_PATH))


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: together time game scene contract")
		quit(0)
	else:
		printerr("FAILED: %d together-time game scene assertions" % _failures)
		quit(1)
