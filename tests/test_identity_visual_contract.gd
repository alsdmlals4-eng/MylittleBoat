# 승인된 외형 이미지와 보트 디오라마 선택 경로를 검증한다.
extends SceneTree

const CATALOG_PATH := "res://scripts/identity/identity_visual_catalog.gd"
const BOAT_SPACE_PATH := "res://scenes/boat_space.tscn"
const GAME_STATE_TEST_SAVE_PATH := "user://identity_visual_contract.cfg"
const EXPECTED_PLAYER_PATHS := {
	"a_soft_hooded": "res://assets/images/runtime/storybook/avatar_a_soft_hooded_storybook.png",
	"b_short_cape": "res://assets/images/runtime/storybook/avatar_b_short_cape_storybook.png",
	"c_loose_knit": "res://assets/images/runtime/storybook/c_default_storybook.png",
}
const EXPECTED_PET_PATHS := {
	"cat": "res://assets/images/runtime/storybook/pet_cat_storybook.png",
	"rabbit": "res://assets/images/runtime/storybook/pet_rabbit_storybook.png",
	"otter": "res://assets/images/runtime/storybook/pet_otter_storybook.png",
	"dog": "res://assets/images/runtime/storybook/dog_default_storybook.png",
}

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(ResourceLoader.exists(CATALOG_PATH), "identity visual catalog must exist")
	if ResourceLoader.exists(CATALOG_PATH):
		var catalog = load(CATALOG_PATH).new()
		_assert_asset_paths(catalog)
	_expect(ResourceLoader.exists(BOAT_SPACE_PATH), "BoatSpace scene must exist")
	if ResourceLoader.exists(BOAT_SPACE_PATH):
		await _assert_visual_routes()
	_finish()


func _assert_asset_paths(catalog: RefCounted) -> void:
	_expect(catalog.has_method("get_player_texture_path"), "catalog must resolve player art paths")
	_expect(catalog.has_method("get_pet_texture_path"), "catalog must resolve pet art paths")
	if catalog.has_method("get_player_texture_path"):
		for id in EXPECTED_PLAYER_PATHS:
			_expect(catalog.get_player_texture_path(id) == EXPECTED_PLAYER_PATHS[id], "player path must remain stable: %s" % id)
			_expect(ResourceLoader.exists(EXPECTED_PLAYER_PATHS[id]), "player asset must exist: %s" % id)
	if catalog.has_method("get_pet_texture_path"):
		for id in EXPECTED_PET_PATHS:
			_expect(catalog.get_pet_texture_path(id) == EXPECTED_PET_PATHS[id], "pet path must remain stable: %s" % id)
			_expect(ResourceLoader.exists(EXPECTED_PET_PATHS[id]), "pet asset must exist: %s" % id)


func _assert_visual_routes() -> void:
	_remove_game_state_test_save()
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	if game_state == null:
		return
	game_state.set_identity_storage_path(GAME_STATE_TEST_SAVE_PATH)
	await _expect_visual_route("c_loose_knit", "dog", "final_composite")
	await _expect_visual_route("c_loose_knit", "cat", "layered_subjects")
	await _expect_visual_route("a_soft_hooded", "dog", "layered_subjects")
	await _expect_visual_route("b_short_cape", "otter", "layered_subjects")
	game_state.set_identity_storage_path("user://identity_profile_v1.cfg")
	_remove_game_state_test_save()


func _expect_visual_route(player_style_id: String, pet_type_id: String, expected_mode: String) -> void:
	var game_state := root.get_node_or_null("GameState")
	game_state.set_selected_player_style(player_style_id)
	game_state.set_selected_pet_type(pet_type_id)
	var scene := (load(BOAT_SPACE_PATH) as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame
	var router := scene.get_node_or_null("IdentityVisualRouter")
	_expect(router != null, "BoatSpace must own IdentityVisualRouter")
	_expect(router != null and router.has_method("get_active_visual_route"), "IdentityVisualRouter must load its route API")
	if router != null and router.has_method("get_active_visual_route"):
		var route: Dictionary = router.get_active_visual_route()
		_expect(route.get("mode", "") == expected_mode, "selected pair must use expected route")
		_expect(route.get("player_style_id", "") == player_style_id, "router must expose selected player")
		_expect(route.get("pet_type_id", "") == pet_type_id, "router must expose selected pet")
		var final_card := scene.get_node_or_null("FinalDioramaCard") as Sprite3D
		_expect(final_card != null, "BoatSpace must preserve FinalDioramaCard")
		if expected_mode == "final_composite":
			_expect(final_card != null and final_card.visible, "C + dog must preserve the final composite")
		else:
			var avatar_cards := scene.get_node_or_null("PlayerAvatarPlaceholder/VisualStudy/AvatarCards")
			var pet_cards := scene.get_node_or_null("RestingPetPlaceholder/VisualStudy/PetCards")
			_expect(final_card != null and not final_card.visible, "non-default pair must hide C + dog composite")
			var selected_avatar := _get_selected_avatar_node(scene, player_style_id)
			var selected_pet := _get_selected_pet_node(scene, pet_type_id)
			_expect(selected_avatar != null and selected_avatar.visible, "layered route must show the selected player card")
			_expect(selected_pet != null and selected_pet.visible, "layered route must show the selected pet card")
			_expect(_visible_child_count(avatar_cards) + int(player_style_id == "c_loose_knit") == 1, "layered route must show exactly one player card")
			_expect(_visible_child_count(pet_cards) + int(pet_type_id == "dog") == 1, "layered route must show exactly one pet card")
	scene.queue_free()
	await process_frame


func _visible_child_count(parent: Node) -> int:
	if parent == null:
		return 0
	var visible_count := 0
	for child in parent.get_children():
		if child is CanvasItem and child.visible:
			visible_count += 1
		elif child is Node3D and child.visible:
			visible_count += 1
	return visible_count


func _get_selected_avatar_node(scene: Node, player_style_id: String) -> Node3D:
	var path := "PlayerAvatarPlaceholder/VisualStudy/StorybookCDefault" if player_style_id == "c_loose_knit" else "PlayerAvatarPlaceholder/VisualStudy/AvatarCards/%s" % player_style_id
	return scene.get_node_or_null(path) as Node3D


func _get_selected_pet_node(scene: Node, pet_type_id: String) -> Node3D:
	var path := "RestingPetPlaceholder/VisualStudy/StorybookDogDefault" if pet_type_id == "dog" else "RestingPetPlaceholder/VisualStudy/PetCards/%s" % pet_type_id
	return scene.get_node_or_null(path) as Node3D


func _remove_game_state_test_save() -> void:
	if FileAccess.file_exists(GAME_STATE_TEST_SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(GAME_STATE_TEST_SAVE_PATH))


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: identity visual contract")
		quit(0)
	else:
		printerr("FAILED: %d identity visual assertions" % _failures)
		quit(1)
