# Canon Migration + Diorama Shell Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Migrate the repository from first-person-only/invisible-player canon to the approved Bondee-inspired visible-avatar 3/4 boat diorama shell while preserving the existing sea-focused Appreciation Camera and all current voyage/rest/fishing behavior.

**Architecture:** Keep the current game scene and Resting Core systems, but make a fixed 3/4 `DioramaCameraRig` the normal active camera and convert the existing draggable first-person rig into the optional `AppreciationCameraRig`. Add one clearly technical visible avatar placeholder with a small customization-slot contract. `GameScene` owns camera-mode switching from the existing `GameState.appreciation_mode`; no decoration system or online backend is introduced in this slice.

**Tech Stack:** Godot 4.7 stable, GDScript, `.tscn`, existing SceneTree contract tests, GitHub Actions Godot validation.

**Spec:** `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md`

## Global Constraints

- Godot 4.7 stable / GDScript.
- Mobile portrait remains the primary screen constraint.
- Normal play shows the player avatar and pet in a 3/4 boat diorama.
- Appreciation Camera preserves the current sea-focused draggable view and low-UI rest behavior.
- Appreciation Camera must not stop the voyage timer, soundscape, or alter rewards.
- Existing fishing, Ambient Discovery, album, voyage-record, RestingSoundscape, and pet-resting contracts must remain green.
- Avatar art in this slice is a clearly labeled technical placeholder, not production art.
- No decoration editor, social fake backend, Supabase integration, FriendBottle, or DriftBottle runtime code in this slice.
- Online social design is approved, but `DriftBottle` remains future-gated by moderation/safety implementation.
- Do not add combat, HP, failure conditions, ranking, ads, payments, or progression pressure.

---

## File Structure for This Slice

**Create**
- `scripts/avatar/player_avatar_placeholder.gd` — technical visible-avatar identity/customization-slot contract only.
- `tests/test_diorama_avatar_camera_contract.gd` — RED/GREEN contract for visible avatar, normal 3/4 camera, Appreciation Camera switching, and no reward/timer mutation.

**Modify**
- `AGENTS.md` — replace obsolete first-person/invisible-player/online-letter prohibition with the approved current operating canon and narrow online boundary.
- `scenes/game.tscn` — add `DioramaCameraRig`, visible avatar placeholder mesh, and rename/reframe the old camera as `AppreciationCameraRig`.
- `scripts/voyage/game_scene.gd` — own camera selection and drift bases for both rigs while preserving current gameplay.
- `scripts/voyage/boat_camera_controller.gd` — update role/header language from first-person core camera to Appreciation Camera input controller; behavior stays the same.
- `tests/test_game_scene_contract.gd` — update the drift-camera path after the explicit camera split and retain all previous assertions.
- `tests/test_camera_input_contract.gd` — reframe assertions as Appreciation Camera input semantics without weakening clamp/horizon behavior.
- `.github/workflows/godot-validation.yml` — run the new diorama/avatar contract.
- `README.md` — describe implemented technical diorama shell and evidence ceiling.
- `docs/CONCEPT.md` — mirror approved visible-avatar/boat-diorama product direction.
- `docs/MVP_SCOPE.md` — distinguish implemented Slice 1 from future decoration/social work.
- `docs/GODOT_MVP_ROADMAP.md` — mark Canon Migration + Diorama Shell state and next Slice 2.

---

### Task 1: Migrate the repository operating canon

**Files:**
- Modify: `AGENTS.md`

**Interfaces:**
- Consumes: approved design spec section 0–3 and section 20.
- Produces: authoritative repository instructions that permit visible avatar + 3/4 diorama and permit only the narrowly designed delayed bottle social subsystem in later slices.

- [ ] **Step 1: Replace obsolete project identity text**

Change:

```text
Genre: first-person healing drifting boat game
The player sits in a small boat and watches the sea. The player body is not visible.
Do not add ... online letter sharing.
```

To an explicit current canon equivalent:

