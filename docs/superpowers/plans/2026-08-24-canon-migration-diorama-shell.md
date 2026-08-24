# Canon Migration + Diorama Shell Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate the repository from first-person-only/invisible-player canon to the approved Bondee-inspired visible-avatar 3/4 boat diorama shell while preserving the existing sea-focused Appreciation Camera and all current voyage/rest/fishing behavior.

**Architecture:** Keep the existing voyage scene and Resting Core systems. Add a fixed 3/4 `DioramaCameraRig` as the normal camera, convert the existing draggable rig into `AppreciationCameraRig`, and add one clearly technical visible avatar placeholder. `GameScene` switches cameras from `GameState.appreciation_mode`. The Appreciation Camera controller processes drag input only while its camera is current so it cannot steal normal diorama touch input.

**Tech Stack:** Godot 4.7 stable, GDScript, `.tscn`, SceneTree contract tests, GitHub Actions Godot validation.

**Spec:** `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md`

## Global Constraints

- Godot 4.7 stable / GDScript.
- Mobile portrait remains primary.
- Normal play shows avatar + pet + boat + sea in a 3/4 diorama.
- Appreciation Camera preserves the existing sea-focused draggable view and low-UI rest behavior.
- Camera switching does not stop voyage time, soundscape, or alter rewards.
- Existing fishing, Ambient Discovery, album, voyage-record, RestingSoundscape, and pet-resting contracts remain green.
- Avatar in this slice is `TECHNICAL_PLACEHOLDER`, not production art.
- No decoration editor, Interactable runtime, fake social backend, Supabase, FriendBottle, or DriftBottle runtime in this slice.
- Future online social is limited to the approved delayed bottle subsystem and its identity/safety operations; no realtime/global/public chat.
- `DriftBottle` future public enablement remains gated by moderation, Terms, age gate, report, block, and operations evidence.
- No combat, HP, failure conditions, ranking, ads, payments, gacha pressure, or progression pressure.

---

## File Map

**Create**
- `scripts/avatar/player_avatar_placeholder.gd` — technical visible-avatar/customization-slot contract.
- `tests/test_diorama_avatar_camera_contract.gd` — avatar + normal/appreciation camera-mode behavior.

**Modify**
- `AGENTS.md`
- `scenes/game.tscn`
- `scripts/voyage/game_scene.gd`
- `scripts/voyage/boat_camera_controller.gd`
- `tests/test_game_scene_contract.gd`
- `tests/test_camera_input_contract.gd`
- `.github/workflows/godot-validation.yml`
- `README.md`
- `docs/CONCEPT.md`
- `docs/MVP_SCOPE.md`
- `docs/GODOT_MVP_ROADMAP.md`

---

### Task 1: Migrate repository operating canon

**Files:**
- Modify: `AGENTS.md`

**Produces:** repository authority that explicitly permits visible-avatar 3/4 diorama normal play and only the approved delayed-bottle online boundary.

- [ ] **Step 1: Replace obsolete identity lines**

Replace the old first-person-only, invisible-player, and blanket online-letter prohibition with:

```text
Genre: rest-first cozy boat diorama / healing voyage game
Normal play uses a visible player avatar + pet + boat in a 3/4 diorama camera.
Appreciation Camera preserves the sea-focused low-UI view.
Online scope is allowed only for the approved delayed FriendBottle / DriftBottle subsystem and required identity/safety operations; core rest/voyage/decor/pet systems remain local-first.
```

- [ ] **Step 2: Update Core Game Direction**

Preserve the 5-minute rest loop, photo, appreciation, speed, fishing, album, pet, and soundscape. Add visible avatar, future boat decoration, low-pressure interaction, and delayed bottle social as approved supporting directions.

- [ ] **Step 3: Add social safety boundary**

State that bottle social cannot become realtime/global/public chat and that future `DriftBottle` release requires moderation/report/block/Terms/age-gate evidence.

- [ ] **Step 4: Static readback**

Verify no unconditional `player body is not visible`, `first-person only`, or blanket `online letter sharing` prohibition remains.

- [ ] **Step 5: Commit**

```bash
git add AGENTS.md
git commit -m "Migrate project canon to boat diorama direction"
```

---

### Task 2: RED — visible avatar and camera-mode contract

