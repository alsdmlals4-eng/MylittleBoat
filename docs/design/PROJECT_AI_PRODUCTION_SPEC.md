# My Little Boat - AI Production Specification

> **Profile:** `DESKTOP_GPT_TWO_ARTIFACT_MASTER_GDD`
> **Publication date:** 2026-08-28
> **Source snapshot:** `origin/main` at `a419d2a91dd8c4e8b72576fe65220e624c439049`
> **Scope:** current-authority design and implementation contract. This document does not replace runtime truth in `.gd`, `.tscn`, `project.godot`, tests, build logs, or captures.

## 00. CANON SNAPSHOT

| Field | Current truth |
| --- | --- |
| Project | `my little boat` - rest-first cozy boat diorama / healing voyage game |
| Engine / target frame | Godot 4.7, GDScript, 540 x 960 portrait-first, PC mouse support |
| Player promise | A visible avatar, companion, personal boat, decor and sea form a calm place where simply staying is complete play. |
| Normal presentation | Calm 3/4 boat diorama. Avatar + pet + boat + sea remain readable together. |
| Alternate presentation | Appreciation Camera shifts attention to sea/horizon with most nonessential UI hidden. |
| Current product stage | Phase 1 design canon and prior visual/runtime slices are merged; new product decisions await a separately approved Phase 2 implementation contract. |
| Work five-phase position | Phase 1 `RECONFIRMED_AFTER_CANON_CORRECTION`; Phase 2-4 complete only for the earlier visual/runtime/package slice; Phase 5 exact packaged human validation `NOT_STARTED`. |
| Protected independent work | PR #19, `feat/social-fake-backend-20260824`, is open and `READ_ONLY_NO_ABSORPTION`. |
| Evidence ceiling | Automated contracts, scene smokes, selected 540 x 960 captures and machine Windows package evidence exist. Real-device touch, five-minute calm, human audio comfort, and human Windows launch are `NOT_RUN`. |

### Status vocabulary

`DOCUMENTED` -> `CONFIRMED` -> `IMPLEMENTED` -> `AUTOMATED_TEST_PASS` -> `RUNTIME_VERIFIED` -> `UX_VERIFIED` -> `RELEASE_READY` is a one-way evidence ladder. A later state is never inferred from an earlier one.

### Current reconciliation

| ID | Item | Current direction | Current implementation | Disposition |
| --- | --- | --- | --- | --- |
| DEC-001 | Rest-first voyage | Doing nothing is valid and optional activities have no pressure. | Normal/alternate camera, fishing, decor and interactions exist. | `CONFIRMED`, partly implemented. |
| DEC-002 | Companion relation | Active foreground voyage time only; quiet Album display; no live level. | Photos/scenery/letters mutate `companion_affection`; live `Lv` remains in voyage and album UI. | `PRODUCT_SUPERSEDED_IMPLEMENTATION`; Phase 2 contract required. |
| DEC-003 | Ambient Discovery | Random, low-density, passive visual memory; auto-save; no input; Normal/Appreciation parity. | Forced early, action-gated letter/scenery offer; Appreciation stops scheduling. | `PRODUCT_SUPERSEDED_IMPLEMENTATION`; Phase 2 contract required. |
| DEC-004 | Visual direction | `HANDPAINTED_STORYBOOK_3D_DIORAMA` + `SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT`; Night is `INDIGO_RAIN_REFLECTION`. | Earlier runtime art/time tones are consumed. | Planning lock is `APPROVED_DIRECTION`; full runtime alignment is `NOT_IMPLEMENTED`. |
| DEC-005 | Visual exploration approval | GPT generates and performs internal QA first; user confirms only a final direction lock. | Documentation/process policy only. | `CONFIRMED` by latest user direction. |

## 01. SOURCE REGISTRY

| Source ID | Owner / locator | Read on | Role | Status |
| --- | --- | --- | --- | --- |
| SRC-001 | Latest user direction in this task | 2026-08-28 | GDD publication and generate-first/final-lock-only visual workflow | `CURRENT` |
| SRC-002 | `AGENTS.md` | 2026-08-28 | Engine, local-first and safety constraints | `CURRENT` |
| SRC-003 | `origin/main` `a419d2a...` | 2026-08-28 | Completed project GitHub baseline | `CURRENT` |
| SRC-004 | GitHub PR #19 | 2026-08-28 | Independent open candidate only | `OPEN_READ_ONLY` |
| SRC-005 | `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`, `docs/CONCEPT.md`, `docs/RESTING_EXPERIENCE_BIBLE.md` and approved repository decision/visual locks | 2026-08-28 | Current human-facing project canon | `CURRENT_REPOSITORY_HUMAN_CANON` |
| SRC-006 | Previous Notion Home / Flow / Visual Bible / asset-library locators | 2026-08-28 | One final user-authorized read-only migration completed; repository receipt owns the transfer readback | `MIGRATED_THEN_LEGACY_DISCOVERY_ONLY` |
| SRC-007 | Repository asset binaries, provenance, consumer manifests and runtime evidence | 2026-08-28 | Current asset/consumer truth | `CURRENT_REPOSITORY_CANON` |
| SRC-008 | `docs/CONCEPT.md`, `docs/RESTING_EXPERIENCE_BIBLE.md`, current handoffs | 2026-08-28 | Repository structured design mirror | `CURRENT` |
| SRC-009 | Scenes/scripts/tests/assets/evidence at SRC-003 | 2026-08-28 | Runtime and automated implementation truth | `CURRENT` |
| SRC-010 | Base `docs/PROJECT_MASTER_GDD_TWO_ARTIFACT_POLICY.md` at `af870522...` | 2026-08-28 | Two-artifact publication profile | `ADAPTED` |
| SRC-011 | Official product/store pages listed in §27 | 2026-08-28 | Bounded market/reference research | `CURRENT_EXTERNAL_EVIDENCE` |
| SRC-012 | §29 in this Master GDD | 2026-08-28 | Final source-structure and approved-asset migration receipt | `CURRENT_REPOSITORY_MIGRATION_RECEIPT` |

