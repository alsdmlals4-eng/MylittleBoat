# 지연 병편지 로컬 fake backend의 시간·수락·오류·6통 Gate 계약을 검증한다.
extends SceneTree

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	if game_state == null:
		_finish()
		return

	var session_path := "res://scripts/social/social_session_fake.gd"
	var client_path := "res://scripts/social/bottle_client_fake.gd"
	_expect(ResourceLoader.exists(session_path), "SocialSessionFake script must exist")
	_expect(ResourceLoader.exists(client_path), "BottleClientFake script must exist")
	if not ResourceLoader.exists(session_path) or not ResourceLoader.exists(client_path):
		_finish()
		return

	_assert_local_only_source(session_path)
	_assert_local_only_source(client_path)

	var session_script = load(session_path)
	var client_script = load(client_path)
	_expect(session_script != null, "SocialSessionFake must load")
	_expect(client_script != null, "BottleClientFake must load")
	if session_script == null or client_script == null:
		_finish()
		return

	game_state.reset_session()
	game_state.voyage_active = true
	game_state.remaining_seconds = 123.0
	game_state.speed_index = 1
	game_state.appreciation_mode = false
	game_state.boat_decor = {"bow_left": "lantern"}

	var before := _snapshot_core(game_state)

	var session = session_script.new()
	_expect(session.has_method("configure"), "session must expose configure")
	_expect(session.has_method("can_use_friend_bottle"), "session must expose FriendBottle eligibility")
	_expect(session.has_method("can_use_drift_bottle"), "session must expose DriftBottle eligibility")
	if not session.has_method("configure"):
		_finish()
		return
	session.call("configure", "linked_social", "16plus", true, 900.0, 1)
	_expect(bool(session.call("can_use_friend_bottle")), "linked 16plus session must be FriendBottle eligible")
	_expect(bool(session.call("can_use_drift_bottle")), "eligible linked session must be DriftBottle eligible")

	var client = client_script.new()
	_expect(client.has_method("configure"), "client must expose configure")
	_expect(client.has_method("send_friend_bottle"), "client must expose FriendBottle send")
	_expect(client.has_method("send_drift_bottle"), "client must expose DriftBottle send")
	_expect(client.has_method("advance_time"), "client must expose deterministic fake time advance")
	_expect(client.has_method("poll_inbox"), "client must expose polling")
	_expect(client.has_method("get_local_drafts"), "client must expose no-recipient local drafts")
	_expect(client.has_method("get_thread_state"), "client must expose stranger thread state")
	if not client.has_method("configure"):
		_finish()
		return

	client.call("configure", session, 90.0)
	client.call("set_friend_available", true)
	client.call("set_drift_recipient_available", true)

	var friend_result: Dictionary = client.call("send_friend_bottle", "오늘 바다가 잔잔하네요.", "")
	_expect(str(friend_result.get("status", "")) == "accepted", "eligible FriendBottle must be accepted")
	_expect(is_equal_approx(float(friend_result.get("deliver_at", -1.0)) - float(friend_result.get("accepted_at", -999.0)), 90.0), "accepted FriendBottle must use deterministic 90 second delay")
	_assert_no_realtime_fields(friend_result)
	_expect((client.call("poll_inbox") as Array).is_empty(), "accepted bottle must stay hidden before deliver_at")
	client.call("advance_time", 89.99)
	_expect((client.call("poll_inbox") as Array).is_empty(), "polling just before deliver_at must still return nothing")
	client.call("advance_time", 0.01)
	var due: Array = client.call("poll_inbox")
	_expect(due.size() == 1, "polling at deliver_at must return the accepted bottle")
	if due.size() == 1:
		_assert_no_realtime_fields(due[0])
	_expect((client.call("poll_inbox") as Array).is_empty(), "delivered bottle must not be returned twice")

	var low_delay_client = client_script.new()
	low_delay_client.call("configure", session, 44.0)
	low_delay_client.call("set_friend_available", true)
	var low_delay: Dictionary = low_delay_client.call("send_friend_bottle", "낮은 경계", "")
	_expect(is_equal_approx(float(low_delay.get("deliver_at", 0.0)) - float(low_delay.get("accepted_at", 0.0)), 45.0), "fake delay must clamp to approved minimum 45 seconds")
	var high_delay_client = client_script.new()
	high_delay_client.call("configure", session, 211.0)
	high_delay_client.call("set_friend_available", true)
	var high_delay: Dictionary = high_delay_client.call("send_friend_bottle", "높은 경계", "")
	_expect(is_equal_approx(float(high_delay.get("deliver_at", 0.0)) - float(high_delay.get("accepted_at", 0.0)), 210.0), "fake delay must clamp to approved maximum 210 seconds")

	var text_boundary_client = client_script.new()
	text_boundary_client.call("configure", session, 90.0)
	text_boundary_client.call("set_friend_available", true)
	var exactly_400: String = "가".repeat(400)
	var over_400: String = "가".repeat(401)
	_expect(str((text_boundary_client.call("send_friend_bottle", exactly_400, "") as Dictionary).get("status", "")) == "accepted", "400-character bottle text must remain valid")
	_expect(str((text_boundary_client.call("send_friend_bottle", over_400, "") as Dictionary).get("status", "")) == "MESSAGE_TOO_LONG", "401-character bottle text must be rejected")

	var no_recipient_client = client_script.new()
	no_recipient_client.call("configure", session, 90.0)
	no_recipient_client.call("set_drift_recipient_available", false)
	var no_recipient: Dictionary = no_recipient_client.call("send_drift_bottle", "누군가에게 닿기를", "", "thread-none")
	_expect(str(no_recipient.get("status", "")) == "NO_RECIPIENT_AVAILABLE", "DriftBottle without eligible recipient must not be accepted")
	var drafts: Array = no_recipient_client.call("get_local_drafts")
	_expect(drafts.size() == 1 and str((drafts[0] as Dictionary).get("text", "")) == "누군가에게 닿기를", "no-recipient DriftBottle must remain as a local draft")
	no_recipient_client.call("advance_time", 300.0)
	_expect((no_recipient_client.call("poll_inbox") as Array).is_empty(), "no-recipient draft must never appear as delivered")

	var drift_delay_client = client_script.new()
	drift_delay_client.call("configure", session, 75.0)
	drift_delay_client.call("set_drift_recipient_available", true)
	var drift_delayed: Dictionary = drift_delay_client.call("send_drift_bottle", "천천히 표류하는 편지", "", "thread-delay")
	_expect(str(drift_delayed.get("status", "")) == "accepted", "eligible DriftBottle must be accepted")
	_expect(is_equal_approx(float(drift_delayed.get("deliver_at", 0.0)) - float(drift_delayed.get("accepted_at", 0.0)), 75.0), "accepted DriftBottle must use the same delayed delivery contract")
	drift_delay_client.call("advance_time", 74.99)
	_expect((drift_delay_client.call("poll_inbox") as Array).is_empty(), "DriftBottle must stay hidden before deliver_at")
	drift_delay_client.call("advance_time", 0.01)
	_expect((drift_delay_client.call("poll_inbox") as Array).size() == 1, "DriftBottle must become pollable at deliver_at")

	var drift_client = client_script.new()
	drift_client.call("configure", session, 60.0)
	drift_client.call("set_drift_recipient_available", true)
	for index in range(6):
		var result: Dictionary = drift_client.call("send_drift_bottle", "조용한 편지 %d" % (index + 1), "", "thread-six")
		_expect(str(result.get("status", "")) == "accepted", "stranger thread message %d must be accepted before the six-letter gate" % (index + 1))
	_expect(str(drift_client.call("get_thread_state", "thread-six")) == "friendship_gate", "six accepted stranger letters must move thread to friendship_gate")
	var seventh: Dictionary = drift_client.call("send_drift_bottle", "일곱 번째 편지", "", "thread-six")
	_expect(str(seventh.get("status", "")) == "STRANGER_THREAD_LIMIT", "seventh stranger letter must be rejected")

	var underage_session = session_script.new()
	underage_session.call("configure", "linked_social", "under16", true, 900.0, 1)
	_expect(not bool(underage_session.call("can_use_friend_bottle")), "under16 fake session must not use FriendBottle")
	_expect(not bool(underage_session.call("can_use_drift_bottle")), "under16 fake session must not use DriftBottle")
	var local_session = session_script.new()
	local_session.call("configure", "local_only", "16plus", true, 900.0, 1)
	_expect(not bool(local_session.call("can_use_friend_bottle")), "local_only fake session must not use FriendBottle")
	_expect(not bool(local_session.call("can_use_drift_bottle")), "local_only fake session must not use DriftBottle")

	var after := _snapshot_core(game_state)
	_expect(before == after, "local social fake operations must not mutate voyage, rewards, memories, or boat decor")
	_finish()


