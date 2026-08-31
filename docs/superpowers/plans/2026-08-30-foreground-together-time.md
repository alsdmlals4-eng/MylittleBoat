# Foreground Together Time Implementation Plan

> **For agentic workers:** Execute this plan inline, task by task. Each task begins with a failing Godot contract and ends with its focused verification. The current checkout contains approved but uncommitted related work, so do not create a parallel worktree, commit, reset, clean, or modify open PR #19.

**Goal:** Replace the remaining legacy companion-level placeholder with local, foreground-only together time that is shown only in `AlbumView`.

**Architecture:** `GameScene` remains the foreground lifecycle owner and forwards scene delta only while the application is foregrounded. `GameState` owns the global total, 15-second write coalescing, explicit lifecycle flushes, and cross-scene state. `TogetherTimePersistence` owns one local `ConfigFile` value, while `TogetherTimePresentation` owns duration and non-pressuring Korean copy for the Album consumer.

**Tech Stack:** Godot 4.7.2 stable, GDScript, `GameState` Autoload, `ConfigFile`, existing SceneTree contracts and 540×960 GPU capture scripts.

**Spec:** `docs/superpowers/specs/2026-08-30-foreground-together-time-design.md`

## Global Constraints

- Accumulate only `GameScene` foreground `delta` for an active voyage, exactly once and without a speed multiplier.
- Keep Normal Diorama, Appreciation Camera, post-record resting, cosmetic identity and all optional actions neutral to the total.
- Add no level, progress bar, milestone, reward, new scene, social feature, runtime image, sound, dependency, or backend.
- Use `user://together_time_v1.cfg` only for the together-time total. Do not infer or convert legacy `companion_affection` values.
- Retire legacy `companion_affection`, `동반자 호감도`, and `Lv` references from current runtime code and current contracts.
- Update the human-facing current owners and preserve Human/device calm, text readability, touch, motion, and audio review as `NOT_RUN`.

---

### Task 1: Add a narrow local persistence owner

**Files:**

- Create: `scripts/core/together_time_persistence.gd`
- Create: `tests/test_together_time_persistence.gd`

**Interfaces:**

- Produces `class_name TogetherTimePersistence`.
- Produces `save_seconds(value: float) -> Error` and `load_seconds() -> float`.
- Uses `user://together_time_v1.cfg`, section `together_time`, key `seconds` by default.

- [ ] **Step 1: Write the failing persistence contract.**

```gdscript
const PERSISTENCE_PATH := "res://scripts/core/together_time_persistence.gd"
const STORAGE_PATH := "user://test_together_time_persistence.cfg"

var persistence = (load(PERSISTENCE_PATH) as Script).new(STORAGE_PATH)
_expect(is_zero_approx(persistence.load_seconds()), "missing local together-time file must restore zero")
_expect(persistence.save_seconds(125.5) == OK, "persistence must save a positive total")
_expect(is_equal_approx(persistence.load_seconds(), 125.5), "saved together time must round-trip exactly")
_write_raw_config(STORAGE_PATH, "[together_time]\nseconds=-9.0\n")
_expect(is_zero_approx(persistence.load_seconds()), "negative saved together time must normalize to zero")
_write_raw_config(STORAGE_PATH, "[together_time]\nseconds=\"bad\"\n")
_expect(is_zero_approx(persistence.load_seconds()), "non-numeric saved together time must normalize to zero")
```

The break this test catches is a persistence owner that restores corrupt or negative data as playtime, or fails to restore a saved positive value.

- [ ] **Step 2: Run the new contract and confirm it fails because the persistence owner is absent.**

```powershell
& $godotExe --headless --path . --script res://tests/test_together_time_persistence.gd
```

- [ ] **Step 3: Implement the minimal `ConfigFile` owner.**

