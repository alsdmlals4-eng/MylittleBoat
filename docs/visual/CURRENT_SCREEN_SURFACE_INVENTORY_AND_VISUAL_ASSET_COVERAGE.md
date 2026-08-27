# My Little Boat — Current Screen Surface Inventory and Visual Asset Coverage

Status: `CANONICAL_VISUAL_COVERAGE_OWNER / 2026-08-28`
Issue: [#71](https://github.com/alsdmlals4-eng/MylittleBoat/issues/71)
Scope: current `main` vertical slice only. Runtime image production is always consumer-first.

## 0. Authority and audit result

This is the project-owned canonical coverage owner for the current target build. It is a screen-first companion to Base `GAME_VISUAL_ASSET_COVERAGE_CHECKLIST.md`, not a second asset ledger.

Authority order used for this readback is the active project `AGENTS.md`, Project Notion Home / Visual Bible, current completed `main`, actual Godot scenes and tests, then Base contracts. The requested Base subordinate file `docs/knowledge/game-development/GAME_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_MATRIX.md` is absent from Base latest `main` at audit time. A historical copy exists at Base commit `d0d337eb`, but is not treated as current authority. The current Base coverage checklist remains the applied cross-check contract.

```text
SCREEN_SURFACE_INVENTORY_FIRST
SCREEN_LEVEL_COMPOSITION_REQUIRED
ACTUAL_CONSUMER_REQUIRED
NO_DUPLICATE_IMAGE_GENERATION
USER_PREAPPROVED_NEEDED_CURRENT_SLICE_ASSET_PRODUCTION
```

### Current target build

The target is the existing mobile-portrait local-first rest slice. A first-time player chooses an identity, time of day, and mood; enters a five-minute 3/4 boat diorama; may rest, use optional low-pressure activities, and leave a memory; then continues or starts another voyage. Delayed bottle social and release/platform flows are not current-build surfaces.

### Required tracking fields

Every current or future player-facing surface is recorded through the same screen-first unit: `screen_id`, `screen_family`, `screen_name`, `project_stage`, `priority`, `flow_entry`, `flow_exit`, `player_goal`, `player_question`, `consumer_kind`, `consumer_surface`, `screen_design_reference`, `runtime_consumer`, `existing_evidence`, `coverage_status`, `notion_destination`, `repository_destination`, and `blockers`.

Every runtime asset family records the consumer, object, state, variation, implementation method, dimensions/alpha/color space, reuse/provenance, approval state, engine connection, and target-resolution evidence. A design sheet or Notion reference never substitutes for a Godot consumer; a runtime image never substitutes for a Visual Bible or release-art deliverable.

### Result at a glance

| Result | State | Meaning |
| --- | --- | --- |
| P0 runtime diorama | `COVERED_EXISTING` | Approved C+dog storybook boat, sea, decor, Normal/Appreciation captures, and actual consumers are present. |
| P0 main entry composition | `COVERED_EXISTING` | The four approved atmosphere backgrounds now switch with the selected time, and the existing C+dog diorama is visible above the compact menu controls. |
| P0 result / next-voyage state | `COVERED_EXISTING` | Same gameplay surface exposes completion copy and `NextVoyageButton`; contract evidence proves the state. |
| P1 album presentation | `GAP_NONBLOCKING` | Functional text record / empty state exists. It needs a later Godot UI composition pass; it does not need fake album images. |
| New runtime bitmap requirement | `0` | The actual current consumers have been rechecked. Existing approved boat, sea, identity, cushion, postcard, and now connected main-menu backgrounds cover them; UI controls use Godot theme resources rather than unnecessary bitmap files. |

## 1. Target screen inventory

`SCREEN_DESIGN_REFERENCE` is whole-screen composition evidence. `RUNTIME_COMPONENT_ASSET` is a directly loaded binary. `GODOT_UI` and `TEXT_LAYER` are engine-rendered and do not imply a new PNG.

| screen_id / screen_name | family / stage / priority / consumer kind | player goal and question | entry → exit | actual consumer and whole-screen evidence | canonical destinations | coverage / blocker |
| --- | --- | --- | --- | --- | --- | --- |
| `MLB-SCR-001` / Main entry | `CURRENT_VERTICAL_SLICE` / P0 / `GAME_RUNTIME` | “What kind of quiet place is this, and how do I begin?” | launch or next voyage → mood choice | `scenes/main_menu.tscn`, `scripts/ui/main_menu.gd`; four [540×960 runtime captures](../evidence/2026-08-28-main-menu-composition/); four approved 1024×1536 atmosphere backgrounds | Notion Home + Visual Bible + Asset Library; this owner + `main_menu.tscn` | `COVERED_EXISTING`. `AtmosphereBackground` swaps the approved Dawn/Bright/Sunset/Night files, while `DioramaAnchor` uses the approved C+dog boat image. Godot StyleBox/labels provide controls without an unnecessary UI bitmap family. |
| `MLB-OVR-002` / Identity and light selection | `CURRENT_VERTICAL_SLICE` / P0 / `GAME_RUNTIME` | “Who is with me, and what light do I want today?” | main entry button/time option → close or mood choice | `IdentityPanel`, `PlayerStyleOption`, `PetTypeOption`, `TimeOfDayOption`; `IdentityVisualCatalog`; `test_main_menu_identity_contract.gd`, `test_main_menu_time_of_day_contract.gd` | Notion Home + Visual Bible; this owner + `main_menu.tscn` | `COVERED_EXISTING`. Three player and four pet choices are local cosmetic state; four time choices are non-reward visual tone only. Screen-level composition inherits `MLB-SCR-001` gap. |
| `MLB-SCR-003` / Normal voyage diorama | `CURRENT_VERTICAL_SLICE` / P0 / `GAME_RUNTIME` | “Can I rest in my own boat with my companion and sea in view?” | mood selection / album return → Appreciation, optional activity, album, or completion | `scenes/game.tscn`, `scenes/boat_space.tscn`, `scripts/voyage/game_scene.gd`; approved boat/sea/identity assets; [Normal evidence](../evidence/2026-08-27-four-time-atmosphere/bright_normal_540x960.png) | Notion Home + Visual Bible + Asset Library; this owner + game/asset paths | `COVERED_EXISTING`. Player, pet, boat, horizon, timer, and optional controls are visible at 540×960. |
| `MLB-OVR-004` / Appreciation Camera | `CURRENT_VERTICAL_SLICE` / P0 / `GAME_RUNTIME` | “Can I reduce UI and quietly look at the sea without changing the voyage?” | `AppreciationButton` → same button | `AppreciationCameraRig`, `boat_camera_controller.gd`; [Appreciation evidence](../evidence/2026-08-27-four-time-atmosphere/bright_appreciation_540x960.png); `test_camera_input_contract.gd` | Notion Home + Visual Bible; this owner + `game.tscn` | `COVERED_EXISTING`. It hides nonessential controls while preserving the timer/reward rules and supports mobile drag. |
| `MLB-OVR-005` / Boat decoration panel | `CURRENT_VERTICAL_SLICE` / P1 / `GAME_RUNTIME` | “Where can I place or change a small personal object?” | `DecorButton` → apply, clear, close, or Appreciation | `DecorPanel`, `BoatDecorSlots`, `boat_decor_catalog.gd`, `decor_visual_assets.gd`; `test_boat_life_ui_contract.gd`, `test_runtime_image_asset_contract.gd` | Notion Asset Library + Production Handoff; this owner + decor scripts/assets | `COVERED_EXISTING`. Eight existing slots, three cushion variants, and one postcard face have exact consumers. Technical presentation polish is deferred, not a bitmap gap. |
| `MLB-OVR-006` / Low-pressure interaction panel | `CURRENT_VERTICAL_SLICE` / P1 / `GAME_RUNTIME` | “What small action could I do, if I want to?” | `InteractButton` → perform or close | `InteractionPanel`, `low_pressure_interactable.gd`, `boat_rail_interactable.gd`; `test_low_pressure_interaction_contract.gd` | Notion Home; this owner + interaction scripts | `COVERED_EXISTING`. Actions do not create pressure, rewards, or care obligations. |
| `MLB-OVR-007` / Quiet fishing state | `CURRENT_VERTICAL_SLICE` / P1 / `GAME_RUNTIME` | “Do I want to wait for a bite, cancel, or keep the catch as a memory?” | `FishingButton` → wait / bite / catch / cancel | `FishingButton`, `FishingStatusLabel`, `fishing_session.gd`; `test_fishing_session.gd`, `test_game_scene_contract.gd` | Notion Home; this owner + `game_scene.gd` | `COVERED_EXISTING`. Text and dynamic button labels are the correct current feedback layer; no icon/VFX requirement is justified. |
| `MLB-OVR-008` / Ambient discovery offer | `CURRENT_VERTICAL_SLICE` / P1 / `GAME_RUNTIME` | “Do I want to keep this quiet letter or scenery memory?” | scheduled discovery → record or expiry | `LetterButton`, `SceneryButton`, `GameState`; `test_game_scene_contract.gd` | Notion Home; this owner + `game_scene.gd` | `COVERED_EXISTING`. Text-led offer is deliberate. Bottle/social presentation remains a separate deferred system. |
| `MLB-OVR-009` / Voyage completion | `CURRENT_VERTICAL_SLICE` / P0 / `GAME_RUNTIME` | “Did this rest become a record, and may I stay or begin again?” | timer reaches zero → `NextVoyageButton` or album | `GameState.complete_voyage`, `NextVoyageButton`, `scripts/voyage/game_scene.gd`; `test_game_scene_contract.gd` | Notion Home + Production Handoff; this owner + `game_scene.gd` | `COVERED_EXISTING`. Current completion is a state of the normal surface, not a separate reward bitmap. |
| `MLB-SCR-010` / Album archive | `CURRENT_VERTICAL_SLICE` / P1 / `GAME_RUNTIME` | “What has this voyage left with me?” | `AlbumButton` → return to sea | `scenes/album.tscn`, `scripts/ui/album_view.gd`; [empty-state capture](../evidence/2026-08-27-screen-surface-audit/album-empty_540x960.png); `test_album_memory_contract.gd` | Notion Home + Production Handoff; this owner + `album.tscn` | `GAP_NONBLOCKING`. Functional dynamic text and empty state exist, but later `GODOT_UI + TEXT_LAYER` composition should better carry the hand-painted memory feeling. Runtime captures, not authored fake photos, remain the correct future image source. |

## 2. Non-applicable and deferred screen families

Every common family was checked. `NOT_APPLICABLE` means absent from the current target build, not permanently rejected from the product.

| family | state | reason |
| --- | --- | --- |
| Boot / splash / custom loading | `NOT_APPLICABLE` | No project-owned boot, async loading, or progress surface exists in the current three-scene local slice. Engine startup is not a player-facing authored screen. |
| New game / save slot / load / profile conflict | `NOT_APPLICABLE` | One local identity/decor persistence path exists; no slot, overwrite, delete, or cloud-conflict flow is implemented. |
| Character build / loadout / equipment comparison | `NOT_APPLICABLE` | Current character and pet choices are cosmetic identity selection, already covered by `MLB-OVR-002`; no stats, equipment, or lock state exists. |
| Hub / map / route / chapter | `NOT_APPLICABLE` | The boat diorama is the current home surface; no map, node graph, chapter, or route consumer exists. |
| Dialogue / story event / cutscene | `NOT_APPLICABLE` | Ambient letter text is a compact discovery state, not a dialogue/cutscene system. |
| Briefing / battle / special action | `NOT_APPLICABLE` | Rest-first scope forbids combat, enemies, failure pressure, QTE, and combat overlays. |
| Progression / shop / craft / repair | `NOT_APPLICABLE` | Decoration and memory are cosmetic/personal, not optimization or economy systems. |
| Tutorial / manual / searchable codex | `DEFERRED_BY_DECISION` | No current player-facing help consumer exists. Runtime UI remains small enough for the slice; add only when a concrete confusion point appears. |
| Pause / settings / accessibility / language | `NOT_APPLICABLE` | No pause/settings scene or save/apply consumer exists in the current vertical slice. This is a future platform/product requirement, not an image gap. |
| Failure / retry / ending / credits | `NOT_APPLICABLE` | Current design excludes failure states and has no ending/credits surface in this slice. |
| Loading / offline / reconnect / permission / update / error | `NOT_APPLICABLE` | Core play is local-first and no network, permission, update, or remote save flow is currently active. |
| FriendBottle / DriftBottle | `DEFERRED_BY_DECISION` | Approved future social boundary is not runtime-enabled until the safety/release gate. No screen or asset is allowed to be inferred early. |
| Store / marketing / app icon | `DEFERRED_BY_DECISION` | Release platform, branding lock, and distribution consumer are not yet selected. |

## 3. Screen-to-asset coverage matrix

| coverage_item_id | surfaces | role / state family | production mode | actual consumer / source | status |
| --- | --- | --- | --- | --- | --- |
| `MLB-VC-001` | `MLB-SCR-001`, `MLB-OVR-002` | First impression, identity/light selection; normal, selected, expanded; Dawn/Bright/Sunset/Night | `GODOT_UI`, `TEXT_LAYER`, `RASTER_IMAGE`, `EXISTING_APPROVED` | `main_menu.tscn`, `main_menu.gd`; `AtmosphereBackground`, `DioramaAnchor`, identity/time catalogs; four approved background files | `COVERED_EXISTING`. `test_main_menu_atmosphere_background_contract.gd` and four 540×960 runtime captures prove the actual path. |
| `MLB-VC-002` | `MLB-SCR-003`, `MLB-OVR-004` | Boat, companion, horizon; Normal and Appreciation | `EXISTING_APPROVED`, `RASTER_IMAGE`, `GODOT_UI` | `boat_c_dog_diorama_storybook.png`, `sea_bright_storybook.png`, `identity_visual_router.gd` | `COVERED_EXISTING`, state family `COMPLETE` for current camera modes. |
| `MLB-VC-003` | `MLB-OVR-002`, `MLB-SCR-003` | Player/pet identity; selected/default, C+dog final route, other pairs | `EXISTING_APPROVED`, `RASTER_IMAGE`, `PROCEDURAL_DRAW` | `identity_visual_catalog.gd`; five identity cards and existing shared boat pass | `COVERED_EXISTING`, current selectable state family `COMPLETE`. |
| `MLB-VC-004` | `MLB-OVR-005`, `MLB-SCR-003` | Decor: placed, replaced, cleared; cushion stripe/moon/floral; postcard default | `EXISTING_APPROVED`, `RASTER_IMAGE`, `SHADER`, `GODOT_UI` | four approved files through `decor_visual_assets.gd`, `boat_decor_slot.gd`, `IdentityVisualRouter` | `COVERED_EXISTING`, current required variants `COMPLETE`. |
| `MLB-VC-005` | `MLB-OVR-006` to `MLB-OVR-009` | Optional action, waiting/bite/cancel, offer/expiry, complete/next | `GODOT_UI`, `TEXT_LAYER`, `NO_NEW_IMAGE_FILE_REQUIRED` | `game_scene.gd`, `fishing_session.gd`, `GameState` | `COVERED_EXISTING`, current state families `COMPLETE`. |
| `MLB-VC-006` | `MLB-SCR-010` | Empty and populated memory summary, return affordance | `GODOT_UI`, `TEXT_LAYER`, `NO_NEW_IMAGE_FILE_REQUIRED` | `album.tscn`, `album_view.gd`, runtime photo records | `REQUIREMENT_LINKED` to `MLB-UI-P1-ALBUM-COMPOSITION`; state family `PARTIAL` only because visual composition is deferred. |
| `MLB-VC-007` | all current surfaces | Buttons, labels, panels, focus/pressed/disabled semantics | `GODOT_UI`, `TEXT_LAYER`, `DO_NOT_GENERATE` | Godot `Control`, `PanelContainer`, `Button`, `OptionButton`, `Label` | `COVERED_EXISTING`. Custom UI icon pack is `DEFERRED_BY_DECISION` until a binding consumer/readability issue exists. |
| `MLB-VC-008` | all current surfaces | Dynamic Korean text, timer, counts, discoveries, no-data message | `TEXT_LAYER`, `NO_NEW_IMAGE_FILE_REQUIRED` | scene labels and scripts | `COVERED_EXISTING`. Text must remain editable and localization-safe. |

## 4. Queues

### 4.1 Screen Design Reference Queue

| screen_id | consumer_surface | player goal | reference needed | existing anchor | fidelity / validation | priority |
| --- | --- | --- | --- | --- | --- |
| `MLB-SCR-001` | `main_menu.tscn` | Understand the cozy boat-rest promise before choosing a mood | Yes, as an engine-composed 540×960 entry reference | `boat_c_dog_diorama_storybook.png`, `sea_bright_storybook.png`, current main-menu capture | Godot UI composition capture must show title, selected identity/light, and mood actions without crowding; verify on PC and later real mobile | P0 |
| `MLB-SCR-010` | `album.tscn` | Read personal memories and empty state as a calm archive | Yes, later | Existing album empty-state capture and real runtime records | Godot UI/text layout only; real photos remain runtime capture, not illustrative filler | P1 |

### 4.2 Runtime Asset Family Queue

| asset_family_id | screen_ids | runtime consumer | role / required states | production mode | format and validation | status |
| --- | --- | --- | --- | --- | --- | --- |
| `MLB-ASSET-BOAT-SEA-IDENTITY` | `MLB-SCR-003`, `MLB-OVR-004` | `game.tscn`, `boat_space.tscn`, `IdentityVisualRouter` | Normal/Appreciation, default C+dog and selectable identities | `EXISTING_APPROVED` | Current local PNG assets; 540×960 capture and identity contracts | `COVERED_EXISTING` |
| `MLB-ASSET-DECOR-SURFACES` | `MLB-SCR-003`, `MLB-OVR-005` | `decor_visual_assets.gd`, boat slots and final overlays | stripe/moon/floral cushion, one Bright postcard face | `EXISTING_APPROVED` | exact imported PNG paths; runtime-image and final-composite contracts | `COVERED_EXISTING` |
| `MLB-ASSET-MAIN-ENTRY-UI` | `MLB-SCR-001`, `MLB-OVR-002` | `main_menu.tscn` | normal / selected / expanded identity and time choice | `GODOT_UI`, `TEXT_LAYER`, `REUSE_PROJECT` | 540×960 runtime capture, semantic button tests, later real-device check | `COVERED_EXISTING` |
| `MLB-ASSET-MAIN-MENU-ATMOSPHERE-BACKGROUND` | `MLB-SCR-001`, `MLB-OVR-002` | `AtmosphereBackground` in `main_menu.tscn`, selected by the existing four-time catalog | Dawn / Bright / Sunset / Night, opaque portrait 2:3 | `RASTER_IMAGE`, `USER_APPROVED`, `GENERATION_PROVENANCE` | four exact 1024×1536 RGB sRGB PNGs; SHA-256, Notion records, durable Git locators in `docs/evidence/2026-08-28-main-menu-background-assets/asset-provenance.md`, and four current 540×960 captures | `COVERED_EXISTING / IMPLEMENTATION_READY` |
| `MLB-ASSET-ALBUM-UI` | `MLB-SCR-010` | `album.tscn` | empty / populated / return | `GODOT_UI`, `TEXT_LAYER`, `RUNTIME_CAPTURE` | capture generated from actual records; no fake images | `GAP_NONBLOCKING` |

The user explicitly approved the one consumer-bound `RASTER_IMAGE` family above on 2026-08-28. No `SPRITE_SHEET`, UI icon, portrait-only, UV-texture, or album-filler family is queued.

## 5. Correction log

| Current state | Finding | Correction | Actual use | Validation evidence |
| --- | --- | --- | --- | --- |
| Runtime/asset documents were complete but historical image-manifest text still described pre-integration zero-assets state. | A reader could confuse historical image workflow with current whole-screen coverage. | This owner separates current screens, their consumers, and actual image state. `CURRENT_GODOT_IMPLEMENTATION.md` links here. | Codex reads this before a future UI slice. | current `main` at `6954b8886fe36a3f2a5da98e70ab22eabe5f429d`; scene/script/test readback. |
| Base requested subordinate path is absent in latest `main`. | Blindly citing it as current would create Base authority drift. | Record the missing path and use the still-present latest Base coverage checklist; historical file is context only. | Future audit knows why project owns this companion. | Base `main` `986ac321`; historical add commit `d0d337eb`. |
| Main entry was functional but visually generic. | It did not present the approved hand-painted boat-rest identity before the player committed to a mood. | Wire the four approved backgrounds to time selection, add the existing C+dog diorama anchor, and use compact translucent Godot UI controls. | First-launch mood selection. | `docs/evidence/2026-08-28-main-menu-composition/main_menu_{dawn,bright,sunset,night}_540x960.png`, `test_main_menu_atmosphere_background_contract.gd`. |
| Album shows real data and a proper empty state but is visually generic. | A future polished memory screen could otherwise provoke fake illustrative-photo generation. | Mark P1 `GODOT_UI + TEXT_LAYER + RUNTIME_CAPTURE`; explicitly prohibit fake photos. | Album entry after any voyage. | `album-empty_540x960.png`, `album_view.gd`, album contract. |

## 6. Codex implementation handoff

Use only this confirmed input for the next product slice.

```text
/goal Implement GitHub Issue #71 exactly as specified.
```

### Read first

- `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md`
- `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`
- `scenes/main_menu.tscn`, `scripts/ui/main_menu.gd`
- `scenes/album.tscn`, `scripts/ui/album_view.gd`
- `docs/evidence/2026-08-27-screen-surface-audit/`
- Project Notion [Home](https://app.notion.com/p/3c41b237eb1c81948b8ed88362cafafa), [Visual Bible](https://app.notion.com/p/3c11b237eb1c81ae97f3dc28a0905304), and [Production Handoff](https://app.notion.com/p/3c11b237eb1c81b0b281ec54d67c9552).

### P0 scope

- Compose `MLB-SCR-001` with the four approved main-menu atmosphere backgrounds, existing boat/identity visual anchors, and Godot UI/text layers.
- Keep player/pet/time selection, mood meaning, local-first state, 540×960 layout, and direct `main_menu → game` route unchanged.
- Do not create more menu-background variants, a UI icon pack, portrait-only asset family, new progression, save-slot system, or a combat/system screen. The four approved backgrounds are fixed P0 inputs.
- Add focused scene/UI tests and runtime captures for normal, identity-expanded, and selected-light states.

### P1 follow-up, not part of P0

- Recompose `MLB-SCR-010` from actual record text and runtime photo captures. Do not invent album art or presentation-only photos.

### Acceptance

- Main entry visibly communicates boat, sea, companion, and rest-first intent before a mood is selected.
- Text remains editable; existing input, state, and no-pressure rules stay unchanged.
- Actual 540×960 Godot capture demonstrates hierarchy and no clipping.
- Existing image consumers retain exact paths and current contracts pass.
- PR #19 remains read-only/no-absorption.

## 7. Remaining gaps and five-way readback

| Review lens | Result |
| --- | --- |
| Screen completeness | All current target-build surfaces are recorded; every non-applicable family has a reason. |
| Player judgment | P0 entry identity is the only blocking visual/composition finding. Current voyage/result and optional choices remain readable. |
| Asset completeness | Current bitmap state families are complete. No new image requirement is valid. |
| Overproduction prevention | Main entry and album gaps route to Godot UI/text/reuse; album photos route to runtime capture. |
| Canon / implementation reality | Notion provides human direction, repository provides current consumers, and 540×960 captures provide screen evidence. |

```text
blocking_gap:
  - MLB-UI-P0-MAIN-ENTRY-COMPOSITION
nonblocking_gap:
  - MLB-UI-P1-ALBUM-COMPOSITION
user_decision_required: []
codex_implementation_required:
  - P0 main-entry Godot UI composition
  - P1 album composition after P0
image_brief_approval_required: []
runtime_player_validation:
  - real-device mobile touch/comfort and human 5-minute rest remain deferred
```
