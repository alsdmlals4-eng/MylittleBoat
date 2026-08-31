# 세로 화면의 카메라 화면비 정책이 승인 풍경의 좌우 명소에 미치는 영향을 비교한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-30-ambient-motifs/projection-probe"
const DAWN_MOTIF_PATH := "res://assets/images/runtime/voyage/ambient_motifs/dawn-sea-arch-waterfall.png"
const CLIFF_MOTIF_PATH := "res://assets/images/runtime/voyage/ambient_motifs/bright-chalk-cliffs-birds.png"


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	root.size = Vector2i(540, 960)
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		_fail("could not create projection probe directory")
		return
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_fail("GameState autoload must exist")
		return
	game_state.reset_session()
	game_state.begin_voyage()
	var scene := (load("res://scenes/game.tscn") as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame
	scene.apply_real_time_atmosphere_for_hour(6)
	var backdrop := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeaBackdrop") as Sprite3D
	var camera := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D") as Camera3D
	if backdrop == null or camera == null:
		_fail("diorama backdrop and camera must exist")
		return
	var motif := load(DAWN_MOTIF_PATH) as Texture2D
	if motif == null:
		_fail("approved dawn motif must load")
		return
	backdrop.texture = motif
	await process_frame
	if not _save("default_keep_height_540x960.png"):
		return
	camera.keep_aspect = Camera3D.KEEP_WIDTH
	await process_frame
	if not _save("keep_width_540x960.png"):
		return
	camera.keep_aspect = Camera3D.KEEP_HEIGHT
	backdrop.position.x = 8.0
	await process_frame
	if not _save("dawn_backdrop_offset_plus_8_540x960.png"):
		return
	backdrop.texture = load(CLIFF_MOTIF_PATH) as Texture2D
	backdrop.position.x = -8.0
	await process_frame
	if not _save("bright_cliffs_backdrop_offset_minus_8_540x960.png"):
		return
	print("PASS: portrait projection probe captured both aspect modes")
	scene.queue_free()
	await process_frame
	game_state.reset_session()
	quit(0)


func _save(file_name: String) -> bool:
	var image := root.get_texture().get_image()
	if image == null or image.is_empty():
		_fail("empty image for %s" % file_name)
		return false
	var output_path := "%s/%s" % [EVIDENCE_DIRECTORY, file_name]
	if image.save_png(output_path) != OK:
		_fail("could not save %s" % output_path)
		return false
	print("SAVED: %s" % output_path)
	return true


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
