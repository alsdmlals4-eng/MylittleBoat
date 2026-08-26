# Current Godot Product Implementation

> **PAUSED DOWNSTREAM HANDOFF.** Start with `docs/handoffs/CURRENT_PLANNING_VISUAL_WORK.md`.

## Current state

```yaml
project: MY_LITTLE_BOAT
mode: CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF
status: PAUSED_PENDING_CONSUMER_CONTRACTS
current_work_router: docs/handoffs/CURRENT_PLANNING_VISUAL_WORK.md
image_asset_policy: CONSUMER_FIRST_ASSET
implementation_baseline: RESOLVE_CURRENT_COMPLETED_MAIN_AT_CODEX_START
implementation_owner_after_unpause: CODEX_GODOT_PRODUCT_IMPLEMENTATION_OWNER
final_review_owner: GPT_FINAL_IMPLEMENTATION_REVIEW
concurrent_pr_19: READ_ONLY_NO_ABSORPTION
image_generation_by_codex: FORBIDDEN
```

The user corrected the visual pipeline: do not build explanatory image sheets as deliverables. Produce only image files with a concrete game/runtime consumer.

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
= APPROVED_AT_FEATURE_MEANING_LEVEL
```

These are cosmetic/personalization choices only. They must not create class/stat/rarity/gacha/monetization/progression differences.

## Image-consumer rule

Before an image asset is generated, planning must define:

```text
asset_path
consumer
runtime_role
spec
fallback
validation
```

An image is not DONE until the intended Godot consumer loads the exact file and runtime evidence shows it in use.

Current main has no production image consumer yet:

```text
assets/images = README only
.png references = 0 observed
albedo_texture references = 0 observed
Main Menu / Album = ColorRect backgrounds
Boat / Avatar / Pet = primitive mesh + color-only material
Decor = primitive mesh + albedo_color
```

## First candidate consumer batches

### Pet cushion textures

Target meaning:
- `item_id = pet_cushion`
- intended material property = `StandardMaterial3D.albedo_texture`
- runtime role = player-visible pet-cushion appearance customization

### Postcard textures

Target meaning:
- `item_id = postcard`
- intended material property = `StandardMaterial3D.albedo_texture`
- runtime role = authored visible postcard/memory artwork

These are candidates, not yet implemented consumers.

## Deferred image categories

Do not create until the corresponding consumer exists:

- character/pet albedo textures → production mesh + UV required;
- boat/general decor textures → production mesh + UV required unless a stable primitive consumer is intentionally retained;
- sky/time-of-day bitmaps → only if Environment adopts panorama/sky textures;
- sea normal/noise maps → only if the sea material/shader samples them;
- UI icons → only after TextureButton/TextureRect/theme-icon consumers are approved;
- main-menu/album backgrounds → current ColorRect means no image asset is needed.

`Image C / Representative Visual GDD` is cancelled as a required production image.

## Unpause gate

Godot product implementation may resume for a consumer-first asset slice when all are true for at least one asset batch:

```text
ASSET_CONSUMER_CONTRACT = APPROVED
ASSET_PATH = FIXED
CONSUMER_TARGET = FIXED
IMPORT_SPEC = FIXED
RUNTIME_ROLE = FIXED
FALLBACK_BEHAVIOR = FIXED
TDD/VALIDATION_PLAN = READY
PR_19 = READ_ONLY_NO_ABSORPTION
```

Then Codex may implement the smallest safe consumer wiring. After the consumer exists and is validated, GPT image generation may produce the exact asset for that consumer, followed by runtime integration verification.

## Protected downstream scope

- rest-first Core Loop, voyage duration/rewards, and mood meaning;
- Normal vs Appreciation Camera semantics and input isolation;
- BoatSpace shared bob ownership;
- 8 decor slot IDs and six current item IDs/compatibility/state meaning;
- low-pressure interaction reward isolation;
- care-obligation-free pet semantics across selectable species;
- cosmetic selection must not alter rewards, timer, progression pressure, social eligibility, or care obligation;
- local-first core;
- PR #19 remains an independent workstream unless explicitly reopened.

## Evidence ceiling while paused

```text
CONSUMER_FIRST_ASSET_POLICY = ACTIVE
REFERENCE_IMAGES = APPROVED_BUT_NOT_RUNTIME_ASSETS
CURRENT_RUNTIME_IMAGE_CONSUMERS = 0
PET_CUSHION_TEXTURES = CONSUMER_CONTRACT_CANDIDATE
POSTCARD_TEXTURES = CONSUMER_CONTRACT_CANDIDATE
NEW_GAME_IMAGE_GENERATION = PAUSED
PRODUCT_TDD_RED_GREEN = NOT_RUN
HANDPAINTED_3D_RUNTIME_SLICE = NOT_RUN
REAL_DEVICE_TOUCH_QA = NOT_RUN
```