**Files:**
- Create: `tests/test_diorama_avatar_camera_contract.gd`
- Modify: `.github/workflows/godot-validation.yml`

**Produces:** contract for `PlayerAvatarPlaceholder`, `DioramaCameraRig/DioramaCamera3D`, `AppreciationCameraRig/AppreciationCamera3D`, and `GameScene.get_active_camera_mode()`.

- [ ] **Step 1: Write failing SceneTree test**

Before scene instantiation, normalize state:

```gdscript
var game_state := root.get_node_or_null("GameState")
_expect(game_state != null, "GameState autoload must exist")
game_state.reset_session()
game_state.voyage_active = true
game_state.remaining_seconds = 123.0
game_state.appreciation_mode = false
```

After instantiation assert:

```gdscript
var avatar := scene.get_node_or_null("VoyageWorld/PlayerAvatarPlaceholder") as Node3D
_expect(avatar != null, "normal play must include a visible player avatar placeholder")
_expect(avatar.has_method("is_technical_placeholder"), "avatar must expose its evidence class")
_expect(bool(avatar.call("is_technical_placeholder")), "avatar must remain technical-placeholder evidence")

var diorama_camera := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D") as Camera3D
var appreciation_camera := scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D") as Camera3D
_expect(diorama_camera != null, "normal play must provide DioramaCamera3D")
_expect(appreciation_camera != null, "appreciation mode must preserve a sea-focused camera")
_expect(diorama_camera.current, "diorama camera must be current in normal play")
_expect(not appreciation_camera.current, "appreciation camera must be inactive in normal play")
_expect(scene.has_method("get_active_camera_mode"), "game scene must expose camera mode")
_expect(str(scene.call("get_active_camera_mode")) == "diorama", "normal camera mode must be diorama")
```

Snapshot `remaining_seconds`, `speed_index`, and photo/scenery/letter/fish counts. Press `%AppreciationButton`, await one frame, then assert:

```gdscript
_expect(not diorama_camera.current, "diorama camera must yield in appreciation mode")
_expect(appreciation_camera.current, "appreciation camera must become current")
_expect(str(scene.call("get_active_camera_mode")) == "appreciation", "camera mode must report appreciation")
```

Assert the toggle itself changed none of the snapshotted progression values.

- [ ] **Step 2: Add test to CI**

Add:

```bash
godot --headless --path . --script res://tests/test_diorama_avatar_camera_contract.gd || status=1
```

- [ ] **Step 3: Open implementation PR and observe RED**

Expected failures: missing avatar, missing camera split, missing camera-mode API. Existing contracts should remain PASS.

- [ ] **Step 4: Inspect RED logs**

If failure is syntax/path setup rather than missing behavior, fix the test and rerun until RED is semantically correct.

- [ ] **Step 5: Commit**

```bash
git add tests/test_diorama_avatar_camera_contract.gd .github/workflows/godot-validation.yml
git commit -m "Test visible avatar and diorama camera contract"
```

---

### Task 3: GREEN — technical avatar shell and 3/4 diorama camera

**Files:**
- Create: `scripts/avatar/player_avatar_placeholder.gd`
- Modify: `scenes/game.tscn`
- Modify: `scripts/voyage/game_scene.gd`

**Produces:**
- `PlayerAvatarPlaceholder.is_technical_placeholder() -> bool`
- `PlayerAvatarPlaceholder.get_customization_slots() -> Array[String]`
- `GameScene.get_active_camera_mode() -> String`
- `GameScene._apply_camera_mode() -> void`

- [ ] **Step 1: Implement avatar placeholder contract**

```gdscript
# 보이는 플레이어 캐릭터의 기술용 외형·커스터마이즈 슬롯 계약을 제공한다.
extends Node3D

const TECHNICAL_PLACEHOLDER := true
const CUSTOMIZATION_SLOTS: Array[String] = [
    "body",
    "hair",
    "top",
    "bottom",
    "head_accessory",
    "accessory",
    "color",
]

func is_technical_placeholder() -> bool:
    return TECHNICAL_PLACEHOLDER

func get_customization_slots() -> Array[String]:
    return CUSTOMIZATION_SLOTS.duplicate()
```

