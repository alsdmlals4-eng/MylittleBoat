# 보트 꾸미기 슬롯·호환성·세션 메모리 계약을 검증한다.
extends SceneTree

const TEST_SAVE_PATH := "user://boat_decoration_contract.cfg"

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

	_expect(game_state.has_method("set_boat_decor"), "GameState must expose set_boat_decor")
	_expect(game_state.has_method("get_boat_decor"), "GameState must expose get_boat_decor")
	_expect(game_state.has_method("save_boat_decor"), "GameState must save cosmetic decor")
	_expect(game_state.has_method("load_boat_decor"), "GameState must load cosmetic decor")
	_expect(game_state.has_method("set_boat_decor_storage_path"), "GameState must isolate decor storage for contract tests")
	if game_state.has_method("set_boat_decor_storage_path"):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_SAVE_PATH))
		game_state.call("set_boat_decor_storage_path", TEST_SAVE_PATH)
	if game_state.has_method("set_boat_decor") and game_state.has_method("get_boat_decor"):
		game_state.call("set_boat_decor", "bow_left", "lantern")
		_expect(str(game_state.call("get_boat_decor", "bow_left")) == "lantern", "decor placement must be stored")
		game_state.reset_session()
		_expect(str(game_state.call("get_boat_decor", "bow_left")) == "lantern", "reset_session must preserve boat decor")
		game_state.begin_voyage("평온")
		_expect(str(game_state.call("get_boat_decor", "bow_left")) == "lantern", "begin_voyage must preserve boat decor")
		game_state.call("set_boat_decor", "bow_left", "")
		_expect(str(game_state.call("get_boat_decor", "bow_left")) == "", "empty item id must clear a decor slot without loss")

	_expect(int(game_state.companion_affection) == before_affection, "decor placement must not change companion affection")
	_expect(game_state.photos.size() == before_photos, "decor placement must not create photo rewards")
	_expect(game_state.sceneries.size() == before_sceneries, "decor placement must not create scenery rewards")
	_expect(game_state.letters.size() == before_letters, "decor placement must not create letter rewards")
	_expect(game_state.fish.size() == before_fish, "decor placement must not create fish rewards")
	_expect(game_state.voyage_records.size() == before_records, "decor placement must not create voyage records")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_SAVE_PATH))

	const catalog_path := "res://scripts/decor/boat_decor_catalog.gd"
	_expect(ResourceLoader.exists(catalog_path), "boat decor catalog script must exist")
	if ResourceLoader.exists(catalog_path):
		var catalog_script := load(catalog_path)
		_expect(catalog_script != null, "boat decor catalog script must load")
		if catalog_script != null:
			var catalog = catalog_script.new()
			_expect(catalog.has_method("get_slot_ids"), "catalog must expose get_slot_ids")
			_expect(catalog.has_method("get_item_ids"), "catalog must expose get_item_ids")
			_expect(catalog.has_method("get_compatible_item_ids"), "catalog must expose get_compatible_item_ids")
			_expect(catalog.has_method("is_compatible"), "catalog must expose is_compatible")

			if catalog.has_method("get_slot_ids"):
				var actual_slots: Array = catalog.call("get_slot_ids")
				var expected_slots: Array[String] = [
					"bow_left",
					"bow_right",
					"center_left",
					"center_right",
					"rear_left",
					"rear_right",
					"rail_accent",
					"pet_corner",
				]
				_expect(actual_slots == expected_slots, "catalog must expose exactly the approved eight slot zones")

			if catalog.has_method("get_item_ids"):
				var item_ids: Array = catalog.call("get_item_ids")
				for required_item in ["lantern", "mug", "cushion", "plant", "postcard", "pet_cushion"]:
					_expect(item_ids.has(required_item), "starter decor item missing: %s" % required_item)

			if catalog.has_method("is_compatible"):
				_expect(bool(catalog.call("is_compatible", "bow_left", "lantern")), "bow_left must accept lantern")
				_expect(bool(catalog.call("is_compatible", "rear_right", "lantern")), "rear_right must accept lantern")
				_expect(bool(catalog.call("is_compatible", "center_left", "cushion")), "center_left must accept cushion")
				_expect(bool(catalog.call("is_compatible", "rail_accent", "postcard")), "rail_accent must accept postcard")
				_expect(bool(catalog.call("is_compatible", "pet_corner", "pet_cushion")), "pet_corner must accept pet cushion")
				_expect(not bool(catalog.call("is_compatible", "pet_corner", "postcard")), "pet_corner must reject postcard")
				_expect(not bool(catalog.call("is_compatible", "rail_accent", "lantern")), "rail_accent must reject lantern")
				_expect(not bool(catalog.call("is_compatible", "missing_slot", "mug")), "unknown slot must reject placement")
				_expect(not bool(catalog.call("is_compatible", "bow_left", "missing_item")), "unknown item must reject placement")

	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: boat decoration contract")
		quit(0)
	else:
		printerr("FAILED: %d boat decoration assertions" % _failures)
		quit(1)
