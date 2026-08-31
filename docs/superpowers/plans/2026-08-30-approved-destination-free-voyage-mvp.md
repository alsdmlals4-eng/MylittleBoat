# Approved Destination-Free Voyage MVP Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 승인된 Revision 2.2의 목적지 없는 보트 휴식을 실제 Godot 시작 화면, 자동 시간대, 저밀도 풍경, 승인 시각 자산 소비처로 구현한다.

**Architecture:** `RealTimeAtmosphereResolver`는 현지 hour를 네 개의 visual-only time ID로 바꾸는 순수 owner다. `GameScene`은 resolver 결과를 `TimeOfDayCatalog` tone과 승인된 배경 texture에 적용하며, `DriftSceneryDirector`에는 foreground `delta`만 전달한다. director가 낸 조용한 풍경 기회는 화면의 비상호작용 label과 선택적 local scenery memory로만 소비하며, 목적지·button·보상·progress를 만들지 않는다.

**Tech Stack:** Godot 4.7.2 stable, GDScript, SceneTree, `Time.get_time_dict_from_system(false)`, existing `GameState` Autoload and headless contract scripts.

**Spec:** `docs/superpowers/specs/2026-08-29-real-time-atmosphere-and-drifting-scenery-design.md`, `docs/design/PROJECT_AI_PRODUCTION_SPEC.md` Revision 2.2, `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md` section 5.1.

## Global Constraints

- `project.godot` starts `res://scenes/game.tscn`; the first view shows boat, player, companion, sea, and horizon without mood, identity, pet, or time setup controls.
- Local hour maps as `05–08=dawn`, `09–16=bright`, `17–20=sunset`, and `21–04=night`. System clock is visual-only and never mutates records, memories, affection, speed, session duration, or persistence.
- Active foreground `delta` alone advances drifting scenery. Pause, focus-out, and other-app time do not advance it.
- Runtime uses `MLB-BP-VIS-001` to `MLB-BP-VIS-005`; `MLB-BP-VIS-006` remains the Human Blueprint flow-map image and is not a game texture.
- Keep `HANDPAINTED_STORYBOOK_3D_DIORAMA`, `SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT`, C loose-knit/long-hair + dog, and `INDIGO_RAIN_REFLECTION` visual constraints.
- No combat, failure, route, arrival, reward track, economy, social expansion, realtime chat, or public bottle capability.
- Do not commit, push, reset, clean, rebase, or modify open PR #19 in the dirty current checkout.

---

## File Structure

| File | Responsibility |
| --- | --- |
| `scripts/voyage/real_time_atmosphere_resolver.gd` | Pure local-hour mapping and production system-time lookup. |
| `scripts/voyage/drift_scenery_director.gd` | Foreground-only event cadence and optional local-memory decision. |
| `scripts/core/game_state.gd` | Mood/time preference retirement; neutral voyage record and non-farming memory storage. |
| `scripts/voyage/game_scene.gd` | Direct entry, tone application, runtime texture selection, compact menu, foreground lifecycle, and director consumption. |
| `scenes/game.tscn` | Compact `RestMenuButton`, hidden initial action panel, refresh timer, scenery label, and approved backdrop resources. |
| `assets/images/runtime/voyage/` | Five user-approved PNGs used by the actual runtime. |
| `tests/test_*.gd` | Clock, direct-entry, state, scene, and foreground-only scenery contracts. |
| `tests/capture_four_time_atmosphere.gd` | Injected-hour 540x960 normal/appreciation captures. |
| `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md` | Exact runtime consumer, asset state, SHA, evidence boundary. |
| `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`, `README.md` | Current runtime state, controls, startup route, and verification instructions. |

## Task 1: Add testable real-time atmosphere resolution

**Files:**

- Create: `scripts/voyage/real_time_atmosphere_resolver.gd`
- Modify: `tests/test_time_of_day_contract.gd`
- Modify: `scripts/voyage/time_of_day_catalog.gd`

**Interfaces:**

- Produces `RealTimeAtmosphereResolver.resolve_hour(hour: int) -> String`.
- Produces `RealTimeAtmosphereResolver.resolve_system_time() -> String`.
- Retains `TimeOfDayCatalog.get_time_of_day_ids() -> Array[String]` and `get_visual_tone(value: String) -> Dictionary`.

