# Current Planning & Visual Work

> Stable current-work router for `MY_LITTLE_BOAT` image production.

## Current task

```yaml
project: MY_LITTLE_BOAT
mode: GPT_GAME_IMAGE_CONSUMER_PLANNING
current_goal: DEFINE_REAL_GAME_IMAGE_CONSUMERS_BEFORE_GENERATION
current_owner: GPT_NONCODING_PLANNING_VISUAL_OWNER
concurrent_pr_19: READ_ONLY_NO_ABSORPTION
policy: CONSUMER_FIRST_ASSET
image_generation: PAUSED_UNTIL_CONSUMER_READY
status: CONSUMER_MANIFEST_IN_PROGRESS
```

The user explicitly corrected the image-production rule:

> Create images only when they have a real game consumer. Do not create explanatory sheets as deliverables.

## Authority

Human/product authority:
- Notion Human Home: `3c41b237-eb1c-8194-8b8e-d88362cafafa`
- Notion Visual Bible: `3c11b237-eb1c-81ae-97f3-dc28a0905304`
- Notion Asset Library: `3c11b237-eb1c-8120-b7db-d48e11756146`
- Notion Visual Production Checklist: `3c81b237-eb1c-810c-b3f8-fce023a453cb`

Repository authority/support:
- consumer manifest: `docs/visual/2026-08-26-game-image-consumer-manifest.md`
- approved Image A customization decision: `docs/visual/2026-08-26-image-a-customization-decision.md`
- paused Godot handoff: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`

## Reference images already approved

The following are preserved as planning references, but are **not counted as runtime image assets**:

- Visual Proof 01
- Visual Proof 02
- Image A — Player + Pet Customization Board
- Image B — Boat / Sea / Four-Time Atmosphere Board

`Image C / Representative Visual GDD` is cancelled as a required image deliverable.

## Current-main runtime audit

Current main currently has no production image consumer:

```text
assets/images = README only
.png references = 0 observed
albedo_texture references = 0 observed
Main Menu = ColorRect background
Album = ColorRect background
Boat/Avatar/Pet = primitive mesh + color-only StandardMaterial3D
Decor = primitive mesh + albedo_color construction
```

Therefore:

```text
CURRENT_RUNTIME_IMAGE_CONSUMERS = 0
```

Do not generate another gameplay image until a concrete consumer contract is ready.

## Consumer-first rule

Every generated game image must have all six before generation:

```text
asset_path
consumer
runtime_role
spec
fallback
validation
```

A generated image is DONE only after the intended Godot consumer actually loads it and it is visible in runtime evidence.

## First candidate consumers

### Pet cushion textures

```text
item_id = pet_cushion
intended consumer = Boat Decoration pet cushion material
intended property = StandardMaterial3D.albedo_texture
runtime role = player-visible cushion appearance customization
```

This is the strongest first candidate because the user already approved pet cushion customization and the stable item id already exists.

### Postcard textures

```text
item_id = postcard
intended consumer = Boat Decoration postcard material
intended property = StandardMaterial3D.albedo_texture
runtime role = authored personal/memory image on placed postcard decor
```

This is also strong because the item id already exists and the visual surface is naturally image-driven.

## Deferred until consumer exists

Do not generate these yet:

- character/pet albedo textures — blocked by production mesh + UV;
- boat/general decor textures — blocked by production mesh + UV unless current primitives are deliberately retained;
- sky/time-of-day bitmaps — only if Environment adopts a panorama/sky texture consumer;
- sea normal/noise maps — only if the sea material/shader actually samples them;
- UI icons — only after a TextureButton/TextureRect/theme-icon consumer is approved;
- main-menu/album backgrounds — current screens use ColorRect, so no image is needed now.

## Runtime-generated images

- Album/voyage photos should come from actual runtime capture, not authored concept art.
- Character/pet selection thumbnails should preferably derive from the real production 3D assets so the thumbnail matches what the player receives.

## Current next work

```text
1. Freeze explanatory-image production.
2. Complete the game image consumer manifest.
3. Promote only one small consumer batch to READY_TO_GENERATE.
4. Recommended first batch: pet cushion textures + postcard textures.
5. Define exact file path, size, alpha/color-space/import behavior and runtime consumer.
6. Only then generate those image assets.
7. Godot product owner wires them and proves exact-file runtime consumption.
```

## Evidence ceiling

```text
CONSUMER_FIRST_ASSET_POLICY = ACTIVE
REFERENCE_IMAGES = APPROVED_BUT_NOT_RUNTIME_ASSETS
IMAGE_C_REPRESENTATIVE_VISUAL_GDD = CANCELLED
CURRENT_RUNTIME_IMAGE_CONSUMERS = 0
PET_CUSHION_TEXTURES = CONSUMER_CONTRACT_CANDIDATE
POSTCARD_TEXTURES = CONSUMER_CONTRACT_CANDIDATE
NEW_GAME_IMAGE_GENERATION = PAUSED
HANDPAINTED_3D_RUNTIME_SLICE = NOT_RUN
REAL_DEVICE_QA = NOT_RUN
```
