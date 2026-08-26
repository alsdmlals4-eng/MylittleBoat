# My Little Boat — Game Image Consumer Manifest

Status: `CONSUMER_FIRST_ASSET_POLICY / ACTIVE_GOALS_DEFINED`
Date: 2026-08-26

> Goal authority: `docs/visual/2026-08-26-remaining-image-goals.md`.

## Policy

An image is produced only when it has a concrete current or approved planned game consumer.

Every generated game asset must define:

```text
asset_path
consumer
runtime_role
spec
fallback
validation
```

Pipeline:

```text
consumer contract → Image Goal → GPT asset production/review → user approval
→ Notion registration → IMPLEMENTATION_READY → Codex integration → runtime proof
```

Codex does not create/edit images.

## Current-main audit

- `assets/images/` production binaries: `0`.
- no runtime `.png`, `Texture2D`, `TextureRect` or `albedo_texture` product consumer observed.
- Main Menu / Album = ColorRect.
- Game Environment/Ocean = color-only material.
- Boat/Avatar/Pet/Decor = primitive technical placeholders + color-only material.
- Album photo content = text records, not captures.

```text
P0_AUTHORED_IMAGE_GOALS = 0
IMPLEMENTED_GAME_IMAGE_ASSETS = 0
RUNTIME_VERIFIED_GAME_IMAGE_ASSETS = 0
```

## Reference inventory

- Proof 01 — `APPROVED / REFERENCE_ONLY`.
- Proof 02 — `APPROVED / REFERENCE_ONLY`.
- Image A — `APPROVED / REFERENCE_ONLY`.
- Image B — `APPROVED / REFERENCE_ONLY`.
- older pre-dog player/pet board — `SUPERSEDED`.
- planning/checklist sheets — `REFERENCE_ONLY / NOT_GAME_ASSET`.
- Image C / Representative Visual GDD — cancelled as required deliverable.

## Active consumer contract — IMG-01 Pet Cushion

```yaml
status: IMAGE_GOAL_DEFINED_NEEDS_REVISION
asset_paths:
  - res://assets/images/decor/pet_cushion/cushion_stripe.png
  - res://assets/images/decor/pet_cushion/cushion_moon.png
  - res://assets/images/decor/pet_cushion/cushion_floral.png
consumer_item_id: pet_cushion
consumer_target: Boat Decoration PetCorner / pet_cushion visual material
runtime_role: player-visible cushion appearance customization
spec: 1024x1024 opaque sRGB flat low-frequency repeat-friendly surface art
fallback: current neutral color-only pet_cushion
validation: actual 540x960 runtime screenshot for all three appearances
```

Current user-approved cushion renders are `REUSE_WITH_EDIT`: motif/color identity is approved, but their rendered cushion rim/tuft/depth/light cannot be used as direct albedo.

## Active consumer contract — IMG-02 Default Postcard

```yaml
status: IMAGE_GOAL_DEFINED_NEEDS_REVISION
asset_path: res://assets/images/decor/postcard/postcard_boat_bright.png
consumer_item_id: postcard
consumer_target: Boat Decoration rail/postcard front face
runtime_role: one quiet personal/memory image on the existing postcard decor
spec: 1024x768 4:3 opaque sRGB normalized face art
fallback: current neutral color-only postcard
validation: actual 540x960 normal-camera screenshot
```

P1 deliberately uses **one default face**. It does not create a postcard variant system only to consume extra art.

Approved Dawn/Sunset source compositions remain `P2 / REUSE_LATER` until a real multi-postcard consumer is approved.

## Deferred / no current authored-image requirement

- Main Menu static background — `NO_REQUIRED_AUTHORED_IMAGE`; current ColorRect is valid.
- Album authored background/fake photos — `REJECT_NOW`; actual photos should be runtime capture.
- Character/Pet selection portraits — `DERIVE_FROM_REAL_3D`.
- Character/Pet/Boat exact UV albedo — `BLOCKED_BY_PRODUCTION_GEOMETRY`.
- Sky/time-of-day bitmaps — `CONDITIONAL`; prefer color/light/simple procedural route.
- Sea normal/noise maps — `CONDITIONAL`; create only if selected material samples them.
- UI icons — `DEFER_NO_BINDING_CONSUMER`.
- App icon / store / marketing — `P3_HOLD` until release target and branding lock.

## Current next action

```text
1. User reviews/approves current IMG-01 + IMG-02 queue.
2. GPT produces/reviews IMG-01 3 files; user approves; Notion registers final assets.
3. GPT produces/reviews IMG-02 1 file; user approves; Notion registers final asset.
4. Both Goals reach IMPLEMENTATION_READY.
5. CODEX-IMG-01 then CODEX-IMG-02.
6. Runtime proof required before IMPLEMENTED/RUNTIME_VERIFIED.
```

## Evidence ceiling

```text
ACTIVE_IMAGE_GOALS = 2
ACTIVE_REQUIRED_FILES = 4
APPROVED_REFERENCE_VISUALS = 4
APPROVED_SOURCE_IMAGES = 6
IMPLEMENTATION_READY_IMAGE_ASSETS = 0
IMPLEMENTED_IMAGE_ASSETS = 0
RUNTIME_VERIFIED_IMAGE_ASSETS = 0
NEW_IMAGE_GENERATION_THIS_TASK = NOT_RUN
```
