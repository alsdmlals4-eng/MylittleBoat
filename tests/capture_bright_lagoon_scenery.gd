# 밝은 낮의 자연 명소 변형이 실제 화면에 표시되는 증거를 저장한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-30-direct-entry-real-time"
const DRIFT_SCENERY_DIRECTOR_SCRIPT = preload("res://scripts/voyage/drift_scenery_director.gd")
const BRIGHT_MOTIF_TEXTURE_PATHS := [
	"res://assets/images/runtime/voyage/ambient_motifs/bright-seagrass-sandbar.png",
	"res://assets/images/runtime/voyage/ambient_motifs/bright-chalk-cliffs-birds.png",
]
const OUTPUT_FILE_NAME := "bright_ambient_motif_event_normal_540x960.png"


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
	game_state.reset_session()
	game_state.voyage_active = true
	game_state.remaining_seconds = 300.0
	var packed_scene := load("res://scenes/game.tscn") as PackedScene
	if packed_scene == null:
		_fail("game scene must load")
		return
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	if not scene.has_method("apply_real_time_atmosphere_for_hour"):
		_fail("game scene must expose injected real-time atmosphere API")
		await _cleanup(scene, game_state)
		return
	scene.apply_real_time_atmosphere_for_hour(12)
	if not await _trigger_bright_ambient_event(scene):
		await _cleanup(scene, game_state)
		return
	await _wait_for_frames(10)
	var scenery_label := scene.get_node_or_null("DistantSceneryLabel") as Label
	if scenery_label == null or not scenery_label.visible or scenery_label.text.is_empty():
		_fail("bright ambient event must show a quiet distant-scenery label")
		await _cleanup(scene, game_state)
		return
	var backdrop := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop") as Sprite3D
	if backdrop == null or backdrop.texture == null or not (backdrop.texture.resource_path in BRIGHT_MOTIF_TEXTURE_PATHS):
		_fail("bright ambient event must use one approved bright motif backdrop")
		await _cleanup(scene, game_state)
		return
	if not _save_runtime_image(OUTPUT_FILE_NAME):
		await _cleanup(scene, game_state)
		return
	await _cleanup(scene, game_state)
	print("PASS: bright ambient scenery runtime capture")
	quit(0)


func _trigger_bright_ambient_event(scene: Node) -> bool:
	var director = scene.get("_drift_scenery_director")
	if director == null or not director.has_method("set_next_event_seconds_for_tests"):
		_fail("game scene must keep the foreground scenery director available for controlled capture")
		return false
	var motif_seed := _find_bright_motif_seed()
	if motif_seed < 0:
		_fail("could not select a no-save bright ambient event")
		return false
	seed(motif_seed)
	director.set_next_event_seconds_for_tests(0.0)
	scene.call("_process", 0.1)
	return true


func _find_bright_motif_seed() -> int:
	for candidate_seed in range(1, 257):
		var probe_director = DRIFT_SCENERY_DIRECTOR_SCRIPT.new()
		seed(candidate_seed)
		probe_director.set_next_event_seconds_for_tests(0.0)
		var probe_event := Dictionary(probe_director.advance(0.1, "bright"))
		if not probe_event.is_empty() and not bool(probe_event.get("save_memory", false)):
			return candidate_seed
	return -1


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
	game_state.reset_session()


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
