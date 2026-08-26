# 승인된 외형 이미지와 보트 디오라마 선택 경로를 검증한다.
extends SceneTree

const CATALOG_PATH := "res://scripts/identity/identity_visual_catalog.gd"
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
	_finish()


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
