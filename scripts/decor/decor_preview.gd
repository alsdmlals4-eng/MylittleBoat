# 꾸미기 패널 안의 독립 보트 미리보기에 현재 cosmetic state를 반영한다.
extends SubViewportContainer


@onready var _boat_space := $DecorPreviewViewport/PreviewWorld/BoatSpace as Node3D
@onready var _preview_viewport := $DecorPreviewViewport as SubViewport
@onready var _preview_camera := $DecorPreviewViewport/PreviewWorld/PreviewCameraRig/PreviewCamera3D as Camera3D


func _ready() -> void:
	_boat_space.visible = false
	hide_preview()


func show_from_state() -> void:
	refresh_from_state()
	_preview_viewport.disable_3d = false
	_preview_viewport.render_target_update_mode = SubViewport.UPDATE_ALWAYS
	_preview_camera.current = true
	_boat_space.visible = true
	visible = true


func hide_preview() -> void:
	visible = false
	_preview_camera.current = false
	_preview_viewport.render_target_update_mode = SubViewport.UPDATE_DISABLED
	_preview_viewport.disable_3d = true
	_boat_space.visible = false


func refresh_from_state() -> void:
	if _boat_space == null:
		return
	var identity_visual_router := _boat_space.get_node_or_null("IdentityVisualRouter")
	if identity_visual_router != null and identity_visual_router.has_method("apply_selection"):
		identity_visual_router.call(
			"apply_selection",
			GameState.get_selected_player_style(),
			GameState.get_selected_pet_type()
		)
	var decor_slots := _boat_space.get_node_or_null("BoatDecorSlots")
	if decor_slots != null:
		for decor_slot in decor_slots.get_children():
			var slot_id := str(decor_slot.get("slot_id"))
			if slot_id == "" or not decor_slot.has_method("apply_item"):
				continue
			decor_slot.call(
				"apply_item",
				GameState.get_boat_decor(slot_id),
				GameState.get_boat_decor_appearance(slot_id)
			)
	if identity_visual_router != null and identity_visual_router.has_method("sync_decor_from_state"):
		identity_visual_router.call("sync_decor_from_state")
