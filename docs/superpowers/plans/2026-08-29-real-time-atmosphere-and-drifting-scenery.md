# Real-Time Atmosphere and Drifting Scenery Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (- [ ]) syntax for tracking.

**Goal:** 선택 화면 없이 보트에서 시작하고, 현실 시간의 분위기와 active foreground 풍경 흐름을 휴식 경험으로 구현한다.

**Architecture:** RealTimeAtmosphereResolver는 입력 hour를 네 승인 ID로 변환하는 순수 owner다. GameScene은 이 결과를 기존 TimeOfDayCatalog tone에 적용하고 app focus notification으로 foreground 여부를 관리한다. DriftSceneryDirector는 foreground delta만 받아 멀리 지나가는 풍경과 선택적인 local ambient memory 기회를 반환하며, GameScene만 그것을 Scene·notification으로 소비한다.

**Tech Stack:** Godot 4.7 stable, GDScript, Node application-focus notification, Time, Timer, SceneTree, 기존 headless contract scripts.

**Spec:** docs/superpowers/specs/2026-08-29-real-time-atmosphere-and-drifting-scenery-design.md

## Execution receipt · 2026-08-29

This implementation plan has been executed on `codex/issue-101-direct-boat-entry`.

| task | outcome |
| --- | --- |
| 1 | `e6e9bd6` added the resolver and the time mapping contract. |
| 2 | `e8595ed` retired mood and stored atmosphere state. |
| 3–4 | direct `game.tscn` entry, compact menu, optional cosmetics, focus-aware 30-second real-time atmosphere refresh, dedicated night sea art, and legacy route compatibility are implemented. |
| 5 | foreground-only scenery director, local ambient memory persistence, named far-scenery consumers, and tests are implemented. |
| 6 | target-resolution GPU captures, evidence receipt, current handoff, visual consumer/provenance records, and adversarial correction receipt are included in the final Issue #101 implementation commit. |

Unchecked historical TDD steps below are retained as the approved execution record. The actual completion source is this receipt plus the commit/test/capture evidence, not the unchecked template markers.

## Global Constraints

- 첫 frame은 scenes/game.tscn의 normal 3/4 boat diorama이며 startup mood/identity/pet/time panel이 없다.
- 05–08=dawn, 09–16=bright, 17–20=sunset, 21–04=night를 현지 시스템 시간에 적용한다.
- 시스템 시간은 visual only다. 보상, memory, affection, voyage progress, persistence의 입력으로 사용하지 않는다.
- active foreground delta만 drifting scenery를 진행한다. focus-out·pause·다른 앱 전환은 진행하지 않는다.
- 명목 5분에는 약 1–2개의 distant scenery 기회를 만들며 memory zero는 정상이다. 탭, 보상, 과제, missed-event penalty를 만들지 않는다.
- 새 GDScript 첫 줄에는 파일 역할을 설명하는 한국어 주석을 둔다.
- HANDPAINTED_STORYBOOK_3D_DIORAMA, SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT, INDIGO_RAIN_REFLECTION을 지키며 다른 게임의 표현을 모방하지 않는다.
- PR #19는 read-only다. direct main, force push, reset/clean/rebase, 새 social/economy/progression은 금지한다.

---

### Task 1: 현실 시간 resolver와 catalog 계약

**Files:**
- Create: scripts/voyage/real_time_atmosphere_resolver.gd
- Modify: tests/test_time_of_day_contract.gd
- Modify: scripts/voyage/time_of_day_catalog.gd

**Interfaces:**
- Consumes: TimeOfDayCatalog.normalize_time_of_day(value: String) -> String
- Produces: RealTimeAtmosphereResolver.resolve_hour(hour: int) -> String and resolve_system_time() -> String

- [ ] **Step 1: Write the failing test**

~~~gdscript
const RESOLVER_PATH := "res://scripts/voyage/real_time_atmosphere_resolver.gd"
_expect(ResourceLoader.exists(RESOLVER_PATH), "real-time atmosphere resolver must exist")
var resolver = load(RESOLVER_PATH).new()
_expect(resolver.resolve_hour(5) == "dawn", "05:00 must be Dawn")
_expect(resolver.resolve_hour(9) == "bright", "09:00 must be Bright")
_expect(resolver.resolve_hour(17) == "sunset", "17:00 must be Sunset")
_expect(resolver.resolve_hour(21) == "night", "21:00 must be Night")
_expect(resolver.resolve_hour(0) == "night", "00:00 must be Night")
_expect(resolver.resolve_hour(-1) == "bright", "invalid hour must safely fall back to Bright")
~~~

