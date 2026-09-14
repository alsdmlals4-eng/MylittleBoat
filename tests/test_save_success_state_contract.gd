# 저장 성공 뒤에만 게임 상태가 확정되고 실패 상태를 복구할 수 있는지 검증한다.
extends SceneTree

const IDENTITY_PATH := "user://test_r07b3_identity.cfg"
const DECOR_PATH := "user://test_r07b3_decor.cfg"
const TOGETHER_PATH := "user://test_r07b3_together.cfg"
const LEDGER_PATH := "user://test_r07b3_ledger.cfg"
const COMFORT_PATH := "user://test_r07b3_comfort.cfg"
const FAILURE_DIRECTORY := "user://test_r07b3_missing"
const FAILURE_IDENTITY_PATH := FAILURE_DIRECTORY + "/identity.cfg"
const FAILURE_TOGETHER_PATH := FAILURE_DIRECTORY + "/together.cfg"
const FAILURE_LEDGER_PATH := FAILURE_DIRECTORY + "/ledger.cfg"
const FAILURE_COMFORT_PATH := FAILURE_DIRECTORY + "/blocked/comfort.cfg"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var state := root.get_node_or_null("GameState")
	_expect(state != null, "GameState autoload must exist")
	if state == null:
		_finish()
		return
	for method_name in ["apply_identity_selection", "apply_decor_selection", "get_storage_status", "recover_storage", "retry_owner_storage", "retry_pending_voyage_record", "add_fish"]:
		_expect(state.has_method(method_name), "GameState must expose %s" % method_name)
	if _failures > 0:
		_finish()
		return

	_cleanup()
	state.set_identity_storage_path(IDENTITY_PATH)
	_expect(bool(state.apply_identity_selection("a_soft_hooded", "cat")), "valid identity candidate must commit")
	_expect(state.selected_player_style == "a_soft_hooded" and state.selected_pet_type == "cat", "identity cache must update after commit")
	var identity_bytes := FileAccess.get_file_as_bytes(IDENTITY_PATH)
	_expect(not bool(state.apply_identity_selection("unknown-style", "cat")), "unknown identity must fail closed")
	_expect(FileAccess.get_file_as_bytes(IDENTITY_PATH) == identity_bytes, "invalid identity must not change the file")
	_expect(state.selected_player_style == "a_soft_hooded", "invalid identity must not change cache")
	DirAccess.copy_absolute(ProjectSettings.globalize_path(IDENTITY_PATH), ProjectSettings.globalize_path(IDENTITY_PATH + ".last_good"))
	var corrupt := FileAccess.open(IDENTITY_PATH, FileAccess.WRITE)
	corrupt.store_string("[identity\ninvalid")
	corrupt.close()
	state.load_identity()
	_expect(state.get_storage_status("identity").get("status", "") == "RECOVERED", "backup read must stay distinct from primary recovery")
	_expect(bool(state.recover_storage("identity")), "verified backup must recover the primary")
	_expect(state.get_storage_status("identity").get("status", "") == "OK", "recovered owner readback must be healthy")

	state.set_identity_storage_path(FAILURE_IDENTITY_PATH)
	var style_before: String = state.selected_player_style
	_expect(not bool(state.apply_identity_selection("b_short_cape", "rabbit")), "unwritable identity candidate must not commit")
	_expect(state.selected_player_style == style_before and not FileAccess.file_exists(FAILURE_IDENTITY_PATH), "failed identity write must preserve cache and file absence")

	state.set_boat_decor_storage_path(DECOR_PATH)
	_expect(bool(state.apply_decor_selection({"bow_left": "lantern"}, {})), "compatible decor candidate must commit")
	var decor_bytes := FileAccess.get_file_as_bytes(DECOR_PATH)
	_expect(not bool(state.apply_decor_selection({"pet_corner": "lantern"}, {})), "incompatible decor must fail closed")
	_expect(FileAccess.get_file_as_bytes(DECOR_PATH) == decor_bytes and state.boat_decor == {"bow_left": "lantern"}, "invalid decor must preserve file and cache")

	state.set_together_time_storage_path(TOGETHER_PATH)
	state.begin_voyage()
	state.advance_together_time(NAN)
	state.advance_together_time(INF)
	_expect(is_zero_approx(state.together_time_seconds), "non-finite together-time delta must be rejected")
	state.set_together_time_storage_path(FAILURE_TOGETHER_PATH)
	state.begin_voyage()
	state.advance_together_time(15.0)
	_expect(is_equal_approx(state.together_time_seconds, 15.0), "failed flush must retain unsaved together time")
	var failed_status: Dictionary = state.get_storage_status("together_time")
	state.advance_together_time(1.0)
	_expect(state.get_storage_status("together_time") == failed_status, "failed together-time flush must not retry every frame")

	state.set_memory_ledger_storage_path(LEDGER_PATH)
	state.fish.clear()
	_expect(bool(state.add_fish("정어리")), "fish must report committed storage")
	_expect(state.fish == ["정어리"], "fish cache must update after commit")
	state.remaining_seconds = 0.0
	_expect(bool(state.complete_voyage()), "completed voyage summary must commit")
	_expect(state.voyage_record_created and state.voyage_records.size() == 1, "voyage state must finalize after commit")
	_expect(not bool(state.retry_pending_voyage_record()), "retry must be inert without a pending summary")

	state.set_memory_ledger_storage_path(FAILURE_LEDGER_PATH)
	state.begin_voyage()
	state.remaining_seconds = 0.0
	_expect(not bool(state.complete_voyage()), "unwritable voyage summary must stay pending")
	_expect(not state.voyage_record_created and state.voyage_records.is_empty(), "failed voyage summary must not finalize or append")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(FAILURE_DIRECTORY))
	_expect(bool(state.retry_pending_voyage_record()), "pending voyage summary must commit after storage recovery")
	_expect(state.voyage_record_created and state.voyage_records.size() == 1, "retry must append the same pending summary exactly once")

	state.set_comfort_storage_path(FAILURE_COMFORT_PATH)
	_expect(not bool(state.set_motion_comfort_profile("gentle")), "failed comfort save must report failure")
	_expect(not bool(state.set_ocean_volume(0.25)), "failed ocean-volume save must report failure")
	_expect(state.get_motion_comfort_profile() == "gentle" and is_equal_approx(state.get_ocean_volume(), 0.25), "comfort failure must preserve live accessibility choices")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(FAILURE_DIRECTORY + "/blocked"))
	_expect(bool(state.retry_owner_storage("comfort")), "comfort retry must commit both live choices")
	state.load_motion_comfort()
	_expect(state.get_motion_comfort_profile() == "gentle" and is_equal_approx(state.get_ocean_volume(), 0.25), "comfort retry must persist motion and ocean volume together")
	var comfort_with_extra := ConfigFile.new()
	comfort_with_extra.set_value("comfort", "profile", "standard")
	comfort_with_extra.set_value("comfort", "ocean_volume", 1.0)
	comfort_with_extra.set_value("future", "preserve_me", "yes")
	comfort_with_extra.save(COMFORT_PATH)
	state.set_comfort_storage_path(COMFORT_PATH)
	state.set_motion_comfort_profile("gentle")
	state.set_ocean_volume(0.5)
	_expect(bool(state.retry_owner_storage("comfort")), "combined comfort retry must commit on a valid existing owner")
	var comfort_readback := ConfigFile.new()
	comfort_readback.load(COMFORT_PATH)
	_expect(comfort_readback.get_value("future", "preserve_me", "") == "yes", "combined comfort retry must preserve unknown valid sections and keys")

	_expect(state.get_storage_status("unknown_owner").is_empty(), "unknown owner status must fail closed")
	_expect(not bool(state.recover_storage("unknown_owner")), "unknown owner recovery must fail closed")
	state.set_identity_storage_path(IDENTITY_PATH)
	state.apply_identity_selection("a_soft_hooded", "cat")
	state.apply_identity_selection("b_short_cape", "rabbit")
	var corrupt_for_ui := FileAccess.open(IDENTITY_PATH, FileAccess.WRITE)
	corrupt_for_ui.store_string("[identity\ninvalid")
	corrupt_for_ui.close()
	state.load_identity()
	var recovery_scene: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(recovery_scene)
	var recovery_router := recovery_scene.get_node("VoyageWorld/BoatSpace/IdentityVisualRouter")
	recovery_router.apply_selection("b_short_cape", "rabbit")
	recovery_scene.open_rest_menu()
	_expect(recovery_scene.get_node("%StorageRecoveryButton").text == "정상본으로 복구", "RECOVERED read must offer explicit primary recovery")
	recovery_scene.get_node("%StorageRecoveryButton").pressed.emit()
	var recovered_route: Dictionary = recovery_router.get_active_visual_route()
	_expect(recovered_route.get("player_style_id", "") == state.selected_player_style and recovered_route.get("pet_type_id", "") == state.selected_pet_type, "identity recovery must synchronize the actual boat visual route")
	recovery_scene.queue_free()
	state.set_identity_storage_path(FAILURE_DIRECTORY + "/blocked2/identity.cfg")
	state.apply_identity_selection("a_soft_hooded", "cat")
	var scene: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(scene)
	scene.open_rest_menu()
	_expect(scene.get_node("%StorageStatusLabel").visible, "rest menu must show only an actual storage issue")
	_expect(scene.get_node("%StorageRecoveryButton").visible and scene.get_node("%StorageRecoveryButton").text == "저장 다시 시도", "rest menu must offer a bounded retry for NOT_COMMITTED")
	_expect(scene.get_node("%StorageRecoveryButton").mouse_filter == Control.MOUSE_FILTER_STOP, "storage action must consume pointer input before camera routing")
	scene.queue_free()
	_finish()


func _cleanup() -> void:
	for path in [IDENTITY_PATH, DECOR_PATH, TOGETHER_PATH, LEDGER_PATH, COMFORT_PATH]:
		preload("res://tests/helpers/config_store_test_cleanup.gd").remove_store(path)
	if DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(FAILURE_DIRECTORY)):
		if DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(FAILURE_DIRECTORY + "/blocked")):
			for name in DirAccess.get_files_at(FAILURE_DIRECTORY + "/blocked"):
				DirAccess.remove_absolute(ProjectSettings.globalize_path((FAILURE_DIRECTORY + "/blocked").path_join(name)))
			DirAccess.remove_absolute(ProjectSettings.globalize_path(FAILURE_DIRECTORY + "/blocked"))
		for name in DirAccess.get_files_at(FAILURE_DIRECTORY):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(FAILURE_DIRECTORY.path_join(name)))
		DirAccess.remove_absolute(ProjectSettings.globalize_path(FAILURE_DIRECTORY))


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	_cleanup()
	if _failures == 0:
		print("PASS: save-success state contract")
		quit(0)
	else:
		printerr("FAILED: %d save-success state assertions" % _failures)
		quit(1)
