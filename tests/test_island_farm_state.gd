# 섬 농사 규칙과 손상 입력을 독립 상태에서 검증한다.
extends SceneTree

var failures := 0
var checks := 0
var fixture := "user://test_island_catalog_%d_%d.json" % [OS.get_process_id(), Time.get_ticks_usec()]

func _init() -> void:
	call_deferred("_run")

func expect(value: bool, message: String) -> void:
	checks += 1
	if not value:
		failures += 1
		printerr("FAIL: " + message)

func _run() -> void:
	expect(ResourceLoader.exists("res://scripts/island/farm_state.gd"), "planned farm owner exists")
	if failures == 0:
		test_body()
	print("island_farm_state: %d checks, %d failures" % [checks, failures])
	quit(0 if failures == 0 else 1)

func test_body() -> void:
	var script: Variant = load("res://scripts/island/farm_state.gd")
	var catalog: Dictionary = script.load_catalog("res://data/island/crops.json")
	expect(catalog.status == "OK", "catalog accepted")
	if catalog.status != "OK": return
	var farm: Variant = script.new(catalog.crops)
	var empty: Dictionary = farm.new_snapshot(1000.0)
	expect(farm.validate_snapshot(empty), "new state valid")
	var planted: Dictionary = farm.preview_command(empty, "plot_01", "plant", "radish", 0, 0)
	expect(planted.status == "APPLIED", "plant")
	expect(empty.plots.plot_01.crop_id == "", "source immutable")
	var cared: Dictionary = farm.preview_command(planted.snapshot, "plot_01", "care", "", 1, 1)
	expect(cared.snapshot.plots.plot_01.elapsed_seconds == 36.0, "care adds 36 seconds")
	expect(farm.preview_command(cared.snapshot, "plot_01", "care", "", 1, 2).status == "ALREADY_CARED", "duplicate care denied")
	var grown: Dictionary = farm.advance_elapsed(cared.snapshot, 144.0)
	expect(farm.phase(grown.plots.plot_01) == "MATURE", "maturity")
	expect(farm.preview_command(grown, "plot_01", "care", "", 1, 2).status == "INVALID_PHASE", "mature care denied")
	var harvested: Dictionary = farm.preview_command(grown, "plot_01", "harvest", "", 1, 2)
	expect(harvested.snapshot.last_harvest_crop == "radish", "basket result")
	expect(farm.phase(harvested.snapshot.plots.plot_01) == "EMPTY", "harvest clears plot")
	var replanted: Dictionary = farm.preview_command(harvested.snapshot, "plot_01", "plant", "tomato", 1, 3)
	expect(farm.preview_command(replanted.snapshot, "plot_01", "harvest", "", 1, 4).status == "STALE_COMMAND", "old generation")
	expect(farm.preview_command(planted.snapshot, "plot_01", "care", "", 1, 0).status == "STALE_COMMAND", "old revision")
	for elapsed in [-1.0, NAN, INF]:
		expect(farm.advance_elapsed(planted.snapshot, elapsed) == planted.snapshot, "invalid delta unchanged")
	expect(farm.phase(farm.advance_elapsed(planted.snapshot, 44.0).plots.plot_01) == "SEEDLING", "before threshold")
	expect(farm.phase(farm.advance_elapsed(planted.snapshot, 45.0).plots.plot_01) == "YOUNG", "threshold")
	expect(farm.phase(farm.advance_elapsed(replanted.snapshot, 479.0).plots.plot_01) == "YOUNG", "tomato before maturity")
	expect(farm.phase(farm.advance_elapsed(replanted.snapshot, 480.0).plots.plot_01) == "MATURE", "tomato maturity")
	var decades: Dictionary = farm.advance_elapsed(replanted.snapshot, 315360000.0)
	expect(decades.plots.plot_01.elapsed_seconds == 480.0 and decades.last_harvest_crop == "radish", "offline caps current crop only")
	expect(decades.plots.plot_02 == empty.plots.plot_02, "other plot untouched")
	var custom: Dictionary = catalog.crops.duplicate(true)
	custom.radish.young_threshold = 0.5
	var custom_farm: Variant = script.new(custom)
	custom.radish.young_threshold = 0.1
	expect(custom_farm.phase(farm.advance_elapsed(planted.snapshot, 45.0).plots.plot_01) == "SEEDLING", "catalog copied and threshold consumed")
	expect(custom_farm.phase(farm.advance_elapsed(planted.snapshot, 90.0).plots.plot_01) == "YOUNG", "custom threshold boundary")
	for args in [["plot_07", "plant", "radish"], ["plot_01", "dance", ""], ["plot_01", "care", "radish"]]:
		expect(farm.preview_command(empty, args[0], args[1], args[2], 0, 0).status == "INVALID_COMMAND", "invalid command")
	expect(farm.preview_command(empty, "plot_01", "plant", "unknown", 0, 0).status == "INVALID_CROP", "unknown crop")
	for action in ["care", "harvest"]:
		expect(farm.preview_command(empty, "plot_01", action, "", 0, 0).status == "INVALID_PHASE", "empty action")
	for action in ["plant", "harvest"]:
		expect(farm.preview_command(planted.snapshot, "plot_01", action, "radish" if action == "plant" else "", 1, 1).status == "INVALID_PHASE", "growing action")
	for key in ["schema_version", "revision"]:
		for value in [true, 1.0, -1, "1", null]:
			var bad: Dictionary = empty.duplicate(true)
			bad[key] = value
			expect(not farm.validate_snapshot(bad), "strict integer " + key)
	for value in [-1.0, NAN, INF, "0", true]:
		var bad: Dictionary = empty.duplicate(true)
		bad.saved_at_utc = value
		expect(not farm.validate_snapshot(bad), "invalid timestamp")
	for value in [-1, 1.0, true, 9007199254740992]:
		var bad: Dictionary = empty.duplicate(true)
		bad.plots.plot_01.generation = value
		expect(not farm.validate_snapshot(bad), "invalid generation")
	for key in ["x", "z", "yaw"]:
		var bad: Dictionary = empty.duplicate(true)
		bad.player[key] = NAN
		expect(not farm.validate_snapshot(bad), "invalid pose")
	for value in [-1.0, NAN, 181.0]:
		var bad: Dictionary = planted.snapshot.duplicate(true)
		bad.plots.plot_01.elapsed_seconds = value
		expect(not farm.validate_snapshot(bad), "invalid elapsed")
	for mutation in ["extra", "missing", "unknown_crop", "empty_cared"]:
		var bad: Dictionary = empty.duplicate(true)
		match mutation:
			"extra": bad.extra = 1
			"missing": bad.plots.erase("plot_06")
			"unknown_crop": bad.plots.plot_01.crop_id = "alien"
			"empty_cared": bad.plots.plot_01.cared = true
		expect(not farm.validate_snapshot(bad), "malformed shape " + mutation)
		expect(farm.preview_command(bad, "plot_01", "plant", "radish", 0, 0).status == "INVALID_STATE", "malformed command input")
	for key in ["revision", "generation"]:
		var limit: Dictionary = empty.duplicate(true)
		if key == "revision": limit.revision = 9007199254740991
		else: limit.plots.plot_01.generation = 9007199254740991
		expect(farm.preview_command(limit, "plot_01", "plant", "radish", limit.plots.plot_01.generation, limit.revision).status == "COUNTER_LIMIT", "counter overflow prevented")
	planted.snapshot.plots.plot_01.crop_id = "tomato"
	expect(cared.snapshot.plots.plot_01.crop_id == "radish", "output detached")
	expect(not FileAccess.file_exists(fixture), "fixture collision abort")
	if FileAccess.file_exists(fixture): return
	for number in ["1", "1.0", "true", "\"1\"", "1.5", "null", "1e999"]:
		var file := FileAccess.open(fixture, FileAccess.WRITE)
		file.store_string('{"schema_version":%s,"crops":%s}' % [number, JSON.stringify(catalog.crops)])
		file.close()
		var previous := Engine.print_error_messages
		if number == "1e999": Engine.print_error_messages = false # 의도한 overflow 파싱 진단만 격리한다.
		var result: Dictionary = script.load_catalog(fixture)
		Engine.print_error_messages = previous
		expect(result.status == ("OK" if number in ["1", "1.0"] else "INVALID_CATALOG"), "catalog schema " + number)
	expect(DirAccess.remove_absolute(fixture) == OK, "fixture cleanup")
