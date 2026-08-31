# 앨범이 물고기와 항해 기록까지 개인적인 기억으로 보여주는지 검증한다.
extends SceneTree

const PHOTO_CONFIG_PATH := "user://test_album_postcards.cfg"
const PHOTO_IMAGE_DIRECTORY := "user://test_album_postcards"
const MEMORY_LEDGER_STORAGE_PATH := "user://test_album_memory_ledger.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	if game_state == null:
		_finish()
		return

	_clear_memory_ledger_storage()
	game_state.set_memory_ledger_storage_path(MEMORY_LEDGER_STORAGE_PATH)
	game_state.photos.clear()
	game_state.photo_memories.clear()
	game_state.sceneries.clear()
	game_state.letters.clear()
	game_state.fish.clear()
	game_state.voyage_records.clear()
	game_state.together_time_seconds = 3660.0
	_cleanup_photo_storage()
	game_state.set_photo_memory_storage(PHOTO_CONFIG_PATH, PHOTO_IMAGE_DIRECTORY)
	_expect(_add_postcard(game_state, "새벽 물결", "dawn", Color(0.95, 0.63, 0.36)), "Album fixture must save a dawn postcard")
	_expect(_add_postcard(game_state, "밝은 물결", "bright", Color(0.24, 0.78, 0.86)), "Album fixture must save a bright postcard")
	_expect(_add_postcard(game_state, "노을 물결", "sunset", Color(0.95, 0.4, 0.42)), "Album fixture must save a sunset postcard")
	_expect(_add_postcard(game_state, "밤 물결", "night", Color(0.18, 0.25, 0.56)), "Album fixture must save a night postcard")
	game_state.add_fish("정어리")
	game_state.voyage_records.append("평온의 항해 · 사진 4 · 풍경 0 · 편지 0 · 물고기 1")

	var packed_scene := load("res://scenes/album.tscn") as PackedScene
	_expect(packed_scene != null, "album.tscn must load")
	if packed_scene == null:
		_finish()
		return

	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame
	var summary := scene.get_node_or_null("Margin/Panel/VBox/SummaryLabel") as Label
	var recent_memory := scene.get_node_or_null("Margin/Panel/VBox/RecentMemoryLabel") as Label
	var postcard_row := scene.get_node_or_null("Margin/Panel/VBox/PostcardRow") as HBoxContainer
	_expect(summary != null, "Album must expose SummaryLabel")
	_expect(recent_memory != null, "Album must expose recent voyage memories")
	_expect(postcard_row != null, "Album must expose a recent postcard row")
	if summary != null:
		_expect("물고기 앨범: 1마리" in summary.text, "Album must show fish memory count")
		_expect("항해 기록: 1회" in summary.text, "Album must show voyage record count")
		_expect("함께한 시간: 1시간 1분" in summary.text, "Album must show a readable together-time duration")
		_expect("Lv" not in summary.text and "호감도" not in summary.text, "Album must not show legacy companion level copy")
	if recent_memory != null:
		_expect("최근 물고기: 정어리" in recent_memory.text, "Album must show the most recent fish memory")
		_expect("최근 항해: 평온의 항해" in recent_memory.text, "Album must show the most recent voyage memory")
	if postcard_row != null:
		_expect(postcard_row.get_child_count() == 3, "Album must show only the latest three real postcards")
		if postcard_row.get_child_count() == 3:
			var newest_card := postcard_row.get_child(0) as VBoxContainer
			var oldest_visible_card := postcard_row.get_child(2) as VBoxContainer
			var newest_image := newest_card.get_node_or_null("Image") as TextureRect
			var newest_caption := newest_card.get_node_or_null("Caption") as Label
			var oldest_caption := oldest_visible_card.get_node_or_null("Caption") as Label
			_expect(newest_image != null and newest_image.texture != null, "Album postcard card must use the saved PNG image")
			_expect(newest_caption != null and newest_caption.text == "밤 물결", "Album must show the newest postcard first")
			_expect(oldest_caption != null and oldest_caption.text == "밝은 물결", "Album must retain only the three newest postcard captions")
			_expect("점수" not in newest_caption.text and "희귀" not in newest_caption.text and "연속" not in newest_caption.text and "보상" not in newest_caption.text, "Album postcards must remain free of score or reward language")

	scene.queue_free()
	await process_frame
	_cleanup_photo_storage()
	game_state.set_memory_ledger_storage_path("user://memory_ledger_v1.cfg")
	_clear_memory_ledger_storage()
	_finish()


func _add_postcard(game_state: Node, label: String, atmosphere_id: String, color: Color) -> bool:
	var image := Image.create_empty(8, 8, false, Image.FORMAT_RGBA8)
	image.fill(color)
	return game_state.record_photo_memory(image, label, atmosphere_id)


func _cleanup_photo_storage() -> void:
	if FileAccess.file_exists(PHOTO_CONFIG_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(PHOTO_CONFIG_PATH))
	if DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(PHOTO_IMAGE_DIRECTORY)):
		var directory := DirAccess.open(PHOTO_IMAGE_DIRECTORY)
		if directory != null:
			for file_name in directory.get_files():
				directory.remove(file_name)
		DirAccess.remove_absolute(ProjectSettings.globalize_path(PHOTO_IMAGE_DIRECTORY))


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
		print("PASS: album memory contract")
		quit(0)
	else:
		printerr("FAILED: %d album memory assertions" % _failures)
		quit(1)
