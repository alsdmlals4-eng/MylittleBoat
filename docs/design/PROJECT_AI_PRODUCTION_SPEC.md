---
artifact_role: AI_MASTER_GDD
pair_id: my-little-boat-20260830-destination-free-rest
blueprint_revision: 2.8
project_repo: alsdmlals4-eng/MylittleBoat
project_branch: main
project_sha: 5ca7343d1c47ee3e02d40eab11a2c84c055b0fd1
base_repo: alsdmlals4-eng/Base
base_sha: 7ead958819a8d96b639e2641a7bbf7c10822cc69
generated_at_utc: 2026-08-30T02:53:40Z
document_version: 2.9.0
scope: blueprint-runtime-receipt
canonical_ai_gdd_path: docs/design/PROJECT_AI_PRODUCTION_SPEC.md
human_pdf_path: exports/MY_LITTLE_BOAT_MASTER_PRODUCTION_GDD_20260830.pdf
blueprint_review_status: USER_APPROVED_FOR_CURRENT_MVP
implementation_authority: USER_AUTHORIZED_MVP_IMPLEMENTED
approved_blueprint_scope:
  - destination-free slow movement as the rest experience
  - human-facing Blueprint revision and matching AI specification
  - six user-approved and canon-registered natural-landmark and visual-flow images
  - direct boat entry, local-time visual atmosphere, and foreground-only passive scenery MVP
excluded_from_this_revision:
  - destination, route, arrival reward, progress, or failure system
  - Human comfort, device usability, accessibility, and audio completion claims
source_precedence: user instruction > project AGENTS.md > current repository owners and runtime evidence > Base publication policy > external sources > derived PDF
overall_status: IMPLEMENTED_MVP_WITH_RUNTIME_CAPTURE_HUMAN_NOT_RUN
known_stale_points:
  - main_menu.tscn remains as an unreachable legacy slice, not the startup route or current product owner.
  - The action-based companion level is retired. Together-time Human/device readability and pressure review remain unrun.
  - Runtime captures do not prove human calm, touch usability, motion comfort, text readability, or audio comfort.
  - Runtime captures do not replace a Human readability review of the new cosmetic preview panel.
---

# My Little Boat - AI Production Specification

## 0. BLUEPRINT REVIEW PUBLICATION

### Pair and review boundary

| Field | Value |
| --- | --- |
| Pair ID | `my-little-boat-20260830-destination-free-rest` |
| Revision | `2.8` |
| Review output | human Blueprint PDF plus this structured specification |
| User-confirmed product decision | Rest means the player avatar and companion ride together through a calm sea with **no destination**. |
| Review status | `USER_APPROVED_FOR_CURRENT_MVP` |
| Implementation authority | `USER_AUTHORIZED_MVP_IMPLEMENTED` |

### Approved meaning and exclusions

- Slow forward motion, boat bob, changing sea/sky, and low-density distant scenery communicate that the pair is gently moving together.
- The player may continue resting or leave whenever desired. A nominal five-minute record is a memory opportunity, never a finish line.
- No route selection, map, destination, arrival screen, arrival reward, progress meter, speed optimization, success/failure, or return pressure may be inferred from this motion.
- The user approved the required visual direction and authorized the current MVP. Its Godot scenes, scripts, tests, runtime images, and evidence were reconciled without changing any open PR.

### Material preparation record

| Material | Blueprint use | Status | Evidence boundary |
| --- | --- | --- | --- |
| Existing normal/appreciation 540x960 captures | excluded from revised human Blueprint scene atlas | retained in repository | initial runnable slice only; not shown as healing landmark art |
| Four-time atmosphere continuity board | a full human Blueprint page for dawn/bright/sunset/night | available | visual continuity reference, not automatic local-time runtime proof |
| Six new natural-landmark / visual-flow images | main screen, four healing landmark scenes, image-based flow map | `USER_APPROVED → CANON_REGISTERED` | the Blueprint set remains historical human-facing provenance. Current passive runtime scenery is separately owned by six `MLB-AMB-MOTIF-001..006` water-only landscape assets; 006 remains `HUMAN_BLUEPRINT_CANON` only |
| Approved normal chibi source and derived foreground matte | default C+dog Normal Diorama | `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED` | source, derived runtime asset, exact shader consumer, and evidence paths are owned by the visual inventory; Human/device comfort remains unverified |
| Approved floral cushion and postcard chibi decor | persisted default C+dog `floral` / `postcard` decor selection | `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED` | candidate-to-canonical SHA equality, existing saved keys, main-composite cushion-only rule, independent preview rail-postcard consumer, and runtime evidence are owned by the visual inventory; Human/device comfort remains unverified |
| Approved visual-asset provenance and hashes | `CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md` sections 5.1–5.6 | recorded | individual path, consumer, SHA-256, approval, and implementation boundary are auditable |

### Current runtime receipt

This receipt supersedes the following historical baseline sections whenever they describe the pre-implementation main-menu route or missing atmosphere/scenery work.

| Scope | Current evidence | Ceiling |
| --- | --- | --- |
| Direct entry | `project.godot` opens `scenes/game.tscn`; first frame shows the approved sea/boat composition and compact `쉬는 메뉴` | runtime capture confirmed; Human comfort `NOT_RUN` |
| Local-time atmosphere | `05–08=dawn`, `09–16=bright`, `17–20=sunset`, `21–04=night`; no reward/progress/save effect | four normal/Appreciation captures and contracts confirmed |
| Passive scenery | foreground-only first opportunity 90–150 seconds; each opportunity independently displays one current-time `MLB-AMB-MOTIF-001..006` with a 65% chance; each following opportunity is 120–180 seconds later regardless of display | director, zero-event cadence, ambient persistence/state/game-scene/motif contracts, and six controlled GPU captures confirmed; long-run Human observation `NOT_RUN` |
| Together time | active foreground voyage seconds only; 15-second/lifecycle local flush; Album-only duration and relation copy | persistence, state, and scene contracts plus 540×960 Album capture confirmed; Human readability/pressure `NOT_RUN` |
| Approved images | four water-only time backdrops remain the base atmosphere; `MLB-AMB-MOTIF-001..006` are six passive landscape events; Blueprint flow image remains human-facing only | six motif GPU runtime captures plus existing base-atmosphere captures; Human evidence `NOT_RUN` |

### Remaining review boundary

The user-approved implementation does not close real-device first-30-second and five-minute calm, touch targets, motion sensitivity, text readability, or audio comfort. The cosmetic preview surface is implemented and captured, but its Human/device review remains required.

## 1. CANON SNAPSHOT

### Product promise

> Open the game and already be on a small boat carrying your character and companion gently through a calm sea with no destination, free to rest or leave a quiet personal memory.

`my little boat` is a rest-first, local-first cozy boat diorama for Godot 4.7. Normal play is a calm 3/4 diorama containing avatar, companion, boat, decor, sea, and horizon. `Appreciation Camera` is an optional low-UI view of the same voyage; it must not alter time, rewards, or soundscape.

### Non-negotiable product boundaries

- No combat, damage, failure states, rankings, scarcity pressure, paid systems, ads, gacha, streaks, public feed, presence, realtime chat, or social comparison.
- No startup choice for mood, identity, pet, decor, or atmosphere. Local device time changes visuals only.
- Cosmetics are self-expression, never stats, rarity, optimization, or a task.
- Photos, fishing, small interactions, and decoration remain optional. Doing nothing is complete play.
- FriendBottle and DriftBottle are delayed correspondence only. Public enablement remains blocked until server moderation, terms, 16+ gate, report/block, operations, support contact, and release evidence exist.

### Fresh-read outcome

