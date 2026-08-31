<<<<<<< HEAD
# 포그라운드 시간만 저밀도 풍경을 진행시키는지 검증한다.
extends SceneTree

const DIRECTOR_PATH := "res://scripts/voyage/drift_scenery_director.gd"
const EXPECTED_MOTIF_IDS_BY_ATMOSPHERE := {
	"dawn": ["MLB-AMB-MOTIF-001"],
	"bright": ["MLB-AMB-MOTIF-002", "MLB-AMB-MOTIF-003"],
	"sunset": ["MLB-AMB-MOTIF-004", "MLB-AMB-MOTIF-005"],
	"night": ["MLB-AMB-MOTIF-006"],
}
const EXPECTED_BACKDROP_OFFSET_X_BY_MOTIF_ID := {
	"MLB-AMB-MOTIF-001": 8.0,
	"MLB-AMB-MOTIF-002": 8.0,
	"MLB-AMB-MOTIF-003": -8.0,
	"MLB-AMB-MOTIF-004": -8.0,
	"MLB-AMB-MOTIF-005": 8.0,
	"MLB-AMB-MOTIF-006": 8.0,
}
=======
# 전경에 머문 시간만 먼 풍경 기회로 바뀌는지 검증한다.
extends SceneTree

const DIRECTOR_PATH := "res://scripts/voyage/drift_scenery_director.gd"
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(ResourceLoader.exists(DIRECTOR_PATH), "drift scenery director must exist")
	if not ResourceLoader.exists(DIRECTOR_PATH):
		_finish()
		return
<<<<<<< HEAD
	var director = load(DIRECTOR_PATH).new()
	_expect(director.has_method("get_next_event_seconds_for_tests"), "director must expose its scheduled next opportunity for cadence regression checks")
	if director.has_method("get_next_event_seconds_for_tests"):
		var initial_wait_seconds: float = float(director.call("get_next_event_seconds_for_tests")) - director.get_foreground_elapsed_seconds()
		_expect(initial_wait_seconds >= 90.0 and initial_wait_seconds <= 150.0, "initial scenery opportunity must remain within the approved 90 to 150 second range")
	director.set_next_event_seconds_for_tests(2.0)
	director.set_foreground(false)
	_expect(director.advance(5.0, "bright").is_empty(), "background time must not create scenery")
	_expect(is_zero_approx(director.get_foreground_elapsed_seconds()), "background time must not accumulate")
	director.set_foreground(true)
	_expect(director.advance(1.0, "bright").is_empty(), "event must wait for foreground elapsed time")
	var event_seed := _find_event_seed("bright")
	_expect(event_seed >= 0, "a scheduled foreground opportunity must be able to create one low-density scenery event")
	if event_seed >= 0:
		seed(event_seed)
	var event := Dictionary(director.advance(1.0, "bright"))
	_expect(not event.is_empty(), "foreground elapsed time must create one low-density scenery event")
	_expect(not event.has("button"), "scenery event must not create interaction UI")
	_expect(not event.has("destination"), "scenery event must not create a destination")
	_expect(event.has("label") and event.has("save_memory") and event.has("motif_id") and event.has("backdrop_texture_path") and event.has("backdrop_offset_x"), "scenery event must expose its quiet label, local-memory choice, approved motif presentation, and portrait-safe backdrop offset")
	_expect(str(event.get("motif_id", "")) in EXPECTED_MOTIF_IDS_BY_ATMOSPHERE["bright"], "bright scenery must select one of its approved motifs")
	_expect(str(event.get("backdrop_texture_path", "")).begins_with("res://assets/images/runtime/voyage/ambient_motifs/"), "scenery event must point only to a canonical runtime motif asset")
	_expect(director.advance(0.0, "bright").is_empty(), "director must not emit more than one event per call")
	if director.has_method("get_next_event_seconds_for_tests"):
		var follow_up_wait_seconds: float = float(director.call("get_next_event_seconds_for_tests")) - director.get_foreground_elapsed_seconds()
		_expect(follow_up_wait_seconds >= 120.0 and follow_up_wait_seconds <= 180.0, "every consumed first opportunity must schedule the next low-density check 120 to 180 seconds later")
	var zero_event_seed := _find_zero_event_voyage_seed()
	_expect(zero_event_seed >= 0, "a five-minute foreground voyage must permit zero automatic scenery events")
	for atmosphere_id in EXPECTED_MOTIF_IDS_BY_ATMOSPHERE:
		var atmosphere_event := _find_event_for_atmosphere(str(atmosphere_id))
		_expect(not atmosphere_event.is_empty(), "%s must be able to emit an approved ambient motif" % atmosphere_id)
		if not atmosphere_event.is_empty():
			var motif_id := str(atmosphere_event.get("motif_id", ""))
			_expect(motif_id in EXPECTED_MOTIF_IDS_BY_ATMOSPHERE[atmosphere_id], "%s motif must match the active local-time atmosphere" % atmosphere_id)
			_expect(str(atmosphere_event.get("backdrop_texture_path", "")).contains("ambient_motifs"), "%s motif must name a canonical scenery texture" % atmosphere_id)
			_expect(is_equal_approx(float(atmosphere_event.get("backdrop_offset_x", 0.0)), float(EXPECTED_BACKDROP_OFFSET_X_BY_MOTIF_ID.get(motif_id, 0.0))), "%s motif must carry its verified portrait-safe backdrop offset" % atmosphere_id)
	_expect_immediate_bright_repeat_is_avoided()
	_finish()


