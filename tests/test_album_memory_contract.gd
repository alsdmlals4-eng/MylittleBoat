# 앨범이 물고기와 항해 기록까지 개인적인 기억으로 보여주는지 검증한다.
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

	game_state.photos.clear()
	game_state.sceneries.clear()
	game_state.letters.clear()
	game_state.fish.clear()
	game_state.voyage_records.clear()
	game_state.companion_affection = 1
	game_state.add_fish("정어리")
	game_state.voyage_records.append("평온의 항해 · 사진 0 · 풍경 0 · 편지 0 · 물고기 1")

	var packed_scene := load("res://scenes/album.tscn") as PackedScene
	_expect(packed_scene != null, "album.tscn must load")
	if packed_scene == null:
		_finish()
		return

	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame
	var summary := scene.get_node_or_null("Margin/Panel/VBox/SummaryLabel") as Label
	var recent_memory := scene.get_node_or_null("Margin/Panel/VBox/RecentMemoryLabel") as Label
	_expect(summary != null, "Album must expose SummaryLabel")
	_expect(recent_memory != null, "Album must expose recent voyage memories")
	if summary != null:
		_expect("물고기 앨범: 1마리" in summary.text, "Album must show fish memory count")
		_expect("항해 기록: 1회" in summary.text, "Album must show voyage record count")
	if recent_memory != null:
		_expect("최근 물고기: 정어리" in recent_memory.text, "Album must show the most recent fish memory")
		_expect("최근 항해: 평온의 항해" in recent_memory.text, "Album must show the most recent voyage memory")

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
		print("PASS: album memory contract")
		quit(0)
	else:
		printerr("FAILED: %d album memory assertions" % _failures)
		quit(1)
