# 목적지 없이 잔잔하게 앞으로 흐르는 보트 표현의 범위와 회귀를 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const COMFORT_STORAGE_PATH := "user://test_voyage_forward_drift_comfort.cfg"
const WATER_FLOW_SHADER_PATH := "res://assets/shaders/voyage_split_sea_flow.gdshader"
const FORWARD_FLOW_CAPTURE_SCRIPT_PATH := "res://tests/capture_voyage_forward_flow.gd"
const MAX_WATER_CONTACT_BASE_OFFSET_FROM_BOAT := 0.05
const MAX_CONTACT_GAP_DELTA_DURING_BOB := 0.012
const MIN_NORMAL_FORWARD_WATER_PROGRESS := 0.02

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_verify_forward_flow_capture_contract()
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	if game_state == null:
		_finish()
		return

	game_state.reset_session()
	_expect(ResourceLoader.exists(WATER_FLOW_SHADER_PATH), "continuous background flow must have a dedicated water shader")
	if game_state.has_method("set_comfort_storage_path"):
		game_state.set_comfort_storage_path(COMFORT_STORAGE_PATH)
	if game_state.has_method("set_motion_comfort_profile"):
		game_state.set_motion_comfort_profile("standard")

	var scene := (load(GAME_SCENE_PATH) as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame

	var boat_space := scene.get_node_or_null("VoyageWorld/BoatSpace") as Node3D
	var water_contact := scene.get_node_or_null("VoyageWorld/BoatWaterContact") as Sprite3D
	var final_diorama_card := scene.get_node_or_null("VoyageWorld/BoatSpace/FinalDioramaCard") as Sprite3D
	_expect(boat_space != null, "forward drift must retain the primary BoatSpace")
	_expect(water_contact != null, "forward drift must retain the visible water-contact layer")
	_expect(final_diorama_card != null, "water contact must be aligned to the actual final diorama boat card")
	if boat_space != null and water_contact != null and final_diorama_card != null:
		var boat_base_position: Vector3 = scene.get("_boat_space_base_position")
		var water_base_position: Vector3 = scene.get("_boat_water_contact_base_position")
		_expect(
			absf(water_base_position.y - boat_base_position.y) <= MAX_WATER_CONTACT_BASE_OFFSET_FROM_BOAT,
			"water-contact base must remain attached to the lowered boat instead of retaining a fixed world height",
		)
		_expect(scene.has_method("get_background_flow_offset"), "game scene must expose the continuously advancing visual water-flow state")
		_expect(scene.has_method("get_forward_water_flow_offset"), "game scene must expose the voyage-only forward water-flow state")
		var background_flow_before: float = float(scene.call("get_background_flow_offset")) if scene.has_method("get_background_flow_offset") else 0.0
		var title_forward_flow_before: float = float(scene.call("get_forward_water_flow_offset")) if scene.has_method("get_forward_water_flow_offset") else 0.0
		_expect(not is_zero_approx(background_flow_before) or scene.has_method("get_background_flow_offset"), "title waiting must initialize a visual-only background-flow state")
		var camera_mode_before: String = str(scene.call("get_active_camera_mode"))
		scene.call("_apply_drift_motion", 1.0)
		var background_flow_after: float = float(scene.call("get_background_flow_offset")) if scene.has_method("get_background_flow_offset") else background_flow_before
		var title_forward_flow_after: float = float(scene.call("get_forward_water_flow_offset")) if scene.has_method("get_forward_water_flow_offset") else title_forward_flow_before
		_expect(absf(background_flow_after - background_flow_before) > 0.001, "background water must progress even while title waiting has not started a voyage")
		_expect(is_equal_approx(title_forward_flow_after, title_forward_flow_before), "title waiting must float without consuming voyage-only forward water flow")
		var boat_vertical_offset_after_title_bob := boat_space.position.y - boat_base_position.y
		var contact_vertical_offset_after_title_bob := water_contact.position.y - water_base_position.y
		_expect(absf(contact_vertical_offset_after_title_bob - boat_vertical_offset_after_title_bob) <= MAX_CONTACT_GAP_DELTA_DURING_BOB, "water contact must stay locked to the boat through title bobbing")

		scene.call("start_voyage_from_title")
		var remaining_before: float = float(game_state.remaining_seconds)
		var forward_offsets: Array[float] = []
		var forward_water_progress: Array[float] = []
		for speed_index in 3:
			game_state.speed_index = speed_index
			scene.set("_drift_phase", 0.0)
			var forward_water_before: float = float(scene.call("get_forward_water_flow_offset")) if scene.has_method("get_forward_water_flow_offset") else 0.0
			scene.call("_apply_drift_motion", 1.0)
			var forward_water_after: float = float(scene.call("get_forward_water_flow_offset")) if scene.has_method("get_forward_water_flow_offset") else forward_water_before
			var forward_offset := boat_space.position.z - boat_base_position.z
			var lateral_offset := boat_space.position.x - boat_base_position.x
			forward_offsets.append(absf(forward_offset))
			forward_water_progress.append(forward_water_after - forward_water_before)
			_expect(absf(forward_offset) > 0.01, "each speed tier must give the boat a visible forward surge")
			_expect(absf(lateral_offset) > 0.001, "each speed tier must give the boat a subtle lateral current drift")
			_expect(is_equal_approx(water_contact.position.x - water_base_position.x, lateral_offset), "water contact must follow the boat lateral drift")
			_expect(is_equal_approx(water_contact.position.z - water_base_position.z, forward_offset), "water contact must follow the boat forward surge")
			_expect(forward_water_after > forward_water_before, "active voyage must advance the near-water forward flow")
			for sea_backdrop in scene.call("_get_sea_backdrops"):
				var sea_material := sea_backdrop.material_override as ShaderMaterial
				var material_forward_flow = sea_material.get_shader_parameter("forward_flow_offset") if sea_material != null else null
				_expect(material_forward_flow != null and is_equal_approx(float(material_forward_flow), forward_water_after), "all active sea cameras must receive the same forward-flow phase")
		_expect(forward_offsets[0] < forward_offsets[1] and forward_offsets[1] < forward_offsets[2], "speed tiers must visibly advance the forward-surge phase without changing voyage state")
		_expect(forward_offsets[2] >= 0.09, "fast speed must provide a clearly readable forward surge at portrait gameplay scale")
		_expect(forward_water_progress[1] >= MIN_NORMAL_FORWARD_WATER_PROGRESS, "normal voyage speed must produce readable forward water travel")
		_expect(forward_water_progress[0] < forward_water_progress[1] and forward_water_progress[1] < forward_water_progress[2], "speed tiers must scale forward water travel without changing voyage state")
		_expect(is_equal_approx(game_state.remaining_seconds, remaining_before), "forward drift must not change voyage duration")
		_expect(scene.call("get_active_camera_mode") == camera_mode_before, "forward drift must not change the active camera mode")

		game_state.set_motion_comfort_profile("still")
		game_state.speed_index = 2
		scene.set("_drift_phase", 0.0)
		var still_forward_flow_before: float = float(scene.call("get_forward_water_flow_offset")) if scene.has_method("get_forward_water_flow_offset") else 0.0
		scene.call("_apply_drift_motion", 1.0)
		var still_forward_flow_after: float = float(scene.call("get_forward_water_flow_offset")) if scene.has_method("get_forward_water_flow_offset") else still_forward_flow_before
		_expect(boat_space.position.is_equal_approx(boat_base_position), "still comfort must remove automatic forward and lateral boat drift")
		_expect(water_contact.position.is_equal_approx(water_base_position), "still comfort must keep water contact at its base position")
		_expect(is_equal_approx(still_forward_flow_after, still_forward_flow_before), "still comfort must stop the voyage-only forward water flow")

	scene.queue_free()
	await process_frame
	_remove_test_file()
	_finish()


func _verify_forward_flow_capture_contract() -> void:
	_expect(ResourceLoader.exists(FORWARD_FLOW_CAPTURE_SCRIPT_PATH), "forward-motion renderer capture must exist")
	if not ResourceLoader.exists(FORWARD_FLOW_CAPTURE_SCRIPT_PATH):
		return
	var source := FileAccess.get_file_as_string(FORWARD_FLOW_CAPTURE_SCRIPT_PATH)
	_expect(source.contains("FORWARD_FLOW_LOWER_CHANGED_FRACTION"), "forward-motion capture must measure lower-water progression")
	_expect(source.contains("FORWARD_FLOW_UPPER_CHANGED_FRACTION"), "forward-motion capture must preserve the fixed upper sky")
	_expect(source.contains("MIN_LOWER_SEA_CHANGED_FRACTION"), "forward-motion capture must retain a minimum near-water travel threshold")


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
		print("PASS: voyage forward drift contract")
		quit(0)
	else:
		printerr("FAILED: %d voyage forward drift assertions" % _failures)
		quit(1)
