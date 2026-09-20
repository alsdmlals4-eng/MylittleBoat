# 섬 세션의 시계·저장 확정·실패 잠금·재진입을 검증한다.
extends SceneTree

const Farm = preload("res://scripts/island/farm_state.gd")
var failures := 0
var checks := 0
var completed := false

class FakeClock extends RefCounted:
	var utc := 1000.0
	var ticks := 0.0
	func utc_now() -> float: return utc
	func ticks_now() -> float: return ticks

class FakeStore extends RefCounted:
	var saved := {}
	var fail := false
	var writes := 0
	var read_status := ""
	func load_state() -> Dictionary:
		return {"status": read_status if read_status != "" else ("ABSENT" if saved.is_empty() else "OK"), "snapshot": saved.duplicate(true), "error": OK}
	func commit(value: Dictionary) -> Dictionary:
		writes += 1
		if fail: return {"status": "NOT_COMMITTED", "error": ERR_FILE_CANT_WRITE}
		saved = value.duplicate(true)
		return {"status": "COMMITTED", "error": OK}
	func recover() -> Dictionary:
		read_status = ""
		return {"status": "COMMITTED", "error": OK}

func _init() -> void: call_deferred("run")
func expect(value: bool, message: String) -> void:
	checks += 1
	if not value:
		failures += 1
		printerr("FAIL: " + message)

func run() -> void:
	expect(ResourceLoader.exists("res://scripts/island/island_session.gd"), "planned island session exists")
	if failures == 0:
		test_body()
		expect(completed, "test body completed")
	print("island_session: %d checks, %d failures" % [checks, failures])
	quit(0 if failures == 0 else 1)

