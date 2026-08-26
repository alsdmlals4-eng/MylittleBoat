# Current GPT Work

> Stable session handoff for the next GPT Work run. Re-resolve current completed `main` and Project Notion at start; this file is a router, not a second product canon.

```yaml
project: MY_LITTLE_BOAT
mode: GPT_WORK_IMAGE_PRODUCTION
status: READY_FOR_GPT_WORK_IMAGE_PRODUCTION
current_owner: GPT_WORK_NONCODING_VISUAL_OWNER
handoff_packet: docs/handoffs/2026-08-26-gpt-work-image-production-handoff.md
image_goal_queue: docs/visual/2026-08-26-remaining-image-goals.md
consumer_manifest: docs/visual/2026-08-26-game-image-consumer-manifest.md
codex_integration_goals: docs/handoffs/2026-08-26-image-codex-integration-goals.md
codex_product_build: HOLD_UNTIL_ACTIVE_IMAGES_IMPLEMENTATION_READY
concurrent_pr_19: READ_ONLY_NO_ABSORPTION
```

## First action

Fresh-read:

1. project `AGENTS.md`;
2. current completed `main`;
3. this router;
4. `docs/handoffs/2026-08-26-gpt-work-image-production-handoff.md`;
5. Remaining Image Goals + consumer manifest;
6. Notion Home / Game Image Blueprint / Visual Production Checklist / Visual Bible / Asset Library;
7. open PRs and current image evidence.

Then execute **IMG-01 Pet Cushion Runtime Surface Set** only.

## Current active production queue

```text
IMG-01 / P1
- cushion_stripe.png
- cushion_moon.png
- cushion_floral.png

then

IMG-02 / P1
- postcard_boat_bright.png
```

The three cushion files and one Bright Boat postcard file are the only active required image files before Codex unless the user explicitly changes scope.

Dawn/Sunset postcard sources are P2 reuse candidates, not active required files.

## Role boundary

GPT Work owns:

- fresh-read/reconciliation;
- image generation/editing;
- image quality review;
- user approval loop;
- Notion Asset Library registration/readback;
- image-production documentation and handoff preparation;
- final transition to Codex readiness after image closeout.

GPT Work does **not** own:

- Godot Scene/Resource/GDScript product implementation;
- runtime wiring/import testing;
- Codex image creation/editing;
- PR #19 changes;
- speculative extra image production.

## Completion gate for this Work phase

```text
IMG_01 = 3 IMPLEMENTATION_READY files + Notion readback PASS
IMG_02 = 1 IMPLEMENTATION_READY file + Notion readback PASS
DURABLE_BINARY_LOCATORS = PASS
DEFERRED_SCOPE = UNCHANGED
CURRENT_GODOT_IMPLEMENTATION = READY_FOR_CODEX_IMAGE_INTEGRATION
GODOT_PRODUCT_CHANGES_BY_GPT_WORK = 0
```

Until then, do not claim the image phase complete and do not start Codex integration.
