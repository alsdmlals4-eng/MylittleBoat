# C와 강아지의 합성 보트에서 임시 3D 장식이 본 화면을 침범하지 않는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const IDENTITY_TEST_SAVE_PATH := "user://final_composite_decor_identity.cfg"
const DECOR_TEST_SAVE_PATH := "user://final_composite_decor.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	if game_state == null:
		_finish()
		return
	_prepare_final_composite_state(game_state)
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	_expect(packed_scene != null, "game scene must load")
	if packed_scene == null:
		_restore_storage(game_state)
		_finish()
		return
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame
	var main_rear_right_slot := scene.get_node_or_null("VoyageWorld/BoatSpace/BoatDecorSlots/RearRight") as Node3D
	var main_rear_right_visual := scene.get_node_or_null("VoyageWorld/BoatSpace/BoatDecorSlots/RearRight/TechnicalDecorVisual") as MeshInstance3D
	_expect(main_rear_right_visual != null, "stored mug must remain constructed for the separate decor consumer")
	_expect(main_rear_right_slot != null and not main_rear_right_slot.is_visible_in_tree(), "final C + dog composite must suppress misaligned technical decor in the main voyage only")
	_expect(main_rear_right_visual != null and not main_rear_right_visual.visible, "main final composite must disable the technical mesh itself, not only its slot parent")
	if scene.has_method("_open_decor_panel"):
		scene.call("_open_decor_panel")
		await process_frame
	var preview_rear_right_slot := scene.get_node_or_null("DecorPanel/DecorVBox/DecorPreview/DecorPreviewViewport/PreviewWorld/BoatSpace/BoatDecorSlots/RearRight") as Node3D
	var preview_rear_right_visual := scene.get_node_or_null("DecorPanel/DecorVBox/DecorPreview/DecorPreviewViewport/PreviewWorld/BoatSpace/BoatDecorSlots/RearRight/TechnicalDecorVisual") as MeshInstance3D
	_expect(preview_rear_right_slot != null and preview_rear_right_slot.is_visible_in_tree(), "decor preview must keep the selected technical decor visible for review")
	_expect(preview_rear_right_visual != null, "decor preview must render the stored mug")
	_expect(preview_rear_right_visual != null and preview_rear_right_visual.visible, "decor preview must leave its technical mug mesh enabled")
	scene.queue_free()
	await process_frame
	_restore_storage(game_state)
	_finish()


func _prepare_final_composite_state(game_state: Node) -> void:
	DirAccess.remove_absolute(ProjectSettings.globalize_path(IDENTITY_TEST_SAVE_PATH))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(DECOR_TEST_SAVE_PATH))
	game_state.set_identity_storage_path(IDENTITY_TEST_SAVE_PATH)
	game_state.set_boat_decor_storage_path(DECOR_TEST_SAVE_PATH)
	game_state.boat_decor.clear()
	game_state.boat_decor_appearances.clear()
	game_state.set_selected_player_style("c_loose_knit")
	game_state.set_selected_pet_type("dog")
	game_state.set_boat_decor("rear_right", "mug")
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


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: final composite decor visibility contract")
		quit(0)
	else:
		printerr("FAILED: %d final-composite decor visibility assertions" % _failures)
		quit(1)