```text
Genre: rest-first cozy boat diorama / healing voyage game
Normal play uses a visible player avatar + pet + decorated boat in a 3/4 diorama camera.
Appreciation Camera preserves the sea-focused low-UI view.
Online scope is allowed only for the approved delayed FriendBottle / DriftBottle subsystem and its required identity/safety operations; the rest of the game remains local-first.
```

- [ ] **Step 2: Update Core Game Direction**

Add the new normal-play presentation and future supporting systems while preserving the 5-minute rest loop, photo, appreciation, speed, fishing, album, pet, and soundscape.

- [ ] **Step 3: Add online safety boundary**

State that future bottle-social runtime must follow the approved spec and cannot become realtime/global/public chat. `DriftBottle` public enablement requires moderation/report/block/Terms/age-gate evidence.

- [ ] **Step 4: Read back `AGENTS.md`**

Verify there is no remaining unconditional statement that the player body must be invisible or that all online letter sharing is forbidden.

- [ ] **Step 5: Commit**

```bash
git add AGENTS.md
git commit -m "Migrate project canon to boat diorama direction"
```

---

### Task 2: RED — define the visible-avatar and camera-mode contract

**Files:**
- Create: `tests/test_diorama_avatar_camera_contract.gd`
- Modify: `.github/workflows/godot-validation.yml`

**Interfaces:**
- Consumes: existing `GameState.appreciation_mode`, `scenes/game.tscn`.
- Produces: behavioral contract for `PlayerAvatarPlaceholder`, `DioramaCameraRig/DioramaCamera3D`, `AppreciationCameraRig/AppreciationCamera3D`, and `GameScene.get_active_camera_mode()`.

- [ ] **Step 1: Write failing contract**

Create a SceneTree test with these assertions:

```gdscript
var avatar := scene.get_node_or_null("VoyageWorld/PlayerAvatarPlaceholder") as Node3D
_expect(avatar != null, "normal play must include a visible player avatar placeholder")
_expect(avatar.has_method("is_technical_placeholder"), "avatar must expose its evidence class")
_expect(bool(avatar.call("is_technical_placeholder")), "current avatar must stay explicitly technical-placeholder evidence")

var diorama_camera := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D") as Camera3D
var appreciation_camera := scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D") as Camera3D
_expect(diorama_camera != null, "normal play must provide a DioramaCamera3D")
_expect(appreciation_camera != null, "appreciation mode must preserve the sea-focused camera")
_expect(diorama_camera.current, "diorama camera must be active in normal play")
_expect(not appreciation_camera.current, "appreciation camera must be inactive in normal play")
_expect(scene.has_method("get_active_camera_mode"), "game scene must expose active camera mode for contract tests")
_expect(str(scene.call("get_active_camera_mode")) == "diorama", "normal play camera mode must be diorama")
```

Then press `%AppreciationButton`, await one frame, and assert:

```gdscript
_expect(not diorama_camera.current, "diorama camera must yield during appreciation mode")
_expect(appreciation_camera.current, "appreciation camera must become active")
_expect(str(scene.call("get_active_camera_mode")) == "appreciation", "camera mode must report appreciation")
```

Also snapshot `GameState.remaining_seconds`, `speed_index`, photo/letter/scenery/fish counts before toggling and assert the toggle itself changes none of them.

- [ ] **Step 2: Add the new test to CI**

Add:

```bash
godot --headless --path . --script res://tests/test_diorama_avatar_camera_contract.gd || status=1
```

to the focused behavior contracts.

- [ ] **Step 3: Open/update the implementation PR and run CI**

Expected RED failures must be specifically about missing avatar/diorama/appreciation camera split or missing camera-mode method. Existing contracts should remain PASS.

- [ ] **Step 4: Inspect RED logs**

Do not implement until the failing test demonstrates the missing feature rather than a syntax/path mistake.

- [ ] **Step 5: Commit**

```bash
git add tests/test_diorama_avatar_camera_contract.gd .github/workflows/godot-validation.yml
git commit -m "Test visible avatar and diorama camera contract"
```

---

### Task 3: GREEN — add the technical avatar shell and normal 3/4 diorama camera

**Files:**
- Create: `scripts/avatar/player_avatar_placeholder.gd`
- Modify: `scenes/game.tscn`
- Modify: `scripts/voyage/game_scene.gd`

