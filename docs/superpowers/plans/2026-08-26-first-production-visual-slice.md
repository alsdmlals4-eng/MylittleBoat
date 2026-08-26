# First Production Visual Slice Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Translate the already approved `HANDPAINTED_STORYBOOK_3D_DIORAMA` direction into one bounded Godot production proof that uses the real BoatSpace, Normal/Appreciation cameras, decor system, mobile renderer, and existing rest/voyage behavior without canonizing final player or pet identity.

**Architecture:** Preserve the current `game.tscn -> BoatSpace -> Avatar/Pet/Boat/DecorSlots` runtime architecture and add only a visual-study layer. Use deliberate multi-part silhouettes and simple matte `StandardMaterial3D` materials first; do not add external assets, runtime generative AI, a new rendering plugin, or a broad watercolor shader. Existing gameplay scripts remain the behavior authority. Automated tests prove structure/evidence boundaries and regression; 540x960 and additional responsive-profile captures prove only visual/runtime observations, while Human comfort/style approval remains `NOT_RUN` until the user actually reviews it.

**Tech Stack:** Godot 4.7.x stable / GDScript / Mobile renderer / `StandardMaterial3D` / existing GitHub Actions Godot validation / Notion approved Visual Proof 01 and 02 as reference-only visual inputs.

**Spec:** `docs/superpowers/specs/2026-08-25-handpainted-storybook-3d-diorama-design.md`

## Global Constraints

- Baseline completed `main`: `d5482ca7b4b38a3a8d45932fe354a64f8f33eebc`; re-read latest `main` before product mutation and reconcile safely if it moved.
- Current planning branch: `plan/first-production-visual-slice-20260826`.
- PR #19 `Implement deterministic local social fake backend` is a pre-existing independent workstream: `READ_ONLY / NO ABSORPTION`.
- Product promise remains rest-first: doing nothing is valid; no combat, failure, chores, farming, ranking, ads, payment, or realtime/public social pressure.
- Preserve `DioramaCamera3D`, `AppreciationCamera3D`, `BoatSpace`, 8 decor slot IDs, low-pressure interactable semantics, voyage duration/rewards, and local-first core.
- Visual hierarchy remains `sea/horizon -> player+pet together -> lived-in boat -> optional affordances`.
- `SOFT_STORYBOOK_3D_DIORAMA` remains parent philosophy; `HANDPAINTED_STORYBOOK_3D_DIORAMA` remains the detailed current canon.
- Final player identity, gender/age/lore, exact hair/clothes, pet species, final boat model, final UI, exact palette, exact shader, final asset pipeline, and four-state time behavior remain undecided.
- First slice must not implement the separate `DAWN / BRIGHT / SUNSET / NIGHT` behavior layer.
- Approved Visual Proof 01/02 are art-direction references, not runtime assets. Codex must not generate or generatively edit images.
- No new paid asset, API, SaaS, renderer plugin, or dependency.
- No external texture/model is required for this proof. Use project-owned Godot primitives/resources/materials unless GPT later supplies an explicitly approved asset.
- Keep all material passes opaque unless a specific existing effect already requires transparency; avoid adding transparent painterly layers solely for style.
- No new player-facing text is required. Therefore this slice must not increase localization string debt. Project-wide `ko/en/ja/zh-*` readiness and Chinese-variant declaration remain a separate unresolved delivery requirement rather than being falsely marked complete here.
- Current product proof target remains the actual 540x960 portrait viewport. Also run representative non-authoritative responsive smokes for `pc_standard`, `pc_wide_or_ultrawide`, and `mobile_landscape`; these smokes do not redefine the portrait-first product direction or constitute Human UI QA.
- Human 30-second/5-minute comfort, final style approval, real-device touch, and production-art approval remain `NOT_RUN` until directly observed.

## Evidence / Research Disposition

### Existing Solution First

1. **REUSE** current BoatSpace, cameras, bob relationship, RestingPet behavior, 8-slot decor, and technical UI.
2. **REUSE** approved Notion Visual Proof 01/02 and Visual Bible as direction references only.
3. **ADAPT** current primitive meshes into more intentional multi-part silhouette studies instead of introducing a new asset pipeline.
4. **ADAPT** `StandardMaterial3D` matte/broad-value materials before a custom shader.
5. **REJECT for first slice** full 2D conversion, external asset packs, large texture pipeline, and broad custom watercolor shader.

### Three materially distinct implementation routes