**Attachment disposition.** The supplied work instruction is a formatting/reference input. Its `NO_AUTOMATIC_IMAGE_GENERATION` rule is superseded by the latest user direction. Its no-Notion-output rule now matches the repository-only authority migration: Notion is retained only as an untouched historical discovery archive.

## 02. CURRENT PROJECT STATE

### Classification register

| Class | Facts |
| --- | --- |
| `CURRENT` | Rest-first loop, local-first core, four time IDs, C knit/long-hair + dog default anchor, cosmetic identity/decor, normal/Appreciation camera semantics, the two new product decisions and their evidence boundaries. |
| `HISTORICAL` | Pre-integration image queues, early visual boards, early action-gated discovery slice, action-based affection placeholder. |
| `SUPERSEDED` | Mandatory first discovery, Letter/Scenery action buttons as discovery confirmation, event suppression in Appreciation, action-earned affection, live `Lv` relation display, Core Scene Board v2's character anchor. |
| `CONFLICT` | Current code/tests still implement the two superseded behaviours described by DEC-002 and DEC-003. Some old visual/handoff wording calls automatic generation conditional on a consumer; the latest user direction removes per-generation approval but not consumer/provenance gates. |
| `UNKNOWN_UNVERIFIED` | Exact affection rate/format/persistence migration; ambient algorithm/motifs; final art/model pipeline; motion comfort; Human five-minute rest; actual touch/audio/package launch; release platform/store plan. |

### Current goal and accepted frontier

**Current project goal:** make a short, calm, personal sea-rest session compelling even when the player does nothing, while optional expression and small memories deepen attachment without chores, grind, fear, or social pressure.

**Accepted frontier:** turn the two already-approved direction packets into one bounded Phase 2 implementation contract, after design review. It must replace superseded affection/discovery behaviour and align only their necessary UI, data, tests and runtime evidence. It must not begin an asset batch, broaden Bottle scope, or implement PR #19.

## 03. CONFIRMED DECISIONS

| ID | Decision | Binding result |
| --- | --- | --- |
| DEC-001 | Free rest voyage | Main action is peaceful drifting and looking at sea, avatar and companion. Photo, fishing, decor and interaction are optional. |
| DEC-002 | Together time | One global, cosmetic-neutral together-time ledger gains only during active foreground voyage time; normal and appreciation count equally, even after the five-minute record. |
| DEC-003 | Quiet relation presentation | First display belongs in `AlbumView`: readable together-time plus one noncompetitive relation sentence. No voyage/alternate-camera levels, numbers, bars or growth popups. |
| DEC-004 | Passive ambient discovery | One-at-a-time, random background presentation with a tiny auto-fading notification and immediate local ambient-memory save. Not a Bottle, letter, reward or task. |
| DEC-005 | Ambient density | Approximately 1-2 events per nominal five-minute voyage; no first-event guarantee; zero is normal. Exact probability/cooldown remain undecided. |
| DEC-006 | Visual lock | Soft storybook 3D parent, handpainted storybook 3D detail, soft manga chibi character/pet refinement, same four time IDs, Night as indigo rain reflection. |
| DEC-007 | Visual approval execution | Generate substantive candidate explorations and internally QA them without pre-generation approval. Ask user to lock only the final selected direction; record adopted/rejected elements and provenance. |

## 04. DESIGN PILLARS

1. **Rest is play.** The player can leave every optional system untouched and still receive the intended experience.
2. **A small shared place.** Avatar, companion, personal boat and sea form one readable, lived-in composition.
3. **Quiet agency, no optimization.** Mood, time, identity and decor express preference; none creates a best build.
4. **Memory instead of score.** Photos, catches, ambient memories and voyage records are personal traces, never pressure meters.
5. **Sea first.** Horizon, sound and slow environmental change carry the frame; UI and props stay secondary.

## 05. PLAYER EXPERIENCE CONTRACT

```text
Player promise
  -> Choose a feeling and enter a personal boat at sea
  -> Watch the avatar and companion quietly share the view
  -> Optionally photograph, fish, decorate or interact
  -> See a small personal trace, never an efficiency grade
  -> Feel settled, gently accompanied and willing to stay a little longer
```

- **Representative action:** enter the diorama and simply remain long enough to notice the sea, companion and a rare change.
- **Meaningful choice:** what mood/light/identity frames the moment and whether an optional activity suits the player's mood now. The trade-off is attention versus stillness, not gain versus loss.
- **Observable result:** a mood-tinted scene, camera change, quiet interaction response, a personal memory or a locally saved ambient moment.
- **Reward / failure learning:** memory and attachment. There is no failure state; an event not seen, a fish not caught, or an activity ignored is not a deficit.
- **First-session memory:** “My tiny boat kept floating; I did not have to do anything, but it still felt like mine.”
- **Differentiation / sales hook:** a mobile-portrait sea-rest diorama that treats visible companionship and lingering time as the core content rather than as a reward skin over chores or productivity.

## 06. CORE / SESSION / META LOOP

