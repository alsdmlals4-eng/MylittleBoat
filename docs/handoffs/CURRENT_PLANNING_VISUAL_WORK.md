# Current Planning & Visual Work

> Stable router for the current `MY_LITTLE_BOAT` noncoding visual phase. The active executor is GPT Work. Start with `docs/handoffs/CURRENT_GPT_WORK.md`.

## Current state

```yaml
project: MY_LITTLE_BOAT
mode: GPT_WORK_IMAGE_PRODUCTION
current_owner: GPT_WORK_NONCODING_VISUAL_OWNER
policy: CONSUMER_FIRST_ASSET
status: HANDOFF_READY_FOR_GPT_WORK
current_work_router: docs/handoffs/CURRENT_GPT_WORK.md
handoff_packet: docs/handoffs/2026-08-26-gpt-work-image-production-handoff.md
concurrent_pr_19: READ_ONLY_NO_ABSORPTION
codex_product_build: HOLD_UNTIL_ACTIVE_IMAGES_IMPLEMENTATION_READY
```

The Remaining Image Goal Queue has been reviewed by the user and is approved for execution in GPT Work.

## Active image queue

```text
IMG-01 / P1 — Pet Cushion Runtime Surface Set
- cushion_stripe.png
- cushion_moon.png
- cushion_floral.png

IMG-02 / P1 — Default Postcard Memory Face
- postcard_boat_bright.png
```

Required count before Codex: **4 implementation-ready runtime image files**.

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
CODEX_ROUTER = READY_FOR_CODEX_IMAGE_INTEGRATION
GODOT_PRODUCT_CHANGES_BY_GPT_WORK = 0
```

Until that gate is satisfied:

- do not start Godot product implementation;
- do not claim runtime verification;
- do not generate deferred image categories merely because they are possible;
- keep PR #19 isolated.

## Evidence ceiling at handoff

```text
GOAL_QUEUE = USER_APPROVED
ACTIVE_P1_REQUIRED_FILES = 4
IMPLEMENTATION_READY_IMAGE_ASSETS = 0
IMPLEMENTED_IMAGE_ASSETS = 0
RUNTIME_VERIFIED_IMAGE_ASSETS = 0
GPT_WORK_IMAGE_PRODUCTION = NOT_RUN
CODEX_IMAGE_INTEGRATION = NOT_RUN
GODOT_RUNTIME = NOT_RUN
```