| Route | Approach | Player value | Cost / risk | Disposition |
| --- | --- | --- | --- | --- |
| A | Recolor existing spheres/box only | Fastest | Too weak to test silhouette/authorship; high false-positive risk | REJECT |
| B | Bounded multi-part primitive silhouette + matte broad-value materials on the real scene | Tests actual composition and repeatable solo-dev workflow with low maintenance | Moderate scene editing; still not final art | **ADOPT** |
| C | Custom watercolor/toon shader + procedural surface motion | Strong stylization potential | Can look synthetic, adds shader/performance/maintenance variables before proving composition | DEFER / fallback only |
| D | New external modeled/textured player/pet/boat bundle | Highest potential fidelity | Asset production, rights, pipeline, integration, and identity decisions all become coupled | DEFER |

### External evidence used for this slice

- Godot 4.7 `StandardMaterial3D` is the default material path and can cover most artist-facing needs without custom shader code. Godot documentation also notes per-vertex lighting can materially improve performance on low-end/mobile devices.
- `Dordogne` is a useful **ADAPT** case: its art director described mixing hand-painted work with 3D while deliberately keeping shaders simple, warning that animated watercolor-shader imitation can look fake. Its Steam reception remains very positive, but popularity is not treated as causal proof.
- `SEASON: A letter to the future` is a **REFERENCE_ONLY** counterpoint: a larger custom-shader approach can produce a distinctive illustrated world, but its scope/team/tooling context is not evidence that My Little Boat should begin with a shader-heavy solution.

## File / Surface Map

| Path | Responsibility | Expected product-build mutation |
| --- | --- | --- |
| `scenes/boat_space.tscn` | Real BoatSpace; player/pet/boat visual study layers | Modify |
| `scenes/game.tscn` | Sea/sky/light material treatment; preserve both cameras and UI | Modify |
| `scripts/decor/boat_decor_slot.gd` | Existing dynamic decor visual construction | Minimal visual-only modify |
| `tests/test_handpainted_visual_slice_contract.gd` | New evidence-boundary and visual-structure contract | Create |
| `tests/test_diorama_avatar_camera_contract.gd` | Existing camera/behavior regression authority | Prefer no semantic change; modify only if evidence wording truly conflicts |
| `tests/test_boat_life_scene_contract.gd` | Existing BoatSpace/decor regression authority | Prefer no semantic change |
| `.github/workflows/godot-validation.yml` | Runs focused contract suite on PR | Add new test invocation only |
| `README.md` | Human developer-facing current implementation order/evidence | Update after product implementation result |
| `docs/GODOT_MVP_ROADMAP.md` | Execution mirror of current priority/evidence | Update after product implementation result |
| Notion Home / Visual Bible / Asset Library | Approved visual canon and proofs | Read-only during Codex implementation unless GPT handles a separate approved correction |
| Notion `AI · 작업 현황 · Evidence` / `06 · Production · Handoff` | Exact implementation/readback evidence | GPT updates after Codex result |

---

### Task 1: Freeze Current Truth and Produce TDD RED

**Files:**
- Create: `tests/test_handpainted_visual_slice_contract.gd`
- Modify later: `.github/workflows/godot-validation.yml`

**Interfaces:**
- Consumes: current `game.tscn`, `boat_space.tscn`, `BoatSpace`, `PlayerAvatarPlaceholder`, `RestingPetPlaceholder`, `DioramaCamera3D`, `AppreciationCamera3D`, current decor slots.
- Produces: a deterministic structural contract that fails on the pre-slice placeholder scene and passes only when the bounded visual proof exists.

- [ ] **Step 1: Re-read latest main, current open PRs, and exact target branch.**

Expected:

```text
main = latest completed default branch
PR #19 = independent READ_ONLY / NO ABSORPTION
no current-task product PR already owns FIRST_PRODUCTION_VISUAL_SLICE
```

If main moved, compare affected files before any edit. Do not reset/rebase/force another workstream.

- [ ] **Step 2: Add the new test with explicit evidence boundaries.**

The test must instantiate `res://scenes/game.tscn` and assert all of the following:

```gdscript
var avatar := scene.get_node_or_null("VoyageWorld/BoatSpace/PlayerAvatarPlaceholder") as Node3D
var pet := scene.get_node_or_null("VoyageWorld/BoatSpace/RestingPetPlaceholder") as Node3D
var boat := scene.get_node_or_null("VoyageWorld/BoatSpace/BoatBow") as Node3D
var diorama := scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D") as Camera3D
var appreciation := scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D") as Camera3D

_expect(avatar != null and avatar.get_node_or_null("VisualStudy") != null,
    "avatar must expose bounded handpainted VisualStudy")
_expect(pet != null and pet.get_node_or_null("VisualStudy") != null,
    "pet must expose bounded handpainted VisualStudy")
_expect(boat != null and boat.get_node_or_null("VisualStudy") != null,
    "boat must expose bounded handpainted VisualStudy")
_expect(diorama != null and appreciation != null,
    "both approved cameras must remain")
```