| Loop | Contract | Current state |
| --- | --- | --- |
| Core | Mood/light/identity -> enter diorama -> rest or optionally interact -> small response/memory -> remain or record | `PARTIAL_IMPLEMENTED` |
| Session | About five minutes of active voyage; record once at zero; player may remain or start the next voyage | `IMPLEMENTED`, Human pace `NOT_RUN` |
| Meta | Personal boat appearance, local cosmetic identity, album and gentle together-time/ambient-memory history | Existing decor/identity/album `IMPLEMENTED`; together-time and ambient-memory semantics `CONFIRMED_NOT_IMPLEMENTED` |

## 07. SYSTEM REGISTRY

| ID | System | Player contract | State |
| --- | --- | --- | --- |
| SYS-001 | Voyage rest and timer | A five-minute drift frames a calm session; staying later remains valid. | `IMPLEMENTED` |
| SYS-002 | Normal / Appreciation camera | Choose shared diorama or low-UI sea/horizon focus without changing time/reward/soundscape. | `IMPLEMENTED`; UX `NOT_RUN` |
| SYS-003 | Mood and four-time atmosphere | Select presentation tone, not a gameplay advantage. | `IMPLEMENTED` for current tones; latest lock alignment `NOT_IMPLEMENTED` |
| SYS-004 | Companion together-time | Active foreground voyage time expresses companionship without farming. | `CONFIRMED_NOT_IMPLEMENTED` |
| SYS-005 | Passive ambient discovery | Rare background event automatically becomes a local personal memory. | `CONFIRMED_NOT_IMPLEMENTED` |
| SYS-006 | Quiet optional activities | Photo, fishing, decor and low-pressure interactions give optional texture with no loss. | `IMPLEMENTED_PARTIAL` |
| SYS-007 | Personal boat decor | Eight zones and six cosmetic item meanings create a lived-in boat, no stats. | `IMPLEMENTED` |
| SYS-008 | Cosmetic identity | Three player styles and four companions are local visual choices only. | `IMPLEMENTED` |
| SYS-009 | Album / voyage memory | Reflect real local records without fake content. | `IMPLEMENTED_PARTIAL` |
| SYS-010 | Soundscape | Wave-first authored ocean bed supports passive rest. | `IMPLEMENTED`; human listening `NOT_RUN` |
| SYS-011 | Delayed Bottle boundary | Future delayed correspondence only; never realtime social. | `DOCUMENTED_DEFERRED` |

## 08. SYSTEM SPECIFICATIONS

### SYS-004 - Companion together-time

| Field | Contract |
| --- | --- |
| Why | Makes quiet co-presence meaningful without converting optional actions into farming. |
| Entry / exit | Accrues only while the voyage scene is active and foreground processing advances. Stops in menu, album, pause/background. |
| Rules | Same global ledger for all cosmetic pets; normal and appreciation parity; speed/mood/time/photo/fishing/decor/discovery do not multiply it; post-record resting counts. |
| UI | Album summary only: duration + quiet relation line. Voyage and Appreciation never show live number, level, bar, milestone or toast. |
| Data | `DAT-004 together_time_seconds: float/int`, owner and persistent migration `NOT_IMPLEMENTED`. |
| Current conflict | `GameState.companion_affection`, `_increase_affection`, `MoodStatusLabel` and Album `Lv` are superseded. |
| Required Phase 2 proof | No-action accrual; normal/appreciation parity; no background/menu/album accrual; post-record continuity; identity neutrality; migration behavior; 540 x 960 game/album capture; human pressure review. |

### SYS-005 - Passive ambient discovery

| Field | Contract |
| --- | --- |
| Why | Keeps the sea alive without demanding vigilance; leaves a private trace. |
| Entry / exit | Active foreground voyage only; one event at a time. An auto-fading notification must finish before another event. |
| Rules | Approx. 1-2 per nominal five minutes; no guaranteed first event; zero is valid; both camera modes; no action, sound cue, reward, affinity, Bottle, letter, score, streak or FOMO. |
| UI | Small nonblocking auto-fade. Smaller/less obstructive in Appreciation. |
| Data | `DAT-005 ambient_memory` type/catalog/schedule/persistence/migration `NOT_IMPLEMENTED`. |
| Current conflict | Early 18-30 sec action-gated letter/scenery offer, repeat every 35-60 sec, pending state and camera suppression are superseded. |
| Required Phase 2 proof | Deterministic scheduling hooks; distribution-oriented density test; autosave/no input; no overlap; parity; no affinity/Bottle side effects; no burst on scene return; 540 x 960 captures; Human `CALM/EMPTY/NOTICEABILITY` review. |

### SYS-006 - Optional activities

| Content | Current rule | Existing owner | Boundaries |
| --- | --- | --- | --- |
| Photo | Make an album memory on button press. | `GameState.add_photo`, `TakePhotoButton` | Must not alter together-time. |
| Fishing | Cast -> wait -> bite -> catch; cancel costs nothing. | `FishingSession`, `FishingButton` | No pressure or required loop. |
| Decor | Select one compatible item for one of eight zones. | `BoatDecorCatalog`, `BoatDecorSlot` | No prices, rarity, stats or completion bonus. |
| Interaction | Pet, rail and placed decor expose calm local actions. | `LowPressureInteractable` | No relation/reward mutation. |
| Ambient | Passive, not an action. | Future SYS-005 | Do not use letter/scenery confirmation UI. |

## 09. CONTENT REGISTRY

