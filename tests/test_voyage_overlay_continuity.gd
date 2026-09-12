# 앨범·꾸미기를 왕복해도 같은 항해와 동결된 풍경이 이어지는지 검증한다.
extends SceneTree

var failures := 0
var paths: Array[String] = []
var capture_directory := ""

func _init() -> void:
	call_deferred("run")

func expect(ok: bool, reason: String) -> void:
	if not ok:
		failures += 1
		printerr("FAIL: " + reason)

func run() -> void:
	var args := OS.get_cmdline_user_args()
	if args.size() == 1 and args[0].is_absolute_path() and DisplayServer.get_name() != "headless":
		if DirAccess.dir_exists_absolute(args[0]):
			printerr("Capture directory must not already exist")
			quit(2)
			return
		capture_directory = args[0]
		DirAccess.make_dir_recursive_absolute(capture_directory)
	root.size = Vector2i(540, 960)
	var state := root.get_node("GameState")
	for kind in ["comfort", "together_time", "memory_ledger", "identity", "boat_decor", "ambient_memory"]:
		var path := "user://test_overlay_%s.cfg" % kind
		paths.append(path)
		state.call("set_%s_storage_path" % kind, path)
	state.begin_voyage()
	state.set_photo_memory_storage("user://test_overlay_photos.cfg", "user://test_overlay_photos")
	paths.append("user://test_overlay_photos.cfg")
	var game := load("res://scenes/game.tscn").instantiate() as Control
	var clock = load("res://scripts/voyage/real_time_atmosphere_resolver.gd").new()
	# 같은 ID로 초기화된 경우에도 최초 조명이 적용돼야 한다.
	game.set("_active_atmosphere_id", clock.resolve_system_time())
	game.set("_active_season_id", clock.resolve_system_season())
	game.get_node("VoyageWorld/SunLight").light_energy = 0.0
	root.add_child(game)
	current_scene = game
	await process_frame
	expect(game.get_node("VoyageWorld/SunLight").light_energy > 0.0, "initial equal atmosphere IDs must still initialize lighting")
	game.set_application_foreground(true)
	var fishing_label: String = game.get_node("%FishingButton").text
	for fixture in [{"delay": 0.0, "outcome": "catch"}, {"delay": 1.0, "outcome": "catch"}, {"delay": 1.0, "outcome": "quiet"}]:
		game._handle_fishing_action()
		if fixture.delay > 0.0:
			game.get("_fishing_session").cast_line(1.0, fixture.outcome)
			game._advance_fishing(1.0)
		game._open_decor_panel()
		game._close_decor_panel()
		expect(game.get_node("%FishingButton").text == fishing_label, "cancelled fishing must restore idle button after decor")
	game._show_temporary_ambient_scenery_backdrop("res://assets/images/runtime/voyage/ambient_motifs/bright-seagrass-sandbar.png", 1.0)
	state.set_motion_comfort_profile("still")
	game._apply_drift_motion(0.0)
	var still_tween: Tween = game.get("_ambient_scenery_pass_tween")
	var still_elapsed := still_tween.get_total_elapsed_time()
	var still_timer := game.get_node("AmbientSceneryReturnTimer") as Timer
	var still_remaining := still_timer.time_left
	still_timer.start(0.05)
	still_remaining = still_timer.time_left
	await create_timer(0.15).timeout
	expect(is_equal_approx(still_tween.get_total_elapsed_time(), still_elapsed), "still comfort must freeze generic scenery tween")
	expect(is_equal_approx(still_timer.time_left, still_remaining), "still comfort must not expire frozen scenery")
	var director = game.get("_drift_scenery_director")
	var director_elapsed: float = director.get_foreground_elapsed_seconds()
	var emitted_events := 0
	for event_seed in range(1, 21):
		game.get_node("%DistantSceneryLabel").text = ""
		seed(event_seed)
		director.set_next_event_seconds_for_tests(0.0)
		game._advance_drift_scenery(0.1)
		if not game.get_node("%DistantSceneryLabel").text.is_empty():
			emitted_events += 1
	expect(emitted_events > 0, "still fixture must exercise real director events")
	expect(is_equal_approx(director.get_foreground_elapsed_seconds() - director_elapsed, 2.0), "still must preserve discovery foreground cadence")
	expect(still_tween.is_valid() and game.get("_ambient_scenery_pass_tween") == still_tween, "new discoveries must not replace frozen scenery")
	# 실패한 구현에서도 나머지 계약과 격리 저장 teardown을 실행한다.
	if not still_tween.is_valid():
		game._show_temporary_ambient_scenery_backdrop("res://assets/images/runtime/voyage/ambient_motifs/bright-seagrass-sandbar.png", 1.0)
		still_tween = game.get("_ambient_scenery_pass_tween")
	state.set_motion_comfort_profile("standard")
	game._apply_drift_motion(0.0)
	var original_speed: int = state.speed_index
	for speed in [0, 1, 2]:
		state.speed_index = speed
		game._apply_drift_motion(0.0)
		var before_step := still_tween.get_total_elapsed_time()
		still_tween.custom_step(0.1)
		expect(is_equal_approx(still_tween.get_total_elapsed_time() - before_step, 0.1 * game.SPEED_MULTIPLIERS[speed]), "scenery must share selected voyage speed")
	state.speed_index = original_speed
	game._apply_drift_motion(0.0)
	still_tween.custom_step(100.0)
	expect(not game.get_node("VoyageWorld/DioramaCameraRig/DioramaCamera3D/AmbientSceneryPass").visible, "generic scenery must clear after visual completion")
	game._show_seasonal_island_layer(load("res://assets/images/runtime/voyage/seasonal_parallax/bright-spring-islet.png"), 1.0)
	state.set_motion_comfort_profile("still")
	game._apply_drift_motion(0.0)
	still_timer.start(0.05)
	await create_timer(0.15).timeout
	expect(game.get_node("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeasonalIslandLayer").visible, "frozen seasonal island must survive wall-clock expiry")
	state.set_motion_comfort_profile("standard")
	game._apply_drift_motion(100.0)
	expect(not game.get_node("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeasonalIslandLayer").visible, "seasonal island must clear after visual completion")
	game._show_temporary_ambient_scenery_backdrop("res://assets/images/runtime/voyage/ambient_motifs/bright-seagrass-sandbar.png", 1.0)
	await create_timer(0.04).timeout
	var active_tween: Tween = game.get("_ambient_scenery_pass_tween")
	game._notification(Node.NOTIFICATION_APPLICATION_FOCUS_IN)
	expect(active_tween.is_valid(), "same-hour focus refresh must not discard passing scenery")
	game._open_decor_panel()
	var phase: float = game.get_forward_water_flow_offset()
	var remaining: float = state.remaining_seconds
	var timer := game.get_node("AmbientSceneryReturnTimer") as Timer
	var time_left := timer.time_left
	var tween_time := active_tween.get_total_elapsed_time()
	await create_timer(0.12).timeout
	expect(is_equal_approx(game.get_forward_water_flow_offset(), phase), "full decor must freeze water phase")
	expect(is_equal_approx(state.remaining_seconds, remaining), "full decor must freeze voyage time")
	expect(is_equal_approx(timer.time_left, time_left), "full decor must freeze scenery return timer")
	expect(is_equal_approx(active_tween.get_total_elapsed_time(), tween_time), "full decor must freeze scenery tween")
	game._close_decor_panel()
	await capture("before-album")
	game._open_album()
	await process_frame
	await process_frame
	expect(is_instance_valid(game) and current_scene == game, "opening album must retain the original voyage scene")
	if is_instance_valid(game) and current_scene == game:
		var album := game.get_node_or_null("AlbumOverlay")
		expect(album != null, "album must open above the retained voyage")
		if album != null:
			await capture("album")
			phase = game.get_forward_water_flow_offset()
			var sound := root.get_node("RestingSoundscape/OceanBed") as AudioStreamPlayer
			expect(sound.can_process(), "album must leave soundscape processing enabled")
			if DisplayServer.get_name() != "headless":
				expect(sound.playing, "album must preserve the playing soundscape")
			for i in 20:
				album.get_node("%BackButton").pressed.emit()
				expect(is_equal_approx(game.get_forward_water_flow_offset(), phase), "back must preserve exact phase before the next tick")
				game._open_album()
				album = game.get_node("AlbumOverlay")
			await create_timer(0.12).timeout
			expect(is_equal_approx(game.get_forward_water_flow_offset(), phase), "album must freeze water phase")
			game.set_application_foreground(false)
			album.get_node("%BackButton").pressed.emit()
			await create_timer(0.12).timeout
			expect(is_equal_approx(game.get_forward_water_flow_offset(), phase), "closing album while inactive must not resume voyage")
			game.set_application_foreground(true)
			await create_timer(0.12).timeout
			expect(game.get_forward_water_flow_offset() > phase, "foreground return must resume retained voyage")
			game.set_look_around_mode(true)
			var camera_rig := game.get_node("VoyageWorld/LookAroundCameraRig") as Node3D
			var press := InputEventMouseButton.new()
			press.button_index = MOUSE_BUTTON_LEFT
			press.position = Vector2(400, 300)
			press.pressed = true
			root.push_input(press)
			game._open_album()
			press.pressed = false
			root.push_input(press)
			game._close_album()
			var held_rotation := camera_rig.rotation
			var motion := InputEventMouseMotion.new()
			motion.position = Vector2(430, 300)
			motion.relative = Vector2(30, 0)
			root.push_input(motion)
			expect(camera_rig.rotation.is_equal_approx(held_rotation), "release during album must not leave a stuck camera drag")
			game.set_look_around_mode(false)
			if DisplayServer.get_name() != "headless":
				var photo_count: int = state.photo_memories.size()
				game._take_photo()
				game._take_photo()
				game._open_album()
				expect(not album.visible, "album request must wait for photo UI restoration")
				for i in 4:
					await process_frame
				expect(album.visible, "deferred album request must open after capture")
				expect(state.photo_memories.size() == photo_count + 1, "repeated photo press must save once")
				var escape := InputEventKey.new()
				escape.keycode = KEY_ESCAPE
				escape.pressed = true
				root.push_input(escape)
				await process_frame
				expect(not album.visible, "Escape input must close the album without replacing voyage")
				await capture("after-album")
				game._open_decor_panel()
				await capture("decor")
				escape.pressed = false
				root.push_input(escape)
				escape.pressed = true
				root.push_input(escape)
				await process_frame
				expect(not game.get_node("DecorPanel").visible, "Escape must close decor while voyage is paused")
				# 실제 항해 사진 네 장으로 최근/이전 페이지와 같은 바다 복귀를 검증한다.
				for photo_index in 3:
					game._take_photo()
					for frame in 4:
						await process_frame
				game._open_album()
				await process_frame
				await capture("album-history-newest")
				var older := album.get_node("%OlderPostcardsButton") as Button
				expect(not older.disabled, "four actual photos must enable older history")
				phase = game.get_forward_water_flow_offset()
				var page_click := InputEventMouseButton.new()
				page_click.button_index = MOUSE_BUTTON_LEFT
				page_click.position = older.get_global_rect().get_center()
				page_click.pressed = true
				root.push_input(page_click)
				page_click.pressed = false
				root.push_input(page_click)
				await capture("album-history-older")
				expect(album.get_node("%PostcardRow").get_child_count() == 1, "older page must contain the first actual photo")
				expect(is_equal_approx(game.get_forward_water_flow_offset(), phase), "photo browsing must leave voyage frozen")
				for viewport_size in [Vector2i(540, 960), Vector2i(360, 640)]:
					root.content_scale_size = viewport_size
					root.size = viewport_size
					await process_frame
					await process_frame
					var back := album.get_node("%BackButton") as Button
					expect(root.get_visible_rect().size.is_equal_approx(Vector2(viewport_size)), "small layout proof must use logical viewport size, not only physical window size")
					expect(root.get_visible_rect().encloses(back.get_global_rect()), "album back button must fit the viewport: visible=%s back=%s" % [root.get_visible_rect(), back.get_global_rect()])
					await capture("album-history-%dx%d" % [viewport_size.x, viewport_size.y])
				root.content_scale_size = Vector2i(540, 960)
				root.size = Vector2i(540, 960)
				album.get_node("%BackButton").pressed.emit()
				expect(is_equal_approx(game.get_forward_water_flow_offset(), phase), "history back must resume the same phase")
	if is_instance_valid(current_scene):
		current_scene.queue_free()
	await process_frame
	root.get_node("RestingSoundscape").release_ocean_bed_for_shutdown()
	for i in 4:
		await process_frame
	for path in paths:
		if FileAccess.file_exists(path):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
	if DirAccess.dir_exists_absolute("user://test_overlay_photos"):
		for file_name in DirAccess.get_files_at("user://test_overlay_photos"):
			DirAccess.remove_absolute(ProjectSettings.globalize_path("user://test_overlay_photos/" + file_name))
		DirAccess.remove_absolute(ProjectSettings.globalize_path("user://test_overlay_photos"))
	print("OVERLAY_CONTINUITY_FAILURES=%d" % failures)
	quit(1 if failures else 0)

func capture(label: String) -> void:
	if capture_directory.is_empty():
		return
	await process_frame
	await RenderingServer.frame_post_draw
	expect(root.get_texture().get_image().save_png(capture_directory.path_join(label + ".png")) == OK, "runtime evidence must save successfully")
