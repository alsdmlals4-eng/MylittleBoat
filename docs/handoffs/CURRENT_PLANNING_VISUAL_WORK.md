# Historical Planning & Visual Work Closeout

> The approved noncoding image-production phase and its Codex integration are complete on `main`. This file preserves the pre-integration planning receipt; continue current product work through `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`.

## Current state

```yaml
project: MY_LITTLE_BOAT
mode: GPT_WORK_IMAGE_PRODUCTION_CLOSEOUT
current_owner: CODEX_GODOT_PRODUCT_IMPLEMENTATION_OWNER
policy: CONSUMER_FIRST_ASSET
status: HISTORICAL_SUPERSEDED_BY_CODEX_IMAGE_INTEGRATION
current_work_router: docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md
handoff_packet: docs/handoffs/2026-08-26-gpt-work-image-production-handoff.md
concurrent_pr_19: READ_ONLY_NO_ABSORPTION
codex_product_build: IMAGE_INTEGRATION_COMPLETE_MERGED_MAIN
```

The four required runtime files have user approval, Asset Library readback, and durable binary locator PASS. GPT Work made no Godot Scene, Resource, or GDScript product change.

## Active image queue

```text
IMG-01 / P1 — Pet Cushion Runtime Surface Set
- cushion_stripe.png
- cushion_moon.png
- cushion_floral.png

IMG-02 / P1 — Default Postcard Memory Face
- postcard_boat_bright.png
```

Required count before Codex: **4 implementation-ready runtime image files**. This requirement is met.

Dawn/Sunset postcard source compositions remain P2 reuse candidates. They are not active required files and must not trigger a new postcard-variant system.

## Source-of-truth package

- GPT Work current router: `docs/handoffs/CURRENT_GPT_WORK.md`
- detailed Work handoff: `docs/handoffs/2026-08-26-gpt-work-image-production-handoff.md`
- image Goal Queue: `docs/visual/2026-08-26-remaining-image-goals.md`
- consumer manifest: `docs/visual/2026-08-26-game-image-consumer-manifest.md`
- future Codex integration Goals: `docs/handoffs/2026-08-26-image-codex-integration-goals.md`
- downstream Codex router: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`

Notion human canon:

- Home: `3c41b237-eb1c-8194-8b8e-d88362cafafa`
- Game Image Blueprint: `3c81b237-eb1c-81dd-bc85-d0eb927671c8`
- Visual Production Checklist: `3c81b237-eb1c-810c-b3f8-fce023a453cb`
- Visual Bible: `3c11b237-eb1c-81ae-97f3-dc28a0905304`
- Asset Library: `3c11b237-eb1c-8120-b7db-d48e11756146`

## Work-phase completion gate

```text
IMG_01 = 3 IMPLEMENTATION_READY files
IMG_01_NOTION_READBACK = PASS
IMG_02 = 1 IMPLEMENTATION_READY file
IMG_02_NOTION_READBACK = PASS
DURABLE_BINARY_LOCATORS = PASS
CODEX_ROUTER = CODEX_IMAGE_INTEGRATION_COMPLETE_MERGED_MAIN
GODOT_PRODUCT_CHANGES_BY_GPT_WORK = 0
```

The gate is satisfied. Codex must still perform import, wiring, and runtime proof; GPT Work must not do those tasks.

Historical pre-integration boundary retained for provenance:

- not start Godot product implementation;
- not claim runtime verification;
- not generate deferred image categories merely because they are possible;
- keep PR #19 isolated.

## Evidence ceiling at Codex handoff

```text
GOAL_QUEUE = USER_APPROVED
ACTIVE_P1_REQUIRED_FILES = 4
IMPLEMENTATION_READY_IMAGE_ASSETS = 4
IMPLEMENTED_IMAGE_ASSETS = HISTORICAL_PRE_INTEGRATION_VALUE_0
RUNTIME_VERIFIED_IMAGE_ASSETS = HISTORICAL_PRE_INTEGRATION_VALUE_0
GPT_WORK_IMAGE_PRODUCTION = COMPLETE
CODEX_IMAGE_INTEGRATION = HISTORICAL_READY_TO_START
GODOT_RUNTIME = HISTORICAL_NOT_RUN
```
