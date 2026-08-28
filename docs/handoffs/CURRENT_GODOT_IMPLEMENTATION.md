# Current Godot Product Implementation

> **CODEX IMAGE INTEGRATION COMPLETE.** The approved runtime images, P0 main-entry composition, and P1 album composition are merged into `main`, have passed GitHub Godot validation, and retain 540×960 runtime proof.

## Current state

```yaml
project: MY_LITTLE_BOAT
mode: CODEX_GODOT_PRODUCT_IMPLEMENTATION_HANDOFF
status: CURRENT_MAIN_RECONCILED_P0_MAIN_ENTRY_AND_P1_ALBUM_COMPOSITION_COMPLETE
current_work_router: docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md
screen_surface_coverage_owner: docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md
five_phase_execution_receipt: docs/handoffs/2026-08-27-work-five-phase-current-slice.md
internal_windows_package_contract: docs/superpowers/specs/2026-08-27-internal-windows-build-artifact-design.md
image_goal_source: docs/visual/2026-08-26-remaining-image-goals.md
codex_image_goal_source: docs/handoffs/2026-08-26-image-codex-integration-goals.md
image_asset_policy: CONSUMER_FIRST_ASSET
implementation_baseline: RESOLVE_CURRENT_COMPLETED_MAIN_AT_CODEX_START
implementation_owner: CODEX_GODOT_PRODUCT_IMPLEMENTATION_OWNER
final_review_owner: GPT_FINAL_IMPLEMENTATION_REVIEW
concurrent_pr_19: READ_ONLY_NO_ABSORPTION
image_generation_by_codex: ALLOWED_BY_USER_AUTO_ASSET_POLICY_2026_08_26
image_registration_policy: AUTO_CREATE_REVIEW_NOTION_AND_PROJECT_LOCAL
visual_reference_lock: HANDPAINTED_STORYBOOK_3D_DIORAMA + SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT + INDIGO_RAIN_REFLECTION_NIGHT
```

## Current screen-coverage readback

The current runtime-image and diorama integration remains complete. A fresh whole-screen audit now owns the next visual product decision at `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md`.

The user-approved `INDIGO_RAIN_REFLECTION` and four-time continuity board are planning-direction locks at `docs/visual/2026-08-28-indigo-rain-four-time-visual-lock.md`. Current `main` still uses the pre-lock Night background/tone. Do not call the new Night presentation runtime-implemented until a separate approved contract updates concrete consumers, tests, and 540×960 runtime evidence.

The user-approved companion-affection source is at `docs/2026-08-28-time-based-companion-affection-decision.md`; its quiet presentation is at `docs/2026-08-28-quiet-companion-affection-presentation-decision.md`. Current `GameState.add_photo`, `add_scenery`, and `add_letter` still raise action-based affection, and GameScene/AlbumView display `동반자 Lv`; this implementation is product-superseded and must not be extended. A future single contract owns active-foreground-voyage time accumulation, local persistence/migration, AlbumView `함께한 시간` plus quiet relation copy, removal of voyage-facing level feedback, focused tests, and runtime/Human evidence. It must not create a separate companion Scene, progress bar, growth popup, or rewards.

The user-approved passive Ambient Discovery direction is at `docs/2026-08-28-passive-ambient-discovery-decision.md`. Current `game_scene.gd` still creates a pending `letter`/`scenery`, shows `LetterButton`/`SceneryButton`, and drops the offer after a timer; that action-gated behavior is product-superseded. Do not extend it or treat it as Bottle behavior. A later single contract owns neutral local ambient-memory data, random low-density scheduling, small auto-fading notification, immediate local persistence, migration, UI retirement, tests, and runtime/Human evidence.