**Interfaces:**
- Produces:
  - `PlayerAvatarPlaceholder.is_technical_placeholder() -> bool`
  - `PlayerAvatarPlaceholder.get_customization_slots() -> Array[String]`
  - `GameScene.get_active_camera_mode() -> String`
  - `GameScene._apply_camera_mode() -> void`

- [ ] **Step 1: Implement minimal avatar placeholder script**

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

No movement, inventory, stats, network identity, or final avatar art in this slice.

- [ ] **Step 2: Add placeholder mesh to `game.tscn`**

Create `VoyageWorld/PlayerAvatarPlaceholder` with rounded primitive body/head meshes and a matte material. Keep it clearly separate from `RestingPetPlaceholder` and positioned so both are readable in portrait diorama framing.

- [ ] **Step 3: Split cameras in `game.tscn`**

Create:

```text
VoyageWorld/DioramaCameraRig/DioramaCamera3D   current=true
VoyageWorld/AppreciationCameraRig/AppreciationCamera3D current=false
```

Move the existing draggable camera controller to `AppreciationCameraRig`. Give the new Diorama camera a fixed 3/4 elevated transform that sees avatar + pet + boat + horizon.

- [ ] **Step 4: Add camera-mode switching in `game_scene.gd`**

Implement:

```gdscript
func get_active_camera_mode() -> String:
    return "appreciation" if GameState.appreciation_mode else "diorama"

func _apply_camera_mode() -> void:
    $VoyageWorld/DioramaCameraRig/DioramaCamera3D.current = not GameState.appreciation_mode
    $VoyageWorld/AppreciationCameraRig/AppreciationCamera3D.current = GameState.appreciation_mode
```

Call `_apply_camera_mode()` inside `_apply_appreciation_mode()` so UI and camera always transition from the same state.

- [ ] **Step 5: Preserve speed/drift feedback in both modes**

Store base positions for both camera rigs and apply only small vertical drift to each so speed control remains observable in the currently active camera. Do not change voyage duration or rewards.

- [ ] **Step 6: Run exact-head CI**

Expected: new diorama/avatar contract GREEN; existing contracts may reveal path assumptions that now need Task 4 migration.

- [ ] **Step 7: Commit**

```bash
git add scenes/game.tscn scripts/avatar/player_avatar_placeholder.gd scripts/voyage/game_scene.gd
git commit -m "Add visible avatar and diorama camera shell"
```

---

### Task 4: REFACTOR — migrate old camera-path contracts without weakening them

**Files:**
- Modify: `scripts/voyage/boat_camera_controller.gd`
- Modify: `tests/test_game_scene_contract.gd`
- Modify: `tests/test_camera_input_contract.gd`

**Interfaces:**
- Preserves existing input behavior: mouse drag + `InputEventScreenDrag`, pitch clamp `[-28, 18]`, roll `0`.
- Reframes that behavior as Appreciation Camera input rather than normal first-person presentation.

- [ ] **Step 1: Update controller role comment only**

Change the source header to describe sea-focused Appreciation Camera drag input. Do not change sensitivity/clamp behavior unless a failing test requires it.

- [ ] **Step 2: Update game-scene drift assertion path**

Replace old `VoyageWorld/CameraRig` lookup with `VoyageWorld/DioramaCameraRig`, because normal-play speed feedback must be observable on the active diorama camera.

- [ ] **Step 3: Reword camera input contract**

Keep the same input simulation and numeric assertions, but describe it as Appreciation Camera behavior.

- [ ] **Step 4: Run full CI**

Expected: all behavior contracts + three scene smokes PASS.

- [ ] **Step 5: Commit**

```bash
git add scripts/voyage/boat_camera_controller.gd tests/test_game_scene_contract.gd tests/test_camera_input_contract.gd
git commit -m "Preserve appreciation camera input contracts"
```

---

### Task 5: Synchronize repository human-readable mirrors with implemented Slice 1

**Files:**
- Modify: `README.md`
- Modify: `docs/CONCEPT.md`
- Modify: `docs/MVP_SCOPE.md`
- Modify: `docs/GODOT_MVP_ROADMAP.md`

