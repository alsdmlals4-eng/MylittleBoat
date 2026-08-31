# 조용한 낚시와 동반자 휴식 상호작용의 실제 화면을 GPU 증거로 저장한다.
extends SceneTree

const GAME_SCENE_PATH := "res://scenes/game.tscn"
const FISHING_SESSION_SCRIPT = preload("res://scripts/voyage/fishing_session.gd")
const EVIDENCE_DIRECTORY := "res://docs/evidence/2026-08-31-calm-fishing-interactions"
const QUIET_FISHING_CAPTURE := "fishing_quiet_no_catch_540x960.png"
const PET_REST_CAPTURE := "pet_rest_together_540x960.png"


func _init() -> void:
	call_deferred("_capture")


func _capture() -> void:
	root.size = Vector2i(540, 960)
	if DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(EVIDENCE_DIRECTORY)) != OK:
		_fail("could not create calm fishing evidence directory")
		return
	var game_state := root.get_node_or_null("GameState")
	var packed_scene := load(GAME_SCENE_PATH) as PackedScene
	if game_state == null or packed_scene == null:
		_fail("GameState and game scene must load for calm interaction capture")
		return
	game_state.reset_session()
	game_state.voyage_active = true
	var scene := packed_scene.instantiate()
	root.add_child(scene)
	for _frame in 10:
		await process_frame
	scene.call("open_rest_menu")
	var fishing_session = FISHING_SESSION_SCRIPT.new()
	scene.set("_fishing_session", fishing_session)
	fishing_session.cast_line(0.0, "quiet")
	scene.call("_handle_fishing_action")
	await RenderingServer.frame_post_draw
	var fishing_status := scene.get_node_or_null("TopPanel/TopVBox/FishingStatusLabel") as Label
	var fishing_button := scene.get_node_or_null("BottomPanel/ButtonGrid/FishingButton") as Button
	if fishing_status == null or fishing_button == null or "조용" not in fishing_status.text or fishing_button.text != "낚시":
		await _cleanup(scene, game_state)
		_fail("quiet fishing must show its no-loss status and restored public action")
		return
	if not _save_viewport_image(QUIET_FISHING_CAPTURE):
		await _cleanup(scene, game_state)
		return

	scene.call("_open_interaction_panel")
	await process_frame
	var action_option := scene.get_node_or_null("InteractionPanel/InteractionVBox/InteractionActionOption") as OptionButton
	if action_option == null or not _select_action(action_option, "rest_together"):
		await _cleanup(scene, game_state)
		_fail("pet rest-together action must be visible in interaction UI")
		return
	scene.call("_perform_selected_interaction")
	await RenderingServer.frame_post_draw
	var action_status := scene.get_node_or_null("TopPanel/TopVBox/StatusLabel") as Label
	if action_status == null or "곁에 몸을 붙이고" not in action_status.text:
		await _cleanup(scene, game_state)
		_fail("pet rest-together action must surface its player-facing message")
		return
	if not _save_viewport_image(PET_REST_CAPTURE):
		await _cleanup(scene, game_state)
		return
	await _cleanup(scene, game_state)
	print("PASS: calm fishing and interaction runtime captures")
	quit(0)


func _select_action(option: OptionButton, action_id: String) -> bool:
	for index in option.item_count:
		if str(option.get_item_metadata(index)) == action_id:
			option.select(index)
			return true
	return false


func _save_viewport_image(file_name: String) -> bool:
	var image := root.get_texture().get_image()
	if image == null or image.is_empty():
		_fail("runtime capture image must not be empty")
		return false
	var output_path := "%s/%s" % [EVIDENCE_DIRECTORY, file_name]
	if image.save_png(output_path) != OK:
		_fail("could not save %s" % output_path)
		return false
	return true


func _cleanup(scene: Node, game_state: Node) -> void:
	if scene != null:
		scene.queue_free()
		await process_frame
	game_state.reset_session()


func _fail(message: String) -> void:
	printerr("FAILED: %s" % message)
	quit(1)
