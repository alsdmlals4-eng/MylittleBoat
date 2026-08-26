# My Little Boat — Game Image Consumer Manifest

Status: `CONSUMER_FIRST_ASSET_POLICY / ACTIVE_GOALS_DEFINED`
Date: 2026-08-26

> Current Goal authority: `docs/visual/2026-08-26-remaining-image-goals.md`. This file owns the consumer inventory and deferred-consumer rules; it does not replace the Image Goal acceptance packets.

## Policy

An image is produced only when it has a concrete current or approved planned game consumer.

Every image asset must define:

```text
asset_path
consumer
runtime_role
spec
fallback
validation
```

Reference boards and explanatory sheets do not count as game-consumable assets.

The approved sequence is:

```text
consumer contract
→ Image Goal
→ GPT image generation/editing
→ user asset approval
→ Notion Asset Library registration
→ IMPLEMENTATION_READY
→ Codex import/wiring
→ runtime screenshot/play verification
```

Codex does not create or edit images.

## Current-main audit

Current repository evidence shows:

- `assets/images/` contains only its README; production image binary = `0`.
- no current `.png` resource reference was observed in project code/scenes.
- no current `albedo_texture` reference was observed.
- `scenes/main_menu.tscn` and `scenes/album.tscn` use `ColorRect` backgrounds.
- `scenes/game.tscn` uses color-only Environment/Ocean materials and text UI.
- `scenes/boat_space.tscn` uses primitive meshes and color-only materials.
- `scripts/decor/boat_decor_slot.gd` constructs primitive decor and sets `albedo_color`.

Therefore:

```text
IMPLEMENTED_GAME_IMAGE_ASSETS = 0
RUNTIME_VERIFIED_GAME_IMAGE_ASSETS = 0
P0_AUTHORED_IMAGE_GOALS = 0
```

## Approved references retained, not counted as runtime assets

- Visual Proof 01 — `APPROVED / REFERENCE_ONLY`
- Visual Proof 02 — `APPROVED / REFERENCE_ONLY`
- Image A — `APPROVED / REFERENCE_ONLY`
- Image B — `APPROVED / REFERENCE_ONLY`
- older player/pet board before the dog-inclusive Image A — `SUPERSEDED`
- planning/checklist infographics — `REFERENCE_ONLY / NOT_GAME_ASSET`

`Image C / Representative Visual GDD` is cancelled as a required production image.

## Active consumer contracts

### IMG-01 / Pet cushion runtime surface set

```yaml
status: IMAGE_GOAL_DEFINED_NEEDS_REVISION
asset_path:
  - res://assets/images/decor/pet_cushion/cushion_stripe.png
  - res://assets/images/decor/pet_cushion/cushion_moon.png
  - res://assets/images/decor/pet_cushion/cushion_floral.png
consumer_item_id: pet_cushion
consumer_target: Boat Decoration PetCorner / pet_cushion visual material
intended_property: StandardMaterial3D.albedo_texture or equivalent simple material input
runtime_role: player-visible cushion appearance customization
spec: 1024x1024 opaque sRGB flat surface art
fallback: current color-only pet_cushion visual remains safe if a texture is missing
validation: actual 540x960 runtime screenshot for all three variants after Codex integration
```

The current user-approved rendered cushion images are **source motif references**, not direct albedo maps. Their outer cushion geometry, tufting and lighting must not be baked into the final surface files.

### IMG-02 / Postcard memory face set

```yaml
status: IMAGE_GOAL_DEFINED_NEEDS_REVISION
asset_path:
  - res://assets/images/decor/postcard/postcard_dawn.png
  - res://assets/images/decor/postcard/postcard_boat_bright.png
  - res://assets/images/decor/postcard/postcard_boat_sunset.png
consumer_item_id: postcard
consumer_target: Boat Decoration rail/postcard front-face material
intended_property: StandardMaterial3D.albedo_texture or equivalent face texture
runtime_role: quiet personal/memory art visible on placed postcard decor
spec: 1024x768 4:3 opaque sRGB normalized card-face art
fallback: current neutral color-only postcard visual remains safe if a texture is missing
validation: actual 540x960 normal-camera screenshot for all three variants after Codex integration
```

The current user-approved postcard renders preserve the approved compositions but must be normalized to the actual face texture. External presentation canvas/drop shadow does not belong in the runtime asset.

## Deferred / no current authored-image requirement

### Main Menu background

Status: `NO_REQUIRED_AUTHORED_IMAGE`.

Current ColorRect is valid. Do not invent a static background consumer merely to use an image. Re-open only after a deliberate screen implementation choice, preferably checking whether live 3D/current world treatment is a better fit.

### Album background / album photos

Status: `NO_AUTHORED_BACKGROUND_REQUIRED / RUNTIME_CAPTURE_FUTURE`.

Player photo content should ultimately come from actual runtime capture rather than authored fake voyage screenshots.

### Character / Pet selection portraits

Status: `DERIVE_FROM_REAL_3D`.

Do not create fake 2D selection portraits. Use actual production model previews/renders once those assets exist.

### Character / Pet / Boat exact albedo maps

Status: `BLOCKED_BY_PRODUCTION_GEOMETRY_AND_CONSUMER`.

Do not pre-generate UV-specific texture sheets. If a stable bitmap material consumer is later established, open a new Image Goal with the exact geometry/material contract.

### Sky / time-of-day bitmap assets

Status: `CONDITIONAL`.

Use Image B as reference. Prefer color/light/simple/procedural implementation. Create panorama/sky bitmaps only if runtime technique explicitly requires them.

### Sea normal/noise maps

Status: `CONDITIONAL`.

Create only if the selected sea material actually samples texture maps and a simple/procedural route is insufficient.

### UI icons

Status: `DEFER_NO_BINDING_CONSUMER`.

Current text buttons are functional. Open an icon Image Goal only after a concrete button/theme consumer and player-readability need are established.

### Release / store / marketing images

Status: `P3_HOLD`.

Wait for platform requirements and branding lock.

## Current next action

```text
1. User reviews/approves IMG-01 + IMG-02 Goal Queue.
2. GPT creates/edits IMG-01 only after that approval.
3. Review → user asset approval → Notion individual records → IMPLEMENTATION_READY.
4. Repeat for IMG-02.
5. Only then unpause CODEX-IMG-01 and CODEX-IMG-02 unless user explicitly narrows the batch.
6. Runtime proof is required before IMPLEMENTED/RUNTIME_VERIFIED claims.
```

## Evidence ceiling

```text
ACTIVE_IMAGE_GOALS = 2
APPROVED_REFERENCE_VISUALS = 4
APPROVED_SOURCE_MOTIFS = 6
IMPLEMENTATION_READY_IMAGE_ASSETS = 0
IMPLEMENTED_IMAGE_ASSETS = 0
RUNTIME_VERIFIED_IMAGE_ASSETS = 0
NEW_IMAGE_GENERATION_THIS_TASK = NOT_RUN
```
