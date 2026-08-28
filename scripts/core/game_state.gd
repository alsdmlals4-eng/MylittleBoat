# 항해의 누적 기억과 현재 세션 상태를 관리한다.
extends Node

const VOYAGE_SECONDS := 300.0
const BOAT_DECOR_PERSISTENCE_SCRIPT = preload("res://scripts/core/boat_decor_persistence.gd")
const IDENTITY_PROFILE_SCRIPT = preload("res://scripts/core/cosmetic_identity_profile.gd")
const AMBIENT_MEMORY_PERSISTENCE_SCRIPT = preload("res://scripts/core/ambient_memory_persistence.gd")

var companion_affection: int = 1

# 여러 항해에 걸쳐 유지되는 기억이다.
var photos: Array[String] = []
var sceneries: Array[String] = []
var letters: Array[String] = []
var fish: Array[String] = []
var voyage_records: Array[String] = []
var boat_decor: Dictionary = {}
var boat_decor_appearances: Dictionary = {}
var selected_player_style := "c_loose_knit"
var selected_pet_type := "dog"

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
var _ambient_memory_persistence = AMBIENT_MEMORY_PERSISTENCE_SCRIPT.new()


func _ready() -> void:
	load_boat_decor()
	load_identity()
	load_ambient_memories()


## Starts a fresh five-minute voyage while preserving accumulated memories and boat decoration.
func begin_voyage() -> void:
	reset_session()
	voyage_active = true
	_voyage_photo_start_count = photos.size()
	_voyage_scenery_start_count = sceneries.size()
	_voyage_letter_start_count = letters.size()
	_voyage_fish_start_count = fish.size()


## Clears only transient voyage state. Album memories, boat decor, and companion progress stay intact.
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


## Adds a photo album entry.
func add_photo(entry: String) -> void:
	photos.append(entry)


## Adds a scenery album entry.
func add_scenery(entry: String) -> void:
	sceneries.append(entry)


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


## Adds a bottle letter entry.
func add_letter(entry: String) -> void:
	letters.append(entry)


## Adds a caught fish as a quiet memory without turning fishing repetition into affection farming.
func add_fish(entry: String) -> void:
	fish.append(entry)