func _snapshot_core(game_state: Node) -> Dictionary:
	return {
		"remaining_seconds": float(game_state.remaining_seconds),
		"speed_index": int(game_state.speed_index),
		"appreciation_mode": bool(game_state.appreciation_mode),
		"companion_affection": int(game_state.companion_affection),
		"photos": game_state.photos.duplicate(),
		"sceneries": game_state.sceneries.duplicate(),
		"letters": game_state.letters.duplicate(),
		"fish": game_state.fish.duplicate(),
		"voyage_records": game_state.voyage_records.duplicate(),
		"boat_decor": game_state.boat_decor.duplicate(true),
	}


func _assert_local_only_source(path: String) -> void:
	var file := FileAccess.open(path, FileAccess.READ)
	_expect(file != null, "social fake source must be readable: %s" % path)
	if file == null:
		return
	var source := file.get_as_text()
	for forbidden in ["HTTPRequest", "HTTPClient", "WebSocketPeer", "WebSocketMultiplayerPeer", "supabase", "SUPABASE", "service_role", "api_key"]:
		_expect(source.find(forbidden) == -1, "social fake must not include real network/backend surface: %s" % forbidden)


func _assert_no_realtime_fields(value: Variant) -> void:
	if not value is Dictionary:
		_expect(false, "bottle record must be a Dictionary")
		return
	var record := value as Dictionary
	for forbidden in ["typing", "presence", "read_receipt", "followers", "ranking", "public_feed"]:
		_expect(not record.has(forbidden), "fake bottle records must not expose realtime/social-pressure field: %s" % forbidden)


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: social fake backend contract")
		quit(0)
	else:
		printerr("FAILED: %d social fake backend assertions" % _failures)
		quit(1)
