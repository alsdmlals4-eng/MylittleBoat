# 실제 항해 화면과 저장 포스트카드 앨범의 GPU 런타임 증거를 남긴다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const ALBUM_SCENE_PATH := "res://scenes/album.tscn"
const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-30-comfort-postcards"
const TEST_COMFORT_PATH := "user://test_capture_comfort_preferences.cfg"
const TEST_PHOTO_CONFIG_PATH := "user://test_capture_voyage_postcards.cfg"
const TEST_PHOTO_IMAGE_DIRECTORY := "user://test_capture_voyage_postcards"
const DEFAULT_COMFORT_PATH := "user://comfort_preferences_v1.cfg"
const DEFAULT_PHOTO_CONFIG_PATH := "user://voyage_postcards_v1.cfg"
const DEFAULT_PHOTO_IMAGE_DIRECTORY := "user://voyage_postcards_v1"
const PROFILE_IDS := ["standard", "gentle", "still"]

var _postcard_manifest: Array[Dictionary] = []
var _failures := 0


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(540, 960)
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		_fail("could not create comfort postcard evidence directory")
		return
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_fail("GameState autoload must exist")
		return
	var prior_session := {
		"voyage_active": game_state.voyage_active,
		"remaining_seconds": game_state.remaining_seconds,
		"speed_index": game_state.speed_index,
		"appreciation_mode": game_state.appreciation_mode,
		"voyage_record_created": game_state.voyage_record_created,
	}
	_cleanup_test_storage()
	game_state.set_comfort_storage_path(TEST_COMFORT_PATH)
	game_state.set_photo_memory_storage(TEST_PHOTO_CONFIG_PATH, TEST_PHOTO_IMAGE_DIRECTORY)
	game_state.reset_session()
	game_state.voyage_active = true
	game_state.remaining_seconds = 300.0

	var game_scene := await _create_game_scene()
	if game_scene == null:
		_restore_game_state(game_state, prior_session)
		return
	for profile_id in PROFILE_IDS:
		if not await _capture_profile(game_scene, game_state, profile_id):
			await _cleanup(game_scene, null, game_state, prior_session)
			return
	game_scene.queue_free()
	await process_frame
	if not await _capture_album():
		_restore_game_state(game_state, prior_session)
		return
	_write_manifest()
	_restore_game_state(game_state, prior_session)
	if _failures == 0:
		print("PASS: comfort and voyage postcard runtime capture")
		quit(0)
	else:
		quit(1)


func _create_game_scene() -> Node:
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	if packed_scene == null:
		_fail("game scene must load for postcard capture")
		return null
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	if not scene.has_method("apply_real_time_atmosphere_for_hour") or not scene.has_method("_apply_drift_motion"):
		scene.queue_free()
		await process_frame
		_fail("game scene must expose atmosphere and drift APIs")
		return null
	scene.apply_real_time_atmosphere_for_hour(12)
	scene.set_process(false)
	await _wait_for_frames(10)
	return scene


func _capture_profile(scene: Node, game_state: Node, profile_id: String) -> bool:
	game_state.set_motion_comfort_profile(profile_id)
	scene.set("_drift_phase", 0.65)
	scene.call("_apply_drift_motion", 0.0)
	scene.call("_update_ui")
	scene.call("open_rest_menu")
	await _wait_for_frames(3)
	if not await _save_runtime_image("bright_%s_540x960.png" % profile_id):
		return false
	var before_count: int = game_state.photo_memories.size()
	var photo_button := scene.get_node_or_null("BottomPanel/ButtonGrid/TakePhotoButton") as Button
	if photo_button == null:
		_fail("public photo button must exist for postcard capture")
		return false
	photo_button.emit_signal("pressed")
	RenderingServer.force_draw(true)
	await RenderingServer.frame_post_draw
	await process_frame
	if game_state.photo_memories.size() != before_count + 1:
		_fail("public photo button must save one postcard for %s" % profile_id)
		return false
	var entry: Dictionary = game_state.photo_memories.back()
	var image_path := str(entry.get("image_path", ""))
	if image_path.is_empty() or not FileAccess.file_exists(image_path):
		_fail("saved postcard PNG must exist for %s" % profile_id)
		return false
	_postcard_manifest.append({
		"comfort_profile": profile_id,
		"label": str(entry.get("label", "")),
		"atmosphere_id": str(entry.get("atmosphere_id", "")),
		"image_path": image_path,
	})
	return true


