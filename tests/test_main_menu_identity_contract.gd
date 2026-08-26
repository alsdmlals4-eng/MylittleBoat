# 메인 메뉴 외형 선택이 실제 로컬 상태만 바꾸는지 검증한다.
extends SceneTree

const MAIN_MENU_PATH := "res://scenes/main_menu.tscn"
const GAME_STATE_TEST_SAVE_PATH := "user://main_menu_identity_contract.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_remove_test_save()
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	_expect(ResourceLoader.exists(MAIN_MENU_PATH), "main menu scene must exist")
	if game_state != null and ResourceLoader.exists(MAIN_MENU_PATH):
		game_state.set_identity_storage_path(GAME_STATE_TEST_SAVE_PATH)
		var before_mood: String = str(game_state.selected_mood)
		var before_affection: int = int(game_state.companion_affection)
		var before_photos: int = game_state.photos.size()
		var menu := (load(MAIN_MENU_PATH) as PackedScene).instantiate()
		root.add_child(menu)
		await process_frame
		var identity_button := menu.get_node_or_null("Margin/Panel/VBox/IdentityButton") as Button
		var panel := menu.get_node_or_null("Margin/Panel/VBox/IdentityPanel") as Control
		var player_option := menu.get_node_or_null("Margin/Panel/VBox/IdentityPanel/PlayerStyleOption") as OptionButton
		var pet_option := menu.get_node_or_null("Margin/Panel/VBox/IdentityPanel/PetTypeOption") as OptionButton
		var summary_label := menu.get_node_or_null("Margin/Panel/VBox/IdentityPanel/IdentitySummaryLabel") as Label
		_expect(identity_button != null and panel != null, "menu must expose a quiet identity entry and panel")
		_expect(player_option != null and player_option.item_count == 3, "menu must show three approved player choices")
		_expect(pet_option != null and pet_option.item_count == 4, "menu must show four approved pet choices")
		_expect(summary_label != null, "menu must show a current identity summary")
		if identity_button != null and panel != null and player_option != null and pet_option != null:
			identity_button.emit_signal("pressed")
			_expect(panel.visible, "identity entry must reveal the selector")
			player_option.emit_signal("item_selected", 0)
			pet_option.emit_signal("item_selected", 2)
			_expect(game_state.get_selected_player_style() == "a_soft_hooded", "menu player selection must update GameState")
			_expect(game_state.get_selected_pet_type() == "otter", "menu pet selection must update GameState")
			_expect(game_state.selected_mood == before_mood, "identity must not change selected mood")
			_expect(game_state.companion_affection == before_affection and game_state.photos.size() == before_photos, "identity must not create progression")
		menu.queue_free()
		await process_frame
		game_state.set_identity_storage_path("user://identity_profile_v1.cfg")
	_remove_test_save()
	_finish()


func _remove_test_save() -> void:
	if FileAccess.file_exists(GAME_STATE_TEST_SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(GAME_STATE_TEST_SAVE_PATH))


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: main menu identity contract")
		quit(0)
	else:
		printerr("FAILED: %d main menu identity assertions" % _failures)
		quit(1)
