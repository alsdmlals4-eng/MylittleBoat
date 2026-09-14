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
const RECOVERY_LEDGER_PATH := "user://test_r07b3_recovery_ledger.cfg"
const RECOVERY_COMFORT_PATH := "user://test_r07b3_recovery_comfort.cfg"
const RETRY_UI_DIRECTORY := "user://test_r07b3_retry_ui_missing"
const RETRY_UI_LEDGER_PATH := RETRY_UI_DIRECTORY + "/ledger.cfg"
const PHOTO_CONFIG_PATH := "user://test_r07b3_photo.cfg"
const PHOTO_DIRECTORY := "user://test_r07b3_photos"

var _failures := 0


class RecoveryThenCommitFailure:
	extends RefCounted
	var status := "RECOVERY_REQUIRED"

	func get_last_storage_result() -> Dictionary:
		return {"status": status}

	func recover_primary() -> Dictionary:
		status = "COMMITTED"
		return {"status": status}

	func load_entries() -> Dictionary:
		return {"fish": [], "voyage_records": []}

	func save_entries(_fish_entries: Array[String], _voyage_entries: Array[String]) -> Error:
		status = "NOT_COMMITTED"
		return ERR_CANT_CREATE


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

	# Recovery must not hide the one pending voyage summary before it is durably committed.
	state.set_memory_ledger_storage_path(RECOVERY_LEDGER_PATH)
	state.fish.clear()
	state.voyage_records.clear()
	state.add_fish("정어리")
	state.add_fish("고등어")
	state.begin_voyage()
	state.remaining_seconds = 0.0
	var corrupt_ledger := FileAccess.open(RECOVERY_LEDGER_PATH, FileAccess.WRITE)
	corrupt_ledger.store_string("[memory_ledger\ninvalid")
	corrupt_ledger.close()
	_expect(not bool(state.complete_voyage()), "corrupt ledger must retain one pending voyage summary")
	_expect(bool(state.recover_storage("memory_ledger")), "ledger recovery must also commit its retained voyage summary")
	_expect(state.voyage_record_created and state.voyage_records.size() == 1, "ledger recovery must finalize the pending summary exactly once")

	# A successful retry must expose and execute the existing next-voyage action immediately.
	state.set_memory_ledger_storage_path(RETRY_UI_LEDGER_PATH)
	state.begin_voyage()
	state.remaining_seconds = 0.0
	_expect(not bool(state.complete_voyage()), "missing ledger directory must leave a retryable voyage summary")
	state.set_identity_storage_path(IDENTITY_PATH)
	state.load_identity()
	state.set_together_time_storage_path(TOGETHER_PATH)
	state.flush_together_time()
	var retry_scene: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(retry_scene)
	retry_scene.open_rest_menu()
	_expect(retry_scene.get_node("%StorageRecoveryButton").get_meta("owner_id", "") == "memory_ledger", "pending voyage must expose its ledger retry")
	DirAccess.make_dir_recursive_absolute(ProjectSettings.globalize_path(RETRY_UI_DIRECTORY))
	retry_scene.get_node("%StorageRecoveryButton").pressed.emit()
	_expect(retry_scene.get_node("%NextVoyageButton").visible, "committed voyage retry must immediately show NextVoyageButton")
	current_scene = retry_scene
	retry_scene.get_node("%NextVoyageButton").pressed.emit()
	await process_frame
	_expect(state.voyage_active and not state.voyage_record_created and is_equal_approx(state.remaining_seconds, state.VOYAGE_SECONDS), "visible next-voyage action must begin the next voyage")

	# Comfort recovery must preserve and then commit the live pair without dropping future keys.
	var recovery_comfort := ConfigFile.new()
	recovery_comfort.set_value("comfort", "profile", "standard")
	recovery_comfort.set_value("comfort", "ocean_volume", 1.0)
	recovery_comfort.set_value("future", "preserve_me", "round1")
	recovery_comfort.save(RECOVERY_COMFORT_PATH)
	state.set_comfort_storage_path(RECOVERY_COMFORT_PATH)
	state.set_motion_comfort_profile("gentle")
	var corrupt_comfort := FileAccess.open(RECOVERY_COMFORT_PATH, FileAccess.WRITE)
	corrupt_comfort.store_string("[comfort\ninvalid")
	corrupt_comfort.close()
	state.set_motion_comfort_profile("still")
	state.set_ocean_volume(0.25)
	state.set_identity_storage_path(IDENTITY_PATH)
	state.load_identity()
	state.set_together_time_storage_path(TOGETHER_PATH)
	state.flush_together_time()
	state.set_memory_ledger_storage_path(LEDGER_PATH)
	state.save_memory_ledger()
	var comfort_scene: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(comfort_scene)
	comfort_scene.open_rest_menu()
	_expect(comfort_scene.get_node("%StorageRecoveryButton").get_meta("owner_id", "") == "comfort", "live comfort recovery must remain actionable")
	comfort_scene.get_node("%StorageRecoveryButton").pressed.emit()
	var recovered_comfort := ConfigFile.new()
	recovered_comfort.load(RECOVERY_COMFORT_PATH)
	_expect(recovered_comfort.get_value("comfort", "profile", "") == "still" and is_equal_approx(float(recovered_comfort.get_value("comfort", "ocean_volume", -1.0)), 0.25), "comfort recovery button must commit the live motion and volume pair")
	_expect(recovered_comfort.get_value("future", "preserve_me", "") == "round1", "comfort recovery must preserve unknown validated keys")
	comfort_scene.queue_free()

	# A non-retryable photo failure must not hide a later actionable comfort failure.
	state.set_photo_memory_storage(PHOTO_CONFIG_PATH, PHOTO_DIRECTORY)
	state.record_photo_memory(null, "", "")
	state.set_identity_storage_path(IDENTITY_PATH)
	state.load_identity()
	state.set_together_time_storage_path(TOGETHER_PATH)
	state.flush_together_time()
	state.set_memory_ledger_storage_path(LEDGER_PATH)
	state.save_memory_ledger()
	state.set_comfort_storage_path(FAILURE_DIRECTORY + "/blocked_photo_comfort/comfort.cfg")
	state.set_ocean_volume(0.75)
	var photo_scene: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(photo_scene)
	photo_scene.open_rest_menu()
	_expect(photo_scene.get_node("%StorageRecoveryButton").get_meta("owner_id", "") == "comfort", "photo NOT_COMMITTED must not hide a later actionable comfort owner")
	photo_scene.queue_free()

	# A recovered primary followed by a failed pending commit must not claim that no verified original existed.
	state._memory_ledger_persistence = RecoveryThenCommitFailure.new()
	state._pending_voyage_summary = "round1 retained summary"
	var partial_recovery_scene: Node = load("res://scenes/game.tscn").instantiate()
	root.add_child(partial_recovery_scene)
	partial_recovery_scene.open_rest_menu()
	_expect(partial_recovery_scene.get_node("%StorageRecoveryButton").get_meta("owner_id", "") == "memory_ledger", "partial recovery fixture must expose the ledger recovery action")
	partial_recovery_scene.get_node("%StorageRecoveryButton").pressed.emit()
	_expect(partial_recovery_scene.get_node("%StatusLabel").text == "저장을 마치지 못했습니다. 원본과 이번 실행 상태는 유지했습니다.", "post-recovery commit failure must use a truthful retained-state message")
	_expect(partial_recovery_scene.get_node("%StorageRecoveryButton").visible, "post-recovery commit failure must remain actionable")
	partial_recovery_scene.queue_free()
	state._memory_ledger_persistence = preload("res://scripts/core/memory_ledger_persistence.gd").new(LEDGER_PATH)
	state._pending_voyage_summary = ""

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
	state.voyage_active = false
	state.flush_together_time()
	if is_instance_valid(current_scene):
		current_scene.queue_free()
	for frame in 2:
		await process_frame
	_finish()


