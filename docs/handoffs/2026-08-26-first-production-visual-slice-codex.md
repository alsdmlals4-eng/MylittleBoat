# My Little Boat — First Production Visual Slice Codex Handoff

## 0. Handoff Contract

```yaml
handoff_mode: CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF
project: MY_LITTLE_BOAT
repository: alsdmlals4-eng/MylittleBoat
planning_baseline_main: d5482ca7b4b38a3a8d45932fe354a64f8f33eebc
implementation_baseline: RESOLVE_CURRENT_COMPLETED_MAIN_AT_CODEX_START
target_branch: feat/first-production-visual-slice-20260826
work_instruction_status: GPT_REVIEWED_GODOT_IMPLEMENTATION_READY_AFTER_PLANNING_CLOSEOUT
implementation_owner: CODEX_GODOT_PRODUCT_IMPLEMENTATION_OWNER
final_review_owner: GPT_FINAL_IMPLEMENTATION_REVIEW
actual_state_verification_required: true
notion_rehydration_required: true
github_rehydration_required: true
codex_image_generation: FORBIDDEN
codex_generative_image_editing: FORBIDDEN
missing_visual_action: GPT_VISUAL_REQUEST
concurrent_pr_19: READ_ONLY_NO_ABSORPTION
```

Do not treat the historical SHA above as the implementation baseline after this planning package is merged. At Codex start, resolve the repository default branch again and use its exact completed `main` as the product baseline.

## 1. Player Outcome

Implement one bounded visual-production proof where the **real current game scene** reads closer to an authored moving storybook than a generic primitive/CG prototype while preserving the sea-first rest experience.

The proof must let GPT/user evaluate, at the actual 540x960 portrait gameplay target:

```text
sea / horizon remains primary
→ neutral player silhouette + resting companion read together
→ boat feels like a personal lived-in place
→ small placed decor belongs to the same matte visual language
→ Normal and Appreciation cameras remain the same game/world
```

This is **not** final art production.

## 2. Approved Scope

### Implement

- bounded neutral player visual study inside the existing avatar behavior node;
- bounded non-species-canonized resting companion visual study inside the existing pet behavior node;
- existing BoatSpace material/shape pass without replacing its ownership structure;
- existing dynamic decor visual pass, preserving all six item IDs and eight slot IDs;
- calm sea/sky/light treatment in the existing `game.tscn` world;
- automated evidence contract for the visual-study layer;
- Godot PR validation wiring for that contract;
- runtime Normal/Appreciation comparison and responsive technical probes if Codex can observe them directly.

### Product paths expected to be relevant

```text
project.godot
scenes/game.tscn
scenes/boat_space.tscn
scripts/decor/boat_decor_slot.gd
tests/test_handpainted_visual_slice_contract.gd
tests/test_diorama_avatar_camera_contract.gd
tests/test_boat_decoration_contract.gd
tests/test_low_pressure_interaction_contract.gd
tests/test_boat_life_scene_contract.gd
.github/workflows/godot-validation.yml
```

Codex may choose a safer/smaller technical implementation after fresh-reading the actual project, provided the approved player outcome, acceptance criteria, evidence ceiling, and protected behavior remain unchanged.

## 3. Protected Scope

Do not change:

- rest-first player promise or Core Loop;
- voyage duration/reward semantics;
- mood meaning;
- `DioramaCamera3D` / `AppreciationCamera3D` behavior meaning;
- `BoatSpace` single-bob-owner relationship;
- eight decor slot IDs or compatibility meaning;
- `GameState.boat_decor = slot_id -> item_id` meaning;
- low-pressure interaction API or reward isolation;
- pet care obligation (`false`);
- local-first voyage/rest/pet/decor/album/fishing/soundscape core;
- delayed-bottle product rules;
- PR #19 branch/content;
- final player identity, gender/age/lore, exact hair/clothes;
- final pet species;
- final UI navigation/typography;
- exact four-state time behavior;
- save/schema/API compatibility;
- project localization meaning;
- social/network/backend scope.

No combat, stamina, HP, enemies, death, failure state, ranking, chores, daily pressure, gacha, ads, payments, runtime generative AI, realtime/public chat, public feed, followers, or popularity mechanics.

## 4. Approved Visual Inputs

Codex must fresh-read the current-use records from Notion rather than rely on this summary alone.

