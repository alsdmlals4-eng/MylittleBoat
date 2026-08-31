# 실제 보트의 부유와 수면 접점을 두 프레임의 런타임 증거로 저장한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-30-boat-float-contact"
const START_OUTPUT_FILE_NAME := "bright_boat_float_start_verified_v5_540x960.png"
const CREST_OUTPUT_FILE_NAME := "bright_boat_float_crest_verified_v5_540x960.png"


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(540, 960)
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		_fail("could not create boat-float evidence directory")
		return
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_fail("GameState autoload must exist")
		return
	game_state.reset_session()
	game_state.voyage_active = true
	game_state.remaining_seconds = 300.0
	game_state.speed_index = 1
	var packed_scene := load("res://scenes/game.tscn") as PackedScene
	if packed_scene == null:
		_fail("game scene must load")
		return
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await _wait_for_frames(8)
	if not await _prepare_bright_normal_capture(scene):
		await _cleanup(scene, game_state)
		return
	if not await _save_runtime_image(START_OUTPUT_FILE_NAME):
		await _cleanup(scene, game_state)
		return
	scene.call("_apply_drift_motion", 1.45)
	await _wait_for_frames(2)
	if not await _save_runtime_image(CREST_OUTPUT_FILE_NAME):
		await _cleanup(scene, game_state)
		return
	await _cleanup(scene, game_state)
	print("PASS: boat float and water-contact runtime capture")
	quit(0)


func _prepare_bright_normal_capture(scene: Node) -> bool:
	if not scene.has_method("apply_real_time_atmosphere_for_hour") or not scene.has_method("_apply_drift_motion"):
		_fail("game scene must expose atmosphere and drift-motion capture APIs")
		return false
	scene.call("set_process", false)
	scene.call("apply_real_time_atmosphere_for_hour", 12)
	scene.set("_drift_phase", 0.0)
	scene.call("_apply_drift_motion", 0.0)
	var boat_space := scene.get_node_or_null("VoyageWorld/BoatSpace") as Node3D
	var water_contact := scene.get_node_or_null("VoyageWorld/BoatWaterContact") as Sprite3D
	if boat_space == null or not boat_space.visible:
		_fail("one visible BoatSpace is required for float capture")
		return false
	if water_contact == null or not water_contact.visible or water_contact.texture == null:
		_fail("visible boat-water contact is required for float capture")
		return false
	return true


func _wait_for_frames(frame_count: int) -> void:
	for _frame in frame_count:
		await process_frame


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


func _cleanup(scene: Node, game_state: Node) -> void:
	scene.queue_free()
	await process_frame
	game_state.reset_session()


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
