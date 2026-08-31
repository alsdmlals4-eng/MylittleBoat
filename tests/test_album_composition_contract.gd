# 앨범이 실제 기억과 현실 현지 시간대 분위기를 분리해 보여주는지 검증한다.
extends SceneTree

const ALBUM_PATH := "res://scenes/album.tscn"
const MEMORY_LEDGER_STORAGE_PATH := "user://test_album_composition_memory_ledger.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	_expect(ResourceLoader.exists(ALBUM_PATH), "album scene must exist")
	if game_state == null or not ResourceLoader.exists(ALBUM_PATH):
		_finish()
		return
	_clear_memory_ledger_storage()
	game_state.set_memory_ledger_storage_path(MEMORY_LEDGER_STORAGE_PATH)
	game_state.photos.clear()
	game_state.sceneries.clear()
	game_state.letters.clear()
	game_state.fish.clear()
	game_state.voyage_records.clear()
	game_state.together_time_seconds = 125.0
	var scene := (load(ALBUM_PATH) as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame
	var background := scene.get_node_or_null("AtmosphereBackground") as TextureRect
	var summary := scene.get_node_or_null("Margin/Panel/VBox/SummaryLabel") as Label
	var recent_memory := scene.get_node_or_null("Margin/Panel/VBox/RecentMemoryLabel") as Label
	_expect(background != null, "album must expose the approved atmosphere background surface")
	_expect(background != null and background.texture != null, "album background must resolve a local-time atmosphere texture")
	var source := FileAccess.get_file_as_string("res://scripts/ui/album_view.gd")
	_expect(source.contains("real_time_atmosphere_resolver"), "album must resolve the current local atmosphere without saved selection")
	_expect(not source.contains("get_selected_time_of_day"), "album must not read a saved time preference")
	_expect(summary != null, "album must expose a total-memory summary")
	_expect(recent_memory != null, "album must expose a recent-memory summary")
	_expect(summary != null and "함께한 시간: 2분" in summary.text, "album must show the calm together-time duration")
	_expect(summary != null and "동반자와 같은 바다를 천천히 바라봤어요." in summary.text, "album must show the quiet together-time relation copy")
	_expect(summary != null and "Lv" not in summary.text and "호감도" not in summary.text, "album summary must not expose legacy level progress")
	_expect(recent_memory != null and "아직 모아 둔 기억이 없어요" in recent_memory.text, "empty album must use the calm empty-state copy")
	game_state.add_fish("정어리")
	game_state.voyage_records.append("오늘의 항해 · 사진 0 · 풍경 0 · 편지 0 · 물고기 1")
	if scene.has_method("refresh_album"):
		scene.refresh_album()
	_expect(recent_memory != null and "최근 물고기: 정어리" in recent_memory.text, "recent-memory area must show the most recent fish")
	_expect(recent_memory != null and "최근 항해: 오늘의 항해" in recent_memory.text, "recent-memory area must show the most recent voyage")
	scene.queue_free()
	await process_frame
	game_state.set_memory_ledger_storage_path("user://memory_ledger_v1.cfg")
	_clear_memory_ledger_storage()
	_finish()


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
		print("PASS: album composition contract")
		quit(0)
	else:
		printerr("FAILED: %d album composition assertions" % _failures)
		quit(1)