- `MLB-SCR-001` main entry is complete on `main` through [Issue #71](https://github.com/alsdmlals4-eng/MylittleBoat/issues/71) and [PR #72](https://github.com/alsdmlals4-eng/MylittleBoat/pull/72), merge commit `7a107873c49cb289fe9f4bc02bcda1c065f8d6e3`. `AtmosphereBackground` selects the approved 1024×1536 file for each time choice, `DioramaAnchor` presents the approved C+dog boat anchor, and compact Godot UI controls preserve identity, light, mood, and route semantics. Four 540×960 runtime captures, the focused contract, all existing contracts, three scene smokes, and GitHub validation passed.
- `MLB-SCR-010` album composition is complete on `main` through [Issue #75](https://github.com/alsdmlals4-eng/MylittleBoat/issues/75) and [PR #76](https://github.com/alsdmlals4-eng/MylittleBoat/pull/76), merge commit `69a2a7f2fdbfc251cfb6d4a3f446ab39dd080cbc`. It uses Godot UI/text, the selected approved atmosphere background, and actual record text; it adds no authored fake album images. Empty and populated 540×960 captures, focused contracts, full test suite, three scene smokes, and GitHub validation passed.
- Main-menu atmosphere backgrounds are the only post-audit bitmap family approved by the user's explicit 2026-08-28 request. No UI icon, portrait-only, UV texture, album filler, or other image family is implied.
- The screen inventory now uses the required screen × object × state × variation fields and confirms no other current runtime image family is missing. [PR #80](https://github.com/alsdmlals4-eng/MylittleBoat/pull/80) adds the main-menu atmosphere and album-composition contracts to the current CI suite; its exact head passed GitHub Godot validation. PR #19 remains `READ_ONLY_NO_ABSORPTION`.

## Binding pipeline

```text
RUNTIME_CONSUMER_OR_CLEAR_VISUAL_NEED
→ Codex image generation/editing when required
→ reference-lock runtime-asset review
→ project-local binary storage
→ Notion final asset registration + durable binary locator
→ IMPLEMENTATION_READY
→ GPT Work historical pre-integration handoff
→ CODEX-IMG-01 / CODEX-IMG-02
→ Godot import/wiring/runtime proof
→ GPT final implementation review
```

The user has authorized automatic image creation and final registration for assets Codex judges necessary. Each generated result must still be runtime-reviewed, stored both project-locally and in Notion Asset Library, and preserve the approved `HANDPAINTED_STORYBOOK_3D_DIORAMA` visual language plus its `SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT`. Use warm dark wood, rounded restrained silhouettes, matte hand-painted surfaces, a calm expansive horizon, and soft-manga chibi player/pet readability; do not drift into generic glossy CG or copy a reference board.

## Completed image integration goals

### CODEX-IMG-01 — Pet Cushion Runtime Surface Integration · Complete

Integrated exact paths:

```text
res://assets/images/decor/pet_cushion/cushion_stripe.png
res://assets/images/decor/pet_cushion/cushion_moon.png
res://assets/images/decor/pet_cushion/cushion_floral.png
```

Three cosmetic visual variants of the existing `pet_cushion` meaning. No stat/rarity/cost/gacha/care/progression semantics.

### CODEX-IMG-02 — Default Postcard Memory Face Integration · Complete

Integrated exact path:

```text
res://assets/images/decor/postcard/postcard_boat_bright.png
```

P1 integrates one default visual face only. Dawn/Sunset source compositions are P2 reuse candidates. Do not create a postcard variant selector/state merely to use them.

Full tasks/acceptance: `docs/handoffs/2026-08-26-image-codex-integration-goals.md`.

## Approved customization semantics waiting downstream

```text
CHARACTER_SELECTION_SET
= SOFT_HOODED_LAYER
+ SHORT_CAPE_SAILOR_LAYER_RHYTHM
+ LOOSE_KNIT_LONG_HAIR_MASS

PET_SELECTION_SET
= CAT
+ RABBIT
+ DOG
+ OTTER_LIKE

PET_CUSHION_CUSTOMIZATION
= THREE_APPROVED_VISUAL_VARIANTS / COSMETIC_ONLY

POSTCARD_P1
= ONE_APPROVED_DEFAULT_FACE / NO_VARIANT_SYSTEM
```

Exact Godot implementation details remain Codex choices after fresh-read. Preserve existing `pet_cushion` and `postcard` base meanings and compatibility.

## Deferred consumers

Do not invent consumers to absorb extra art:

- No additional Main Menu/Album authored bitmap family is required now. The approved main-menu atmosphere backgrounds are already integrated, and Album reuses the selected approved background with actual records; fake album filler remains prohibited.
- character/pet selection thumbnails derive from actual 3D previews.
- exact UV-specific character/pet/boat texture sheets are blocked by production geometry.
- sky/sea bitmap assets are conditional; prefer simple color/light/procedural route.
- UI icons are deferred until a binding consumer/readability need exists.
- app icon/store/marketing is P3 after release targets/branding lock.

## Completed integration receipt

```text
IMG_01_3_FILES = IMPLEMENTATION_READY
IMG_01_NOTION_READBACK = PASS
IMG_02_1_FILE = IMPLEMENTATION_READY
IMG_02_NOTION_READBACK = PASS
DURABLE_BINARY_LOCATORS = PASS
EXACT_ASSET_PATHS = FIXED
CODEX_INTEGRATION_GOALS = CURRENT
PR_19 = READ_ONLY_NO_ABSORPTION
```

At Codex start, fresh-read current completed main, Project Notion, actual Godot files/tests, open PRs and toolchain. Use semantic TDD and runtime proof for a newly approved product slice. GPT Work must stop before making Scene/Resource/GDScript product changes.

## Protected downstream scope

- rest-first Core Loop, voyage duration/rewards and mood meaning;
- Normal/Appreciation Camera semantics and input isolation;
- BoatSpace shared bob ownership;
- 8 decor slot IDs and existing six base item meanings/compatibility;
- low-pressure interaction reward isolation;
- care-obligation-free pet semantics;
- cosmetic visuals must not alter rewards, timer, progression pressure, social eligibility or care obligation;
- local-first core;
- PR #19 remains independent.
- New image work may proceed automatically only when it has a concrete runtime consumer or prevents a clear visual gap in the approved diorama. Do not generate speculative menu backgrounds, icon packs, UV texture sheets, or presentation-only art.

## Current Codex evidence

```text
IMAGE_GOAL_QUEUE = USER_APPROVED
GPT_WORK_IMAGE_PRODUCTION = COMPLETE
IMG_01_FINAL_FILES = 3 / 3 IMPLEMENTATION_READY
IMG_02_FINAL_FILES = 1 / 1 IMPLEMENTATION_READY
IMG_01_NOTION_READBACK = PASS
IMG_02_NOTION_READBACK = PASS
DURABLE_BINARY_LOCATORS = PASS
CODEX_IMG_01 = RUNTIME_VERIFIED_USER_APPROVED_MERGED_MAIN
CODEX_IMG_02 = RUNTIME_VERIFIED_USER_APPROVED_MERGED_MAIN
CODEX_LOCAL_WIRING_ASSETS = 4
IMPLEMENTED_IMAGE_ASSETS = 4_MERGED_MAIN
RUNTIME_VERIFIED_IMAGE_ASSETS = 4
CI = GITHUB_GODOT_VALIDATION_PASS_PR_48_AND_PR_49
FIRST_PRODUCTION_VISUAL_SLICE = CODEX_RUNTIME_CAPTURE_USER_APPROVED_MERGED_MAIN
HANDPAINTED_3D_RUNTIME_SLICE = USER_APPROVED_MERGED_MAIN
C_DOG_DEFAULT_RUNTIME_CAPTURE = PASS
C_DOG_HUMAN_VISUAL_APPROVAL = PASS
COSMETIC_IDENTITY_SELECTION = IMPLEMENTED_LOCAL_FIRST
DEFAULT_IDENTITY_C_DOG = PRESERVED
IDENTITY_RUNTIME_ASSET_LOCATORS = PASS
IDENTITY_AUTOMATED_CONTRACTS = PASS
IDENTITY_RUNTIME_CAPTURE = PASS
IDENTITY_REAL_DEVICE_MOBILE_QA = DEFERRED
REAL_DEVICE_TOUCH_QA = NOT_RUN
FOUR_TIME_ATMOSPHERE = MERGED_MAIN
FOUR_TIME_ATMOSPHERE_AUTOMATED = PASS
FOUR_TIME_RUNTIME_CAPTURE = PASS
FOUR_TIME_REAL_DEVICE_MOBILE_QA = DEFERRED
FOUR_TIME_HUMAN_COMFORT_REVIEW = NOT_RUN
FINAL_COMPOSITE_DECOR = MERGED_MAIN
FINAL_COMPOSITE_DECOR_RUNTIME_CAPTURE = PASS
INTERNAL_WINDOWS_PACKAGE = GITHUB_ACTIONS_ARTIFACT_PASS_MAIN
INTERNAL_WINDOWS_PACKAGE_HEADLESS_SMOKE = PASS_MAIN_B675249_RUN_33072278953_ARTIFACT_9646328971
INTERNAL_WINDOWS_PACKAGE_HUMAN_LAUNCH = NOT_RUN
```

## Current implementation packet

- `scripts/decor/decor_visual_assets.gd` maps the three exact cushion textures and one exact Bright Boat postcard texture, with a missing-path neutral fallback.
- `pet_cushion` keeps its existing base item ID and has only `stripe`, `moon`, and `floral` cosmetic appearances.
- `postcard` keeps one default Bright Boat front face and no appearance selector or new collection/progression state.
- `tests/test_runtime_image_asset_contract.gd` proves exact runtime texture paths, material consumers, fallback behavior, and core-state isolation.
- Headless import, all current contract scripts, and all three scene smokes passed. Live 540×960 captures exist for Stripe, Moon, Floral, and Bright Boat postcard at `docs/evidence/2026-08-26-runtime-image-integration/`; editor diagnostics report 0 errors and the user approved the runtime review. The scoped integration is merged to `main` through PR #34 at merge commit `647e403bba4b9a537052d16963b469be10236be4`; later PRs #48 and #49 also passed GitHub Actions Godot 4.7 validation.
- The First Production Visual Slice provided the bounded visual baseline. The user-approved C+dog final 2.5D route, cosmetic identity selection, four-time atmosphere, and final-composite decor correction now supersede it as the current runtime visual result. Reproducible 540×960 evidence remains technical proof; human/mobile comfort and touch review remain deferred.
- The approved default direction is C knit/long-hair player + dog. Its bounded 3D proof keeps the current placeholder/care-free semantics and stores 540×960 Normal/Appreciation capture at `docs/evidence/2026-08-26-c-storybook-dog-default/`; the user approved it and it merged to `main` through PR #36 at merge commit `0e5f6c7c47d5b1415a3954b3fd6aee84ec17ff8f`. It remains below final art and real-device touch QA.
- The final 2.5D storybook runtime set uses `assets/images/runtime/storybook/boat_c_dog_diorama_storybook.png` with `sea_bright_storybook.png`; Normal/Appreciation captures are at `docs/evidence/2026-08-26-final-2p5d-storybook-art/`. User approval, Notion final registration, SHA-256 provenance, and durable Git binary locators passed on 2026-08-26. Notion records: `MLB_FINAL_2P5D_C_DOG_BOAT_RUNTIME_V1` and `MLB_FINAL_2P5D_BRIGHT_SEA_RUNTIME_V1`.
- The internal Windows package route is limited to one x86_64 debug export preset and a GitHub Actions ZIP artifact containing the executable, PCK, and SHA-256 manifest. The exact current `main` commit `b6752495d121a2523f871475d4720c9fb1b2e573` passed in GitHub Actions run `33072278953`; downloaded artifact `9646328971` contained matching executable/PCK SHA-256 values from `SHA256SUMS.txt`, and `my_little_boat.exe --headless --quit-after 1` exited with code `0`. This is machine package evidence only; no Android/public-store/signing work and no Human Windows launch or mobile comfort claim are included.
- `BoatDecorPersistence` stores only cosmetic `boat_decor` and `boat_decor_appearances` in `user://boat_decor_v1.cfg`. The service handles missing or wrong-typed data as an empty boat; no voyage, reward, affection, memory, camera, or social state is persisted. Automated local restore proof passes, while real-device QA remains deferred by user.
- `RestingSoundscape` now owns a 16-second stereo authored `OceanBed` runtime candidate at a conservative -18 dB. It preserves the wave-first layer priority and does not alter voyage, reward, camera, or social state. Automated loop wiring passes; human headset/speaker/mobile listening remains `NOT_RUN`.
- Runtime identity selection is local-first: the main-menu `내 모습과 동반자` panel stores one approved player ID and one pet ID only in `user://identity_profile_v1.cfg`. C knit + dog preserves `FinalDioramaCard` unchanged; all other pairs use the shared boat/sea pass plus exactly one selected player card and one selected pet card. Five new 1024×1024 transparent runtime cards are individually registered in Notion Asset Library with SHA-256/provenance/durable repo locators. Normal and Appreciation GPU runtime captures for C+dog and B+otter are stored at `docs/evidence/2026-08-27-runtime-identity-selection/`. User mobile touch QA remains deferred.
- The four-time atmosphere layer is a process-lifetime pre-voyage choice only: Dawn / Bright / Sunset / Night apply the approved restrained environment, key-light, and shared backdrop modulation to the same scene. Bright preserves the approved Bright sea art; no image binary, map, shader, audio, timer, reward, identity, decor, social, or postcard-variant behavior was added. Eight OpenGL 540×960 Normal/Appreciation captures and hashes are at `docs/evidence/2026-08-27-four-time-atmosphere/`. Human comfort and real-device mobile QA remain deferred.
- Final-composite correction: the C+dog final composite hides only its detached `pet_corner` and `rail_accent` technical meshes, then renders the selected approved cushion surface and default postcard as flat storybook overlays. Four-time captures isolate test decor/identity state and fail before capture if required imported textures are unavailable. The focused contracts and a 540×960 floral-cushion/postcard capture are at `docs/evidence/2026-08-27-final-composite-decor/`. This correction merged to `main` through PR #48 at merge commit `eb84a86c219cdff696a2209446e282a6634302d3`; human/mobile QA remains deferred.
