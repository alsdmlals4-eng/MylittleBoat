# 외형 저장은 남기되 타이틀 대기 화면이 과거 설정 메뉴를 되살리지 않는지 검증한다.
extends SceneTree

const LEGACY_MENU_PATH := "res://scenes/main_menu.tscn"
const GAME_SCENE_PATH := "res://scenes/game.tscn"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	_expect(ResourceLoader.exists(LEGACY_MENU_PATH), "legacy menu material must remain available without becoming startup")
	_expect(ProjectSettings.get_setting("application/run/main_scene", "") == GAME_SCENE_PATH, "identity setup must not block the title boat entry")
	if game_state != null:
		game_state.reset_session()
	if ResourceLoader.exists(GAME_SCENE_PATH):
		var scene := (load(GAME_SCENE_PATH) as PackedScene).instantiate()
		root.add_child(scene)
		await process_frame
		var title_overlay := scene.get_node_or_null("TitleOverlay") as Control
		_expect(title_overlay != null and title_overlay.visible, "title entry must exist without a legacy identity panel")
		_expect(scene.get_node_or_null("TitleOverlay/TitleLayout/PlayerStyleOption") == null, "title entry must not ask for player identity")
		_expect(scene.get_node_or_null("TitleOverlay/TitleLayout/PetTypeOption") == null, "title entry must not ask for companion identity")
		scene.queue_free()
		await process_frame
	if game_state != null:
		var before_together_time: float = game_state.together_time_seconds
		game_state.set_selected_player_style("a_soft_hooded")
		game_state.set_selected_pet_type("otter")
		_expect(game_state.get_selected_player_style() == "a_soft_hooded", "cosmetic player choice must stay local state")
		_expect(game_state.get_selected_pet_type() == "otter", "cosmetic companion choice must stay local state")
		_expect(is_equal_approx(game_state.together_time_seconds, before_together_time), "cosmetic identity must not create together time")
		game_state.set_selected_player_style("c_loose_knit")
		game_state.set_selected_pet_type("dog")
		game_state.reset_session()
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: direct entry identity contract")
		quit(0)
	else:
		printerr("FAILED: %d direct entry identity assertions" % _failures)
		quit(1)
