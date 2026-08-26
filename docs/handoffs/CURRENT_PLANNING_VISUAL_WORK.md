# Current Planning & Visual Work

> Stable current-work router for `MY_LITTLE_BOAT` game-consumable image production.

## Current task

```yaml
project: MY_LITTLE_BOAT
mode: GPT_REMAINING_IMAGE_GOALS
current_owner: GPT_NONCODING_PLANNING_VISUAL_OWNER
policy: CONSUMER_FIRST_ASSET
current_goal: REVIEW_AND_COMPLETE_ACTIVE_IMAGE_GOALS_BEFORE_CODEX
status: GOAL_QUEUE_READY_FOR_USER_REVIEW
concurrent_pr_19: READ_ONLY_NO_ABSORPTION
codex_product_build: HOLD_UNTIL_ACTIVE_IMAGES_IMPLEMENTATION_READY
```

Latest binding pipeline:

```text
current canon/runtime audit
→ existing image inventory + reuse check
→ consumer gap analysis
→ Remaining Image Goals
→ user goal approval
→ GPT image production/review
→ user asset approval
→ Notion registration
→ Codex Integration Goals
→ Codex implementation
→ runtime screenshots/play verification
```

Codex does not create/edit images and must not start the active image integrations before the required files are `IMPLEMENTATION_READY`.

## Current authority/support

Human canon:
- Notion Human Home: `3c41b237-eb1c-8194-8b8e-d88362cafafa`
- Notion Visual Bible: `3c11b237-eb1c-81ae-97f3-dc28a0905304`
- Notion Asset Library: `3c11b237-eb1c-8120-b7db-d48e11756146`
- Notion Visual Production Checklist: `3c81b237-eb1c-810c-b3f8-fce023a453cb`
- Notion Game Image Blueprint: `3c81b237-eb1c-81dd-bc85-d0eb927671c8`

Repository planning:
- current Goal Queue: `docs/visual/2026-08-26-remaining-image-goals.md`
- consumer manifest: `docs/visual/2026-08-26-game-image-consumer-manifest.md`
- Codex integration goals: `docs/handoffs/2026-08-26-image-codex-integration-goals.md`
- downstream router: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`

## Current image state

```text
APPROVED_REFERENCE_VISUALS = 4
APPROVED_SOURCE_IMAGES = 6
ACTIVE_P1_IMAGE_GOALS = 2
ACTIVE_P1_REQUIRED_FILES = 4
P0_AUTHORED_IMAGE_GOALS = 0
IMPLEMENTATION_READY_IMAGE_ASSETS = 0
IMPLEMENTED_IMAGE_ASSETS = 0
RUNTIME_VERIFIED_IMAGE_ASSETS = 0
```

Reference-only approved visuals:
- Visual Proof 01
- Visual Proof 02
- Image A — Player + Pet Customization Board
- Image B — Boat / Sea / Four-Time Atmosphere Board

Six generated source images retain user-approved motif/composition decisions. They are not direct runtime files: 3 cushion sources and the Bright Boat postcard source are `REUSE_WITH_EDIT`; Dawn/Sunset postcard sources are P2 reuse candidates until a real multi-postcard consumer exists.

## Active Image Goal Queue

### IMG-01 — Pet Cushion Runtime Surface Set · P1

Required flat files:

```text
cushion_stripe.png
cushion_moon.png
cushion_floral.png
```

Must be 1024×1024 opaque sRGB low-frequency/repeat-friendly surface art with no rendered cushion form, rim, drop shadow, tuft depth or directional baked lighting.

### IMG-02 — Default Postcard Memory Face · P1

Required file:

```text
postcard_boat_bright.png
```

Must be one normalized 1024×768 4:3 postcard face with no external presentation canvas/drop shadow. No new postcard variant selector/state is part of P1.

Dawn/Sunset postcard compositions remain approved P2 reuse candidates and are not active required files.

## Explicit deferred / no-goal categories

- Main Menu static background — no required authored image; current ColorRect is valid and a static image would invent a consumer.
- Album authored screenshots — eventual photos should be runtime captures.
- fake 2D character/pet portraits — derive selection thumbnails from actual 3D assets.
- exact character/pet/boat UV sheets — blocked by production geometry/consumer.
- sky/sea bitmaps — conditional on real material/shader technique; prefer simple color/light/procedural route.
- UI icon pack — current text controls are functional; reopen only for a binding consumer/readability need.
- application icon/store/marketing — real eventual P3 requirement, held until release targets/brand package are explicit.

## After user approves this queue

```text
IMG-01 → generate/edit → GPT review → user asset approval → individual Asset Library registration
IMG-02 → generate/edit → GPT review → user asset approval → individual Asset Library registration
→ both active Goals IMPLEMENTATION_READY
→ CODEX-IMG-01 → CODEX-IMG-02
→ 540×960 runtime proof
```

## Evidence ceiling

```text
GOAL_QUEUE = READY_FOR_USER_REVIEW
NEW_IMAGE_GENERATION_FOR_GOALS = NOT_RUN
CODEX_IMAGE_INTEGRATION = NOT_RUN
GODOT_RUNTIME = NOT_RUN
MOBILE_30S_REVIEW = NOT_RUN
MOBILE_5M_REVIEW = NOT_RUN
```
