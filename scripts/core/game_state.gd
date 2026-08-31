# 항해의 누적 기억과 현재 세션 상태를 관리한다.
extends Node

const VOYAGE_SECONDS := 300.0
const BOAT_DECOR_PERSISTENCE_SCRIPT = preload("res://scripts/core/boat_decor_persistence.gd")
const IDENTITY_PROFILE_SCRIPT = preload("res://scripts/core/cosmetic_identity_profile.gd")
<<<<<<< HEAD
const TOGETHER_TIME_PERSISTENCE_SCRIPT = preload("res://scripts/core/together_time_persistence.gd")
const AMBIENT_MEMORY_PERSISTENCE_SCRIPT = preload("res://scripts/core/ambient_memory_persistence.gd")
const COMFORT_PREFERENCES_SCRIPT = preload("res://scripts/core/comfort_preferences.gd")
const PHOTO_MEMORY_PERSISTENCE_SCRIPT = preload("res://scripts/core/photo_memory_persistence.gd")
const MEMORY_LEDGER_PERSISTENCE_SCRIPT = preload("res://scripts/core/memory_ledger_persistence.gd")
const TOGETHER_TIME_SAVE_INTERVAL_SECONDS := 15.0
=======
const AMBIENT_MEMORY_PERSISTENCE_SCRIPT = preload("res://scripts/core/ambient_memory_persistence.gd")

var companion_affection: int = 1
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564

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
<<<<<<< HEAD
var _together_time_persistence = TOGETHER_TIME_PERSISTENCE_SCRIPT.new()
var _ambient_memory_persistence = AMBIENT_MEMORY_PERSISTENCE_SCRIPT.new()
var _comfort_preferences = COMFORT_PREFERENCES_SCRIPT.new()
var _photo_memory_persistence = PHOTO_MEMORY_PERSISTENCE_SCRIPT.new()
var _memory_ledger_persistence = MEMORY_LEDGER_PERSISTENCE_SCRIPT.new()
var _unsaved_together_time_seconds := 0.0
=======
var _ambient_memory_persistence = AMBIENT_MEMORY_PERSISTENCE_SCRIPT.new()
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564


func _ready() -> void:
	load_boat_decor()
	load_identity()
<<<<<<< HEAD
	load_together_time()
	load_ambient_memories()
	load_motion_comfort()
	load_photo_memories()
	load_memory_ledger()
=======
	load_ambient_memories()
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564


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
func set_boat_decor(slot_id: String, item_id: String) -> void:
	if slot_id == "":
		return
	if item_id == "":
		boat_decor.erase(slot_id)
		boat_decor_appearances.erase(slot_id)
	else:
		boat_decor[slot_id] = item_id
	save_boat_decor()


## Returns the process-lifetime cosmetic item stored in one boat slot.
func get_boat_decor(slot_id: String) -> String:
	return str(boat_decor.get(slot_id, ""))


## Stores or clears a cosmetic appearance without changing the stable decor item meaning.
func set_boat_decor_appearance(slot_id: String, appearance_id: String) -> void:
	if slot_id == "":
		return
	if appearance_id == "":
		boat_decor_appearances.erase(slot_id)
	else:
		boat_decor_appearances[slot_id] = appearance_id
	save_boat_decor()


## Returns the stored cosmetic appearance for one boat decor slot.
func get_boat_decor_appearance(slot_id: String) -> String:
	return str(boat_decor_appearances.get(slot_id, ""))


## Switches the local cosmetic decor storage target without loading gameplay state.
func set_boat_decor_storage_path(path: String) -> void:
	if path == "":
		return
	_boat_decor_persistence = BOAT_DECOR_PERSISTENCE_SCRIPT.new(path)


## Writes only cosmetic boat decor to the local device.
func save_boat_decor() -> void:
	_boat_decor_persistence.save(boat_decor, boat_decor_appearances)


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
func set_selected_player_style(value: String) -> void:
	selected_player_style = _identity_profile.normalize_player_style(value)
	save_identity()


## Stores a selected companion species as local cosmetic state only.
func set_selected_pet_type(value: String) -> void:
	selected_pet_type = _identity_profile.normalize_pet_type(value)
	save_identity()


## Switches the identity storage target for isolated contract tests.
func set_identity_storage_path(path: String) -> void:
	if path == "":
		return
	_identity_profile = IDENTITY_PROFILE_SCRIPT.new(path)
	load_identity()


## Writes only the selected visual identity to the local device.
func save_identity() -> void:
	_identity_profile.save(selected_player_style, selected_pet_type)


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
	load_together_time()


## Accumulates only real active-voyage time without action or speed bonuses.
func advance_together_time(delta: float) -> void:
	if not voyage_active:
		return
	var safe_delta := maxf(delta, 0.0)
	if is_zero_approx(safe_delta):
		return
	together_time_seconds += safe_delta
	_unsaved_together_time_seconds += safe_delta
	if _unsaved_together_time_seconds >= TOGETHER_TIME_SAVE_INTERVAL_SECONDS:
		flush_together_time()


