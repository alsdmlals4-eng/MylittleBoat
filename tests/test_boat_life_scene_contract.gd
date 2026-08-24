# 보트 생활공간의 단일 bob owner와 8개 꾸미기 슬롯을 검증한다.
extends SceneTree

var _failures := 0

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var gs := root.get_node_or_null("GameState")
	_expect(gs != null, "GameState required")
	if gs == null:
		_finish()
		return
	gs.boat_decor.clear()
	gs.set_boat_decor("bow_left", "lantern")
	gs.set_boat_decor("rear_right", "mug")
	gs.voyage_active = true
	gs.remaining_seconds = 123.0
	gs.appreciation_mode = false

	var packed := load("res://scenes/game.tscn") as PackedScene
	var scene := packed.instantiate()
	root.add_child(scene)
	await process_frame

	var space := scene.get_node_or_null("VoyageWorld/BoatSpace") as Node3D
	_expect(space != null, "BoatSpace required")
	if space != null:
		_expect(space.get_node_or_null("BoatBow") != null, "BoatBow under BoatSpace")
		_expect(space.get_node_or_null("PlayerAvatarPlaceholder") != null, "avatar under BoatSpace")
		_expect(space.get_node_or_null("RestingPetPlaceholder") != null, "pet under BoatSpace")
		_expect(space.get_node_or_null("BoatRail") != null, "BoatRail required")
		var slots := space.get_node_or_null("BoatDecorSlots")
		_expect(slots != null, "BoatDecorSlots required")
		if slots != null:
			for node_name in ["BowLeft", "BowRight", "CenterLeft", "CenterRight", "RearLeft", "RearRight", "RailAccent", "PetCorner"]:
				_expect(slots.get_node_or_null(node_name) != null, "missing slot %s" % node_name)
			var left := slots.get_node_or_null("BowLeft")
			var rear := slots.get_node_or_null("RearRight")
			if left != null and left.has_method("get_item_id"):
				_expect(str(left.call("get_item_id")) == "lantern", "stored lantern rendered")
			if rear != null and rear.has_method("get_item_id"):
				_expect(str(rear.call("get_item_id")) == "mug", "stored mug rendered")

	_expect(scene.has_method("apply_boat_decor"), "decor mutation route required")
	_expect(scene.has_method("clear_boat_decor"), "decor clear route required")
	if scene.has_method("apply_boat_decor"):
		_expect(not bool(scene.call("apply_boat_decor", "pet_corner", "postcard")), "invalid pair rejected")
		_expect(gs.get_boat_decor("pet_corner") == "", "invalid pair cannot mutate")
		_expect(bool(scene.call("apply_boat_decor", "bow_left", "plant")), "compatible replace succeeds")
		_expect(gs.get_boat_decor("bow_left") == "plant", "replace stored")
	if scene.has_method("clear_boat_decor"):
		scene.call("clear_boat_decor", "bow_left")
		_expect(gs.get_boat_decor("bow_left") == "", "clear stored")

	if space != null and scene.has_method("_apply_drift_motion"):
		var avatar := space.get_node_or_null("PlayerAvatarPlaceholder") as Node3D
		var pet := space.get_node_or_null("RestingPetPlaceholder") as Node3D
		if avatar != null and pet != null:
			var before_space := space.position
			var before_avatar := avatar.position
			var before_pet := pet.position
			scene.call("_apply_drift_motion", 0.5)
			_expect(space.position != before_space, "BoatSpace must bob")
			_expect(avatar.position == before_avatar, "avatar local position stable")
			_expect(pet.position == before_pet, "pet local position stable")

	scene.queue_free()
	await process_frame
	gs.boat_decor.clear()
	_finish()

func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("FAIL: %s" % message)

func _finish() -> void:
	if _failures == 0:
		print("PASS: boat life scene contract")
		quit(0)
	else:
		printerr("FAILED: %d boat life scene assertions" % _failures)
		quit(1)