```gdscript
# 함께한 시간 하나만 로컬 ConfigFile에 저장하고 복원한다.
class_name TogetherTimePersistence
extends RefCounted

const DEFAULT_PATH := "user://together_time_v1.cfg"

var _path: String

func _init(path: String = DEFAULT_PATH) -> void:
	_path = path

func save_seconds(value: float) -> Error:
	var config := ConfigFile.new()
	config.set_value("together_time", "seconds", _normalize_seconds(value))
	return config.save(_path)

func load_seconds() -> float:
	var config := ConfigFile.new()
	if config.load(_path) != OK:
		return 0.0
	var raw_value := config.get_value("together_time", "seconds", 0.0)
	if typeof(raw_value) != TYPE_FLOAT and typeof(raw_value) != TYPE_INT:
		return 0.0
	return _normalize_seconds(float(raw_value))

func _normalize_seconds(value: float) -> float:
	if is_nan(value) or is_inf(value) or value < 0.0:
		return 0.0
	return value
```

- [ ] **Step 4: Re-run the focused contract.**

```powershell
& $godotExe --headless --path . --script res://tests/test_together_time_persistence.gd
```

Expected result is `PASS: together time persistence contract`.

### Task 2: Replace the legacy GameState placeholder with together-time state

**Files:**

- Modify: `scripts/core/game_state.gd`
- Create: `tests/test_together_time_state_contract.gd`
- Modify: `tests/test_calm_voyage_state.gd`
- Modify: `tests/test_boat_decoration_contract.gd`
- Modify: `tests/test_boat_life_ui_contract.gd`
- Modify: `tests/test_low_pressure_interaction_contract.gd`
- Modify: `tests/test_main_menu_identity_contract.gd`
- Modify: `tests/test_runtime_image_asset_contract.gd`
- Modify: `tests/test_decor_preview_contract.gd`

**Interfaces:**

- Produces `GameState.together_time_seconds: float`.
- Produces `advance_together_time(delta: float) -> void`, `flush_together_time() -> void`, `load_together_time() -> void`, and `set_together_time_storage_path(path: String) -> void`.
- Removes `GameState.companion_affection` without adding test-only state reset APIs.

- [ ] **Step 1: Write the failing GameState contract.**

```gdscript
const STORAGE_PATH := "user://test_together_time_state.cfg"

state.set_together_time_storage_path(STORAGE_PATH)
state.together_time_seconds = 0.0
state.reset_session()
state.advance_together_time(3.0)
_expect(is_zero_approx(state.together_time_seconds), "inactive voyage must not accumulate together time")

state.begin_voyage()
state.advance_together_time(2.5)
_expect(is_equal_approx(state.together_time_seconds, 2.5), "active voyage must accumulate the passed delta")
state.advance_together_time(-4.0)
_expect(is_equal_approx(state.together_time_seconds, 2.5), "negative delta must not decrease or add together time")

state.add_photo("테스트 사진")
state.add_scenery("테스트 풍경")
state.add_letter("테스트 편지")
state.add_fish("정어리")
_expect(is_equal_approx(state.together_time_seconds, 2.5), "optional memories must not add together time")

state.remaining_seconds = 0.0
state.complete_voyage()
state.advance_together_time(1.0)
_expect(is_equal_approx(state.together_time_seconds, 3.5), "post-record resting in the same voyage must keep accumulating")
state.flush_together_time()
state.together_time_seconds = 0.0
state.load_together_time()
_expect(is_equal_approx(state.together_time_seconds, 3.5), "flushed together time must restore locally")
```

The break this test catches is either optional-action farming, time accrued outside an active voyage, loss of post-record rest time, or failure to restore the real accumulated total.

- [ ] **Step 2: Run the state contract and confirm it fails on the missing together-time API.**

```powershell
& $godotExe --headless --path . --script res://tests/test_together_time_state_contract.gd
```

- [ ] **Step 3: Implement state, coalesced persistence, and explicit migration.**

```gdscript
const TOGETHER_TIME_SAVE_INTERVAL_SECONDS := 15.0
const TOGETHER_TIME_PERSISTENCE_SCRIPT = preload("res://scripts/core/together_time_persistence.gd")

var together_time_seconds := 0.0
var _unsaved_together_time_seconds := 0.0
var _together_time_persistence = TOGETHER_TIME_PERSISTENCE_SCRIPT.new()

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

func flush_together_time() -> void:
	_together_time_persistence.save_seconds(together_time_seconds)
	_unsaved_together_time_seconds = 0.0
```