## Writes the current global together-time total to the local device.
func flush_together_time() -> void:
	_together_time_persistence.save_seconds(together_time_seconds)
	_unsaved_together_time_seconds = 0.0


## Restores together time or safely starts at zero when local data is unavailable.
func load_together_time() -> void:
	together_time_seconds = _together_time_persistence.load_seconds()
	_unsaved_together_time_seconds = 0.0


## Switches the ambient-memory storage target for isolated contract tests.
func set_ambient_memory_storage_path(path: String) -> void:
	if path == "":
		return
	_ambient_memory_persistence = AMBIENT_MEMORY_PERSISTENCE_SCRIPT.new(path)
	load_ambient_memories()


## Records one automatically discovered scenery memory and persists it immediately.
func record_ambient_memory(entry: String) -> void:
	var normalized_entry := entry.strip_edges()
	if normalized_entry.is_empty():
		return
	ambient_memories.append(normalized_entry)
	sceneries.append(normalized_entry)
	_ambient_memory_persistence.save_entries(ambient_memories)


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
func set_motion_comfort_profile(profile: String) -> void:
	motion_comfort_profile = _comfort_preferences.normalize_profile(profile)
	_comfort_preferences.save_profile(motion_comfort_profile)


## Cycles through the three optional visual-motion comfort profiles.
func cycle_motion_comfort_profile() -> void:
	var profiles: Array[String] = COMFORT_PREFERENCES_SCRIPT.PROFILE_ORDER
	var current_index := profiles.find(get_motion_comfort_profile())
	var next_index := (current_index + 1) % profiles.size()
	set_motion_comfort_profile(profiles[next_index])


## Returns the normalized local visual-motion preference.
func get_motion_comfort_profile() -> String:
	return _comfort_preferences.normalize_profile(motion_comfort_profile)


## Returns a presentation-only amplitude multiplier for boat and camera motion.
func get_motion_comfort_scale() -> float:
	return _comfort_preferences.get_motion_scale(get_motion_comfort_profile())


## Restores visual-motion comfort without changing device-clock atmosphere or player progress.
func load_motion_comfort() -> void:
	motion_comfort_profile = _comfort_preferences.load_profile()


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


## Switches fish and completed-voyage storage for isolated contract tests.
func set_memory_ledger_storage_path(path: String) -> void:
	if path == "":
		return
	_memory_ledger_persistence = MEMORY_LEDGER_PERSISTENCE_SCRIPT.new(path)
	load_memory_ledger()


## Writes only quiet fish memories and completed voyage summaries to the local device.
func save_memory_ledger() -> void:
	_memory_ledger_persistence.save_entries(fish, voyage_records)


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
	if not voyage_active or remaining_seconds <= 0.0:
		return false
	remaining_seconds = maxf(0.0, remaining_seconds - maxf(delta, 0.0))
	return remaining_seconds <= 0.0


## Creates exactly one memory record only after an active voyage reaches zero.
func complete_voyage() -> void:
	if not voyage_active or remaining_seconds > 0.0 or voyage_record_created:
		return
	voyage_record_created = true
	var photos_this_voyage := maxi(0, photos.size() - _voyage_photo_start_count)
	var scenery_this_voyage := maxi(0, sceneries.size() - _voyage_scenery_start_count)
	var letters_this_voyage := maxi(0, letters.size() - _voyage_letter_start_count)
	var fish_this_voyage := maxi(0, fish.size() - _voyage_fish_start_count)
	voyage_records.append(
		"오늘의 항해 · 사진 %d · 풍경 %d · 편지 %d · 물고기 %d" % [
			photos_this_voyage,
			scenery_this_voyage,
			letters_this_voyage,
			fish_this_voyage,
		]
	)
<<<<<<< HEAD
	save_memory_ledger()
=======
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564


## Adds a photo album entry.
func add_photo(entry: String) -> void:
	photos.append(entry)


## Adds a scenery album entry.
func add_scenery(entry: String) -> void:
	sceneries.append(entry)
<<<<<<< HEAD
=======


## Adds one passive surrounding-scenery memory and writes it to the local device.
func add_ambient_scenery(entry: String) -> void:
	if entry.strip_edges().is_empty():
		return
	sceneries.append(entry)
	_ambient_memory_persistence.save(sceneries)


## Switches the ambient-memory storage target without changing other voyage state.
func set_ambient_memory_storage_path(path: String) -> void:
	if path == "":
		return
	_ambient_memory_persistence = AMBIENT_MEMORY_PERSISTENCE_SCRIPT.new(path)


## Restores automatic surrounding-scenery memories without touching other voyage state.
func load_ambient_memories() -> void:
	for entry in _ambient_memory_persistence.load():
		sceneries.append(entry)
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564


## Adds a bottle letter entry.
func add_letter(entry: String) -> void:
	letters.append(entry)


## Adds a caught fish as a quiet memory without turning fishing repetition into affection farming.
func add_fish(entry: String) -> void:
	fish.append(entry)
<<<<<<< HEAD
	save_memory_ledger()
=======

>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
