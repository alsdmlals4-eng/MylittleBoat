# Comfort Mode and Voyage Postcards Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Let players reduce or stop automatic boat/camera motion locally, and let a taken photo persist as a quiet real-image postcard in Album.

**Architecture:** A small ConfigFile value owns motion preference, and `GameState` exposes only normalized local preference behavior to the voyage scene. A separate postcard persistence owner writes PNG and metadata; `GameScene` obtains one post-draw image and Album displays the newest valid cards without creating any new route or progress system.

**Tech Stack:** Godot 4.7 stable, GDScript, `ConfigFile`, `Image.save_png`, `ViewportTexture.get_image`, `RenderingServer.frame_post_draw`.

**Spec:** `docs/superpowers/specs/2026-08-30-comfort-and-voyage-postcards-design.md`

**Execution receipt:** `COMPLETED` on 2026-08-30. The historical checkbox prose below records the intended TDD order, while current truth is owned by `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`. All five tasks were delivered. The rendered-frame GameScene contract runs on the OpenGL GPU route because `RenderingServer.frame_post_draw` does not fire under the headless renderer. Isolated tests clean only their own exact `user://test_*` paths; no production deletion API was added.

## Global Constraints

- Start directly in normal 3/4 diorama and do not add a startup selector or saved atmosphere preference.
- Keep core voyage/rest/photo/album local-first with no account, cloud, public sharing, rewards, tasks, score, or social pressure.
- `standard` remains the current approved motion baseline; `gentle` and `still` alter amplitude only.
- New GDScript files begin with a one-line Korean role comment.
- Image capture waits for a rendered frame and restores all hidden UI even on failure.
- New art assets are out of scope until candidates are separately approved.
- Preserve unrelated dirty worktree files and leave open PR #19 untouched.

---

### Task 1: Persist normalized motion comfort

**Status:** `COMPLETED`

**Files:**
- Create: `scripts/core/comfort_preferences.gd`
- Create: `tests/test_comfort_preferences.gd`
- Modify: `scripts/core/game_state.gd`
- Modify: `tests/test_calm_voyage_state.gd`

**Interfaces:**
- Produces `ComfortPreferences.new(path := DEFAULT_PATH)`, `save_profile(profile: String) -> Error`, `load_profile() -> String`, `normalize_profile(profile: String) -> String`, `get_motion_scale(profile: String) -> float`.
- Produces `GameState.set_motion_comfort_profile(profile: String)`, `GameState.cycle_motion_comfort_profile()`, `GameState.get_motion_comfort_profile() -> String`, `GameState.get_motion_comfort_scale() -> float`, and `GameState.set_comfort_storage_path(path: String)`.

- [ ] **Step 1: Write the failing preference persistence test**

```gdscript
var preferences = (load(PERSISTENCE_PATH) as Script).new(STORAGE_PATH)
_expect(preferences.load_profile() == "standard", "missing file restores standard")
_expect(preferences.save_profile("gentle") == OK, "valid profile writes locally")
_expect(preferences.load_profile() == "gentle", "saved profile round-trips")
_expect(preferences.normalize_profile("unknown") == "standard", "invalid profile is safe")
_expect(is_zero_approx(preferences.get_motion_scale("still")), "still removes automatic motion")
```

- [ ] **Step 2: Run the test and verify RED**

Run the Godot console with `--headless --path . --script res://tests/test_comfort_preferences.gd`.

Expected result: the file cannot load because `comfort_preferences.gd` is missing.

- [ ] **Step 3: Implement the smallest standalone persistence owner**

```gdscript
const PROFILE_ORDER: Array[String] = ["standard", "gentle", "still"]
const MOTION_SCALES := {"standard": 1.0, "gentle": 0.5, "still": 0.0}

func normalize_profile(profile: String) -> String:
    return profile if profile in PROFILE_ORDER else "standard"
```

Store only a normalized `profile` in `[comfort] profile`, and load `standard` if ConfigFile loading or data validation fails.

- [ ] **Step 4: Run the persistence test and verify GREEN**

Run the same targeted Godot test. Expected result: `PASS: comfort-preferences persistence contract`.