For every `MeshInstance3D` under each `VisualStudy`, require an active `StandardMaterial3D`, opaque blend mode, metallic `0.0`, and a matte-biased roughness floor chosen by the implementer within the approved style. The test must **not** assert that the art is beautiful, hand-painted, comfortable, final, or Human-approved.

Also assert:

```gdscript
_expect(avatar.has_method("is_technical_placeholder"), "avatar evidence API preserved")
_expect(bool(avatar.call("is_technical_placeholder")),
    "final avatar art remains NOT_INTEGRATED; behavior node remains explicit placeholder evidence")
_expect(pet.has_method("has_care_obligation") and not bool(pet.call("has_care_obligation")),
    "visual slice cannot create pet chores")
```

- [ ] **Step 3: Run RED on the exact baseline.**

Run:

```bash
godot --headless --path . --script res://tests/test_handpainted_visual_slice_contract.gd
```

Expected: FAIL specifically because `VisualStudy` nodes/material proof do not exist yet. Existing contracts must remain independently runnable.

- [ ] **Step 4: Record the RED head/run in the Codex result.**

Do not call the slice TDD-complete if the test was only written after implementation.

---

### Task 2: Build the Neutral Player and Resting-Companion Visual Studies

**Files:**
- Modify: `scenes/boat_space.tscn`

**Interfaces:**
- Consumes: existing `PlayerAvatarPlaceholder` and `RestingPetPlaceholder` nodes/scripts/positions/bob relationship.
- Produces: `PlayerAvatarPlaceholder/VisualStudy` and `RestingPetPlaceholder/VisualStudy` visual-only child hierarchies.

- [ ] **Step 1: Preserve the parent behavior nodes and hide only the old primitive display children when the new study is visible.**

Do not rename `PlayerAvatarPlaceholder` or `RestingPetPlaceholder`, change their scripts, move them out of BoatSpace, or change the pet interaction contract.

- [ ] **Step 2: Build the player from a few deliberate 3D masses.**

Use project-owned Godot primitive meshes only. The hierarchy should be conceptually equivalent to:

```text
PlayerAvatarPlaceholder
└─ VisualStudy
   ├─ CoatOrTorsoMass
   ├─ LowerBodyMass
   ├─ HeadMass
   └─ HairMassA / HairMassB
```

Requirements:

- silhouette remains readable at 540x960 without face rendering;
- hair is 2-4 broad masses, not strand detail;
- no eyes/face decal is required for this proof;
- no gender, age, lore, hairstyle identity, or final clothing canon is introduced;
- colors remain muted enough that the sea is not demoted to background decoration.

- [ ] **Step 3: Build the pet as a non-species-canonized resting companion study.**

Conceptual hierarchy:

```text
RestingPetPlaceholder
└─ VisualStudy
   ├─ RestingBodyMass
   └─ HeadMass
```

Do not add ears/tail/species-signature details that silently canonize cat/dog/rabbit/otter. Preserve the existing low-frequency `rest/watch_sea/nap/glance` behavior and tiny breathing scale.

- [ ] **Step 4: Use simple matte materials.**

Default route:

```gdscript
var material := StandardMaterial3D.new()
material.metallic = 0.0
material.roughness = 0.9
material.albedo_color = <muted authored color>
```

The exact roughness/color may be adjusted by Codex after runtime readback, but remain within the matte, low-noise, sea-first contract. Do not add a custom shader in this task.

- [ ] **Step 5: Run focused RED→GREEN check.**

Run:

```bash
godot --headless --path . --script res://tests/test_handpainted_visual_slice_contract.gd
godot --headless --path . --script res://tests/test_diorama_avatar_camera_contract.gd
```

Expected after Task 2: new visual-study assertions for avatar/pet pass; camera/bob/placeholder-evidence assertions remain passable. Boat/sea assertions may still be RED until later tasks.

---

### Task 3: Give the Existing Boat and Dynamic Decor a Bounded Matte Material Pass

**Files:**
- Modify: `scenes/boat_space.tscn`
- Modify: `scripts/decor/boat_decor_slot.gd`

**Interfaces:**
- Consumes: current `BoatBow`, `BoatRail`, six existing decor IDs, 8-slot compatibility rules, interaction toggle behavior.
- Produces: `BoatBow/VisualStudy` plus visually compatible dynamic decor without changing item IDs, categories, actions, state schema, or placement rules.