- [ ] **Step 2: Add visible rounded avatar mesh**

Create `VoyageWorld/PlayerAvatarPlaceholder` with rounded primitive body/head meshes and matte material. Position it so avatar and `RestingPetPlaceholder` are both visible in portrait diorama composition. Do not imply final art quality.

- [ ] **Step 3: Split camera rigs**

Scene structure:

```text
VoyageWorld/DioramaCameraRig/DioramaCamera3D             current=true
VoyageWorld/AppreciationCameraRig/AppreciationCamera3D   current=false
```

Move the existing `boat_camera_controller.gd` onto `AppreciationCameraRig`. Set `DioramaCameraRig` to a fixed elevated 3/4 transform showing avatar + pet + boat + horizon.

- [ ] **Step 4: Implement camera selection**

```gdscript
func get_active_camera_mode() -> String:
    return "appreciation" if GameState.appreciation_mode else "diorama"

func _apply_camera_mode() -> void:
    $VoyageWorld/DioramaCameraRig/DioramaCamera3D.current = not GameState.appreciation_mode
    $VoyageWorld/AppreciationCameraRig/AppreciationCamera3D.current = GameState.appreciation_mode
```

Call `_apply_camera_mode()` from `_apply_appreciation_mode()`.

- [ ] **Step 5: Preserve speed/drift feedback**

Store base positions for both camera rigs and apply small vertical drift to both. Existing speed choices still change felt drift but never duration/reward.

- [ ] **Step 6: Run exact-head CI**

Expected: new avatar/camera contract GREEN. Fix only production behavior needed by the contract.

- [ ] **Step 7: Commit**

```bash
git add scenes/game.tscn scripts/avatar/player_avatar_placeholder.gd scripts/voyage/game_scene.gd
git commit -m "Add visible avatar and diorama camera shell"
```

---

### Task 4: RED/GREEN — Appreciation Camera must not steal normal diorama input

**Files:**
- Modify: `scripts/voyage/boat_camera_controller.gd`
- Modify: `tests/test_camera_input_contract.gd`
- Modify: `tests/test_game_scene_contract.gd`

**Produces:** `boat_camera_controller.gd` handles mouse/touch drag only when its child `AppreciationCamera3D.current == true`.

- [ ] **Step 1: Extend camera input test with an inactive-camera RED case**

Construct the rig with a child camera named `AppreciationCamera3D`, set `current = false`, send `InputEventScreenDrag`, and assert rotation is unchanged:

```gdscript
camera.current = false
var inactive_before := rig.rotation_degrees
var inactive_drag := InputEventScreenDrag.new()
inactive_drag.relative = Vector2(28.0, -14.0)
rig.call("_unhandled_input", inactive_drag)
_expect(rig.rotation_degrees == inactive_before, "inactive Appreciation Camera must not consume diorama drag behavior")
```

Then set `camera.current = true`, send the same drag, and preserve existing assertions for changed rotation, roll `0`, and pitch clamp `[-28, 18]`.

- [ ] **Step 2: Run CI and verify RED**

Expected RED: inactive Appreciation Camera still rotates because the old controller has no active-camera gate.

- [ ] **Step 3: Implement minimal active-camera gate**

In `boat_camera_controller.gd` add:

```gdscript
@onready var _controlled_camera := get_node_or_null("AppreciationCamera3D") as Camera3D

func _is_input_active() -> bool:
    return _controlled_camera != null and _controlled_camera.current
```

Start `_unhandled_input(event)` with:

```gdscript
if not _is_input_active():
    _dragging = false
    return
```

Keep existing sensitivity, pitch clamp, yaw, and zero-roll behavior unchanged.

- [ ] **Step 4: Update role/header language**

Describe the script as the sea-focused Appreciation Camera PC/touch drag controller, not the normal first-person camera.

- [ ] **Step 5: Update game-scene contract path**

Replace its normal-play drift lookup from old `VoyageWorld/CameraRig` to `VoyageWorld/DioramaCameraRig`. Retain all prior behavior assertions.

- [ ] **Step 6: Run full CI**

Expected: all existing contracts + new diorama/avatar contract PASS; all three scene smokes PASS.

- [ ] **Step 7: Commit**