- [ ] **Step 2: Run test to verify it fails**

Run: godot --headless --path . --script res://tests/test_time_of_day_contract.gd

Expected: resolver file assertion fails.

- [ ] **Step 3: Write minimal implementation**

~~~gdscript
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
	var time_dict := Time.get_time_dict_from_system(false)
	return resolve_hour(int(time_dict.get("hour", -1)))
~~~

TimeOfDayCatalog의 ID 순서와 tone dictionary는 유지한다. resolver는 selected_time_of_day 또는 save file을 만들지 않는다.

- [ ] **Step 4: Run test to verify it passes**

Run: godot --headless --path . --script res://tests/test_time_of_day_contract.gd

Expected: PASS: time-of-day contract.

- [ ] **Step 5: Commit**

~~~powershell
git add scripts/voyage/real_time_atmosphere_resolver.gd scripts/voyage/time_of_day_catalog.gd tests/test_time_of_day_contract.gd
git commit -m "Add real-time atmosphere resolver"
~~~

### Task 2: mood와 저장된 시간 선택을 retire한 direct voyage state

**Files:**
- Modify: scripts/core/game_state.gd
- Modify: tests/test_calm_voyage_state.gd
- Modify: tests/test_game_scene_contract.gd

**Interfaces:**
- Consumes: Task 1 resolver output as a visual input only.
- Produces: GameState.begin_voyage() -> void, mood 없는 voyage record wording, existing tick_voyage(delta: float) -> bool.

- [ ] **Step 1: Write the failing test**

~~~gdscript
state.begin_voyage()
_expect(state.voyage_active, "direct start must activate the voyage")
_expect(is_equal_approx(state.remaining_seconds, 300.0), "direct start must keep the 5-minute baseline")
var state_source := FileAccess.get_file_as_string("res://scripts/core/game_state.gd")
_expect(not state_source.contains("selected_mood"), "mood must not remain product state")
state.remaining_seconds = 0.0
state.complete_voyage()
_expect(not state.voyage_records.back().contains("의 항해"), "record must not name a removed mood")
~~~

The former time-selector assertions become checks that a resolver hour never changes photos, sceneries, letters, fish, affection, or records.

- [ ] **Step 2: Run test to verify it fails**

Run: godot --headless --path . --script res://tests/test_calm_voyage_state.gd

Expected: no-argument start and removed-mood assertions fail.

- [ ] **Step 3: Write minimal implementation**

~~~gdscript
func begin_voyage() -> void:
	reset_session()
	voyage_active = true
	_voyage_photo_start_count = photos.size()
	_voyage_scenery_start_count = sceneries.size()
	_voyage_letter_start_count = letters.size()
	_voyage_fish_start_count = fish.size()
~~~

Delete selected_mood, select_mood, selected_time_of_day, select_time_of_day, and get_selected_time_of_day. Set record copy to "오늘의 항해 · 사진 %d · 풍경 %d · 편지 %d · 물고기 %d". Do not migrate an old mood to a new player-visible state. Make add_photo, add_scenery, and add_letter append memories without calling _increase_affection; the confirmed foreground-time affection system remains a later contract, so an ambient scenery memory cannot become an affection reward.

- [ ] **Step 4: Run test to verify it passes**

Run: godot --headless --path . --script res://tests/test_calm_voyage_state.gd

Run: godot --headless --path . --script res://tests/test_game_scene_contract.gd

Expected: both pass with no mood-facing assertion.

- [ ] **Step 5: Commit**

~~~powershell
git add scripts/core/game_state.gd tests/test_calm_voyage_state.gd tests/test_game_scene_contract.gd
git commit -m "Retire mood voyage state"
~~~

### Task 3: direct boat entry와 낮은 첫 화면 UI

**Files:**
- Modify: project.godot
- Modify: scenes/game.tscn
- Modify: scripts/voyage/game_scene.gd
- Modify: tests/test_game_scene_contract.gd
- Create: tests/test_direct_boat_entry_contract.gd