```yaml
project_home: 3c41b237-eb1c-8194-8b8e-d88362cafafa
visual_bible: 3c11b237-eb1c-81ae-97f3-dc28a0905304
asset_library: 3c11b237-eb1c-8120-b7db-d48e11756146
production_handoff: 3c11b237-eb1c-81b0-b281-ec54d67c9552
ai_evidence: 3c61b237-eb1c-812f-a9f5-f5a116a98370
approved_visual_records:
  - APPROVED_PRODUCTION_VISUAL_PROOF
  - APPROVED_PRODUCTION_VISUAL_PROOF_02
current_detailed_visual_canon: HANDPAINTED_STORYBOOK_3D_DIORAMA
parent_visual_philosophy: SOFT_STORYBOOK_3D_DIORAMA
```

Allowed use of Proof 01/02:

- style/emotion/material-language reference;
- silhouette-first player direction;
- quiet companion/resting relationship;
- lived-in boat/decor language;
- matte, broad-value, low-noise surface intent;
- sea/horizon hierarchy.

Not allowed to infer from Proof 01/02:

- final player sex/gender/age/hair/clothes;
- final pet species;
- final decor set;
- exact UI;
- exact RGB/HEX palette;
- exact shader implementation;
- final runtime geometry;
- final asset approval.

If a new raster/model/texture is truly required, return `GPT_VISUAL_REQUEST`. Do not create or generatively edit it in Codex.

## 5. GitHub Sources to Fresh-Read

```yaml
github_sources:
  repository: alsdmlals4-eng/MylittleBoat
  project_agents: AGENTS.md
  current_direction:
    - README.md
    - docs/CONCEPT.md
    - docs/RESTING_EXPERIENCE_BIBLE.md
    - docs/GODOT_MVP_ROADMAP.md
  approved_spec: docs/superpowers/specs/2026-08-25-handpainted-storybook-3d-diorama-design.md
  implementation_plan: docs/superpowers/plans/2026-08-26-first-production-visual-slice.md
  previous_handoff: docs/handoffs/2026-08-25-handpainted-visual-closeout.md
  actual_product:
    - project.godot
    - scenes/game.tscn
    - scenes/boat_space.tscn
    - scripts/avatar/player_avatar_placeholder.gd
    - scripts/voyage/resting_pet_placeholder.gd
    - scripts/decor/boat_decor_catalog.gd
    - scripts/decor/boat_decor_slot.gd
    - scripts/voyage/game_scene.gd
  runtime_tests:
    - tests/test_game_scene_contract.gd
    - tests/test_camera_input_contract.gd
    - tests/test_resting_core_contract.gd
    - tests/test_diorama_avatar_camera_contract.gd
    - tests/test_boat_decoration_contract.gd
    - tests/test_low_pressure_interaction_contract.gd
    - tests/test_boat_life_scene_contract.gd
    - tests/test_boat_life_ui_contract.gd
  workflow: .github/workflows/godot-validation.yml
  current_open_prs: true
```

## 6. Acceptance Criteria

1. The real `game.tscn` still uses the current BoatSpace and both approved cameras; no second mock game/world replaces it.
2. Avatar/pet/boat expose bounded visual-study geometry materially more deliberate than the current sphere/box display while final identity remains uncanonized.
3. Visual-study materials are simple opaque matte-biased materials; no new broad watercolor shader/plugin/dependency is introduced.
4. Sea/sky/light treatment preserves stable horizon, low visual noise, and mood-tone compatibility.
5. A small cluster of existing decor can be placed through the current decor system and visually belongs to the same treatment; no default inventory/state semantics are changed just for a screenshot.
6. All 8 slot IDs, 6 item IDs, compatibility, replace/clear behavior, and low-pressure interaction semantics remain unchanged.
7. Avatar/pet/boat remain attached to BoatSpace bob; Appreciation transition does not mutate voyage time, speed choice, or rewards.
8. Pet still has no care obligation and no attention-demanding interaction loop is added.
9. TDD evidence exists: the new focused visual-slice contract fails on the baseline for the intended missing visual layer, then passes after implementation.
10. Existing focused contracts and `main_menu/game/album` smokes pass on the exact implementation head.
11. Canonical PR CI runs on the exact implementation head before GPT review; older CI is not reused.
12. No product code or delta from PR #19 is copied, rebased, modified, merged, or absorbed.
13. No new user-facing strings are required. If implementation unexpectedly adds strings, stop and return a change proposal/localization impact rather than silently increasing untranslated content.
14. 540x960 portrait runtime observation is captured if the environment allows it. Representative `pc_standard`, `pc_wide_or_ultrawide`, and `mobile_landscape` probes are recorded as technical smokes only; lack of full semantic parity must remain `PARTIAL/NOT_RUN`, not PASS.
15. Human 30s/5m comfort, Human style approval, real-device touch, and final-art status remain `NOT_RUN/NOT_INTEGRATED` until directly observed.

