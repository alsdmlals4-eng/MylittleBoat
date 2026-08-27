# C+강아지 최종 합성 화면의 승인 장식이 평면 오버레이로 표시되는지 검증한다.
extends SceneTree

const BOAT_SPACE_PATH := "res://scenes/boat_space.tscn"
const TEST_SAVE_PATH := "user://final_composite_decor_contract.cfg"
const CUSHION_TEXTURE_PATH := "res://assets/images/decor/pet_cushion/cushion_floral.png"
const POSTCARD_TEXTURE_PATH := "res://assets/images/decor/postcard/postcard_boat_bright.png"

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
		var cushion_surface := scene.get_node_or_null("StorybookPetCushionSurface") as Sprite3D
		var postcard_surface := scene.get_node_or_null("StorybookPostcardSurface") as Sprite3D
		_expect(final_card != null, "C + dog final composite card must exist")
		_expect(pet_corner != null, "PetCorner decor slot must exist")
		_expect(pet_corner != null and not pet_corner.visible, "final composite must hide detached pet cushion technical mesh")
		_expect(rail_accent != null and not rail_accent.visible, "final composite must hide detached postcard technical mesh")
		_expect(cushion_surface != null and cushion_surface.visible, "final composite must show a pet cushion surface overlay")
		_expect(cushion_surface != null and cushion_surface.texture != null and cushion_surface.texture.resource_path == CUSHION_TEXTURE_PATH, "surface overlay must use selected approved cushion texture")
		_expect(cushion_surface != null and cushion_surface.material_override is ShaderMaterial, "cushion surface overlay must mask the opaque texture to a soft cushion shape")
		_expect(postcard_surface != null and postcard_surface.visible, "final composite must show a postcard surface overlay")
		_expect(postcard_surface != null and postcard_surface.texture != null and postcard_surface.texture.resource_path == POSTCARD_TEXTURE_PATH, "surface overlay must use approved postcard texture")
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
	if FileAccess.file_exists(TEST_SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_SAVE_PATH))


func _finish() -> void:
	if _failures == 0:
		print("PASS: final composite decor contract")
		quit(0)
	else:
		printerr("FAILED: %d final composite decor assertions" % _failures)
		quit(1)
