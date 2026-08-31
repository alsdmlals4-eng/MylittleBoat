# 저장 후 복원된 자동 풍경 기억이 앨범에 보이는지 세로 해상도로 캡처한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-30-direct-entry-real-time"
const ALBUM_PATH := "res://scenes/album.tscn"
const STORAGE_PATH := "user://capture_ambient_memory_album.cfg"
const CAPTURE_NAME := "album_restored_ambient_memory_540x960.png"
const AMBIENT_ENTRY := "멀리 바위 아치 사이로 잔잔한 물줄기가 보입니다."


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(540, 960)
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		_fail("could not create ambient-memory evidence directory")
		return
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_fail("GameState autoload must exist")
		return
	var packed_scene := load(ALBUM_PATH) as PackedScene
	if packed_scene == null:
		_fail("album scene must load")
		return
	_clear_storage()
	game_state.set_ambient_memory_storage_path(STORAGE_PATH)
	game_state.photos.clear()
	game_state.sceneries.clear()
	game_state.ambient_memories.clear()
	game_state.letters.clear()
	game_state.fish.clear()
	game_state.voyage_records.clear()
	game_state.record_ambient_memory(AMBIENT_ENTRY)
	game_state.ambient_memories.clear()
	game_state.sceneries.clear()
	game_state.load_ambient_memories()
	if game_state.sceneries != [AMBIENT_ENTRY]:
		_fail("restored ambient memory must populate the Album scenery entries")
		return
	game_state.together_time_seconds = 3660.0

	var scene := packed_scene.instantiate()
	root.add_child(scene)
	for _frame in 10:
		await process_frame
	var summary := scene.get_node_or_null("Margin/Panel/VBox/SummaryLabel") as Label
	var recent_memory := scene.get_node_or_null("Margin/Panel/VBox/RecentMemoryLabel") as Label
	if summary == null or recent_memory == null:
		_fail("Album must expose summary and recent-memory labels")
		return
	if "풍경 앨범: 1개" not in summary.text or AMBIENT_ENTRY not in recent_memory.text:
		_fail("Album must show the restored ambient memory")
		return
	var image := root.get_texture().get_image()
	scene.queue_free()
	await process_frame
	if image == null or image.is_empty():
		_fail("restored ambient-memory Album image must not be empty")
		return
	var output_path := "%s/%s" % [EVIDENCE_DIRECTORY, CAPTURE_NAME]
	if image.save_png(output_path) != OK:
		_fail("could not save %s" % output_path)
		return
	print("SAVED: %s (%dx%d)" % [output_path, image.get_width(), image.get_height()])
	print("PASS: restored ambient-memory Album runtime capture")
	quit(0)


func _clear_storage() -> void:
	var file := FileAccess.open(STORAGE_PATH, FileAccess.WRITE)
	if file != null:
		file.store_string("")


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