```bash
git add scripts/voyage/boat_camera_controller.gd tests/test_camera_input_contract.gd tests/test_game_scene_contract.gd
git commit -m "Gate appreciation camera drag input"
```

---

### Task 5: Synchronize repository mirrors with implemented Slice 1

**Files:**
- Modify: `README.md`
- Modify: `docs/CONCEPT.md`
- Modify: `docs/MVP_SCOPE.md`
- Modify: `docs/GODOT_MVP_ROADMAP.md`

**Produces:** repository mirrors that distinguish implemented technical shell from future decor/social systems.

- [ ] **Step 1: README evidence table/text**

State exactly:

```text
TECH_DIORAMA_SHELL = implemented
VISIBLE_AVATAR_PLACEHOLDER = implemented
APPRECIATION_CAMERA = preserved
BOAT_DECORATION = NOT_IMPLEMENTED
INTERACTABLE_RUNTIME = NOT_IMPLEMENTED
FRIEND_BOTTLE = NOT_IMPLEMENTED
DRIFT_BOTTLE = NOT_IMPLEMENTED
```

- [ ] **Step 2: Concept and MVP Scope**

Replace first-person-only language with visible-avatar 3/4 normal play + optional Appreciation Camera. Keep bottle social as approved future runtime scope.

- [ ] **Step 3: Roadmap**

Add:

```text
Canon Migration + Diorama Shell — implemented / Human visual QA NOT_RUN
Next — Local Decoration + Interactable
```

- [ ] **Step 4: Static stale-language scan**

Read touched mirrors and remove only unconditional now-invalid phrases such as `player body is not visible`, `first-person only`, or blanket `online letter sharing forbidden`.

- [ ] **Step 5: Commit**

```bash
git add README.md docs/CONCEPT.md docs/MVP_SCOPE.md docs/GODOT_MVP_ROADMAP.md
git commit -m "Sync diorama shell implementation mirrors"
```

---

### Task 6: Exact verification, adversarial review, merge, and Notion sync

**Files:**
- Runtime/docs only if a concrete review defect is found.
- Update Notion after merge.

- [ ] **Step 1: Exact-head verification**

Confirm PR head SHA and latest Godot 4.7 workflow on that exact head is `SUCCESS`.

- [ ] **Step 2: Whole-state adversarial review, five clean loops**

Attack at minimum:

1. stale first-person/no-online canon still governing future work;
2. Appreciation Camera input handling stealing normal diorama touch input or changing timer/rewards;
3. avatar placeholder being mistaken for final art or obscuring pet/sea;
4. 3/4 camera/drift creating excessive motion or breaking portrait composition at the technical-contract level;
5. README/Notion claiming decor/social backend runtime exists when only Slice 1 exists.

A newly discovered valid defect is corrected and the clean-loop count restarts according to project workflow.

- [ ] **Step 3: PR review surfaces**

Inspect changed filenames, full patch, comments, reviews, unresolved threads, and base-main movement.

- [ ] **Step 4: Merge with expected head SHA**

Squash only after exact-head verification and review are clean.

- [ ] **Step 5: Postmerge readback**

Verify `main` SHA and merged files and ensure the current implementation issue closes if linked.

- [ ] **Step 6: Notion evidence sync**

Update:

- Project Registry main SHA/revision/notes;
- Home current state;
- `3/4 디오라마 플레이어·카메라` → `SYNCED` with merged SHA;
- voyage core loop source/evidence where applicable;
- Production Handoff receipt.

Keep `보트 꾸미기 슬롯 존`, `저압력 상호작용 시스템`, `FriendBottle`, `DriftBottle`, and `병편지 소셜 안전·모더레이션` as future runtime work (`REPO_UPDATE_REQUIRED`) until their own slices are implemented.

- [ ] **Step 7: Final evidence ceiling**

Report:

```text
Godot contract/scene behavior = PASS if exact-head CI proves it
Visible avatar technical shell = PASS
3/4 camera technical shell = PASS
Appreciation Camera preservation = PASS
Appreciation input isolation = PASS
Human visual comfort = NOT_RUN
Final avatar art = NOT_INTEGRATED
Boat decoration runtime = NOT_IMPLEMENTED
Bottle social runtime/backend = NOT_IMPLEMENTED
Real mobile device QA = NOT_RUN
```
