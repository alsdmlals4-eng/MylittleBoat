# 메인 메뉴의 시간대 선택이 비보상 시각 상태만 바꾸는지 검증한다.
extends SceneTree

const MAIN_MENU_PATH := "res://scenes/main_menu.tscn"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	_expect(ResourceLoader.exists(MAIN_MENU_PATH), "main menu scene must exist")
	if game_state != null and ResourceLoader.exists(MAIN_MENU_PATH):
		game_state.select_time_of_day("bright")
		var before_mood: String = str(game_state.selected_mood)
		var before_player: String = game_state.get_selected_player_style()
		var before_pet: String = game_state.get_selected_pet_type()
		var before_affection: int = int(game_state.companion_affection)
		var before_photos: int = game_state.photos.size()
		var menu := (load(MAIN_MENU_PATH) as PackedScene).instantiate()
		root.add_child(menu)
		await process_frame
		var time_option := menu.get_node_or_null("Margin/Panel/VBox/TimeOfDayOption") as OptionButton
		_expect(time_option != null and time_option.item_count == 4, "menu must show four approved light choices")
		if time_option != null:
			_expect(str(time_option.get_item_metadata(1)) == "bright", "Bright must remain the second ordered menu choice")
			time_option.emit_signal("item_selected", 3)
			_expect(game_state.get_selected_time_of_day() == "night", "menu time selection must update GameState")
			_expect(game_state.selected_mood == before_mood, "time selection must not change mood")
			_expect(game_state.get_selected_player_style() == before_player and game_state.get_selected_pet_type() == before_pet, "time selection must not change identity")
			_expect(game_state.companion_affection == before_affection and game_state.photos.size() == before_photos, "time selection must not create progression")
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
		print("PASS: main menu time-of-day contract")
		quit(0)
	else:
		printerr("FAILED: %d main menu time-of-day assertions" % _failures)
		quit(1)

