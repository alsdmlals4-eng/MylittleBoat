# 둘러보기 화면 상태가 기존 항해 상태와 분리되는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const PORT_ANGLE_TEXTURE_PATH := "res://assets/images/runtime/voyage/look_around/chibi_transparent/chibi-transparent-port.png"
const BRIGHT_MOTIF_TEXTURE_PATH := "res://assets/images/runtime/voyage/ambient_motifs/bright-seagrass-sandbar.png"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	if game_state == null:
		_finish()
		return

	game_state.reset_session()
	game_state.voyage_active = true
	game_state.remaining_seconds = 147.0
	game_state.speed_index = 2
	game_state.appreciation_mode = false
	var together_before: float = float(game_state.together_time_seconds)
	var photo_count: int = game_state.photos.size()
	var scenery_count: int = game_state.sceneries.size()
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	_expect(packed_scene != null, "game.tscn must load")
	if packed_scene == null:
		_finish()
		return

	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame

	var diorama_camera := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D") as Camera3D
	var appreciation_camera := scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D") as Camera3D
	var look_around_camera := scene.get_node_or_null("VoyageWorld/LookAroundCameraRig/LookAroundCamera3D") as Camera3D
	var look_around_backdrop := scene.get_node_or_null("VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/SeaBackdrop") as Sprite3D
	var look_around_sky := scene.get_node_or_null("VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/SkyBackdrop") as Sprite3D
	var final_diorama_card := scene.get_node_or_null("VoyageWorld/BoatSpace/FinalDioramaCard") as Sprite3D
	var boat_space := scene.get_node_or_null("VoyageWorld/BoatSpace") as Node3D
	var water_contact := scene.get_node_or_null("VoyageWorld/BoatWaterContact") as Sprite3D
	var look_around_button := scene.get_node_or_null("BottomPanel/ButtonGrid/LookAroundButton") as Button
	_expect(look_around_camera != null, "game scene must provide LookAroundCamera3D")
	_expect(look_around_backdrop != null, "game scene must provide the Look Around backdrop consumer")
	_expect(look_around_sky != null, "game scene must provide the Look Around static sky consumer")
	_expect(look_around_button != null, "rest menu must expose LookAroundButton")
	_expect(scene.has_method("set_look_around_mode"), "game scene must expose local Look Around mode routing")
	if scene.has_method("set_look_around_mode"):
		scene.call("set_look_around_mode", true)
		_expect(str(scene.call("get_active_camera_mode")) == "look_around", "enabled Look Around must report its own camera mode")
		_expect(look_around_camera != null and look_around_camera.current, "Look Around camera must become current")
		_expect(diorama_camera != null and not diorama_camera.current, "diorama camera must yield to Look Around")
		_expect(appreciation_camera != null and not appreciation_camera.current, "appreciation camera must yield to Look Around")
		_expect(not game_state.appreciation_mode, "Look Around must not leave appreciation state active")
		_expect(is_equal_approx(float(game_state.remaining_seconds), 147.0), "Look Around must not change voyage time")
		_expect(int(game_state.speed_index) == 2, "Look Around must not change speed")
		_expect(is_equal_approx(float(game_state.together_time_seconds), together_before), "Look Around toggle itself must not add together time")
		_expect(game_state.photos.size() == photo_count and game_state.sceneries.size() == scenery_count, "Look Around must not create memories")
		var look_around_controller := scene.get_node_or_null("VoyageWorld/LookAroundCameraRig")
		_expect(scene.has_method("get_look_around_requested_angle_id"), "game scene must retain the requested Look Around angle separately from display fallback")
		if look_around_controller != null and scene.has_method("get_look_around_requested_angle_id"):
			look_around_controller.call("set_view_angles", 76.0, 0.0)
			_expect(str(scene.call("get_look_around_requested_angle_id")) == "port", "camera yaw must retain a port request for approved art routing")
			_expect(str(scene.call("get_look_around_display_angle_id")) == "port", "approved port request must retain its own display angle")
			_expect(look_around_backdrop != null and look_around_backdrop.texture != null and look_around_backdrop.texture.resource_path == PORT_ANGLE_TEXTURE_PATH, "approved port request must load the exact port backdrop")
			_expect(look_around_sky != null and not look_around_sky.visible, "approved composite port art must hide the split sky instead of covering its boat with moving water")
			_expect(look_around_backdrop != null and look_around_backdrop.material_override == null, "approved composite port art must remain a whole still image rather than half-flowing")
			scene.call("_show_temporary_ambient_scenery_backdrop", BRIGHT_MOTIF_TEXTURE_PATH, 8.0)
			_expect(look_around_backdrop != null and look_around_backdrop.texture != null and look_around_backdrop.texture.resource_path == PORT_ANGLE_TEXTURE_PATH, "foreground scenery must not replace approved Look Around angle art")
			_expect(final_diorama_card != null and not final_diorama_card.visible, "non-front Look Around art must hide the duplicated normal diorama card")
			_expect(boat_space != null and boat_space.visible, "Look Around must keep the local BoatSpace state alive")
			_expect(water_contact != null and water_contact.visible, "Look Around must keep the water-contact ripple available")

		scene.call("_toggle_appreciation_mode")
		_expect(str(scene.call("get_active_camera_mode")) == "appreciation", "appreciation entry must exit Look Around before changing camera")
		scene.call("_toggle_appreciation_mode")
		_expect(str(scene.call("get_active_camera_mode")) == "diorama", "leaving appreciation must return to normal diorama")

		scene.call("set_look_around_mode", true)
		scene.call("_open_decor_panel")
		_expect(str(scene.call("get_active_camera_mode")) == "diorama", "decor entry must close Look Around for isolated controls")

	scene.queue_free()
	await process_frame
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: look around game scene contract")
		quit(0)
	else:
		printerr("FAILED: %d Look Around game scene assertions" % _failures)
		quit(1)
