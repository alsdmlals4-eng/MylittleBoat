# My Little Boat — Remaining Image Goals

Status: `USER_APPROVED_GOAL_QUEUE / GPT_WORK_READY_TO_EXECUTE`
Date: 2026-08-26
Original audit baseline main: `d4d5e57027e1c83d1ae3504fce484fd4a11d8015`
Current execution router: `docs/handoffs/CURRENT_GPT_WORK.md`

## 1. Current-state result

The image-gap audit established:

```text
P0_AUTHORED_IMAGE_GOALS = 0
ACTIVE_P1_IMAGE_GOALS = 2
ACTIVE_P1_REQUIRED_FILES = 4
IMPLEMENTATION_READY_IMAGE_ASSETS = 0
IMPLEMENTED_IMAGE_ASSETS = 0
RUNTIME_VERIFIED_IMAGE_ASSETS = 0
```

The current P0 visual blockers are production 3D/runtime work, not missing authored bitmaps. The user has approved the following P1 Goal Queue for GPT Work execution before Codex/Godot implementation.

## 2. Existing visual inventory / reuse

| Visual | State | Runtime use | Existing Solution First |
| --- | --- | --- | --- |
| Visual Proof 01 | `APPROVED` | reference only | `REUSE_AS_IS` style/material/composition |
| Visual Proof 02 | `APPROVED` | reference only | `REUSE_AS_IS` silhouette/pet/decor |
| Image A — Player + Pet Customization | `APPROVED` | reference only | `REUSE_AS_IS` identity/customization meaning |
| Image B — Boat/Sea/Four-Time | `APPROVED` | reference only | `REUSE_AS_IS` atmosphere/value hierarchy |
| pre-dog player/pet board | `SUPERSEDED` | none | `REJECT` as current source |
| planning/checklist sheets | `REFERENCE_ONLY` | none | `REJECT` as game asset |
| 3 cushion renders | motif `APPROVED`; runtime `NEEDS_REVISION` | future pet cushion | `REUSE_WITH_EDIT` |
| bright-boat postcard render | composition `APPROVED`; runtime `NEEDS_REVISION` | future postcard face | `REUSE_WITH_EDIT` |
| dawn + sunset postcard renders | `APPROVED` source compositions | no current variant consumer | `REUSE_LATER / P2` |

The cushion source images include rendered cushion geometry/shading, so direct albedo use would double-bake shape/light. The postcard source includes presentation-space treatment; its final runtime face must be normalized. User source approval remains valid at motif/composition level.

## 3. Alternative disposition

- Broad static-background/icon/portrait production now → `REJECT`.
- Assetize only approved consumer-stable surfaces → `ADOPT`.
- Pre-generate exact UV-specific character/pet/boat maps before geometry → `DEFER / REJECT_NOW`.

---

# IMG-01 — Pet Cushion Runtime Surface Set

Priority: `P1`
Goal approval: `USER_APPROVED`
Execution status: `READY_FOR_GPT_WORK`
Reuse: `REUSE_WITH_EDIT`
Required final images: `3`

### 1. Player / Product Goal

The pet corner should feel personally chosen through three calm cushion appearances, while the pet remains a no-obligation resting companion. Appearance choice must never imply power, rarity, care state, price or progression advantage.

### 2. Actual Consumer

- Scene: `scenes/game.tscn` → `VoyageWorld/BoatSpace/BoatDecorSlots/PetCorner`
- System: Boat Decoration
- Stable base item: `pet_cushion`
- Planned consumer: `pet_cushion` 3D visual material via `StandardMaterial3D.albedo_texture` or the smallest equivalent material input selected later by Codex.
- Planned files:
  - `res://assets/images/decor/pet_cushion/cushion_stripe.png`
  - `res://assets/images/decor/pet_cushion/cushion_moon.png`
  - `res://assets/images/decor/pet_cushion/cushion_floral.png`
- Fallback: existing neutral color-only `pet_cushion` remains usable if a texture is unavailable.

The visual-variant state representation is Codex implementation detail. It must preserve the stable `pet_cushion` meaning rather than creating new item categories, rarity or economy.

### 3. Existing References

Use Image A and Visual Proof 01/02 for the approved hand-painted, matte, low-noise language.

Approved source provenance:

