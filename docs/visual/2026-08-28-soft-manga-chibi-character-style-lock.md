# Soft Manga Chibi Character Style Lock · 2026-08-28

## Lock status

```text
PARENT_VISUAL_PHILOSOPHY = SOFT_STORYBOOK_3D_DIORAMA
DETAILED_VISUAL_CANON = HANDPAINTED_STORYBOOK_3D_DIORAMA
CHARACTER_PET_REFINEMENT = SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT
SELECTED_CANDIDATE = CHARACTER_STYLE_COMPARISON_C_LOWER_LEFT
STATUS = USER_APPROVED_VISUAL_DIRECTION
RUNTIME_ASSET_PRODUCTION = NOT_AUTHORIZED_BY_THIS_LOCK
HUMAN_USABILITY_OR_PLAYER_EXPERIENCE_PASS = NOT_PROVEN
```

## Selected evidence and provenance

- Selected comparison board: `docs/visual/generated/soft-manga-chibi-character-style-comparison-2026-08-28.png`.
- SHA-256: `33B030BEAE5528DC068618E7528EAFD59A6A4851A71E165CAF1AC969CE2BECDC`.
- Selected panel: lower-left `C` — soft manga chibi.
- User-supplied character and background references were used only as discovery/style references. Their literal characters, text, composition boards, and any unverified third-party rights are not project assets, are not copied into this repository, and must not be reproduced.
- The generated comparison board is a project-local approval reference, not an independent runtime asset, sprite sheet, or final identity turn-around.

## Visual direction lock packet

### Adopted

- Player and pet use a coherent soft manga chibi language: rounded but not toddler proportions, clear silhouette, large readable hair/ear masses, gentle warm eyes, small facial features, delicate warm contour accents, and restrained two-tone cel shading.
- C knit/long-hair + dog remains the default identity anchor. The chosen panel shows the intended charm and proportion language, not a new character age, outfit system, or pet breed rule.
- Environment remains a broad hand-painted sea and sky: soft time-of-day color, stable horizon, low visual pressure, gentle broken reflection, cool sea ambient light, and a boat physically integrated at the waterline.
- Normal play remains a distant 3/4 diorama where Avatar + Pet + Boat + Sea read together. Close character art is a style anchor, not a replacement camera.

### Rejected

- Plain painterly characters that lack distinctive chibi/anime charm.
- Overly toy-like glossy 3D, photoreal skin/fur, high-fashion glamour, literal toddler framing, oversized glassy eyes, or a pet that reads as a collectible mascot rather than a resting companion.
- Pixel-art/full-2D conversion, dense decoration, dramatic spectacle, task/reward/social visual pressure, and literal copying of user-supplied references.

### Keep / Avoid / Do Not Drift

- Keep: quiet companionship, cream knit + muted teal-blue visual family, warm wood against cool sea, matte materials, a wide horizon, soft bounded motion, and readable mobile silhouettes.
- Avoid: harsh highlights, random generated surface noise, excessive facial detail, competing UI decoration, or atmospheric effects that make the sea threatening.
- Do Not Drift: character refinement must not change local-first rest rules, avatar/pet/boat/sea relationship, camera semantics, voyage rewards, care-free pet behavior, or approved social boundary.

## Comparison-first approval protocol

Every future visual approval must include all of the following before an asset or lock is called approved:

1. At least three materially different candidates, not color-only variants.
2. The same named consumer, camera, composition, information density, character identity, and known constraints across candidates unless the comparison explicitly tests one of those axes.
3. A plain-language mapping of each candidate to player value, production and maintenance cost, scope/risk, reversibility, provenance/rights, and `GENERATED_EXPLORATION` versus `APPROVED_DIRECTION` versus `RUNTIME_VERIFIED` status.
4. A GPT recommendation with its reason and a clear statement of what user selection would change in the repository, Notion, image direction, and runtime scope.
5. Selected, rejected, and superseded references recorded with exact destination readback. A comparison board is never itself a runtime asset or Human usability/Player Experience evidence.

## Next validation

1. Use this lock for the next planning-only main-screen/character comparison board.
2. Check character readability and the boat/sea/character balance together at 540×960 before approving any runtime asset production.
3. Do not start production asset batch or Godot implementation until a separate Phase 2 implementation review approves a concrete consumer.