**Interfaces:**
- Consumes: GameState.begin_voyage() -> void from Task 2.
- Produces: main route to scenes/game.tscn, GameScene.open_rest_menu() -> void, GameScene.close_rest_menu() -> void.

- [ ] **Step 1: Write the failing test**

~~~gdscript
var main_scene := ProjectSettings.get_setting("application/run/main_scene", "")
_expect(main_scene == "res://scenes/game.tscn", "main scene must enter the boat directly")
var scene := (load("res://scenes/game.tscn") as PackedScene).instantiate()
root.add_child(scene)
await process_frame
_expect(scene.get_node_or_null("RestMenuButton") != null, "first view needs one compact rest-menu entry")
_expect(not scene.get_node_or_null("BottomPanel").visible, "first view must not show the large action grid")
_expect(scene.get_node_or_null("MoodStatusLabel") == null, "first view must not expose removed mood UI")
_expect(scene.get_node_or_null("VoyageWorld/BoatSpace") != null, "boat remains visible at direct entry")
~~~

- [ ] **Step 2: Run test to verify it fails**

Run: godot --headless --path . --script res://tests/test_direct_boat_entry_contract.gd

Expected: main route and compact-menu assertions fail.

- [ ] **Step 3: Write minimal implementation**

Set application/run/main_scene to res://scenes/game.tscn. On GameScene._ready(), call GameState.begin_voyage() only when no voyage is active. Rename MoodStatusLabel to VoyageStatusLabel and render only neutral copy "동반자와 바다를 보고 있어요.".

Add one visible RestMenuButton at the lower safe area with text "메뉴"; begin with BottomPanel.visible = false. Its press opens the existing action grid. Closing 꾸미기, interaction, album return, and Appreciation mode must not accidentally show the grid on first entry. The panel must not include mood, time, player, or pet startup choices.

- [ ] **Step 4: Run test to verify it passes**

Run: godot --headless --path . --script res://tests/test_direct_boat_entry_contract.gd

Run: godot --headless --path . --scene res://scenes/game.tscn --quit-after 1

Expected: direct entry passes and the scene opens without a task-related error.

- [ ] **Step 5: Commit**

~~~powershell
git add project.godot scenes/game.tscn scripts/voyage/game_scene.gd tests/test_game_scene_contract.gd tests/test_direct_boat_entry_contract.gd
git commit -m "Enter the boat directly"
~~~

### Task 4: 현실 시간 tone refresh와 optional 꾸미기 entry

**Files:**
- Modify: scenes/game.tscn
- Modify: scripts/voyage/game_scene.gd
- Modify: tests/test_game_scene_time_of_day_contract.gd
- Modify: tests/test_main_menu_identity_contract.gd
- Modify: tests/test_main_menu_time_of_day_contract.gd
- Modify: tests/test_main_menu_atmosphere_background_contract.gd

**Interfaces:**
- Consumes: RealTimeAtmosphereResolver.resolve_hour(hour: int) -> String and TimeOfDayCatalog.get_visual_tone(id: String) -> Dictionary.
- Produces: GameScene.apply_real_time_atmosphere_for_hour(hour: int) -> String and GameScene.set_application_foreground(is_foreground: bool) -> void for tests.

- [ ] **Step 1: Write the failing test**

~~~gdscript
var bright := await _capture_scene_tone(packed_scene, 12)
var night := await _capture_scene_tone(packed_scene, 22)
_expect(bright.get("atmosphere_id", "") == "bright", "12:00 must use Bright")
_expect(night.get("atmosphere_id", "") == "night", "22:00 must use Night")
_expect(bright.get("background", Color.BLACK) != night.get("background", Color.BLACK), "night tone must visibly differ")
_expect(night.get("diorama_modulate", Color.WHITE) == night.get("appreciation_modulate", Color.BLACK), "both cameras share one night treatment")
~~~

The three legacy main-menu tests retain only direct-entry assertions. They must not ask the player to select a time, identity, or pet before the boat is visible.

- [ ] **Step 2: Run test to verify it fails**

Run: godot --headless --path . --script res://tests/test_game_scene_time_of_day_contract.gd

Expected: hour injection and apply_real_time_atmosphere_for_hour assertions fail.

