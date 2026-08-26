# My Little Boat — Codex Image Integration Goals

Status: `PREPARED / BLOCKED_UNTIL_GPT_IMAGE_APPROVAL_COMPLETE`
Date: 2026-08-26

Codex does **not** create or redesign images. It integrates only GPT-produced, user-approved, Notion-registered assets.

Before every Goal, Codex must fresh-read completed `main`, project Notion, actual scenes/scripts/resources/tests, and open PRs. PR #19 remains `READ_ONLY / NO_ABSORPTION`.

---

## CODEX-IMG-01 — Pet Cushion Runtime Surface Integration

### Goal

Connect the three approved pet-cushion surface images to the actual `pet_cushion` decor so the player can see/select the approved appearance variants without changing any rest, reward or care semantics.

### Inputs

- `IMG-01` approved assets and Notion records.
- `docs/visual/2026-08-26-remaining-image-goals.md`.
- `scripts/decor/boat_decor_catalog.gd`.
- `scripts/decor/boat_decor_slot.gd`.
- `scenes/boat_space.tscn`.
- `scenes/game.tscn`.
- existing Boat Decoration / GameState tests.

Expected asset paths:

```text
res://assets/images/decor/pet_cushion/cushion_stripe.png
res://assets/images/decor/pet_cushion/cushion_moon.png
res://assets/images/decor/pet_cushion/cushion_floral.png
```

### Scope

- import approved textures;
- establish the smallest safe `pet_cushion` visual variant representation;
- connect the selected texture to the cushion material;
- preserve fallback if an image is missing/invalid;
- expose only enough existing decor UI/state to select the three approved visual variants;
- preserve local-first state semantics and existing slot compatibility.

### Non-Scope

- no new pet needs/care loop;
- no stats, rarity, currency, gacha or store;
- no new decor slot ids;
- no unrelated boat/item art replacement;
- no PR #19 mutation;
- no image creation/editing by Codex.

### Tasks

1. Fresh-read current completed main and Notion asset records.
2. Inspect existing `pet_cushion` item/slot/state contracts and current tests.
3. Reuse current Boat Decoration flow; choose the smallest variant-state representation that preserves base `pet_cushion` meaning.
4. Add semantic TDD RED for three available cushion appearances, missing-texture fallback, and core-state isolation.
5. Import the approved PNGs using mobile-appropriate texture settings.
6. Connect the actual material consumer.
7. Connect variant selection without creating reward/progression meaning.
8. Run focused tests and repository validation.
9. Run Godot scene/runtime proof at 540×960 portrait.
10. Capture evidence showing each variant on the actual pet cushion.
11. Fix stretch, UV, scale, noise or state regressions.
12. Return a `READY_FOR_GPT_REVIEW` packet with exact paths, head SHA, tests, runtime proof and remaining NOT_RUN evidence.

### Acceptance Criteria

- all three **exact approved files** are importable and actually referenced by the runtime consumer;
- switching cushion appearance does not change slot compatibility, rewards, timer, affection, social state or care obligation;
- missing/invalid texture falls back safely instead of breaking the decor item;
- no double-baked cushion geometry/shadow appears from the albedo;
- texture scale is readable and calm at 540×960;
- existing Boat Decoration and interaction behavior does not regress;
- runtime screenshot evidence exists.

---

## CODEX-IMG-02 — Postcard Memory Face Integration

### Goal

Connect the three approved postcard face images to the existing `postcard` decor so placed postcards visibly carry quiet memory art without turning them into collectible progression.

### Inputs

- `IMG-02` approved assets and Notion records.
- `docs/visual/2026-08-26-remaining-image-goals.md`.
- `scripts/decor/boat_decor_catalog.gd`.
- `scripts/decor/boat_decor_slot.gd`.
- `scenes/boat_space.tscn`.
- `scenes/game.tscn`.

Expected paths:

```text
res://assets/images/decor/postcard/postcard_dawn.png
res://assets/images/decor/postcard/postcard_boat_bright.png
res://assets/images/decor/postcard/postcard_boat_sunset.png
```

### Scope

- import three face textures;
- apply one selected face to the existing postcard visual;
- provide the smallest cosmetic variant path within the current decoration flow;
- maintain rail/postcard interaction behavior;
- verify small-object readability in the normal 3/4 camera.

### Non-Scope

- no postcard rarity/collection score;
- no new memory reward system;
- no new album architecture;
- no new social-letter feature;
- no PR #19 work;
- no image creation/editing by Codex.

### Tasks

1. Fresh-read main/Notion and current postcard behavior.
2. Confirm actual face orientation/material/UV needs.
3. Add semantic RED tests for three cosmetic faces, fallback and core-state isolation.
4. Import approved files and bind them to the postcard front-face material.
5. Connect minimal cosmetic selection while preserving base `postcard` item meaning.
6. Verify `look` interaction still works.
7. Run focused regression tests and full repository validation.
8. Run actual game scene at 540×960 and inspect normal 3/4 view.
9. Capture screenshots showing each face at runtime.
10. Correct crop, aspect, UV orientation, mip/readability or visual-noise issues.
11. Return `READY_FOR_GPT_REVIEW` packet.

### Acceptance Criteria

- the exact approved postcard files are loaded by the actual postcard consumer;
- no card-face image is stretched, mirrored, clipped incorrectly or surrounded by presentation-space background/shadow;
- the postcard remains a low-pressure decor/memory trace;
- `look` interaction and existing decor state continue to work;
- the sea/boat hierarchy remains dominant in the normal camera;
- runtime screenshot evidence exists.

---

## Cross-goal verification sequence

```text
Approved image binary
→ Notion asset record
→ Codex import
→ exact runtime consumer reference
→ focused regression
→ Godot runtime
→ 540×960 screenshot
→ GPT final review
→ merge
→ postmerge readback
→ Notion Implementation/RUNTIME status update
```

No `IMPLEMENTED` or `RUNTIME_VERIFIED` status is allowed from planning, image approval or CI alone.
