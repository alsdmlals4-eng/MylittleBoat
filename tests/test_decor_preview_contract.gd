# 꾸미기 패널의 독립 보트 미리보기와 기본 풍경 분리를 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const IDENTITY_TEST_SAVE_PATH := "user://decor_preview_identity.cfg"
const DECOR_TEST_SAVE_PATH := "user://decor_preview_decor.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	if game_state == null:
		_finish()
		return
	_prepare_isolated_cosmetics(game_state)
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	_expect(packed_scene != null, "game scene must load")
	if packed_scene == null:
		_restore_storage(game_state)
		_finish()
		return
	var cold_scene := packed_scene.instantiate()
	var cold_preview_viewport := cold_scene.get_node_or_null("DecorPanel/DecorVBox/DecorPreview/DecorPreviewViewport") as SubViewport
	var cold_preview_camera := cold_scene.get_node_or_null("DecorPanel/DecorVBox/DecorPreview/DecorPreviewViewport/PreviewWorld/PreviewCameraRig/PreviewCamera3D") as Camera3D
	var cold_preview_boat_space := cold_scene.get_node_or_null("DecorPanel/DecorVBox/DecorPreview/DecorPreviewViewport/PreviewWorld/BoatSpace") as Node3D
	_expect(cold_preview_viewport != null and cold_preview_viewport.disable_3d, "packed scene must disable the hidden preview 3D world before its first frame")
	_expect(cold_preview_viewport != null and cold_preview_viewport.render_target_update_mode == SubViewport.UPDATE_DISABLED, "packed scene must not schedule hidden preview rendering before its first frame")
	_expect(cold_preview_camera != null and not cold_preview_camera.current, "packed scene must not assign the hidden preview camera before its first frame")
	_expect(cold_preview_boat_space != null and not cold_preview_boat_space.visible, "packed scene must hide the preview BoatSpace before its first frame")
	cold_scene.queue_free()
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame
	scene.set_application_foreground(false)
	var before_together_time: float = game_state.together_time_seconds
	var before_scenery_count: int = game_state.sceneries.size()
	var main_boat_space := scene.get_node_or_null("VoyageWorld/BoatSpace") as Node3D
	var preview_boat_before_open := scene.get_node_or_null("DecorPanel/DecorVBox/DecorPreview/DecorPreviewViewport/PreviewWorld/BoatSpace") as Node3D
	var preview_camera_before_open := scene.get_node_or_null("DecorPanel/DecorVBox/DecorPreview/DecorPreviewViewport/PreviewWorld/PreviewCameraRig/PreviewCamera3D") as Camera3D
	var preview_viewport_before_open := scene.get_node_or_null("DecorPanel/DecorVBox/DecorPreview/DecorPreviewViewport") as SubViewport
	_expect(main_boat_space != null and main_boat_space.visible, "default voyage must render the primary BoatSpace once over the water-only backdrop")
	_expect(preview_camera_before_open != null and not preview_camera_before_open.current, "hidden decor preview must not claim the active camera")
	_expect(preview_viewport_before_open != null and preview_viewport_before_open.disable_3d, "hidden decor preview must not render a second 3D world")
	_expect(preview_boat_before_open != null and not preview_boat_before_open.visible, "hidden decor preview must not leave a second BoatSpace visible")

	_expect(scene.has_method("_open_decor_panel"), "game scene must expose the optional decor-panel entry")
	if scene.has_method("_open_decor_panel"):
		scene.call("_open_decor_panel")
		await process_frame
	var decor_panel := scene.get_node_or_null("DecorPanel") as Control
	var preview := scene.get_node_or_null("DecorPanel/DecorVBox/DecorPreview") as SubViewportContainer
	var preview_viewport := scene.get_node_or_null("DecorPanel/DecorVBox/DecorPreview/DecorPreviewViewport") as SubViewport
	var preview_camera := scene.get_node_or_null("DecorPanel/DecorVBox/DecorPreview/DecorPreviewViewport/PreviewWorld/PreviewCameraRig/PreviewCamera3D") as Camera3D
	var preview_boat_space := scene.get_node_or_null("DecorPanel/DecorVBox/DecorPreview/DecorPreviewViewport/PreviewWorld/BoatSpace") as Node3D
	var preview_router := scene.get_node_or_null("DecorPanel/DecorVBox/DecorPreview/DecorPreviewViewport/PreviewWorld/BoatSpace/IdentityVisualRouter")
	var preview_lantern_slot := scene.get_node_or_null("DecorPanel/DecorVBox/DecorPreview/DecorPreviewViewport/PreviewWorld/BoatSpace/BoatDecorSlots/BowLeft")
	var player_style_option := scene.get_node_or_null("DecorPanel/DecorVBox/IdentityRow/PlayerStyleOption") as OptionButton
	var pet_type_option := scene.get_node_or_null("DecorPanel/DecorVBox/IdentityRow/PetTypeOption") as OptionButton
	_expect(decor_panel != null and decor_panel.visible, "opening optional decor must show its panel")
	_expect(preview != null and preview.visible, "opening optional decor must reveal an independent preview surface")
	_expect(preview_viewport != null and preview_viewport.render_target_update_mode == SubViewport.UPDATE_ALWAYS, "opening decor must resume its isolated preview render target")
	_expect(preview_viewport != null and not preview_viewport.disable_3d, "opening decor may enable its isolated 3D world")
	_expect(preview_camera != null and preview_camera.current, "opening decor may activate its isolated preview camera")
	_expect(preview_boat_space != null and preview_boat_space.visible, "opening decor must activate its separate BoatSpace instance")
	_expect(main_boat_space != null and main_boat_space.visible, "opening decor preview must not create a second main-voyage BoatSpace")
	_expect(preview_router != null and preview_router.has_method("get_active_visual_route"), "preview BoatSpace must own the identity visual router")
	if preview_router != null and preview_router.has_method("get_active_visual_route"):
		var route := Dictionary(preview_router.call("get_active_visual_route"))
		_expect(str(route.get("player_style_id", "")) == "a_soft_hooded", "preview must show the currently selected player appearance")
		_expect(str(route.get("pet_type_id", "")) == "otter", "preview must show the currently selected companion type")
	_expect(preview_lantern_slot != null and preview_lantern_slot.has_method("get_item_id"), "preview must keep the original boat-decor slot contract")
	if preview_lantern_slot != null and preview_lantern_slot.has_method("get_item_id"):
		_expect(str(preview_lantern_slot.call("get_item_id")) == "lantern", "preview must render the stored lantern decoration")
	_expect(player_style_option != null and pet_type_option != null, "decor panel must provide local player and companion selectors")
	if player_style_option != null and pet_type_option != null:
		var player_style_index := _find_metadata_index(player_style_option, "b_short_cape")
		var pet_type_index := _find_metadata_index(pet_type_option, "cat")
		_expect(player_style_index >= 0, "decor player selector must expose the short-cape visual choice")
		_expect(pet_type_index >= 0, "decor companion selector must expose the cat visual choice")
		if player_style_index >= 0 and pet_type_index >= 0:
			player_style_option.select(player_style_index)
			player_style_option.emit_signal("item_selected", player_style_index)
			pet_type_option.select(pet_type_index)
			pet_type_option.emit_signal("item_selected", pet_type_index)
			await process_frame
			_expect(game_state.get_selected_player_style() == "b_short_cape", "decor player selector must store the selected cosmetic choice locally")
			_expect(game_state.get_selected_pet_type() == "cat", "decor companion selector must store the selected cosmetic choice locally")
			if preview_router != null and preview_router.has_method("get_active_visual_route"):
				var updated_route := Dictionary(preview_router.call("get_active_visual_route"))
				_expect(str(updated_route.get("player_style_id", "")) == "b_short_cape", "preview must refresh after player selection")
				_expect(str(updated_route.get("pet_type_id", "")) == "cat", "preview must refresh after companion selection")
	_expect(is_equal_approx(game_state.together_time_seconds, before_together_time), "opening decor preview must not create together time")
	_expect(game_state.sceneries.size() == before_scenery_count, "opening decor preview must not create scenery rewards")

	if scene.has_method("_close_decor_panel"):
		scene.call("_close_decor_panel")
		await process_frame
		_expect(decor_panel != null and not decor_panel.visible, "closing decor must hide the panel")
		_expect(preview != null and not preview.visible, "closing decor must hide its independent preview surface")
		_expect(preview_viewport != null and preview_viewport.render_target_update_mode == SubViewport.UPDATE_DISABLED, "closing decor must stop the isolated preview render target")
		_expect(preview_viewport != null and preview_viewport.disable_3d, "closing decor must disable the isolated 3D world")
		_expect(preview_camera != null and not preview_camera.current, "closing decor must release the isolated preview camera")
		_expect(preview_boat_space != null and not preview_boat_space.visible, "closing decor must hide its separate BoatSpace instance")
	else:
		_expect(false, "game scene must expose decor-panel close behavior")
	scene.queue_free()
	await process_frame
	_restore_storage(game_state)
	_finish()


