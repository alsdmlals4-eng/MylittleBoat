# Four-Time Atmosphere Layer Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add a player-selected Dawn/Bright/Sunset/Night atmosphere treatment to the existing voyage without changing its mechanics or approved visual identity.

**Architecture:** A small `TimeOfDayCatalog` owns the four allowed IDs and their restrained visual definitions. `GameState` stores only the normalized process-lifetime selection; Main Menu changes that selection; Game Scene applies the catalog to environment, key light, and both camera-local backdrops before its existing mood tint.

**Tech Stack:** Godot 4.7 stable, GDScript, `.tscn`, SceneTree contract scripts, Godot headless capture.

**Spec:** `docs/superpowers/specs/2026-08-27-four-time-atmosphere-design.md`

## Global Constraints

- Preserve C + dog default, approved runtime assets, camera rigs, BoatSpace/bob, 5-minute voyage, all low-pressure systems, and PR #19 read-only/no-absorption.
- No new binary asset, shader, add-on, map, audio, continuous clock, persistence, reward, penalty, unlock, or in-voyage time control.
- `bright` is the default and invalid fallback; time selection remains process-lifetime only.
- Every new GDScript begins with a one-line Korean role comment.
- Do not stage generated `.import` or `.uid` files.

---

### Task 1: Establish the time-of-day data contract

**Files:**
- Create: `scripts/voyage/time_of_day_catalog.gd`
- Modify: `scripts/core/game_state.gd`
- Test: `tests/test_time_of_day_contract.gd`

**Interfaces:**
- Produces `TimeOfDayCatalog.get_time_of_day_ids() -> Array[String]`, `normalize_time_of_day(value: String) -> String`, `get_label(value: String) -> String`, and `get_visual_tone(value: String) -> Dictionary`.
- Produces `GameState.select_time_of_day(value: String) -> void` and `GameState.get_selected_time_of_day() -> String`.

- [ ] **Step 1: Write the failing test**

```gdscript
_expect(catalog.get_time_of_day_ids() == ["dawn", "bright", "sunset", "night"], "time IDs must remain approved and ordered")
_expect(catalog.normalize_time_of_day("invalid") == "bright", "unknown time must fall back to Bright")
_expect(game_state.get_selected_time_of_day() == "bright", "fresh state must begin at Bright")
```

- [ ] **Step 2: Run test to verify it fails**

Run: `godot --headless --path . --script res://tests/test_time_of_day_contract.gd`

Expected: fail because the catalog and GameState time API do not exist.

- [ ] **Step 3: Write minimal implementation**

```gdscript
var selected_time_of_day := "bright"

func select_time_of_day(value: String) -> void:
	selected_time_of_day = _time_of_day_catalog.normalize_time_of_day(value)

func get_selected_time_of_day() -> String:
	return selected_time_of_day
```

Keep visual definitions in the catalog and do not write them to disk.

- [ ] **Step 4: Run focused contract to verify it passes**

Run: `godot --headless --path . --script res://tests/test_time_of_day_contract.gd`

Expected: `PASS: time-of-day contract`.

- [ ] **Step 5: Commit**

```powershell
git add scripts/voyage/time_of_day_catalog.gd scripts/core/game_state.gd tests/test_time_of_day_contract.gd
git commit -m "Add voyage time-of-day state"
```

### Task 2: Expose the quiet pre-voyage choice

**Files:**
- Modify: `scenes/main_menu.tscn`
- Modify: `scripts/ui/main_menu.gd`
- Test: `tests/test_main_menu_time_of_day_contract.gd`

**Interfaces:**
- Consumes `GameState.select_time_of_day` and `TimeOfDayCatalog` labels.
- Produces a unique `TimeOfDayOption` whose item metadata is a catalog ID.

- [ ] **Step 1: Write the failing test**

```gdscript
_expect(time_option != null and time_option.item_count == 4, "menu must show four approved light choices")
time_option.emit_signal("item_selected", 3)
_expect(game_state.get_selected_time_of_day() == "night", "menu time selection must update GameState")
_expect(game_state.selected_mood == before_mood and game_state.photos.size() == before_photos, "light choice must not create state or progression")
```

- [ ] **Step 2: Run test to verify it fails**

Run: `godot --headless --path . --script res://tests/test_main_menu_time_of_day_contract.gd`

