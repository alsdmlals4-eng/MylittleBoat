# 보트 꾸미기·상호작용 기술 UI의 무압력·감상모드 계약을 검증한다.
extends SceneTree

var _failures := 0

func _init() -> void:
	call_deferred("_run")

func _run() -> void:
	var gs := root.get_node_or_null("GameState")
	_expect(gs != null, "GameState required")
	if gs == null:
		_finish()
		return
	gs.boat_decor.clear()
	gs.reset_session()
	gs.voyage_active = true
	gs.remaining_seconds = 123.0

	var packed := load("res://scenes/game.tscn") as PackedScene
	_expect(packed != null, "game scene must load")
	if packed == null:
		_finish()
		return
	var scene := packed.instantiate()
	root.add_child(scene)
	await process_frame

	var decor_button := scene.get_node_or_null("BottomPanel/ButtonGrid/DecorButton") as Button
	var interact_button := scene.get_node_or_null("BottomPanel/ButtonGrid/InteractButton") as Button
	var decor_panel := scene.get_node_or_null("DecorPanel") as Control
	var interaction_panel := scene.get_node_or_null("InteractionPanel") as Control
	var slot_option := scene.get_node_or_null("DecorPanel/DecorVBox/DecorSlotOption") as OptionButton
	var item_option := scene.get_node_or_null("DecorPanel/DecorVBox/DecorItemOption") as OptionButton
	var apply_button := scene.get_node_or_null("DecorPanel/DecorVBox/DecorApplyButton") as Button
	var appreciation_button := scene.get_node_or_null("BottomPanel/ButtonGrid/AppreciationButton") as Button

	_expect(decor_button != null, "DecorButton required")
	_expect(interact_button != null, "InteractButton required")
	_expect(decor_panel != null and not decor_panel.visible, "DecorPanel must start hidden")
	_expect(interaction_panel != null and not interaction_panel.visible, "InteractionPanel must start hidden")
	_expect(slot_option != null and slot_option.item_count == 8, "decor UI must expose eight approved slots")
	_expect(item_option != null, "compatible decor item option required")
	_expect(apply_button != null, "decor apply action required")
	_expect(scene.has_method("get_interaction_target_ids"), "interaction target discovery API required")
	_expect(scene.has_method("perform_interaction"), "interaction routing API required")

	var before_together_time: float = gs.together_time_seconds
	var before_photos: int = gs.photos.size()
	var before_records: int = gs.voyage_records.size()
	var before_time: float = float(gs.remaining_seconds)

	if decor_button != null and decor_panel != null:
		decor_button.emit_signal("pressed")
		_expect(decor_panel.visible, "DecorButton must open DecorPanel")
		if interaction_panel != null:
			_expect(not interaction_panel.visible, "opening DecorPanel must close InteractionPanel")
	if item_option != null:
		_expect(item_option.item_count > 0, "selected slot must offer compatible items")
	if apply_button != null and slot_option != null and item_option != null and item_option.item_count > 0:
		apply_button.emit_signal("pressed")
		_expect(gs.get_boat_decor("bow_left") != "", "apply must store one compatible bow-left item")

	if scene.has_method("get_interaction_target_ids"):
		var targets: Array = scene.call("get_interaction_target_ids")
		_expect(targets.has("pet"), "pet must be an interaction target")
		_expect(targets.has("rail"), "rail must be an interaction target")
		_expect(targets.has("decor:bow_left"), "placed interactive decor must become a target")

	_expect(is_equal_approx(gs.together_time_seconds, before_together_time), "decor UI must not create together time")
	_expect(gs.photos.size() == before_photos, "decor UI must not create photos")
	_expect(gs.voyage_records.size() == before_records, "decor UI must not create voyage records")
	_expect(is_equal_approx(float(gs.remaining_seconds), before_time), "button actions themselves must not change voyage time")

	if interact_button != null and interaction_panel != null:
		interact_button.emit_signal("pressed")
		_expect(interaction_panel.visible, "InteractButton must open InteractionPanel")
		if decor_panel != null:
			_expect(not decor_panel.visible, "opening InteractionPanel must close DecorPanel")

	if appreciation_button != null:
		appreciation_button.emit_signal("pressed")
		_expect(gs.appreciation_mode, "AppreciationButton must still enter appreciation mode")
		if decor_button != null:
			_expect(not decor_button.visible, "Appreciation Camera must hide DecorButton")
		if interact_button != null:
			_expect(not interact_button.visible, "Appreciation Camera must hide InteractButton")
		if decor_panel != null:
			_expect(not decor_panel.visible, "Appreciation Camera must close DecorPanel")
		if interaction_panel != null:
			_expect(not interaction_panel.visible, "Appreciation Camera must close InteractionPanel")
		appreciation_button.emit_signal("pressed")
		if decor_button != null:
			_expect(decor_button.visible, "leaving Appreciation restores DecorButton")
		if interact_button != null:
			_expect(interact_button.visible, "leaving Appreciation restores InteractButton")
		if decor_panel != null:
			_expect(not decor_panel.visible, "leaving Appreciation must not reopen DecorPanel")
		if interaction_panel != null:
			_expect(not interaction_panel.visible, "leaving Appreciation must not reopen InteractionPanel")

	scene.queue_free()
	await process_frame
	gs.boat_decor.clear()
	gs.appreciation_mode = false
	_finish()

func _expect(condition: bool, message: String) -> void:
	if not condition:
		_failures += 1
		printerr("FAIL: %s" % message)

func _finish() -> void:
	if _failures == 0:
		print("PASS: boat life UI contract")
		quit(0)
	else:
		printerr("FAILED: %d boat life UI assertions" % _failures)
		quit(1)