func _find_event_seed(atmosphere_id: String) -> int:
	for candidate_seed in range(1, 257):
		var probe_director = load(DIRECTOR_PATH).new()
		seed(candidate_seed)
		probe_director.set_next_event_seconds_for_tests(0.0)
		if not Dictionary(probe_director.advance(0.1, atmosphere_id)).is_empty():
			return candidate_seed
	return -1


func _find_zero_event_voyage_seed() -> int:
	for candidate_seed in range(1, 257):
		var probe_director = load(DIRECTOR_PATH).new()
		probe_director.set_next_event_seconds_for_tests(90.0)
		seed(candidate_seed)
		var emitted_count := 0
		for _second in range(300):
			if not Dictionary(probe_director.advance(1.0, "bright")).is_empty():
				emitted_count += 1
		if emitted_count == 0:
			return candidate_seed
	return -1


func _find_event_for_atmosphere(atmosphere_id: String) -> Dictionary:
	var event_seed := _find_event_seed(atmosphere_id)
	if event_seed < 0:
		return {}
	var director = load(DIRECTOR_PATH).new()
	seed(event_seed)
	director.set_next_event_seconds_for_tests(0.0)
	return Dictionary(director.advance(0.1, atmosphere_id))


func _expect_immediate_bright_repeat_is_avoided() -> void:
	var event_seed := _find_event_seed("bright")
	_expect(event_seed >= 0, "bright event seed must exist for repetition guard")
	if event_seed < 0:
		return
	var director = load(DIRECTOR_PATH).new()
	seed(event_seed)
	director.set_next_event_seconds_for_tests(0.0)
	var first_event := Dictionary(director.advance(0.1, "bright"))
	director.set_next_event_seconds_for_tests(0.0)
	seed(event_seed)
	var second_event := Dictionary(director.advance(0.1, "bright"))
	_expect(str(first_event.get("motif_id", "")) != str(second_event.get("motif_id", "")), "bright scenery must avoid immediately repeating the same approved motif when another bright motif exists")


=======
	var director = load(DIRECTOR_PATH).new(12345)
	_expect(is_equal_approx(director.get_active_seconds(), 0.0), "new scenery director starts empty")
	director.advance(151.0, false)
	_expect(is_equal_approx(director.get_active_seconds(), 0.0), "background time must not advance scenery")
	var event: Dictionary = director.advance(151.0, true)
	_expect(is_equal_approx(director.get_active_seconds(), 151.0), "foreground time advances scenery")
	_expect(bool(event.get("show_scenery", false)), "first foreground window shows distant scenery")
	_expect(["buoy", "islet", "lighthouse"].has(str(event.get("scenery_id", ""))), "event must choose an approved distant scenery ID")
	_expect(not event.has("reward"), "scenery event must not expose a reward")
	_expect(event.has("save_memory") and event.get("save_memory") is bool, "event may only offer passive memory saving")
	_finish()


>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
<<<<<<< HEAD
		print("PASS: drift scenery director contract")
		quit(0)
	else:
		printerr("FAILED: %d drift scenery director assertions" % _failures)
=======
		print("PASS: drifting scenery director contract")
		quit(0)
	else:
		printerr("FAILED: %d drifting scenery assertions" % _failures)
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
		quit(1)
