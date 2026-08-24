# Rest-first technical prototype contracts: persistent audio wiring, soft sea composition, and non-demanding pet placeholder.
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

	var soundscape := root.get_node_or_null("RestingSoundscape")
	var ocean_bed := root.get_node_or_null("RestingSoundscape/OceanBed") as AudioStreamPlayer
	_expect(soundscape != null, "RestingSoundscape must be a persistent AutoLoad owner so album/menu scene changes do not restart the ocean bed")
	_expect(scene.get_node_or_null("RestingSoundscape") == null, "game scene must not create a duplicate local RestingSoundscape")
	_expect(ocean_bed != null, "persistent RestingSoundscape must expose an OceanBed AudioStreamPlayer")
	if soundscape != null:
		_expect(soundscape.has_method("is_technical_prototype"), "soundscape must expose its evidence class")
		if soundscape.has_method("is_technical_prototype"):
			_expect(bool(soundscape.call("is_technical_prototype")), "current generated soundscape must stay explicitly TECHNICAL_PROTOTYPE")
	if ocean_bed != null:
		_expect(ocean_bed.stream != null, "OceanBed must have a technical prototype stream wired")
		_expect(ocean_bed.autoplay, "OceanBed must autoplay so doing nothing still produces the resting space")
		_expect(ocean_bed.volume_db <= -8.0, "technical OceanBed must start conservatively below -8 dB")
		var wave := ocean_bed.stream as AudioStreamWAV
		_expect(wave != null, "technical OceanBed must use an inspectable AudioStreamWAV loop")
		if wave != null:
			_expect(wave.loop_mode == AudioStreamWAV.LOOP_FORWARD, "technical OceanBed must loop continuously")
			_expect(wave.loop_end > wave.loop_begin, "technical OceanBed loop range must be valid")

	var pet := scene.get_node_or_null("VoyageWorld/RestingPetPlaceholder") as Node3D
	_expect(pet != null, "game scene must include one clearly-placeholder resting pet")
	if pet != null:
		_expect(pet.has_method("get_resting_state"), "resting pet controller must expose its current low-pressure idle state")
		_expect(pet.has_method("get_next_idle_seconds"), "resting pet controller must expose the next idle interval for testability")
		_expect(pet.has_method("has_care_obligation"), "resting pet must expose whether it creates a care obligation")
		if pet.has_method("get_next_idle_seconds"):
			_expect(float(pet.call("get_next_idle_seconds")) >= 10.0, "pet idle interval must be long enough to avoid attention-seeking behavior")
		if pet.has_method("has_care_obligation"):
			_expect(not bool(pet.call("has_care_obligation")), "resting pet placeholder must not create hunger/cleaning/fatigue obligations")

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
