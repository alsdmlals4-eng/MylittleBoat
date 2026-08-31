# 승인 자연 명소가 현재 시간대의 normal·감상 배경에만 조용히 표시되는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const DIRECTOR_PATH := "res://scripts/voyage/drift_scenery_director.gd"
const BASE_BRIGHT_TEXTURE_PATH := "res://assets/images/runtime/voyage/bright-open-sea-water-only.png"
const BRIGHT_MOTIF_PATHS := [
	"res://assets/images/runtime/voyage/ambient_motifs/bright-seagrass-sandbar.png",
	"res://assets/images/runtime/voyage/ambient_motifs/bright-chalk-cliffs-birds.png",
]
const EXPECTED_BACKDROP_OFFSET_X_BY_PATH := {
	"res://assets/images/runtime/voyage/ambient_motifs/bright-seagrass-sandbar.png": 8.0,
	"res://assets/images/runtime/voyage/ambient_motifs/bright-chalk-cliffs-birds.png": -8.0,
}

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	_expect(ResourceLoader.exists(GAME_SCENE_PATH), "game scene must exist")
	if game_state == null or not ResourceLoader.exists(GAME_SCENE_PATH):
		_finish()
		return
	game_state.reset_session()
	game_state.begin_voyage()
	var before_photos: int = int(game_state.photos.size())
	var before_fish: int = int(game_state.fish.size())
	var before_records: int = int(game_state.voyage_records.size())
	var before_together_time: float = float(game_state.together_time_seconds)
	var scene := (load(GAME_SCENE_PATH) as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame
	scene.apply_real_time_atmosphere_for_hour(12)
	var motif_seed := _find_no_save_bright_motif_seed()
	_expect(motif_seed >= 0, "a deterministic bright approved motif must be selectable without saving a memory")
	if motif_seed >= 0:
		var director = scene.get("_drift_scenery_director")
		director.set_next_event_seconds_for_tests(0.0)
		seed(motif_seed)
		scene.call("_advance_drift_scenery", 0.1)
		var normal_backdrop := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop") as Sprite3D
		var appreciation_backdrop := scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeaBackdrop") as Sprite3D
		var diorama_camera := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D") as Camera3D
		var scenery_label := scene.get_node_or_null("DistantSceneryLabel") as Label
		var scenery_timer := scene.get_node_or_null("AmbientSceneryReturnTimer") as Timer
		_expect(normal_backdrop != null and normal_backdrop.texture != null and normal_backdrop.texture.resource_path in BRIGHT_MOTIF_PATHS, "bright scenery must temporarily replace the normal backdrop with one approved bright motif")
		_expect(appreciation_backdrop != null and appreciation_backdrop.texture != null and appreciation_backdrop.texture.resource_path in BRIGHT_MOTIF_PATHS, "bright scenery must temporarily replace the Appreciation backdrop with the same approved motif")
		if normal_backdrop != null and normal_backdrop.texture != null:
			var expected_offset_x := float(EXPECTED_BACKDROP_OFFSET_X_BY_PATH.get(normal_backdrop.texture.resource_path, 0.0))
			_expect(is_equal_approx(normal_backdrop.position.x, expected_offset_x), "bright scenery must shift the normal backdrop to its verified portrait-safe horizontal position")
			_expect(appreciation_backdrop != null and is_equal_approx(appreciation_backdrop.position.x, expected_offset_x), "bright scenery must shift the Appreciation backdrop to the same verified horizontal position")
		_expect(diorama_camera != null and diorama_camera.keep_aspect == Camera3D.KEEP_HEIGHT, "portrait motif visibility must preserve the approved tight diorama camera framing")
		_expect(scenery_label != null and scenery_label.visible and not scenery_label.text.is_empty(), "ambient motif must retain one quiet non-interactive label")
		_expect(scenery_timer != null and not scenery_timer.is_stopped(), "ambient motif must schedule its existing temporary return")
		scene.call("_restore_active_atmosphere_backdrop")
		_expect(normal_backdrop != null and normal_backdrop.texture != null and normal_backdrop.texture.resource_path == BASE_BRIGHT_TEXTURE_PATH, "restoring the current atmosphere must return to the normal bright backdrop")
		_expect(normal_backdrop != null and is_zero_approx(normal_backdrop.position.x), "restoring the current atmosphere must recenter the normal backdrop")
		_expect(appreciation_backdrop != null and is_zero_approx(appreciation_backdrop.position.x), "restoring the current atmosphere must recenter the Appreciation backdrop")
		_expect(game_state.photos.size() == before_photos, "ambient scenery must not create a photo")
		_expect(game_state.fish.size() == before_fish, "ambient scenery must not create fish")
		_expect(game_state.voyage_records.size() == before_records, "ambient scenery must not create a voyage record")
		_expect(is_equal_approx(game_state.together_time_seconds, before_together_time), "ambient scenery must not alter together-time semantics")
	scene.queue_free()
	await process_frame
	game_state.reset_session()
	_finish()


func _find_no_save_bright_motif_seed() -> int:
	for candidate_seed in range(1, 257):
		var director = (load(DIRECTOR_PATH) as Script).new()
		seed(candidate_seed)
		director.set_next_event_seconds_for_tests(0.0)
		var event := Dictionary(director.advance(0.1, "bright"))
		if not event.is_empty() and not bool(event.get("save_memory", true)):
			return candidate_seed
	return -1


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: ambient motif game scene contract")
		quit(0)
	else:
		printerr("FAILED: %d ambient motif game scene assertions" % _failures)
		quit(1)