| Area | Product decision | Current repository evidence | Current truth |
| --- | --- | --- | --- |
| Entry | Directly show the boat diorama | `project.godot` routes to `scenes/game.tscn`; first-frame compact rest menu contract and capture exist | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| Voyage | About five minutes, but staying longer is valid | `GameState.VOYAGE_SECONDS = 300.0`; one post-zero record | `PARTIAL_IMPLEMENTED` |
| Atmosphere | Local time is visual-only and automatic | `RealTimeAtmosphereResolver`, injected-hour tests, five approved runtime textures, 30-second refresh and focus/resume refresh | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| Appreciation | Same voyage, lower UI, horizon focus | Camera controller, scene nodes, and contract test exist | `IMPLEMENTED / UX_NOT_RUN` |
| Cosmetics | Optional in-voyage `꾸미기`, local-only | DecorPanel owns player/pet selectors and boat-decor controls; independent `DecorPreview` reflects the same local state | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human readability `NOT_RUN` |
| Memories | Personal album, not collection pressure | photo postcards, auto-recorded ambient scenery, fish, and completed voyage records each have a dedicated local persistence owner and Album consumer; delayed bottle letters remain process-lifetime and excluded from this ledger | `PARTIAL_IMPLEMENTED`; delayed-letter/full-memory save `NOT_RUN` |
| Companion | Quiet together-time in Album | `GameState` foreground seconds, `TogetherTimePersistence`, `TogetherTimePresentation`, and Album-only copy | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human readability/pressure `NOT_RUN` |
| Ambient discovery | Foreground-only, passive, low density | `DriftSceneryDirector`, non-interactive label, `GameState.record_ambient_memory`, and `AmbientMemoryPersistence` at `user://ambient_memory_v1.cfg` | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; no-guarantee cadence complete, long-run Human observation `NOT_RUN` |

## 2. SOURCE REGISTRY

| ID | Claim or rule | Source | Baseline | Status and use |
| --- | --- | --- | --- | --- |
| `SRC-001` | Engine, safety, local-first, and output language constraints | `AGENTS.md` | project main `5ca7343` | `CONFIRMED` |
| `SRC-002` | Exactly two master outputs, Blueprint layering, and pre-implementation review gate | `Base/docs/PROJECT_MASTER_GDD_TWO_ARTIFACT_POLICY.md` | Base `7ead958` | `CONFIRMED` |
| `SRC-003` | Current repository identity, open work, and commits | Git and GitHub readback | 2026-08-30 | `CONFIRMED` |
| `SRC-004` | Product promise and direct-entry target | `docs/design/PROJECT_GDD.md` | 2026-08-30 | `CONFIRMED` |
| `SRC-005` | Rest-first behavioral guardrails | `docs/RESTING_EXPERIENCE_BIBLE.md` | current main | `CONFIRMED` |
| `SRC-006` | Passive ambient discovery and density | `docs/2026-08-28-passive-ambient-discovery-*.md` | 2026-08-28 | `USER_APPROVED` |
| `SRC-007` | Together-time companion presentation | `docs/2026-08-28-*-companion-affection-*.md` | 2026-08-28 | `USER_APPROVED` |
| `SRC-008` | Delayed bottle safety gate | `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md` | current main | `USER_APPROVED / RELEASE_BLOCKED` |
| `SRC-009` | Next integrated Phase 2 design and plan | `docs/superpowers/specs/2026-08-29-real-time-atmosphere-and-drifting-scenery-design.md`, `docs/superpowers/plans/2026-08-29-real-time-atmosphere-and-drifting-scenery.md` | current main | `CONFIRMED_IMPLEMENTATION_INPUT` |
| `SRC-010` | Current Godot route, scene ownership, and known gap | `project.godot`, `scenes/*.tscn`, `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md` | main `5ca7343` | `CONFIRMED` |
| `SRC-011` | State, persistence, and behavior owners | `scripts/core/*.gd`, `scripts/voyage/*.gd`, `scripts/ui/*.gd` | main `5ca7343` | `CONFIRMED` |
| `SRC-012` | Visual direction, consumers, provenance, and evidence limit | `docs/visual/*.md`, `docs/evidence/**` | current main | `CONFIRMED` |
| `SRC-013` | Automated coverage and CI route | `tests/test_*.gd`, `.github/workflows/godot-validation.yml` | run 2026-08-30 | `AUTOMATED_TEST_PASS` |
| `SRC-014` | Autoload, local time, ConfigFile, and scene feasibility | Godot stable official documentation | accessed 2026-08-29 | `CONFIRMED_EXTERNAL` |
| `SRC-015` | Accessibility guardrails | Xbox Accessibility Guidelines | accessed 2026-08-29 | `REFERENCE` |
| `SRC-016` | Genre expectations and differentiation | Official pages for Townscaper, A Short Hike, TOEM, Alba, Sail Forth, DREDGE | accessed 2026-08-30 | `RESEARCHED` |
| `SRC-017` | Destination-free slow sea movement is the definition of rest | user instruction, 2026-08-30 | current review pair | `USER_CONFIRMED` |
| `SRC-018` | Human Blueprint page/label/quality rules | attached `PROJECT_HUMAN_GAME_BLUEPRINT_GDD_TEMPLATE_AND_INSTRUCTION (2).md` | 2026-08-30 | `CONFIRMED_TEMPLATE` |
| `SRC-019` | Main-screen, healing-landmark, and visual-flow image set | user request and approval, `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md` section 5.1 | 2026-08-30 | `USER_APPROVED / CANON_REGISTERED / HUMAN_BLUEPRINT_CANON` |

### Fresh-read evidence