- [ ] **Step 5: Write the failing GameState isolation test**

```gdscript
var remaining_before := state.remaining_seconds
var speed_before := state.speed_index
var together_before := state.together_time_seconds
state.set_motion_comfort_profile("gentle")
_expect(state.get_motion_comfort_profile() == "gentle", "GameState exposes selected local comfort profile")
_expect(is_equal_approx(state.get_motion_comfort_scale(), 0.5), "GameState exposes gentle amplitude")
_expect(is_equal_approx(state.remaining_seconds, remaining_before), "comfort does not change voyage timer")
_expect(state.speed_index == speed_before and is_equal_approx(state.together_time_seconds, together_before), "comfort does not change speed or together time")
```

- [ ] **Step 6: Run the GameState contract and verify RED**

Run the Godot console with `--headless --path . --script res://tests/test_calm_voyage_state.gd`.

Expected result: missing GameState comfort API assertion fails.

- [ ] **Step 7: Add GameState as consumer of the persistence owner**

Load the preference in `_ready()`, keep profile separate from gameplay state, and persist only through the named preference API.

- [ ] **Step 8: Re-run both tests and verify GREEN**

Run both focused scripts. Expected result: both PASS with no test assertion failures.

### Task 2: Apply motion comfort through the existing rest menu

**Status:** `COMPLETED`

**Files:**
- Modify: `scenes/game.tscn`
- Modify: `scripts/voyage/game_scene.gd`
- Modify: `tests/test_game_scene_contract.gd`

**Interfaces:**
- Consumes `GameState.get_motion_comfort_scale()` and `GameState.cycle_motion_comfort_profile()`.
- Produces `ComfortButton` and `GameScene._get_motion_comfort_label() -> String`.

- [ ] **Step 1: Write the failing scene behavior test**

```gdscript
state.set_motion_comfort_profile("standard")
scene.call("_apply_drift_motion", 0.5)
var standard_offset := absf(boat.position.y - base_boat_y)
state.set_motion_comfort_profile("gentle")
scene.call("_apply_drift_motion", 0.5)
var gentle_offset := absf(boat.position.y - base_boat_y)
state.set_motion_comfort_profile("still")
scene.call("_apply_drift_motion", 0.5)
_expect(is_equal_approx(gentle_offset, standard_offset * 0.5), "gentle halves visible boat bob")
_expect(is_equal_approx(boat.position.y, base_boat_y), "still removes automatic boat bob")
```

Also require that opening the rest menu exposes `ComfortButton`, pressing it changes label from `파도: 기본` to `파도: 잔잔`, and it is hidden with all other optional controls in Appreciation Mode.

- [ ] **Step 2: Run the scene contract and verify RED**

Run `--headless --path . --script res://tests/test_game_scene_contract.gd`.

Expected result: `ComfortButton` is absent and the amplitude assertions fail.

- [ ] **Step 3: Add one optional button and scale only automatic amplitudes**

Create `ComfortButton` beside existing optional controls. Connect it in `_ready()`. Multiply the existing camera y bob, boat y bob, boat roll, and water-contact breath/offset amplitudes by the normalized scale, without changing `_drift_phase`, speed multipliers, timers, or scene routing.

- [ ] **Step 4: Run the scene contract and verify GREEN**

Run the same focused test. Expected result: `PASS: calm voyage game scene contract`.

### Task 3: Persist actual postcard PNGs and metadata

**Status:** `COMPLETED`

**Files:**
- Create: `scripts/core/photo_memory_persistence.gd`
- Create: `tests/test_photo_memory_persistence.gd`
- Modify: `scripts/core/game_state.gd`
- Create: `tests/test_photo_memory_state_contract.gd`

**Interfaces:**
- Produces `PhotoMemoryPersistence.new(config_path := DEFAULT_CONFIG_PATH, image_directory := DEFAULT_IMAGE_DIRECTORY)`.
- Produces `save_photo(image: Image, label: String, atmosphere_id: String) -> Dictionary` and `load_entries() -> Array[Dictionary]`. Tests own cleanup of their exact isolated directories.
- Produces `GameState.photo_memories`, `GameState.record_photo_memory(image: Image, label: String, atmosphere_id: String) -> bool`, `GameState.set_photo_memory_storage(config_path: String, image_directory: String)`, `GameState.load_photo_memories()`.

