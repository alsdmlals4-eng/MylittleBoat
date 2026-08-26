# My Little Boat — Remaining Image Goals

Status: `GOAL_QUEUE_READY_FOR_USER_REVIEW / NO_NEW_IMAGE_GENERATION_THIS_TASK`
Date: 2026-08-26
Baseline main: `d4d5e57027e1c83d1ae3504fce484fd4a11d8015`
Base observed main: `05d44bba978f4cff0fc94ade8e54825f5d6c80f0`

## 1. Current-state reconstruction

Current runtime truth:

- `assets/images/` contains only `README.md`; production image binaries = `0`.
- no runtime `.png`, `Texture2D`, `TextureRect` or `albedo_texture` consumer was observed in current product files.
- Main Menu and Album backgrounds are `ColorRect`.
- Game World/Ocean use color-only materials.
- Boat/Avatar/Pet/Decor are primitive technical placeholders with color-only materials.
- photo/album state is text records, not actual captured images.
- PR #19 remains unrelated `OPEN / READ_ONLY / NO_ABSORPTION`.

```text
IMPLEMENTATION_READY_IMAGE_ASSETS = 0
IMPLEMENTED_IMAGE_ASSETS = 0
RUNTIME_VERIFIED_IMAGE_ASSETS = 0
P0_AUTHORED_IMAGE_GOALS = 0
```

The current P0 visual blockers are production 3D/runtime work, not missing authored bitmaps.

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

### Why the current cushion/postcard renders are not implementation-ready

The cushion sources include a whole rendered cushion, seam, raised rim, depth and directional shading. Direct albedo use would double-bake geometry/light.

The postcard sources include presentation-space card/canvas treatment. Their illustration is reusable, but a runtime face file must be normalized to the actual postcard surface.

User approval remains valid at motif/composition level; runtime assetization is a controlled edit, not a redesign.

## 3. Alternative trade study

| Route | Meaning | Decision |
| --- | --- | --- |
| A | create static backgrounds, icon packs, fake portraits and more explanatory sheets now | `REJECT` — no binding consumer / rework risk |
| B | assetize only approved surfaces whose gameplay meaning/consumer is already stable | `ADOPT` |
| C | pre-generate UV-specific character/pet/boat textures before production geometry exists | `REJECT_NOW / DEFER` |

Route B is the smallest path that produces real game-consumable image files without forcing new unrelated systems.

---

# IMG-01 — Pet Cushion Runtime Surface Set

Priority: `P1`
State: `NEEDS_REVISION`
Reuse: `REUSE_WITH_EDIT`
Required images: `3`

### 1. Player / Product Goal

The pet corner should feel personally chosen through three calm cushion appearances, while the pet remains a no-obligation resting companion. Appearance choice must never imply power, rarity, care state, price or progression advantage.

### 2. Actual Consumer

- Scene: `scenes/game.tscn` → `VoyageWorld/BoatSpace/BoatDecorSlots/PetCorner`
- System: Boat Decoration
- Stable base item: `pet_cushion`
- Planned consumer: `pet_cushion` 3D visual material, using `StandardMaterial3D.albedo_texture` or the smallest equivalent material input selected by Codex.
- Planned files:
  - `res://assets/images/decor/pet_cushion/cushion_stripe.png`
  - `res://assets/images/decor/pet_cushion/cushion_moon.png`
  - `res://assets/images/decor/pet_cushion/cushion_floral.png`
- Fallback: existing neutral color-only `pet_cushion` remains usable if a texture is unavailable.

The visual-variant state representation is Codex implementation detail. It must reuse the stable `pet_cushion` meaning rather than creating new item categories, rarity or economy.

### 3. Existing References

- Image A: approved pet-cushion customization meaning.
- Proof 01/02: matte, hand-painted, low-noise surface language.
- Stripe source SHA-256 `ccc05bfb09cdf26b3cdf8c834cde252dee03ab656cdd20be62b2de28116cfa99`.
- Moon source SHA-256 `ff0327998969f5b8e034c887a1ec9067aefabc5f98a4238bf374204d316792a5`.
- Floral source SHA-256 `3426a4463dddcb202b5b9c43a27612cd71203130647e0ca4a7f6c76947deca58`.

Use the source images for pattern/color identity only, not as direct material maps.

### 4. Required Assets

1. `cushion_stripe.png`
   - cream + soft-blue stripe; tiny wave embroidery cue;
   - 1024×1024, opaque sRGB;
   - flat, low-frequency, repeat-friendly surface art;
   - no alpha required.
2. `cushion_moon.png`
   - muted lavender; restrained stitched moon/stars;
   - 1024×1024, opaque sRGB;
   - flat, low-frequency, repeat-friendly surface art.
3. `cushion_floral.png`
   - cream/olive; sparse small botanical motifs;
   - 1024×1024, opaque sRGB;
   - flat, low-frequency, repeat-friendly surface art.

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

- actual material-source quality, not concept-sheet quality;
- usable on simple current/future cushion geometry without obvious presentation-space artifacts;
- remains distinct after aggressive reduction at the 540×960 portrait gameplay target;
- motif density low enough not to compete with sea/horizon.

### 8. Acceptance Criteria

PASS only when:

- exactly three separate flat surface files exist;
- no rendered cushion geometry/shadow remains;
- files can plausibly feed a Godot material directly;
- Stripe/Moon/Floral remain identifiable at small scale;
- file names/paths are fixed;
- no canon or reward/economy semantics changed.

### 9. Verification

```text
Generated/Edited
→ GPT Reviewed
→ User Approved
→ Notion Registered
→ IMPLEMENTATION_READY
→ CODEX-IMG-01
→ Implemented
→ 540×960 Runtime Screenshot
→ RUNTIME_VERIFIED
```

