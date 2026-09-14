# 격리 저장 손상 fixture에서 쉬는 메뉴의 복구 상태와 실제 버튼 결과를 캡처한다.
extends SceneTree

const STORAGE_PATH := "user://test_capture_r07b3_identity.cfg"

var _state: Node


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var output_directory := OS.get_environment("MLB_R07B3_CAPTURE_DIR")
	var resolved_output := ProjectSettings.globalize_path(output_directory).simplify_path()
	var project_root := ProjectSettings.globalize_path("res://").simplify_path()
	var isolated_user_dir := bool(ProjectSettings.get_setting("application/config/use_custom_user_dir", false)) and str(ProjectSettings.get_setting("application/config/custom_user_dir_name", "")).begins_with("MyLittleBoat_test_")
	var required_path := resolved_output.path_join("storage_recovery_required.png")
	var committed_path := resolved_output.path_join("storage_recovery_committed.png")
	if output_directory.is_empty() or not resolved_output.is_absolute_path() or resolved_output.begins_with(project_root) or not DirAccess.dir_exists_absolute(resolved_output) or FileAccess.file_exists(required_path) or FileAccess.file_exists(committed_path) or not isolated_user_dir:
		printerr("FAILED: capture requires an empty external output directory and isolated MyLittleBoat test user dir")
		quit(1)
		return
	_state = root.get_node("GameState")
	_cleanup()
	_state.set_identity_storage_path(STORAGE_PATH)
	_state.apply_identity_selection("a_soft_hooded", "cat")
	_state.apply_identity_selection("b_short_cape", "rabbit")
	var corrupt := FileAccess.open(STORAGE_PATH, FileAccess.WRITE)
	corrupt.store_string("[identity\ninvalid")
	corrupt.close()
	_state.load_identity()
	var scene: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(scene)
	await process_frame
	scene.start_voyage_from_title()
	scene.open_rest_menu()
	await process_frame
	var button := scene.get_node("%StorageRecoveryButton") as Button
	var label := scene.get_node("%StorageStatusLabel") as Label
	if not button.visible or button.text != "정상본으로 복구" or not label.visible:
		printerr("FAILED: recovery controls are not visible with expected wording")
		await _shutdown_scene(scene)
		_cleanup()
		quit(1)
		return
	if not await _save_frame(required_path):
		await _shutdown_scene(scene)
		_cleanup()
		quit(1)
		return
	button.pressed.emit()
	await process_frame
	if scene.get_node("%StatusLabel").text != "정상본 복구를 마쳤습니다.":
		printerr("FAILED: actual recovery button did not report committed success")
		await _shutdown_scene(scene)
		_cleanup()
		quit(1)
		return
	if not await _save_frame(committed_path):
		await _shutdown_scene(scene)
		_cleanup()
		quit(1)
		return
	await _shutdown_scene(scene)
	_cleanup()
	print("PASS: storage recovery UI display capture")
	quit(0)


func _save_frame(path: String) -> bool:
	await process_frame
	var image := root.get_texture().get_image()
	if image == null or image.is_empty() or image.save_png(path) != OK:
		printerr("FAILED: could not save %s" % path)
		return false
	return true


func _shutdown_scene(scene: Node) -> void:
	scene.queue_free()
	for frame in 4:
		await process_frame
	var soundscape := root.get_node_or_null("RestingSoundscape")
	if soundscape != null and soundscape.has_method("release_ocean_bed_for_shutdown"):
		soundscape.release_ocean_bed_for_shutdown()
	for frame in 4:
		await process_frame


func _cleanup() -> void:
	preload("res://tests/helpers/config_store_test_cleanup.gd").remove_store(STORAGE_PATH)
