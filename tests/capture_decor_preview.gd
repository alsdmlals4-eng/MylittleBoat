# 꾸미기 패널의 분리된 보트 미리보기를 실제 화면 증거로 저장한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-30-direct-entry-real-time"
const IDENTITY_TEST_SAVE_PATH := "user://capture_decor_preview_identity.cfg"
const DECOR_TEST_SAVE_PATH := "user://capture_decor_preview_decor.cfg"
const OUTPUT_FILE_NAME := "decor_preview_alt_identity_540x960.png"


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(540, 960)
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		_fail("could not create runtime evidence directory")
		return
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_fail("GameState autoload must exist")
		return
	_prepare_isolated_cosmetics(game_state)
	var packed_scene := load("res://scenes/game.tscn") as PackedScene
	if packed_scene == null:
		_fail("game scene must load")
		_restore_storage(game_state)
		return
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await _wait_for_frames(8)
	if not scene.has_method("_open_decor_panel"):
		_fail("game scene must expose decor-panel entry")
		await _cleanup(scene, game_state)
		return
	scene.call("_open_decor_panel")
	await _wait_for_frames(16)
	var preview := scene.get_node_or_null("DecorPanel/DecorVBox/DecorPreview") as SubViewportContainer
	var preview_boat_space := scene.get_node_or_null("DecorPanel/DecorVBox/DecorPreview/DecorPreviewViewport/PreviewWorld/BoatSpace") as Node3D
	var main_boat_space := scene.get_node_or_null("VoyageWorld/BoatSpace") as Node3D
	if preview == null or not preview.visible or preview_boat_space == null:
		_fail("decor preview surface must be visible before capture")
		await _cleanup(scene, game_state)
		return
	if main_boat_space == null or not main_boat_space.visible:
		_fail("default BoatSpace must remain visible once over the water-only backdrop")
		await _cleanup(scene, game_state)
		return
	if not _save_runtime_image(OUTPUT_FILE_NAME):
		await _cleanup(scene, game_state)
		return
	await _cleanup(scene, game_state)
	print("PASS: decor preview runtime capture")
	quit(0)


func _prepare_isolated_cosmetics(game_state: Node) -> void:
	DirAccess.remove_absolute(ProjectSettings.globalize_path(IDENTITY_TEST_SAVE_PATH))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(DECOR_TEST_SAVE_PATH))
	game_state.set_identity_storage_path(IDENTITY_TEST_SAVE_PATH)
	game_state.set_boat_decor_storage_path(DECOR_TEST_SAVE_PATH)
	game_state.boat_decor.clear()
	game_state.boat_decor_appearances.clear()
	game_state.set_selected_player_style("a_soft_hooded")
	game_state.set_selected_pet_type("otter")
	game_state.set_boat_decor("bow_left", "lantern")
	game_state.set_boat_decor("center_left", "cushion")
	game_state.set_boat_decor("rail_accent", "postcard")
	game_state.set_boat_decor("pet_corner", "pet_cushion")
	game_state.set_boat_decor_appearance("pet_corner", "botanical")
	game_state.reset_session()
	game_state.voyage_active = true
	game_state.remaining_seconds = 300.0


func _wait_for_frames(frame_count: int) -> void:
	for _frame in frame_count:
		await process_frame


func _save_runtime_image(file_name: String) -> bool:
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


func _cleanup(scene: Node, game_state: Node) -> void:
	scene.queue_free()
	await process_frame
	_restore_storage(game_state)


func _restore_storage(game_state: Node) -> void:
	game_state.reset_session()
	game_state.set_identity_storage_path("user://identity_profile_v1.cfg")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(IDENTITY_TEST_SAVE_PATH))
	game_state.boat_decor.clear()
	game_state.boat_decor_appearances.clear()
	game_state.set_boat_decor_storage_path("user://boat_decor_v1.cfg")
	game_state.load_boat_decor()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(DECOR_TEST_SAVE_PATH))


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
