# Look Around Camera Implementation Plan

> **For agentic workers:** Execute this plan inline. The current checkout contains active uncommitted work and open PR #19 belongs to another workstream. Do not create a parallel worktree, commit, reset, clean, force-push, or modify that PR. Keep every change scoped to Look Around and its current documentation owners.

**Goal:** Add a local, calm Look Around mode to the normal boat diorama. The player can use mouse/touch drag to inspect approved front/side/rear/overhead compositions without changing voyage state.

**Architecture:** `GameScene` owns mutually exclusive presentation-mode routing. A new `LookAroundCameraController` owns input, yaw/pitch clamps and deterministic angle buckets. A new `LookAroundPresentationRouter` is a narrow asset-selection seam: it returns the existing approved front composition until the four generated angle candidates receive separate user approval and canonical registration.

**Tech Stack:** Godot 4.7 stable, GDScript, existing `game.tscn` 3D camera rigs, `InputEventScreenDrag`, SceneTree contracts, current approved image registry.

**Spec:** `docs/superpowers/specs/2026-08-30-look-around-camera-design.md`

**Execution receipt, 2026-08-30:** Tasks 1–6 have been completed for the user-approved `MLB-LOOK-CHIBI-TRN-001..004` exact assets. The router, GameScene consumer, duplicate-card guard, asset-load guard, focused contracts, and six 540×960 GPU captures are recorded in the current handoff and visual owner. The separately generated Normal Diorama chibi replacement is a new `USER_REVIEW_PENDING` candidate and is not covered by this completion receipt.

## Global constraints

- Keep the startup Normal Diorama and existing Appreciation Camera intact.
- Do not make Look Around persistent, rewarded, timed, social, monetized, competitive, threatening, or gameplay-affecting.
- Do not use technical primitive meshes as the player-facing angle view.
- Keep candidate art out of `assets/images/runtime/` and out of `game.tscn` until explicit user approval.
- Preserve normal/UI input priority through `_unhandled_input` and current camera gating.
- Before completion, distinguish automated PASS, GPU-rendered PASS, and unrun human/device comfort review.

---

### Task 1: Establish a failing isolated camera-input contract

**Files:**

- Create: `tests/test_look_around_camera_input_contract.gd`
- Create later: `scripts/voyage/look_around_camera_controller.gd`

- [ ] Create a SceneTree contract before the controller exists. Instantiate a `Node3D` with a `Camera3D` named `LookAroundCamera3D`, attach the future controller, and check the following.
  - An inactive camera cannot consume a screen drag or rotate the rig.
  - An active screen drag changes yaw/pitch but keeps `rotation_degrees.z == 0.0`.
  - pitch never leaves `[-16.0, 38.0]`; yaw never leaves `[-135.0, 135.0]`.
  - Calling `get_angle_id()` at representative yaw/pitch values yields `front`, `port`, `starboard`, `aft`, `overhead` deterministically.
- [ ] Run the focused script and observe the expected missing-controller failure.

```powershell
& $godotExe --headless --path . --script res://tests/test_look_around_camera_input_contract.gd
```

### Task 2: Implement only the narrow local input owner

**Files:**

- Create: `scripts/voyage/look_around_camera_controller.gd`
- Modify: `tests/test_look_around_camera_input_contract.gd` only if the red contract finds an API naming ambiguity.

- [ ] Add the Korean one-line source header.
- [ ] Use exported sensitivities and clamps from the approved spec.
- [ ] Treat left-button drag and `InputEventScreenDrag` equivalently, only while `LookAroundCamera3D.current` is true.
- [ ] Emit `angle_changed(angle_id: String)` only when the deterministic bucket changes. Make a neutral initial `front` value available after `_ready()`.
- [ ] Re-run the focused contract until it passes.

### Task 3: Add explicit mode routing without art integration

**Files:**

- Modify: `scenes/game.tscn`
- Modify: `scripts/voyage/game_scene.gd`
- Create: `scripts/voyage/look_around_presentation_router.gd`
- Create: `tests/test_look_around_game_scene_contract.gd`
- Modify: `tests/test_game_scene_contract.gd`

