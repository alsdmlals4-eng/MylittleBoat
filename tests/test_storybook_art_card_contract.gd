# 스토리북 2.5D 아트 카드의 경로와 fallback 경계를 검증한다.
extends SceneTree

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed_scene := load("res://scenes/boat_space.tscn") as PackedScene
	_expect(packed_scene != null, "boat space scene must load")
	if packed_scene == null:
		_finish()
		return
	var boat_space := packed_scene.instantiate() as Node3D
	root.add_child(boat_space)
	await process_frame

	_expect_art_card(
		boat_space,
		"PlayerAvatarPlaceholder/VisualStudy/StorybookCDefault",
		"res://assets/images/runtime/storybook/c_default_storybook.png",
		["FaceMass", "HairMass", "KnitMass", "SkirtMass", "LeftBoot", "RightBoot", "Pendant"]
	)
	_expect_art_card(
		boat_space,
		"RestingPetPlaceholder/VisualStudy/StorybookDogDefault",
		"res://assets/images/runtime/storybook/dog_default_storybook.png",
		["DogBody", "DogHead", "LeftEar", "RightEar"]
	)
	_expect_art_card(
		boat_space,
		"BoatBow/VisualStudy/StorybookHullPass",
		"res://assets/images/runtime/storybook/boat_default_storybook.png",
		["HullMass", "DeckMass", "LeftRailMass", "RightRailMass"]
	)

	boat_space.queue_free()
	await process_frame
	_finish()


func _expect_art_card(boat_space: Node3D, owner_path: String, texture_path: String, fallback_names: Array[String]) -> void:
	var owner := boat_space.get_node_or_null(owner_path) as Node3D
	_expect(owner != null, "%s must exist" % owner_path)
	if owner == null:
		return
	for fallback_name in fallback_names:
		_expect(owner.get_node_or_null(fallback_name) is MeshInstance3D, "%s fallback mesh %s must remain" % [owner_path, fallback_name])
	var art_card := owner.get_node_or_null("ArtCard") as Sprite3D
	_expect(art_card != null, "%s needs ArtCard Sprite3D" % owner_path)
	if art_card == null:
		return
	_expect(art_card.texture != null, "%s ArtCard needs a texture" % owner_path)
	if art_card.texture != null:
		_expect(art_card.texture.resource_path == texture_path, "%s must use %s" % [owner_path, texture_path])
	_expect(art_card.billboard != BaseMaterial3D.BILLBOARD_DISABLED, "%s ArtCard must face the active camera" % owner_path)
	_expect(art_card.has_method("refresh_visual"), "%s ArtCard needs fallback refresh" % owner_path)


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: storybook art card contract")
		quit(0)
	else:
		printerr("FAILED: %d storybook art card assertions" % _failures)
		quit(1)
