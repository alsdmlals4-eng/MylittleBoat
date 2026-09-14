# 과거 먼 풍경 테스트 경로에서 현재 ambient motif 런타임 소비 계약을 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const DIRECTOR_PATH := "res://scripts/voyage/drift_scenery_director.gd"
const BRIGHT_MOTIF_PATHS := [
	"res://assets/images/runtime/voyage/ambient_motifs/bright-seagrass-sandbar.png",
	"res://assets/images/runtime/voyage/ambient_motifs/bright-chalk-cliffs-birds.png",
]

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	_expect(packed_scene != null, "game scene must load")
	if packed_scene == null:
		_finish()
		return
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame
	_expect(scene.has_method("_advance_drift_scenery"), "game scene must consume current ambient motif events")
	var scenery_timer := scene.get_node_or_null("AmbientSceneryReturnTimer") as Timer
	_expect(scenery_timer != null, "game scene must retain the temporary ambient-scenery return timer")
	var motif_seed := _find_bright_motif_seed()
	_expect(motif_seed >= 0, "a deterministic bright ambient motif must be selectable")
	if motif_seed >= 0 and scene.has_method("_advance_drift_scenery"):
		scene.apply_real_time_atmosphere_for_hour(12)
		var director = scene.get("_drift_scenery_director")
		_expect(director != null, "game scene must expose the current drift-scenery director")
		if director != null:
			director.set_next_event_seconds_for_tests(0.0)
			seed(motif_seed)
			scene.call("_advance_drift_scenery", 0.1)
			var normal_backdrop := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop") as Sprite3D
			_expect(
				normal_backdrop != null
				and normal_backdrop.texture != null
				and normal_backdrop.texture.resource_path in BRIGHT_MOTIF_PATHS,
				"current ambient scenery must be consumed through an approved temporary SeaBackdrop motif",
			)
	scene.queue_free()
	await process_frame
	_finish()


func _find_bright_motif_seed() -> int:
	for candidate_seed in range(1, 257):
		var director = (load(DIRECTOR_PATH) as Script).new()
		seed(candidate_seed)
		director.set_next_event_seconds_for_tests(0.0)
		var event := Dictionary(director.advance(0.1, "bright"))
		if not event.is_empty():
			return candidate_seed
	return -1


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: current ambient scenery runtime contract")
		quit(0)
	else:
		printerr("FAILED: %d ambient scenery runtime assertions" % _failures)
		quit(1)
