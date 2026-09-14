# 항해의 누적 기억과 현재 세션 상태를 관리한다.
extends Node

signal ocean_volume_changed(volume: float)

const VOYAGE_SECONDS := 300.0
const BOAT_DECOR_PERSISTENCE_SCRIPT = preload("res://scripts/core/boat_decor_persistence.gd")
const IDENTITY_PROFILE_SCRIPT = preload("res://scripts/core/cosmetic_identity_profile.gd")
const TOGETHER_TIME_PERSISTENCE_SCRIPT = preload("res://scripts/core/together_time_persistence.gd")
const AMBIENT_MEMORY_PERSISTENCE_SCRIPT = preload("res://scripts/core/ambient_memory_persistence.gd")
const COMFORT_PREFERENCES_SCRIPT = preload("res://scripts/core/comfort_preferences.gd")
const PHOTO_MEMORY_PERSISTENCE_SCRIPT = preload("res://scripts/core/photo_memory_persistence.gd")
const MEMORY_LEDGER_PERSISTENCE_SCRIPT = preload("res://scripts/core/memory_ledger_persistence.gd")
const TOGETHER_TIME_SAVE_INTERVAL_SECONDS := 15.0
const DECOR_CATALOG_SCRIPT = preload("res://scripts/decor/boat_decor_catalog.gd")
const DECOR_VISUAL_ASSETS_SCRIPT = preload("res://scripts/decor/decor_visual_assets.gd")

# 여러 항해에 걸쳐 유지되는 기억이다.
var photos: Array[String] = []
var photo_memories: Array[Dictionary] = []
var sceneries: Array[String] = []
var ambient_memories: Array[String] = []
var letters: Array[String] = []
var fish: Array[String] = []
var voyage_records: Array[String] = []
var boat_decor: Dictionary = {}
var boat_decor_appearances: Dictionary = {}
var selected_player_style := "c_loose_knit"
var selected_pet_type := "dog"
var together_time_seconds := 0.0
var motion_comfort_profile := "standard"
var _ocean_volume := 1.0

# Scene 전환에도 유지되어야 하는 현재 항해 상태다.
var voyage_active := false
var remaining_seconds := VOYAGE_SECONDS
var speed_index := 1
var appreciation_mode := false
var voyage_record_created := false

var _voyage_photo_start_count := 0
var _voyage_scenery_start_count := 0
var _voyage_letter_start_count := 0
var _voyage_fish_start_count := 0
var _boat_decor_persistence = BOAT_DECOR_PERSISTENCE_SCRIPT.new()
var _identity_profile = IDENTITY_PROFILE_SCRIPT.new()
var _together_time_persistence = TOGETHER_TIME_PERSISTENCE_SCRIPT.new()
var _ambient_memory_persistence = AMBIENT_MEMORY_PERSISTENCE_SCRIPT.new()
var _comfort_preferences = COMFORT_PREFERENCES_SCRIPT.new()
var _photo_memory_persistence = PHOTO_MEMORY_PERSISTENCE_SCRIPT.new()
var _memory_ledger_persistence = MEMORY_LEDGER_PERSISTENCE_SCRIPT.new()
var _unsaved_together_time_seconds := 0.0
var _together_time_since_save_attempt := 0.0
var _pending_voyage_summary := ""


func _ready() -> void:
	load_boat_decor()
	load_identity()
	load_together_time()
	load_ambient_memories()
	load_motion_comfort()
	load_photo_memories()
	load_memory_ledger()


## Starts a fresh five-minute voyage while preserving accumulated memories and boat decoration.
func begin_voyage() -> void:
	reset_session()
	voyage_active = true
	_voyage_photo_start_count = photos.size()
	_voyage_scenery_start_count = sceneries.size()
	_voyage_letter_start_count = letters.size()
	_voyage_fish_start_count = fish.size()


