# My Little Boat — GPT Work Image Production Handoff

Date: 2026-08-26
Handoff baseline main: `db30be07b9fc009013e349a47cf0b2217a7115d4`
Target worker: `GPT_WORK_NONCODING_VISUAL_OWNER`
Status: `READY_FOR_GPT_WORK_IMAGE_PRODUCTION`

## 1. User intent

The user wants the remaining **actual game-consumable images** completed in GPT Work before any Codex/Godot product implementation resumes.

Binding pipeline:

```text
fresh-read current project truth
→ execute approved Image Goal
→ generate/edit actual runtime asset
→ GPT visual/runtime-asset review
→ user asset approval
→ Notion Asset Library registration + durable binary locator
→ IMPLEMENTATION_READY
→ next Image Goal
→ when active image Goals are complete, prepare Codex integration handoff
→ stop before Godot product implementation
```

Do not make explanatory image sheets, mood boards, fake game screenshots, or extra illustrations merely to show progress.

## 2. Fresh-read bootstrap

Do not trust this handoff's baseline SHA as current truth. At GPT Work start:

1. Resolve current completed `main` of `alsdmlals4-eng/MylittleBoat`.
2. Read project `AGENTS.md`.
3. Read `docs/handoffs/CURRENT_GPT_WORK.md`.
4. Read `docs/visual/2026-08-26-remaining-image-goals.md`.
5. Read `docs/visual/2026-08-26-game-image-consumer-manifest.md`.
6. Read Notion Human Home `3c41b237-eb1c-8194-8b8e-d88362cafafa`.
7. Read Notion Game Image Blueprint `3c81b237-eb1c-81dd-bc85-d0eb927671c8`.
8. Read Notion Visual Production Checklist `3c81b237-eb1c-810c-b3f8-fce023a453cb`.
9. Read Notion Visual Bible `3c11b237-eb1c-81ae-97f3-dc28a0905304`.
10. Read Notion Asset Library `3c11b237-eb1c-8120-b7db-d48e11756146` and the six source records listed below.
11. Check current open PRs. PR #19 remains `READ_ONLY / NO_ABSORPTION` unless the user explicitly switches workstreams.

If current `main` or Notion has moved, reconcile before generating anything.

## 3. Current evidence ceiling

At handoff time:

```text
GOAL_QUEUE = USER_APPROVED
P0_AUTHORED_IMAGE_GOALS = 0
ACTIVE_P1_IMAGE_GOALS = 2
ACTIVE_P1_REQUIRED_FILES = 4
IMPLEMENTATION_READY_IMAGE_ASSETS = 0
IMPLEMENTED_IMAGE_ASSETS = 0
RUNTIME_VERIFIED_IMAGE_ASSETS = 0
CODEX_IMAGE_INTEGRATION = HOLD
GODOT_RUNTIME = NOT_RUN
```

Approved reference visuals are not runtime assets:

- Visual Proof 01
- Visual Proof 02
- Image A — Player + Pet Customization Board
- Image B — Boat / Sea / Four-Time Atmosphere Board

The six generated source images below have **user-approved motif/composition meaning**, but their current presentation-render form is not direct runtime material input.

## 4. Active Goal 1 — IMG-01 Pet Cushion Runtime Surface Set

Priority: `P1`
Execution order: **first**
Required final files: **3**

### Player/Product Goal

Let the player personalize the pet's resting corner with three calm cosmetic surface choices. The variants must never imply rarity, power, care obligation, currency, premium status, or progression.

### Actual Consumer

```text
Scene: scenes/game.tscn
Space: VoyageWorld/BoatSpace/BoatDecorSlots/PetCorner
System: Boat Decoration
Stable item meaning: pet_cushion
Planned material input: StandardMaterial3D.albedo_texture or equivalent simple material input
```

Planned runtime paths:

```text
res://assets/images/decor/pet_cushion/cushion_stripe.png
res://assets/images/decor/pet_cushion/cushion_moon.png
res://assets/images/decor/pet_cushion/cushion_floral.png
```

### Final production spec

Each file:

- `1024×1024`
- opaque sRGB
- flat fabric/surface art, not a rendered cushion object
- low-frequency, mobile-readable pattern
- repeat-friendly enough for simple UV/material mapping
- no outer cushion silhouette
- no raised rim
- no drop shadow
- no tuft/depression geometry baked into color
- no directional lighting baked into the albedo
- no text/logo/rarity/premium marks

### Source 1 — Stripe

Source record: `MLB_IMG_PET_CUSHION_STRIPE_SOURCE`
Generation locator: `gen_id 10069481-9195-4973-b149-66146910708b`
Observed source: 1254×1254 PNG
SHA-256: `ccc05bfb09cdf26b3cdf8c834cde252dee03ab656cdd20be62b2de28116cfa99`

Visual fingerprint to preserve:

- warm cream woven fabric base;
- broad desaturated dusty-blue vertical stripes;
- small sparse stitched wave/rope-like motifs;
- handmade watercolor/cloth texture;
- low saturation and quiet contrast.