- Stripe source · `gen_id 10069481-9195-4973-b149-66146910708b` · SHA-256 `ccc05bfb09cdf26b3cdf8c834cde252dee03ab656cdd20be62b2de28116cfa99`.
- Moon source · `gen_id 5aed1ba0-9ee3-4837-9e9d-cfabb2bc9c71` · SHA-256 `ff0327998969f5b8e034c887a1ec9067aefabc5f98a4238bf374204d316792a5`.
- Floral source · `gen_id 15ff36bc-add1-473b-b076-a27a52c6cf52` · SHA-256 `3426a4463dddcb202b5b9c43a27612cd71203130647e0ca4a7f6c76947deca58`.

The exact visual fingerprints/removal instructions are in `docs/handoffs/2026-08-26-gpt-work-image-production-handoff.md` and the corresponding Notion Asset Library source records.

### 4. Required Assets

1. `cushion_stripe.png`
   - cream + soft dusty-blue broad stripe; sparse tiny stitched wave/rope motifs;
   - 1024×1024, opaque sRGB;
   - flat, low-frequency, repeat-friendly surface art.
2. `cushion_moon.png`
   - muted dusty lavender; one soft cream crescent + sparse cream stars/tiny dots;
   - 1024×1024, opaque sRGB;
   - flat, low-frequency surface art.
3. `cushion_floral.png`
   - warm parchment/cream; muted olive leaves/sprigs + sparse tiny cream/yellow flowers;
   - 1024×1024, opaque sRGB;
   - flat, low-frequency surface art.

### 5. Must Preserve

- the three user-approved motif identities;
- `HANDPAINTED_STORYBOOK_3D_DIORAMA` surface language;
- muted/comfortable long-viewing palette;
- pet = resting companion, not collectible mascot;
- cosmetic-only semantics.

### 6. Must Not Introduce

- rendered cushion silhouette/rim/tuft/depth;
- drop shadow, perspective or directional baked lighting;
- rarity glow/badge, premium mark, price, text/logo;
- pet need/care indicator;
- new pet species or gameplay rule.

### 7. Quality Target

- production-use material source, not concept-sheet quality;
- remains distinct after aggressive reduction at the 540×960 portrait gameplay target;
- motif density low enough not to compete with sea/horizon;
- plausible direct use as color/albedo source on simple 3D cushion geometry.

### 8. Acceptance Criteria

PASS only when:

- exactly three separate flat surface files exist;
- no rendered cushion geometry/shadow remains;
- Stripe/Moon/Floral remain identifiable at small scale;
- files have stable names/planned paths;
- no canon or reward/economy semantics changed;
- GPT Work reviews them as runtime assets and the user explicitly approves the final files.

### 9. Verification sequence

```text
GPT Work Generated/Edited
→ GPT Work Runtime-Asset Review
→ User Asset Approval
→ Notion Final Asset Records + Durable Binary Locators
→ IMPLEMENTATION_READY
→ CODEX-IMG-01
→ Implemented
→ 540×960 Runtime Screenshot
→ RUNTIME_VERIFIED
```

---

# IMG-02 — Default Postcard Memory Face

Priority: `P1`
Goal approval: `USER_APPROVED`
Execution status: `WAITING_AFTER_IMG_01`
Reuse: `REUSE_WITH_EDIT`
Required final images: `1`

### 1. Player / Product Goal

The existing `postcard` decor should visibly carry one quiet personal memory image, adding attachment to the boat without introducing a postcard collection/variant system solely to consume extra art.

### 2. Actual Consumer

- Scene: `scenes/game.tscn` → Boat Decoration `rail_accent` postcard visual.
- System: Boat Decoration.
- Stable base item: `postcard`.
- Planned consumer: postcard front face via `albedo_texture` or equivalent simple face material.
- Planned file: `res://assets/images/decor/postcard/postcard_boat_bright.png`.
- Fallback: current neutral color-only postcard remains usable if the texture is unavailable.

No new postcard selector/state is required for this P1 Goal.

### 3. Existing References

- Image B: Bright atmosphere, stable horizon and sea-first hierarchy.
- Proof 01/02: hand-painted low-noise surface language.
- Bright Boat source · `gen_id 5514be9b-ca2e-48b6-86b5-64ac788c2059` · SHA-256 `1f0a0c9d5c658f58a55290d3a9dddeaca231630cd1158170cbc655ed6b823a3d`.

P2 source provenance preserved only:

