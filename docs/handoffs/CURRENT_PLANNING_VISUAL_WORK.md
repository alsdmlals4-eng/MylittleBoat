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

Latest user pipeline is binding:

```text
current canon/runtime audit
→ existing image inventory + reuse check
→ consumer gap analysis
→ Remaining Image Goals
→ user review/approval
→ GPT image production
→ Notion registration
→ Codex Integration Goals
→ Codex implementation
→ runtime screenshots/play verification
```

Do not ask Codex to create images. Do not require Codex to create an image consumer before GPT image production when the consumer contract can already be defined safely from approved product semantics.

## Current authority/support

Human canon:
- Notion Human Home: `3c41b237-eb1c-8194-8b8e-d88362cafafa`
- Notion Visual Bible: `3c11b237-eb1c-81ae-97f3-dc28a0905304`
- Notion Asset Library: `3c11b237-eb1c-8120-b7db-d48e11756146`
- Notion Visual Production Checklist: `3c81b237-eb1c-810c-b3f8-fce023a453cb`
- Notion Game Image Blueprint: `3c81b237-eb1c-81dd-bc85-d0eb927671c8`

Repository planning:
- remaining image goal queue: `docs/visual/2026-08-26-remaining-image-goals.md`
- consumer audit/manifest: `docs/visual/2026-08-26-game-image-consumer-manifest.md`
- Codex integration goal queue: `docs/handoffs/2026-08-26-image-codex-integration-goals.md`
- downstream Godot router: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`

## Current image state

```text
APPROVED_REFERENCE_VISUALS = 4
APPROVED_MOTIF_SOURCE_IMAGES = 6
IMPLEMENTATION_READY_IMAGE_ASSETS = 0
IMPLEMENTED_IMAGE_ASSETS = 0
RUNTIME_VERIFIED_IMAGE_ASSETS = 0
P0_AUTHORED_IMAGE_GOALS = 0
ACTIVE_P1_IMAGE_GOALS = 2
```

Approved references retained but not runtime assets:
- Visual Proof 01
- Visual Proof 02
- Image A — Player + Pet Customization Board
- Image B — Boat / Sea / Four-Time Atmosphere Board

The six approved cushion/postcard generated images preserve approved motif/color/composition decisions, but their current presentation-render form is not a production albedo/face asset. They are `NEEDS_REVISION` for runtime use.

## Active Image Goal Queue

### IMG-01 — Pet Cushion Runtime Surface Set · P1

Produce exactly three flat surface files from the approved motifs:

```text
cushion_stripe.png
cushion_moon.png
cushion_floral.png
```

They must not contain rendered cushion geometry, rim, drop shadow, tuft depth or baked directional lighting.

### IMG-02 — Postcard Memory Face Set · P1

Produce exactly three normalized 4:3 postcard face files from the approved compositions:

```text
postcard_dawn.png
postcard_boat_bright.png
postcard_boat_sunset.png
```

They must not contain external presentation canvas/drop shadow around the intended card face.

## Explicit non-goals / deferred

Do not create now:
- Main Menu static background — current ColorRect is sufficient; a static image would invent a new consumer and may diverge from the actual 3D game.
- Album authored screenshots — eventual photos should be runtime captures.
- fake 2D character/pet portraits — selection thumbnails should derive from the real 3D assets.
- exact character/pet/boat UV sheets — blocked until production geometry/consumer exists.
- sky/sea bitmaps — conditional on actual material/shader technique; prefer simple color/light/procedural route.
- UI icon pack — current text controls work; only reopen after a binding icon consumer/polish need.
- release/store art — P3 and platform/branding dependent.

## After user approves this queue

Proceed in order:

```text
IMG-01 text contract → generate/edit → review → user approval → Notion registration
IMG-02 text contract → generate/edit → review → user approval → Notion registration
then update downstream handoff to READY_FOR_CODEX_IMAGE_INTEGRATION
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
