# My Little Boat — Game Image Consumer Manifest

Status: `CONSUMER_FIRST_ASSET_POLICY / IMAGE_GENERATION_PAUSED_UNTIL_READY`
Date: 2026-08-26

## Policy

An image is produced only when it has a concrete Godot consumer.

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

## Current-main audit

Current repository evidence shows:

- `assets/images/` contains only its README; no production image binary is currently stored there.
- no current `.png` reference was found in project code/scenes.
- no current `albedo_texture` reference was found.
- `scenes/main_menu.tscn` uses `ColorRect` for its background.
- `scenes/album.tscn` uses `ColorRect` for its background.
- `scenes/boat_space.tscn` uses primitive meshes and color-only `StandardMaterial3D` placeholders.
- `scripts/decor/boat_decor_slot.gd` constructs primitive decor meshes and sets `albedo_color`; it does not load texture files.

Therefore:

```text
CURRENT_RUNTIME_IMAGE_CONSUMERS = 0
```

Do not generate another gameplay image until a consumer contract below reaches `READY_TO_GENERATE`.

## Approved references retained, not counted as runtime assets

- Visual Proof 01 — approved reference
- Visual Proof 02 — approved reference
- Image A — approved customization reference
- Image B — approved time-of-day/boat atmosphere reference

These can guide production, but the files themselves are not required runtime assets unless a specific consumer is later created for them.

`Image C / Representative Visual GDD` is cancelled as a required production image.

## Candidate consumer contracts

### 1. Pet cushion textures

```yaml
status: CONSUMER_CONTRACT_CANDIDATE
asset_path: res://assets/images/decor/pet_cushion/
consumer_item_id: pet_cushion
consumer_target: Boat Decoration pet_cushion visual material
intended_property: StandardMaterial3D.albedo_texture
runtime_role: player-visible cushion appearance customization
fallback: existing color-only material
```

Why first:
- `pet_cushion` already exists as a stable decor item meaning.
- the user explicitly approved pet cushion customization.
- it is cosmetic and does not affect stats/rewards.

Before generation:
- choose minimal variant count;
- define how the chosen texture maps to the actual cushion mesh;
- define import size/color-space expectations;
- ensure the consumer will actually load the file.

### 2. Postcard face textures

```yaml
status: CONSUMER_CONTRACT_CANDIDATE
asset_path: res://assets/images/decor/postcard/
consumer_item_id: postcard
consumer_target: Boat Decoration postcard visual material
intended_property: StandardMaterial3D.albedo_texture
runtime_role: readable personal/memory artwork on placed postcard decor
fallback: existing neutral color-only postcard material
```

Why first:
- `postcard` already exists as a stable decor item.
- the object is visually planar and suited to authored 2D art.
- a small number of variants can be directly player-visible without expanding core systems.

Before generation:
- confirm face orientation/UV mapping;
- define 1–3 initial variants only;
- define import size and alpha policy;
- verify 3/4-camera readability.

## Deferred until their consumer exists

### Character / pet albedo textures

Status: `BLOCKED_BY_PRODUCTION_MESH_AND_UV`.

Do not generate character/pet texture sheets until the actual 3D mesh and UV layout exist. The approved Image A remains reference only.

### Boat / general decor albedo textures

Status: `BLOCKED_BY_PRODUCTION_MESH_AND_UV`.

If color-only materials are sufficient, skip bitmap generation entirely.

### Sky / time-of-day images

Status: `CONDITIONAL`.

Generate only if the Godot Environment explicitly adopts a panorama/sky texture consumer. If Dawn/Bright/Sunset/Night are implemented with colors/lights/material parameters, create no sky bitmap.

Image B is a reference, not a runtime sky image.

### Sea normal/noise maps

Status: `CONDITIONAL`.

Generate only if the final sea material/shader samples texture maps. Prefer no image when simple/procedural material is sufficient.

### UI icons

Status: `BLOCKED_BY_UI_TEXTURE_CONSUMER`.

Current UI is text Button/ColorRect based. Generate icons only after a concrete `TextureButton`, `TextureRect`, theme icon, or equivalent consumer is approved.

Possible future meanings: Mood, Appreciation, Photo, Fishing, Decor, Interaction, Album.

### Main menu / Album backgrounds

Status: `NO_CURRENT_CONSUMER`.

Current scenes use `ColorRect`. Do not generate background images unless those screens are deliberately changed to a texture consumer.

## Runtime-generated images

Album/voyage photos should be produced from actual runtime capture when implemented. Do not substitute authored concept art for a player's captured voyage image.

Character/pet selection thumbnails should preferably derive from actual production 3D previews/renders so the selection UI matches the model the player receives.

## Current next action

```text
1. Keep image generation paused.
2. Promote one candidate consumer contract to READY_TO_GENERATE.
3. Define exact path/spec/consumer mapping.
4. Generate only that asset.
5. Wire it in Godot through the product-implementation owner.
6. Verify the exact file is loaded and visible in runtime.
7. Only then count that image as DONE.
```

Recommended first consumer batch after contract lock:

```text
PET_CUSHION_TEXTURES
POSTCARD_TEXTURES
```

No other image batch should be generated by default.