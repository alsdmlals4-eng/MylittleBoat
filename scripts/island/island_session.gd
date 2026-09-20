# 섬의 실행 중 상태·시계·저장 확정과 관측 이벤트를 소유한다.
extends Node

signal state_changed(snapshot: Dictionary)
signal action_committed(result: Dictionary)
signal storage_blocked(status: String)

const AUTOSAVE_SECONDS := 30.0
var _farm: RefCounted
var _store: RefCounted
var _utc_now: Callable
var _ticks_now: Callable
var _working := {}
var _durable := {}
var _initial := {}
var _last_ticks := NAN
var _pause_utc := NAN
var _autosave_elapsed := 0.0
var _foreground := true
var _editable := false
var _busy := false
var _started := false
var _blocked_notified := false

func configure(farm: RefCounted, store: RefCounted, utc_now: Callable, ticks_now: Callable) -> void:
	if _started or _busy: return
	_farm = farm
	_store = store
	_utc_now = utc_now
	_ticks_now = ticks_now

func _clock(source: Callable) -> float:
	if not source.is_valid(): return NAN
	var value: Variant = source.call()
	if not (typeof(value) in [TYPE_FLOAT, TYPE_INT]): return NAN
	return float(value) if is_finite(float(value)) and value >= 0 else NAN

func start() -> Dictionary:
	if _started or _busy: return {"status": "BUSY"}
	if _farm == null or _store == null: return {"status": "NOT_CONFIGURED"}
	_started = true
	_busy = true
	var result := _reload()
	_busy = false
	return result

func retry_load() -> Dictionary:
	if _busy: return {"status": "BUSY"}
	if not _started: return {"status": "LOCKED"}
	_busy = true
	var result := _reload()
	_busy = false
	return result

func recover_storage() -> Dictionary:
	if _busy: return {"status": "BUSY"}
	if not _started or _editable: return {"status": "LOCKED"}
	_busy = true
	var result: Dictionary = _store.recover()
	if result.status == "COMMITTED": result = _reload()
	else: _block(result.status)
	_busy = false
	return result.duplicate(true)

func _reload() -> Dictionary:
	var result: Dictionary = _store.load_state()
	var now := _clock(_utc_now)
	var loaded: Variant = result.get("snapshot", {})
	_editable = false
	_working = loaded.duplicate(true) if _farm.validate_snapshot(loaded) else {}
	_durable = _working.duplicate(true)
	_initial = {}
	_last_ticks = _clock(_ticks_now)
	_pause_utc = now
	_autosave_elapsed = 0.0
	if result.status in ["OK", "ABSENT"] and is_finite(now):
		if result.status == "ABSENT":
			_working = _farm.new_snapshot(now)
			_initial = _working.duplicate(true)
			_durable = {}
		elif _working.is_empty():
			_block("CORRUPT")
			return {"status": "CORRUPT"}
		else:
			_working = _farm.advance_elapsed(_working, maxf(0.0, now - _working.saved_at_utc))
		_editable = true
		_blocked_notified = false
		state_changed.emit(snapshot())
	else:
		if result.status in ["OK", "ABSENT"]: result = {"status": "INVALID_CLOCK"}
		_block(result.status)
	return result.duplicate(true)

func snapshot() -> Dictionary:
	return _working.duplicate(true)

func can_edit() -> bool:
	return _editable and _foreground and not _busy

func _reconcile() -> void:
	var now := _clock(_ticks_now)
	var elapsed := maxf(0.0, now - _last_ticks) if is_finite(now) and is_finite(_last_ticks) else 0.0
	_last_ticks = now
	_working = _farm.advance_elapsed(_working, elapsed)
	_autosave_elapsed += elapsed

func tick() -> void:
	if not can_edit(): return
	_busy = true
	_reconcile()
	if _autosave_elapsed >= AUTOSAVE_SECONDS and not _durable.is_empty():
		_commit(_working)
	else:
		state_changed.emit(snapshot())
	_busy = false

func set_foreground(value: bool) -> void:
	if _busy or not _started or value == _foreground: return
	_busy = true
	if not value:
		if _editable: _reconcile()
		_pause_utc = _clock(_utc_now)
		if _editable: _flush_current()
		_foreground = false
	else:
		var now := _clock(_utc_now)
		if _editable and is_finite(now) and is_finite(_pause_utc):
			_working = _farm.advance_elapsed(_working, maxf(0.0, now - _pause_utc))
		_last_ticks = _clock(_ticks_now)
		_pause_utc = NAN
		_foreground = true
		state_changed.emit(snapshot())
	_busy = false

func request_action(plot_id: String, action: String, crop_id: String, expected_generation: int, expected_revision: int) -> Dictionary:
	if _busy: return {"status": "BUSY"}
	if not can_edit(): return {"status": "LOCKED"}
	_busy = true
	_reconcile()
	var candidate: Dictionary = _farm.preview_command(_working, plot_id, action, crop_id, expected_generation, expected_revision)
	if candidate.status != "APPLIED":
		_busy = false
		return candidate
	var result := _commit(candidate.snapshot)
	if result.status == "COMMITTED":
		action_committed.emit({"status": "COMMITTED", "action": action, "plot_id": plot_id, "revision": _working.revision})
	_busy = false
	return result.duplicate(true)

func flush() -> Dictionary:
	if _busy: return {"status": "BUSY"}
	if not can_edit(): return {"status": "LOCKED"}
	_busy = true
	_reconcile()
	var result := _flush_current()
	_busy = false
	return result

func _flush_current() -> Dictionary:
	if not is_finite(_clock(_utc_now)):
		_block("INVALID_CLOCK")
		return {"status": "INVALID_CLOCK"}
	# 새 농장은 첫 명령 전까지 파일을 만들지 않는다.
	if _durable.is_empty(): return {"status": "UNCHANGED"}
	return _commit(_working)

func _commit(candidate: Dictionary) -> Dictionary:
	var now := _clock(_utc_now)
	if not is_finite(now):
		_block("INVALID_CLOCK")
		return {"status": "INVALID_CLOCK"}
	var next := candidate.duplicate(true)
	next.saved_at_utc = now
	var result: Dictionary = _store.commit(next)
	if result.status == "COMMITTED":
		_durable = next.duplicate(true)
		_working = next.duplicate(true)
		_autosave_elapsed = 0.0
		state_changed.emit(snapshot())
	else:
		_block(result.status)
	return result

func _block(status: String) -> void:
	_editable = false
	_working = (_durable if not _durable.is_empty() else _initial).duplicate(true)
	state_changed.emit(snapshot())
	if not _blocked_notified:
		_blocked_notified = true
		storage_blocked.emit(status)

func set_player_pose(x: float, z: float, yaw: float) -> bool:
	if not can_edit() or not is_finite(x) or not is_finite(z) or not is_finite(yaw): return false
	_busy = true
	_working.player = {"x": x, "z": z, "yaw": yaw}
	state_changed.emit(snapshot())
	_busy = false
	return true
