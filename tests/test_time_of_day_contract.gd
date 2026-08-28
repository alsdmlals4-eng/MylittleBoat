# 현실 시간 분위기 ID와 비진행 원칙을 검증한다.
extends SceneTree

const CATALOG_PATH := "res://scripts/voyage/time_of_day_catalog.gd"
const RESOLVER_PATH := "res://scripts/voyage/real_time_atmosphere_resolver.gd"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(ResourceLoader.exists(CATALOG_PATH), "time-of-day catalog must exist")
	_expect(ResourceLoader.exists(RESOLVER_PATH), "real-time atmosphere resolver must exist")
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	if ResourceLoader.exists(RESOLVER_PATH):
		var resolver = load(RESOLVER_PATH).new()
		_expect(resolver.resolve_hour(5) == "dawn", "05:00 must be Dawn")
		_expect(resolver.resolve_hour(9) == "bright", "09:00 must be Bright")
		_expect(resolver.resolve_hour(17) == "sunset", "17:00 must be Sunset")
		_expect(resolver.resolve_hour(21) == "night", "21:00 must be Night")
		_expect(resolver.resolve_hour(0) == "night", "00:00 must be Night")
		_expect(resolver.resolve_hour(-1) == "bright", "invalid hour must safely fall back to Bright")
	if ResourceLoader.exists(CATALOG_PATH):
		var catalog = load(CATALOG_PATH).new()
		_expect(catalog.get_time_of_day_ids() == ["dawn", "bright", "sunset", "night"], "time IDs must remain approved and ordered")
		_expect(catalog.normalize_time_of_day("invalid") == "bright", "unknown time must fall back to Bright")
		_expect(catalog.get_label("night") == "밤", "catalog must label the Night state")
	if game_state != null:
		var before_affection: int = int(game_state.companion_affection)
		var before_photos: int = game_state.photos.size()
		var before_scenery: int = game_state.sceneries.size()
		var before_records: int = game_state.voyage_records.size()
		_expect(not game_state.has_method("select_time_of_day"), "GameState must not expose manual time selection")
		_expect(not game_state.has_method("get_selected_time_of_day"), "GameState must not store an atmosphere preference")
		if ResourceLoader.exists(RESOLVER_PATH):
			var resolver = load(RESOLVER_PATH).new()
			resolver.resolve_hour(5)
			resolver.resolve_hour(21)
		_expect(game_state.companion_affection == before_affection and game_state.photos.size() == before_photos and game_state.sceneries.size() == before_scenery and game_state.voyage_records.size() == before_records, "atmosphere resolution must not create progress")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: time-of-day contract")
		quit(0)
	else:
		printerr("FAILED: %d time-of-day assertions" % _failures)
		quit(1)