- [ ] **Step 1: Write the failing resolver contract.**

```gdscript
const RESOLVER_PATH := "res://scripts/voyage/real_time_atmosphere_resolver.gd"
_expect(ResourceLoader.exists(RESOLVER_PATH), "real-time atmosphere resolver must exist")
var resolver = load(RESOLVER_PATH).new()
_expect(resolver.resolve_hour(5) == "dawn", "05:00 must be Dawn")
_expect(resolver.resolve_hour(9) == "bright", "09:00 must be Bright")
_expect(resolver.resolve_hour(17) == "sunset", "17:00 must be Sunset")
_expect(resolver.resolve_hour(21) == "night", "21:00 must be Night")
_expect(resolver.resolve_hour(0) == "night", "00:00 must be Night")
_expect(resolver.resolve_hour(-1) == "bright", "invalid hour must safely fall back to Bright")
```

- [ ] **Step 2: Run the single contract and confirm the missing resolver fails.**

```powershell
& $godot --headless --path . --script res://tests/test_time_of_day_contract.gd
```

- [ ] **Step 3: Implement the smallest pure resolver.**

```gdscript
# 현지 현실 시간을 승인된 항해 분위기 ID로 바꾼다.
class_name RealTimeAtmosphereResolver
extends RefCounted

func resolve_hour(hour: int) -> String:
	if hour < 0 or hour > 23:
		return "bright"
	if hour <= 4 or hour >= 21:
		return "night"
	if hour <= 8:
		return "dawn"
	if hour <= 16:
		return "bright"
	return "sunset"

func resolve_system_time() -> String:
	var local_time := Time.get_time_dict_from_system(false)
	return resolve_hour(int(local_time.get("hour", -1)))
```

- [ ] **Step 4: Re-run the contract and confirm the full time-ID catalog remains unchanged.**

```powershell
& $godot --headless --path . --script res://tests/test_time_of_day_contract.gd
```

## Task 2: Retire mood and saved time preference from voyage state

**Files:**

- Modify: `scripts/core/game_state.gd`
- Modify: `scripts/ui/album_view.gd`
- Modify: `tests/test_calm_voyage_state.gd`
- Modify: `tests/test_album_composition_contract.gd`

**Interfaces:**

- Changes `GameState.begin_voyage()` to take no argument.
- Removes `selected_mood`, `select_mood`, `selected_time_of_day`, `select_time_of_day`, and `get_selected_time_of_day` from product state.
- Retains existing local cosmetic identity/decor persistence and `tick_voyage(delta: float) -> bool`.

- [ ] **Step 1: Replace mood-dependent state assertions with direct-start and non-farming assertions.**

```gdscript
_expect(state.has_method("begin_voyage"), "GameState must expose direct begin_voyage")
state.begin_voyage()
_expect(state.voyage_active, "direct start must activate the voyage")
_expect(is_equal_approx(state.remaining_seconds, 300.0), "direct start keeps the five-minute baseline")
var source := FileAccess.get_file_as_string("res://scripts/core/game_state.gd")
_expect(not source.contains("selected_mood"), "mood must not remain product state")
_expect(not source.contains("selected_time_of_day"), "saved time preference must not remain product state")
var affection_before := state.companion_affection
state.add_photo("사진")
state.add_scenery("풍경")
state.add_letter("편지")
_expect(state.companion_affection == affection_before, "memory actions must not farm companion affection")
```

- [ ] **Step 2: Run the state contract and confirm it fails on the legacy state.**

```powershell
& $godot --headless --path . --script res://tests/test_calm_voyage_state.gd
```

- [ ] **Step 3: Implement the state retirement without changing cosmetic storage.**

```gdscript
func begin_voyage() -> void:
	reset_session()
	voyage_active = true
	_voyage_photo_start_count = photos.size()
	_voyage_scenery_start_count = sceneries.size()
	_voyage_letter_start_count = letters.size()
	_voyage_fish_start_count = fish.size()
```