- [ ] **Step 1: Add a simple BoatBow visual study using large readable masses.**

Keep the current boat footprint and slot positions. Use only a few deck/hull/rail masses and broad warm natural value variation. Avoid photoreal wood grain, glossy bevel-showcase surfaces, or geometry that blocks avatar/pet/sea silhouettes.

- [ ] **Step 2: Preserve all 8 slot transforms and IDs exactly.**

The following remain unchanged:

```text
bow_left
bow_right
center_left
center_right
rear_left
rear_right
rail_accent
pet_corner
```

- [ ] **Step 3: Refine the existing dynamic decor visuals only at the rendering layer.**

`boat_decor_slot.gd` may change mesh proportions and material values for `lantern`, `mug`, `cushion`, `plant`, `postcard`, and `pet_cushion`, but must preserve:

```text
ITEM_IDS
category compatibility
get_actions / can_interact / perform
lantern toggle semantics
mug held semantics
GameState slot_id -> item_id storage
replace/clear no-loss behavior
```

Keep `is_technical_placeholder() == true`; this slice is a visual production proof, not final decor art.

- [ ] **Step 4: Run decor regression.**

Run:

```bash
godot --headless --path . --script res://tests/test_boat_decoration_contract.gd
godot --headless --path . --script res://tests/test_low_pressure_interaction_contract.gd
godot --headless --path . --script res://tests/test_boat_life_scene_contract.gd
```

Expected: 8-slot and interaction semantics unchanged, same-frame replacement still leaves one visual, and stored lantern/mug continue to render.

---

### Task 4: Apply the Sea / Sky / Light Treatment Without a Watercolor Shader

**Files:**
- Modify: `scenes/game.tscn`

**Interfaces:**
- Consumes: current `WorldEnvironment`, `SunLight`, `OceanPlane`, both camera rigs, mood-sky runtime update.
- Produces: low-noise sea/sky/light visual proof that still allows `_apply_mood_tone()` to change the environment safely.

- [ ] **Step 1: Keep the same WorldEnvironment and OceanPlane ownership.**

Do not create a second world, new map, or time-of-day controller.

- [ ] **Step 2: Adjust only low-cost material/light parameters first.**

Use `StandardMaterial3D`, opaque rendering, low metallic/specular response, high roughness, broad sea color, and soft broad lighting. Do not introduce screen-space painterly postprocess, animated paper noise, or a custom watercolor shader.

- [ ] **Step 3: Preserve mood semantics.**

`_apply_mood_tone()` must still alter only atmosphere/color and must not introduce good/bad weather, gameplay penalties, rewards, or separate maps.

- [ ] **Step 4: Preserve camera and UI behavior.**

Normal/Appreciation transitions, input isolation, UI hide/restore semantics, voyage time, rewards, and speed choice remain unchanged.

- [ ] **Step 5: Run visual contract plus scene/camera regression.**

Run:

```bash
godot --headless --path . --script res://tests/test_handpainted_visual_slice_contract.gd
godot --headless --path . --script res://tests/test_game_scene_contract.gd
godot --headless --path . --script res://tests/test_camera_input_contract.gd
godot --headless --path . --script res://tests/test_diorama_avatar_camera_contract.gd
godot --headless --path . --scene res://scenes/game.tscn --quit-after 1
```

Expected: all automated structure/regression checks pass. This proves neither Human comfort nor final art quality.

---

### Task 5: Wire the New Contract Into Canonical PR Validation

**Files:**
- Modify: `.github/workflows/godot-validation.yml`

**Interfaces:**
- Consumes: `tests/test_handpainted_visual_slice_contract.gd`.
- Produces: every product PR validates the bounded visual proof contract alongside existing behavior contracts.

- [ ] **Step 1: Add exactly one focused test invocation to the existing behavior-contract block.**

Add:

```bash
timeout 20s godot --headless --path . --script res://tests/test_handpainted_visual_slice_contract.gd || status=1
```

Do not remove existing tests or weaken failure aggregation.

- [ ] **Step 2: Do not opportunistically redesign the workflow.**

Current third-party Action pinning is a separate supply-chain concern. If current Base security policy blocks the exact implementation PR because the existing workflow uses mutable action tags, return that as a focused `CHANGE_PROPOSAL`/follow-up rather than mixing a broad CI refactor into the visual slice without evidence.

- [ ] **Step 3: Run the same commands locally/headlessly if available, then rely on canonical PR CI for exact-head remote evidence.**

No CI success may be reused from an earlier SHA.

---

### Task 6: Runtime / Responsive Evidence Capture