- [ ] **Step 1: Write the failing real-image persistence test**

```gdscript
var image := Image.create_empty(4, 4, false, Image.FORMAT_RGBA8)
image.fill(Color(0.2, 0.6, 0.8, 1.0))
var result := persistence.save_photo(image, "밝은 바다의 물결", "bright")
_expect(bool(result.get("ok", false)), "real postcard image must write successfully")
_expect(FileAccess.file_exists(str(result.get("image_path", ""))), "postcard PNG must exist locally")
var restored := persistence.load_entries()
_expect(restored.size() == 1 and restored[0].get("label", "") == "밝은 바다의 물결", "valid postcard metadata must round-trip")
```

Write an invalid config with empty label and a metadata entry pointing to a missing PNG, then assert both are omitted.

- [ ] **Step 2: Run the persistence test and verify RED**

Run `--headless --path . --script res://tests/test_photo_memory_persistence.gd`.

Expected result: missing persistence script causes the expected initial assertion failure.

- [ ] **Step 3: Implement PNG and metadata owner with isolated local paths**

Generate an ID from system unix milliseconds plus an existing-file suffix, make the directory with `DirAccess.make_dir_recursive_absolute`, save the Image as PNG, then save the normalized metadata array in `[voyage_postcards] entries`. If config save fails, remove only the newly created PNG and return `{ "ok": false }`.

- [ ] **Step 4: Run persistence test and verify GREEN**

Run the same test. Expected result: `PASS: photo-memory persistence contract`.

- [ ] **Step 5: Write the failing GameState postcard isolation test**

```gdscript
var together_before := state.together_time_seconds
var ambient_before := state.ambient_memories.duplicate()
var image := Image.create_empty(4, 4, false, Image.FORMAT_RGBA8)
_expect(state.record_photo_memory(image, "밤의 물결", "night"), "GameState records a persisted postcard")
_expect(state.photo_memories.size() == 1 and state.photos == ["밤의 물결"], "postcard rebuilds legacy photo summary")
_expect(is_equal_approx(state.together_time_seconds, together_before), "postcard does not grant together time")
_expect(state.ambient_memories == ambient_before, "postcard does not change ambient memory")
```

- [ ] **Step 6: Run the new state contract and verify RED**

Run `--headless --path . --script res://tests/test_photo_memory_state_contract.gd`.

Expected result: GameState does not yet expose postcard ledger and writer.

- [ ] **Step 7: Add only the GameState ledger/bridge**

Load postcard entries in `_ready()`, rebuild `photos` from valid labels, and update both only after `PhotoMemoryPersistence.save_photo` succeeds. Keep `add_photo` as the existing nonpersistent legacy helper.

- [ ] **Step 8: Re-run both postcard tests and verify GREEN**

Run focused persistence and state scripts. Expected result: both PASS.

### Task 4: Capture UI-free voyage view and show quiet Album cards

**Status:** `COMPLETED`

**Files:**
- Modify: `scripts/voyage/game_scene.gd`
- Modify: `scenes/album.tscn`
- Modify: `scripts/ui/album_view.gd`
- Modify: `tests/test_game_scene_contract.gd`
- Modify: `tests/test_album_memory_contract.gd`

**Interfaces:**
- Consumes `GameState.record_photo_memory(image, label, atmosphere_id)`.
- Produces `GameScene._capture_voyage_postcard() -> void` and Album `PostcardRow` / `PostcardEmptyLabel` nodes.

- [ ] **Step 1: Write the failing capture restoration test**

```gdscript
take_photo_button.emit_signal("pressed")
await RenderingServer.frame_post_draw
await process_frame
_expect(rest_menu_button.visible, "photo capture restores compact rest menu visibility")
_expect(not bottom_panel.visible, "photo capture restores closed rest menu state")
_expect(game_state.photo_memories.size() == before_count + 1, "photo button saves a postcard after a rendered frame")
```