Set voyage record text to `오늘의 항해 · 사진 %d · 풍경 %d · 편지 %d · 물고기 %d`. Keep memories as album data but stop calling `_increase_affection()` from `add_photo`, `add_scenery`, and `add_letter`. Make Album background resolve current local time through Task 1 rather than a saved selection.

- [ ] **Step 4: Run direct state and Album composition contracts.**

```powershell
& $godot --headless --path . --script res://tests/test_calm_voyage_state.gd
& $godot --headless --path . --script res://tests/test_album_composition_contract.gd
```

## Task 3: Make the boat the direct first view with a compact optional menu

**Files:**

- Modify: `project.godot`
- Modify: `scenes/game.tscn`
- Modify: `scripts/voyage/game_scene.gd`
- Create: `tests/test_direct_boat_entry_contract.gd`
- Modify: `tests/test_game_scene_contract.gd`
- Modify: `tests/test_main_menu_identity_contract.gd`
- Modify: `tests/test_main_menu_time_of_day_contract.gd`
- Modify: `tests/test_main_menu_atmosphere_background_contract.gd`

**Interfaces:**

- Main route is `res://scenes/game.tscn`.
- `GameScene.open_rest_menu() -> void` and `GameScene.close_rest_menu() -> void` control the existing optional action grid.
- `RestMenuButton` is visible in normal mode; `BottomPanel` starts hidden.

- [ ] **Step 1: Write the failing direct-entry contract.**

```gdscript
_expect(ProjectSettings.get_setting("application/run/main_scene", "") == "res://scenes/game.tscn", "main scene must enter the boat directly")
var scene := (load("res://scenes/game.tscn") as PackedScene).instantiate()
root.add_child(scene)
await process_frame
_expect(scene.get_node_or_null("RestMenuButton") != null, "first view needs one compact menu entry")
_expect(not (scene.get_node_or_null("BottomPanel") as Control).visible, "first view must not show the large action grid")
_expect(scene.get_node_or_null("TopPanel/TopVBox/MoodStatusLabel") == null, "first view must not expose mood UI")
_expect(scene.get_node_or_null("VoyageWorld/BoatSpace") != null, "boat must be present at direct entry")
```

- [ ] **Step 2: Run the new contract and confirm legacy main-menu routing fails.**

```powershell
& $godot --headless --path . --script res://tests/test_direct_boat_entry_contract.gd
```

- [ ] **Step 3: Implement direct entry and neutral first-frame copy.**

```ini
[application]
run/main_scene="res://scenes/game.tscn"
```

Rename `MoodStatusLabel` to `VoyageStatusLabel` with neutral text such as `동반자와 바다를 보고 있어요.`. Add `RestMenuButton` in the lower safe area, begin with `BottomPanel.visible = false`, and connect it to show the current action grid. Close the grid when returning from a nested action; do not surface any mood, time, player, or pet setup panel before the boat. Preserve the existing menu scene only as unreachable legacy material and replace its tests with assertions that the application route does not consume it.

- [ ] **Step 4: Run direct-entry and normal-scene smoke checks.**

```powershell
& $godot --headless --path . --script res://tests/test_direct_boat_entry_contract.gd
& $godot --headless --path . --script res://tests/test_game_scene_contract.gd
& $godot --headless --path . --scene res://scenes/game.tscn --quit-after 1
```

## Task 4: Connect the five approved landscape assets to real-time runtime atmosphere

**Files:**

- Move: five `MLB-BP-VIS-001` to `MLB-BP-VIS-005` PNGs from `docs/visual/approved/2026-08-30-destination-free-voyage/` to `assets/images/runtime/voyage/`
- Modify: `scenes/game.tscn`
- Modify: `scripts/voyage/game_scene.gd`
- Modify: `tests/test_game_scene_time_of_day_contract.gd`
- Modify: `tests/test_runtime_image_asset_contract.gd`
- Modify: `scripts/visual/runtime_capture_guard.gd`

**Interfaces:**

- `GameScene.apply_real_time_atmosphere_for_hour(hour: int) -> String` applies a deterministic test hour.
- `GameScene.refresh_real_time_atmosphere() -> String` uses production local system time.
- `GameScene.get_active_atmosphere_id() -> String` exposes the active visual state for contracts.