func _capture_album() -> bool:
	var packed_scene := load(ALBUM_SCENE_PATH) as PackedScene
	if packed_scene == null:
		_fail("album scene must load for postcard capture")
		return false
	var album_scene := packed_scene.instantiate()
	root.add_child(album_scene)
	await _wait_for_frames(8)
	var row := album_scene.get_node_or_null("Margin/Panel/VBox/PostcardRow") as HBoxContainer
	if row == null or row.get_child_count() != 3:
		album_scene.queue_free()
		await process_frame
		_fail("album capture must show the three saved postcard cards")
		return false
	var saved := await _save_runtime_image("album_recent_postcards_540x960.png")
	album_scene.queue_free()
	await process_frame
	return saved


func _save_runtime_image(file_name: String) -> bool:
	RenderingServer.force_draw(true)
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	if image == null or image.is_empty():
		_fail("empty runtime image for %s" % file_name)
		return false
	var output_path := "%s/%s" % [EVIDENCE_DIRECTORY, file_name]
	if image.save_png(output_path) != OK:
		_fail("could not save %s" % file_name)
		return false
	print("SAVED: %s (%dx%d)" % [output_path, image.get_width(), image.get_height()])
	return true


func _write_manifest() -> void:
	var output_path := "%s/postcards_manifest.json" % EVIDENCE_DIRECTORY
	var file := FileAccess.open(output_path, FileAccess.WRITE)
	if file == null:
		_fail("could not write postcard capture manifest")
		return
	file.store_string(JSON.stringify({"postcards": _postcard_manifest}, "\t"))
	file.close()
	print("SAVED: %s" % output_path)


func _restore_game_state(game_state: Node, prior_session: Dictionary) -> void:
	game_state.reset_session()
	game_state.voyage_active = bool(prior_session["voyage_active"])
	game_state.remaining_seconds = float(prior_session["remaining_seconds"])
	game_state.speed_index = int(prior_session["speed_index"])
	game_state.appreciation_mode = bool(prior_session["appreciation_mode"])
	game_state.voyage_record_created = bool(prior_session["voyage_record_created"])
	game_state.set_comfort_storage_path(DEFAULT_COMFORT_PATH)
	game_state.set_photo_memory_storage(DEFAULT_PHOTO_CONFIG_PATH, DEFAULT_PHOTO_IMAGE_DIRECTORY)
	_cleanup_test_storage()


func _cleanup(scene: Node, album_scene: Node, game_state: Node, prior_session: Dictionary) -> void:
	if scene != null:
		scene.queue_free()
	if album_scene != null:
		album_scene.queue_free()
	await process_frame
	_restore_game_state(game_state, prior_session)


func _cleanup_test_storage() -> void:
	if FileAccess.file_exists(TEST_COMFORT_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_COMFORT_PATH))
	if FileAccess.file_exists(TEST_PHOTO_CONFIG_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_PHOTO_CONFIG_PATH))
	if DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(TEST_PHOTO_IMAGE_DIRECTORY)):
		var directory := DirAccess.open(TEST_PHOTO_IMAGE_DIRECTORY)
		if directory != null:
			for file_name in directory.get_files():
				directory.remove(file_name)
		DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_PHOTO_IMAGE_DIRECTORY))


func _wait_for_frames(frame_count: int) -> void:
	for _frame in frame_count:
		await process_frame


func _fail(message: String) -> void:
	_failures += 1
	printerr("FAILED: %s" % message)
	quit(1)