**Files:**
- No source change required unless a verified runtime bug is found.

**Interfaces:**
- Consumes: completed product candidate.
- Produces: runtime observation evidence separated from Human approval.

- [ ] **Step 1: Run normal game-scene smoke at the actual portrait target.**

Required target:

```text
540x960 portrait
```

Observe/capture Normal view with avatar + pet + boat + sea. Use the existing Decor panel to place a small compatible cluster such as lantern + mug/cushion; do not change default save/state semantics just to pre-populate the screenshot.

- [ ] **Step 2: Capture/observe Appreciation Camera on the same state.**

Confirm the sea/horizon becomes the focus and the visual treatment does not require a different map or reset voyage state.

- [ ] **Step 3: Exercise existing motion.**

Observe boat bob, pet breathing/resting state, and camera transition long enough to catch obvious motion noise, clipping, or silhouette collapse.

- [ ] **Step 4: Run representative responsive technical smokes.**

Use reasonable temporary viewport probes for:

```text
pc_standard
pc_wide_or_ultrawide
mobile_landscape
```

Record the exact dimensions actually used by Codex. These are technical probes only. If the current UI becomes unusable outside portrait, record `RESPONSIVE_SEMANTIC_PARITY = PARTIAL/NOT_RUN` rather than silently redesigning UI in this visual slice.

- [ ] **Step 5: Separate evidence ceilings.**

Allowed after Codex runtime observation:

```text
HANDPAINTED_3D_RUNTIME_SLICE = IMPLEMENTED / RUNTIME_OBSERVED (only if actually observed)
NORMAL_APPRECIATION_VISUAL_COMPARE = OBSERVED (only if actually observed)
```

Still required until the user directly reviews:

```text
MOBILE_30S_VISUAL_REVIEW = NOT_RUN
MOBILE_5M_VISUAL_REVIEW = NOT_RUN
HUMAN_STYLE_APPROVAL = NOT_RUN
REAL_DEVICE_TOUCH_QA = NOT_RUN
FINAL_AVATAR_ART = NOT_INTEGRATED
FINAL_PET_ART = NOT_INTEGRATED
FINAL_BOAT_SEA_ART = NOT_INTEGRATED
```

---

### Task 7: Full Regression and Codex Return Packet

**Files:**
- All changed Godot product files and tests.

- [ ] **Step 1: Run project import and every existing focused contract.**

Run the canonical suite represented by `.github/workflows/godot-validation.yml`, including the new visual-slice contract, plus `main_menu`, `game`, and `album` scene smokes.

- [ ] **Step 2: Confirm protected semantics explicitly.**

Return evidence that visual changes did not alter:

```text
voyage duration/reward state
Appreciation camera state semantics
8 decor slot IDs/compatibility
interaction reward isolation
pet care obligation = false
local-first core
social/network code = unchanged
```

- [ ] **Step 3: Return exact evidence.**

Codex result must include:

```yaml
codex_result:
  project: MY_LITTLE_BOAT
  repository: alsdmlals4-eng/MylittleBoat
  baseline_main:
  final_head:
  implementation_direction_chosen:
  changed_godot_files_and_reasons: []
  tests_passed: []
  tests_failed: []
  tests_not_run: []
  runtime_or_play_evidence: []
  responsive_probe_dimensions: []
  approved_notion_visuals_consumed:
    - APPROVED_PRODUCTION_VISUAL_PROOF
    - APPROVED_PRODUCTION_VISUAL_PROOF_02
  visual_requests_waiting: []
  technical_improvements: []
  change_proposals: []
  remaining_risks: []
  rollback:
  status: READY_FOR_GPT_REVIEW | BLOCKED | WAITING_GPT_VISUAL
```

- [ ] **Step 4: Stop at `READY_FOR_GPT_REVIEW`.**

Codex does not merge by itself under this handoff. GPT performs final contract review, exact-head CI/readback, Notion canonical reflection, minimum-five whole-state adversarial review, and current-task merge gate.

---

## Implementation Reality / Completion Boundary

This plan is `IMPLEMENTATION_READY` only when the current GitHub/Notion readback remains aligned and no new user decision is required. The eventual product change is not complete merely because files exist or CI is green.

```text
STRUCTURE / TEST PASS
≠ RUNTIME VISUAL QUALITY PASS
≠ HUMAN 30S/5M COMFORT PASS
≠ FINAL ART PASS
```

If the bounded StandardMaterial/multi-part route cannot produce a clearly more authored frame at 540x960, do **not** scale it across assets. Return evidence and re-open the Route B vs lightweight shader vs external authored-asset trade study before further production.
