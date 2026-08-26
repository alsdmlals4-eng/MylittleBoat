# Current Godot Product Implementation

> Stable current-work pointer for the next Codex Godot product build. This file is a **router/handoff**, not a second game-design canon.

## Current task

```yaml
project: MY_LITTLE_BOAT
mode: CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF
goal: FIRST_PRODUCTION_VISUAL_SLICE
implementation_baseline: RESOLVE_CURRENT_COMPLETED_MAIN_AT_CODEX_START
implementation_owner: CODEX_GODOT_PRODUCT_IMPLEMENTATION_OWNER
final_review_owner: GPT_FINAL_IMPLEMENTATION_REVIEW
concurrent_pr_19: READ_ONLY_NO_ABSORPTION
image_generation_by_codex: FORBIDDEN
status: READY_FOR_CODEX_FRESH_READ
```

At implementation start, do **not** reuse a historical SHA from a plan or chat. Fresh-read the repository default branch, project Notion, current open PRs, actual Godot product files/tests, and the adopted toolchain.

## Authority and supporting package

Current product intent and visual authority:

- Project `AGENTS.md`.
- Notion Human Home `3c41b237-eb1c-8194-8b8e-d88362cafafa`.
- Notion Visual Bible `3c11b237-eb1c-81ae-97f3-dc28a0905304`.
- Notion Asset Library `3c11b237-eb1c-8120-b7db-d48e11756146`.
- Notion Production Handoff `3c11b237-eb1c-81b0-b281-ec54d67c9552`.
- Notion AI Evidence `3c61b237-eb1c-812f-a9f5-f5a116a98370`.

Supporting planning artifacts:

- `docs/superpowers/plans/2026-08-26-first-production-visual-slice.md`.
- `docs/handoffs/2026-08-26-first-production-visual-slice-codex.md`.
- `docs/research/2026-08-26-first-production-visual-slice-benchmark-evidence.md`.

### Implementation-method correction

The supporting v1 plan contains concrete examples such as a child named `VisualStudy` and example test/node shapes. Those are **illustrative planning sketches, not binding runtime interfaces or required node names**.

```text
BINDING
= player outcome
+ approved/protected product semantics
+ evidence ceiling
+ TDD-before-implementation requirement
+ acceptance criteria
+ no-image/no-PR19/no-scope-growth boundaries

NON_BINDING
= exact node names
+ exact scene child hierarchy
+ exact test implementation
+ exact mesh primitive choice
+ exact material numeric values
+ exact internal file split when a safer existing-project pattern is found
```

Codex must choose the smallest implementation that fits the **actual current Godot structure**. Do not mechanically create a `VisualStudy` API merely because the earlier plan used that name.

If the existing structure supports a cleaner proof with different private nodes/resources/tests, use it and explain the choice in the result packet. Any change that alters Core Loop, major UX meaning, final player/pet identity, Art Direction, target-platform product direction, save/schema, social scope, or project-wide shader/asset-pipeline architecture is a `CHANGE_PROPOSAL` back to GPT/user rather than an autonomous implementation choice.

## Player outcome

On the real current game scene, produce one bounded visual proof that reads materially closer to the approved `HANDPAINTED_STORYBOOK_3D_DIORAMA` than the current generic primitive/CG prototype while preserving the rest-first sea-focused experience.

At 540×960 portrait, the result must make it possible to evaluate:

```text
sea/horizon remains primary
→ neutral player + quiet resting companion read together
→ current BoatSpace feels more authored/lived-in
→ a small cluster of existing decor belongs to the same low-noise matte language
→ Normal and Appreciation cameras still feel like the same world
```

This is not final-art production.

## Protected product semantics

Do not change:

