# C+강아지 최종 합성에서 쿠션만 보이고 엽서는 Album·미리보기에 남는지 검증한다.
extends SceneTree

const BOAT_SPACE_PATH := "res://scenes/boat_space.tscn"
const TEST_SAVE_PATH := "user://test_final_composite_decor_contract.cfg"
const CUSHION_TEXTURE_PATH := "res://assets/images/decor/pet_cushion/cushion_floral_chibi.png"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(ResourceLoader.exists(BOAT_SPACE_PATH), "BoatSpace scene must exist")
	if ResourceLoader.exists(BOAT_SPACE_PATH):
		var game_state := root.get_node_or_null("GameState")
		_expect(game_state != null, "GameState autoload must exist")
		if game_state == null:
			_finish()
			return
		_remove_test_save()
		game_state.set_boat_decor_storage_path(TEST_SAVE_PATH)
		game_state.boat_decor.clear()
		game_state.boat_decor_appearances.clear()
		game_state.set_selected_player_style("c_loose_knit")
		game_state.set_selected_pet_type("dog")
		game_state.set_boat_decor("pet_corner", "pet_cushion")
		game_state.set_boat_decor_appearance("pet_corner", "floral")
		game_state.set_boat_decor("rail_accent", "postcard")
		var scene := (load(BOAT_SPACE_PATH) as PackedScene).instantiate()
		root.add_child(scene)
		await process_frame
		var final_card := scene.get_node_or_null("FinalDioramaCard") as Sprite3D
		var pet_corner := scene.get_node_or_null("BoatDecorSlots/PetCorner") as Node3D
		var rail_accent := scene.get_node_or_null("BoatDecorSlots/RailAccent") as Node3D
		var cushion_surface := scene.get_node_or_null("FinalDioramaCard/PartsViewport/Cushion") as Sprite2D
		var postcard_surface := scene.get_node_or_null("StorybookPostcardSurface") as Sprite3D
		_expect(final_card != null, "C + dog final composite card must exist")
		_expect(pet_corner != null, "PetCorner decor slot must exist")
		_expect(pet_corner != null and not pet_corner.visible, "final composite must hide detached pet cushion technical mesh")
		_expect(rail_accent != null and not rail_accent.visible, "final composite must hide detached postcard technical mesh")
		_expect(cushion_surface != null and cushion_surface.visible, "final composite must show a pet cushion surface overlay")
		_expect(cushion_surface != null and cushion_surface.texture != null and cushion_surface.texture.resource_path == CUSHION_TEXTURE_PATH, "surface overlay must use selected approved cushion texture")
		_expect(cushion_surface != null and cushion_surface.material is ShaderMaterial, "cushion surface overlay must mask the opaque texture to a soft cushion shape")
		var pet := scene.get_node_or_null("FinalDioramaCard/PartsViewport/Pet") as Sprite2D
		_expect(cushion_surface != null and pet != null and cushion_surface.get_index() < pet.get_index() and cushion_surface.position.distance_to(pet.position) < 50.0, "selected cushion must remain beneath the pet in the assembled boat")
		_expect(not scene.get_node("StorybookPetCushionSurface").visible, "legacy detached cushion must not float outside the newly positioned boat")
		_expect(postcard_surface == null, "main final composite must not include a postcard overlay node because Album and decor preview remain its consumer surfaces")
		scene.queue_free()
		await process_frame
		game_state.boat_decor.clear()
		game_state.boat_decor_appearances.clear()
		game_state.set_boat_decor_storage_path("user://boat_decor_v1.cfg")
		game_state.load_boat_decor()
		_remove_test_save()
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _remove_test_save() -> void:
	preload("res://tests/helpers/config_store_test_cleanup.gd").remove_store(TEST_SAVE_PATH)


func _finish() -> void:
	if _failures == 0:
		print("PASS: final composite decor contract")
		quit(0)
	else:
		printerr("FAILED: %d final composite decor assertions" % _failures)
		quit(1)