## Clears only transient voyage state. Album memories, boat decor, and together time stay intact.
func reset_session() -> void:
	voyage_active = false
	remaining_seconds = VOYAGE_SECONDS
	speed_index = 1
	appreciation_mode = false
	voyage_record_created = false


## Stores or clears one cosmetic boat-decor choice without creating rewards.
func set_boat_decor(slot_id: String, item_id: String) -> bool:
	if slot_id == "":
		return false
	var candidate_decor := boat_decor.duplicate(true)
	var candidate_appearances := boat_decor_appearances.duplicate(true)
	if item_id == "":
		candidate_decor.erase(slot_id)
		candidate_appearances.erase(slot_id)
	else:
		candidate_decor[slot_id] = item_id
	return apply_decor_selection(candidate_decor, candidate_appearances)


## Returns the process-lifetime cosmetic item stored in one boat slot.
func get_boat_decor(slot_id: String) -> String:
	return str(boat_decor.get(slot_id, ""))


## Stores or clears a cosmetic appearance without changing the stable decor item meaning.
func set_boat_decor_appearance(slot_id: String, appearance_id: String) -> bool:
	if slot_id == "":
		return false
	var candidate_appearances := boat_decor_appearances.duplicate(true)
	if appearance_id == "":
		candidate_appearances.erase(slot_id)
	else:
		candidate_appearances[slot_id] = appearance_id
	return apply_decor_selection(boat_decor, candidate_appearances)


## Returns the stored cosmetic appearance for one boat decor slot.
func get_boat_decor_appearance(slot_id: String) -> String:
	return str(boat_decor_appearances.get(slot_id, ""))


## Switches the local cosmetic decor storage target without loading gameplay state.
func set_boat_decor_storage_path(path: String) -> void:
	if path == "":
		return
	_boat_decor_persistence = BOAT_DECOR_PERSISTENCE_SCRIPT.new(path)


## Writes only cosmetic boat decor to the local device.
func save_boat_decor() -> bool:
	return _boat_decor_persistence.save(boat_decor, boat_decor_appearances) == OK


func apply_decor_selection(decor: Dictionary, appearances: Dictionary) -> bool:
	var catalog = DECOR_CATALOG_SCRIPT.new()
	var visuals = DECOR_VISUAL_ASSETS_SCRIPT.new()
	for slot in decor:
		if not slot is String or not decor[slot] is String or not catalog.is_compatible(slot, decor[slot]):
			return false
	for slot in appearances:
		if not slot is String or not appearances[slot] is String or decor.get(slot, "") != "pet_cushion" or appearances[slot] not in visuals.get_cushion_appearance_ids():
			return false
	var candidate_decor := decor.duplicate(true)
	var candidate_appearances := appearances.duplicate(true)
	if _boat_decor_persistence.save(candidate_decor, candidate_appearances) != OK:
		return false
	boat_decor = candidate_decor
	boat_decor_appearances = candidate_appearances
	return true


## Restores cosmetic boat decor or keeps an empty boat when the file is unavailable.
func load_boat_decor() -> void:
	var restored := _boat_decor_persistence.load()
	boat_decor = restored.get("decor", {})
	boat_decor_appearances = restored.get("appearances", {})


## Returns the selected visual player family without changing gameplay state.
func get_selected_player_style() -> String:
	return selected_player_style


## Returns the selected visual companion species without changing gameplay state.
func get_selected_pet_type() -> String:
	return selected_pet_type


## Stores a selected player family as local cosmetic state only.
func set_selected_player_style(value: String) -> bool:
	return apply_identity_selection(value, selected_pet_type)


## Stores a selected companion species as local cosmetic state only.
func set_selected_pet_type(value: String) -> bool:
	return apply_identity_selection(selected_player_style, value)


## Switches the identity storage target for isolated contract tests.
func set_identity_storage_path(path: String) -> void:
	if path == "":
		return
	_identity_profile = IDENTITY_PROFILE_SCRIPT.new(path)
	load_identity()


