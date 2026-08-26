# My Little Boat — Remaining Image Goals

Status: `GOAL_QUEUE_READY_FOR_USER_REVIEW / NO_NEW_IMAGE_GENERATION_THIS_TASK`
Date: 2026-08-26
Baseline main: `d4d5e57027e1c83d1ae3504fce484fd4a11d8015`
Base observed main: `05d44bba978f4cff0fc94ade8e54825f5d6c80f0`

## 1. Current-state reconstruction

Current runtime truth:

- `assets/images/` contains only `README.md`; production image binaries in repository = `0`.
- `main_menu.tscn` and `album.tscn` use `ColorRect` rather than authored background images.
- `game.tscn` uses color-only Environment/Ocean materials.
- `boat_space.tscn` uses primitive Boat/Avatar/Pet meshes and color-only `StandardMaterial3D`.
- `boat_decor_slot.gd` creates primitive decor and uses `albedo_color`; no current `albedo_texture` consumer exists.
- album photos are currently string records, not captured images.
- open PR #19 remains unrelated/read-only and is not part of this image workstream.

Therefore:

```text
IMPLEMENTED_GAME_IMAGE_ASSETS = 0
RUNTIME_VERIFIED_GAME_IMAGE_ASSETS = 0
```

## 2. Existing visual inventory

| Visual | Current class | Runtime disposition | Reuse decision |
| --- | --- | --- | --- |
| Approved Production Visual Proof 01 | `APPROVED` | reference only | `REUSE_AS_IS` as style/material/composition reference |
| Approved Production Visual Proof 02 | `APPROVED` | reference only | `REUSE_AS_IS` as silhouette/pet/decor reference |
| Image A — Player + Pet Customization Board | `APPROVED` | reference only | `REUSE_AS_IS` for character/pet identity semantics |
| Image B — Boat / Sea / Four-Time Atmosphere | `APPROVED` | reference only | `REUSE_AS_IS` for atmosphere/value hierarchy |
| older player/pet boards before the dog-inclusive approved Image A | `SUPERSEDED` | do not implement | `REJECT` as current asset source |
| planning/checklist infographic sheets | `REFERENCE_ONLY` | do not implement | `REJECT` as game asset |
| cushion stripe render | `NEEDS_REVISION` | not a valid flat albedo yet | `REUSE_WITH_EDIT` |
| cushion moon render | `NEEDS_REVISION` | not a valid flat albedo yet | `REUSE_WITH_EDIT` |
| cushion floral render | `NEEDS_REVISION` | not a valid flat albedo yet | `REUSE_WITH_EDIT` |
| postcard dawn render | `NEEDS_REVISION` | motif approved; file needs face-texture normalization | `REUSE_WITH_EDIT` |
| postcard boat bright render | `NEEDS_REVISION` | motif approved; file needs face-texture normalization | `REUSE_WITH_EDIT` |
| postcard boat sunset render | `NEEDS_REVISION` | motif approved; file needs face-texture normalization | `REUSE_WITH_EDIT` |

### Why the six approved generated images are not `IMPLEMENTATION_READY`

The cushion images contain the whole cushion form, seam, raised border and baked shading. Mapping them directly as `albedo_texture` would double-bake geometry/light and fight the 3D mesh.

The postcard images contain a complete illustrated card presentation with border/background treatment. The illustration is reusable, but the final runtime face asset must be normalized to the actual postcard surface so a Godot material is not given presentation-space shadow/background pixels.

The user approval is preserved as **design/motif approval**. Runtime assetization is an edit/normalization task, not a redesign.

## 3. Existing Solution First

### Current project

Adopt the approved motifs and existing stable decor semantics:

- `pet_cushion` item id;
- `postcard` item id;
- eight existing boat decor slot ids;
- current rest-first/no-stat/no-rarity/no-cost meaning.

### Base / shared material

No Base-owned project-specific cushion/postcard binary is a better identity match. Reuse Base process/evidence patterns, not generic visual trade dress.

### External/reference work

Reuse the already approved benchmark disposition only:

- `Spirit City` — attachment through avatar/personal space/companion, without XP pressure;
- `Dordogne` — authored surface and restrained technique;
- `SEASON` — simplification, silhouette/readability, believable light.

No new benchmark is required to re-open the already-approved visual style.

## 4. Alternative trade study

| Route | Description | Result |
| --- | --- | --- |
| A | generate static backgrounds, extra icons, portraits and more concept sheets now | `REJECT` — creates images before a binding consumer and increases mismatch/rework |
| B | assetize only planar/consumer-stable approved surfaces first | `ADOPT` — highest certainty, lowest rework, directly connected to existing decor semantics |
| C | pre-generate UV-specific character/boat/pet textures before production geometry exists | `REJECT_NOW / DEFER` — violates consumer-first and risks unusable UV/layout assets |

Recommended route: **B**.

## 5. Priority result

```text
P0_AUTHORED_IMAGE_GOALS = 0
```

There is no missing authored bitmap that blocks core gameplay verification today. The P0 blockers are production 3D/runtime implementation, not image generation.