func test_body() -> void:
	var script: Variant = load("res://scripts/island/island_session.gd")
	var farm := Farm.new(Farm.load_catalog("res://data/island/crops.json").crops)
	var clock := FakeClock.new()
	var store := FakeStore.new()
	var session: Variant = script.new()
	session.configure(farm, store, clock.utc_now, clock.ticks_now)
	expect(session.start().status == "ABSENT", "new session")
	expect(session.start().status == "BUSY", "duplicate start")
	clock.ticks = 100.0
	session.tick()
	expect(store.writes == 0, "empty initial state not autosaved")
	clock.ticks = 0.0
	session.tick()
	var events := [0]
	var blocked := [0]
	session.action_committed.connect(func(_value): events[0] += 1)
	session.storage_blocked.connect(func(_value): blocked[0] += 1)
	expect(session.request_action("plot_01", "plant", "radish", 0, 0).status == "COMMITTED", "plant persisted")
	expect(events[0] == 1 and store.saved.revision == 1, "event only committed state")
	clock.ticks = 10.0
	clock.utc = 1010.0
	session.tick()
	expect(session.snapshot().plots.plot_01.elapsed_seconds == 10.0, "foreground grows")
	session.set_foreground(false)
	var writes := store.writes
	session.set_foreground(false)
	expect(store.writes == writes, "duplicate pause no save")
	expect(session.request_action("plot_01", "care", "", 1, 1).status == "LOCKED", "background input locked")
	clock.utc = 1030.0
	clock.ticks = 30.0
	session.tick()
	expect(session.snapshot().plots.plot_01.elapsed_seconds == 10.0, "background polling stopped")
	session.set_foreground(true)
	session.set_foreground(true)
	expect(session.snapshot().plots.plot_01.elapsed_seconds == 30.0, "resume once")
	var prior := store.saved.duplicate(true)
	store.fail = true
	session.request_action("plot_01", "care", "", 1, 1)
	expect(not session.can_edit() and session.snapshot() == prior, "save failure rolls back and locks")
	expect(store.saved == prior and events[0] == 1, "failure no event or save")
	session.flush()
	expect(blocked[0] == 1, "one block transition")
	store.fail = false
	session.retry_load()
	expect(not session.snapshot().plots.plot_01.cared, "retry no replay")
	expect(session.snapshot().plots.plot_01.elapsed_seconds == 30.0, "reload offline once")
	clock.utc = 900000.0
	clock.ticks = 35.0
	session.tick()
	expect(session.snapshot().plots.plot_01.elapsed_seconds == 35.0, "active UTC jump ignored")
	var external: Dictionary = session.snapshot()
	external.plots.plot_01.elapsed_seconds = 0.0
	expect(session.snapshot().plots.plot_01.elapsed_seconds == 35.0, "snapshot detached")
	var reentered := [""]
	var mutation = func(value: Dictionary):
		value.plots.plot_01.crop_id = "alien"
		reentered[0] = session.request_action("plot_02", "plant", "radish", 0, 1).status
	session.state_changed.connect(mutation)
	session.request_action("plot_01", "care", "", 1, 1)
	expect(reentered[0] == "BUSY", "signal reentry blocked")
	expect(session.snapshot().plots.plot_01.crop_id == "radish" and store.saved.plots.plot_02.crop_id == "", "signal cannot alter state")
	session.state_changed.disconnect(mutation)
	expect(session.set_player_pose(2.0, -3.0, 0.5), "valid pose")
	expect(not session.set_player_pose(INF, 0.0, 0.0), "invalid pose")
	writes = store.writes
	clock.ticks += 95.0
	session.tick()
	expect(store.writes == writes + 1, "missed autosave intervals coalesce")
	expect(store.saved.player.x == 2.0, "pose persisted")
	expect(events[0] == 2, "autosave no action event")
	session.free()
	clock.utc = store.saved.saved_at_utc + 315360000.0
	var restart: Variant = script.new()
	restart.configure(farm, store, clock.utc_now, clock.ticks_now)
	restart.start()
	expect(restart.snapshot().plots.plot_01.elapsed_seconds == 180.0, "decade offline capped")
	expect(restart.snapshot().last_harvest_crop == "", "offline no harvest")
	restart.free()
	clock.utc = 0.0
	restart = script.new()
	restart.configure(farm, store, clock.utc_now, clock.ticks_now)
	restart.start()
	expect(restart.snapshot().plots.plot_01.elapsed_seconds == store.saved.plots.plot_01.elapsed_seconds, "UTC reversal no loss")
	var elapsed: float = restart.snapshot().plots.plot_01.elapsed_seconds
	for tick_value in [NAN, INF, -1.0, 0.0]:
		clock.ticks = tick_value
		restart.tick()
		expect(restart.snapshot().plots.plot_01.elapsed_seconds == elapsed, "invalid/rebased clock no elapsed")
	clock.utc = NAN
	restart.flush()
	expect(not restart.can_edit(), "nonfinite UTC blocks write")
	expect(is_finite(store.saved.saved_at_utc), "nonfinite never stored")
	restart.free()
	for status in ["CORRUPT", "IO_ERROR", "UNSUPPORTED_VERSION", "RECOVERY_REQUIRED"]:
		var locked_store := FakeStore.new()
		locked_store.read_status = status
		var locked: Variant = script.new()
		clock.utc = 1000.0
		locked.configure(farm, locked_store, clock.utc_now, clock.ticks_now)
		locked.start()
		expect(not locked.can_edit() and locked.snapshot().is_empty(), "bad load not fresh game " + status)
		locked.tick()
		locked.flush()
		expect(locked_store.writes == 0, "bad load no writes " + status)
		locked.free()
	var first_store := FakeStore.new()
	first_store.fail = true
	var first: Variant = script.new()
	first.configure(farm, first_store, clock.utc_now, clock.ticks_now)
	first.start()
	first.request_action("plot_01", "plant", "radish", 0, 0)
	expect(not first.can_edit() and first.snapshot().plots.plot_01.crop_id == "", "failed first action no speculative crop")
	first_store.fail = false
	first_store.read_status = "RECOVERY_REQUIRED"
	first.retry_load()
	expect(not first.can_edit(), "receipt blocks retry")
	first.recover_storage()
	expect(first.can_edit() and first_store.saved.is_empty(), "explicit recovery absent without automatic commit")
	first.free()
	# 실제 ConfigFile backend와 두 Session을 연결해 가짜 저장소에만 의존하지 않는다.
	var directory := "user://test_island_session_%d_%d" % [OS.get_process_id(), Time.get_ticks_usec()]
	expect(not DirAccess.dir_exists_absolute(directory), "integration collision")
	if DirAccess.dir_exists_absolute(directory): return
	expect(DirAccess.make_dir_recursive_absolute(directory) == OK, "integration directory")
	var save_script: Variant = load("res://scripts/island/island_save_store.gd")
	var disk_store: Variant = save_script.new(directory.path_join("farm.cfg"), farm)
	clock.utc = 2000.0
	clock.ticks = 0.0
	var disk_session: Variant = script.new()
	disk_session.configure(farm, disk_store, clock.utc_now, clock.ticks_now)
	disk_session.start()
	expect(disk_session.request_action("plot_02", "plant", "tomato", 0, 0).status == "COMMITTED", "real plant transaction")
	disk_session.free()
	clock.utc = 2480.0
	disk_session = script.new()
	disk_session.configure(farm, disk_store, clock.utc_now, clock.ticks_now)
	disk_session.start()
	expect(disk_session.snapshot().plots.plot_02.elapsed_seconds == 480.0, "real restart growth")
	expect(disk_session.request_action("plot_02", "harvest", "", 1, 1).status == "COMMITTED", "real harvest commit")
	expect(disk_store.load_state().snapshot.last_harvest_crop == "tomato", "basket survives disk reload")
	expect(disk_session.request_action("plot_02", "harvest", "", 1, 1).status == "STALE_COMMAND", "duplicate real harvest denied")
	disk_session.free()
	var owned_files: Array[String] = []
	for name in DirAccess.get_files_at(directory): owned_files.append(directory.path_join(name))
	for path in owned_files: expect(DirAccess.remove_absolute(path) == OK, "integration cleanup")
	expect(DirAccess.remove_absolute(directory) == OK, "integration directory cleanup")
	completed = true
