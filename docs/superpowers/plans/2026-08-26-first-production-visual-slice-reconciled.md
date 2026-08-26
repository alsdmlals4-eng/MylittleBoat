# First Production Visual Slice Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Make the existing 540×960 BoatSpace read as a calm hand-painted-storybook 3D diorama without changing gameplay semantics or canonizing final character/pet identity.

**Architecture:** Add visual-only `VisualStudy` child hierarchies to the existing BoatSpace owners, retain their scripts and transforms, and use opaque matte `StandardMaterial3D` materials. Keep dynamic decor construction as the rendering boundary, then verify the new proof with one structural contract plus the existing behavior contracts.

**Tech Stack:** Godot 4.7.x stable, GDScript, Mobile renderer, `StandardMaterial3D`, existing GitHub Actions validation.

**Spec:** `docs/superpowers/specs/2026-08-26-first-production-visual-slice-design.md`

## Global Constraints

- Work from current completed `main`; preserve unrelated local changes in `project.godot`, `scenes/main_menu.tscn`, `addons/`, and generated import/UID files.
- Keep PR #19 `READ_ONLY / NO ABSORPTION`.
- Preserve voyage rules, mood meaning, both cameras, shared BoatSpace bob, eight slot IDs, current item IDs, interaction contracts, and local-first state.
- Use only project-owned primitive meshes and opaque matte `StandardMaterial3D` materials.
- Do not add generated assets, external dependencies, custom shaders, final identity/species canon, four-time behavior, economy, chores, social features, or new player-facing copy.
- Human 30-second/5-minute review and real-device touch QA remain manual evidence gates.

---

### Task 1: Add a RED visual-boundary contract

**Files:**
- Create: `tests/test_handpainted_visual_slice_contract.gd`
- Modify later: `.github/workflows/godot-validation.yml`

**Interfaces:**
- Consumes: `res://scenes/game.tscn`, `BoatSpace`, `PlayerAvatarPlaceholder`, `RestingPetPlaceholder`, `BoatBow`, and both existing cameras.
- Produces: a scene contract that requires visual-study nodes/materials while explicitly preserving technical-placeholder and no-care evidence.

- [ ] **Step 1: Write the failing contract**

```gdscript
var avatar := scene.get_node_or_null("VoyageWorld/BoatSpace/PlayerAvatarPlaceholder") as Node3D
var pet := scene.get_node_or_null("VoyageWorld/BoatSpace/RestingPetPlaceholder") as Node3D
var boat := scene.get_node_or_null("VoyageWorld/BoatSpace/BoatBow") as Node3D
_expect(avatar != null and avatar.get_node_or_null("VisualStudy") != null, "avatar needs VisualStudy")
_expect(pet != null and pet.get_node_or_null("VisualStudy") != null, "pet needs VisualStudy")
_expect(boat != null and boat.get_node_or_null("VisualStudy") != null, "boat needs VisualStudy")
_expect(bool(avatar.call("is_technical_placeholder")), "avatar remains a placeholder")
_expect(not bool(pet.call("has_care_obligation")), "pet remains care-free")
```

For every `MeshInstance3D` below each `VisualStudy`, require a `StandardMaterial3D` with `metallic == 0.0`, `roughness >= 0.8`, and an opaque blend mode.

- [ ] **Step 2: Run the contract before scene changes**

Run: `godot --headless --path . --script res://tests/test_handpainted_visual_slice_contract.gd`

Expected: FAIL because no `VisualStudy` nodes exist.

- [ ] **Step 3: Commit the RED test**

```bash
git add tests/test_handpainted_visual_slice_contract.gd
git commit -m "Add visual slice contract"
```

### Task 2: Build player, companion, and boat visual studies

**Files:**
- Modify: `scenes/boat_space.tscn`

**Interfaces:**
- Consumes: existing placeholder parents and their current local positions/scripts.
- Produces: `PlayerAvatarPlaceholder/VisualStudy`, `RestingPetPlaceholder/VisualStudy`, and `BoatBow/VisualStudy`.

- [ ] **Step 1: Hide legacy primitive children without renaming or removing the behavior parents**

Set the existing primitive display `Body` and `Head` nodes invisible when their replacement study is present. Keep `PlayerAvatarPlaceholder`, `RestingPetPlaceholder`, `BoatBow`, all transforms, and attached scripts unchanged.

- [ ] **Step 2: Add the neutral player study**

Create a `VisualStudy` `Node3D` with `CoatMass`, `LowerBodyMass`, `HeadMass`, `HairMassA`, and `HairMassB`. Use capsule/sphere/box primitives, broad muted teal/cream/brown values, `metallic = 0.0`, and `roughness = 0.9`. Do not add facial features or identity-signature details.