- rest-first Core Loop, voyage duration/rewards, or mood meaning;
- Normal vs Appreciation Camera behavior meaning or input isolation;
- BoatSpace shared bob ownership;
- 8 decor slot IDs, six current item IDs, compatibility/state meaning, replace/clear no-loss behavior;
- low-pressure interaction reward isolation;
- `has_care_obligation() == false` pet meaning;
- local-first voyage/rest/pet/decor/album/fishing/soundscape core;
- final player identity, final pet species, four-state time behavior, final UI, save/schema, localization meaning, or social/backend scope;
- PR #19 branch/content.

No combat, failure, competition, chores, farming pressure, ranking, gacha, ads, payment, realtime/public chat, public feed/followers, or runtime generative AI.

## Implementation preference — not a mandate

Preferred first trade-study route remains:

```text
current real 3D scene
+ deliberate but small silhouette/material improvement
+ simple opaque matte-biased Godot material path
+ current light/environment/decor systems
```

Why: it is the lowest-cost route that can test composition, authored broad values, motion survival, and solo-developer repeatability before a texture/model pipeline or custom watercolor shader is justified.

If runtime evidence shows this route cannot express the approved direction, return evidence instead of scaling complexity automatically. Valid next proposals include `LIGHTWEIGHT_SHADER_FOLLOWUP`, `GPT_APPROVED_AUTHORED_ASSET_REQUEST`, or `VISUAL_DIRECTION_REOPEN_REQUIRED`.

## TDD and verification contract

TDD is binding; the exact test implementation is not.

1. Fresh-read the current product and choose a **semantic, minimally coupled acceptance seam** for this slice.
2. Add a focused test/contract that fails on the current baseline for the actual missing production-proof property without asserting subjective beauty or final-art quality.
3. Run and record that RED before implementing the fix.
4. Implement the smallest production change.
5. Run focused GREEN plus all affected existing behavior contracts and scene smokes.
6. Run canonical exact-head PR CI.
7. Observe runtime only where Codex actually has runtime/capture access; otherwise report `NOT_RUN`.

A structural test may verify preserved camera/decor/pet/scene contracts and a stable marker/resource chosen by Codex, but must not invent a new public runtime API solely to make the test easy.

## Evidence ceiling

Technical implementation or CI does not prove subjective visual quality.

Until direct evidence exists, keep:

```text
MOBILE_30S_VISUAL_REVIEW = NOT_RUN
MOBILE_5M_VISUAL_REVIEW = NOT_RUN
HUMAN_STYLE_APPROVAL = NOT_RUN
REAL_DEVICE_TOUCH_QA = NOT_RUN
FINAL_AVATAR_ART = NOT_INTEGRATED
FINAL_PET_ART = NOT_INTEGRATED
FINAL_DECOR_ART = NOT_INTEGRATED
FINAL_BOAT_SEA_ART = NOT_INTEGRATED
```

The current 540×960 portrait viewport is the **primary visual proof target** because it is the actual runtime profile in `project.godot`. Separately, the r5.4 project contract requires responsive semantic-parity coverage for `pc_standard`, `pc_wide_or_ultrawide`, and `mobile_landscape`; Codex must run the representative technical probes that are feasible in its environment and report any missing profile as `NOT_RUN/PARTIAL`, not erase the requirement. These profiles are delivery/semantic-parity requirements and do not by themselves redefine the final store/release platform set. `ko/en/ja/zh-*` readiness and the required Chinese locale variant declaration remain unresolved project-wide requirements; this visual-only slice must not falsely close them or add untranslated user-facing strings.

## Required result packet

```yaml
codex_result:
  project: MY_LITTLE_BOAT
  baseline_main:
  implementation_branch:
  final_head:
  implementation_approach_and_why:
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
  change_proposals: []
  remaining_risks: []
  toolchain_observed:
  rollback:
  status: READY_FOR_GPT_REVIEW | BLOCKED | WAITING_GPT_VISUAL
```

Stop at `READY_FOR_GPT_REVIEW`. GPT owns final review, GitHub/Notion canonical reflection, merge/postmerge readback, and completion-ceiling judgment.
