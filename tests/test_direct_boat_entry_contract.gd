# 보트 디오라마가 설정 패널 없이 첫 화면으로 열리는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(ProjectSettings.get_setting("application/run/main_scene", "") == GAME_SCENE_PATH, "main scene must enter the boat directly")
	_expect(ResourceLoader.exists(GAME_SCENE_PATH), "direct boat scene must exist")
	if not ResourceLoader.exists(GAME_SCENE_PATH):
		_finish()
		return
	var scene := (load(GAME_SCENE_PATH) as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame
	var rest_menu_button := scene.get_node_or_null("RestMenuButton") as Button
	var bottom_panel := scene.get_node_or_null("BottomPanel") as Control
	_expect(rest_menu_button != null and rest_menu_button.visible, "first view needs one compact menu entry")
	_expect(bottom_panel != null and not bottom_panel.visible, "first view must not show the large action grid")
	_expect(scene.get_node_or_null("TopPanel/TopVBox/MoodStatusLabel") == null, "first view must not expose mood UI")
	var boat_space := scene.get_node_or_null("VoyageWorld/BoatSpace") as Node3D
	var water_contact := scene.get_node_or_null("VoyageWorld/BoatWaterContact") as Sprite3D
	_expect(boat_space != null and boat_space.visible, "one actual BoatSpace must be visible at direct entry")
	_expect(water_contact != null and water_contact.visible and water_contact.texture != null, "direct entry must bind the visible boat to a local water-contact layer")
	_expect(scene.has_method("open_rest_menu") and scene.has_method("close_rest_menu"), "game scene must expose compact-menu controls")
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
