# 저압력 상호작용의 공통 API·무보상·감상모드 비간섭 계약을 검증한다.
extends SceneTree

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	if game_state == null:
		_finish()
		return

	var before_affection: int = int(game_state.companion_affection)
	var before_photos: int = game_state.photos.size()
	var before_sceneries: int = game_state.sceneries.size()
	var before_letters: int = game_state.letters.size()
	var before_fish: int = game_state.fish.size()
	var before_records: int = game_state.voyage_records.size()
	game_state.appreciation_mode = true

	const interaction_path := "res://scripts/interaction/low_pressure_interactable.gd"
	_expect(ResourceLoader.exists(interaction_path), "low-pressure interactable script must exist")
	if ResourceLoader.exists(interaction_path):
		var interaction_script := load(interaction_path)
		_expect(interaction_script != null, "low-pressure interactable script must load")
		if interaction_script != null:
			var interaction = interaction_script.new()
			_expect(interaction.has_method("configure"), "interaction must expose configure")
			_expect(interaction.has_method("get_actions"), "interaction must expose get_actions")
			_expect(interaction.has_method("can_interact"), "interaction must expose can_interact")
			_expect(interaction.has_method("perform"), "interaction must expose perform")
			if interaction.has_method("configure") and interaction.has_method("get_actions") and interaction.has_method("can_interact") and interaction.has_method("perform"):
				interaction.call("configure", "lantern_test", "랜턴", [
					{"id": "toggle_light", "label": "불빛 바꾸기", "message": "불빛을 바꿨습니다.", "toggle_key": "light_on"},
				])
				var actions: Array = interaction.call("get_actions", {})
				_expect(actions.size() == 1 and str(actions[0].get("id", "")) == "toggle_light", "configured action must be discoverable")
				_expect(not bool(interaction.call("can_interact", {}, "missing")), "unknown interaction action must be rejected")
				_expect(bool(interaction.call("can_interact", {}, "toggle_light")), "configured interaction action must be allowed")
				var first_result: Dictionary = interaction.call("perform", {}, "toggle_light")
				var second_result: Dictionary = interaction.call("perform", {}, "toggle_light")
				_expect(bool(first_result.get("ok", false)), "valid interaction must return ok=true")
				_expect(str(first_result.get("target_id", "")) == "lantern_test", "interaction result must identify its target")
				_expect(bool(first_result.get("state", {}).get("light_on", false)), "toggle action must turn local state on")
				_expect(not bool(second_result.get("state", {}).get("light_on", true)), "second toggle must deterministically turn local state off")

	var pet_script := load("res://scripts/voyage/resting_pet_placeholder.gd")
	_expect(pet_script != null, "resting pet placeholder script must load")
	if pet_script != null:
		var pet := Node3D.new()
		pet.set_script(pet_script)
		root.add_child(pet)
		await process_frame
		_expect(pet.has_method("get_actions"), "pet must expose reusable get_actions")
		_expect(pet.has_method("can_interact"), "pet must expose reusable can_interact")
		_expect(pet.has_method("perform"), "pet must expose reusable perform")
		if pet.has_method("get_actions") and pet.has_method("perform"):
			var pet_actions: Array = pet.call("get_actions", {})
			_expect(_has_action(pet_actions, "pet"), "pet interactions must include pet")
			_expect(_has_action(pet_actions, "look_at_sea"), "pet interactions must include look_at_sea")
			var pet_result: Dictionary = pet.call("perform", {}, "pet")
			_expect(bool(pet_result.get("ok", false)), "pet action must complete without progression")
		pet.queue_free()
		await process_frame

	const rail_path := "res://scripts/voyage/boat_rail_interactable.gd"
	_expect(ResourceLoader.exists(rail_path), "boat rail interactable script must exist")
	if ResourceLoader.exists(rail_path):
		var rail_script := load(rail_path)
		_expect(rail_script != null, "boat rail interactable script must load")
		if rail_script != null:
			var rail := Node3D.new()
			rail.set_script(rail_script)
			root.add_child(rail)
			await process_frame
			_expect(rail.has_method("get_actions"), "rail must expose reusable get_actions")
			_expect(rail.has_method("can_interact"), "rail must expose reusable can_interact")
			_expect(rail.has_method("perform"), "rail must expose reusable perform")
			if rail.has_method("get_actions") and rail.has_method("perform"):
				var rail_actions: Array = rail.call("get_actions", {})
				_expect(_has_action(rail_actions, "lean"), "rail interactions must include lean")
				_expect(_has_action(rail_actions, "look_at_sea"), "rail interactions must include look_at_sea")
				var rail_result: Dictionary = rail.call("perform", {}, "lean")
				_expect(bool(rail_result.get("ok", false)), "rail action must complete without progression")
			rail.queue_free()
			await process_frame

	_expect(game_state.appreciation_mode, "interactions must never force exit from Appreciation Camera")
	_expect(int(game_state.companion_affection) == before_affection, "interactions must not change companion affection")
	_expect(game_state.photos.size() == before_photos, "interactions must not create photo rewards")
	_expect(game_state.sceneries.size() == before_sceneries, "interactions must not create scenery rewards")
	_expect(game_state.letters.size() == before_letters, "interactions must not create letter rewards")
	_expect(game_state.fish.size() == before_fish, "interactions must not create fish rewards")
	_expect(game_state.voyage_records.size() == before_records, "interactions must not create voyage records")

	game_state.appreciation_mode = false
	_finish()


func _has_action(actions: Array, action_id: String) -> bool:
	for action in actions:
		if action is Dictionary and str(action.get("id", "")) == action_id:
			return true
	return false


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: low-pressure interaction contract")
		quit(0)
	else:
		printerr("FAILED: %d low-pressure interaction assertions" % _failures)
		quit(1)
