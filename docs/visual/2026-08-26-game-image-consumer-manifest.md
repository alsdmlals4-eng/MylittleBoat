# My Little Boat — Game Image Consumer Manifest

**Status:** `CURRENT_RUNTIME_CONSUMERS`

**Updated:** 2026-08-29
**Owner:** [visual inventory](CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md)

## Policy

이미지는 concrete current runtime consumer 또는 approved named consumer가 있을 때만 만든다. 생성 exploration board, visual direction lock, source binary, Godot integration, GPU capture, Human approval은 서로 다른 상태다.

```text
consumer contract → source/provenance → Godot consumer → automated validation → runtime capture → Human validation
```

Notion registration은 current pipeline이 아니다. 새 asset의 durable locator, consumer, provenance, validation은 repository에서 소유한다.

## Current runtime consumer table

| ID | asset path | consumer | runtime role | fallback | validation |
| --- | --- | --- | --- | --- | --- |
| `IMG-SEA-001` | `res://assets/images/runtime/storybook/sea_bright_storybook.png` | two `SeaBackdrop` nodes and album default | dawn/bright/sunset sea base | existing 3D environment color | direct GPU captures |
| `IMG-SEA-002` | `res://assets/images/runtime/storybook/sea_night_indigo_rain_storybook.png` | two `SeaBackdrop` nodes and album night | dedicated indigo-rain night sea | bright sea with night tone only | game/album resource-path contracts + night GPU capture |
| `IMG-WATER-001` | `res://assets/images/runtime/storybook/boat_waterline_storybook.png` | `BoatSpace/BoatWaterlineOverlay` | hull-water wake and occlusion | no overlay, weaker contact | direct GPU capture |
| `IMG-SCENERY-001` | `res://assets/images/runtime/scenery/distant_buoy_storybook.png` | `DistantSceneryLayer` dynamic `TextureRect` | distant buoy | event omitted | scenery runtime contract |
| `IMG-SCENERY-002` | `res://assets/images/runtime/scenery/distant_islet_storybook.png` | same | distant islet | event omitted | runtime contract + visible GPU capture |
| `IMG-SCENERY-003` | `res://assets/images/runtime/scenery/distant_lighthouse_storybook.png` | same | distant lighthouse | event omitted | scenery runtime contract |

## Generated runtime asset receipt

`IMG-SEA-002`, `IMG-WATER-001`, and `IMG-SCENERY-001` through `003` were generated with the built-in image-generation capability on 2026-08-29 for the listed consumers. They were checked against the approved project grammar, have no text/logo/foreign character/UI, and do not reproduce an external game's proprietary art or trade dress. Their output files are committed under `assets/images/runtime/`; the transient generator working files are not product source of truth.

The islet capture places the same runtime prop inside the frame only to make the consumer observable. Normal play creates props outside the horizon frame and moves them at the foreground-only drift rate. No comparison board cell is counted as a runtime asset.

## Evidence ceiling

```text
APPROVED_VISUAL_DIRECTION = YES
CURRENT_RUNTIME_IMAGE_ASSETS = 6
GENERATED_RUNTIME_IMAGE_ASSETS = 5
AUTOMATED_CONSUMER_VALIDATION = PASS
GPU_CAPTURE_540x960 = PASS
HUMAN_FIRST_30_SECONDS = NOT_RUN
HUMAN_FIVE_MINUTE_CALM = NOT_RUN
MOBILE_TOUCH_AND_AUDIO = NOT_RUN
```

## Deferred

- Character/pet production animation batch.
- Additional scenery motif catalogue.
- Album fake illustration/photo filler.
- UI icon pack, store art, marketing art.
- Any art without a named current consumer.

These are not implied by the current six asset consumers.