| ID | Content | System | Status |
| --- | --- | --- | --- |
| CNT-001 | Today mood: calm/tired/lonely/excited | SYS-001/003 | `IMPLEMENTED` |
| CNT-002 | Four time states: dawn/bright/sunset/night | SYS-003 | `IMPLEMENTED`; visual lock alignment pending |
| CNT-003 | Default C knit/long-hair + dog anchor | SYS-008/visual | Current runtime anchor `IMPLEMENTED`; latest style lock production `NOT_IMPLEMENTED` |
| CNT-004 | Player style and pet choices | SYS-008 | `IMPLEMENTED` |
| CNT-005 | Boat decor slots and starter items | SYS-007 | `IMPLEMENTED` |
| CNT-006 | Photo/fishing/interaction moments | SYS-006 | `IMPLEMENTED_PARTIAL` |
| CNT-007 | Voyage record and Album | SYS-009 | `IMPLEMENTED_PARTIAL` |
| CNT-008 | Together-time relation trace | SYS-004 | `CONFIRMED_NOT_IMPLEMENTED` |
| CNT-009 | Ambient memory motif | SYS-005 | `CONFIRMED_NOT_IMPLEMENTED` |
| CNT-010 | FriendBottle / DriftBottle | SYS-011 | `DOCUMENTED_DEFERRED` |

## 10. CONTENT SPECIFICATIONS

### CNT-008 - Together-time relation trace

- **Purpose:** make a passive session feel personally shared when revisited, not measured while playing.
- **Unlock / variation:** no unlock, no tier, no pet-specific track. Exact copy catalogue and duration display are undecided.
- **Consumer:** `UI-003 AlbumView` only in first implementation.
- **Acceptance:** no level language in voyage screen, relation line does not imply a next reward/action, leaving/returning does not create false time.

### CNT-009 - Ambient memory motif family

- **Purpose:** low-density, background-only proof that the sea is alive.
- **Motif production:** `NOT_IMPLEMENTED`; create only after a Phase 2 consumer/algorithm contract. No generated board or motif is automatically a runtime asset.
- **Minimum semantic fields:** stable id, catalog version, occurrence timestamp/active-voyage context, presentation label/localization token, save status. Exact fields remain `DAT-005` contract work.
- **Acceptance:** immediate autosave, no action or rarity response, no social/letter identity, no duplicated notification.

## 11. UI/UX AND INPUT CONTRACT

| ID | Surface | Inputs | Required meaning | Current status |
| --- | --- | --- | --- | --- |
| UI-001 | Main Menu | Mood button, identity options, time-of-day option | Choose emotional and visual framing before entering sea. | `IMPLEMENTED` |
| UI-002 | Game Diorama | Photo, Appreciation, speed, fishing, decor, interaction, album | Optional low-pressure routes around rest. | `IMPLEMENTED_PARTIAL` |
| UI-003 | Album | Back, future quiet relation summary | View real personal memory and return to voyage. | `IMPLEMENTED_PARTIAL` |
| UI-004 | Appreciation Camera | Drag view, end appreciation | Sea/horizon focus with reduced UI. | `IMPLEMENTED`; UX `NOT_RUN` |
| UI-005 | Ambient notification | No input | Brief passive acknowledgement, auto-fades. | `NOT_IMPLEMENTED` |

### UX flow

```text
UX-001 Start
Main Menu -> choose mood/light/identity -> Game Diorama
      -> rest (complete play)
      -> optional photo / fish / decorate / interact / Appreciation
      -> passive ambient event may auto-save
      -> record at 5:00 -> stay, Album, or next voyage
```

Mobile requirement: environmental calm never excuses weak functional contrast. Primary buttons, focused selection and back path must remain readable in every time state at 540 x 960. Human touch/comfort validation remains pending.

## 12. VISUAL ASSET CONSUMER MATRIX

| ID | Asset family / locator | Consumer | Status / boundary |
| --- | --- | --- | --- |
| AST-001 | `assets/images/ui/main_menu/main_menu_{dawn,bright,sunset,night}_storybook_v1.png` | `main_menu.tscn`, `album.tscn` `AtmosphereBackground` | Runtime consumed and captured. Latest visual lock does not yet replace/re-align these assets. |
| AST-002 | `assets/images/runtime/storybook/boat_c_dog_diorama_storybook.png` | Main menu `DioramaAnchor`; boat-space composition | Runtime consumed/captured; latest style lock is not a production replacement. |
| AST-003 | `assets/images/runtime/storybook/sea_bright_storybook.png` | Normal/Appreciation `SeaBackdrop` | Runtime consumed/captured. |
| AST-004 | player/pet storybook cards | `boat_space.tscn`, identity router | Local cosmetic runtime consumer exists. |
| AST-005 | cushion trio and Bright postcard | decor material consumers | Runtime consumed/captured. |
| AST-006 | approved visual boards under `docs/visual/generated/` | Planning/approval evidence only | `NOT_RUNTIME_ASSET`, `NOT_GODOT_IMPLEMENTED`. |

**Visual execution policy:** Before an unapproved visual choice is locked, GPT may generate substantive candidate boards and QA them against the selected consumer, same camera/composition/information density, style lock, rights and readability. The user is asked only whether to lock a final direction. A generated board remains `GENERATED_EXPLORATION` until that lock and never becomes a runtime asset until an approved consumer, local binary/provenance, implementation, test and runtime proof exist.

## 13. AUDIO CONSUMER MATRIX

| ID | Audio | Owner / consumer | Status |
| --- | --- | --- | --- |
| AUD-001 | Authored 16-second stereo OceanBed | Autoload `RestingSoundscape` | `IMPLEMENTED`, automated wiring; human listening `NOT_RUN` |
| AUD-002 | Near water, wind, boat creak, distant nature/pet, UI | Layer priority contract in `RestingSoundscape` | `DOCUMENTED/NOT_IMPLEMENTED` as separate authored layers |
| AUD-003 | Rain audio | None | `FORBIDDEN_BY_DEC-006` |
| AUD-004 | Ambient discovery cue | None | `FORBIDDEN_BY_DEC-004`; visual notification only |

## 14. TECHNICAL ARCHITECTURE