## Writes only the selected visual identity to the local device.
func save_identity() -> bool:
	return _identity_profile.save(selected_player_style, selected_pet_type) == OK


func apply_identity_selection(player_style: String, pet_type: String) -> bool:
	if _identity_profile.normalize_player_style(player_style) != player_style or _identity_profile.normalize_pet_type(pet_type) != pet_type:
		return false
	if _identity_profile.save(player_style, pet_type) != OK:
		return false
	selected_player_style = player_style
	selected_pet_type = pet_type
	return true


## Restores selected visual identity or keeps the approved C + dog default.
func load_identity() -> void:
	var restored := _identity_profile.load()
	selected_player_style = str(restored.get("player_style_id", "c_loose_knit"))
	selected_pet_type = str(restored.get("pet_type_id", "dog"))


## Switches the together-time storage target for isolated contract tests.
func set_together_time_storage_path(path: String) -> void:
	if path == "":
		return
	_together_time_persistence = TOGETHER_TIME_PERSISTENCE_SCRIPT.new(path)
	_unsaved_together_time_seconds = 0.0
	_together_time_since_save_attempt = 0.0
	load_together_time()


## Accumulates only real active-voyage time without action or speed bonuses.
func advance_together_time(delta: float) -> void:
	if not voyage_active:
		return
	if not is_finite(delta):
		return
	var safe_delta := maxf(delta, 0.0)
	if is_zero_approx(safe_delta):
		return
	together_time_seconds += safe_delta
	_unsaved_together_time_seconds += safe_delta
	_together_time_since_save_attempt += safe_delta
	if _together_time_since_save_attempt >= TOGETHER_TIME_SAVE_INTERVAL_SECONDS:
		flush_together_time()


## Writes the current global together-time total to the local device.
func flush_together_time() -> bool:
	var previous_status := str(_together_time_persistence.get_last_storage_result().get("status", ""))
	if is_zero_approx(_unsaved_together_time_seconds) and previous_status in ["", "OK", "ABSENT", "COMMITTED"]:
		return true
	_together_time_since_save_attempt = 0.0
	if _together_time_persistence.save_seconds(together_time_seconds) != OK:
		return false
	_unsaved_together_time_seconds = 0.0
	return true


## Restores together time or safely starts at zero when local data is unavailable.
func load_together_time() -> void:
	together_time_seconds = _together_time_persistence.load_seconds()
	_unsaved_together_time_seconds = 0.0
	_together_time_since_save_attempt = 0.0


## Switches the ambient-memory storage target for isolated contract tests.
func set_ambient_memory_storage_path(path: String) -> void:
	if path == "":
		return
	_ambient_memory_persistence = AMBIENT_MEMORY_PERSISTENCE_SCRIPT.new(path)
	load_ambient_memories()


## Records one automatically discovered scenery memory and persists it immediately.
func record_ambient_memory(entry: String) -> bool:
	var normalized_entry := entry.strip_edges()
	if normalized_entry.is_empty():
		return false
	var candidate: Array[String] = ambient_memories.duplicate()
	candidate.append(normalized_entry)
	if _ambient_memory_persistence.save_entries(candidate) != OK:
		return false
	ambient_memories = candidate
	sceneries = ambient_memories.duplicate()
	return true


## Restores only durable ambient scenery memories for the existing Album consumer.
func load_ambient_memories() -> void:
	ambient_memories = _ambient_memory_persistence.load_entries()
	sceneries = ambient_memories.duplicate()


## Switches the local comfort storage target for isolated contract tests.
func set_comfort_storage_path(path: String) -> void:
	if path == "":
		return
	_comfort_preferences = COMFORT_PREFERENCES_SCRIPT.new(path)
	load_motion_comfort()


