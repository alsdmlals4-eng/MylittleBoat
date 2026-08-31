# 복원된 물고기와 완료 항해 기록이 앨범에 보이는지 실제 화면으로 저장한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-30-memory-ledger"
const ALBUM_PATH := "res://scenes/album.tscn"
const STORAGE_PATH := "user://capture_memory_ledger_album.cfg"
const CAPTURE_NAME := "album_restored_fish_and_voyage_540x960.png"
const FISH_ENTRY := "유리빛 정어리"
const VOYAGE_ENTRY := "오늘의 항해 · 사진 0 · 풍경 0 · 편지 0 · 물고기 1"


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(540, 960)
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		_fail("could not create memory-ledger evidence directory")
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
	game_state.set_memory_ledger_storage_path(STORAGE_PATH)
	game_state.photos.clear()
	game_state.sceneries.clear()
	game_state.letters.clear()
	game_state.fish.clear()
	game_state.voyage_records.clear()
	game_state.begin_voyage()
	game_state.add_fish(FISH_ENTRY)
	game_state.remaining_seconds = 0.0
	game_state.complete_voyage()
	game_state.fish.clear()
	game_state.voyage_records.clear()
	game_state.letters.clear()
	game_state.load_memory_ledger()
	if game_state.fish != [FISH_ENTRY] or game_state.voyage_records != [VOYAGE_ENTRY] or not game_state.letters.is_empty():
		_restore_storage(game_state)
		_fail("only restored fish and completed voyage records may reach the Album")
		return
	game_state.together_time_seconds = 3660.0

	var scene := packed_scene.instantiate()
	root.add_child(scene)
	for _frame in 10:
		await process_frame
	var summary := scene.get_node_or_null("Margin/Panel/VBox/SummaryLabel") as Label
	var recent_memory := scene.get_node_or_null("Margin/Panel/VBox/RecentMemoryLabel") as Label
	if summary == null or recent_memory == null:
		await _cleanup(scene, game_state)
		_fail("Album must expose summary and recent-memory labels")
		return
	if "물고기 앨범: 1마리" not in summary.text or "항해 기록: 1회" not in summary.text:
		await _cleanup(scene, game_state)
		_fail("Album must show restored fish and voyage counts")
		return
	if FISH_ENTRY not in recent_memory.text or "최근 항해: 오늘의 항해" not in recent_memory.text:
		await _cleanup(scene, game_state)
		_fail("Album must show restored fish and voyage entries")
		return
	var image := root.get_texture().get_image()
	if image == null or image.is_empty():
		await _cleanup(scene, game_state)
		_fail("restored-memory Album image must not be empty")
		return
	var output_path := "%s/%s" % [EVIDENCE_DIRECTORY, CAPTURE_NAME]
	if image.save_png(output_path) != OK:
		await _cleanup(scene, game_state)
		_fail("could not save %s" % output_path)
		return
	await _cleanup(scene, game_state)
	print("SAVED: %s (%dx%d)" % [output_path, image.get_width(), image.get_height()])
	print("PASS: restored fish-and-voyage Album runtime capture")
	quit(0)


func _cleanup(scene: Node, game_state: Node) -> void:
	if scene != null:
		scene.queue_free()
		await process_frame
	_restore_storage(game_state)


func _restore_storage(game_state: Node) -> void:
	game_state.reset_session()
	game_state.set_memory_ledger_storage_path("user://memory_ledger_v1.cfg")
	_clear_storage()


func _clear_storage() -> void:
	if FileAccess.file_exists(STORAGE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(STORAGE_PATH))


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