**Interfaces:**
- Consumes: implemented runtime truth from Tasks 1–4.
- Produces: repository mirrors that do not falsely claim decor/social runtime exists yet.

- [ ] **Step 1: README**

State:

```text
TECH_DIORAMA_SHELL = implemented
VISIBLE_AVATAR_PLACEHOLDER = implemented
APPRECIATION_CAMERA = preserved
BOAT_DECORATION = NOT_IMPLEMENTED
FRIEND_BOTTLE = NOT_IMPLEMENTED
DRIFT_BOTTLE = NOT_IMPLEMENTED
```

Do not call placeholder visual quality PASS.

- [ ] **Step 2: Concept/MVP Scope**

Replace first-person-only language with 3/4 visible-avatar normal play + optional Appreciation Camera. Keep online bottle systems as approved future scope, not runtime evidence.

- [ ] **Step 3: Roadmap**

Add/mark:

```text
Canon Migration + Diorama Shell — implemented / Human visual QA NOT_RUN
Next: Local Decoration + Interactable
```

- [ ] **Step 4: Static readback**

Search the touched mirrors for stale unconditional phrases such as `player body is not visible`, `first-person only`, or `online letter sharing forbidden` and remove only those now-invalid statements.

- [ ] **Step 5: Commit**

```bash
git add README.md docs/CONCEPT.md docs/MVP_SCOPE.md docs/GODOT_MVP_ROADMAP.md
git commit -m "Sync diorama shell implementation mirrors"
```

---

### Task 6: Final verification, adversarial review, merge, and Notion evidence sync

**Files:**
- No new runtime files unless review reveals a concrete defect.
- Update Notion after merge.

**Interfaces:**
- Consumes: exact PR head and CI evidence.
- Produces: merged main SHA + Notion `SYNCED` evidence for implemented Slice 1 while future systems remain `REPO_UPDATE_REQUIRED`.

- [ ] **Step 1: Exact-head verification**

Verify the PR head SHA and ensure the latest Godot 4.7 workflow run on that exact head is SUCCESS.

- [ ] **Step 2: Whole-state adversarial review loop 1–5**

Attack at minimum:

1. old first-person/no-online canon still silently controlling implementation;
2. Appreciation Camera losing existing touch/mouse behavior or affecting rewards/timer;
3. visible avatar blocking sea/pet or becoming final-art evidence by accident;
4. 3/4 camera making speed bob/motion sickness worse or UI unreadable in portrait;
5. docs/Notion claiming decoration/social backend exists when only the shell exists.

Any new valid finding resets the clean-loop count after correction according to project workflow.

- [ ] **Step 3: PR review surfaces**

Check changed files, full patch, comments, reviews, unresolved threads, and base-main movement.

- [ ] **Step 4: Merge with expected head SHA**

Use squash merge only after exact-head CI and review are clean.

- [ ] **Step 5: Postmerge readback**

Verify new `main` SHA and merged files. Confirm the current-task issue closes if linked.

- [ ] **Step 6: Notion sync**

Update:

- Project Registry `Repo Main SHA`, revision, notes;
- Home current state;
- `3/4 디오라마 플레이어·카메라` record → `SYNCED` with merged SHA;
- existing core loop source/evidence as appropriate;
- Production Handoff receipt.

Leave `보트 꾸미기 슬롯 존`, `저압력 상호작용 시스템`, `FriendBottle`, `DriftBottle`, and social-safety runtime records as future/not-implemented (`REPO_UPDATE_REQUIRED`) unless actually implemented in a later slice.

- [ ] **Step 7: Final evidence ceiling**

Report separately:

```text
Godot contract/scene behavior = PASS if CI proves it
Visible avatar technical shell = PASS
3/4 camera technical shell = PASS
Appreciation Camera preservation = PASS
Human visual comfort = NOT_RUN
Final avatar art = NOT_INTEGRATED
Boat decoration runtime = NOT_IMPLEMENTED
Bottle social runtime/backend = NOT_IMPLEMENTED
Real mobile device QA = NOT_RUN
```
