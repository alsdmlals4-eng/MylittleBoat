<<<<<<< HEAD
# 보트 디오라마가 설정 패널 없이 첫 화면으로 열리는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
=======
# 앱 시작이 선택 화면 없이 조용한 보트 장면으로 이어지는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const CAPTURE_RUNNER_PATH := "res://tests/capture_direct_boat_entry_atmospheres.gd"
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
<<<<<<< HEAD
	_expect(ProjectSettings.get_setting("application/run/main_scene", "") == GAME_SCENE_PATH, "main scene must enter the boat directly")
	_expect(ResourceLoader.exists(GAME_SCENE_PATH), "direct boat scene must exist")
	if not ResourceLoader.exists(GAME_SCENE_PATH):
		_finish()
		return
	var scene := (load(GAME_SCENE_PATH) as PackedScene).instantiate()
=======
	var project_settings := FileAccess.get_file_as_string("res://project.godot")
	_expect(project_settings.contains('run/main_scene="res://scenes/game.tscn"'), "game.tscn must be the direct app entry")
	_expect(ResourceLoader.exists(CAPTURE_RUNNER_PATH), "direct-entry atmosphere capture runner must exist")
	if ResourceLoader.exists(CAPTURE_RUNNER_PATH):
		var capture_source := FileAccess.get_file_as_string(CAPTURE_RUNNER_PATH)
		_expect(capture_source.contains("apply_real_time_atmosphere_for_hour"), "capture must inject approved hour states")
		_expect(capture_source.contains("Vector2i(540, 960)"), "capture must use target portrait resolution")
	var game_state := root.get_node_or_null("GameState")
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	_expect(game_state != null, "GameState autoload must exist")
	_expect(packed_scene != null, "game.tscn must load")
	if game_state == null or packed_scene == null:
		_finish()
		return

	game_state.reset_session()
	var scene := packed_scene.instantiate()
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
	root.add_child(scene)
	await process_frame
	var rest_menu_button := scene.get_node_or_null("RestMenuButton") as Button
	var bottom_panel := scene.get_node_or_null("BottomPanel") as Control
<<<<<<< HEAD
	_expect(rest_menu_button != null and rest_menu_button.visible, "first view needs one compact menu entry")
	_expect(bottom_panel != null and not bottom_panel.visible, "first view must not show the large action grid")
	_expect(scene.get_node_or_null("TopPanel/TopVBox/MoodStatusLabel") == null, "first view must not expose mood UI")
	var boat_space := scene.get_node_or_null("VoyageWorld/BoatSpace") as Node3D
	var water_contact := scene.get_node_or_null("VoyageWorld/BoatWaterContact") as Sprite3D
	_expect(boat_space != null and boat_space.visible, "one actual BoatSpace must be visible at direct entry")
	_expect(water_contact != null and water_contact.visible and water_contact.texture != null, "direct entry must bind the visible boat to a local water-contact layer")
	_expect(scene.has_method("open_rest_menu") and scene.has_method("close_rest_menu"), "game scene must expose compact-menu controls")
=======
	var top_panel := scene.get_node_or_null("TopPanel") as Control
	var waterline_overlay := scene.get_node_or_null("VoyageWorld/BoatSpace/BoatWaterlineOverlay") as Sprite3D
	_expect(scene.get_node_or_null("VoyageWorld/BoatSpace") != null, "first scene must contain the boat diorama")
	_expect(waterline_overlay != null and waterline_overlay.texture != null, "boat diorama must contain a waterline overlay")
	_expect(rest_menu_button != null and rest_menu_button.visible, "first view must show one quiet menu entry")
	_expect(bottom_panel != null and not bottom_panel.visible, "first view must not cover the boat with an action grid")
	_expect(top_panel != null and not top_panel.visible, "first view must not show a startup status panel")
	_expect(scene.get_node_or_null("TopPanel/TopVBox/MoodStatusLabel") == null, "first view must not expose removed mood UI")
	if rest_menu_button != null and bottom_panel != null:
		rest_menu_button.emit_signal("pressed")
		await process_frame
		_expect(bottom_panel.visible, "menu entry must reveal optional actions")
		rest_menu_button.emit_signal("pressed")
		await process_frame
		_expect(not bottom_panel.visible, "menu entry must close optional actions again")
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
	scene.queue_free()
	await process_frame
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: direct boat entry contract")
		quit(0)
	else:
		printerr("FAILED: %d direct boat entry assertions" % _failures)
		quit(1)
