# 먼 풍경 원화가 실제 화면 레이어에 소비되는지 검증한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	_expect(packed_scene != null, "game scene must load")
	if packed_scene == null:
		_finish()
		return
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame
	var layer := scene.get_node_or_null("DistantSceneryLayer") as Control
	_expect(layer != null, "game scene must expose a shared distant-scenery layer")
	_expect(scene.has_method("_spawn_distant_scenery"), "game scene must consume distant scenery events")
	if layer != null and scene.has_method("_spawn_distant_scenery"):
		scene.call("_spawn_distant_scenery", "islet", false)
		await process_frame
		_expect(layer.get_child_count() == 1, "islet event must create exactly one screen-space distant scenery prop")
		if layer.get_child_count() == 1:
			var prop := layer.get_child(0) as TextureRect
			_expect(prop.texture != null, "distant scenery prop must receive a runtime texture")
			_expect(prop.position.y + prop.size.y <= 400.0, "distant scenery must stay at or above the horizon band")
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
		print("PASS: distant scenery runtime contract")
		quit(0)
	else:
		printerr("FAILED: %d distant scenery runtime assertions" % _failures)
		quit(1)
