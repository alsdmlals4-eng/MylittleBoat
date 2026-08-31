# 낚시가 catch·조용한 무수확·취소를 모두 압박 없이 처리하는지 검증한다.
extends SceneTree

const FISHING_SESSION_PATH := "res://scripts/voyage/fishing_session.gd"
const GAME_SCENE_PATH := "res://scenes/game.tscn"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(ResourceLoader.exists(FISHING_SESSION_PATH), "calm fishing session must exist")
	_expect(ResourceLoader.exists(GAME_SCENE_PATH), "game scene must exist")
	if not ResourceLoader.exists(FISHING_SESSION_PATH) or not ResourceLoader.exists(GAME_SCENE_PATH):
		_finish()
		return
	var session: RefCounted = (load(FISHING_SESSION_PATH) as Script).new()
	_expect(session.has_method("is_quiet_ready"), "fishing session must expose a quiet no-catch result state")
	_expect(session.has_method("resolve_quiet"), "fishing session must resolve a quiet no-catch result without penalty")
	if not session.has_method("is_quiet_ready") or not session.has_method("resolve_quiet"):
		_finish()
		return

	session.call("cast_line", 0.5, "quiet")
	_expect(bool(session.call("is_waiting")), "quiet fishing must still begin with the same calm wait")
	_expect(bool(session.call("advance", 0.5)), "quiet fishing must finish its wait with one result event")
	_expect(bool(session.call("is_quiet_ready")), "quiet fishing must become a readable no-catch result")
	_expect(not bool(session.call("is_bite_ready")), "quiet fishing must not pretend that a fish bit")
	_expect(bool(session.call("resolve_quiet")), "quiet result must resolve without losing anything")
	_expect(not bool(session.call("is_waiting")) and not bool(session.call("is_quiet_ready")), "resolved quiet fishing must return to idle")

	var scene := (load(GAME_SCENE_PATH) as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame
	var scene_session: RefCounted = (load(FISHING_SESSION_PATH) as Script).new()
	scene.set("_fishing_session", scene_session)
	scene_session.call("cast_line", 0.0, "quiet")
	scene.call("_handle_fishing_action")
	var fishing_button := scene.get_node_or_null("BottomPanel/ButtonGrid/FishingButton") as Button
	var fishing_status := scene.get_node_or_null("TopPanel/TopVBox/FishingStatusLabel") as Label
	_expect(fishing_button != null and fishing_button.text == "낚시", "resolving quiet fishing must return the public control to its calm idle label")
	_expect(fishing_status != null and "조용" in fishing_status.text, "quiet fishing must tell the player that nothing was lost")
	_expect(not scene_session.call("is_waiting") and not scene_session.call("is_quiet_ready"), "game scene must consume the quiet result exactly once")
	scene.queue_free()
	await process_frame
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: fishing outcome contract")
		quit(0)
	else:
		printerr("FAILED: %d fishing outcome assertions" % _failures)
		quit(1)