Load together time in `_ready()`. `set_together_time_storage_path()` replaces the owner, clears only the pending-save accumulator, and calls `load_together_time()`. Remove the legacy variable rather than converting its synthetic `Lv` value. Update every listed existing contract to snapshot and assert `together_time_seconds` is unchanged by the unrelated action it exercises.

- [ ] **Step 4: Re-run the focused state and affected contracts.**

```powershell
& $godotExe --headless --path . --script res://tests/test_together_time_state_contract.gd
& $godotExe --headless --path . --script res://tests/test_calm_voyage_state.gd
& $godotExe --headless --path . --script res://tests/test_boat_decoration_contract.gd
& $godotExe --headless --path . --script res://tests/test_decor_preview_contract.gd
```

Expected result is all exit code `0` and no `companion_affection` reference in current runtime code or current contracts.

### Task 3: Apply foreground lifecycle and Album-only presentation

**Files:**

- Create: `scripts/companion/together_time_presentation.gd`
- Modify: `scripts/voyage/game_scene.gd`
- Modify: `scripts/ui/album_view.gd`
- Create: `tests/test_together_time_game_scene_contract.gd`
- Modify: `tests/test_album_composition_contract.gd`
- Modify: `tests/test_album_memory_contract.gd`
- Modify: `tests/capture_album_composition.gd`

**Interfaces:**

- Produces `TogetherTimePresentation.get_duration_copy(seconds: float) -> String` and `get_relation_copy(seconds: float) -> String`.
- `GameScene.set_application_foreground(is_foreground: bool)` flushes when false.
- `GameScene._process(delta)` is the only production caller that advances active together-time.

- [ ] **Step 1: Write failing presentation and lifecycle contracts.**

```gdscript
var presentation = (load("res://scripts/companion/together_time_presentation.gd") as Script).new()
_expect(presentation.get_duration_copy(0.0) == "함께한 시간: 잠시", "zero time must use calm non-progress copy")
_expect(presentation.get_duration_copy(125.0) == "함께한 시간: 2분", "minute copy must floor rather than show seconds")
_expect(presentation.get_duration_copy(3660.0) == "함께한 시간: 1시간 1분", "hour copy must include a remaining whole minute")
_expect("Lv" not in presentation.get_relation_copy(125.0), "relation copy must not expose a level")

state.begin_voyage()
state.together_time_seconds = 0.0
scene.set_application_foreground(false)
scene._process(4.0)
_expect(is_zero_approx(state.together_time_seconds), "backgrounded game scene must not accumulate together time")
scene.set_application_foreground(true)
state.speed_index = 2
scene._process(2.0)
_expect(is_equal_approx(state.together_time_seconds, 2.0), "speed must not multiply together time")
scene._toggle_appreciation_mode()
scene._process(1.0)
_expect(is_equal_approx(state.together_time_seconds, 3.0), "Appreciation Camera must share the same together time")
```

The breaks these tests catch are a timer visible outside Album, background accumulation, a speed multiplier, camera-mode inequality, or level-like presentation copy.

- [ ] **Step 2: Run the new scene contract and confirm it fails because the presentation owner and foreground advance are missing.**

```powershell
& $godotExe --headless --path . --script res://tests/test_together_time_game_scene_contract.gd
```

- [ ] **Step 3: Implement presentation and lifecycle ownership.**

```gdscript
# 함께한 시간을 앨범용으로만 조용하게 문장화한다.
class_name TogetherTimePresentation
extends RefCounted

func get_duration_copy(seconds: float) -> String:
	var whole_minutes := int(floor(maxf(seconds, 0.0) / 60.0))
	if whole_minutes <= 0:
		return "함께한 시간: 잠시"
	var hours := whole_minutes / 60
	var minutes := whole_minutes % 60
	if hours <= 0:
		return "함께한 시간: %d분" % whole_minutes
	if minutes <= 0:
		return "함께한 시간: %d시간" % hours
	return "함께한 시간: %d시간 %d분" % [hours, minutes]

func get_relation_copy(seconds: float) -> String:
	if seconds < 60.0:
		return "동반자와 같은 바다에 머물고 있어요."
	return "동반자와 같은 바다를 천천히 바라봤어요."
```

