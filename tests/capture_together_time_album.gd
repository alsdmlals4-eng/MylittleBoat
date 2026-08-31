# 함께한 시간 앨범 소비처를 세로 해상도로 캡처한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-30-direct-entry-real-time"
const ALBUM_PATH := "res://scenes/album.tscn"
const CAPTURE_NAME := "album_together_time_540x960.png"


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(540, 960)
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		_fail("could not create together-time evidence directory")
		return
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_fail("GameState autoload must exist")
		return
	var packed_scene := load(ALBUM_PATH) as PackedScene
	if packed_scene == null:
		_fail("album scene must load")
		return
	game_state.photos.clear()
	game_state.sceneries.clear()
	game_state.letters.clear()
	game_state.fish.clear()
	game_state.voyage_records.clear()
	game_state.photos.append("랜턴과 구름 사이의 바다")
	game_state.sceneries.append("푸른 수평선")
	game_state.letters.append("파도 소리가 고요했어요")
	game_state.fish.append("정어리")
	game_state.voyage_records.append("오늘의 항해 · 사진 1 · 풍경 1 · 편지 1 · 물고기 1")
	game_state.together_time_seconds = 3660.0

	var scene := packed_scene.instantiate()
	root.add_child(scene)
	for _frame in 10:
		await process_frame
	var summary := scene.get_node_or_null("Margin/Panel/VBox/SummaryLabel") as Label
	if summary == null:
		_fail("album summary label must exist")
		return
	if "함께한 시간: 1시간 1분" not in summary.text:
		_fail("album summary must show the together-time duration")
		return
	if "Lv" in summary.text or "호감도" in summary.text:
		_fail("album summary must not show legacy level copy")
		return
	var image := root.get_texture().get_image()
	scene.queue_free()
	await process_frame
	if image == null or image.is_empty():
		_fail("together-time Album image must not be empty")
		return
	var output_path := "%s/%s" % [EVIDENCE_DIRECTORY, CAPTURE_NAME]
	if image.save_png(output_path) != OK:
		_fail("could not save %s" % output_path)
		return
	print("SAVED: %s (%dx%d)" % [output_path, image.get_width(), image.get_height()])
	print("PASS: together-time Album runtime capture")
	quit(0)


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
