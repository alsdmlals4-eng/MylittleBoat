# 항해의 누적 기억과 현재 세션 상태를 관리한다.
extends Node

const VOYAGE_SECONDS := 300.0

var selected_mood: String = "평온"
var companion_affection: int = 1

# 여러 항해에 걸쳐 유지되는 기억이다.
var photos: Array[String] = []
var sceneries: Array[String] = []
var letters: Array[String] = []
var fish: Array[String] = []
var voyage_records: Array[String] = []
var boat_decor: Dictionary = {}
var boat_decor_appearances: Dictionary = {}

# Scene 전환에도 유지되어야 하는 현재 항해 상태다.
var voyage_active := false
var remaining_seconds := VOYAGE_SECONDS
var speed_index := 1
var appreciation_mode := false
var voyage_record_created := false
var pending_discovery_type := ""
var pending_discovery_value := ""

var _voyage_photo_start_count := 0
var _voyage_scenery_start_count := 0
var _voyage_letter_start_count := 0
var _voyage_fish_start_count := 0


## Selects today's mood before entering the sea scene.
func select_mood(mood: String) -> void:
	selected_mood = mood


## Starts a fresh five-minute voyage while preserving accumulated memories and boat decoration.
func begin_voyage(mood: String) -> void:
	select_mood(mood)
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
	pending_discovery_type = ""
	pending_discovery_value = ""


## Stores or clears one cosmetic boat-decor choice without creating rewards.
func set_boat_decor(slot_id: String, item_id: String) -> void:
	if slot_id == "":
		return
	if item_id == "":
		boat_decor.erase(slot_id)
		boat_decor_appearances.erase(slot_id)
	else:
		boat_decor[slot_id] = item_id


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


## Returns the stored cosmetic appearance for one boat decor slot.
func get_boat_decor_appearance(slot_id: String) -> String:
	return str(boat_decor_appearances.get(slot_id, ""))


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
		"%s의 항해 · 사진 %d · 풍경 %d · 편지 %d · 물고기 %d" % [
			selected_mood,
			photos_this_voyage,
			scenery_this_voyage,
			letters_this_voyage,
			fish_this_voyage,
		]
	)


## Stores one ambient discovery until the player records or ignores it.
func set_pending_discovery(discovery_type: String, value: String) -> void:
	pending_discovery_type = discovery_type
	pending_discovery_value = value


## Clears the current ambient discovery without applying a penalty.
func clear_pending_discovery() -> void:
	pending_discovery_type = ""
	pending_discovery_value = ""


## Adds a photo album entry.
func add_photo(entry: String) -> void:
	photos.append(entry)
	_increase_affection()


## Adds a scenery album entry.
func add_scenery(entry: String) -> void:
	sceneries.append(entry)
	_increase_affection()


## Adds a bottle letter entry.
func add_letter(entry: String) -> void:
	letters.append(entry)
	_increase_affection()


## Adds a caught fish as a quiet memory without turning fishing repetition into affection farming.
func add_fish(entry: String) -> void:
	fish.append(entry)


func _increase_affection() -> void:
	var relationship_memory_count := photos.size() + sceneries.size() + letters.size()
	companion_affection = clampi(1 + int(relationship_memory_count / 2), 1, 3)