Remove from final runtime asset:

- thick padded cream rim;
- blue outer piping;
- seam/edge geometry;
- volumetric cushion shading.

### Source 2 — Moon

Source record: `MLB_IMG_PET_CUSHION_MOON_SOURCE`
Generation locator: `gen_id 5aed1ba0-9ee3-4837-9e9d-cfabb2bc9c71`
Observed source: 1254×1254 PNG
SHA-256: `ff0327998969f5b8e034c887a1ec9067aefabc5f98a4238bf374204d316792a5`

Visual fingerprint to preserve:

- muted dusty-lavender fabric;
- one soft cream crescent-moon stitched motif near center;
- a few small cream star motifs and tiny dots;
- hand-stitched, matte, sleepy nighttime feeling;
- restrained pattern density.

Remove from final runtime asset:

- outer padded frame;
- inner seam rectangle;
- corner ties;
- cushion volume and directional shading.

### Source 3 — Floral

Source record: `MLB_IMG_PET_CUSHION_FLORAL_SOURCE`
Generation locator: `gen_id 15ff36bc-add1-473b-b076-a27a52c6cf52`
Observed source: 1254×1254 PNG
SHA-256: `3426a4463dddcb202b5b9c43a27612cd71203130647e0ca4a7f6c76947deca58`

Visual fingerprint to preserve:

- warm parchment/cream fabric;
- muted olive-green leaves and small sprigs;
- sparse tiny cream/yellow flowers;
- vintage hand-painted botanical feel;
- very low visual noise.

Remove from final runtime asset:

- olive padded frame;
- stitched inner border;
- tuft depressions and cushion volume;
- baked edge shadows.

### IMG-01 acceptance

Before asking for user approval, GPT Work must verify:

- exactly 3 separate flat surface assets exist;
- source motif identity is preserved without re-opening style direction;
- all presentation-space cushion geometry has been removed;
- patterns remain distinguishable after strong downscale;
- no gameplay/status/rarity semantics were introduced;
- final files are suitable as direct material color/albedo sources.

Then show the three assets to the user for explicit asset approval.

After approval:

- create/update one Asset Library record per final file;
- mark design/runtime-file status accurately;
- attach or otherwise provide a **durable binary locator that Codex can retrieve**;
- record final size, SHA-256, generation/edit provenance, planned `res://` path, rights/source, and approval receipt;
- set `IMPLEMENTATION_READY` only after Notion readback confirms the final binary/provenance locator.

## 5. Active Goal 2 — IMG-02 Default Postcard Memory Face

Priority: `P1`
Execution order: **after IMG-01 is approved and registered**
Required final files: **1**

### Player/Product Goal

The placed postcard reads as a quiet personal memory trace on the boat without creating a collectible score, rarity, new lore system, or postcard-variant UI.

### Actual Consumer

```text
Scene: scenes/game.tscn
System: Boat Decoration
Stable item meaning: postcard
Slot meaning: rail_accent
Planned material input: postcard front-face albedo_texture or equivalent face texture
```

Planned runtime path:

```text
res://assets/images/decor/postcard/postcard_boat_bright.png
```

### Final production spec

- `1024×768`
- 4:3
- opaque sRGB
- normalized postcard **face art** only
- a subtle painted paper border may remain as part of the face itself
- no external white presentation canvas
- no external drop shadow
- no readable text/logo
- no rarity/collection marks
- composition must survive reduction to a small object in the 3/4 camera.

### Approved Bright Boat source

Source record: `MLB_IMG_POSTCARD_BOAT_BRIGHT_SOURCE`
Generation locator: `gen_id 5514be9b-ca2e-48b6-86b5-64ac788c2059`
Observed source: 1448×1086 PNG
SHA-256: `1f0a0c9d5c658f58a55290d3a9dddeaca231630cd1158170cbc655ed6b823a3d`

Visual fingerprint to preserve:

- bright but gentle blue daytime sea;
- wide stable horizon with small distant islands;
- soft white cumulus clouds in pale blue sky;
- small dark wooden personal boat centered/lower-middle;
- lantern mast, tiny plant, mugs/cups, light cushion and small hanging memory details;
- broad water/sky area remains more important than the boat;
- matte hand-painted storybook rendering, not glossy CG.

Remove/normalize for final runtime face:

- external presentation margin/canvas;
- any drop shadow outside the intended card face;
- excessive tiny detail that will disappear at runtime scale.

### P2 postcard sources — do not produce now

Preserve but do not turn into active runtime files unless the user later approves a real multi-postcard consumer:

- Dawn source — `gen_id 68183ec8-8dff-425e-8954-02e75b358aee`, SHA-256 `4aefdf55a02f0d255de21250d68f1cbb3ac478db69e2d19d15da2eb0e7a8eff9`.
- Sunset source — `gen_id 311d5986-da71-43c2-95bd-6ed3a070d648`, SHA-256 `23058b8390c564a330c66257ff04a1ec38e0686eaf886f09b999b10c562b9131`.