## 7. Implementation Preference, Not a Hard Technical Mandate

The preferred first route is:

```text
existing 3D architecture
+ a few deliberate primitive mesh masses
+ simple StandardMaterial3D matte/broad-value treatment
+ existing light/environment
+ existing decor system
```

Reason: it is the smallest route that can test silhouette, sea-first hierarchy, authored broad values, motion survival, and solo-developer repeatability without coupling the proof to a texture/model pipeline or custom watercolor shader.

If this route cannot satisfy the acceptance criteria after direct runtime inspection, do not compensate by scaling complexity blindly. Return the evidence and recommend one of:

```text
LIGHTWEIGHT_SHADER_FOLLOWUP
GPT_APPROVED_AUTHORED_ASSET_REQUEST
VISUAL_DIRECTION_REOPEN_REQUIRED
```

## 8. Toolchain Freshness Gate

Observed external state on 2026-08-26:

- Godot latest stable: `4.7.2-stable` (maintenance release; official release notes recommend adoption with VCS/backup precautions).
- Repository CI currently installs `4.7.0`; project `project.godot` declares the 4.7 feature line.
- Godot AI public latest release observed from the official GitHub release API: `v3.2.0`, published 2026-08-25. This is newer than the earlier 3.1.5 observation and includes client/tool-registry changes, so it must **not** be silently auto-adopted without the current Base provider-upgrade compatibility/canary/rollback gate.

Codex must resolve its actual implementation toolchain, installed pins, and compatibility at start. Do not mutate user-local toolchain or project adoption records merely because a newer release exists. Any safe update claim requires actual installed identity, canary, rollback, and readback evidence.

## 9. Required Runtime / Play Checks

Minimum product checks:

```text
Godot headless import
new handpainted visual-slice contract
all pre-existing focused behavior contracts
main_menu scene smoke
game scene smoke
album scene smoke
Normal/Appreciation runtime comparison if observable
BoatSpace bob + pet idle motion observation if observable
540x960 portrait observation if observable
representative extra profile smokes if observable
```

User/Human check after GPT accepts technical result:

```text
30 seconds: hierarchy/readability/fatigue
5 minutes: CALM vs EMPTY vs visually noisy
Normal/Appreciation: same-world continuity
motion: storybook feel survives bob/idle
player/pet/sea: sea remains primary enough
```

## 10. CHANGE_PROPOSAL Boundary

Return to GPT instead of changing these autonomously:

- Core Loop or rest-first promise;
- camera semantics;
- decor slot count/meaning;
- pet system meaning;
- final character or pet identity;
- new time-cycle behavior;
- final UI/UX redesign;
- new asset pipeline or paid/external dependency;
- custom shader becoming a project-wide visual foundation;
- save/schema migration;
- localization target/Chinese-variant decision;
- social backend/PR #19;
- target-platform product-direction change.

## 11. Codex Result Contract

```yaml
codex_result:
  project: MY_LITTLE_BOAT
  repository: alsdmlals4-eng/MylittleBoat
  baseline_main:
  implementation_branch:
  final_head:
  implementation_direction_chosen:
  changed_godot_files_and_reasons: []
  protected_behavior_preserved: []
  tdd_red_evidence: []
  tests_passed: []
  tests_failed: []
  tests_not_run: []
  runtime_or_play_evidence: []
  responsive_probe_dimensions: []
  approved_notion_visuals_consumed: []
  visual_requests_waiting: []
  technical_improvements: []
  change_proposals: []
  remaining_risks: []
  toolchain_observed:
  rollback:
  status: READY_FOR_GPT_REVIEW | BLOCKED | WAITING_GPT_VISUAL
```

Stop at `READY_FOR_GPT_REVIEW`. GPT owns final adversarial review, exact-head evidence assessment, GitHub/Notion canonical reflection, merge decision, postmerge readback, and completion ceiling.
