# 앨범이 실제 기억과 현재 시간대 분위기를 분리해 보여주는지 검증한다.
extends SceneTree

const ALBUM_PATH := "res://scenes/album.tscn"
const NIGHT_BACKGROUND_PATH := "res://assets/images/runtime/storybook/sea_night_indigo_rain_storybook.png"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var game_state := root.get_node_or_null("GameState")
	_expect(game_state != null, "GameState autoload must exist")
	_expect(ResourceLoader.exists(ALBUM_PATH), "album scene must exist")
	if game_state == null or not ResourceLoader.exists(ALBUM_PATH):
		_finish()
		return
	game_state.photos.clear()
	game_state.sceneries.clear()
	game_state.letters.clear()
	game_state.fish.clear()
	game_state.voyage_records.clear()
	game_state.companion_affection = 1
	var scene := (load(ALBUM_PATH) as PackedScene).instantiate()
	root.add_child(scene)
	await process_frame
	var background := scene.get_node_or_null("AtmosphereBackground") as TextureRect
	var summary := scene.get_node_or_null("Margin/Panel/VBox/SummaryLabel") as Label
	var recent_memory := scene.get_node_or_null("Margin/Panel/VBox/RecentMemoryLabel") as Label
	_expect(background != null, "album must expose the approved atmosphere background surface")
	_expect(scene.has_method("apply_real_time_background_for_hour"), "album must resolve atmosphere from real time without a selector")
	if scene.has_method("apply_real_time_background_for_hour"):
		scene.call("apply_real_time_background_for_hour", 21)
		_expect(background != null and background.texture != null and background.texture.resource_path == NIGHT_BACKGROUND_PATH, "album Night background must follow the current real-time band")
	_expect(summary != null, "album must expose a total-memory summary")
	_expect(recent_memory != null, "album must expose a recent-memory summary")
	_expect(recent_memory != null and "아직 모아 둔 기억이 없어요" in recent_memory.text, "empty album must use the calm empty-state copy")
	game_state.add_fish("정어리")
	game_state.voyage_records.append("오늘의 항해 · 사진 0 · 풍경 0 · 편지 0 · 물고기 1")
	if scene.has_method("refresh_album"):
		scene.refresh_album()
	_expect(recent_memory != null and "최근 물고기: 정어리" in recent_memory.text, "recent-memory area must show the most recent fish")
	_expect(recent_memory != null and "최근 항해: 오늘의 항해" in recent_memory.text, "recent-memory area must show the most recent voyage")
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
		print("PASS: album composition contract")
		quit(0)
	else:
		printerr("FAILED: %d album composition assertions" % _failures)
		quit(1)