## Stores a local motion-comfort choice without mutating voyage progress or atmosphere.
func set_motion_comfort_profile(profile: String) -> bool:
	motion_comfort_profile = _comfort_preferences.normalize_profile(profile)
	return _comfort_preferences.save_profile(motion_comfort_profile) == OK


## Cycles through the three optional visual-motion comfort profiles.
func cycle_motion_comfort_profile() -> bool:
	var profiles: Array[String] = COMFORT_PREFERENCES_SCRIPT.PROFILE_ORDER
	var current_index := profiles.find(get_motion_comfort_profile())
	var next_index := (current_index + 1) % profiles.size()
	return set_motion_comfort_profile(profiles[next_index])


## Returns the normalized local visual-motion preference.
func get_motion_comfort_profile() -> String:
	return _comfort_preferences.normalize_profile(motion_comfort_profile)


## Returns a presentation-only amplitude multiplier for boat and camera motion.
func get_motion_comfort_scale() -> float:
	return _comfort_preferences.get_motion_scale(get_motion_comfort_profile())


## Restores visual-motion comfort without changing device-clock atmosphere or player progress.
func load_motion_comfort() -> void:
	motion_comfort_profile = _comfort_preferences.load_profile()
	_ocean_volume = _comfort_preferences.load_ocean_volume()
	ocean_volume_changed.emit(_ocean_volume)


## Applies sound immediately even if the local preference cannot be saved.
func set_ocean_volume(volume: float) -> bool:
	if not is_finite(volume) or volume < 0.0 or volume > 1.0:
		return false
	_ocean_volume = volume
	ocean_volume_changed.emit(_ocean_volume)
	return _comfort_preferences.save_ocean_volume(volume) == OK


func get_ocean_volume() -> float:
	return _ocean_volume


## Switches postcard metadata and PNG storage together for isolated contract tests.
func set_photo_memory_storage(config_path: String, image_directory: String) -> void:
	if config_path == "" or image_directory == "":
		return
	_photo_memory_persistence = PHOTO_MEMORY_PERSISTENCE_SCRIPT.new(config_path, image_directory)
	load_photo_memories()


## Stores one real local postcard without changing voyage progress or ambient discovery state.
func record_photo_memory(image: Image, label: String, atmosphere_id: String) -> bool:
	var result := _photo_memory_persistence.save_photo(image, label, atmosphere_id)
	if not bool(result.get("ok", false)):
		return false
	var entry: Dictionary = result.duplicate(true)
	entry.erase("ok")
	photo_memories.append(entry)
	photos.append(str(entry.get("label", "")))
	return true


## Restores valid postcard entries and rebuilds the existing quiet photo summary.
func load_photo_memories() -> void:
	photo_memories = _photo_memory_persistence.load_entries()
	photos.clear()
	for entry in photo_memories:
		photos.append(str(entry.get("label", "")))


func resolve_photo_path(entry: Dictionary) -> String:
	return _photo_memory_persistence.resolve_photo_path(entry)


func load_photo_image(entry: Dictionary) -> Image:
	return _photo_memory_persistence.load_photo_image(entry)


## Switches fish and completed-voyage storage for isolated contract tests.
func set_memory_ledger_storage_path(path: String) -> void:
	if path == "":
		return
	_memory_ledger_persistence = MEMORY_LEDGER_PERSISTENCE_SCRIPT.new(path)
	load_memory_ledger()


## Writes only quiet fish memories and completed voyage summaries to the local device.
func save_memory_ledger() -> bool:
	return _memory_ledger_persistence.save_entries(fish, voyage_records) == OK


## Restores only fish memories and completed voyage summaries, never bottle letters.
func load_memory_ledger() -> void:
	var restored := _memory_ledger_persistence.load_entries()
	fish.clear()
	for entry in restored.get("fish", []):
		fish.append(str(entry))
	voyage_records.clear()
	for entry in restored.get("voyage_records", []):
		voyage_records.append(str(entry))


