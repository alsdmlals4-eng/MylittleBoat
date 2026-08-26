# 첫 production visual slice의 구조·보호 경계를 검증한다.
extends SceneTree

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed_scene := load("res://scenes/game.tscn") as PackedScene
	_expect(packed_scene != null, "game scene must load")
	if packed_scene == null:
		_finish()
		return
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame

	var avatar := scene.get_node_or_null("VoyageWorld/BoatSpace/PlayerAvatarPlaceholder") as Node3D
	var pet := scene.get_node_or_null("VoyageWorld/BoatSpace/RestingPetPlaceholder") as Node3D
	var boat := scene.get_node_or_null("VoyageWorld/BoatSpace/BoatBow") as Node3D
	_expect(avatar != null and avatar.get_node_or_null("VisualStudy") != null, "avatar needs VisualStudy")
	_expect(pet != null and pet.get_node_or_null("VisualStudy") != null, "pet needs VisualStudy")
	_expect(boat != null and boat.get_node_or_null("VisualStudy") != null, "boat needs VisualStudy")
	if avatar != null:
		_expect(avatar.has_method("is_technical_placeholder"), "avatar keeps placeholder evidence API")
		if avatar.has_method("is_technical_placeholder"):
			_expect(bool(avatar.call("is_technical_placeholder")), "avatar remains a technical placeholder")
	if pet != null:
		_expect(pet.has_method("has_care_obligation"), "pet keeps care evidence API")
		if pet.has_method("has_care_obligation"):
			_expect(not bool(pet.call("has_care_obligation")), "visual study cannot add pet chores")
	var appreciation_button := scene.get_node_or_null("BottomPanel/ButtonGrid/AppreciationButton") as Button
	var bottom_panel := scene.get_node_or_null("BottomPanel") as PanelContainer
	_expect(appreciation_button != null, "appreciation exit button must remain available")
	if appreciation_button != null:
		appreciation_button.emit_signal("pressed")
		await process_frame
		_expect(bottom_panel != null and bottom_panel.offset_top > -96.0, "appreciation mode must collapse the empty control panel")

	for owner in [avatar, pet, boat]:
		if owner == null:
			continue
		var visual_study := owner.get_node_or_null("VisualStudy") as Node3D
		if visual_study == null:
			continue
		_expect(_has_matte_meshes(visual_study), "%s VisualStudy needs opaque matte meshes" % owner.name)

	scene.queue_free()
	await process_frame
	_finish()


func _has_matte_meshes(visual_study: Node3D) -> bool:
	var meshes := visual_study.find_children("*", "MeshInstance3D", true, false)
	if meshes.is_empty():
		return false
	for node in meshes:
		var mesh_instance := node as MeshInstance3D
		var material := mesh_instance.get_active_material(0) as StandardMaterial3D
		if material == null:
			return false
		if not is_zero_approx(material.metallic):
			return false
		if material.roughness < 0.8:
			return false
		if material.transparency != BaseMaterial3D.TRANSPARENCY_DISABLED:
			return false
	return true


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: handpainted visual slice contract")
		quit(0)
	else:
		printerr("FAILED: %d handpainted visual slice assertions" % _failures)
		quit(1)
