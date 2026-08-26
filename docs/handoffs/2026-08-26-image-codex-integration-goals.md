# My Little Boat — Codex Image Integration Goals

Status: `PREPARED / BLOCKED_UNTIL_GPT_IMAGE_APPROVAL_COMPLETE`
Date: 2026-08-26

Codex does **not** create, redraw or edit images. It integrates only GPT-produced, user-approved, Notion-registered `IMPLEMENTATION_READY` assets.

Before every Goal, fresh-read completed `main`, Project Notion, actual scenes/scripts/resources/tests and current open PRs. PR #19 stays `READ_ONLY / NO_ABSORPTION`.

---

## CODEX-IMG-01 — Pet Cushion Runtime Surface Integration

### Goal

Connect the three approved final cushion surface images to the stable `pet_cushion` decor so the player can select three quiet appearance variants without changing rest, reward, care or economy semantics.

### Inputs

- `IMG-01` approved files + Asset Library records.
- `docs/visual/2026-08-26-remaining-image-goals.md`.
- `scripts/decor/boat_decor_catalog.gd`.
- `scripts/decor/boat_decor_slot.gd`.
- `scenes/boat_space.tscn` and `scenes/game.tscn`.
- existing Boat Decoration / GameState tests.

Expected exact files:

```text
res://assets/images/decor/pet_cushion/cushion_stripe.png
res://assets/images/decor/pet_cushion/cushion_moon.png
res://assets/images/decor/pet_cushion/cushion_floral.png
```

### Scope

- import the exact three approved images;
- reuse the existing `pet_cushion` base item and `pet_corner` compatibility;
- choose the smallest safe cosmetic variant-state representation;
- connect selected surface to actual cushion material/geometry;
- preserve neutral color fallback if texture is absent/invalid;
- expose only enough existing decor UI/state to choose the three appearances.

### Non-Scope

- no new pet need/care loop;
- no stats, rarity, currency, gacha, shop or completion bonus;
- no new decor slot IDs or unrelated item replacement;
- no social/PR #19 work;
- no image creation/editing.

### Tasks

1. Fresh-read current main/Notion and inspect existing cushion/decor contracts.
2. Reuse current Boat Decoration architecture; avoid parallel inventory/system creation.
3. Add semantic TDD RED for three cosmetic appearances, safe fallback and core-state isolation.
4. Import exact approved files with mobile-appropriate settings.
5. Establish the smallest viable cushion material mapping; current simple geometry may be refined only as needed to display the approved flat surfaces correctly.
6. Connect appearance selection without altering base item compatibility or interaction meaning.
7. Run focused regression + repository validation.
8. Run actual game at 540×960 portrait.
9. Capture runtime evidence for Stripe / Moon / Floral.
10. Fix UV/repeat/stretch/mip/noise/state issues.
11. Return `READY_FOR_GPT_REVIEW` with exact head, file refs, tests, screenshots and NOT_RUN evidence.

### Acceptance Criteria

- all three exact approved files are actually referenced by the runtime cushion consumer;
- appearance switching changes only visuals;
- missing texture falls back safely;
- no double-baked cushion silhouette/shadow is visible;
- motifs remain calm/readable at 540×960;
- existing decoration/interaction/state semantics regress by 0;
- runtime screenshots exist.

---

## CODEX-IMG-02 — Default Postcard Memory Face Integration

### Goal

Connect the one approved default Bright Boat postcard face to the existing `postcard` decor so it carries visible personal-memory artwork without creating a new postcard variant/collection system.

### Inputs

- `IMG-02` approved final file + Asset Library record.
- `docs/visual/2026-08-26-remaining-image-goals.md`.
- `scripts/decor/boat_decor_catalog.gd`.
- `scripts/decor/boat_decor_slot.gd`.
- `scenes/boat_space.tscn` and `scenes/game.tscn`.

Expected exact file:

```text
res://assets/images/decor/postcard/postcard_boat_bright.png
```

Dawn/Sunset source compositions are P2 reuse candidates and are **not** inputs to this P1 Goal.

### Scope

- import the exact approved default face;
- connect it to the existing `postcard` visual;
- preserve the existing `postcard` item ID, rail compatibility and `look` interaction;
- preserve neutral fallback if texture is missing/invalid;
- make only the minimal geometry/material change needed for correct front-face display.

### Non-Scope

- no postcard variant selector/state;
- no rarity/collection score/reward system;
- no new Album architecture or social-letter feature;
- no PR #19 work;
- no image creation/editing.

### Tasks

1. Fresh-read main/Notion and current postcard behavior.
2. Confirm the simplest correct front-face geometry/material path; if the current BoxMesh cannot display a clean single face without unwanted side repetition, use the smallest visual-only geometry adjustment.
3. Add semantic RED tests for exact texture consumer, fallback and core-state isolation.
4. Import and bind the approved Bright Boat face.
5. Verify existing `look` interaction and decor state remain intact.
6. Run focused regression + full repository validation.
7. Run actual game at 540×960 normal 3/4 view.
8. Capture runtime screenshot proving the exact face is visible.
9. Correct aspect/crop/mirroring/UV/mip/readability/noise issues.
10. Return `READY_FOR_GPT_REVIEW` packet.

### Acceptance Criteria

- the exact approved Bright Boat file is loaded by the actual postcard consumer;
- no external presentation canvas/shadow is visible;
- image is not stretched, mirrored or incorrectly clipped;
- no new postcard variant/progression system was introduced;
- `look` interaction and existing decor state work unchanged;
- postcard stays subordinate to the sea/boat hierarchy;
- runtime screenshot evidence exists.

---

## Cross-goal verification sequence

```text
IMPLEMENTATION_READY approved image
→ Codex import
→ exact runtime consumer reference
→ semantic regression
→ Godot runtime
→ 540×960 screenshot
→ GPT final review
→ merge
→ postmerge readback
→ Notion IMPLEMENTED / RUNTIME_VERIFIED update
```

Planning, image approval or CI alone never upgrades a file to `IMPLEMENTED` or `RUNTIME_VERIFIED`.
