# 보이는 플레이어·3/4 디오라마와 감상 카메라 전환 계약을 검증한다.
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

	game_state.reset_session()
	game_state.voyage_active = true
	game_state.remaining_seconds = 123.0
	game_state.speed_index = 1
	game_state.appreciation_mode = false

	var packed_scene := load("res://scenes/game.tscn") as PackedScene
	_expect(packed_scene != null, "game.tscn must load")
	if packed_scene == null:
		_finish()
		return

	var scene := packed_scene.instantiate()
	root.add_child(scene)
	await process_frame

	var avatar := scene.get_node_or_null("VoyageWorld/PlayerAvatarPlaceholder") as Node3D
	var pet := scene.get_node_or_null("VoyageWorld/RestingPetPlaceholder") as Node3D
	var boat := scene.get_node_or_null("VoyageWorld/BoatBow") as Node3D
	_expect(avatar != null, "normal play must include a visible player avatar placeholder")
	if avatar != null:
		_expect(avatar.has_method("is_technical_placeholder"), "avatar must expose its evidence class")
		if avatar.has_method("is_technical_placeholder"):
			_expect(bool(avatar.call("is_technical_placeholder")), "current avatar must remain explicit technical-placeholder evidence")
		_expect(avatar.has_method("get_customization_slots"), "avatar placeholder must expose future cosmetic slots without stats")

	var diorama_camera := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D") as Camera3D
	var appreciation_camera := scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D") as Camera3D
	_expect(diorama_camera != null, "normal play must provide DioramaCamera3D")
	_expect(appreciation_camera != null, "appreciation mode must preserve a sea-focused camera")
	if diorama_camera != null:
		_expect(diorama_camera.current, "diorama camera must be current in normal play")
	if appreciation_camera != null:
		_expect(not appreciation_camera.current, "appreciation camera must be inactive in normal play")
	_expect(scene.has_method("get_active_camera_mode"), "game scene must expose active camera mode")
	if scene.has_method("get_active_camera_mode"):
		_expect(str(scene.call("get_active_camera_mode")) == "diorama", "normal camera mode must report diorama")

	if avatar != null and pet != null and boat != null:
		var avatar_relative_y_before: float = avatar.position.y - boat.position.y
		var pet_relative_y_before: float = pet.position.y - boat.position.y
		scene.call("_process", 0.5)
		var avatar_relative_y_after: float = avatar.position.y - boat.position.y
		var pet_relative_y_after: float = pet.position.y - boat.position.y
		_expect(is_equal_approx(avatar_relative_y_after, avatar_relative_y_before), "visible avatar must co-move with boat bob instead of floating relative to the deck")
		_expect(is_equal_approx(pet_relative_y_after, pet_relative_y_before), "resting pet must co-move with boat bob in the visible diorama")
	else:
		_expect(false, "diorama must expose avatar, pet, and boat for shared drift composition")

	var appreciation_button := scene.get_node_or_null("BottomPanel/ButtonGrid/AppreciationButton") as Button
	_expect(appreciation_button != null, "AppreciationButton must remain available")
	if appreciation_button != null:
		var before_time: float = float(game_state.remaining_seconds)
		var before_speed: int = int(game_state.speed_index)
		var before_photos: int = game_state.photos.size()
		var before_sceneries: int = game_state.sceneries.size()
		var before_letters: int = game_state.letters.size()
		var before_fish: int = game_state.fish.size()

		appreciation_button.emit_signal("pressed")

		if diorama_camera != null:
			_expect(not diorama_camera.current, "diorama camera must yield during appreciation mode")
		if appreciation_camera != null:
			_expect(appreciation_camera.current, "appreciation camera must become current")
		if scene.has_method("get_active_camera_mode"):
			_expect(str(scene.call("get_active_camera_mode")) == "appreciation", "camera mode must report appreciation")

		_expect(is_equal_approx(float(game_state.remaining_seconds), before_time), "camera toggle itself must not change voyage time")
		_expect(int(game_state.speed_index) == before_speed, "camera toggle must not change speed choice")
		_expect(game_state.photos.size() == before_photos, "camera toggle must not create photo rewards")
		_expect(game_state.sceneries.size() == before_sceneries, "camera toggle must not create scenery rewards")
		_expect(game_state.letters.size() == before_letters, "camera toggle must not create letter rewards")
		_expect(game_state.fish.size() == before_fish, "camera toggle must not create fishing rewards")

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
		print("PASS: diorama avatar camera contract")
		quit(0)
	else:
		printerr("FAILED: %d diorama avatar camera assertions" % _failures)
		quit(1)
