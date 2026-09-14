# 시작 경로가 아닌 legacy 메뉴의 현재 현지 분위기 자료를 저장한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-28-main-menu-composition"
const MAIN_MENU_PATH := "res://scenes/main_menu.tscn"


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(540, 960)
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		_fail("could not create main menu evidence directory")
		return
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_fail("GameState autoload must exist")
		return
	var packed_scene := load(MAIN_MENU_PATH) as PackedScene
	if packed_scene == null:
		_fail("main menu scene must load")
		return
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	for _frame in 10:
		await process_frame
	if not _save_runtime_image("legacy_main_menu_current_local_540x960.png"):
		scene.queue_free()
		await process_frame
		return
	scene.queue_free()
	await process_frame
	print("PASS: legacy main menu current-local capture")
	quit(0)


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


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
