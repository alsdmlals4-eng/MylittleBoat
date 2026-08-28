# Indigo Rain + Four-Time Visual Direction Lock · 2026-08-28

## Lock status

```text
PARENT_VISUAL_PHILOSOPHY = SOFT_STORYBOOK_3D_DIORAMA
DETAILED_VISUAL_CANON = HANDPAINTED_STORYBOOK_3D_DIORAMA
CHARACTER_PET_REFINEMENT = SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT
NIGHT_ATMOSPHERE_VARIATION = INDIGO_RAIN_REFLECTION
FOUR_TIME_CONTINUITY = USER_APPROVED_VISUAL_DIRECTION
CORE_SCENE_BOARD_V3 = USER_APPROVED_VISUAL_DIRECTION
RUNTIME_ASSET_PRODUCTION = NOT_AUTHORIZED_BY_THIS_LOCK
GODOT_IMPLEMENTATION = NOT_STARTED
HUMAN_USABILITY_OR_PLAYER_EXPERIENCE_PASS = NOT_PROVEN
```

## Selected evidence and provenance

- User-selected Night mood anchor: `docs/visual/generated/indigo-rain-reflection-night-2026-08-28.png`.
- Night anchor SHA-256: `A21F79C9FC23AA3DD710E20937FCE74395576DB69F991798B3414D87F0D70ACC`.
- User-approved four-time continuity board: `docs/visual/generated/four-time-atmosphere-continuity-2026-08-28.png`.
- Continuity board SHA-256: `D586794EA7DB4A989F8B46097B0F7A40F885727C6F85D41BB0477D9B705333F4`.
- User-approved C-character core-scene board: `docs/visual/generated/project-core-scene-visual-board-2026-08-28-v3-soft-manga-chibi.png`.
- Core-scene board SHA-256: `F2161D11BD31C5158651DBEC66D2D788C706CD927D37C1C76A52FB525867540A`.
- Generator: built-in image generation. The supplied character, environment, and mobile-screen references were discovery/style inputs only. Their literal UI, device chrome, characters, text, layouts, and unverified third-party expressions are not project assets and are not reproduced.

## Adopted visual grammar

### Shared normal-play composition

- Every time state preserves the same mobile-portrait 3/4 diorama: readable Avatar + Dog + Boat + Sea, with the boat in the lower portion and the horizon/sky carrying the larger visual mass.
- C knit/long-hair + dog remains the default anchor. The soft manga chibi character/pet language, warm dark wood, matte surfaces, and low-density lived-in props remain unchanged.
- Normal drifting is the dominant image. Fishing, photo, companion interaction, album memory, and Appreciation Camera stay optional branches, not reward prompts.

### Four-time atmosphere

| Existing ID | Approved rendering role | Keep | Avoid |
| --- | --- | --- | --- |
| `dawn` | cool lavender-blue first light with faint rain residue and a distant muted-peach horizon | broad soft value groups and quiet damp air | a saturated sunrise spectacle or a new weather mechanic |
| `bright` | airy blue open sky and restrained water reflection | generous negative space and calm readable water | harsh white glare, high-frequency sparkle, or dense clouds |
| `sunset` | dusty lilac/apricot sky with broken soft reflection | warmth stays secondary to the wide ocean | orange overload, dramatic sunset tourism framing, or high contrast |
| `night` | `INDIGO_RAIN_REFLECTION`: deep indigo sky, sparse fine rain, subdued broad cool water reflection, and one small warm lantern accent | sea/horizon before lantern, gentle rain, soft blue path-like reflection, visual stillness | neon/magical water, thunder, lightning, giant waves, rain gameplay, or a new time-state choice |

### Keep / Avoid / Do Not Drift

- Keep: large vertical sky space, stable low horizon, light rain as atmosphere rather than a hazard, soft-manga chibi charm, one warm lantern against cool water, and a quiet boat scale.
- Avoid: copied mobile UI, status bars, action icons, pseudo-text, glossy/plastic CG, photoreal water, crowded deck props, close face portraits, or a weather effect that obscures gameplay readability.
- Do Not Drift: `night` remains the existing fourth atmosphere ID. This lock does not authorize a fifth `Rainy Night` option, day cycle, weather simulation, rain audio, gameplay effects, rewards, failure, extra social behavior, or a change to Normal/Appreciation Camera semantics.

## Consumer and evidence boundary

The current runtime consumers are `main_menu.tscn` / `AtmosphereBackground`, `game.tscn` / shared time-of-day tone on both sea backdrops, and `album.tscn` / `AtmosphereBackground`. They still consume the pre-lock Night assets and tone values on current `main`.

The next separately approved implementation contract may replace the existing `night` presentation inside those consumers and may align the other three existing backgrounds to this shared grammar. It must retain exactly `dawn / bright / sunset / night`, add no new state semantics, prove both Normal and Appreciation treatments, and use real 540×960 runtime captures. This planning lock is not itself a runtime image, import, Scene change, UI completion, or Human/player-experience PASS.

## Superseded references

- `docs/visual/generated/project-core-scene-visual-board-2026-08-28-v2.png` remains provenance for the earlier free-rest board but is superseded as a character/atmosphere reference.
- The prior flat `night` presentation is superseded as a **style target**, not as an already-completed runtime asset.

## Selection rationale

`INDIGO_RAIN_REFLECTION` was selected over the quieter-blue and cloud-cocoon alternatives because its broad blue reflection makes the sea feel gently alive while preserving the small boat, open horizon, and passive-rest promise. It is more distinctive than a simple dark tint without requiring a spectacle, progression loop, or separate weather system.

## Next validation

1. Finish the remaining product/UX review before any implementation contract is approved.
2. During Phase 2, use only concrete consumers and preserve the four existing time IDs.
3. Before any production claim, check the selected Night treatment at 540×960 in Normal and Appreciation views for text/button contrast, character/boat readability, rain density, sea-first hierarchy, and mobile comfort.