- [ ] **Step 1: Write failing texture and injected-hour expectations.**

```gdscript
_expect(ResourceLoader.exists("res://assets/images/runtime/voyage/main-entry-bright-open-sea.png"), "approved bright entry texture must be runtime-loadable")
_expect(ResourceLoader.exists("res://assets/images/runtime/voyage/dawn-sea-arches-waterfall.png"), "approved dawn texture must be runtime-loadable")
var bright := await _capture_scene_tone(packed_scene, 12)
var night := await _capture_scene_tone(packed_scene, 22)
_expect(bright.get("atmosphere_id", "") == "bright", "12:00 must apply Bright")
_expect(night.get("atmosphere_id", "") == "night", "22:00 must apply Night")
_expect(bright.get("texture_path", "").ends_with("main-entry-bright-open-sea.png"), "Bright uses the approved direct-entry image")
_expect(night.get("texture_path", "").ends_with("night-indigo-rain-bay.png"), "Night uses the approved indigo-rain image")
```

- [ ] **Step 2: Run the contract and confirm missing runtime asset paths/injected API fail.**

```powershell
& $godot --headless --path . --script res://tests/test_game_scene_time_of_day_contract.gd
```

- [ ] **Step 3: Move approved assets and apply them to both camera backdrops.**

Use these exact mappings: `dawn → dawn-sea-arches-waterfall.png`, `bright → main-entry-bright-open-sea.png`, `sunset → sunset-sandstone-cove.png`, `night → night-indigo-rain-bay.png`. The second bright landscape, `bright-clear-seagrass-lagoon.png`, is a director-only scenery variation. Keep one shared tone/texture map for Diorama and Appreciation `SeaBackdrop` nodes. On initial load apply immediately; later system-hour changes may tween only tone modulation over 1.5 seconds without changing session state.

- [ ] **Step 4: Add focus/resume refresh and verify camera parity.**

Implement `NOTIFICATION_APPLICATION_FOCUS_IN` and `NOTIFICATION_APPLICATION_RESUMED` to call `set_application_foreground(true)` and refresh. Implement `NOTIFICATION_APPLICATION_FOCUS_OUT` and `NOTIFICATION_APPLICATION_PAUSED` to call `set_application_foreground(false)`. A repeating `AtmosphereRefreshTimer` calls `refresh_real_time_atmosphere()` every 30 seconds.

- [ ] **Step 5: Run time/image contracts and a headless scene smoke.**

```powershell
& $godot --headless --path . --script res://tests/test_game_scene_time_of_day_contract.gd
& $godot --headless --path . --script res://tests/test_runtime_image_asset_contract.gd
& $godot --headless --path . --scene res://scenes/game.tscn --quit-after 1
```

## Task 5: Add foreground-only low-density drifting scenery

**Files:**

- Create: `scripts/voyage/drift_scenery_director.gd`
- Modify: `scripts/voyage/game_scene.gd`
- Modify: `scenes/game.tscn`
- Create: `tests/test_drift_scenery_director.gd`
- Modify: `tests/test_game_scene_contract.gd`

**Interfaces:**

- `DriftSceneryDirector.set_foreground(is_foreground: bool) -> void`.
- `DriftSceneryDirector.advance(delta: float) -> Dictionary`; returns `{}` or one `{ "label": String, "save_memory": bool, "use_bright_lagoon": bool }` event.
- `DriftSceneryDirector.get_foreground_elapsed_seconds() -> float` is contract-visible.

- [ ] **Step 1: Write a failing foreground-only cadence test.**

```gdscript
var director = load("res://scripts/voyage/drift_scenery_director.gd").new()
director.set_next_event_seconds_for_tests(2.0)
director.set_foreground(false)
_expect(director.advance(5.0).is_empty(), "background time must not create scenery")
_expect(is_zero_approx(director.get_foreground_elapsed_seconds()), "background time must not accumulate")
director.set_foreground(true)
_expect(director.advance(1.0).is_empty(), "event must wait for foreground elapsed time")
var event := director.advance(1.0)
_expect(not event.is_empty(), "foreground elapsed time must create one low-density scenery event")
_expect(not event.has("button"), "scenery event must not create interaction UI")
```

