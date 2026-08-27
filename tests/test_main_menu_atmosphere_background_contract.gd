# 메인 메뉴의 시간대 선택과 승인된 배경 자산 연결을 검증한다.
extends SceneTree

const MAIN_MENU_PATH := "res://scenes/main_menu.tscn"
const EXPECTED_BACKGROUND_PATHS := {
	"dawn": "res://assets/images/ui/main_menu/main_menu_dawn_storybook_v1.png",
	"bright": "res://assets/images/ui/main_menu/main_menu_bright_storybook_v1.png",
	"sunset": "res://assets/images/ui/main_menu/main_menu_sunset_storybook_v1.png",
	"night": "res://assets/images/ui/main_menu/main_menu_night_storybook_v1.png",
}

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	_expect(ResourceLoader.exists(MAIN_MENU_PATH), "main menu scene must exist")
	for background_path in EXPECTED_BACKGROUND_PATHS.values():
		_expect(ResourceLoader.exists(background_path), "approved main-menu background must exist: %s" % background_path)
	if game_state != null and ResourceLoader.exists(MAIN_MENU_PATH):
		var menu := (load(MAIN_MENU_PATH) as PackedScene).instantiate()
		root.add_child(menu)
		await process_frame
		var background := menu.get_node_or_null("AtmosphereBackground") as TextureRect
		_expect(background != null, "main menu must expose an atmosphere background texture surface")
		_expect(menu.has_method("refresh_atmosphere_background"), "main menu must expose an atmosphere refresh API")
		for time_of_day_id in EXPECTED_BACKGROUND_PATHS:
			game_state.select_time_of_day(time_of_day_id)
			if menu.has_method("refresh_atmosphere_background"):
				menu.refresh_atmosphere_background()
			_expect(
				background != null and background.texture != null and background.texture.resource_path == EXPECTED_BACKGROUND_PATHS[time_of_day_id],
				"%s selection must use its approved atmosphere background" % time_of_day_id
			)
		menu.queue_free()
		await process_frame
		game_state.select_time_of_day("bright")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: main menu atmosphere background contract")
		quit(0)
	else:
		printerr("FAILED: %d main menu atmosphere background assertions" % _failures)
		quit(1)