```text
project.godot autoloads
  GameState ---------------------> scenes/main_menu.tscn -> scenes/game.tscn -> scenes/album.tscn
  RestingSoundscape                    |                      |                   |
                                  MainMenu.gd           GameScene.gd          AlbumView.gd
                                                           |        |
                                              BoatSpace scene     Fishing/Decor/Interaction services
```

- `GameState` currently owns process-lifetime mood/time, memory arrays, voyage state, decor and identity. It is a candidate owner for new data only after persistence/migration is explicitly designed.
- `BoatDecorPersistence` and `CosmeticIdentityProfile` isolate only their cosmetic local config storage.
- No actual backend is required for normal voyage/rest/decor/pet/album/fishing/soundscape.
- Future Bottle code belongs behind a dedicated social boundary and remains out of this GDD's next milestone.

## 15. DATA CONTRACTS

| ID | Data | Current owner / fields | Required change |
| --- | --- | --- | --- |
| DAT-001 | Voyage state | `voyage_active`, `remaining_seconds`, `speed_index`, `appreciation_mode`, `voyage_record_created` in `GameState` | Preserve semantic behaviour. |
| DAT-002 | Local memories | `photos`, `sceneries`, `letters`, `fish`, `voyage_records` arrays | Preserve; do not reclassify ambient events as letters. |
| DAT-003 | Cosmetic state | decor dictionaries, player/pet IDs and two ConfigFile services | Preserve local-only scope. |
| DAT-004 | Together time | `NOT_IMPLEMENTED`; legacy `companion_affection: int` exists | Define type, storage path, migration, accumulator lifecycle and display formatter in Phase 2. |
| DAT-005 | Ambient memory | `NOT_IMPLEMENTED`; legacy pending discovery fields exist | Define separate record/catalog/persistence and migration/retirement for pending legacy state in Phase 2. |

## 16. SCENE MAP

| Scene | Important nodes | Responsibility |
| --- | --- | --- |
| `res://scenes/main_menu.tscn` | `AtmosphereBackground`, `DioramaAnchor`, identity/time/mood controls | Enter a new voyage with presentation choices. |
| `res://scenes/game.tscn` | `VoyageWorld`, both camera rigs, `BoatSpace`, `TopPanel`, optional panels and `BottomPanel` | Calm voyage presentation and optional interaction surfaces. |
| `res://scenes/boat_space.tscn` | Boat, avatar, pet, rail, eight `BoatDecorSlots`, visual cards | Shared visible personal place. |
| `res://scenes/album.tscn` | `AtmosphereBackground`, summary, recent memory, Back | Reflect real local history. |

## 17. SCRIPT RESPONSIBILITY MAP

| Script | Responsibility | Relevant contract status |
| --- | --- | --- |
| `scripts/core/game_state.gd` | Session/memory/identity/decor state; legacy affection/pending discovery | Must be changed only in Phase 2 DEC-002/003 contract. |
| `scripts/voyage/game_scene.gd` | Process loop, camera, UI, fishing, decor/interactions, legacy discovery scheduler | Must retire superseded discovery and live relation UI only in that contract. |
| `scripts/ui/album_view.gd` | Album background/summary/recent memory | Future first consumer of quiet together-time. |
| `scripts/ui/main_menu.gd` | Mood, identity and time selection | No change required by DEC-002/003. |
| `scripts/audio/resting_soundscape.gd` | Authored wave loop and layer priority | Preserve wave-first role. |
| `scripts/core/*persistence*.gd` | Decor/identity ConfigFile persistence | Reuse patterns only after scope/data review. |

## 18. SIGNAL AND EVENT FLOW

Current input connections are direct `Button.pressed` / `OptionButton.item_selected` callbacks in scene scripts. No new signal is approved yet.

**Required Phase 2 event decisions before code:** define whether a pure in-process event/callback is necessary for `together_time_updated` and `ambient_memory_added`, exact payload fields, persistence timing, duplicate protection and test seams. Do not invent new event buses before that contract.

## 19. STATE MACHINES

### Voyage state

```text
MENU -> ACTIVE_VOYAGE -> RECORD_CREATED -> ACTIVE_REST_AFTER_RECORD
       |                      |                    |
       +-> Appreciation <----+--------------------+
       +-> Album -> return to same voyage scene
```

### Required ambient state, not implemented

```text
IDLE_SCHEDULED -> PRESENTING_AND_AUTOSAVED -> NOTIFICATION_FADING -> IDLE_SCHEDULED
                         \-> no player confirmation branch
```

## 20. SAVE / LOAD CONTRACT

- Existing local persistence is limited to `user://boat_decor_v1.cfg` and `user://identity_profile_v1.cfg`.
- Existing general memory arrays and voyage state are process-lifetime, not proven durable across restart.
- `DAT-004` and `DAT-005` cannot assume these existing files are appropriate. Phase 2 must choose storage, atomicity, migration from legacy affection/pending states, corrupted-file fallback and test isolation.
- No cloud, account, social or cross-device dependency is permitted for the rest core.

## 21. IMPLEMENTATION TRACEABILITY

| Decision | Affected existing owners | Required future evidence |
| --- | --- | --- |
| DEC-002/003 | `GameState`, `GameScene`, `AlbumView`, related contracts/captures | focused automated contracts + Game/Album 540 x 960 capture + human calm/pressure review |
| DEC-004/005 | `GameState`, `GameScene`, legacy discovery tests/captures | deterministic distribution/test hooks + parity/runtime capture + human calm/empty/noticeability review |
| DEC-006 | main menu/game/album visual consumers, time catalog | only after consumer-specific visual implementation contract |
| DEC-007 | planning boards, Visual Bible, provenance registry | generated exploration QA and final user lock record before runtime asset contract |