---

# IMG-02 — Default Postcard Memory Face

Priority: `P1`
State: `NEEDS_REVISION`
Reuse: `REUSE_WITH_EDIT`
Required images: `1`

### 1. Player / Product Goal

The existing `postcard` decor should visibly carry one quiet personal memory image, adding attachment to the boat without introducing a postcard collection/variant system just to consume extra art.

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
- approved Bright Boat source SHA-256 `1f0a0c9d5c658f58a55290d3a9dddeaca231630cd1158170cbc655ed6b823a3d`.
- Dawn source SHA-256 `4aefdf55a02f0d255de21250d68f1cbb3ac478db69e2d19d15da2eb0e7a8eff9` and Sunset source SHA-256 `23058b8390c564a330c66257ff04a1ec38e0686eaf886f09b999b10c562b9131` remain approved P2 reuse candidates only.

### 4. Required Assets

1. `postcard_boat_bright.png`
   - bright calm sea + small personal boat memory composition;
   - 1024×768, 4:3, opaque sRGB;
   - normalized to the card face itself;
   - a small painted paper border may belong to the face, but no external canvas/drop shadow may remain.

### 5. Must Preserve

- approved bright-boat composition and calm sea identity;
- stable horizon;
- hand-painted storybook treatment;
- postcard = quiet decor/memory trace, not progression reward.

### 6. Must Not Introduce

- external presentation background/drop shadow;
- readable brand/logo/text;
- rarity/collectible scoring;
- dramatic threat weather;
- new character, place or boat lore that becomes canon accidentally;
- new postcard-variant system in P1.

### 7. Quality Target

- directly usable on a planar postcard face;
- strong simple silhouette/value grouping surviving very small 3/4-camera display;
- no high-frequency details that become noise.

### 8. Acceptance Criteria

PASS only when:

- one normalized 4:3 face file exists at the fixed path;
- no external presentation canvas/shadow remains;
- boat/sea memory is still readable after thumbnail reduction;
- current `postcard` behavior can consume it without requiring new progression/collection state;
- visual hierarchy remains subordinate to the boat/sea scene.

### 9. Verification

```text
Generated/Edited
→ GPT Reviewed
→ User Approved
→ Notion Registered
→ IMPLEMENTATION_READY
→ CODEX-IMG-02
→ Implemented
→ 540×960 Runtime Screenshot
→ RUNTIME_VERIFIED
```

---

## 4. P2 / P3 and deferred image requirements

### P2 — Additional Postcard Faces

Status: `HOLD_NO_CURRENT_VARIANT_CONSUMER`.

Approved Dawn and Sunset compositions are preserved for reuse. Open a P2 Image Goal only after the product has a real reason to show more than one postcard face; do not create a selection system solely to use two extra images.

### Main Menu static background

Status: `REJECT_NOW / NO_REQUIRED_AUTHORED_IMAGE`.

Current ColorRect is valid. Do not invent a static-image consumer solely to increase image count. A future live 3D/menu presentation can be evaluated in implementation if needed.

### Album authored background / fake photos

Status: `REJECT_NOW`.

Album memories should ultimately use runtime capture rather than authored fake voyage screenshots.

### Character / Pet selection portraits

Status: `REJECT_FAKE_2D_ASSET`.

Derive selection thumbnails from actual production 3D previews so the selection UI matches the asset received in game.

### Character / Pet / Boat exact UV albedo maps

Status: `BLOCKED_BY_PRODUCTION_GEOMETRY`.

Do not pre-generate UV-specific sheets. Current pre-Codex asset queue deliberately avoids image files that cannot be guaranteed usable. If a later stable geometry/material contract proves a bitmap is necessary, create a new Image Goal before that asset is finalized.

### Sky / Sea bitmap maps

Status: `CONDITIONAL`.

Use Image B as the visual reference. Prefer color/light/simple/procedural material. Open a new Image Goal only if the selected runtime technique explicitly needs panorama/normal/noise maps.

### UI icon pack

Status: `DEFER_NO_BINDING_CONSUMER`.

Current text controls are functional. Create icons only if an actual icon consumer and readability/polish requirement are established.

### App icon / Store / Marketing

Priority: `P3 / HOLD`.

An application icon is a real eventual release asset, and platform/store art may also be required, but exact platform/branding requirements are not locked. Re-open as a P3 Image Goal when release targets and brand package are explicit; do not pre-empt P1 runtime validation.

## 5. Codex Integration Queue

Codex instructions are in `docs/handoffs/2026-08-26-image-codex-integration-goals.md`.

```text
IMG-01 (3 files) → CODEX-IMG-01
IMG-02 (1 file) → CODEX-IMG-02
→ 540×960 runtime screenshot/play verification
→ GPT final review
```

Codex remains paused until the user approves this Goal Queue and GPT completes/gets approval/Notion registration for the active files.

## 6. Evidence ceiling

```text
IMAGE_GOAL_QUEUE = READY_FOR_USER_REVIEW
NEW_IMAGE_GENERATION_THIS_TASK = NOT_RUN
APPROVED_REFERENCE_VISUALS = 4
APPROVED_SOURCE_IMAGES = 6
ACTIVE_P1_IMAGE_GOALS = 2
ACTIVE_P1_REQUIRED_FILES = 4
P0_AUTHORED_IMAGE_GOALS = 0
IMPLEMENTATION_READY_IMAGE_ASSETS = 0
IMPLEMENTED_IMAGE_ASSETS = 0
RUNTIME_VERIFIED_IMAGE_ASSETS = 0
```
