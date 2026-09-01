# 항해 중 가까운 바다가 앞으로 흐르고 하늘은 고정되는 실제 렌더 증거를 저장한다.
extends SceneTree

const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-09-02-forward-voyage-flow"
const START_CAPTURE_FILE := "bright_voyage_forward_flow_start_540x960.png"
const AFTER_CAPTURE_FILE := "bright_voyage_forward_flow_after_540x960.png"
const FORWARD_STEP_SECONDS := 2.0
const MIN_LOWER_SEA_CHANGED_FRACTION := 0.08
const MAX_UPPER_SKY_CHANGED_FRACTION := 0.01

var _failures := 0


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	var game_state := root.get_node_or_null("GameState")
	if game_state == null:
		_fail("GameState autoload must exist")
		_finish()
		return
	game_state.reset_session()
	game_state.begin_voyage()
	game_state.speed_index = 1
	game_state.set_motion_comfort_profile("standard")
	var packed_scene := load("res://scenes/game.tscn") as PackedScene
	if packed_scene == null:
		_fail("game scene must load")
		_finish()
		return
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	for _frame in 8:
		await process_frame
	scene.call("set_process", false)
	scene.call("apply_real_time_atmosphere_for_hour", 12)
	scene.set("_drift_phase", 0.0)
	scene.call("_apply_drift_motion", 0.0)
	var start_image := await _save_runtime_image(START_CAPTURE_FILE)
	if start_image == null:
		await _cleanup(scene, game_state)
		return
	scene.call("_apply_drift_motion", FORWARD_STEP_SECONDS)
	var after_image := await _save_runtime_image(AFTER_CAPTURE_FILE)
	if after_image == null:
		await _cleanup(scene, game_state)
		return
	_assert_forward_motion_readback(start_image, after_image)
	await _cleanup(scene, game_state)
	_finish()


func _save_runtime_image(file_name: String) -> Image:
	RenderingServer.force_draw(true)
	await RenderingServer.frame_post_draw
	var image := root.get_texture().get_image()
	if image == null or image.is_empty():
		_fail("empty runtime image for %s" % file_name)
		return null
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY))
	var output_path := "%s/%s" % [EVIDENCE_DIRECTORY, file_name]
	if image.save_png(output_path) != OK:
		_fail("could not save %s" % file_name)
		return null
	print("SAVED: %s (%dx%d)" % [output_path, image.get_width(), image.get_height()])
	return image


func _assert_forward_motion_readback(start_image: Image, after_image: Image) -> void:
	var lower_changed_fraction := _get_changed_fraction(start_image, after_image, 0.62, 1.0, true)
	var upper_changed_fraction := _get_changed_fraction(start_image, after_image, 0.0, 0.38, false)
	_expect(lower_changed_fraction >= MIN_LOWER_SEA_CHANGED_FRACTION, "near-water frame must visibly advance during a voyage")
	_expect(upper_changed_fraction <= MAX_UPPER_SKY_CHANGED_FRACTION, "forward-water travel must not pan the fixed upper sky")
	print("FORWARD_FLOW_LOWER_CHANGED_FRACTION=%.4f" % lower_changed_fraction)
	print("FORWARD_FLOW_UPPER_CHANGED_FRACTION=%.4f" % upper_changed_fraction)


func _get_changed_fraction(start_image: Image, after_image: Image, start_y_fraction: float, end_y_fraction: float, exclude_boat: bool) -> float:
	var start_y := int(start_image.get_height() * start_y_fraction)
	var end_y := int(start_image.get_height() * end_y_fraction)
	var changed_samples := 0
	var sampled_pixels := 0
	for y in range(start_y, end_y, 2):
		for x in range(0, start_image.get_width(), 2):
			if exclude_boat and x >= 130 and x <= 410 and y >= int(start_image.get_height() * 0.58):
				continue
			sampled_pixels += 1
			var start_pixel := start_image.get_pixel(x, y)
			var after_pixel := after_image.get_pixel(x, y)
			var difference := maxf(
				absf(start_pixel.r - after_pixel.r),
				maxf(absf(start_pixel.g - after_pixel.g), absf(start_pixel.b - after_pixel.b)),
			)
			if difference >= 0.035:
				changed_samples += 1
	return float(changed_samples) / float(maxi(sampled_pixels, 1))


func _cleanup(scene: Node, game_state: Node) -> void:
	scene.queue_free()
	await process_frame
	game_state.reset_session()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_fail(message)


func _fail(message: String) -> void:
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: voyage forward-flow runtime capture")
		quit(0)
	else:
		printerr("FAILED: %d voyage forward-flow assertions" % _failures)
		quit(1)