- [ ] First write a failing game-scene contract that requires an explicit `set_look_around_mode(active: bool)` and `get_active_camera_mode()` reporting `look_around` only while active.
- [ ] Add a disabled-by-default `LookAroundCameraRig/LookAroundCamera3D/SeaBackdrop` to `VoyageWorld`, with the input controller on the rig. Add a named `LookAroundButton` to the existing top controls.
- [ ] Set current cameras and all three backdrop visibilities from one `_apply_camera_mode()` owner. Never depend on Camera3D's implicit current-camera fallback.
- [ ] Add a local `var _look_around_mode := false`. Enabling Look Around turns off `GameState.appreciation_mode`; enabling Appreciation turns off Look Around. Entering decor/album/photo closes Look Around. Existing Appreciation drag remains unchanged.
- [ ] Use `LookAroundPresentationRouter.get_fallback_angle_id()` to retain the current approved front asset until individual angle assets are approved. It must not load candidate paths.
- [ ] Verify input/mode tests and existing camera-input contract.

### Task 4: Generate, review, and gate the four visual candidates

**Files:**

- Create outside canonical runtime asset paths: generated candidates supplied by ImageGen.
- Modify later on approval: current visual asset owner, provenance registry, consumer matrix.

- [ ] Inspect the existing approved C + dog boat and the three user reference captures before generating.
- [ ] Generate four portrait 540×960 candidates for `port`, `starboard`, `aft`, and `overhead`. All must be original, logo-free, text-free, non-threatening, no-UI boat/sea illustrations using the project’s soft storybook language.
- [ ] Show all four with their intended angle and wait for explicit asset approval.
- [ ] **Gate:** do not copy candidate bytes into `assets/images/runtime/voyage/look_around/`, do not write their canonical hashes, and do not attach them to `game.tscn` before that approval.

### Task 5: Canonicalize approved art and connect the router

**Prerequisite:** explicit approval for the reviewed candidates.

**Files:**

- Create: `assets/images/runtime/voyage/look_around/*.png`
- Modify: `scenes/game.tscn`
- Modify: `scripts/voyage/look_around_presentation_router.gd`
- Modify: `scripts/voyage/game_scene.gd`
- Modify: `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md`
- Modify: `docs/design/PROJECT_GDD.md`
- Modify: `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`
- Modify: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`
- Modify/create: focused runtime asset contracts and 540×960 capture script

- [ ] Copy only approved exact candidate bytes into the canonical path and compute SHA-256.
- [ ] Register provenance, approver, intended consumer, status transitions, and each evidence boundary in the current visual owner.
- [ ] Register the four external textures and use the router to update only the Look Around backdrop when the bucket changes.
- [ ] Keep the primary `BoatSpace` and water-contact ripple visible and moving; do not re-enable technical presentation nodes.
- [ ] Extend the runtime-asset contract to assert each approved image has one intentional Look Around consumer.

### Task 6: Verify, capture, and perform adversarial review

**Files:**

- Modify/create: `tests/capture_look_around_views.gd`
- Modify: current docs listed in Task 5 only as facts observed.

- [ ] Run all focused Look Around contracts plus existing normal/appreciation/time/boat/decor/asset contracts.
- [ ] Run `godot --headless --path . --quit` and `godot --headless --path . --scene "res://scenes/game.tscn" --quit-after 1` with the project’s known local executable fallback if required.
- [ ] Capture 540×960 normal, port, starboard, aft, overhead, and Appreciation frames on the actual runtime surface.
- [ ] Run `git diff --check` and read back every changed runtime/document owner.
- [ ] Attack authority drift, accidental candidate promotion, hidden technical mesh visibility, input leakage, duplicate current cameras, gameplay-state mutation, accessibility/motion claims, and visual rights drift. Correct any observed defect before reporting.

## Completion evidence

Automated and runtime capture can prove source-level modes, input routing and rendered surfaces. They do not prove a person finds the rotation comfortable, legible, calm, or sufficiently distinct at the target device size. Those remain a separate Human/device verification after integrated approved art is available.
