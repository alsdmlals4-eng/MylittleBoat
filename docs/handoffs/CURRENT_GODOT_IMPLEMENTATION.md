# Current Godot Product Implementation

> **PAUSED DOWNSTREAM HANDOFF.** The active worker is GPT Work. Start current project continuation with `docs/handoffs/CURRENT_GPT_WORK.md`; do not begin Godot product implementation yet.

## Current state

```yaml
project: MY_LITTLE_BOAT
mode: CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF
status: PAUSED_DURING_GPT_WORK_IMAGE_PRODUCTION
current_work_router: docs/handoffs/CURRENT_GPT_WORK.md
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

```text
USER_APPROVED_IMAGE_GOALS
→ GPT Work image generation/editing
→ GPT Work runtime-asset review
→ user asset approval
→ Notion final asset registration + durable binary locator
→ IMPLEMENTATION_READY
→ GPT Work changes this router to READY_FOR_CODEX_IMAGE_INTEGRATION
→ CODEX-IMG-01 / CODEX-IMG-02
→ Godot import/wiring/runtime proof
→ GPT final implementation review
```

Codex does not create/edit images and does not start CODEX-IMG-01/02 before their required files are `IMPLEMENTATION_READY` with Notion readback.

## Active image integration goals waiting downstream

### CODEX-IMG-01 — Pet Cushion Runtime Surface Integration

Waits for exactly:

```text
res://assets/images/decor/pet_cushion/cushion_stripe.png
res://assets/images/decor/pet_cushion/cushion_moon.png
res://assets/images/decor/pet_cushion/cushion_floral.png
```

Three cosmetic visual variants of the existing `pet_cushion` meaning. No stat/rarity/cost/gacha/care/progression semantics.

### CODEX-IMG-02 — Default Postcard Memory Face Integration

Waits for exactly:

```text
res://assets/images/decor/postcard/postcard_boat_bright.png
```

P1 integrates one default visual face only. Dawn/Sunset source compositions are P2 reuse candidates. Do not create a postcard variant selector/state merely to use them.

Full tasks/acceptance: `docs/handoffs/2026-08-26-image-codex-integration-goals.md`.

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

POSTCARD_P1
= ONE_APPROVED_DEFAULT_FACE / NO_VARIANT_SYSTEM
```

Exact Godot implementation details remain Codex choices after fresh-read. Preserve existing `pet_cushion` and `postcard` base meanings and compatibility.

## Deferred consumers

Do not invent consumers to absorb extra art:

- Main Menu/Album authored backgrounds are not required now.
- character/pet selection thumbnails derive from actual 3D previews.
- exact UV-specific character/pet/boat texture sheets are blocked by production geometry.
- sky/sea bitmap assets are conditional; prefer simple color/light/procedural route.
- UI icons are deferred until a binding consumer/readability need exists.
- app icon/store/marketing is P3 after release targets/branding lock.

## Codex unpause gate

```text
IMG_01_3_FILES = IMPLEMENTATION_READY
IMG_01_NOTION_READBACK = PASS
IMG_02_1_FILE = IMPLEMENTATION_READY
IMG_02_NOTION_READBACK = PASS
DURABLE_BINARY_LOCATORS = PASS
EXACT_ASSET_PATHS = FIXED
CODEX_INTEGRATION_GOALS = CURRENT
PR_19 = READ_ONLY_NO_ABSORPTION
```

At Codex start, fresh-read current completed main, Project Notion, actual Godot files/tests, open PRs and toolchain. Use semantic TDD and runtime proof. GPT Work must stop before making Scene/Resource/GDScript product changes.

## Protected downstream scope

- rest-first Core Loop, voyage duration/rewards and mood meaning;
- Normal/Appreciation Camera semantics and input isolation;
- BoatSpace shared bob ownership;
- 8 decor slot IDs and existing six base item meanings/compatibility;
- low-pressure interaction reward isolation;
- care-obligation-free pet semantics;
- cosmetic visuals must not alter rewards, timer, progression pressure, social eligibility or care obligation;
- local-first core;
- PR #19 remains independent.

## Evidence ceiling while paused

```text
IMAGE_GOAL_QUEUE = USER_APPROVED
GPT_WORK_IMAGE_PRODUCTION = NEXT / NOT_RUN
IMG_01_FINAL_FILES = 0 / 3 IMPLEMENTATION_READY
IMG_02_FINAL_FILES = 0 / 1 IMPLEMENTATION_READY
CODEX_IMG_01 = NOT_RUN
CODEX_IMG_02 = NOT_RUN
IMPLEMENTED_IMAGE_ASSETS = 0
RUNTIME_VERIFIED_IMAGE_ASSETS = 0
HANDPAINTED_3D_RUNTIME_SLICE = NOT_RUN
REAL_DEVICE_TOUCH_QA = NOT_RUN
```
