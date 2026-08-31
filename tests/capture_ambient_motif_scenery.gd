# 승인된 자연 명소 여섯 장이 실제 항해 화면에 표시되는 GPU 증거를 저장한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-30-ambient-motifs"
const DIRECTOR_SCRIPT = preload("res://scripts/voyage/drift_scenery_director.gd")
const CAPTURE_CASES := [
	{
		"id": "MLB-AMB-MOTIF-001",
		"atmosphere_id": "dawn",
		"hour": 6,
		"texture_path": "res://assets/images/runtime/voyage/ambient_motifs/dawn-sea-arch-waterfall.png",
		"backdrop_offset_x": 8.0,
		"file_name": "dawn_sea_arch_540x960.png",
	},
	{
		"id": "MLB-AMB-MOTIF-002",
		"atmosphere_id": "bright",
		"hour": 12,
		"texture_path": "res://assets/images/runtime/voyage/ambient_motifs/bright-seagrass-sandbar.png",
		"backdrop_offset_x": 8.0,
		"file_name": "bright_seagrass_540x960.png",
	},
	{
		"id": "MLB-AMB-MOTIF-003",
		"atmosphere_id": "bright",
		"hour": 12,
		"texture_path": "res://assets/images/runtime/voyage/ambient_motifs/bright-chalk-cliffs-birds.png",
		"backdrop_offset_x": -8.0,
		"file_name": "bright_chalk_cliffs_540x960.png",
	},
	{
		"id": "MLB-AMB-MOTIF-004",
		"atmosphere_id": "sunset",
		"hour": 18,
		"texture_path": "res://assets/images/runtime/voyage/ambient_motifs/sunset-sandstone-cove.png",
		"backdrop_offset_x": -8.0,
		"file_name": "sunset_sandstone_cove_540x960.png",
	},
	{
		"id": "MLB-AMB-MOTIF-005",
		"atmosphere_id": "sunset",
		"hour": 18,
		"texture_path": "res://assets/images/runtime/voyage/ambient_motifs/sunset-reed-islet.png",
		"backdrop_offset_x": 8.0,
		"file_name": "sunset_reed_islet_540x960.png",
	},
	{
		"id": "MLB-AMB-MOTIF-006",
		"atmosphere_id": "night",
		"hour": 22,
		"texture_path": "res://assets/images/runtime/voyage/ambient_motifs/night-bioluminescent-band.png",
		"backdrop_offset_x": 8.0,
		"file_name": "night_bioluminescence_540x960.png",
	},
]


func _init() -> void:
	call_deferred("_capture_all")


func _capture_all() -> void:
	root.size = Vector2i(540, 960)
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		_fail("could not create ambient motif evidence directory")
		return
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_fail("GameState autoload must exist")
		return
	for capture_case in CAPTURE_CASES:
		if not await _capture_case(game_state, capture_case):
			return
	print("PASS: six approved ambient motif GPU captures")
	quit(0)


func _capture_case(game_state: Node, capture_case: Dictionary) -> bool:
	game_state.reset_session()
	game_state.begin_voyage()
	var packed_scene := load("res://scenes/game.tscn") as PackedScene
	if packed_scene == null:
		_fail("game scene must load")
		return false
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame
	scene.apply_real_time_atmosphere_for_hour(int(capture_case["hour"]))
	var seed_value := _find_no_save_seed_for_motif(str(capture_case["atmosphere_id"]), str(capture_case["id"]))
	if seed_value < 0:
		_fail("could not select a no-save seed for %s" % capture_case["id"])
		await _cleanup(scene, game_state)
		return false
	var director = scene.get("_drift_scenery_director")
	director.set_next_event_seconds_for_tests(0.0)
	seed(seed_value)
	scene.call("_advance_drift_scenery", 0.1)
	for _frame in 8:
		await process_frame
	var normal_backdrop := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop") as Sprite3D
	if normal_backdrop == null or normal_backdrop.texture == null or normal_backdrop.texture.resource_path != str(capture_case["texture_path"]):
		_fail("normal backdrop must use %s" % capture_case["id"])
		await _cleanup(scene, game_state)
		return false
	var appreciation_backdrop := scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeaBackdrop") as Sprite3D
	var expected_offset_x := float(capture_case["backdrop_offset_x"])
	if not is_equal_approx(normal_backdrop.position.x, expected_offset_x) or appreciation_backdrop == null or not is_equal_approx(appreciation_backdrop.position.x, expected_offset_x):
		_fail("normal and Appreciation backdrops must use the portrait-safe offset for %s" % capture_case["id"])
		await _cleanup(scene, game_state)
		return false
	var scenery_label := scene.get_node_or_null("DistantSceneryLabel") as Label
	if scenery_label == null or not scenery_label.visible or scenery_label.text.is_empty():
		_fail("ambient motif must display a quiet label for %s" % capture_case["id"])
		await _cleanup(scene, game_state)
		return false
	if not _save_runtime_image(str(capture_case["file_name"])):
		await _cleanup(scene, game_state)
		return false
	await _cleanup(scene, game_state)
	return true


func _find_no_save_seed_for_motif(atmosphere_id: String, motif_id: String) -> int:
	for candidate_seed in range(1, 1025):
		var director = DIRECTOR_SCRIPT.new()
		seed(candidate_seed)
		director.set_next_event_seconds_for_tests(0.0)
		var event := Dictionary(director.advance(0.1, atmosphere_id))
		if str(event.get("motif_id", "")) == motif_id and not bool(event.get("save_memory", true)):
			return candidate_seed
	return -1


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
	game_state.reset_session()


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
