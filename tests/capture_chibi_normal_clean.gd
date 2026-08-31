# 저장된 꾸미기 선택을 바꾸지 않고 깨끗한 치비 정상 화면을 GPU로 저장한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const TEST_DECOR_SAVE_PATH := "user://chibi_normal_clean_capture_decor.cfg"
const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-30-chibi-normal-material-proof"
const EVIDENCE_FILE_NAME := "chibi_normal_clean_night_540x960.png"


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(540, 960)
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_fail("GameState autoload must exist")
		return
	game_state.set_boat_decor_storage_path(TEST_DECOR_SAVE_PATH)
	game_state.boat_decor.clear()
	game_state.boat_decor_appearances.clear()
	game_state.reset_session()
	game_state.voyage_active = true
	game_state.remaining_seconds = 300.0
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	if packed_scene == null:
		_restore_user_decor(game_state)
		_fail("game scene must load")
		return
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	if not scene.has_method("apply_real_time_atmosphere_for_hour"):
		await _cleanup(scene, game_state)
		_fail("game scene must expose injected real-time atmosphere API")
		return
	scene.apply_real_time_atmosphere_for_hour(22)
	await _wait_for_frames(12)
	RenderingServer.force_draw(true)
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	if image == null or image.is_empty():
		await _cleanup(scene, game_state)
		_fail("clean chibi normal capture must render an image")
		return
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		await _cleanup(scene, game_state)
		_fail("clean chibi normal evidence directory must exist")
		return
	var output_path := "%s/%s" % [EVIDENCE_DIRECTORY, EVIDENCE_FILE_NAME]
	if image.save_png(output_path) != OK:
		await _cleanup(scene, game_state)
		_fail("clean chibi normal capture must save evidence")
		return
	if _get_warm_foreground_width(image) < 220:
		await _cleanup(scene, game_state)
		_fail("clean chibi normal foreground must remain wide enough to read player, companion, and boat together")
		return
	await _cleanup(scene, game_state)
	print("SAVED: %s (%dx%d)" % [output_path, image.get_width(), image.get_height()])
	quit(0)


func _wait_for_frames(frame_count: int) -> void:
	for _frame in frame_count:
		await process_frame


func _cleanup(scene: Node, game_state: Node) -> void:
	scene.queue_free()
	await process_frame
	_restore_user_decor(game_state)


func _restore_user_decor(game_state: Node) -> void:
	game_state.set_boat_decor_storage_path("user://boat_decor_v1.cfg")
	game_state.load_boat_decor()
	if FileAccess.file_exists(TEST_DECOR_SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_DECOR_SAVE_PATH))


func _get_warm_foreground_width(image: Image) -> int:
	var minimum_x := image.get_width()
	var maximum_x := -1
	var start_y := 250
	var end_y := mini(680, image.get_height())
	for y in range(start_y, end_y, 2):
		for x in range(0, image.get_width(), 2):
			var pixel := image.get_pixel(x, y)
			var is_warm_foreground := pixel.r > 0.45 and pixel.g > 0.18 and pixel.r > pixel.b + 0.12
			if is_warm_foreground:
				minimum_x = mini(minimum_x, x)
				maximum_x = maxi(maximum_x, x)
	return maximum_x - minimum_x + 1 if maximum_x >= minimum_x else 0


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