The first actionable image work is P1 vertical-slice polish on surfaces whose gameplay meaning already exists.

---

# IMG-01 — Pet Cushion Runtime Surface Set

Priority: `P1`
Current state: `NEEDS_REVISION`
Reuse mode: `REUSE_WITH_EDIT`

## 1. Player / Product Goal

The player can make the pet's resting corner feel personally chosen while the pet remains a low-pressure resting companion. The three choices must communicate cozy preference only, never rarity, power, care obligation or monetization value.

## 2. Actual Consumer

- Scene: `scenes/game.tscn` → `VoyageWorld/BoatSpace/BoatDecorSlots/PetCorner`
- System: Boat Decoration
- Stable semantic item: `pet_cushion`
- Planned material consumer: the 3D `pet_cushion` visual material, normally through `StandardMaterial3D.albedo_texture` or an equivalent simple Godot material input selected by Codex.
- Planned paths:
  - `res://assets/images/decor/pet_cushion/cushion_stripe.png`
  - `res://assets/images/decor/pet_cushion/cushion_moon.png`
  - `res://assets/images/decor/pet_cushion/cushion_floral.png`

The variant mechanism is implementation work. It must preserve the stable `pet_cushion` meaning rather than turning variants into new gameplay categories.

## 3. Existing References

- Image A — pet cushion customization meaning and player/pet relationship.
- Proof 01 / Proof 02 — matte, low-noise, hand-painted surface target.
- approved generated cushion designs:
  - stripe + small wave embroidery, SHA-256 `ccc05bfb09cdf26b3cdf8c834cde252dee03ab656cdd20be62b2de28116cfa99`;
  - lavender moon + stars, SHA-256 `ff0327998969f5b8e034c887a1ec9067aefabc5f98a4238bf374204d316792a5`;
  - vintage floral, SHA-256 `3426a4463dddcb202b5b9c43a27612cd71203130647e0ca4a7f6c76947deca58`.

Use them as **pattern/color identity references**, not as direct albedo maps.

## 4. Required Assets

1. `cushion_stripe.png`
   - purpose: cream/soft-blue striped fabric with tiny wave motif;
   - target: 1024×1024 square source;
   - alpha: no; opaque sRGB albedo;
   - state/variant: stripe;
   - reuse: existing approved design with edit/regeneration.
2. `cushion_moon.png`
   - purpose: muted lavender fabric with restrained moon/star stitched motifs;
   - target: 1024×1024;
   - alpha: no;
   - state/variant: moon;
   - reuse: existing approved design with edit/regeneration.
3. `cushion_floral.png`
   - purpose: cream/olive low-density floral fabric;
   - target: 1024×1024;
   - alpha: no;
   - state/variant: floral;
   - reuse: existing approved design with edit/regeneration.

All three must be **surface art**, not a rendered cushion object. No perspective, rim, drop shadow, tuft depth, baked directional lighting or background.

## 5. Must Preserve

- approved three motif identities;
- hand-painted storybook texture;
- low saturation / warm-cool balance;
- quiet non-mascot pet role;
- no gameplay/stat difference between variants.

## 6. Must Not Introduce

- rarity glow, badge, stars as rarity rating, prices or premium framing;
- pet needs/care state;
- new pet species;
- brand/logo/text;
- baked 3D cushion geometry or directional light.

## 7. Quality Target

- production-use albedo source, not a concept render;
- remains readable on a small cushion at the 540×960 portrait gameplay target;
- motif frequency low enough not to create visual noise;
- compatible with neutral UV/triplanar/simple mapping without obvious presentation-space artifacts.

## 8. Acceptance Criteria

- exactly three approved variants exist as separate flat source images;
- no rendered cushion edge/shadow remains;
- each file can plausibly feed a Godot material directly;
- the three variants are distinguishable after strong downscale;
- visual language matches Image A/Proofs without copying another game's trade dress;
- file naming and path contract are stable.

## 9. Verification

```text
Generated
→ Reviewed
→ Approved
→ Notion Registered
→ Implementation Ready
→ CODEX-IMG-01 Implemented
→ Runtime Verified
```

---

# IMG-02 — Postcard Memory Face Set

Priority: `P1`
Current state: `NEEDS_REVISION`
Reuse mode: `REUSE_WITH_EDIT`

## 1. Player / Product Goal

Placed postcards should read as small, personal memory traces on the boat, reinforcing attachment without becoming a collectible scoreboard or covering the sea-first composition.

## 2. Actual Consumer

- Scene: `scenes/game.tscn` → Boat Decoration rail slot (`rail_accent`) / postcard visual.
- System: Boat Decoration.
- Stable semantic item: `postcard`.
- Planned material consumer: postcard front-face material / `albedo_texture` or equivalent.
- Planned paths:
  - `res://assets/images/decor/postcard/postcard_dawn.png`
  - `res://assets/images/decor/postcard/postcard_boat_bright.png`
  - `res://assets/images/decor/postcard/postcard_boat_sunset.png`

Variant selection remains cosmetic. Codex may implement the smallest data representation that preserves the base `postcard` semantics.