- [ ] **Step 3: Write minimal implementation**

Add a repeating AtmosphereRefreshTimer with wait_time = 30.0. Resolve the local system hour in production and an injected hour in tests. On NOTIFICATION_APPLICATION_FOCUS_IN and NOTIFICATION_APPLICATION_RESUMED, set foreground true and refresh immediately; on NOTIFICATION_APPLICATION_FOCUS_OUT and NOTIFICATION_APPLICATION_PAUSED, set foreground false. Use a 1.5-second Tween only after the first resolved ID changes. Apply one backdrop modulate to both cameras.

Expand the existing DecorPanel into optional 꾸미기: retain decor controls and add player-style/pet-type OptionButtons populated from the existing cosmetic profile/router. Persist only the existing identity/decor profile. Do not add a time option or a gameplay effect.

- [ ] **Step 4: Run test to verify it passes**

Run: godot --headless --path . --script res://tests/test_game_scene_time_of_day_contract.gd

Run: godot --headless --path . --script res://tests/test_main_menu_identity_contract.gd

Run: godot --headless --path . --script res://tests/test_main_menu_time_of_day_contract.gd

Run: godot --headless --path . --script res://tests/test_main_menu_atmosphere_background_contract.gd

Expected: all pass with direct-entry language; no retained gate requests setup choices.

- [ ] **Step 5: Commit**

~~~powershell
git add scenes/game.tscn scripts/voyage/game_scene.gd tests/test_game_scene_time_of_day_contract.gd tests/test_main_menu_identity_contract.gd tests/test_main_menu_time_of_day_contract.gd tests/test_main_menu_atmosphere_background_contract.gd
git commit -m "Apply real-time boat atmosphere"
~~~

### Task 5: active foreground drifting scenery와 runtime art consumer

**Files:**
- Create: scripts/voyage/drift_scenery_director.gd
- Create: scenes/distant_scenery.tscn
- Create: assets/images/runtime/scenery/distant_islet_storybook.png
- Create: assets/images/runtime/scenery/distant_buoy_storybook.png
- Create: assets/images/runtime/scenery/distant_lighthouse_storybook.png
- Modify: scenes/game.tscn
- Modify: scripts/voyage/game_scene.gd
- Create: tests/test_drift_scenery_director.gd
- Modify: docs/visual/2026-08-26-game-image-consumer-manifest.md

**Interfaces:**
- Consumes: GameScene.set_application_foreground(is_foreground: bool) -> void and scene delta.
- Produces: DriftSceneryDirector.advance(delta: float, is_foreground: bool) -> Dictionary with show_scenery, scenery_id, and save_memory keys.

- [ ] **Step 1: Write the failing test**

~~~gdscript
var director = load("res://scripts/voyage/drift_scenery_director.gd").new(12345)
_expect(director.get_active_seconds() == 0.0, "new scenery director starts empty")
director.advance(151.0, false)
_expect(director.get_active_seconds() == 0.0, "background time must not advance scenery")
var event := director.advance(151.0, true)
_expect(director.get_active_seconds() == 151.0, "foreground time advances scenery")
_expect(bool(event.get("show_scenery", false)), "first foreground window shows distant scenery")
_expect(not event.has("reward"), "scenery event must not expose a reward")
~~~

- [ ] **Step 2: Run test to verify it fails**

Run: godot --headless --path . --script res://tests/test_drift_scenery_director.gd

Expected: missing director assertion fails.

- [ ] **Step 3: Write minimal implementation**

~~~gdscript
# 활성 화면 시간에만 지나가는 먼 풍경 기회를 관리한다.
class_name DriftSceneryDirector
extends RefCounted

func advance(delta: float, is_foreground: bool) -> Dictionary:
	if not is_foreground or delta <= 0.0:
		return {}
	_active_seconds += delta
	if _active_seconds < _next_scenery_second:
		return {}
	var scenery_id := _take_next_scenery_id()
	_next_scenery_second += _rng.randf_range(90.0, 150.0)
	return {"show_scenery": true, "scenery_id": scenery_id, "save_memory": _rng.randf() < 0.45}
~~~

