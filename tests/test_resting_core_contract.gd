# Rest-first technical prototype contracts: audio wiring, soft sea composition, and non-demanding pet placeholder.
extends SceneTree

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed_scene := load("res://scenes/game.tscn") as PackedScene
	_expect(packed_scene != null, "game.tscn must load")
	if packed_scene == null:
		_finish()
		return

	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame

	var soundscape := scene.get_node_or_null("RestingSoundscape")
	var ocean_bed := scene.get_node_or_null("RestingSoundscape/OceanBed") as AudioStreamPlayer
	_expect(soundscape != null, "game scene must have a dedicated RestingSoundscape owner")
	_expect(ocean_bed != null, "RestingSoundscape must expose an OceanBed AudioStreamPlayer")
	if ocean_bed != null:
		_expect(ocean_bed.stream != null, "OceanBed must have a technical prototype stream wired")
		_expect(ocean_bed.autoplay, "OceanBed must autoplay so doing nothing still produces the resting space")
		_expect(ocean_bed.volume_db <= -8.0, "technical OceanBed must start conservatively below -8 dB")

	var pet := scene.get_node_or_null("VoyageWorld/RestingPetPlaceholder") as Node3D
	_expect(pet != null, "game scene must include one clearly-placeholder resting pet")
	if pet != null:
		_expect(pet.has_method("get_resting_state"), "resting pet controller must expose its current low-pressure idle state")
		_expect(pet.has_method("get_next_idle_seconds"), "resting pet controller must expose the next idle interval for testability")
		if pet.has_method("get_next_idle_seconds"):
			_expect(float(pet.call("get_next_idle_seconds")) >= 10.0, "pet idle interval must be long enough to avoid attention-seeking behavior")

	var ocean := scene.get_node_or_null("VoyageWorld/OceanPlane") as MeshInstance3D
	_expect(ocean != null, "resting prototype must keep an explicit OceanPlane")
	if ocean != null:
		var material := ocean.get_active_material(0) as StandardMaterial3D
		_expect(material != null, "OceanPlane must have a readable soft-sea material")
		if material != null:
			_expect(material.roughness >= 0.85, "placeholder ocean must favor soft reflection over sharp glare")
			_expect(material.albedo_color.v <= 0.75, "placeholder ocean must avoid excessively bright high-glare color")

	scene.queue_free()
	await process_frame
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: resting core technical prototype contract")
		quit(0)
	else:
		printerr("FAILED: %d resting core assertions" % _failures)
		quit(1)