- The repository was fresh-read on 2026-08-30. The current branch is `main` at `5ca7343d1c47ee3e02d40eab11a2c84c055b0fd1`; the uncommitted current-MVP worktree is preserved and this revision reconciles its relevant runtime and owner documentation.
- The adopted Base policy was fresh-read from `main` at `7ead958819a8d96b639e2641a7bbf7c10822cc69`.
- GitHub readback found open Issue [#99](https://github.com/alsdmlals4-eng/MylittleBoat/issues/99), open Issue [#18](https://github.com/alsdmlals4-eng/MylittleBoat/issues/18), and unrelated open PR [#19](https://github.com/alsdmlals4-eng/MylittleBoat/pull/19). PR #19 is read-only and excluded.
- Godot 4.7.2 ran all 51 current `test_*.gd` contracts warning-free on 2026-08-31. `ViewportTexture` postcard persistence remains asserted by the OpenGL game-scene contract, while the headless path explicitly skips only that unsupported renderer read. The OpenGL game-scene contract ran 5/5 without ObjectDB/resource leak warnings, and the chibi normal material proof passed once on NVIDIA RTX 3050 OpenGL 3.3. This is machine evidence only; device and Human comfort remain unverified.

## 3. CURRENT PROJECT STATE

### What players can run now

The current entry scene is `scenes/game.tscn`: it immediately shows the normal boat diorama and compact rest controls. The device-local hour selects the visual atmosphere; it does not change rewards, progression, or persistence. `GameScene` runs the nominal five-minute record, supports optional photo, Appreciation Camera, speed, fishing, decor, interaction, Album, and passive scenery. The Album shows local records plus an Album-only foreground together-time duration and quiet relation sentence. There is no live companion level.

### Current implementation versus approved target

| Current implementation | Approved target | Current reconciliation |
| --- | --- | --- |
| `project.godot` launches `scenes/game.tscn`; `main_menu.tscn` is unreachable legacy UI | launch directly into normal boat diorama | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` |
| no mood state changes the current entry; mood-facing controls are legacy only | no mood state or mood-facing UI | `IMPLEMENTED` |
| `RealTimeAtmosphereResolver` uses system local hour as visual-only state | system local hour, visual-only, no selector/save | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` |
| only active foreground voyage delta advances `together_time_seconds` | active foreground voyage time only | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human readability/pressure `NOT_RUN` |
| `DriftSceneryDirector` schedules a 90–150 second foreground first opportunity, rolls 65% at every opportunity, and schedules the next 120–180 second opportunity after either an empty or displayed result; `save_memory=true` uses a named immediate durable writer | 1-2 passive events per nominal five minutes, zero valid and immediate durable local memory | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; long-run Human observation `NOT_RUN` |
| target routes have 540×960 GPU evidence, including the Album together-time state | target entry needs new 540×960 evidence | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` |

## 4. CONFIRMED DECISIONS

| ID | Decision | State | Implementation evidence |
| --- | --- | --- | --- |
| `DEC-001` | Rest-first calm 3/4 diorama is the normal presentation | `USER_APPROVED` | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| `DEC-002` | Appreciation Camera is optional, low-UI, and reward-neutral | `USER_APPROVED` | `IMPLEMENTED`; UX/Human comfort `NOT_RUN` |
| `DEC-003` | Direct boat entry replaces all startup selectors | `USER_APPROVED` | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` |
| `DEC-004` | Local clock maps to dawn, bright, sunset, night visuals only | `USER_APPROVED` | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| `DEC-005` | Cosmetics remain optional and local-only | `USER_APPROVED` | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human readability `NOT_RUN` |
| `DEC-006` | Ambient discovery is passive, auto-saved, foreground-only, and no-reward | `USER_APPROVED` | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; long-run Human observation `NOT_RUN` |
| `DEC-007` | Ambient density is about 1-2 per nominal five minutes; zero is valid | `USER_APPROVED` | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; 90–150 second first opportunity, 65% per opportunity, 120–180 second follow-up; Human observation `NOT_RUN` |
| `DEC-008` | Companion value is quiet together-time in Album, not action farming | `USER_APPROVED` | implemented; Human readability/pressure review remains `NOT_RUN` |
| `DEC-009` | Bottle social is delayed and release-gated | `USER_APPROVED` | deferred and gated |

## 5. DESIGN PILLARS AND PLAYER EXPERIENCE CONTRACT

| EXP ID | Player promise | Player question | Feedback | Guardrail |
| --- | --- | --- | --- | --- |
| `EXP-001` | I am already drifting with my companion, without needing to arrive anywhere. | Can I simply keep going slowly together? | boat bob, gentle forward motion, sea, avatar, pet, horizon, and changing light | no startup selector, destination, task, or arrival reward |
| `EXP-002` | My small space can feel mine. | How do I want this boat and pair to look? | immediate cosmetic change and local restoration | no stats, price, rarity, or best build |
| `EXP-003` | Looking is valid play. | Do I want the diorama or the horizon? | camera changes UI and framing only | no hidden reward rate or timer change |
| `EXP-004` | A small moment can become a memory. | Do I want to photograph, fish, or just watch? | photo/catch memory, small response, calm sound | no failure penalty or farming |
| `EXP-005` | The sea can feel alive without demanding attention. | What is quietly passing by? | distant silhouette and rare fading note | zero events valid; no tap, reward, or FOMO |
| `EXP-006` | Time with my companion matters without becoming a chore. | What have we quietly shared? | Album duration and one relation sentence | no live level, bar, milestone, or species advantage |

### Core, session, and meta loops

```text
CORE: arrive on boat -> stay or optionally act -> receive calm world feedback -> keep resting or leave
SESSION: direct entry -> normal diorama -> optional photo/fishing/decor/camera -> a voyage record after about 5 min -> continue or begin another voyage
META: local memories and cosmetics -> Album / visual self-expression -> return to the same low-pressure boat
```

There is no mandatory failure, recovery, economy, daily loop, or competitive loop. "No action" is a legitimate successful branch.

## 6. SYSTEM REGISTRY

| ID | System | Player value | Current evidence | Next evidence |
| --- | --- | --- | --- | --- |
| `SYS-001` | Direct entry and destination-free rest voyage | immediate belonging and gentle shared movement | legacy route only | direct `game.tscn` capture |
| `SYS-002` | Appreciation Camera | choose less UI and more horizon | automated contract | human comfort test |
| `SYS-003` | Cosmetic identity and boat decor | make the place mine | local persistence, actual alternate chibi consumer, and GPU capture contracts | in-voyage device readability/touch test |
| `SYS-004` | Quiet optional actions | light touch without chores | photo, catch/quiet/cancel fishing, interaction contracts and controlled GPU capture | human readability review |
| `SYS-005` | Album and personal memory | revisit what actually happened | Album contracts/captures | whole-memory save remains partial |
| `SYS-006` | Passive ambient discovery | living sea without pressure | approved decision only | foreground director and capture |
| `SYS-007` | Quiet companion together-time | affection without optimization | persistence/state/scene contracts and Album capture | Human readability/pressure review |
| `SYS-008` | Delayed bottle correspondence | warm delayed connection, never chat | design only | safety-gated backend slice |
| `SYS-009` | Real-time atmosphere | the same place changes visually | tone catalog and legacy selector | hour resolver and transition |

## 7. SYSTEM SPECIFICATIONS

### SYS-001 - Direct entry and destination-free rest voyage

- **Role:** make the first frame a calm boat-world rather than a configuration form, and make its slow motion feel like companionship rather than progress toward a destination.
- **Entry:** application launch or return from Album. **Exit:** none is required; the player may continue resting after a record.
- **Visible information:** avatar, companion, boat, sea, horizon, optional compact controls, and low-amplitude forward water/boat movement. **Hidden information:** no mood, score, task list, expected action, route, destination, or arrival target.
- **Rules:** motion is continuous environmental feedback, not player progress. Local clock selects only visual tone. The five-minute timer may create one record; it does not eject the player or indicate arrival.
- **Current owner:** `project.godot`, `scenes/main_menu.tscn`, `scenes/game.tscn`, `scripts/core/game_state.gd`, `scripts/voyage/game_scene.gd`.
- **Known conflict:** current `run/main_scene` is `main_menu.tscn`, and `GameScene._ready()` starts a voyage using `selected_mood`.
- **Acceptance criteria:** a clean local state opens `game.tscn`; no pre-entry identity/pet/time/mood control is visible; camera and soundscape parity remain; existing personal cosmetic state restores; no route, arrival, progress, or motion-derived reward appears.
- **Verification:** direct-entry contract test, scene smoke, four injected-hour 540x960 captures, and human first-30-second observation.

### SYS-002 - Appreciation Camera

- **Role:** offer a horizon-forward resting view without creating a different game mode.
- **Input:** `AppreciationButton`, mouse drag, or touch drag while appreciation camera is current.
- **State transition:** `DIORAMA <-> APPRECIATION`; fishing is safely cancelled before the switch.
- **Visible effect:** camera current flags and nonessential UI visibility change. **Invariant:** voyage countdown, memories, decoration, time tone, and soundscape do not receive a multiplier.
- **Current owner:** `BoatCameraController`, `GameScene._toggle_appreciation_mode()`, two camera rigs in `game.tscn`.
- **Verification:** `test_camera_input_contract.gd`, `test_game_scene_contract.gd`; human motion/comfort validation remains `NOT_RUN`.

### SYS-003 - Cosmetic identity and boat decor

- **Role:** provide self-expression after arrival.
- **Content:** player styles `a_soft_hooded`, `b_short_cape`, `c_loose_knit`; companion types cat, rabbit, otter, dog; eight boat slots and catalogued cosmetic items.
- **Rules:** visual pair and decor item do not change reward, affection, discovery, speed, or difficulty. Default is C loose-knit plus dog.
- **Data:** `CosmeticIdentityProfile` saves two IDs in `user://identity_profile_v1.cfg`; `BoatDecorPersistence` saves item/appearance dictionaries in `user://boat_decor_v1.cfg`.
- **Current owner:** `IdentityVisualCatalog`, `IdentityVisualRouter`, `BoatDecorSlot`, `GameState`, DecorPanel, and `DecorPreview`. Menu identity panel is legacy product flow.
- **Boundary cases:** unknown IDs normalize to approved defaults; unavailable or invalid ConfigFile produces empty/default state; clearing a decor slot removes its appearance override.
- **Variant-refresh boundary:** user-approved alternate A/B player, cat/rabbit/otter, `stripe`, and `moon` use seven exact canonical chibi copies. Existing IDs and local cosmetic save keys remain unchanged; C+dog, `floral`, and postcard consumers remain separate.
- **Verification:** identity, persistence, decor, final-composite, capture-guard, and decor-preview contracts plus 540×960 GPU captures. Human readability and touch comfort remain `NOT_RUN`.

### SYS-004 - Quiet optional actions

- **Role:** add low-density agency without turning rest into a checklist.
- **Photo:** adds a local text memory. **Fishing:** `IDLE -> WAITING -> BITE_READY -> IDLE` for a catch, or `IDLE -> WAITING -> QUIET_READY -> IDLE` for an input-free no-catch ending. Waiting can be cancelled; quiet resolution and cancellation both have no loss, score, reward, streak, or economy side effect. **Interaction:** selected boat/pet/rail action yields short contextual text; pet `rest_together` uses the existing calm `rest` pose and rail `listen_to_waves` is a text-only moment.
- **Current behavior:** only a fishing catch calls the existing fish-memory writer. Quiet fishing, cancellation, decor, and interaction do not mutate together-time, fish, scenery, voyage records, or letters. Only active foreground voyage elapsed time is eligible for together-time.
- **Current owner:** `GameScene`, `CalmFishingSession`, `LowPressureInteractable`, `BoatRailInteractable`, resting-pet and decor interactions.
- **Verification:** `test_fishing_session.gd`, `test_fishing_outcome_contract.gd`, `test_low_pressure_interaction_contract.gd`, and `test_interaction_content_contract.gd` pass. `capture_calm_fishing_interactions.gd` captures explicit quiet-fishing and pet-rest UI states through OpenGL 3.3. Human text readability remains `NOT_RUN`.
- **Acceptance criteria:** all actions remain optional, cancellable where applicable, camera-neutral, and cannot improve companion progression.

### SYS-005 - Album and personal memory

- **Role:** turn actual local play into reflection rather than completion pressure.
- **Current records:** `photos`, `sceneries`, `letters`, `fish`, and `voyage_records` are process-lifetime `GameState` arrays. They are not currently written as a complete save game.
- **Current UI:** Album gives counts, current summary, foreground together-time duration, and one quiet relation sentence, then returns to `game.tscn`.
- **Product correction achieved:** no live `Lv` language remains. The Album contains only a duration and quiet relation sentence, not a score, checklist, fake photograph, or fill target.
- **Verification:** Album memory/composition and together-time scene contracts plus a 540×960 GPU Album capture prove the implemented rendering. Human readability and pressure remain `NOT_RUN`.

### SYS-006 - Passive ambient discovery

- **Role:** let the sea feel gently alive while preserving quiet.
- **Approved behavior:** active foreground voyage time only; distant scenery; durable local ambient memory when an event occurs; a small fading notification; no input, button, reward, letter semantics, or penalty. Normal and Appreciation views share the same underlying behavior. A nominal five minutes targets approximately 1-2 events, but zero is normal.
- **Current behavior:** `DriftSceneryDirector` schedules its first active-foreground opportunity at 90–150 seconds. At every opportunity it independently rolls 65% before creating a low-density scene, then schedules the following opportunity at 120–180 seconds regardless of whether the scene was displayed. It supplies a non-interactive fading note, camera parity, and an optional `GameState.record_ambient_memory` call. That named writer appends only the normalized ambient string to its ambient-only ledger and immediately writes `user://ambient_memory_v1.cfg`; app startup restores the ledger into the existing Album scenery consumer. Passive scenery has no together-time side effect. The sampled zero-event five-minute voyage is a valid automated outcome and has no player-visible missed state.
- **Data boundary:** generic `add_scenery()` remains a process-lifetime fixture/legacy helper and is not a durable writer. Photos, letters, fish, and voyage records remain outside this ambient persistence slice.
- **Remaining evidence boundary:** exact cadence is user-approved for this MVP. Future density retuning or motif-weight changes require a new product decision; Human five-minute calm, noticeability, text readability, and device comfort remain `NOT_RUN`.
- **Acceptance criteria:** foreground-only elapsed time, no first-event guarantee, one-at-a-time guard, no affinity mutation, camera parity, immediate durable local save, and no post-return burst.

### SYS-007 - Quiet companion together-time

- **Role:** make companionship meaningful without measuring performance.
- **Approved behavior:** accumulate active foreground voyage time globally, including both cameras and post-record rest; do not accumulate in menu, Album, background, or pause. Show duration and a non-pressuring sentence in Album only.
- **Current implementation:** one real active foreground voyage second adds one global together-time second in both camera modes and after the nominal record. It does not accrue in menu, Album, pause, or background.
- **Data contract:** `together_time_seconds` saves to `user://together_time_v1.cfg` as `[together_time] seconds`; missing, invalid, non-finite, or negative data normalizes to `0.0`. The save coalesces every 15 seconds and flushes on background, Album transition, and scene exit. The retired integer level has no reliable durable value, so it is not converted.
- **Presentation:** `< 60s` shows `함께한 시간: 잠시`; otherwise the Album shows floored minutes or hours/minutes, with one of two quiet relation sentences. It is global across cosmetic companion types.
- **Verification:** dedicated persistence/state/game-scene contracts prove no action, speed, or species modifier; a 540×960 GPU Album capture proves no `Lv` presentation. Human readability and pressure review remain `NOT_RUN`.
- **Acceptance criteria:** no action farming, no speed/species modifier, no live level/progress UI, local persistence, and separate human pressure review.

### SYS-008 - Delayed bottle correspondence

- **Role:** offer delayed, bounded letters rather than instant messaging.
- **Scope:** local-first voyage remains playable without backend. FriendBottle and DriftBottle are isolated future systems.
- **Hard release gate:** production server moderation, terms/community guidelines, 16+ gating, in-app report/block, moderation operations, support contact, and verification evidence are all required before public DriftBottle enablement.
- **Explicit exclusions:** public directory/feed, presence, typing indicator, read receipt, ranking, follower system, realtime/global chat, and social pressure.

### SYS-009 - Real-time atmosphere

- **Role:** let the place reflect local time without changing the game.
- **Approved mapping:** `05:00-08:59 dawn`, `09:00-16:59 bright`, `17:00-20:59 sunset`, `21:00-04:59 night`.
- **Rules:** refresh at start, foreground resume, and a bounded periodic interval; use a visual-only 1.5 second transition after an actual state change; fallback to bright if resolution fails; never store the selected atmosphere as progression state.
- **Current owner:** `RealTimeAtmosphereResolver` resolves the local hour, `TimeOfDayCatalog` defines tone values, and `GameScene` refreshes the visual-only tone on start, foreground resume, and the bounded interval. `GameState.selected_time_of_day` and main-menu options are unreachable legacy behavior.
- **Feasibility:** Godot's system-time API provides local time but must not drive precise progress. Delta/focus-owned time remains the correct source for progression. [Godot Time](https://docs.godotengine.org/en/stable/classes/class_time.html)

## 8. CONTENT REGISTRY AND SPECIFICATIONS

| CNT ID | Content | Consumer | Product status | Evidence limit |
| --- | --- | --- | --- | --- |
| `CNT-001` | C loose-knit and dog default | BoatSpace visual route | `RUNTIME_CONSUMED` | direct-entry capture exists; Human comfort `NOT_RUN` |
| `CNT-002` | Alternate avatar and companion cards | `IdentityVisualRouter` | `USER_APPROVED → CANON_REGISTERED → RUNTIME_CONSUMED`; five chibi paths retain existing IDs | default C+dog route remains unchanged; Human visual comfort `NOT_RUN` |
| `CNT-003` | Pet cushion and postcard decor surfaces | final composite decor | `USER_APPROVED → CANON_REGISTERED → RUNTIME_CONSUMED`; `stripe`/`moon` exact chibi copies retain saved appearance IDs | floral/postcard integration remains separate; Human visual comfort `NOT_RUN` |
| `CNT-004` | Four time-of-day background/tone family | `GameScene` and `Album` visual tone catalog | `RUNTIME_CONSUMED` | automatic local-hour mapping captured; Human comfort `NOT_RUN` |
| `CNT-005` | Photo postcard, ambient scenery, fish, completed-voyage records | GameState and Album | `PARTIAL_IMPLEMENTED` | each listed local record has its named owner; delayed bottle letters remain excluded and gated |
| `CNT-006` | Dawn sea arch, bright seagrass or chalk cliffs, sunset sandstone cove or reed islet, and night bioluminescence | `DriftSceneryDirector`, fading passive note, durable ambient-memory writer, and temporary normal·Appreciation backdrop consumer | `RUNTIME_CONSUMED` | six controlled 540×960 GPU captures and ambient cadence/persistence contracts; long-run Human observation `NOT_RUN` |
| `CNT-007` | Bottle letter content and moderation surfaces | future isolated social boundary | `DEFERRED` | safety gate blocks release |

### Visual content rules

- Keep `HANDPAINTED_STORYBOOK_3D_DIORAMA`, broad sea and sky, stable horizon, matte painterly values, rounded soft-manga-chibi silhouettes, and `INDIGO_RAIN_REFLECTION` night direction.
- Avoid glossy photoreal CG, dense micro-detail, strong flashing/bloom, giant blocking panels, threat weather, copied trade dress, and decorative rarity language.
- Existing generated images and captures retain their source/evidence labels. Only the explicit current direct-entry and time-scene capture receipts are runtime evidence; generated Blueprint art is never substituted for runtime proof.
- Do not generate new images for this GDD. Diagrams are vector/text descriptions; existing project captures are labeled as earlier runtime evidence.

## 9. UI/UX AND INPUT CONTRACT

| UI ID | Surface | Primary action | Required feedback | Current status |
| --- | --- | --- | --- | --- |
| `UI-001` | Direct boat entry | none required | boat-water-horizon hierarchy at first frame | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| `UI-002` | Normal voyage controls | photo, appreciation, speed, fishing, decor, interaction, Album | compact, optional, no reward escalation | `IMPLEMENTED`; Human readability `NOT_RUN` |
| `UI-003` | Appreciation Camera | toggle, mouse/touch drag | lower UI and horizon focus | implemented |
| `UI-004` | 꾸미기 | choose identity/decor, apply/clear/close | immediate cosmetic change, local persistence | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human readability `NOT_RUN` |
| `UI-005` | Album | read personal records, return | calm empty state, readable photo/ambient/fish/voyage separation, together-time copy | `PARTIAL_IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; delayed-letter persistence and Human readability `NOT_RUN` |
| `UI-006` | Passive discovery note | none | small auto-fade after an optional immediately persisted ambient entry | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; long-run Human observation `NOT_RUN` |

### Accessibility acceptance rules

- A player can preserve the core rest experience without repeated inputs or reaction timing.
- Important state is not color-only; use copy, icon/shape, or layout redundancy.
- Mouse and touch input remain supported for camera movement. Touch target size and portrait readability require device validation.
- Text, contrast, motion-reduction option, subtitles/audio alternatives, remapping, and localization expansion are `NEEDS_VALIDATION` rather than shipped claims. Apply relevant [Xbox Accessibility Guidelines](https://learn.microsoft.com/en-us/gaming/accessibility/xbox-accessibility-guidelines/) criteria when implementation introduces the surface.

## 10. VISUAL AND AUDIO CONSUMER MATRIX

| Event or state | UI consumer | World visual / animation | Audio consumer | Accessible alternative | Status |
| --- | --- | --- | --- | --- | --- |
| normal boat rest | compact controls | boat bob, sea, pet idle, diorama | `RestingSoundscape` | visual motion and copy remain | implemented; Human comfort/audio `NOT_RUN` |
| Appreciation toggle | button label | camera switch and UI reduction | same soundscape | no audio-only state | implemented |
| photo | status text | small pose/nearby response as available | unspecified | text memory | partial |
| fishing bite/cancel | fishing status text | line/session state | unspecified | visible status | partial |
| decor applied | DecorPanel feedback | slot/identity router refresh | unspecified | text confirmation | partial |
| passive discovery | fading optional note | far-horizon motion | no required cue yet | visible note, no urgency | implemented; controlled capture and ambient persistence/zero-event cadence contracts, long-run Human observation `NOT_RUN` |
| time boundary | no compulsory UI | shared sky/light/sea tone transition | persistent soundscape unchanged | visual-only; motion option undecided | implemented; Human comfort `NOT_RUN` |

## 11. TECHNICAL ARCHITECTURE

### Scene map

| IMP ID | Scene or owner | Responsibility | Input | Output / state | Save |
| --- | --- | --- | --- | --- | --- |
| `IMP-001` | `project.godot` | application route, autoloads, 540x960 portrait viewport | launch | current route is `scenes/game.tscn` | n/a |
| `IMP-002` | `scenes/main_menu.tscn` | unreachable legacy mood/time/identity setup | legacy buttons/options | no current startup consumer | process state only if explicitly opened |
| `IMP-003` | `scenes/game.tscn` | normal voyage world and compact UI | controls | camera/world/UI state | delegated |
| `IMP-004` | `scenes/boat_space.tscn` | boat, avatar, companion, decor visual hierarchy | GameState cosmetics | visual router/slots | n/a |
| `IMP-005` | `scenes/album.tscn` | personal record reading | Back button | returns to game | n/a |
| `IMP-006` | `GameState` Autoload | session, process-lifetime memories, and together-time lifecycle | scene calls | direct shared state | decor/identity plus together-time through its dedicated persistence owner |
| `IMP-007` | `RestingSoundscape` Autoload | persistent calm soundscape | scene state as wired | audio playback | not established |

### Script responsibility map

| Script | Owns | Must not own |
| --- | --- | --- |
| `scripts/core/game_state.gd` | shared session state, together-time lifecycle, and memory boundaries | UI presentation, atmosphere selector, rule duplication |
| `scripts/voyage/game_scene.gd` | voyage orchestration, control bindings, foreground timer call, visual atmosphere, and passive scenery | long-lived persistence schema or future social backend |
| `scripts/voyage/time_of_day_catalog.gd` | time IDs, labels, tone data | progression or save decisions |
| `scripts/voyage/boat_camera_controller.gd` | Appreciation camera drag input | reward/time modifiers |
| `scripts/voyage/fishing_session.gd` | deterministic fishing states | UI copy and affection |
| `scripts/ui/album_view.gd` | render actual local records and prepared together-time copy | invent records or calculate progression |
| `scripts/identity/identity_visual_router.gd` | visual card/decor application | cosmetic data ownership |
| `scripts/core/*_persistence.gd` | ConfigFile serialization and normalization | gameplay rules |
| `scripts/companion/together_time_presentation.gd` | Album-facing duration and relation copy | elapsed-time tracking or UI scene ownership |

### Signal and event flow

Current code primarily connects `Button.pressed` and `OptionButton.item_selected` directly in `GameScene._ready()`. State is read through the `GameState` Autoload rather than typed custom signals.

```text
UI button -> GameScene handler -> GameState or local session -> UI/world refresh
GameScene foreground delta -> GameState.advance_together_time -> TogetherTimePersistence lifecycle flush
Album transition -> GameState.flush_together_time -> AlbumView uses TogetherTimePresentation copy
RealTimeAtmosphereResolver -> GameScene visual tone only -> both camera backdrops/world light
DriftSceneryDirector -> optional GameState.record_ambient_memory -> ambient_memory_v1.cfg and Album scenery record -> optional fading UI note
```

Passive discovery and together-time use deterministic data/event boundaries before UI consumption. UI does not recalculate gameplay timing.

## 12. DATA CONTRACTS

| DAT ID | Current form | Writer | Consumer | Persistence and migration |
| --- | --- | --- | --- | --- |
| `DAT-001` | GameState session values | GameScene / menu | all scenes | process lifetime only |
| `DAT-002` | `photos`, `sceneries`, `letters`, `fish`, `voyage_records` string arrays | GameScene | Album | process lifetime only; full memory save undecided |
| `DAT-003` | `boat_decor`, `boat_decor_appearances` dictionaries | decor controls | BoatSpace | `user://boat_decor_v1.cfg` |
| `DAT-004` | player style and pet type IDs | identity controls | IdentityVisualRouter | `user://identity_profile_v1.cfg` |
| `DAT-005` | `selected_mood`, `selected_time_of_day` | legacy menu | legacy game/Album | product-superseded; migration required |
| `DAT-006` | `together_time_seconds` float | active foreground `GameScene` delta | `AlbumView` | `user://together_time_v1.cfg`; invalid/missing/non-finite/negative values become `0.0`; no level conversion |
| `DAT-007` | pending discovery type/value | old discovery offer | GameScene | product-superseded; replace or migrate explicitly |
| `DAT-008` | `ambient_memories` string array | `GameState.record_ambient_memory` on `save_memory=true` director event | Album scenery count/latest scenery and fading note | `user://ambient_memory_v1.cfg`; malformed/non-string/blank entries are omitted; legacy generic scenery is not migrated |

### State machines

```text
Voyage: INACTIVE -> ACTIVE -> RECORD_CREATED -> ACTIVE_RESTING -> (NEXT_VOYAGE -> ACTIVE)
Camera: DIORAMA <-> APPRECIATION
Fishing: IDLE -> WAITING -> BITE_READY -> IDLE; WAITING/BITE_READY -> CANCELLED -> IDLE
Legacy discovery: NONE -> PENDING -> RECORDED or EXPIRED
Target discovery: IDLE -> DISTANT_EVENT -> AUTO_SAVED_NOTE -> IDLE
```

## 13. SAVE/LOAD CONTRACT

- Current durable data is cosmetic identity, boat decoration, one global together-time float, and the ambient-only string ledger through `ConfigFile` under `user://`.
- Photos, letters, fish, voyage records, selected mood/time, and pending discovery remain process-lifetime state. Do not describe the partial memory set as a durable complete save.
- SYS-007 uses `TogetherTimePersistence` and `together_time_v1.cfg`; SYS-006 uses `AmbientMemoryPersistence` and `ambient_memory_v1.cfg`. Both normalize malformed local values to empty/default state and deliberately avoid unreliable legacy-value conversion.
- A failed ConfigFile load currently falls back to empty/default cosmetic state. This is an observed behavior, not proof of robust full-save recovery.

## 14. IMPLEMENTATION TRACEABILITY

| Experience | System | Content / UI | Implementation owner | Test or evidence | Gap |
| --- | --- | --- | --- | --- | --- |
| `EXP-001` | `SYS-001`, `SYS-009` | `UI-001`, `CNT-001/004` | `project.godot`, GameScene, `RealTimeAtmosphereResolver`, `TimeOfDayCatalog` | direct-entry/atmosphere contracts and captures | Human comfort `NOT_RUN` |
| `EXP-002` | `SYS-003` | `CNT-002/003`, `UI-004` | profiles, router, decor slots | persistence/identity/decor contracts | entry relocation |
| `EXP-003` | `SYS-002` | `UI-003` | camera controller, GameScene | camera/game scene contracts | human comfort |
| `EXP-004` | `SYS-004`, `SYS-005` | `CNT-005`, `UI-002/005` | GameScene, AlbumView | catch/quiet/cancel fishing, interaction, and Album contracts plus controlled capture | delayed-letter persistence remains partial |
| `EXP-005` | `SYS-006` | `CNT-006`, `UI-006` | `DriftSceneryDirector`, `GameState.record_ambient_memory`, `AmbientMemoryPersistence`, GameScene | director + ambient persistence/state/game-scene contracts and controlled capture | Human long-run observation `NOT_RUN` |
| `EXP-006` | `SYS-007` | Album summary | `GameState`, `TogetherTimePersistence`, `TogetherTimePresentation`, `AlbumView` | together persistence/state/game-scene contracts + Album capture | Human readability/pressure `NOT_RUN` |
| delayed correspondence | `SYS-008` | `CNT-007` | future isolated boundary | moderation release checklist | not ready |

## 15. TEST AND QA CONTRACT

### Existing automated evidence

`test_*.gd` passed: Album composition/memory, boat decor persistence and UI, calm voyage state, camera input, identity profile/visuals, diorama camera, final decor, catch/quiet/cancel fishing, game scene, time-of-day catalog/application, low-pressure interaction and content, legacy main menu, resting core, runtime capture guard/image asset, storybook art card, and Windows export contract.

### What that evidence does not prove

- No current automated test proves Human calm, touch usability, motion sensitivity, text readability, audio comfort, long-run scenery presentation, or safety-gated bottle release.
- Headless scene exit is not player-comfort, touch usability, audio comfort, or visual-art approval.
- Every 540×960 capture proves only its recorded route and state. It does not prove Human calm, device usability, or unrecorded long-run behavior.

### Target test cards

| QA ID | Connected system | Pass condition | Current result |
| --- | --- | --- | --- |
| `QA-001` | SYS-001 | clean startup opens game scene with no selector | `PASS` direct-entry contract + game smoke + 540×960 capture |
| `QA-002` | SYS-009 | injected hours map correctly without state/reward changes | `PASS` resolver/state/atmosphere contracts + four-time capture |
| `QA-003` | SYS-006 | background time does not advance; zero-event five-minute voyage is valid; no input or affinity mutation; current-time motif maps to its quiet label and portrait-safe backdrop position; saved ambient scenery restores locally | `PASS` director + ambient persistence/state/game-scene/motif contracts and six controlled motif captures; Human long-run observation `NOT_RUN` |
| `QA-004` | SYS-007 | actions/speed/species do not change together-time; Album-only display | `PASS` persistence/state/game-scene contracts + Album composition/memory contracts + 540×960 GPU Album capture; Human readability/pressure `NOT_RUN` |
| `QA-005` | SYS-003 | cosmetic persistence restores only cosmetic choice; in-voyage selectors update an independent preview without changing rewards or the first-view backdrop | `PASS` decor-preview contract + 540×960 GPU capture; Human readability `NOT_RUN` |
| `QA-006` | SYS-002 | both camera modes keep voyage/soundscape neutral | `PARTIAL_PASS`; human comfort `NOT_RUN` |
| `QA-007` | visual target | 540x960 direct-entry contact, hierarchy, and six optional natural landmarks read clearly without shrinking the rear boat frame | `PASS` eight time/camera captures plus six controlled motif captures inspected; Human comfort `NOT_RUN` |
| `QA-008` | human experience | first 30 sec, five-minute calm, touch, audio comfort | `NOT_RUN` |
| `QA-009` | SYS-004 | catch, quiet no-catch, cancellation, and short interaction response stay non-punishing and visible | `PASS` focused contracts plus two 540×960 OpenGL capture states; Human readability `NOT_RUN` |

## 16. VERTICAL SLICE DEFINITION

### Next smallest valuable slice

**Direct boat entry with visual-only local-time atmosphere and passive foreground scenery.**

- **In scope:** main route to normal diorama; remove mood/time startup inputs; injectable local-hour mapper; shared camera tone; foreground-only distant scenery director with a 90–150 second first opportunity, 65% per-opportunity display, and 120–180 second follow-up opportunities; passive optional note; named ambient-memory persistence; in-voyage cosmetic entry; focused tests/captures/docs.
- **Out of scope:** seasons, weather API, location astronomy, social systems, new asset batches, maps, quests, economy, interaction with distant structures, and bottle release. Together-time was implemented separately under `docs/superpowers/specs/2026-08-30-foreground-together-time-design.md`.
- **Primary source:** `docs/superpowers/plans/2026-08-29-real-time-atmosphere-and-drifting-scenery.md`.
- **Issue/PR boundary:** do not mutate or absorb open PR #19. Confirm the exact current GitHub Issue and implementation branch at execution time.

## 17. RISKS AND BLOCKERS

| RSK ID | Risk | Early signal | Mitigation | State |
| --- | --- | --- | --- | --- |
| `RSK-001` | Product code drift keeps legacy menu as actual first impression | `run/main_scene` no longer targets `game.tscn`, or a startup panel returns | direct-entry route and contract keep `game.tscn` as the actual first impression | managed by the 2026-08-31 direct-entry contract; Human first-impression review remains open |
| `RSK-002` | Calm loop becomes a reward loop | live level, popup, visible odds/countdown, dense notes | enforce SYS-006/007 acceptance tests and inspect the live player-facing route | managed by current state/scene/Album contracts; Human pressure review remains open |
| `RSK-003` | Old captures are mistaken for new target proof | capture caption lacks route/baseline | label all evidence with route and ceiling | managed |
| `RSK-004` | Local together-time data loses or misstates value | malformed ConfigFile or undefined legacy conversion | v1 schema, normalization to `0.0`, no unreliable level conversion, persistence contract | managed; Human readability/pressure remains open |
| `RSK-005` | Generated/reference art is presented as runtime proof | consumer/provenance missing | retain asset matrix and capture labels | managed |
| `RSK-006` | Bottle scope leaks into chat/public social | presence/feed/realtime requests | isolated boundary and hard release gate | blocked by policy |
| `RSK-007` | Headless shutdown warnings mask a real lifecycle regression | generated `AudioStreamWAV` appears without a display output or warning count grows | keep the persistent owner but skip stream allocation in headless mode; explicitly stop and clear the stream before standalone GPU contract exit; keep `ViewportTexture` capture GPU-only | managed by 51/51 warning-free headless contracts and 5/5 OpenGL game-scene checks on 2026-08-31; Human audio comfort and real-device close behavior remain open |

## 18. USER DECISION REQUIRED

The destination-free meaning of rest is user-confirmed for this revision. The following are intentionally **Undecided** and must not be invented during implementation:

- future passive-discovery density, motif weight, seed policy, and notification copy beyond the user-approved 90–150 second first opportunity, 65% per-opportunity display, and 120–180 second follow-up;
- accessibility option set and shipping-platform matrix;
- Bottle backend launch timeline after its safety gate is met.

## 19. IMPLEMENTATION QUEUE

1. **MVP - Direct boat entry / atmosphere / passive scenery.** Direct entry, visual atmosphere, and no-guarantee passive scenery are `IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_CAPTURE_VERIFIED` on 2026-08-30. The remaining boundary is a Human first-30-second and five-minute calm/noticeability review.
2. **Feature - Quiet companion together-time.** `IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_CAPTURE_VERIFIED` on 2026-08-30. Keep Human readability and pressure review outside this completion claim.
3. **Feature - Chibi normal foreground, Look Around camera, and alternate family.** The default C+dog normal foreground material, local input, three-camera state routing, foreground-state invariance, four approved chibi angle assets, and seven user-approved alternate identity/`stripe`·`moon` copies are `IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_CAPTURE_VERIFIED`. The default route, saved IDs, reward model, and camera state remain unchanged. Human/device approval remains separate.
4. **Polish - Human calm and accessibility review.** Run first-30-second, five-minute, touch, motion, text, and audio checks on target devices. Include the actual Look Around and chibi-normal surfaces in motion/comfort review. Keep every unrun dimension explicit.
5. **Deferred - Bottle system.** Do not enable public DriftBottle before the safety/release gate is fully evidenced.

## 20. BENCHMARK AND FIELD RESEARCH

| Reference | What works | Adapt | Reject | Differentiation |
| --- | --- | --- | --- | --- |
| [Townscaper](https://store.steampowered.com/app/1291340/Townscaper/) | immediate visual response and no goal pressure | cosmetics as a beautiful low-stakes action | building sandbox as primary loop | a lived-in boat with avatar and companion |
| [A Short Hike](https://ashorthike.com/press/) | player-paced exploration and quiet landscape attention | optional photo/fishing cadence | summit-driven progression and collectible gating | staying still is valid, not merely a pause between exploration |
| [TOEM](https://www.playstation.com/pt-pt/games/toem/) | camera makes observation legible and relaxing | photo as a gentle memory verb | puzzle/errand completion as the reason to photograph | no task queue and no photo objective |
| [Alba](https://store.steampowered.com/app/1337010/Alba_A_Wildlife_Adventure/) | warm nature place and self-paced tone | readable small discoveries | volunteer, species, and collection completion pressure | personal reflection instead of civic objective |
| [Sail Forth](https://www.sailforthgame.com/press/) | sea movement, regions, and ambient audio identity | calm wind/sea presence | adventure-scale fleet/progression content | fixed intimate diorama, not expedition management |
| [DREDGE](https://www.dredge.game/) | memorable boat-sea tension contrast | only the clarity of boat/sea readability | survival, selling, upgrades, quests, fog threat, nighttime fear | sea as refuge rather than danger |

**Adopt:** no-pressure self-expression, readable place, and optional observation verbs.

**Adapt:** photography/fishing only as personal moment-makers, never required objectives.

**Reject:** survival, profit, upgrade ladders, quest chains, timed danger, complete-the-set loops, and mandatory helping.

**Differentiation:** a visible avatar, companion, boat, and open horizon share one small place where staying is already play.
**Remaining uncertainty:** whether the proposed calm density and compact controls remain comfortable for five minutes on a real portrait device.

## 21. FIVE-LOOP ADVERSARIAL REVIEW RECEIPT

| Loop | Attack focus | Evidence checked | Finding and correction | Residual state |
| --- | --- | --- | --- | --- |
| 1 | Authority drift | Base two-artifact policy, project `AGENTS.md`, current `main` SHA, GitHub Issues/PRs | Kept the prescribed pair only; treated the attached PDF as a format example; did not modify open PR #19. | clean for publication |
| 2 | Player-value and scope creep | current canon, `DEC-001` to `DEC-009`, forbidden-feature list | Preserved direct entry, rest-first play, optional photo/fishing/decor, delayed bottles, and zero-valid passive scenery; rejected old selector friction and reward pressure. | Human calm/noticeability review remains open |
| 3 | Feasibility and shared-state hazards | `project.godot`, Autoloads, scene/script inventory, Godot primary documentation | Implemented direct entry, visual-only local time, ambient-only persistence, action-free together-time, and no-guarantee cadence while retaining legacy routes as non-product slices. | Human/device evidence remains before final experience completion |
| 4 | Evidence and provenance overclaim | 51 contract test results, headless smoke outputs, GPU capture/asset inventory | Separated current runtime proof, approved direction, and needs-validation claims. The `AudioStreamWAV`/playback leak was reproduced, bounded to headless allocation and short GPU-test teardown, then covered by explicit release and clean 51-test/smoke outputs. | clean for current automated scope; Human/device/audio-comfort evidence remains open |
| 5 | Human readability and handoff completeness | PDF page map, visual-asset provenance, source registry, benchmark decision | Revision 2.2 records user approval and canonical registration of the generated main screen, four distinct natural landmarks, and image-based flow. The regenerated 14-page PDF was rendered at 160 dpi; its four contact sheets plus detailed checks of pages 2, 5, 6, 7, 8, 9, 13, and 14 found no clipping, overlap, placeholder, or missing-image defect. | portrait-device, 5-minute, touch, motion, text, and audio checks remain manual |

## 22. CHANGE LOG

| Version | Date | Change |
| --- | --- | --- |
| `1.0.0` | 2026-08-29 | Rebuilt the AI production specification from current Base policy, project canon, source code, test readback, evidence inventory, official engine/accessibility sources, and benchmark review. This document does not claim implementation of the approved Phase 2 target. |
| `2.0.0` | 2026-08-30 | Published the destination-free rest Blueprint review revision. It defines slow shared boat movement as atmosphere rather than a route, goal, reward, or progression system, and pairs the human review PDF with this exact specification. |
| `2.1.0` | 2026-08-30 | Rebuilt the human Blueprint around a generated direct-entry main-screen candidate, four distinct healing natural landmarks, and an image-based flow candidate. Removed the initial 3D scene-atlas references and the nonessential prior pages 19 to 22. Candidate images remain human-review-only and non-canonical. |
| `2.2.0` | 2026-08-30 | Recorded explicit user approval for all six Blueprint images, moved the approved bytes to the Human Blueprint canonical asset path with unchanged SHA-256 provenance, and updated the paired PDF labels from candidate review to approved visual direction. This does not authorize Godot implementation or claim runtime verification. |
| `2.3.0` | 2026-08-30 | Implemented the user-approved direct boat entry MVP. Removed mood/saved-time setup state, connected local-time visual-only atmosphere and five approved image consumers, replaced action-gated discovery with foreground-only passive scenery, captured eight 540×960 runtime frames, and recorded 28/28 automated contracts. Human comfort, touch, motion, text, sound, and the long-run lagoon event remain unverified. |
| `2.4.0` | 2026-08-30 | Captured the approved bright lagoon on the actual normal runtime surface through a controlled foreground event. The event now uses its matching quiet label. This is runtime-capture evidence only; Human comfort and long-run event presentation remain unverified. |
| `2.5.0` | 2026-08-30 | Added local player and companion selectors plus an independent `DecorPreview` BoatSpace consumer to the in-voyage decor panel. The fixed approved first-view backdrop stays untouched, while the preview is captured with an alternate identity and decor state. |
| `2.6.0` | 2026-08-30 | Replaced the retired action-based companion level with active-foreground local together-time. Added v1 persistence, Album-only duration/relation copy, no-farming contracts, and a 540×960 runtime Album capture. Human readability and pressure remain unverified. |
| `2.7.0` | 2026-08-30 | Implemented the ambient auto-save boundary with a dedicated v1 string ledger. Only `save_memory=true` foreground scenery calls the named writer; malformed entries are omitted, generic scenery helpers are not migrated, and photo/letter/fish/voyage persistence remains out of scope. The current deterministic first event is explicitly retained as a product conflict, not a completion claim. |
| `2.8.0` | 2026-08-30 | Implemented the user-approved no-first-guarantee ambient cadence. The director now schedules a 90–150 second first opportunity, independently displays each opportunity with a 65% chance, and schedules every following opportunity at 120–180 seconds even after an empty opportunity. A five-minute zero-event foreground voyage is now an automated valid outcome. Human calm, noticeability, text readability, and device comfort remain unverified. |
| `2.9.0` | 2026-08-30 | Added the user-directed Look Around skeleton. A third local camera, drag controller, explicit mode routing, and requested-angle/fallback separation are verified by focused contracts without changing voyage state. Four original angle compositions are generated candidates only; user approval, canonical registration, runtime image connection, GPU capture, and Human motion review remain pending. |
| `3.0.0` | 2026-08-30 | Recorded user approval and canonical registration of the transparent-water chibi `port`, `starboard`, `aft`, and `overhead` angle art. The local router now maps only those exact assets, hides the duplicate normal card for non-front views while preserving BoatSpace/water-contact motion state, and guards foreground scenery from replacing selected angle art. Focused contracts and six 540×960 OpenGL GPU captures passed. Normal-Diorama foreground replacement remains a separate user-review candidate; Human/device comfort remains unverified. |
| `3.1.0` | 2026-08-30 | User-approved the normal chibi foreground treatment and connected the derived green technical matte to the default C+dog `FinalDioramaCard`. An explicit `matte_texture` shader uniform removes only the technical green background while retaining the water-only local-time backdrop, BoatSpace bob, and water contact. GPU material proof, final-card/direct-entry regressions, clean normal capture, and dawn/bright/sunset/night captures passed. Alternate identity and saved decor art are intentionally not claimed as chibi-family-complete; Human/device comfort remains unverified. |
| `3.2.0` | 2026-08-30 | User-approved the chibi floral cushion and moonlit postcard replacements for the saved default C+dog decor selections. The canonical files retain exact candidate SHA-256 bytes, the existing `floral`/`postcard` keys resolve to them without data migration, and the final-composite surfaces moved to compact bow/stern clear zones so they do not cover the player or dog. Decor, capture-guard, and actual saved-selection GPU capture checks passed. Alternate identity and unselected decor variants remain outside this claim; Human/device comfort remains unverified. |
| `3.3.0` | 2026-08-30 | Added local `standard/gentle/still` motion comfort without altering time, speed, rewards, atmosphere, or saves. The public photo control now saves a UI-free rendered PNG and local metadata, and Album reads the newest three valid images without score, reward, sharing, or deletion mechanics. Persistence, state, scene, Album, and OpenGL runtime capture checks passed. Human motion/readability comfort remains unverified. |
| `3.4.0` | 2026-08-30 | User-approved a rear three-quarter default normal composition. The player now rests against the stern-side rail with a visible back view and the dog beside them. The approved source and derived green technical matte are separately registered with SHA-256 provenance; only `DioramaCameraRig` moved to the stern side, while Look Around and Appreciation remain independent. Rear-card, material, bright/night GPU capture checks passed. Human/device comfort remains unverified. |
| `3.5.0` | 2026-08-30 | User-approved six water-only natural motifs and their exact canonical copies. `DriftSceneryDirector` now selects only the matching local-time motif during an active-foreground opportunity, preserves the no-first-guarantee 90–150 / 65% / 120–180 cadence, and avoids immediate bright/sunset repetition. A portrait projection probe showed outer landmarks were cropped by the fixed rear-diorama camera; per-motif `Sprite3D` horizontal offsets preserve the approved boat frame while revealing each landmark. All 45 headless contracts, two OpenGL GPU contracts, and six 540×960 motif captures passed. Human/device comfort remains unverified. |
| `3.6.0` | 2026-08-30 | Final rear-chibi GPU capture exposed that the old square postcard overlay sat over the player head; a node-visible-only contract had missed it. The same user-approved source now renders only its actual postcard region (`Rect2(120, 295, 1020, 670)`) as a compact rear memory card. It clears the player, dog, and simultaneously selected floral cushion without changing saved keys, source bytes, voyage state, or rewards. RED→GREEN decor contract and saved-decor 540×960 OpenGL GPU capture passed. Human/device comfort remains unverified. |
| `3.7.0` | 2026-08-30 | User clarified that the selected rail postcard does not need to appear on the main rest screen. The experimental final-composite postcard node was removed instead of merely hidden. The main C+dog rest image consumes only the floral cushion overlay, while the same `rail_accent=postcard` key remains a real independent DecorPreview rail face and voyage photo postcards remain Album content. A RED→GREEN omission contract plus main and preview 540×960 OpenGL GPU captures passed. Human/device comfort remains unverified. |
| `3.8.0` | 2026-08-30 | Implemented the approved bounded local memory ledger. `MemoryLedgerPersistence` stores only normalized fish and completed voyage-summary strings in `user://memory_ledger_v1.cfg`; `GameState` saves after a catch and one post-zero completion, then restores them for the existing Album. Delayed bottle letters are neither read nor written. RED→GREEN persistence/state contracts and a restored 540×960 OpenGL Album capture passed. Human readability remains unverified. |
| `3.9.0` | 2026-08-31 | Completed the bounded quiet-action slice. `CalmFishingSession` now distinguishes catch, quiet no-catch, and cancellation without penalties, score, streaks, or rewards; only a catch retains the existing fish-memory save. Added companion `나란히 쉬기` and rail `파도 소리 듣기` responses with no progression side effect. RED→GREEN focused contracts, game-scene OpenGL contract, and two 540×960 GPU captures passed. Human readability remains unverified. |
| `3.10.0` | 2026-08-31 | Generated seven alternate A/B player, cat/rabbit/otter, and `stripe`/`moon` cushion visual candidates to align old high-detail variants with the current cute soft-matte chibi direction. They are copied to the repository visual-candidate path with dimensions, alpha/full-bleed inspection, SHA-256 provenance, and intended consumers. They remain `GENERATED_CANDIDATE / USER_REVIEW_PENDING`; no canonical asset, runtime consumer, or saved selection was changed. |
| `3.11.0` | 2026-08-31 | User-approved all seven alternate chibi candidates. Exact source bytes were copied to non-destructive canonical runtime paths, while existing identity and decor save IDs were preserved. The selected `Sprite3D` and cushion texture consumers, capture guard, and focused contracts now use those paths. Three 540×960 OpenGL captures cover A+cat+stripe, B+rabbit+moon, and A+otter+stripe. Headless checks no longer start a generated audio stream with no output device, resolving the repeated two-instance ObjectDB shutdown warning without changing player-facing sound design. Human/device visual and audio comfort remain unverified. |

## 23. EXTERNAL REFERENCES

- [Godot Autoload](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)
- [Godot Time](https://docs.godotengine.org/en/stable/classes/class_time.html)
- [Godot ConfigFile](https://docs.godotengine.org/en/stable/classes/class_configfile.html)
- [Godot user data paths](https://docs.godotengine.org/en/stable/tutorials/scripting/filesystem.html)
- [Godot scene changes](https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html)
- [Xbox Accessibility Guidelines](https://learn.microsoft.com/en-us/gaming/accessibility/xbox-accessibility-guidelines/)