## 22. TEST AND QA CONTRACT

| ID | Verification | Current evidence | Gap |
| --- | --- | --- | --- |
| QA-001 | Headless Godot import and scene smokes | GitHub `Godot 4.7 validation` succeeds on PR #96 | Must rerun exact head for changed phase. |
| QA-002 | Focused behavioural contracts | Existing `tests/test_*.gd` suite | Old affection/discovery assertions are expected to change with Phase 2. |
| QA-003 | 540 x 960 runtime capture | Existing visual/menu/album capture folders | Future DEC-002/003 captures absent. |
| QA-004 | Real-device touch / mobile comfort | None | `NOT_RUN`. |
| QA-005 | Human 5-minute rest/pressure | None | `NOT_RUN`. |
| QA-006 | Human audio listening | None | `NOT_RUN`. |
| QA-007 | Human Windows package launch | Headless package smoke only | `NOT_RUN`. |

## 23. VERTICAL SLICE DEFINITION

**Next vertical slice:** `VS-002 Quiet Together-Time + Passive Ambient Memory`.

Player enters the existing 3/4 boat scene. Without doing anything, active foreground time quietly accumulates. Once in a while, a visual-only ambient moment occurs in either camera mode, auto-saves as a distinct local memory and fades without interaction. In the Album, the player can read together-time and one quiet relation sentence next to real memory history. The slice succeeds only if it feels like less work, not like a quieter checklist.

**Excluded:** visual asset batch, Bottle/social runtime, cosmetic expansion, economy/unlocks, new screen, reward/currency, exact public release work.

## 24. RISKS AND BLOCKERS

| Risk | Evidence | Disposition |
| --- | --- | --- |
| Design/code drift | DEC-002/003 conflict table | Implement both only in one bounded contract with migration/tests. |
| Calm becomes empty | Density target is an intention, not tested | Human five-minute `CALM/EMPTY/NOTICEABILITY` review. |
| Calm becomes chore | Live levels/popups/action reward are explicitly prohibited | Reject any metric/reward UI during review. |
| Visual drift | Lock is planning-only, current runtime remains earlier art | Consumer-specific lock checklist at target resolution. |
| Scope / social safety | PR #19 and Bottle needs special safety gate | Keep read-only and defer. |
| False release confidence | Only machine checks/captures exist | Keep Human/mobile/package claims `NOT_RUN`. |

## 25. USER DECISION REQUIRED

No decision is required to publish this GDD. Before `VS-002` implementation, one bounded Phase 2 review must decide only implementation-level details that product direction deliberately leaves open:

1. together-time storage/migration and duration-copy catalogue;
2. ambient scheduling algorithm/test hook and first motif catalogue;
3. the smallest auto-fade notification placement/copy at 540 x 960.

Those are not invitations to add new progression, visual asset families or a social system.

## 26. IMPLEMENTATION QUEUE

| Order | Item | Why now | Gate |
| --- | --- | --- | --- |
| 1 | Phase 2 preproduction review for VS-002 | Resolves known product/code conflicts with highest player-value protection. | One implementation contract, TDD, data/migration decision. |
| 2 | Implement and capture VS-002 | Makes the approved rest promise observable. | Automated contract + runtime capture, no Human PASS claim. |
| 3 | Human five-minute mobile/audio/touch review | Tests the actual player promise. | User test protocol and recorded observations. |
| 4 | Consumer-specific visual runtime alignment | Only after VS-002 avoids contract churn. | Generate-first/final-lock-only workflow and actual consumer proof. |
| 5 | Any delayed Bottle work | Highest moderation/operations dependency. | Separate safety release gate; PR #19 remains independent. |

## 27. BENCHMARK AND REFERENCE DISPOSITION

| Reference | Observation from source | Adopt / Adapt / Reject | Project translation / risk |
| --- | --- | --- | --- |
| NAIAD | A calm water journey uses fauna/flora and small secrets in a personal visual/sound language. | `ADAPT` | Use rare non-task ambient moments, but retain static resting as core rather than route-based exploration. |
| A Short Hike | Peaceful traversal supports side activities within a relaxed journey. | `ADAPT` | Fishing remains optional texture; do not import summit/goal pressure. |
| Spirit City: Lofi Sessions | Soundscape, space and companion can support calm, but it is a gamified focus tool. | `ADAPT / REJECT` | Keep wave-first space/companion value; reject productivity XP or task framing. |
| Animal Crossing: Pocket Camp Complete | Strong personalization and outdoor activity coexist with a large event/item loop. | `ADAPT / REJECT` | Retain expression through decor/identity; reject limited events, request chains and collection pressure. |
| Townscaper | A toy-like ocean-space builder foregrounds simple placement and beauty without a win condition. | `ADAPT` | Keep no-best-build decor semantics; do not broaden to freeform city building. |
| Unpacking | A domestic space can carry memory without timers, meters or scores. | `ADAPT` | Album and decor tell personal history; avoid puzzle correctness requirements. |
| Kind Words | Gentle letter exchange has clear UGC/safety exposure. | `ADAPT / DEFER` | Keep delayed human warmth only behind Bottle moderation gates; local core never depends on it. |
| DREDGE | Fishing and sea atmosphere can be compelling when tied to risk, upgrades and horror. | `REJECT` | Explicit contrast: no danger, inventory pressure, upgrades or darkness-as-threat. |

Research date: 2026-08-28. Sources: official Nintendo Animal Crossing Pocket Camp Complete page; Steam product pages for NAIAD, A Short Hike, Spirit City: Lofi Sessions, Townscaper, Unpacking, Kind Words and DREDGE. See the user PDF source list for stable URLs.