Expected: fail because `TimeOfDayOption` is absent.

- [ ] **Step 3: Write minimal implementation**

Populate the option from catalog IDs in `_ready()`, select GameState’s normalized current value, and write only the chosen metadata in `_on_time_of_day_selected(index)`.

- [ ] **Step 4: Run focused contract to verify it passes**

Run: `godot --headless --path . --script res://tests/test_main_menu_time_of_day_contract.gd`

Expected: `PASS: main menu time-of-day contract`.

- [ ] **Step 5: Commit**

```powershell
git add scenes/main_menu.tscn scripts/ui/main_menu.gd tests/test_main_menu_time_of_day_contract.gd
git commit -m "Add time-of-day voyage selector"
```

### Task 3: Apply one shared atmosphere to both camera modes

**Files:**
- Modify: `scenes/game.tscn`
- Modify: `scripts/voyage/game_scene.gd`
- Test: `tests/test_game_scene_time_of_day_contract.gd`

**Interfaces:**
- Consumes `GameState.get_selected_time_of_day()` and catalog tone dictionaries.
- Produces `_apply_time_of_day_tone()` called before `_apply_mood_tone()`.

- [ ] **Step 1: Write the failing test**

```gdscript
_expect(dawn_background != bright_background, "Dawn must visibly differ from Bright")
_expect(night_backdrop_modulate != Color.WHITE, "Night must tint both camera-local backdrops")
_expect(bright_backdrop_modulate == Color.WHITE, "Bright must preserve the approved Bright sea art")
```

- [ ] **Step 2: Run test to verify it fails**

Run: `godot --headless --path . --script res://tests/test_game_scene_time_of_day_contract.gd`

Expected: fail because Game Scene has no time-of-day application.

- [ ] **Step 3: Write minimal implementation**

Apply the catalog’s environment, ambient, directional-light, and backdrop modulate values to the existing nodes. Both `SeaBackdrop` nodes use the same color. Retain the existing mood method as the final background-only subtle modifier.

- [ ] **Step 4: Run focused contract to verify it passes**

Run: `godot --headless --path . --script res://tests/test_game_scene_time_of_day_contract.gd`

Expected: `PASS: game scene time-of-day contract`.

- [ ] **Step 5: Commit**

```powershell
git add scenes/game.tscn scripts/voyage/game_scene.gd tests/test_game_scene_time_of_day_contract.gd
git commit -m "Apply four voyage atmosphere tones"
```

### Task 4: Capture, validate, and document the bounded slice

**Files:**
- Create: `tests/capture_four_time_atmosphere.gd`
- Create: `docs/evidence/2026-08-27-four-time-atmosphere/`
- Modify: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`
- Modify: `docs/GODOT_MVP_ROADMAP.md`
- Modify: `README.md`

**Interfaces:**
- Produces eight 540×960 PNG capture files named `{time}_{camera}_540x960.png`.

- [ ] **Step 1: Write the capture utility**

The utility instantiates `game.tscn` once per approved time, waits for one rendered frame, saves Normal, triggers the existing Appreciation button, waits one rendered frame, then saves Appreciation. It must restore `GameState` transient state after each run.

- [ ] **Step 2: Run headless import and all contracts**

Run: `godot --headless --editor --path . --quit`, then all existing `tests/test_*.gd` plus the three new focused contracts.

Expected: all pass; known `ObjectDB` exit warning remains documented baseline, not a new pass criterion.

- [ ] **Step 3: Run Main Menu and Game scene smokes plus the capture utility**

Run the two headless scenes and the capture script. Inspect dimensions with image metadata and verify the eight expected files exist.

- [ ] **Step 4: Update durable status**

State `FOUR_TIME_ATMOSPHERE_AUTOMATED = PASS`, `FOUR_TIME_RUNTIME_CAPTURE = PASS`, and preserve `REAL_DEVICE_MOBILE_QA = DEFERRED / HUMAN_COMFORT = NOT_RUN`. Record no image asset was added and PR #19 remained read-only.

- [ ] **Step 5: Commit**

```powershell
git add tests/capture_four_time_atmosphere.gd docs/evidence/2026-08-27-four-time-atmosphere docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md docs/GODOT_MVP_ROADMAP.md README.md
git commit -m "Document four-time atmosphere evidence"
```