func _cleanup() -> void:
	for path in [IDENTITY_PATH, DECOR_PATH, TOGETHER_PATH, LEDGER_PATH, COMFORT_PATH, RECOVERY_LEDGER_PATH, RECOVERY_COMFORT_PATH, PHOTO_CONFIG_PATH]:
		preload("res://tests/helpers/config_store_test_cleanup.gd").remove_store(path)
	if DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(FAILURE_DIRECTORY)):
		if DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(FAILURE_DIRECTORY + "/blocked")):
			for name in DirAccess.get_files_at(FAILURE_DIRECTORY + "/blocked"):
				DirAccess.remove_absolute(ProjectSettings.globalize_path((FAILURE_DIRECTORY + "/blocked").path_join(name)))
			DirAccess.remove_absolute(ProjectSettings.globalize_path(FAILURE_DIRECTORY + "/blocked"))
		for name in DirAccess.get_files_at(FAILURE_DIRECTORY):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(FAILURE_DIRECTORY.path_join(name)))
		DirAccess.remove_absolute(ProjectSettings.globalize_path(FAILURE_DIRECTORY))
	if DirAccess.dir_exists_absolute(ProjectSettings.globalize_path(RETRY_UI_DIRECTORY)):
		for name in DirAccess.get_files_at(RETRY_UI_DIRECTORY):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(RETRY_UI_DIRECTORY.path_join(name)))
		DirAccess.remove_absolute(ProjectSettings.globalize_path(RETRY_UI_DIRECTORY))


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