## 28. CHANGE LOG

| Date | Change |
| --- | --- |
| 2026-08-28 | Initial two-artifact Master GDD publication from `a419d2a...`; records DEC-002/003 implementation conflicts and DEC-007 generate-first/final-lock-only visual workflow. |
| 2026-08-28 | User retired Notion from active project use. Repository human-facing canon now owns current direction, approvals and asset provenance; Notion is `LEGACY_DISCOVERY_ONLY` with no new read/write/sync. |
| 2026-08-28 | One final user-authorized read-only migration transferred the useful current Notion structure, decisions and asset provenance to §29 of this GDD; historical/duplicate/WIP records were deliberately excluded. |
| 2026-08-28 | `NO_BASE_PROMOTION`: this repository-only authority migration is a user/project-specific operating choice and does not retire Notion as a Base-wide workflow option. |

## 29. FINAL NOTION ARCHIVE MIGRATION RECEIPT

> **Status:** `FINAL_MIGRATION_COMPLETE`<br>
> **Executed:** 2026-08-28<br>
> **Policy after this receipt:** Repository documents, assets, provenance and runtime evidence are the only current project owners. Previous Notion pages are retained without deletion as historical archives; no further Notion read, write or sync is normal project work.

This is the one-time user-authorized migration check completed when retiring Notion. It does not promote a past page to current truth. The repository destinations below own the useful transferred content; old page identities are retained only to prove what was checked.

### Scope and exclusions

- Included: current project navigation responsibilities, current rest-first/companion-time/Ambient/visual-lock decisions, approved runtime-asset records and current production/evidence boundaries.
- Excluded by user direction: superseded 2026-08-24 system implementations, old `main` SHA receipts, retired PR duplicates, `WIP` source duplicates for approved cushion/postcard outputs, preview-only attachments already represented by a repository board/binary/provenance record, and unapproved audio candidates.
- `EXCLUDED` never means a current approved asset or decision was discarded; it means a historical or duplicate record was not made an active repository owner.

### Previous structure → current repository ownership

| Previous page/database checked | Source identity | Responsibility transferred | Current repository owner | Result |
| --- | --- | --- | --- | --- |
| Home | `3c41b237-eb1c-8194-8b8e-d88362cafafa` | North Star, current decisions, five-minute flow and evidence ceiling | this GDD, `docs/CONCEPT.md`, `docs/RESTING_EXPERIENCE_BIBLE.md` | `MIGRATED` |
| 01 · Direction · Planning | `3c51b237-eb1c-81f2-a2e0-f4258b15aae3` | Direction/intent and planning responsibility | this GDD | `MIGRATED` |
| 02 · Voyage · Experience · Systems and Flow Map | `3c51b237-eb1c-8136-99e0-fd12478954a2`, `3c11b237-eb1c-81c3-8e12-d3f598113c7e` | Mood → rest → optional activity → memory, companion-time and passive Ambient rules | `docs/RESTING_EXPERIENCE_BIBLE.md` and four 2026-08-28 decision packets | `MIGRATED` |
| 03 · Visual · UX · Assets and Visual Bible | `3c51b237-eb1c-810d-ba71-f358c8a91b0c`, `3c11b237-eb1c-81ae-97f3-dc28a0905304` | Visual grammar, screens and consumer-first asset rule | visual locks, current screen inventory and this GDD | `MIGRATED` |
| Asset Library · Master | `3c11b237-eb1c-8120-b7db-d48e11756146`, `collection://4c49f406-67a2-4524-97b9-f8f1aa730f16` | Approved asset ID, paths, rights/provenance, hash and runtime use | local binaries plus repository evidence/provenance records | `MIGRATED` |
| 04 · Production · Validation / Handoff | `3c51b237-eb1c-8178-a475-e647a4bb5a30`, `3c11b237-eb1c-81b0-b281-ec54d67c9552` | Godot boundary, validation evidence and independent-work isolation | `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`, Work-5 receipt | `MIGRATED` |
| 05 · Reference · Benchmark | `3c51b237-eb1c-813b-bf72-ea727541132e`, `3c11b237-eb1c-8116-9c53-e3662be2e347` | Adapt/reject reasoning and validation questions | §27 | `MIGRATED` |
| Old Core System detail / AI evidence | `3c11b237-eb1c-8119-8378-c25d3ebbf658`, `3c61b237-eb1c-812f-a9f5-f5a116a98370` | Old implementation and PR receipts | Git history and `docs/evidence/`; later product decisions supersede stale behavior | `EXCLUDED_AS_HISTORICAL` |

### Approved asset transfer readback

Every local binary below was re-read and SHA-256 checked on 2026-08-28. The local path plus matching hash is the current asset identity; an earlier Notion record is not needed to consume, review or validate it.