### IMG-02 acceptance

Before user approval:

- exactly 1 Bright Boat runtime face exists;
- 4:3 composition is normalized;
- no external presentation-space canvas/shadow remains;
- calm horizon and sea-first hierarchy are preserved;
- no new postcard variant selector/state is implied;
- file remains readable at very small display size.

After approval, register it in Notion with a durable binary locator and only then mark it `IMPLEMENTATION_READY`.

## 6. Deferred categories — do not generate in this Work session by default

- Main Menu static background — `NO_REQUIRED_AUTHORED_IMAGE`.
- Album fake authored screenshots — future actual runtime capture.
- Character/Pet fake 2D portraits — derive from real production 3D previews.
- Character/Pet/Boat UV-specific albedo sheets — blocked by production geometry/UV/material consumer.
- Sky/Sea bitmap maps — conditional on actual runtime technique.
- UI icon pack — deferred until a binding consumer/readability need exists.
- App icon / store capsule / marketing art — P3, wait for release targets and branding lock.

Do not create any of the above simply because GPT Work can generate them.

## 7. Notion rules

Notion remains the human-facing image/approval canon.

For each final approved runtime image record, preserve:

```text
Asset ID
Name
Project = MY_LITTLE_BOAT
Record Type = ASSET
Category
Status
Approved
Decision
Reuse
Source
Rights / License
Prompt/provenance or NOT_RECORDED_BY_TOOL
Hash
Implementation Path
AI Note / exact runtime status
Preview or durable binary locator
Last Synced
Revision
```

Do not upgrade `IMPLEMENTED` or `RUNTIME_VERIFIED` from image approval alone.

## 8. When GPT Work may hand off to Codex

All must be true:

```text
IMG_01_FILES = 3 / IMPLEMENTATION_READY
IMG_01_NOTION_READBACK = PASS
IMG_02_FILE = 1 / IMPLEMENTATION_READY
IMG_02_NOTION_READBACK = PASS
DURABLE_BINARY_LOCATORS = PASS
EXACT_PLANNED_RES_PATHS = FIXED
CURRENT_CODEX_INTEGRATION_GOALS = READBACK_PASS
PR_19 = READ_ONLY_NO_ABSORPTION
```

Then GPT Work should:

1. update `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md` to `READY_FOR_CODEX_IMAGE_INTEGRATION` without prescribing exact internal Node/function implementation beyond approved consumer outcomes;
2. update `docs/handoffs/CURRENT_PLANNING_VISUAL_WORK.md` to show active image production complete;
3. sync Notion Project Plan / Production Handoff / Blueprint / Registry as appropriate;
4. verify any doc-only PR exact head and merge if the current approved work contract permits;
5. stop with `READY_FOR_CODEX_IMAGE_INTEGRATION` and return the exact Codex start instruction.

GPT Work must **not** implement Scene/Resource/GDScript or run Godot product changes itself.

## 9. Required GPT Work result packet

When Work stops, report:

```yaml
gpt_work_result:
  fresh_main_sha:
  img_01:
    files: []
    user_approval:
    notion_records: []
    durable_binary_locators: []
    status:
  img_02:
    files: []
    user_approval:
    notion_records: []
    durable_binary_locators: []
    status:
  p2_sources_preserved: []
  deferred_categories_unchanged: []
  github_docs_changed: []
  notion_pages_changed: []
  validation_evidence: []
  unresolved_findings: []
  codex_handoff_status: READY_FOR_CODEX_IMAGE_INTEGRATION | NOT_READY
```

## 10. Starter prompt for GPT Work

Use this as the first Work instruction:

> 현재 `alsdmlals4-eng/MylittleBoat`의 completed main과 Project Notion을 fresh-read하고 `docs/handoffs/CURRENT_GPT_WORK.md`를 현재 작업 진입점으로 사용해. 이번 단계는 Codex/Godot 구현이 아니라 승인된 Remaining Image Goal의 실제 runtime asset 제작 단계야. `IMG-01 Pet Cushion Runtime Surface Set` 3종부터 진행하고, 각 파일은 기존 승인 motif를 유지한 1024×1024 flat opaque sRGB surface로 만들어. 생성 후 runtime-asset 관점으로 검수하고 사용자 승인 전에는 IMPLEMENTATION_READY로 올리지 마. 사용자 승인 즉시 Notion Asset Library에 개별 정본 등록하고 Codex가 회수 가능한 durable binary locator까지 확보해. 그 다음 `IMG-02 Default Postcard Memory Face` Bright Boat 1장을 1024×768 4:3 runtime face로 같은 방식으로 완료해. Dawn/Sunset은 P2 reuse candidate로 보존하고, Main Menu 배경·가짜 캐릭터 초상·UI icon pack·UV-specific textures는 만들지 마. 두 Goal이 모두 IMPLEMENTATION_READY + Notion readback PASS가 되면 Codex handoff를 READY로 갱신하고 Godot 제품 구현은 하지 않은 채 결과 패킷을 반환해.
