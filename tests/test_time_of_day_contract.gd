# 항해 시간대 선택의 정규화와 비보상 상태를 검증한다.
extends SceneTree

const CATALOG_PATH := "res://scripts/voyage/time_of_day_catalog.gd"
const CAPTURE_PATH := "res://tests/capture_four_time_atmosphere.gd"
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
		_expect(game_state.has_method("select_time_of_day"), "GameState must expose a time selection setter")
		_expect(game_state.has_method("get_selected_time_of_day"), "GameState must expose a time selection getter")
		if game_state.has_method("select_time_of_day") and game_state.has_method("get_selected_time_of_day"):
			_expect(game_state.get_selected_time_of_day() == "bright", "fresh state must begin at Bright")
			var before_mood: String = str(game_state.selected_mood)
			var before_affection: int = int(game_state.companion_affection)
			var before_photos: int = game_state.photos.size()
			game_state.select_time_of_day("sunset")
			_expect(game_state.get_selected_time_of_day() == "sunset", "valid time must remain selected")
			_expect(game_state.selected_mood == before_mood, "time selection must not change mood")
			_expect(game_state.companion_affection == before_affection and game_state.photos.size() == before_photos, "time selection must not create progression")
		game_state.select_time_of_day("invalid")
		_expect(game_state.get_selected_time_of_day() == "bright", "invalid GameState value must normalize to Bright")
		game_state.selected_time_of_day = "corrupt"
		_expect(game_state.get_selected_time_of_day() == "bright", "corrupt public GameState value must read as Bright")
		game_state.select_time_of_day("bright")
	var capture_source := FileAccess.get_file_as_string(CAPTURE_PATH)
	_expect(capture_source.contains("get_time_of_day_ids"), "capture must use the catalog time ID source")
	_expect(not capture_source.contains("const TIME_OF_DAY_IDS"), "capture must not duplicate approved time IDs")
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
