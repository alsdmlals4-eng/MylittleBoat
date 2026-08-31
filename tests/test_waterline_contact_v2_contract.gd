# 승인된 좁은 수면 접점 레이어가 보트와 함께 자연스럽게 움직이는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const WATERLINE_TEXTURE_PATH := "res://assets/images/runtime/voyage/boat-waterline-contact-v2.png"
const COMFORT_STORAGE_PATH := "user://test_waterline_contact_v2_comfort.cfg"
const MAX_VERTICAL_LOCK_DELTA := 0.012
const MIN_WIDE_ASPECT_RATIO := 2.5
const MAX_BOAT_BASE_HEIGHT_FOR_LOWERED_FRAME := -2.6

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	_expect(ResourceLoader.exists(WATERLINE_TEXTURE_PATH), "approved v2 waterline texture must exist at its canonical runtime path")
	if game_state == null:
		_finish()
		return

	game_state.reset_session()
	if game_state.has_method("set_comfort_storage_path"):
		game_state.set_comfort_storage_path(COMFORT_STORAGE_PATH)
	if game_state.has_method("set_motion_comfort_profile"):
		game_state.set_motion_comfort_profile("standard")

	var scene := (load(GAME_SCENE_PATH) as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame

	var boat_space := scene.get_node_or_null("VoyageWorld/BoatSpace") as Node3D
	var waterline_contact := scene.get_node_or_null("VoyageWorld/BoatWaterlineContact") as Sprite3D
	_expect(boat_space != null, "waterline contact v2 must remain anchored to the primary BoatSpace")
	_expect(waterline_contact != null, "scene must expose a dedicated narrow BoatWaterlineContact layer")
	if boat_space != null and waterline_contact != null:
		_expect(waterline_contact.visible, "narrow waterline contact must be visible in the normal boat diorama")
		_expect(not waterline_contact.no_depth_test, "waterline contact must retain depth testing so it cannot paint over the whole diorama")
		_expect(waterline_contact.texture != null, "waterline contact must consume a runtime texture")
		if waterline_contact.texture != null:
			_expect(
				waterline_contact.texture.resource_path == WATERLINE_TEXTURE_PATH,
				"waterline contact must consume the user-approved v2 canonical texture",
			)
			_expect(
				float(waterline_contact.texture.get_width()) / float(waterline_contact.texture.get_height()) >= MIN_WIDE_ASPECT_RATIO,
				"waterline contact must remain a narrow horizontal strip rather than a full puddle",
			)

		var boat_base_position: Vector3 = scene.get("_boat_space_base_position")
		var waterline_base_position: Vector3 = scene.get("_boat_waterline_contact_base_position")
		_expect(
			boat_base_position.y <= MAX_BOAT_BASE_HEIGHT_FOR_LOWERED_FRAME,
			"portrait framing must keep the resting boat lower than the screen midpoint",
		)
		scene.call("_apply_drift_motion", 1.0)
		_expect(
			is_equal_approx(waterline_contact.position.x - waterline_base_position.x, boat_space.position.x - boat_base_position.x),
			"waterline contact must follow the boat lateral drift",
		)
		_expect(
			is_equal_approx(waterline_contact.position.z - waterline_base_position.z, boat_space.position.z - boat_base_position.z),
			"waterline contact must follow the boat forward surge",
		)
		_expect(
			absf((waterline_contact.position.y - waterline_base_position.y) - (boat_space.position.y - boat_base_position.y)) <= MAX_VERTICAL_LOCK_DELTA,
			"waterline contact must stay attached to the hull through gentle bobbing",
		)

		game_state.set_motion_comfort_profile("still")
		scene.set("_drift_phase", 0.0)
		scene.call("_apply_drift_motion", 1.0)
		_expect(
			waterline_contact.position.is_equal_approx(waterline_base_position),
			"still comfort must return the waterline contact to its base position",
		)

	scene.queue_free()
	await process_frame
	_remove_test_file()
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _remove_test_file() -> void:
	if FileAccess.file_exists(COMFORT_STORAGE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(COMFORT_STORAGE_PATH))


func _finish() -> void:
	if _failures == 0:
		print("PASS: waterline contact v2 contract")
		quit(0)
	else:
		printerr("FAILED: %d waterline contact v2 assertions" % _failures)
		quit(1)
