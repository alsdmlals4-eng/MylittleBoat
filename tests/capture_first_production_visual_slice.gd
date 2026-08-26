# 첫 production visual slice의 headless runtime 증거 이미지를 저장한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-26-first-production-visual-slice"


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(540, 960)
	var packed_scene := load("res://scenes/game.tscn") as PackedScene
	if packed_scene == null:
		printerr("FAILED: game scene must load for runtime capture")
		quit(1)
		return
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await _wait_for_frames(10)
	var top_panel := scene.get_node_or_null("TopPanel") as PanelContainer
	print("NORMAL_TOP_PANEL: visible=%s rect=%s" % [top_panel != null and top_panel.visible, top_panel.get_rect() if top_panel != null else Rect2()])
	if not _save_runtime_image("normal_540x960.png"):
		quit(1)
		return

	var appreciation_button := scene.get_node_or_null("BottomPanel/ButtonGrid/AppreciationButton") as Button
	if appreciation_button == null:
		printerr("FAILED: appreciation button must exist for runtime capture")
		quit(1)
		return
	appreciation_button.emit_signal("pressed")
	await _wait_for_frames(10)
	if not _save_runtime_image("appreciation_540x960.png"):
		quit(1)
		return

	scene.queue_free()
	await process_frame
	print("PASS: first production visual slice runtime captures")
	quit(0)


func _wait_for_frames(frame_count: int) -> void:
	for _frame in frame_count:
		await process_frame


func _save_runtime_image(file_name: String) -> bool:
	var output_path := "%s/%s" % [EVIDENCE_DIRECTORY, file_name]
	var image := root.get_texture().get_image()
	if image == null or image.is_empty():
		printerr("FAILED: empty runtime image for %s" % file_name)
		return false
	var result := image.save_png(output_path)
	if result != OK:
		printerr("FAILED: could not save %s (error %d)" % [output_path, result])
		return false
	print("SAVED: %s (%dx%d)" % [output_path, image.get_width(), image.get_height()])
	return true