| Asset ID | Repository binary | SHA-256 | Current role / repository provenance |
| --- | --- | --- | --- |
| `MLB_MAIN_MENU_DAWN_BACKGROUND_V1` | `assets/images/ui/main_menu/main_menu_dawn_storybook_v1.png` | `68B537C9815C95BF04DC0BA13ECBCA5909E2BD196C9A3AA7A89E27981B89C39E` | Dawn menu atmosphere · `docs/evidence/2026-08-28-main-menu-background-assets/asset-provenance.md` |
| `MLB_MAIN_MENU_BRIGHT_BACKGROUND_V1` | `assets/images/ui/main_menu/main_menu_bright_storybook_v1.png` | `7ED8CA5101C803344A78BB8A39D2E7545899BC8F7A8D59FF66BE346DA787D0D5` | Bright menu atmosphere · same |
| `MLB_MAIN_MENU_SUNSET_BACKGROUND_V1` | `assets/images/ui/main_menu/main_menu_sunset_storybook_v1.png` | `3E4901FDCEFB771AD5200C75A26B2B74E5FCED95AD01E345E00E677423D86A3A` | Sunset menu atmosphere · same |
| `MLB_MAIN_MENU_NIGHT_BACKGROUND_V1` | `assets/images/ui/main_menu/main_menu_night_storybook_v1.png` | `5669220C5E0F39CBB365748A2BC9883C67AA1D14C51B7C8068F51BC72E196C30` | Night menu atmosphere · same |
| `MLB_FINAL_2P5D_C_DOG_BOAT_RUNTIME_V1` | `assets/images/runtime/storybook/boat_c_dog_diorama_storybook.png` | `E6A197C68F08BCE6E1EABC37A5390598BA19174124C5B0E4EDA4C2000F5481FD` | C + dog diorama · `docs/evidence/2026-08-26-final-2p5d-storybook-art/asset-provenance.md` |
| `MLB_FINAL_2P5D_BRIGHT_SEA_RUNTIME_V1` | `assets/images/runtime/storybook/sea_bright_storybook.png` | `2B174E0F66C98672F5527411EA0CA43FDE9DBB93957696614158FCB895A3BDEC` | Bright sea backdrop · same |
| `MLB_IMG_PET_CUSHION_STRIPE_RUNTIME` | `assets/images/decor/pet_cushion/cushion_stripe.png` | `452CC8BF848BBD6836D5B250C36827F62A0EE9578BF3370A4604C1ADA5007DB5` | Cosmetic cushion · runtime image contract |
| `MLB_IMG_PET_CUSHION_MOON_RUNTIME` | `assets/images/decor/pet_cushion/cushion_moon.png` | `267D4C73BD48299F1DADC3BD1424FC4B6360B7E4F7CF055EEE0AFBB19217E2A1` | Cosmetic cushion · runtime image contract |
| `MLB_IMG_PET_CUSHION_FLORAL_RUNTIME` | `assets/images/decor/pet_cushion/cushion_floral.png` | `6920E5BFAC8BCC44B63B3DAE318888C305CDD7E622347F28C7791DD50A694C80` | Cosmetic cushion · runtime image contract |
| `MLB_IMG_POSTCARD_BOAT_BRIGHT_RUNTIME` | `assets/images/decor/postcard/postcard_boat_bright.png` | `87A80C439E12DD97D262C1C74FB7108905E27E5F42950F658F75DA9427AC291F` | Default postcard face · runtime image contract |
| `MLB_RUNTIME_IDENTITY_A_SOFT_HOODED_V1` | `assets/images/runtime/storybook/avatar_a_soft_hooded_storybook.png` | `30D67B1DD74A01109698727CADDC14B450461580E2D2457A7B108362FFF54F3A` | Optional avatar A · identity provenance |
| `MLB_RUNTIME_IDENTITY_B_SHORT_CAPE_V1` | `assets/images/runtime/storybook/avatar_b_short_cape_storybook.png` | `74FCF3D7FB9522558706F8FAD864A64A357A84A624D7E3BE013DA768032C6B54` | Optional avatar B · identity provenance |
| `MLB_RUNTIME_IDENTITY_CAT_V1` | `assets/images/runtime/storybook/pet_cat_storybook.png` | `92570863C8D76BE76886C21D5FA83E0615EBA964D26951DC674A0AC7FFBF452C` | Optional cat · identity provenance |
| `MLB_RUNTIME_IDENTITY_RABBIT_V1` | `assets/images/runtime/storybook/pet_rabbit_storybook.png` | `9837A7B4CE5AFB19E265522953A944F6BA6E8ED9B351DAD5EFB4FCDFBB07EA78` | Optional rabbit · identity provenance |
| `MLB_RUNTIME_IDENTITY_OTTER_V1` | `assets/images/runtime/storybook/pet_otter_storybook.png` | `84A3FE7A647634C23336F448D0DE52E28397AE37BEF62EB1B2846145B0D3B3E0` | Optional otter · identity provenance |

The old asset-library `*_SOURCE` records, P2 postcard candidates and audio references were `WIP` or reference-only. Their useful facts are represented by the approved output rows above; they were not copied as active work.

### Current decision transfer readback

| Decision | Repository owner | Result |
| --- | --- | --- |
| Doing nothing on the boat is complete play; fishing/photo/decor/interaction are optional | `docs/CONCEPT.md`, `docs/RESTING_EXPERIENCE_BIBLE.md`, §§02–04 | `PASS` |
| Companion relation is active foreground voyage time only; Album shows quiet together-time | the two companion 2026-08-28 decision packets | `PASS` |
| Ambient Discovery is low-density passive atmosphere with a small notification and immediate local save | the two Ambient 2026-08-28 decision packets | `PASS` |
| C knit/long-hair + dog and soft-manga chibi refinement | `docs/visual/2026-08-28-soft-manga-chibi-character-style-lock.md` | `PASS` |
| Four-time grammar; Night is `INDIGO_RAIN_REFLECTION`, not a fifth weather mode | `docs/visual/2026-08-28-indigo-rain-four-time-visual-lock.md` | `PASS` |
| Generated boards are planning direction proof, not runtime asset or Human validation | §§00–02 and visual-lock documents | `PASS` |
| Runtime, automated and Human evidence have distinct ceilings | §00 and `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md` | `PASS` |

### Closing rule

The old structure now resolves through this Master GDD, Concept, Experience Bible, visual locks, evidence/provenance folders and current handoffs. No deletion or rewriting was performed in Notion. A future Notion read requires a new explicit user request and a new repository migration receipt; it can never silently regain current-owner status.
