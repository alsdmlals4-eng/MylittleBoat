# 실제 기록 유무에 따른 현재 현지 분위기의 앨범 화면을 세로 해상도로 저장한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-28-album-composition"
const ALBUM_PATH := "res://scenes/album.tscn"


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(540, 960)
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		_fail("could not create album evidence directory")
		return
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_fail("GameState autoload must exist")
		return
	var packed_scene := load(ALBUM_PATH) as PackedScene
	if packed_scene == null:
		_fail("album scene must load")
		return
	_clear_memories(game_state)
	if not await _capture_scene(packed_scene, "album_empty_current_local_540x960.png"):
		return
	game_state.photos.append("랜턴과 구름 사이의 바다")
	game_state.sceneries.append("푸른 수평선")
	game_state.letters.append("파도 소리가 고요했어요")
	game_state.fish.append("정어리")
	game_state.voyage_records.append("오늘의 항해 · 사진 1 · 풍경 1 · 편지 1 · 물고기 1")
	game_state.together_time_seconds = 3660.0
	if not await _capture_scene(packed_scene, "album_populated_current_local_540x960.png"):
		return
	_clear_memories(game_state)
	print("PASS: album composition runtime captures")
	quit(0)


func _capture_scene(packed_scene: PackedScene, file_name: String) -> bool:
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	for _frame in 10:
		await process_frame
	var image := root.get_texture().get_image()
	scene.queue_free()
	await process_frame
	if image == null or image.is_empty():
		_fail("empty runtime image for %s" % file_name)
		return false
	var output_path := "%s/%s" % [EVIDENCE_DIRECTORY, file_name]
	if image.save_png(output_path) != OK:
		_fail("could not save %s" % file_name)
		return false
	print("SAVED: %s (%dx%d)" % [output_path, image.get_width(), image.get_height()])
	return true


func _clear_memories(game_state: Node) -> void:
	game_state.photos.clear()
	game_state.sceneries.clear()
	game_state.letters.clear()
	game_state.fish.clear()
	game_state.voyage_records.clear()
	game_state.together_time_seconds = 0.0


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
