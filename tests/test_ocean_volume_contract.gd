# 실제 음량 설정과 지속 재생·항해 상태·메뉴 입력 연결을 검증한다.
extends SceneTree

var failures := 0
const STORAGE := "user://test_ocean_volume.cfg"

func _init() -> void:
	call_deferred("run")

func expect(ok: bool, message: String) -> void:
	if not ok:
		failures += 1
		printerr("FAIL: " + message)

func send_key(code: Key) -> void:
	var event := InputEventKey.new()
	event.keycode = code
	event.pressed = true
	Input.parse_input_event(event)
	Input.flush_buffered_events()
	event = event.duplicate()
	event.pressed = false
	Input.parse_input_event(event)
	Input.flush_buffered_events()

func run() -> void:
	var args := OS.get_cmdline_user_args()
	var output := args[0] if args.size() == 1 else ""
	if not output.is_empty():
		if DisplayServer.get_name() == "headless" or not output.is_absolute_path() or DirAccess.dir_exists_absolute(output):
			printerr("Runtime capture requires a new absolute directory and display renderer")
			quit(2)
			return
		DirAccess.make_dir_recursive_absolute(output)
	root.size = Vector2i(540, 960)
	root.gui_embed_subwindows = true
	var state := root.get_node("GameState")
	var sound := root.get_node("RestingSoundscape")
	var player := sound.get_node("OceanBed") as AudioStreamPlayer
	preload("res://tests/helpers/config_store_test_cleanup.gd").remove_store(STORAGE)
	state.set_comfort_storage_path(STORAGE)
	var isolated_paths: Array[String] = [STORAGE]
	for kind in ["together_time", "memory_ledger", "identity", "boat_decor", "ambient_memory"]:
		var path := "user://test_ocean_%s.cfg" % kind
		isolated_paths.append(path)
		state.call("set_%s_storage_path" % kind, path)
	expect(state.has_method("set_ocean_volume"), "player must be able to mute persistent ocean bed")
	if state.has_method("set_ocean_volume"):
		state.set_ocean_volume(1.0)
		await create_timer(0.25).timeout
		state.set_ocean_volume(0.0)
		sound.set_process(false)
		sound._process(0.05)
		expect(is_equal_approx(player.volume_linear, 0.08392836), "fade must pass through two-thirds gain after 50ms integrated delta")
		sound._process(0.05)
		expect(is_equal_approx(player.volume_linear, 0.04196418), "fade must pass through one-third gain after 100ms integrated delta")
		sound._process(0.05)
		expect(is_zero_approx(player.volume_linear), "fade must finish at 150ms integrated delta")
		if DisplayServer.get_name() != "headless":
			await create_timer(1.0).timeout
		var before_time: float = state.remaining_seconds
		var before_memories: Array = state.photo_memories.duplicate(true)
		var original_stream := player.stream
		var original_position := player.get_playback_position()
		var original_ticks := Time.get_ticks_msec()
		expect(state.set_ocean_volume(0.0), "mute preference must save")
		await create_timer(0.25).timeout
		expect(is_zero_approx(player.volume_linear), "mute must reach actual audio player")
		state.set_motion_comfort_profile("gentle")
		state.set_comfort_storage_path(STORAGE)
		expect(is_zero_approx(state.get_ocean_volume()), "mute must survive preference reload and motion update")
		expect(state.set_ocean_volume(0.5), "half volume must save")
		await create_timer(0.25).timeout
		expect(is_equal_approx(player.volume_linear, 0.06294627), "half control must be relative to existing -18 dB mix")
		expect(not state.set_ocean_volume(INF) and is_equal_approx(state.get_ocean_volume(), 0.5), "invalid gain must preserve live preference")
		expect(player.stream == original_stream, "volume change must not replace ocean stream")
		if DisplayServer.get_name() != "headless":
			var advanced := fposmod(player.get_playback_position() - original_position, 16.0)
			var elapsed := float(Time.get_ticks_msec() - original_ticks) / 1000.0
			expect(player.playing and absf(advanced - elapsed) < 0.25, "volume changes must preserve playback phase across elapsed time")
		expect(state.remaining_seconds == before_time and state.photo_memories == before_memories, "audio setting must not advance voyage or memories")
		original_stream = null
	var game := (load("res://scenes/game.tscn") as PackedScene).instantiate()
	root.add_child(game)
	current_scene = game
	await process_frame
	var volume := game.get_node_or_null("%OceanVolumeOption") as OptionButton
	expect(volume != null, "rest menu must expose actual ocean volume control")
	if volume != null:
		game.start_voyage_from_title()
		game.set_application_foreground(true)
		game.set_process(false)
		game.get_node("%RestMenuButton").pressed.emit()
		expect(volume.is_visible_in_tree(), "volume must be reachable from rest menu")
		volume.grab_focus()
		send_key(KEY_SPACE)
		await process_frame
		var popup := volume.get_popup()
		expect(popup.visible, "keyboard activation must open real volume popup")
		expect(popup.size.y >= 48 * popup.item_count, "open volume choices must provide touch-sized rows")
		if not output.is_empty():
			await RenderingServer.frame_post_draw
			expect(root.get_texture().get_image().save_png(output.path_join("volume-popup.png")) == OK, "open popup capture must save")
		send_key(KEY_UP)
		send_key(KEY_UP)
		await process_frame
		expect(popup.get_focused_item() == 0, "up input must focus the mute option")
		send_key(KEY_ENTER)
		await create_timer(0.25).timeout
		expect(not popup.visible and volume.selected == 0, "keyboard choice must close popup and select mute")
		expect(is_zero_approx(state.get_ocean_volume()) and is_zero_approx(player.volume_linear), "mute menu selection must reach persistence and actual audio")
		for size in [Vector2i(360, 640), Vector2i(540, 960), Vector2i(720, 1280)]:
			root.content_scale_size = size
			root.size = size
			await process_frame
			await process_frame
			expect(root.get_visible_rect().encloses(volume.get_global_rect()), "volume control must fit logical viewport %s" % size)
			expect(volume.size.y >= 48.0, "volume target must retain 48 logical pixels")
			if not output.is_empty():
				await RenderingServer.frame_post_draw
				expect(root.get_texture().get_image().save_png(output.path_join("muted-%dx%d.png" % [size.x, size.y])) == OK, "capture must save")
			if size == Vector2i(360, 640):
				volume.grab_focus()
				send_key(KEY_SPACE)
				await process_frame
				expect(popup.visible and root.get_visible_rect().encloses(Rect2(Vector2(popup.position), Vector2(popup.size))), "open volume menu must fit small logical screen")
				if not output.is_empty():
					await RenderingServer.frame_post_draw
					expect(root.get_texture().get_image().save_png(output.path_join("volume-popup-360.png")) == OK, "small popup must save")
				send_key(KEY_ESCAPE)
				await process_frame
				expect(not popup.visible and is_zero_approx(state.get_ocean_volume()), "cancel must close popup without changing mute")
		root.content_scale_size = Vector2i(360, 640)
		root.size = Vector2i(360, 640)
		state.tick_voyage(300.0)
		state.complete_voyage()
		game._sync_next_voyage_button()
		await process_frame
		await process_frame
		expect(game.get_node("%NextVoyageButton").visible, "completed voyage fixture must show next-voyage action")
		for control in [volume, game.get_node("%NextVoyageButton")]:
			expect(root.get_visible_rect().encloses(control.get_global_rect()), "completed voyage controls must remain inside small screen")
		game._toggle_appreciation_mode()
		expect(not volume.is_visible_in_tree(), "appreciation camera must keep nonessential audio menu hidden")
		game._toggle_appreciation_mode()
		game._open_album()
		expect(is_zero_approx(player.volume_linear), "album must preserve mute")
		game._close_album()
		var invalid_path := "user://test_ocean_absent_parent/settings.cfg"
		expect(not DirAccess.dir_exists_absolute("user://test_ocean_absent_parent"), "write-failure fixture must have absent parent")
		state.set_comfort_storage_path(invalid_path)
		volume.select(0)
		volume.item_selected.emit(0)
		await create_timer(0.25).timeout
		expect(is_zero_approx(player.volume_linear), "unavailable storage must not prevent immediate mute")
		expect("저장하지 못했어요" in game.get_node("%StatusLabel").text, "save failure must not report durable preference success")
		state.set_comfort_storage_path(STORAGE)
		expect(is_zero_approx(state.get_ocean_volume()), "original saved mute must survive unavailable-store attempt")
		# 실제 새 재생 owner도 mute를 적용한 다음에만 stream을 시작해야 한다.
		var restarted := (load("res://scripts/audio/resting_soundscape.gd") as Script).new() as Node
		root.add_child(restarted)
		var restarted_player := restarted.get_node("OceanBed") as AudioStreamPlayer
		expect(is_zero_approx(restarted_player.volume_linear), "new audio owner must not leak default gain before saved mute")
		restarted.release_ocean_bed_for_shutdown()
		restarted.queue_free()
	game.queue_free()
	await process_frame
	sound.release_ocean_bed_for_shutdown()
	for i in 4:
		await process_frame
	preload("res://tests/helpers/config_store_test_cleanup.gd").remove_store(STORAGE)
	for path in isolated_paths:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	print("OCEAN_VOLUME_FAILURES=%d" % failures)
	quit(1 if failures else 0)