In `GameScene._process(delta)`, call `GameState.advance_together_time(delta)` before the visual-only voyage timer only when `_application_in_foreground` is true. Keep the existing boat drift speed multiplier exclusively in `_apply_drift_motion`. On `set_application_foreground(false)`, `_open_album()`, and `_exit_tree()`, call `GameState.flush_together_time()` without altering whether the voyage is active.

In `AlbumView`, use a local `TogetherTimePresentation` instance. Replace the old level line with the unchanged voyage-record count, duration copy, and relation copy in the existing SummaryLabel. Do not add a node, button, or runtime image. Update the Album contracts and capture setup to seed `together_time_seconds`, and assert visible duration/relation text plus absence of `Lv` and `호감도`.

- [ ] **Step 4: Re-run focused scene and Album contracts.**

```powershell
& $godotExe --headless --path . --script res://tests/test_together_time_game_scene_contract.gd
& $godotExe --headless --path . --script res://tests/test_album_composition_contract.gd
& $godotExe --headless --path . --script res://tests/test_album_memory_contract.gd
```

Expected result is all exit code `0`; the game scene has no together-time UI and the Album has one static summary consumer.

### Task 4: Capture, reconcile current owners, and verify the complete candidate

**Files:**

- Modify: `README.md`
- Modify: `docs/design/PROJECT_GDD.md`
- Modify: `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`
- Modify: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`
- Modify: `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md` only if its current surface inventory states the legacy level.
- Modify: `tests/capture_album_composition.gd`
- Create: `docs/evidence/2026-08-30-direct-entry-real-time/album_together_time_540x960.png`

**Interfaces:**

- The current human-facing owners label together-time `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` only after the complete automated batch and GPU capture pass.
- They retain Human/device text readability, touch, five-minute calm, motion, and audio review as `NOT_RUN`.

- [ ] **Step 1: Update the Album GPU capture to prove the consumer.**

Set the capture fixture to `GameState.together_time_seconds = 3660.0`, open `album.tscn`, wait one process frame, assert `SummaryLabel` contains `함께한 시간: 1시간 1분`, assert it does not contain `Lv` or `호감도`, then save `album_together_time_540x960.png` at 540×960.

- [ ] **Step 2: Run the focused GPU capture and visually inspect the saved output.**

```powershell
& $godotExe --path . --display-driver windows --rendering-driver opengl3 --script res://tests/capture_album_composition.gd
```

Expected result is a saved 540×960 Album image whose static summary is not clipped or overlapping and does not frame time as a goal.

- [ ] **Step 3: Update repository owners to the measured result.**

Replace legacy-level claims with the actual source, path, 15-second save coalescing, no-conversion migration, Album-only copy, test names, and capture filename. Do not claim a human pass. Record the existing headless `ObjectDB` shutdown warning as un-attributed if it still appears.

- [ ] **Step 4: Run the complete project verification.**

```powershell
$tests = Get-ChildItem tests -Filter 'test_*.gd' -File | Sort-Object Name
foreach ($test in $tests) {
    & $godotExe --headless --path . --script ("res://tests/" + $test.Name)
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
& $godotExe --headless --path . --quit
& $godotExe --headless --path . --scene res://scenes/game.tscn --quit-after 1
& $godotExe --headless --path . --scene res://scenes/album.tscn --quit-after 1
git diff --check
```

- [ ] **Step 5: Run the adversarial review before reporting.**

Verify each item against the spec and runtime evidence.

1. No source or UI can create together-time from action, speed, camera selection, identity, decor, or background time.
2. No game-voyage screen contains `Lv`, `호감도`, progress, reward, threshold, or milestone UI.
3. `GameState` owns a global total only and cannot produce pet-specific progression.
4. Missing, malformed, negative, and legacy state cannot produce a positive total.
5. Capture/runtime proof remains distinct from Human/device calm and readability evidence.

No commit or PR mutation occurs in this task because the current checkout is intentionally dirty and PR #19 is another workstream.