Use one DistantSceneryAnchor beyond the boat and active camera horizon. A selected Sprite3D begins outside the horizon, moves laterally slowly, and queue-frees outside frame. It may not occlude avatar, pet, boat, or main horizon. When save_memory is true, call GameState.add_scenery("지나간 %s" % label) once and show a non-blocking label for 2.5 seconds; otherwise show no text.

Generate the three named transparent PNGs before wiring them. Each must be a hand-painted storybook far-distance silhouette, use the approved sea/sky palette family, contain no text/logo/character, and be recorded as a runtime consumer with source/provenance. Do not use a comparison board, copied reference, or photoreal image as the runtime texture.

- [ ] **Step 4: Run test to verify it passes**

Run: godot --headless --path . --script res://tests/test_drift_scenery_director.gd

Run: godot --headless --path . --scene res://scenes/game.tscn --quit-after 1

Expected: background elapsed remains zero, foreground creates only visual/memory event data, and the scene opens without texture or node errors.

- [ ] **Step 5: Commit**

~~~powershell
git add scripts/voyage/drift_scenery_director.gd scenes/distant_scenery.tscn assets/images/runtime/scenery scenes/game.tscn scripts/voyage/game_scene.gd tests/test_drift_scenery_director.gd docs/visual/2026-08-26-game-image-consumer-manifest.md
git commit -m "Add passive drifting scenery"
~~~

### Task 6: capture, documentation, and adversarial verification

**Files:**
- Create: tests/capture_direct_boat_entry_atmospheres.gd
- Modify: docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md
- Modify: docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md
- Modify: README.md

**Interfaces:**
- Consumes: Task 3 direct route, Task 4 apply_real_time_atmosphere_for_hour, Task 5 director event source.
- Produces: four 540 x 960 capture files under docs/evidence/2026-08-29-direct-boat-entry and an evidence-state readback.

- [ ] **Step 1: Write the failing test**

~~~gdscript
_expect(ResourceLoader.exists("res://tests/capture_direct_boat_entry_atmospheres.gd"), "direct-entry capture runner must exist")
var capture_source := FileAccess.get_file_as_string("res://tests/capture_direct_boat_entry_atmospheres.gd")
_expect(capture_source.contains("apply_real_time_atmosphere_for_hour"), "capture must inject approved hour states")
_expect(capture_source.contains("Vector2i(540, 960)"), "capture must use target portrait resolution")
~~~

- [ ] **Step 2: Run test to verify it fails**

Run: godot --headless --path . --script res://tests/test_direct_boat_entry_contract.gd

Expected: missing capture-runner assertion fails.

- [ ] **Step 3: Write minimal implementation**

Use the existing capture_four_time_atmosphere.gd pattern, but instantiate game.tscn as the project route, call apply_real_time_atmosphere_for_hour(6|12|18|22), wait ten frames, and save dawn, bright, sunset, night images at 540 x 960. Keep the compact rest-menu state closed. Do not call select_time_of_day or instantiate main_menu.tscn.

Update handoff/inventory/README to state only automated and capture evidence achieved. Retain Human first-30-seconds, five-minute, touch, and audio comfort as NOT_RUN until the user tests them.

- [ ] **Step 4: Run full required verification**

Run: godot --headless --path . --script res://tests/test_time_of_day_contract.gd

Run: godot --headless --path . --script res://tests/test_calm_voyage_state.gd

Run: godot --headless --path . --script res://tests/test_direct_boat_entry_contract.gd

Run: godot --headless --path . --script res://tests/test_game_scene_time_of_day_contract.gd

Run: godot --headless --path . --script res://tests/test_drift_scenery_director.gd

Run: godot --headless --path . --script res://tests/capture_direct_boat_entry_atmospheres.gd

Run: godot --headless --path . --quit

Expected: all contracts, smokes, and capture runner pass. Inspect the four 540 x 960 images and record only what they prove.

- [ ] **Step 5: Commit**

Verify before commit: main route has no main_menu; active docs contain no saved-atmosphere claim; system time does not touch progression; focus-out scenery test passes; scenery has no task/reward; the four captures preserve one visual grammar; generated textures have consumer/provenance; PR #19 is unchanged.

~~~powershell
git add tests/capture_direct_boat_entry_atmospheres.gd docs/evidence/2026-08-29-direct-boat-entry docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md README.md
git commit -m "Verify direct boat entry atmosphere"
~~~
