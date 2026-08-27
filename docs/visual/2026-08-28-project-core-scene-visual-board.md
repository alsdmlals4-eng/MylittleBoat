# Project Core Scene Visual Board · 2026-08-28

## Status and boundary

```text
PROJECT_CORE_SCENE_VISUAL_BOARD = GENERATED_EXPLORATION
PURPOSE = AI_UNDERSTANDING_VALIDATION + PLANNING_REVIEW + VISUAL_DIRECTION_CONFIRMATION
NOT_RUNTIME_ASSET = TRUE
NOT_GODOT_UI_IMPLEMENTATION = TRUE
NOT_HUMAN_USABILITY_OR_PLAYER_EXPERIENCE_PASS = TRUE
CHARACTER_STYLE_STATUS = SUPERSEDED_BY_SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT
```

This board records the approved free-rest voyage role. It does not create a new image family, change a runtime consumer, or authorize a production-asset batch.

Its large normal-drifting composition and optional-activity hierarchy remain valid. Its player/pet rendering predates the approved soft-manga chibi refinement, so it must not be used as the character-style reference for future visual work.

## Provenance

- Generator: built-in image generation.
- Reference role: `docs/evidence/2026-08-28-main-menu-composition/main_menu_bright_540x960.png` supplied the approved C knit/long-hair player, dog companion, wooden boat, and `HANDPAINTED_STORYBOOK_3D_DIORAMA` language.
- Selected board binary: `docs/visual/generated/project-core-scene-visual-board-2026-08-28-v2.png`.
- Selected SHA-256: `9B5D25A9B0AB871996036C6522EBFF75446EA42B0A33A6EEB8EDA6C224EA25B0`.
- Superseded exploration: `docs/visual/generated/project-core-scene-visual-board-2026-08-28.png` was retained only as provenance. It duplicated the scenery-photo framing and did not make the Appreciation view independently legible.
- Rights and scope: project-local generated planning visualization. It is not an approved independent runtime asset and must not be wired into a Godot scene without a separately approved concrete consumer.

## Confirmed player contract

Normal voyage is peaceful drifting: the player looks at the sea and the resting player/pet pair. Doing nothing is complete play, not idle waiting or failure. Fishing, scenery photos, decoration, small interaction, and Ambient Discovery are freely available optional branches. They do not force a once-per-voyage choice, order, reward optimization, loss, or pressure.

## Panel readback

| Planning panel | Actual or planned consumer | Player goal and action | Choice, feedback, and next connection | Confirmed basis / undecided boundary |
| --- | --- | --- | --- | --- |
| Arrival light | `main_menu.tscn` / `AtmosphereBackground` | Enter a calm voyage after choosing the time and mood. | The atmosphere changes before entry; continue to normal diorama. | Four approved time backgrounds are current. Exact onboarding wording and final control layout remain runtime-owned. |
| Normal drifting — primary | `game.tscn` / Normal Camera | Watch the sea, the resting player, and the dog in the boat. | Staying still is already valid; optional branches remain quiet and secondary. | Confirmed by Issue #83. Exact mobile UI density needs Human validation. |
| Appreciation view | `game.tscn` / Appreciation Camera | Shift attention toward sea and horizon. | Reduced nonessential UI; return without timer, reward, or soundscape change. | Current camera semantics are confirmed. The generated board conveys this with the open-horizon composition, not exact UI. |
| Quiet fishing | `game.tscn` / fishing state | Fish only when the player wants a small waiting activity. | Wait, catch, cancel, or return to resting; no economy or failure loop. | Existing optional fishing contract is current. Final feedback feel remains unverified. |
| Scenery photo | `game.tscn` / photo action | Keep a quiet view as a personal memory. | A photo becomes a record, then the player may return to rest. | Photo is optional. Exact capture framing and album presentation are runtime-owned. |
| Gentle companion / boat interaction | `game.tscn` / low-pressure interaction | Briefly pet the companion or share the boat space. | Small posture or local response only; return to normal drifting. | No affection farming, care obligation, timer, or reward change. |
| Memory trace | `album.tscn` | Revisit actual voyage and activity records. | Record is a trace, not a score or completion target; continue resting or start a new voyage. | Album uses Godot UI/text and actual records. This notebook imagery is explanatory only. |

## Visual direction readback

- Keep: calm ocean and stable horizon, warm dark wood, long-hair knit player + dog, matte hand-painted material, rounded restrained silhouettes, low visual density, quiet life props.
- Avoid: readable or pseudo text in images, glossy generic CG, pixel-art or full-2D conversion, task UI, trophies, dense inventory, public/social feed, maps, warning badges.
- Do not drift: optional activity must never visually dominate passive rest or imply a reward/failure progression.
- Allowed variation: time-of-day light, calm weather, and low-intensity activity framing inside the same camera/material/UI grammar.
