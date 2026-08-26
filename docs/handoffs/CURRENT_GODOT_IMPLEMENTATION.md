# Current Godot Product Implementation

> **PAUSED DOWNSTREAM HANDOFF.** Start with `docs/handoffs/CURRENT_PLANNING_VISUAL_WORK.md`.

## Current state

```yaml
project: MY_LITTLE_BOAT
mode: CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF
status: PAUSED_UNTIL_ACTIVE_IMAGE_GOALS_IMPLEMENTATION_READY
current_work_router: docs/handoffs/CURRENT_PLANNING_VISUAL_WORK.md
image_goal_source: docs/visual/2026-08-26-remaining-image-goals.md
codex_image_goal_source: docs/handoffs/2026-08-26-image-codex-integration-goals.md
image_asset_policy: CONSUMER_FIRST_ASSET
implementation_baseline: RESOLVE_CURRENT_COMPLETED_MAIN_AT_CODEX_START
implementation_owner_after_unpause: CODEX_GODOT_PRODUCT_IMPLEMENTATION_OWNER
final_review_owner: GPT_FINAL_IMPLEMENTATION_REVIEW
concurrent_pr_19: READ_ONLY_NO_ABSORPTION
image_generation_by_codex: FORBIDDEN
```

## Binding pipeline

The latest user instruction requires image planning/production to finish **before** Codex product integration for the active image goals:

```text
Remaining Image Goals
→ user goal approval
→ GPT image generation/editing
→ GPT review
→ user image approval
→ Notion asset registration
→ IMPLEMENTATION_READY
→ Codex Integration Goals
→ Godot import/wiring
→ runtime screenshots/play verification
→ GPT final review
```

Do not ask Codex to create/edit images. Do not start CODEX-IMG-01 or CODEX-IMG-02 while their image files are below `IMPLEMENTATION_READY`.

## Active image integration goals waiting downstream

### CODEX-IMG-01 — Pet Cushion Runtime Surface Integration

Waits for:

```text
res://assets/images/decor/pet_cushion/cushion_stripe.png
res://assets/images/decor/pet_cushion/cushion_moon.png
res://assets/images/decor/pet_cushion/cushion_floral.png
```

These are three cosmetic visual variants of the stable `pet_cushion` meaning. Implementation must not create stats, rarity, cost, gacha, care obligation or a separate progression system.

### CODEX-IMG-02 — Postcard Memory Face Integration

Waits for:

```text
res://assets/images/decor/postcard/postcard_dawn.png
res://assets/images/decor/postcard/postcard_boat_bright.png
res://assets/images/decor/postcard/postcard_boat_sunset.png
```

These are cosmetic visual variants of the stable `postcard` meaning. They must remain quiet decor/memory traces.

Full implementation tasks/acceptance are in `docs/handoffs/2026-08-26-image-codex-integration-goals.md`.

## Approved customization semantics waiting downstream

```text
CHARACTER_SELECTION_SET
= SOFT_HOODED_LAYER
+ SHORT_CAPE_SAILOR_LAYER_RHYTHM
+ LOOSE_KNIT_LONG_HAIR_MASS

PET_SELECTION_SET
= CAT
+ RABBIT
+ DOG
+ OTTER_LIKE

PET_CUSHION_CUSTOMIZATION
= THREE_APPROVED_VISUAL_VARIANTS / COSMETIC_ONLY
```

The exact Godot variant-state representation remains Codex's implementation choice after fresh-read. Preserve existing `pet_cushion` and `postcard` base semantics and current decor compatibility.

## Do not invent image consumers for deferred categories

- Main Menu / Album authored backgrounds are not required; current ColorRect/live-world routes remain valid.
- character/pet selection thumbnails should derive from actual 3D previews.
- exact UV-specific character/pet/boat texture sheets stay blocked by production geometry.
- sky/sea bitmap assets are conditional on actual material technique; prefer simple color/light/procedural methods.
- UI icons remain deferred until a binding runtime need exists.
- release/store art is P3 and not this implementation slice.

## Codex unpause gate

Both active image goals must be ready unless the user explicitly narrows the batch:

```text
IMG_01_FILES = IMPLEMENTATION_READY
IMG_01_NOTION_READBACK = PASS
IMG_02_FILES = IMPLEMENTATION_READY
IMG_02_NOTION_READBACK = PASS
EXACT_ASSET_PATHS = FIXED
CODEX_INTEGRATION_GOALS = CURRENT
PR_19 = READ_ONLY_NO_ABSORPTION
```

At Codex start, fresh-read current completed main, Notion, actual Godot files/tests, current open PRs, and toolchain. Use semantic TDD and runtime proof. Do not treat historical exact Node/test sketches as binding implementation internals.

## Protected downstream scope

- rest-first Core Loop, voyage duration/rewards, and mood meaning;
- Normal vs Appreciation Camera semantics and input isolation;
- BoatSpace shared bob ownership;
- 8 decor slot IDs and existing six base item meanings/compatibility;
- low-pressure interaction reward isolation;
- care-obligation-free pet semantics;
- cosmetic variants must not alter rewards, timer, progression pressure, social eligibility or care obligation;
- local-first core;
- PR #19 remains an independent workstream.

## Evidence ceiling while paused

```text
IMAGE_GOAL_QUEUE = READY_FOR_USER_REVIEW
IMG_01 = NEEDS_REVISION
IMG_02 = NEEDS_REVISION
CODEX_IMG_01 = NOT_RUN
CODEX_IMG_02 = NOT_RUN
IMPLEMENTED_IMAGE_ASSETS = 0
RUNTIME_VERIFIED_IMAGE_ASSETS = 0
HANDPAINTED_3D_RUNTIME_SLICE = NOT_RUN
REAL_DEVICE_TOUCH_QA = NOT_RUN
```
