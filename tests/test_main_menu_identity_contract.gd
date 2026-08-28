# 외형과 동반자 선택이 시작 화면이 아닌 선택형 꾸미기에만 있는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const GAME_STATE_TEST_SAVE_PATH := "user://direct_entry_identity_contract.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_remove_test_save()
	var game_state := root.get_node_or_null("GameState")
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	_expect(game_state != null, "GameState autoload must exist")
	_expect(packed_scene != null, "game scene must exist")
	if game_state == null or packed_scene == null:
		_finish()
		return

	game_state.set_identity_storage_path(GAME_STATE_TEST_SAVE_PATH)
	game_state.reset_session()
	var before_affection: int = game_state.companion_affection
	var before_photos: int = game_state.photos.size()
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame
	var rest_menu_button := scene.get_node_or_null("RestMenuButton") as Button
	var decor_button := scene.get_node_or_null("BottomPanel/ButtonGrid/DecorButton") as Button
	var decor_panel := scene.get_node_or_null("DecorPanel") as Control
	var player_option := scene.get_node_or_null("DecorPanel/DecorVBox/PlayerStyleOption") as OptionButton
	var pet_option := scene.get_node_or_null("DecorPanel/DecorVBox/PetTypeOption") as OptionButton
	var identity_router := scene.get_node_or_null("VoyageWorld/BoatSpace/IdentityVisualRouter")
	_expect(decor_panel != null and not decor_panel.visible, "first view must not show identity controls")
	if rest_menu_button != null:
		rest_menu_button.emit_signal("pressed")
		await process_frame
	if decor_button != null:
		decor_button.emit_signal("pressed")
		await process_frame
	_expect(decor_panel != null and decor_panel.visible, "decor action must reveal optional cosmetics")
	_expect(player_option != null and player_option.item_count == 3, "decor must show three approved player choices")
	_expect(pet_option != null and pet_option.item_count == 4, "decor must show four approved pet choices")
	if player_option != null and pet_option != null:
		player_option.emit_signal("item_selected", 0)
		pet_option.emit_signal("item_selected", 2)
		_expect(game_state.get_selected_player_style() == "a_soft_hooded", "decor player selection must update GameState")
		_expect(game_state.get_selected_pet_type() == "otter", "decor pet selection must update GameState")
		if identity_router != null and identity_router.has_method("get_active_visual_route"):
			var visual_route: Dictionary = identity_router.get_active_visual_route()
			_expect(visual_route.get("player_style_id", "") == "a_soft_hooded" and visual_route.get("pet_type_id", "") == "otter", "decor selections must update the live boat visuals")
		else:
			_expect(false, "boat scene must expose the identity visual router")
		_expect(game_state.companion_affection == before_affection and game_state.photos.size() == before_photos, "cosmetics must not create progression")

	scene.queue_free()
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
		print("PASS: direct-entry identity contract")
		quit(0)
	else:
		printerr("FAILED: %d direct-entry identity assertions" % _failures)
		quit(1)
