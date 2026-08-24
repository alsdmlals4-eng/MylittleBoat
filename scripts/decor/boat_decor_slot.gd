# 한 보트 꾸미기 슬롯의 기술 placeholder와 상호작용을 관리한다.
extends Node3D

const CATALOG_SCRIPT = preload("res://scripts/decor/boat_decor_catalog.gd")
const INTERACTION_SCRIPT = preload("res://scripts/interaction/low_pressure_interactable.gd")

@export var slot_id := ""

var _catalog = CATALOG_SCRIPT.new()
var _interaction = INTERACTION_SCRIPT.new()
var _item_id := ""
var _visual: Node3D = null


func apply_item(item_id: String) -> bool:
	if item_id == "":
		_item_id = ""
		_clear_visual()
		_interaction.configure("decor:%s" % slot_id, "빈 꾸미기 슬롯", [])
		return true
	if not _catalog.is_compatible(slot_id, item_id):
		return false

	_item_id = item_id
	_clear_visual()
	var definition := _catalog.get_item_definition(item_id)
	_build_visual(str(definition.get("shape", "")))
	_interaction.configure(
		"decor:%s" % slot_id,
		str(definition.get("label", item_id)),
		definition.get("actions", [])
	)
	_sync_interaction_visual()
	return true


func get_item_id() -> String:
	return _item_id


func is_technical_placeholder() -> bool:
	return true


func get_actions(actor_context: Dictionary = {}) -> Array[Dictionary]:
	return _interaction.get_actions(actor_context)


func can_interact(actor_context: Dictionary, action_id: String) -> bool:
	return _interaction.can_interact(actor_context, action_id)


func perform(actor_context: Dictionary, action_id: String) -> Dictionary:
	var result := _interaction.perform(actor_context, action_id)
	_sync_interaction_visual()
	return result


func _build_visual(shape: String) -> void:
	var mesh_instance := MeshInstance3D.new()
	mesh_instance.name = "TechnicalDecorVisual"
	var material := StandardMaterial3D.new()
	material.roughness = 0.88

	match shape:
		"lantern":
			var mesh := BoxMesh.new()
			mesh.size = Vector3(0.24, 0.42, 0.24)
			mesh_instance.mesh = mesh
			material.albedo_color = Color(0.86, 0.68, 0.42, 1.0)
		"mug":
			var mesh := CylinderMesh.new()
			mesh.top_radius = 0.13
			mesh.bottom_radius = 0.13
			mesh.height = 0.24
			mesh_instance.mesh = mesh
			material.albedo_color = Color(0.78, 0.84, 0.86, 1.0)
		"cushion", "pet_cushion":
			var mesh := BoxMesh.new()
			mesh.size = Vector3(0.48, 0.12, 0.42)
			mesh_instance.mesh = mesh
			material.albedo_color = Color(0.76, 0.67, 0.76, 1.0) if shape == "cushion" else Color(0.72, 0.66, 0.56, 1.0)
		"plant":
			var mesh := CylinderMesh.new()
			mesh.top_radius = 0.14
			mesh.bottom_radius = 0.18
			mesh.height = 0.34
			mesh_instance.mesh = mesh
			material.albedo_color = Color(0.48, 0.67, 0.52, 1.0)
		"postcard":
			var mesh := BoxMesh.new()
			mesh.size = Vector3(0.42, 0.26, 0.035)
			mesh_instance.mesh = mesh
			material.albedo_color = Color(0.88, 0.82, 0.72, 1.0)
		_:
			var mesh := SphereMesh.new()
			mesh.radius = 0.18
			mesh.height = 0.36
			mesh_instance.mesh = mesh
			material.albedo_color = Color(0.72, 0.72, 0.72, 1.0)

	mesh_instance.set_surface_override_material(0, material)
	add_child(mesh_instance)
	_visual = mesh_instance

	if shape == "lantern":
		var light := OmniLight3D.new()
		light.name = "TechnicalLanternLight"
		light.omni_range = 2.2
		light.light_energy = 0.16
		light.visible = false
		_visual.add_child(light)


func _clear_visual() -> void:
	if is_instance_valid(_visual):
		_visual.queue_free()
	_visual = null


func _sync_interaction_visual() -> void:
	if not is_instance_valid(_visual):
		return
	var state := _interaction.get_state()
	if _item_id == "lantern":
		var light := _visual.get_node_or_null("TechnicalLanternLight") as OmniLight3D
		if light != null:
			light.visible = bool(state.get("light_on", false))
	elif _item_id == "mug":
		_visual.position.y = 0.12 if bool(state.get("held", false)) else 0.0