## 3. Existing References

- Image B — dawn/bright/sunset atmosphere and stable horizon hierarchy.
- Proof 01 / Proof 02 — painted surface language and low visual noise.
- approved generated postcard designs:
  - dawn sea, SHA-256 `4aefdf55a02f0d255de21250d68f1cbb3ac478db69e2d19d15da2eb0e7a8eff9`;
  - bright boat/sea, SHA-256 `1f0a0c9d5c658f58a55290d3a9dddeaca231630cd1158170cbc655ed6b823a3d`;
  - sunset boat/sea, SHA-256 `23058b8390c564a330c66257ff04a1ec38e0686eaf886f09b999b10c562b9131`.

Use composition/color as approved reference. Remove presentation-space shadow/background from the final face texture.

## 4. Required Assets

1. `postcard_dawn.png` — 4:3 face art, target 1024×768, opaque sRGB.
2. `postcard_boat_bright.png` — 4:3 face art, target 1024×768, opaque sRGB.
3. `postcard_boat_sunset.png` — 4:3 face art, target 1024×768, opaque sRGB.

A small painted paper border may be part of the **postcard face itself**. External canvas/background/drop shadow may not.

## 5. Must Preserve

- stable calm horizon;
- same-world hand-painted style;
- Dawn/Bright/Sunset semantic identities already approved;
- small-memory role, not progression reward.

## 6. Must Not Introduce

- text or readable brand/logo;
- collectible rarity symbols;
- dramatic weather/threat;
- new character/boat lore that becomes canon by accident;
- external drop shadow/background baked around the card.

## 7. Quality Target

- directly usable on the planar postcard face;
- main composition survives reduction to a very small object in 3/4 camera;
- no high-frequency details that turn to noise;
- border treatment remains visible but does not consume most of the tiny texture.

## 8. Acceptance Criteria

- three normalized, separate 4:3 face files exist;
- no presentation background/shadow remains outside the intended card face;
- each is visibly different at thumbnail scale;
- image still reads as a memory trace when small;
- file paths and consumer meaning are fixed.

## 9. Verification

```text
Generated
→ Reviewed
→ Approved
→ Notion Registered
→ Implementation Ready
→ CODEX-IMG-02 Implemented
→ Runtime Verified
```

---

## 6. Deferred / not current Image Goals

### Main Menu background

Disposition: `REJECT_NOW / NO_REQUIRED_AUTHORED_IMAGE`.

Current consumer is `ColorRect`; changing it to a static illustrated background would invent a consumer and risk showing a different visual truth from the actual 3D game. Prefer current simple background or a future live 3D scene if product implementation chooses it. Re-open only after an explicit consumer decision.

### Album background

Disposition: `REJECT_NOW`.

Album is currently text summary. The meaningful images should eventually be player/runtime captures, not authored replacement screenshots.

### Character / pet selection portraits

Disposition: `REJECT_FAKE_2D_ASSET`.

Use previews derived from the actual production 3D avatar/pet so selection thumbnails match what the player receives.

### Character / pet / boat UV-specific albedo

Disposition: `BLOCKED_BY_PRODUCTION_GEOMETRY`.

Do not pre-generate exact UV sheets. If Codex later establishes a stable bitmap consumer, return to GPT with the exact mesh/UV/material contract and open a new Image Goal before final asset integration.

### Sky / sea texture maps

Disposition: `CONDITIONAL`.

Use Image B as reference. Prefer colors/lights/simple/procedural material. Generate bitmap panorama/normal/noise only if a real shader/material consumer is chosen and simple methods fail the approved runtime target.

### UI icon pack

Disposition: `DEFER / NOT_REQUIRED_NOW`.

Current text buttons are functional. Icon+text is a possible future polish route, but generating icons now would create work before a binding UI consumer and is not required for vertical-slice validation.

### App / Store / marketing art

Disposition: `P3 / HOLD`.

Do not produce until release platform/store requirements and branding lock are explicit.

## 7. Codex Integration Queue

After each Image Goal becomes `IMPLEMENTATION_READY`, use the matching integration goal in `docs/handoffs/2026-08-26-image-codex-integration-goals.md`.

Order:

```text
IMG-01 → CODEX-IMG-01
IMG-02 → CODEX-IMG-02
then runtime screenshot / mobile portrait verification
```

Godot work remains paused until the user has reviewed/approved this queue and GPT has finished the active image assets.

## 8. Evidence ceiling

```text
IMAGE_GOAL_QUEUE = PLANNED
NEW_IMAGE_GENERATION_THIS_TASK = NOT_RUN
APPROVED_REFERENCE_VISUALS = 4
APPROVED_MOTIF_SOURCE_IMAGES = 6
IMPLEMENTATION_READY_IMAGE_ASSETS = 0
IMPLEMENTED_IMAGE_ASSETS = 0
RUNTIME_VERIFIED_IMAGE_ASSETS = 0
P0_AUTHORED_IMAGE_GOALS = 0
ACTIVE_P1_IMAGE_GOALS = 2
```