## Advances the active voyage timer and reports when it reaches zero this tick.
func tick_voyage(delta: float) -> bool:
	if not voyage_active or remaining_seconds <= 0.0 or not is_finite(delta):
		return false
	remaining_seconds = maxf(0.0, remaining_seconds - maxf(delta, 0.0))
	return remaining_seconds <= 0.0


## Creates exactly one memory record only after an active voyage reaches zero.
func complete_voyage() -> bool:
	if not voyage_active or remaining_seconds > 0.0 or voyage_record_created:
		return false
	var photos_this_voyage := maxi(0, photos.size() - _voyage_photo_start_count)
	var scenery_this_voyage := maxi(0, sceneries.size() - _voyage_scenery_start_count)
	var letters_this_voyage := maxi(0, letters.size() - _voyage_letter_start_count)
	var fish_this_voyage := maxi(0, fish.size() - _voyage_fish_start_count)
	if _pending_voyage_summary.is_empty():
		_pending_voyage_summary = "오늘의 항해 · 사진 %d · 풍경 %d · 편지 %d · 물고기 %d" % [
			photos_this_voyage,
			scenery_this_voyage,
			letters_this_voyage,
			fish_this_voyage,
		]
	var candidate_records: Array[String] = voyage_records.duplicate()
	candidate_records.append(_pending_voyage_summary)
	if _memory_ledger_persistence.save_entries(fish, candidate_records) != OK:
		return false
	voyage_records = candidate_records
	voyage_record_created = true
	_pending_voyage_summary = ""
	return true


func retry_pending_voyage_record() -> bool:
	if _pending_voyage_summary.is_empty():
		return false
	return complete_voyage()


## Adds a photo album entry.
func add_photo(entry: String) -> void:
	photos.append(entry)


## Adds a scenery album entry.
func add_scenery(entry: String) -> void:
	sceneries.append(entry)


## Adds a bottle letter entry.
func add_letter(entry: String) -> void:
	letters.append(entry)


## Adds a caught fish as a quiet memory without turning fishing repetition into affection farming.
func add_fish(entry: String) -> bool:
	var candidate: Array[String] = fish.duplicate()
	candidate.append(entry)
	if _memory_ledger_persistence.save_entries(candidate, voyage_records) != OK:
		return false
	fish = candidate
	return true


func get_storage_status(owner_id: String) -> Dictionary:
	var owner = _storage_owner(owner_id)
	return owner.get_last_storage_result() if owner != null else {}


func recover_storage(owner_id: String) -> bool:
	var owner = _storage_owner(owner_id)
	if owner == null:
		return false
	var result: Dictionary = owner.recover_primary()
	if result.get("status", "") != "COMMITTED":
		return false
	match owner_id:
		"identity": load_identity()
		"boat_decor": load_boat_decor()
		"ambient_memory": load_ambient_memories()
		"memory_ledger": load_memory_ledger()
		"photo_memory": load_photo_memories()
		"comfort": pass
	# together_time intentionally preserves this execution's unsaved accumulation.
	return true


func retry_owner_storage(owner_id: String) -> bool:
	match owner_id:
		"identity": return save_identity()
		"boat_decor": return save_boat_decor()
		"together_time": return flush_together_time()
		"ambient_memory": return _ambient_memory_persistence.save_entries(ambient_memories) == OK
		"memory_ledger": return retry_pending_voyage_record() if not _pending_voyage_summary.is_empty() else save_memory_ledger()
		"comfort": return _comfort_preferences.save_preferences(motion_comfort_profile, _ocean_volume) == OK
	return false


func _storage_owner(owner_id: String):
	return {
		"identity": _identity_profile,
		"boat_decor": _boat_decor_persistence,
		"together_time": _together_time_persistence,
		"ambient_memory": _ambient_memory_persistence,
		"memory_ledger": _memory_ledger_persistence,
		"photo_memory": _photo_memory_persistence,
		"comfort": _comfort_preferences,
	}.get(owner_id)
