# 외형 프로필의 기본값·정규화·독립 저장을 검증한다.
extends SceneTree

const CATALOG_PATH := "res://scripts/identity/identity_visual_catalog.gd"
const PROFILE_PATH := "res://scripts/core/cosmetic_identity_profile.gd"
const TEST_SAVE_PATH := "user://identity_profile_contract.cfg"
const GAME_STATE_TEST_SAVE_PATH := "user://identity_game_state_contract.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_remove_test_save()
	_remove_game_state_test_save()
	_expect(ResourceLoader.exists(CATALOG_PATH), "identity catalog must exist")
	_expect(ResourceLoader.exists(PROFILE_PATH), "cosmetic identity profile must exist")
	if ResourceLoader.exists(CATALOG_PATH) and ResourceLoader.exists(PROFILE_PATH):
		var catalog = load(CATALOG_PATH).new()
		var profile = load(PROFILE_PATH).new(TEST_SAVE_PATH)
		_expect(catalog.get_player_style_ids() == ["a_soft_hooded", "b_short_cape", "c_loose_knit"], "player IDs must remain approved and ordered")
		_expect(catalog.get_pet_type_ids() == ["cat", "rabbit", "otter", "dog"], "pet IDs must remain approved and ordered")
		_expect(profile.load() == {"player_style_id": "c_loose_knit", "pet_type_id": "dog"}, "missing profile must use C + dog")
		_expect(profile.save("b_short_cape", "otter") == OK, "valid cosmetic identity must save")
		_expect(profile.load() == {"player_style_id": "b_short_cape", "pet_type_id": "otter"}, "saved identity must restore exactly")
		_expect(profile.save("unknown", "fox") == OK, "unknown values normalize rather than fail")
		_expect(profile.load() == {"player_style_id": "c_loose_knit", "pet_type_id": "dog"}, "unknown values must normalize to defaults")
		var invalid := ConfigFile.new()
		invalid.set_value("identity", "player_style_id", 42)
		invalid.set_value("identity", "pet_type_id", [])
		_expect(invalid.save(TEST_SAVE_PATH) == OK, "test must create a corrupt typed profile")
		_expect(profile.load() == {"player_style_id": "c_loose_knit", "pet_type_id": "dog"}, "corrupt profile must fall back safely")
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	if game_state != null:
		_expect(game_state.has_method("get_selected_player_style"), "GameState must expose player identity getter")
		_expect(game_state.has_method("get_selected_pet_type"), "GameState must expose pet identity getter")
		_expect(game_state.has_method("set_selected_player_style"), "GameState must expose player identity setter")
		_expect(game_state.has_method("set_selected_pet_type"), "GameState must expose pet identity setter")
		_expect(game_state.has_method("set_identity_storage_path"), "GameState must expose isolated identity storage path")
		if game_state.has_method("set_identity_storage_path"):
			game_state.set_identity_storage_path(GAME_STATE_TEST_SAVE_PATH)
			game_state.set_selected_player_style("a_soft_hooded")
			game_state.set_selected_pet_type("rabbit")
			_expect(game_state.get_selected_player_style() == "a_soft_hooded", "GameState must retain selected player style")
			_expect(game_state.get_selected_pet_type() == "rabbit", "GameState must retain selected pet type")
			game_state.set_identity_storage_path("user://identity_profile_v1.cfg")
	_remove_test_save()
	_remove_game_state_test_save()
	_finish()


func _remove_test_save() -> void:
	if FileAccess.file_exists(TEST_SAVE_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(TEST_SAVE_PATH))


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
		print("PASS: cosmetic identity profile contract")
		quit(0)
	else:
		printerr("FAILED: %d cosmetic identity profile assertions" % _failures)
		quit(1)
