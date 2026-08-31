# 로고가 있는 보트 대기 화면이 항해 시간 없이 시작되고 시작 버튼으로만 항해가 열리는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const TITLE_LOGO_PATH := "res://assets/images/brand/my_little_boat_title_lockup_v1.png"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	_expect(ProjectSettings.get_setting("application/run/main_scene", "") == GAME_SCENE_PATH, "main scene must enter the title boat diorama")
	_expect(ResourceLoader.exists(GAME_SCENE_PATH), "title boat scene must exist")
	_expect(ResourceLoader.exists(TITLE_LOGO_PATH), "title entry must use the locked brand logo")
	if not ResourceLoader.exists(GAME_SCENE_PATH):
		_finish()
		return
	if game_state != null:
		game_state.reset_session()
	var scene := (load(GAME_SCENE_PATH) as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame
	var title_overlay := scene.get_node_or_null("TitleOverlay") as Control
	var title_logo := scene.get_node_or_null("TitleOverlay/TitleLayout/BrandLogo") as TextureRect
	var start_button := scene.get_node_or_null("TitleOverlay/TitleLayout/StartVoyageButton") as Button
	var rest_menu_button := scene.get_node_or_null("RestMenuButton") as Button
	var bottom_panel := scene.get_node_or_null("BottomPanel") as Control
	_expect(title_overlay != null and title_overlay.visible, "first view must show the title boat overlay")
	_expect(title_logo != null and title_logo.texture != null, "title overlay must render the locked logo")
	_expect(start_button != null and start_button.visible, "first view needs one explicit voyage-start button")
	_expect(game_state != null and not game_state.voyage_active, "title waiting must not start a voyage or timer")
	_expect(rest_menu_button != null and not rest_menu_button.visible, "title waiting must not expose the rest menu")
	_expect(bottom_panel != null and not bottom_panel.visible, "title waiting must not show the large action grid")
	_expect(scene.get_node_or_null("TitleOverlay/TitleLayout/IdentityPanel") == null, "title waiting must not resurrect identity setup")
	var boat_space := scene.get_node_or_null("VoyageWorld/BoatSpace") as Node3D
	var water_contact := scene.get_node_or_null("VoyageWorld/BoatWaterContact") as Sprite3D
	_expect(boat_space != null and boat_space.visible, "title waiting must use the actual BoatSpace")
	_expect(water_contact != null and water_contact.visible and water_contact.texture != null, "title waiting must bind the visible boat to a local water-contact layer")
	_expect(scene.has_method("open_rest_menu") and scene.has_method("close_rest_menu"), "game scene must expose compact-menu controls")
	_expect(scene.has_method("start_voyage_from_title"), "game scene must expose an explicit title-start boundary")
	if scene.has_method("start_voyage_from_title"):
		scene.call("start_voyage_from_title")
		await process_frame
		_expect(game_state != null and game_state.voyage_active, "explicit title start must begin the voyage")
		_expect(title_overlay != null and not title_overlay.visible, "title overlay must leave after voyage start")
		_expect(rest_menu_button != null and rest_menu_button.visible, "rest menu must appear only after voyage start")
	scene.queue_free()
	await process_frame
	if game_state != null:
		game_state.reset_session()
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
