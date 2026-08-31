# 승인된 런타임 이미지가 보트 장식 소비자와 핵심 상태를 보존하는지 검증한다.
extends SceneTree

const VISUAL_ASSETS_PATH := "res://scripts/decor/decor_visual_assets.gd"
const SLOT_PATH := "res://scripts/decor/boat_decor_slot.gd"
const GAME_SCENE_PATH := "res://scenes/game.tscn"
const CUSHION_TEXTURE_PATHS := {

	"stripe": "res://assets/images/decor/pet_cushion/cushion_stripe_chibi.png",
	"moon": "res://assets/images/decor/pet_cushion/cushion_moon_chibi.png",
	"floral": "res://assets/images/decor/pet_cushion/cushion_floral_chibi.png",
}
const POSTCARD_TEXTURE_PATH := "res://assets/images/decor/postcard/postcard_chibi_moonboat.png"
const VOYAGE_TEXTURE_PATHS := {
	"bright": "res://assets/images/runtime/voyage/bright-open-sea-water-only.png",
	"dawn": "res://assets/images/runtime/voyage/dawn-arches-waterfall-water-only.png",
	"lagoon": "res://assets/images/runtime/voyage/bright-clear-seagrass-lagoon.png",
	"sunset": "res://assets/images/runtime/voyage/sunset-sandstone-cove-water-only.png",
	"night": "res://assets/images/runtime/voyage/night-indigo-rain-bay-water-only.png",
}
const AMBIENT_MOTIF_TEXTURE_PATHS := {
	"dawn_arch": "res://assets/images/runtime/voyage/ambient_motifs/dawn-sea-arch-waterfall.png",
	"bright_seagrass": "res://assets/images/runtime/voyage/ambient_motifs/bright-seagrass-sandbar.png",
	"bright_cliffs": "res://assets/images/runtime/voyage/ambient_motifs/bright-chalk-cliffs-birds.png",
	"sunset_cove": "res://assets/images/runtime/voyage/ambient_motifs/sunset-sandstone-cove.png",
	"sunset_reeds": "res://assets/images/runtime/voyage/ambient_motifs/sunset-reed-islet.png",
	"night_bioluminescence": "res://assets/images/runtime/voyage/ambient_motifs/night-bioluminescent-band.png",
}
const BOAT_WATER_CONTACT_TEXTURE_PATH := "res://assets/images/runtime/voyage/boat-water-contact-ripple.png"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(ResourceLoader.exists(VISUAL_ASSETS_PATH), "runtime image asset resolver must exist")
	_expect(ResourceLoader.exists(SLOT_PATH), "boat decor slot script must exist")
	_expect(ResourceLoader.exists(GAME_SCENE_PATH), "game scene must exist")
	for texture_path in CUSHION_TEXTURE_PATHS.values():
		_expect(ResourceLoader.exists(texture_path), "approved cushion texture must exist: %s" % texture_path)
	_expect(ResourceLoader.exists(POSTCARD_TEXTURE_PATH), "approved postcard texture must exist")
	for texture_path in VOYAGE_TEXTURE_PATHS.values():
		_expect(ResourceLoader.exists(texture_path), "approved voyage texture must be runtime-loadable: %s" % texture_path)
	for texture_path in AMBIENT_MOTIF_TEXTURE_PATHS.values():
		_expect(ResourceLoader.exists(texture_path), "approved ambient motif texture must be runtime-loadable: %s" % texture_path)
	_expect(ResourceLoader.exists(BOAT_WATER_CONTACT_TEXTURE_PATH), "approved boat-water contact texture must be runtime-loadable")
	var game_scene_source := FileAccess.get_file_as_string("res://scripts/voyage/game_scene.gd")
	_expect(game_scene_source.contains("assets/images/runtime/voyage"), "game scene must own approved voyage-texture consumers")

	if not ResourceLoader.exists(VISUAL_ASSETS_PATH):
		_finish()
		return
	var visual_assets_script := load(VISUAL_ASSETS_PATH)
	_expect(visual_assets_script != null, "runtime image asset resolver must load")
	if visual_assets_script == null:
		_finish()
		return
	var visual_assets = visual_assets_script.new()
	_expect(visual_assets.get_cushion_appearance_ids() == ["stripe", "moon", "floral"], "cushion appearance ids must remain exactly the three approved variants")
	for appearance_id in CUSHION_TEXTURE_PATHS:
		_expect(visual_assets.get_cushion_texture_path(appearance_id) == CUSHION_TEXTURE_PATHS[appearance_id], "cushion appearance must resolve to its approved texture")
	_expect(visual_assets.get_postcard_texture_path() == POSTCARD_TEXTURE_PATH, "postcard must resolve to the approved Bright Boat face")
	_expect(visual_assets.load_texture_if_available("res://assets/images/decor/missing.png") == null, "missing texture must resolve safely to a neutral fallback")

	var slot_script := load(SLOT_PATH)
	var cushion_slot = slot_script.new()
	cushion_slot.slot_id = "pet_corner"
	root.add_child(cushion_slot)
	_expect(cushion_slot.apply_item("pet_cushion", "moon"), "pet cushion must accept the moon appearance")
	_expect(cushion_slot.get_item_id() == "pet_cushion", "pet cushion base item id must remain stable")
	_expect(cushion_slot.get_appearance_id() == "moon", "pet cushion must store the selected cosmetic appearance")
	_expect(cushion_slot.get_active_texture_path() == CUSHION_TEXTURE_PATHS["moon"], "pet cushion runtime consumer must use the exact moon texture")
	_expect(_material_uses_texture(cushion_slot.get_node_or_null("TechnicalDecorVisual"), CUSHION_TEXTURE_PATHS["moon"]), "pet cushion material must consume the exact moon texture")
	cushion_slot.queue_free()
	await process_frame

	var postcard_slot = slot_script.new()
	postcard_slot.slot_id = "rail_accent"
	root.add_child(postcard_slot)
	_expect(postcard_slot.apply_item("postcard"), "postcard must remain compatible with the rail slot")
	_expect(postcard_slot.get_item_id() == "postcard", "postcard base item id must remain stable")
	_expect(postcard_slot.get_appearance_id() == "", "postcard must not create a variant state")
	_expect(postcard_slot.get_active_texture_path() == POSTCARD_TEXTURE_PATH, "postcard runtime consumer must use the exact Bright Boat face")
	_expect(_material_uses_texture(postcard_slot.get_node_or_null("TechnicalDecorVisual/TechnicalPostcardFace"), POSTCARD_TEXTURE_PATH), "postcard front face must consume the exact Bright Boat texture")
	postcard_slot.queue_free()
	await process_frame

	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	if game_state != null:
		var before_photos: int = game_state.photos.size()
		var before_records: int = game_state.voyage_records.size()
		game_state.boat_decor.clear()
		game_state.boat_decor_appearances.clear()
		var packed := load(GAME_SCENE_PATH) as PackedScene
		var scene := packed.instantiate()
		root.add_child(scene)
		await process_frame
		scene.set_application_foreground(false)
		var before_together_time: float = game_state.together_time_seconds
		_expect(scene.call("apply_boat_decor", "pet_corner", "pet_cushion", "floral"), "game scene must apply a selected cushion appearance")
		_expect(game_state.get_boat_decor("pet_corner") == "pet_cushion", "appearance selection must preserve base decor storage")
		_expect(game_state.get_boat_decor_appearance("pet_corner") == "floral", "appearance selection must persist independently of the item id")
		_expect(scene.call("apply_boat_decor", "rail_accent", "postcard"), "game scene must apply the default postcard face")
		_expect(is_equal_approx(game_state.together_time_seconds, before_together_time), "image appearance changes must not create together time")
		_expect(game_state.photos.size() == before_photos, "image appearance changes must not create photos")
		_expect(game_state.voyage_records.size() == before_records, "image appearance changes must not create voyage records")
		scene.queue_free()
		await process_frame
		game_state.boat_decor.clear()
		game_state.boat_decor_appearances.clear()

	_finish()


func _material_uses_texture(node: Node, expected_path: String) -> bool:
	var mesh_instance := node as MeshInstance3D
	if mesh_instance == null:
		return false
	var material := mesh_instance.get_active_material(0) as StandardMaterial3D
	return material != null and material.albedo_texture != null and material.albedo_texture.resource_path == expected_path


func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: runtime image asset contract")
		quit(0)
	else:
		printerr("FAILED: %d runtime image asset assertions" % _failures)
		quit(1)