- [ ] **Step 3: Add the non-species companion study**

Create `VisualStudy` with `RestingBodyMass` and `HeadMass`, using two low elongated sphere masses in muted warm beige with `roughness = 0.92`. Add no ears, tail, markings, or species signature.

- [ ] **Step 4: Add the boat study**

Create `BoatBow/VisualStudy` with `HullMass`, `DeckMass`, and two low rail masses. Use warm wood broad values with `roughness = 0.86`; preserve the slot transforms outside this hierarchy.

- [ ] **Step 5: Run the new and existing camera contracts**

Run:

```bash
godot --headless --path . --script res://tests/test_handpainted_visual_slice_contract.gd
godot --headless --path . --script res://tests/test_diorama_avatar_camera_contract.gd
```

Expected: both pass; camera and shared-bob semantics stay unchanged.

### Task 3: Give dynamic decor a compatible material pass

**Files:**
- Modify: `scripts/decor/boat_decor_slot.gd`

**Interfaces:**
- Consumes: `apply_item(item_id, appearance_id)`, `BoatDecorCatalog`, current interaction state, and approved image textures.
- Produces: the same item IDs/actions with matte, low-noise primitive decor visuals.

- [ ] **Step 1: Preserve state and action APIs**

Leave `apply_item`, `get_item_id`, `get_appearance_id`, `get_actions`, `can_interact`, `perform`, and `is_technical_placeholder` signatures unchanged.

- [ ] **Step 2: Change only rendering values and primitive proportions**

Keep all generated materials at `metallic = 0.0` and `roughness >= 0.84`. Keep the lantern light toggle and mug held offset unchanged. Preserve the existing pet-cushion and postcard texture assignment helpers.

- [ ] **Step 3: Run decor and interaction regression**

Run:

```bash
godot --headless --path . --script res://tests/test_boat_decoration_contract.gd
godot --headless --path . --script res://tests/test_low_pressure_interaction_contract.gd
godot --headless --path . --script res://tests/test_boat_life_scene_contract.gd
```

Expected: all pass with the same slot, replacement, and interaction behavior.

### Task 4: Tune the existing sea, sky, and lighting owners

**Files:**
- Modify: `scenes/game.tscn`

**Interfaces:**
- Consumes: current `WorldEnvironment`, sun light, ocean plane, mood update, and both camera rigs.
- Produces: a low-noise opaque sea/sky/light treatment with unchanged mood and camera behavior.

- [ ] **Step 1: Adjust only current environment/material parameters**

Use broad blue-green sea values, low specular/metallic response, and soft light. Do not create another world, time controller, shader, post-process, or transparent overlay.

- [ ] **Step 2: Keep `_apply_mood_tone()` atmospheric only**

It may continue changing background color but must not change voyage time, rewards, map, weather quality, or penalties.

- [ ] **Step 3: Run game/camera regression and scene smoke**

Run:

```bash
godot --headless --path . --script res://tests/test_game_scene_contract.gd
godot --headless --path . --script res://tests/test_camera_input_contract.gd
godot --headless --path . --scene res://scenes/game.tscn --quit-after 1
```

Expected: all pass.

### Task 5: Add the contract to CI and capture runtime evidence

**Files:**
- Modify: `.github/workflows/godot-validation.yml`
- Create: `docs/evidence/2026-08-26-first-production-visual-slice/normal_540x960.png`
- Create: `docs/evidence/2026-08-26-first-production-visual-slice/appreciation_540x960.png`
- Modify: `README.md`
- Modify: `docs/GODOT_MVP_ROADMAP.md`

**Interfaces:**
- Consumes: completed visual contract and live Godot scene.
- Produces: canonical CI coverage plus evidence that is explicitly runtime proof, not final-art or human-comfort approval.

- [ ] **Step 1: Add exactly one CI invocation**

Add this line to the existing focused contract block:

```bash
timeout 20s godot --headless --path . --script res://tests/test_handpainted_visual_slice_contract.gd || status=1
```

- [ ] **Step 2: Capture both camera modes at 540×960**

Run the actual scene, capture Normal and Appreciation views, and save the two PNGs at the paths above. Record diagnostics; do not describe either capture as human comfort approval.

- [ ] **Step 3: Update human-facing execution status**

Set the roadmap and README to `TECH_VISUAL_SLICE = PASS` only after automated contracts, smokes, and runtime evidence pass. Leave `HUMAN_DIORAMA_COMFORT`, `HUMAN_STYLE_APPROVAL`, and `REAL_DEVICE_TOUCH_QA` as `NOT_RUN`.

- [x] **Step 4: Run the full suite and commit the completed slice**

Run all focused contracts, three scene smokes, `git diff --check`, and GitHub Actions on the exact PR head. Commit only current-slice files.
