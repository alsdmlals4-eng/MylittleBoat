# 네트워크 없이 지연 병편지 수락·전달·오류 흐름을 재현하는 로컬 fake client다.
extends RefCounted

const MIN_DELAY_SECONDS := 45.0
const MAX_DELAY_SECONDS := 210.0
const MAX_MESSAGE_CHARS := 400
const MAX_STRANGER_MESSAGES := 6

var _session = null
var _delay_seconds := 90.0
var _fake_now := 0.0
var _friend_available := false
var _drift_recipient_available := false
var _pending: Array[Dictionary] = []
var _delivered_ids: Dictionary = {}
var _local_drafts: Array[Dictionary] = []
var _thread_message_counts: Dictionary = {}
var _next_id := 1


func configure(session, deterministic_delay_seconds: float = 90.0) -> void:
	_session = session
	_delay_seconds = clampf(deterministic_delay_seconds, MIN_DELAY_SECONDS, MAX_DELAY_SECONDS)


func set_friend_available(value: bool) -> void:
	_friend_available = value


func set_drift_recipient_available(value: bool) -> void:
	_drift_recipient_available = value


func send_friend_bottle(text: String, sticker_id: String = "") -> Dictionary:
	if _session == null or not _session.has_method("can_use_friend_bottle") or not bool(_session.call("can_use_friend_bottle")):
		return _error("SESSION_NOT_ELIGIBLE")
	var validation := _validate_message(text)
	if validation != "":
		return _error(validation)
	if not _friend_available:
		return _error("FRIEND_NOT_AVAILABLE")
	return _accept_bottle("friend", text, sticker_id, "")


func send_drift_bottle(text: String, sticker_id: String = "", thread_id: String = "") -> Dictionary:
	if _session == null or not _session.has_method("can_use_drift_bottle") or not bool(_session.call("can_use_drift_bottle")):
		return _error("SESSION_NOT_ELIGIBLE")
	var validation := _validate_message(text)
	if validation != "":
		return _error(validation)
	var resolved_thread_id := thread_id if thread_id != "" else "thread-%d" % _next_id
	var message_count := int(_thread_message_counts.get(resolved_thread_id, 0))
	if message_count >= MAX_STRANGER_MESSAGES:
		return {
			"status": "STRANGER_THREAD_LIMIT",
			"thread_id": resolved_thread_id,
		}
	if not _drift_recipient_available:
		_local_drafts.append({
			"status": "local_draft",
			"kind": "drift",
			"text": text,
			"sticker_id": sticker_id,
			"thread_id": resolved_thread_id,
		})
		return {
			"status": "NO_RECIPIENT_AVAILABLE",
			"thread_id": resolved_thread_id,
		}
	_thread_message_counts[resolved_thread_id] = message_count + 1
	return _accept_bottle("drift", text, sticker_id, resolved_thread_id)


func advance_time(seconds: float) -> void:
	_fake_now += maxf(seconds, 0.0)


func poll_inbox() -> Array[Dictionary]:
	var due: Array[Dictionary] = []
	for bottle in _pending:
		var bottle_id := str(bottle.get("id", ""))
		if bottle_id == "" or _delivered_ids.has(bottle_id):
			continue
		if float(bottle.get("deliver_at", INF)) <= _fake_now:
			due.append(bottle.duplicate(true))
			_delivered_ids[bottle_id] = true
	return due


func get_local_drafts() -> Array[Dictionary]:
	var result: Array[Dictionary] = []
	for draft in _local_drafts:
		result.append(draft.duplicate(true))
	return result


func get_thread_state(thread_id: String) -> String:
	return "friendship_gate" if int(_thread_message_counts.get(thread_id, 0)) >= MAX_STRANGER_MESSAGES else "open"


func get_fake_now() -> float:
	return _fake_now


func _accept_bottle(kind: String, text: String, sticker_id: String, thread_id: String) -> Dictionary:
	var bottle := {
		"id": "fake-bottle-%d" % _next_id,
		"status": "accepted",
		"kind": kind,
		"text": text,
		"sticker_id": sticker_id,
		"accepted_at": _fake_now,
		"deliver_at": _fake_now + _delay_seconds,
	}
	if thread_id != "":
		bottle["thread_id"] = thread_id
	_next_id += 1
	_pending.append(bottle)
	return bottle.duplicate(true)


func _validate_message(text: String) -> String:
	if text.strip_edges() == "":
		return "EMPTY_MESSAGE"
	if text.length() > MAX_MESSAGE_CHARS:
		return "MESSAGE_TOO_LONG"
	return ""


func _error(status: String) -> Dictionary:
	return {"status": status}