func _prepare_isolated_cosmetics(game_state: Node) -> void:
	DirAccess.remove_absolute(ProjectSettings.globalize_path(IDENTITY_TEST_SAVE_PATH))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(DECOR_TEST_SAVE_PATH))
	game_state.set_identity_storage_path(IDENTITY_TEST_SAVE_PATH)
	game_state.set_boat_decor_storage_path(DECOR_TEST_SAVE_PATH)
	game_state.boat_decor.clear()
	game_state.boat_decor_appearances.clear()
	game_state.set_selected_player_style("a_soft_hooded")
	game_state.set_selected_pet_type("otter")
	game_state.set_boat_decor("bow_left", "lantern")
	game_state.reset_session()
	game_state.voyage_active = true
	game_state.remaining_seconds = 300.0


func _restore_storage(game_state: Node) -> void:
	game_state.reset_session()
	game_state.set_identity_storage_path("user://identity_profile_v1.cfg")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(IDENTITY_TEST_SAVE_PATH))
	game_state.boat_decor.clear()
	game_state.boat_decor_appearances.clear()
	game_state.set_boat_decor_storage_path("user://boat_decor_v1.cfg")
	game_state.load_boat_decor()
	DirAccess.remove_absolute(ProjectSettings.globalize_path(DECOR_TEST_SAVE_PATH))


func _find_metadata_index(option_button: OptionButton, expected_id: String) -> int:
	for index in option_button.item_count:
		if str(option_button.get_item_metadata(index)) == expected_id:
			return index
	return -1


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: decor preview contract")
		quit(0)
	else:
		printerr("FAILED: %d decor preview assertions" % _failures)
		quit(1)