Use an isolated postcard storage path before scene instantiation. Assert that the stored image path exists and that photo capture does not enter Appreciation or Look Around mode.

- [ ] **Step 2: Run the scene contract and verify RED**

Run `--headless --path . --script res://tests/test_game_scene_contract.gd`.

Expected result: pressing the current photo button produces only legacy text and does not create a postcard file.

- [ ] **Step 3: Implement post-draw capture with guaranteed restoration**

Hide only capture-excluded UI nodes, await `RenderingServer.frame_post_draw`, read the root viewport texture into an `Image`, immediately restore each prior visibility value, and call the named GameState writer. Use actual `active_atmosphere_id` for the copy label. A write failure restores UI and writes no synthetic photo entry.

- [ ] **Step 4: Run scene contract and verify GREEN**

Run the same script. Expected result: all existing scene assertions and new photo assertions pass.

- [ ] **Step 5: Write the failing Album postcard presentation test**

```gdscript
var row := scene.get_node_or_null("Margin/Panel/VBox/PostcardRow") as HBoxContainer
_expect(row != null and row.get_child_count() == 3, "Album shows at most the newest three postcard cards")
var first_card := row.get_child(0).get_node_or_null("Image") as TextureRect
_expect(first_card != null and first_card.texture != null, "Album postcard card loads stored real image texture")
```

Use four real isolated postcard files and expect only the last three, in newest-first order. Assert no summary text contains `점수`, `희귀`, `연속`, or `보상`.

- [ ] **Step 6: Run Album contract and verify RED**

Run `--headless --path . --script res://tests/test_album_memory_contract.gd`.

Expected result: postcard nodes are absent.

- [ ] **Step 7: Add compact dynamic cards without a new navigation route**

Place a `PostcardHeadingLabel`, `PostcardRow`, and empty copy in the existing Album VBox. In `AlbumView`, clear the row, load only valid `photo_memories` from newest to oldest, create up to three compact `VBoxContainer` cards with TextureRect and Label, and keep all labels noninteractive.

- [ ] **Step 8: Run Album contract and verify GREEN**

Run the same script. Expected result: `PASS: album memory contract` with card texture assertions passing.

### Task 5: Runtime proof, canon reconciliation, and candidate-asset handoff

**Status:** `COMPLETED`

**Files:**
- Create: `tests/capture_voyage_postcards.gd`
- Create: `docs/evidence/2026-08-30-comfort-postcards/`
- Modify: `README.md`
- Modify: `docs/design/PROJECT_GDD.md`
- Modify: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`
- Modify: `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md`
- Create: `docs/superpowers/specs/2026-08-30-ambient-motif-and-response-brief.md`

**Interfaces:**
- Capture script creates a real postcard in each required camera/comfort test state and saves 540×960 evidence without claiming Human approval.
- Asset brief produces only `BRIEF_READY` requirements for six ambient motifs and three visible companion/boat reaction frames.

- [ ] **Step 1: Add a capture script that uses the public photo button path**

Set isolated postcard storage, capture a normal `standard` view, switch to `gentle`, capture again, switch to `still`, capture again, open Album, and save 540×960 images plus a readback manifest listing actual local postcard file paths.

- [ ] **Step 2: Run the focused test suite and runtime capture**

Run the five new/updated behavior contracts, the existing chibi/direct-entry/ambient/together/decor suites, headless project smoke, and a GPU capture command. Record exit codes and any warnings exactly.

- [ ] **Step 3: Inspect output and update only truthful canon state**

Document implemented/machine/runtime capture evidence, retain `Human motion comfort`, `touch reachability`, `five-minute calm`, and `audio comfort` as `NOT_RUN`, and do not mark proposed images as approved or implemented.

- [ ] **Step 4: Write the separate BRIEF_READY image handoff**

Specify six natural ambient motifs and three chibi response-frame sets with exact camera, alpha, visual-family, usage, and no-reward constraints. Do not generate or register any image in this task.

- [ ] **Step 5: Run final static and runtime checks**

Run `git diff --check`, the full targeted Godot suite, `--headless --path . --quit`, and `--headless --path . --scene res://scenes/game.tscn --quit-after 1`. Confirm output before any completion claim.
