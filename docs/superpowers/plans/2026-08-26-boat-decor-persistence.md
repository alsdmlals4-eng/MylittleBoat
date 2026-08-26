# Boat Decor Local Persistence Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Keep approved cosmetic boat decor and pet-cushion appearance after a local app restart without persisting gameplay, reward, or social state.

**Architecture:** Add a small ConfigFile-backed `BoatDecorPersistence` service that only serializes the two existing decor dictionaries. `GameState` owns when it loads and saves, preserving all current callers and session-reset behavior. The service is independently testable with a disposable `user://` path; `GameState` remains the only runtime state owner.

**Tech Stack:** Godot 4.7.2 stable, GDScript, `ConfigFile`, existing SceneTree contract tests.

**Spec:** `docs/superpowers/specs/2026-08-26-boat-decor-persistence-design.md`

## Global Constraints

- Persist only `boat_decor` and `boat_decor_appearances` to `user://boat_decor_v1.cfg`.
- Never persist voyage, rewards, affinity, records, camera, mood, discovery, social, or time state.
- New GDScript files begin with a concise Korean role comment.
- Preserve existing eight slots, six item IDs, cosmetic-only semantics, and PR #19 independence.
- Invalid or unreadable data must fail closed to an empty boat with no penalty or modal UI.

---

### Task 1: Add an independently testable decor persistence service

**Files:**
- Create: `scripts/core/boat_decor_persistence.gd`
- Create: `tests/test_boat_decor_persistence.gd`

**Interfaces:**
- Produces: `BoatDecorPersistence.new(path := "user://boat_decor_v1.cfg")`.
- Produces: `save(decor: Dictionary, appearances: Dictionary) -> Error`.
- Produces: `load() -> Dictionary` with `decor` and `appearances` Dictionary entries.

- [ ] **Step 1: Write the failing round-trip and corrupt-file tests**

```gdscript
var store = persistence_script.new("user://boat_decor_persistence_contract.cfg")
_expect(store.save({"bow_left": "lantern"}, {"pet_corner": "moon"}) == OK, "save must succeed")
var restored := store.load()
_expect(restored["decor"] == {"bow_left": "lantern"}, "decor must round-trip")
_expect(restored["appearances"] == {"pet_corner": "moon"}, "appearance must round-trip")
```

- [ ] **Step 2: Run the test to verify it fails because the service is absent**

Run: `& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_boat_decor_persistence.gd`

Expected: FAIL because `res://scripts/core/boat_decor_persistence.gd` is missing.

- [ ] **Step 3: Implement the smallest ConfigFile service**

```gdscript
# 보트 꾸미기와 외형만 로컬 ConfigFile에 저장하고 복원한다.
class_name BoatDecorPersistence
extends RefCounted

const DEFAULT_PATH := "user://boat_decor_v1.cfg"
var _path: String

func _init(path: String = DEFAULT_PATH) -> void:
	_path = path

func save(decor: Dictionary, appearances: Dictionary) -> Error:
	var config := ConfigFile.new()
	config.set_value("boat_decor", "items", decor)
	config.set_value("boat_decor", "appearances", appearances)
	return config.save(_path)

func load() -> Dictionary:
	var config := ConfigFile.new()
	if config.load(_path) != OK:
		return {"decor": {}, "appearances": {}}
	return {"decor": _string_dictionary(config.get_value("boat_decor", "items", {})), "appearances": _string_dictionary(config.get_value("boat_decor", "appearances", {}))}
```

- [ ] **Step 4: Run the persistence test to verify it passes**

Run the Task 1 command. Expected: PASS including missing/corrupt-file empty-state assertions.

- [ ] **Step 5: Commit Task 1**

```powershell
git add scripts/core/boat_decor_persistence.gd tests/test_boat_decor_persistence.gd
git commit -m "Persist cosmetic boat decor locally"
```

### Task 2: Connect the existing GameState setters without widening stored state

**Files:**
- Modify: `scripts/core/game_state.gd`
- Modify: `tests/test_boat_decoration_contract.gd`

**Interfaces:**
- Consumes: `BoatDecorPersistence.save()` and `BoatDecorPersistence.load()` from Task 1.
- Produces: GameState startup restoration and setter-triggered saves for only decor dictionaries.

- [ ] **Step 1: Write failing GameState persistence assertions**

```gdscript
_expect(game_state.has_method("save_boat_decor"), "GameState must save cosmetic decor")
_expect(game_state.has_method("load_boat_decor"), "GameState must load cosmetic decor")
```

- [ ] **Step 2: Run the existing decoration contract to verify it fails**

Run: `& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_boat_decoration_contract.gd`

Expected: FAIL because the explicit persistence methods do not exist.

- [ ] **Step 3: Add minimal GameState integration**

```gdscript
const BOAT_DECOR_PERSISTENCE_SCRIPT = preload("res://scripts/core/boat_decor_persistence.gd")
var _boat_decor_persistence = BOAT_DECOR_PERSISTENCE_SCRIPT.new()

func _ready() -> void:
	load_boat_decor()

func save_boat_decor() -> void:
	_boat_decor_persistence.save(boat_decor, boat_decor_appearances)

func load_boat_decor() -> void:
	var restored := _boat_decor_persistence.load()
	boat_decor = restored["decor"]
	boat_decor_appearances = restored["appearances"]
```

Call `save_boat_decor()` at the end of both existing setter methods after their current mutation logic.

- [ ] **Step 4: Run the decoration and persistence contracts to verify they pass**

Run both Task 1 and Task 2 commands. Expected: PASS, with all existing reward-isolation assertions unchanged.

- [ ] **Step 5: Commit Task 2**

```powershell
git add scripts/core/game_state.gd tests/test_boat_decoration_contract.gd
git commit -m "Restore boat decor through GameState"
```

### Task 3: Record the bounded persistence evidence

**Files:**
- Modify: `README.md`
- Modify: `docs/GODOT_MVP_ROADMAP.md`
- Modify: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`

**Interfaces:**
- Consumes: passing Task 1/2 contracts.
- Produces: repository status distinguishing automated local persistence proof from still-deferred real-device QA.

- [ ] **Step 1: Update only the persistence status lines**

Set `APP_RESTART_DECOR_PERSISTENCE = AUTOMATED_LOCAL_RESTORE_PASS`; leave mobile/device values as `NOT_RUN` or `DEFERRED_BY_USER`.

- [ ] **Step 2: Run the full regression suite and smokes**

Run every `tests/test_*.gd` script, then `main_menu.tscn`, `game.tscn`, and `album.tscn` headless smokes with Godot 4.7.2. Expected: all exit 0.

- [ ] **Step 3: Check the diff and commit evidence**

```powershell
git diff --check
git add README.md docs/GODOT_MVP_ROADMAP.md docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md
git commit -m "Document local boat decor persistence"
```
