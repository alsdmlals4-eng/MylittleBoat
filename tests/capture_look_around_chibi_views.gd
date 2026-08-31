# 승인된 치비 둘러보기 각도와 감상 시점의 실제 런타임 화면 증거를 저장한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-30-look-around-chibi-transparent"
const GAME_SCENE_PATH := "res://scenes/game.tscn"
const RUNTIME_CAPTURE_GUARD_SCRIPT = preload("res://scripts/visual/runtime_capture_guard.gd")
const RUNTIME_ANGLE_TEXTURE_PATHS := {
	"port": "res://assets/images/runtime/voyage/look_around/chibi_transparent/chibi-transparent-port.png",
	"starboard": "res://assets/images/runtime/voyage/look_around/chibi_transparent/chibi-transparent-starboard.png",
	"aft": "res://assets/images/runtime/voyage/look_around/chibi_transparent/chibi-transparent-aft.png",
	"overhead": "res://assets/images/runtime/voyage/look_around/chibi_transparent/chibi-transparent-overhead.png",
}
const ANGLE_CAPTURES := [
	{"id": "port", "yaw": 76.0, "pitch": 0.0},
	{"id": "starboard", "yaw": -76.0, "pitch": 0.0},
	{"id": "aft", "yaw": 120.0, "pitch": 0.0},
	{"id": "overhead", "yaw": 0.0, "pitch": 32.0},
]


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(540, 960)
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		_fail("could not create Look Around evidence directory")
		return
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_fail("GameState autoload must exist")
		return
	var runtime_capture_guard = RUNTIME_CAPTURE_GUARD_SCRIPT.new()
	var capture_texture_paths: Array[String] = []
	capture_texture_paths.append_array(runtime_capture_guard.REQUIRED_TEXTURE_PATHS)
	for angle_id in RUNTIME_ANGLE_TEXTURE_PATHS:
		capture_texture_paths.append(str(RUNTIME_ANGLE_TEXTURE_PATHS[angle_id]))
	var unavailable_texture_paths := runtime_capture_guard.get_unavailable_texture_paths(capture_texture_paths)
	if not unavailable_texture_paths.is_empty():
		_fail("required imported runtime textures unavailable: %s" % ", ".join(unavailable_texture_paths))
		return
	game_state.reset_session()
	game_state.voyage_active = true
	game_state.remaining_seconds = 300.0
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	if packed_scene == null:
		_fail("game scene must load")
		return
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	if not scene.has_method("apply_real_time_atmosphere_for_hour"):
		await _cleanup(scene, game_state)
		_fail("game scene must expose injected real-time atmosphere API")
		return
	scene.apply_real_time_atmosphere_for_hour(22)
	if not scene.has_method("get_active_atmosphere_id") or scene.get_active_atmosphere_id() != "night":
		await _cleanup(scene, game_state)
		_fail("capture must use the night atmosphere")
		return
	await _wait_for_frames(12)
	if not await _save_runtime_image("normal_540x960.png"):
		await _cleanup(scene, game_state)
		return
	if not await _capture_approved_angles(scene):
		await _cleanup(scene, game_state)
		return
	scene.call("_toggle_appreciation_mode")
	await _wait_for_frames(10)
	if not scene.has_method("get_active_camera_mode") or scene.get_active_camera_mode() != "appreciation":
		await _cleanup(scene, game_state)
		_fail("appreciation capture must exit Look Around")
		return
	if not await _save_runtime_image("appreciation_540x960.png"):
		await _cleanup(scene, game_state)
		return
	await _cleanup(scene, game_state)
	print("PASS: approved chibi Look Around runtime captures")
	quit(0)


func _capture_approved_angles(scene: Node) -> bool:
	if not scene.has_method("set_look_around_mode"):
		_fail("game scene must expose Look Around routing")
		return false
	scene.set_look_around_mode(true)
	var look_around_controller := scene.get_node_or_null("VoyageWorld/LookAroundCameraRig")
	var backdrop := scene.get_node_or_null("VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/SeaBackdrop") as Sprite3D
	if look_around_controller == null or not look_around_controller.has_method("set_view_angles") or backdrop == null:
		_fail("Look Around camera controller and backdrop must exist")
		return false
	for angle_capture in ANGLE_CAPTURES:
		var angle_id := str(angle_capture["id"])
		look_around_controller.set_view_angles(float(angle_capture["yaw"]), float(angle_capture["pitch"]))
		await _wait_for_frames(8)
		if not scene.has_method("get_look_around_display_angle_id") or scene.get_look_around_display_angle_id() != angle_id:
			_fail("Look Around capture must resolve %s" % angle_id)
			return false
		var expected_path := str(RUNTIME_ANGLE_TEXTURE_PATHS[angle_id])
		if backdrop.texture == null or backdrop.texture.resource_path != expected_path:
			_fail("Look Around capture must render exact %s artwork" % angle_id)
			return false
		if not await _save_runtime_image("%s_540x960.png" % angle_id):
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