- [ ] **Step 2: Run the director test and confirm the missing script fails.**

```powershell
& $godot --headless --path . --script res://tests/test_drift_scenery_director.gd
```

- [ ] **Step 3: Implement deterministic-test hooks and production cadence.**

Use a first event range of 90–150 active seconds and a follow-up range of 120–180 active seconds. `advance()` never emits more than one event per call. Each event picks a short non-interactive label. A memory event is allowed to call `GameState.add_scenery()` only when its `save_memory` value is true; zero saves is always valid and no event increments companion affection. Use `use_bright_lagoon` only for a bright-time event, showing the approved lagoon texture temporarily before returning to the current time texture.

- [ ] **Step 4: Consume the event without a button, reward, or expiry penalty.**

Add a non-interactive `DistantSceneryLabel` to `game.tscn`. `GameScene` fades the label in/out, optionally displays the bright lagoon variation, and never creates `LetterButton`, `SceneryButton`, route, arrival, or task UI. Remove the former 18–30 second pending discovery scheduling and action-gated record functions from the product route.

- [ ] **Step 5: Run director and scene contracts.**

```powershell
& $godot --headless --path . --script res://tests/test_drift_scenery_director.gd
& $godot --headless --path . --script res://tests/test_game_scene_contract.gd
```

## Task 6: Capture, update owners, and re-verify the integrated MVP

**Files:**

- Modify: `tests/capture_four_time_atmosphere.gd`
- Modify: `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md`
- Modify: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`
- Modify: `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`
- Modify: `README.md`

- [ ] **Step 1: Update capture to use injected hours rather than GameState time preference.**

```gdscript
scene.apply_real_time_atmosphere_for_hour(hour)
_expect(scene.get_active_atmosphere_id() == time_of_day_id, "capture hour must apply requested visual ID")
```

Keep eight captures in `docs/evidence/2026-08-30-direct-entry-real-time/`: normal and appreciation for each approved time ID at 540x960. Do not call any legacy time-selector API.

- [ ] **Step 2: Run the capture and inspect all eight generated images.**

```powershell
& $godot --headless --path . --script res://tests/capture_four_time_atmosphere.gd
```

Render/contact-review every capture. Confirm the boat, player, companion, sea, horizon, menu button, and both camera modes remain legible without the former startup panel.

- [ ] **Step 3: Update canonical ownership and evidence labels.**

Move `MLB-BP-VIS-001` through `MLB-BP-VIS-005` from `CANON_REGISTERED` to `IMPLEMENTED` only after resource load and scene consumer checks. Mark `RUNTIME_VERIFIED` only after the captures are present and inspected. Keep `MLB-BP-VIS-006` as `HUMAN_BLUEPRINT_CANON / NOT_IMPLEMENTED`. Update current handoff gaps, AI spec QA statuses, README controls/start route, and the actual Godot 4.7.2 fallback path.

- [ ] **Step 4: Run the complete automated set and core smokes.**

```powershell
$tests = Get-ChildItem tests -Filter 'test_*.gd' -File | Sort-Object Name
foreach ($test in $tests) { & $godot --headless --path . --script ("res://tests/" + $test.Name); if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE } }
& $godot --headless --path . --quit
& $godot --headless --path . --scene res://scenes/game.tscn --quit-after 1
& $godot --headless --path . --scene res://scenes/album.tscn --quit-after 1
```

- [ ] **Step 5: Record the evidence ceiling exactly.**

Report automated-test and captured-runtime results separately from manual Human validation. Leave first-30-second, five-minute, touch, motion, text, and sound comfort as `NOT_RUN` unless an actual person/device run supplies evidence.

## Plan Self-Review

- [x] Each approved MVP requirement maps to a task: direct entry (Task 3), local-hour visual-only tone (Tasks 1 and 4), foreground-only scenery (Task 5), concrete approved image consumer (Task 4), automated/capture verification (Task 6).
- [x] The plan does not introduce a destination, reward track, social capability, new image generation, or together-time rate/threshold system.
- [x] API names used across tasks are declared before their consumer tasks.
- [x] Every production-code task begins with a specified failing Godot contract and includes its green verification command.