- Dawn · `gen_id 68183ec8-8dff-425e-8954-02e75b358aee` · SHA-256 `4aefdf55a02f0d255de21250d68f1cbb3ac478db69e2d19d15da2eb0e7a8eff9`.
- Sunset · `gen_id 311d5986-da71-43c2-95bd-6ed3a070d648` · SHA-256 `23058b8390c564a330c66257ff04a1ec38e0686eaf886f09b999b10c562b9131`.

### 4. Required Asset

`postcard_boat_bright.png`

- bright calm sea + small personal dark wooden boat;
- soft clouds / stable horizon / small distant islands;
- lantern, plant, mugs/cups, light cushion may remain as simple memory cues;
- 1024×768, 4:3, opaque sRGB;
- normalized to the intended card face itself;
- a small painted paper border may remain, but no external canvas/drop shadow may remain.

### 5. Must Preserve

- approved bright-boat composition and calm sea identity;
- stable horizon and broad sea/sky dominance;
- hand-painted storybook treatment;
- postcard = quiet decor/memory trace, not progression reward.

### 6. Must Not Introduce

- external presentation background/drop shadow;
- readable brand/logo/text;
- rarity/collectible scoring;
- dramatic threat weather;
- new character/place/boat lore that becomes canon accidentally;
- new postcard-variant system in P1.

### 7. Quality Target

- directly usable on a planar postcard face;
- strong simple silhouette/value grouping surviving very small 3/4-camera display;
- no high-frequency details that become noise.

### 8. Acceptance Criteria

PASS only when:

- one normalized 4:3 face file exists at the fixed planned path;
- no external presentation canvas/shadow remains;
- boat/sea memory stays readable after thumbnail reduction;
- current `postcard` semantics can consume it without new progression/collection state;
- GPT Work reviews it and the user explicitly approves the final runtime file.

### 9. Verification sequence

```text
GPT Work Generated/Edited
→ GPT Work Runtime-Asset Review
→ User Asset Approval
→ Notion Final Asset Record + Durable Binary Locator
→ IMPLEMENTATION_READY
→ CODEX-IMG-02
→ Implemented
→ 540×960 Runtime Screenshot
→ RUNTIME_VERIFIED
```

---

## 4. P2/P3 and deferred image requirements

- Additional Dawn/Sunset postcard faces → `P2 HOLD_NO_CURRENT_VARIANT_CONSUMER`.
- Main Menu static background → `NO_REQUIRED_AUTHORED_IMAGE`.
- Album authored background/fake photos → `REJECT_NOW`; use future runtime capture.
- Character/Pet selection portraits → `DERIVE_FROM_REAL_3D`.
- Character/Pet/Boat exact UV albedo maps → `BLOCKED_BY_PRODUCTION_GEOMETRY`.
- Sky/Sea bitmap maps → `CONDITIONAL` on actual runtime material technique.
- UI icon pack → `DEFER_NO_BINDING_CONSUMER`.
- App icon / Store / Marketing → `P3 HOLD` until release target + branding lock.

Do not promote these merely because GPT Work can generate images.

## 5. Codex Integration Queue

Codex instructions are in `docs/handoffs/2026-08-26-image-codex-integration-goals.md`.

```text
IMG-01 (3 final approved files) → CODEX-IMG-01
IMG-02 (1 final approved file) → CODEX-IMG-02
→ 540×960 runtime screenshot/play verification
→ GPT final review
```

Codex remains paused until all four active files are `IMPLEMENTATION_READY` with Notion readback and durable binary locators, unless the user explicitly narrows the batch.

## 6. Evidence ceiling

```text
IMAGE_GOAL_QUEUE = USER_APPROVED
GPT_WORK_EXECUTION = NEXT / NOT_RUN
NEW_FINAL_RUNTIME_IMAGE_GENERATION = NOT_RUN
APPROVED_REFERENCE_VISUALS = 4
APPROVED_SOURCE_IMAGES = 6
ACTIVE_P1_IMAGE_GOALS = 2
ACTIVE_P1_REQUIRED_FILES = 4
P0_AUTHORED_IMAGE_GOALS = 0
IMPLEMENTATION_READY_IMAGE_ASSETS = 0
IMPLEMENTED_IMAGE_ASSETS = 0
RUNTIME_VERIFIED_IMAGE_ASSETS = 0
CODEX_IMAGE_INTEGRATION = HOLD
```
