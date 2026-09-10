# 분리 원본을 재작성하지 않고 540×960 검토 viewport에 배치해 캡처한다.
extends SceneTree

const FAMILY := "docs/visual/candidates/2026-09-10-intimate-diorama/"
const SIZE := Vector2i(540, 960)

func _init() -> void:
	call_deferred("_render")

func _render() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() != 2 or DisplayServer.get_name() == "headless":
		printerr("Display renderer required: -- repository_root new_output.png")
		quit(2)
		return
	if FileAccess.file_exists(args[1]):
		printerr("Refusing to overwrite output")
		quit(2)
		return
	var viewport := SubViewport.new()
	viewport.size = SIZE
	viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	root.add_child(viewport)
	var folder := args[0].path_join(FAMILY)
	# 순서는 실제 화면의 뒤→앞이며 size는 화면 픽셀, 원본은 read-only다.
	var entries := [
		["sky-day-v1.png", Vector2(0, 0), Vector2(540, 270), false],
		["sea-day-v1.png", Vector2(0, 270), Vector2(540, 690), false],
		["clouds-rgba-v1.png", Vector2(12, 92), Vector2(228, 0), true],
		["rocks-rgba-v1.png", Vector2(15, 229), Vector2(108, 0), true],
		["empty-hull-rgba-v1.png", Vector2(160, 596), Vector2(220, 0), true],
		["player-rgba-v1.png", Vector2(178, 739), Vector2(140, 0), true],
		["companion-rgba-v1.png", Vector2(290, 814), Vector2(64, 0), true],
		# 원본 선체의 같은 화면 좌표를 재사용해 가까운 난간만 승객 앞에 둔다.
		["empty-hull-rgba-v1.png", Vector2(160, 596 + (1130.0 - 136.0) * 220.0 / 871.0), Vector2(220, 0), true, Rect2(38, 1130, 871, 372)],
	]
	for entry in entries:
		var source := Image.load_from_file(folder.path_join(entry[0]))
		if source == null or source.is_empty():
			viewport.free()
			quit(2)
			return
		var region := Rect2(source.get_used_rect()) if entry[3] else Rect2(Vector2.ZERO, source.get_size())
		if entry.size() == 5:
			region = entry[4]
		var target: Vector2 = entry[2]
		if target.y == 0:
			target.y = target.x * region.size.y / region.size.x
		var sprite := Sprite2D.new()
		sprite.name = str(entry[0]).get_basename()
		sprite.texture = ImageTexture.create_from_image(source)
		sprite.centered = false
		sprite.region_enabled = true
		sprite.region_rect = region
		sprite.region_filter_clip_enabled = true
		sprite.position = entry[1]
		sprite.scale = target / region.size
		viewport.add_child(sprite)
		print("LAYER %s position=%s size=%s region=%s" % [entry[0], sprite.position, target, region])
	for _index in 3:
		await process_frame
		await RenderingServer.frame_post_draw
	var capture := viewport.get_texture().get_image()
	var result := capture.save_png(args[1])
	print("CANDIDATE_LAYOUT_RENDER size=%s result=%d; NOT_GAMEPLAY" % [capture.get_size(), result])
	viewport.queue_free()
	await process_frame
	quit(0 if result == OK and capture.get_size() == SIZE else 1)
