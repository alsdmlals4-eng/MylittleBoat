# Direct Boat Entry and Human GDD Design

**Issue:** [#99 Reconcile direct boat entry and human-readable GDD](https://github.com/alsdmlals4-eng/MylittleBoat/issues/99)
**Date:** 2026-08-28
**Status:** `USER_APPROVED_DESIGN`
**Scope:** repository planning canon and a future implementation contract only. This design changes no Godot scene, script, asset, test, package, or runtime result.

## 1. Why this change exists

The current product entry asks the player to choose a mood, light, identity, and pet before they can see the boat. That makes a rest-first game feel like a setup form. It also turns a player's quiet wish to simply open the game and look at the sea into a decision task.

The current master document has the opposite problem in writing: it records many implementation owners, evidence labels, and data details before explaining what a player actually does. A person cannot quickly understand the game or judge whether each system supports its calm feeling.

This design makes the player experience the front door and makes the GDD readable before its implementation evidence.

## 2. Confirmed product decisions

| ID | Decision | Status |
| --- | --- | --- |
| DBE-001 | App launch goes directly to a visibly floating boat diorama. Seeing the avatar, companion, boat, sea, and horizon is enough to begin. | `CONFIRMED` |
| DBE-002 | `오늘의 마음` is removed from the product. It is not replaced by another startup question. | `CONFIRMED` |
| DBE-003 | There is no player, pet, decor, light, or atmosphere chooser before the first boat view. | `CONFIRMED` |
| DBE-004 | Player appearance, companion species, and boat decor remain optional cosmetic expression accessed from `꾸미기` after arrival. They never change rewards or optimal play. | `CONFIRMED` |
| DBE-005 | A new local save begins in `bright`. Later direct entries use the locally stored atmosphere value without a startup selector. This scope does not authorize a new place to change that value. | `CONFIRMED` |
| DBE-006 | The supplied current main-entry composition is rejected as a main-entry presentation. Its boat has insufficient waterline contact, wave response, and reflection, so it reads as placed over the sea rather than floating in it. | `CONFIRMED` |
| DBE-007 | A source binary is not discarded merely because this one composition is rejected. Only the use of that composition as the main entry is prohibited until a future verified diorama solves the float-contact problem. | `CONFIRMED` |
| DBE-008 | The canonical GDD must be human-first. Technical source maps, Scene and data ownership, tests, captures, hashes, and migration receipts remain in their existing engineering records, not in the main explanation of the game. | `CONFIRMED` |

## 3. Considered entry approaches

### A. Immediate boat entry — adopted

`launch -> floating boat diorama -> rest or optional activity`

The game shows its promise before asking for anything. A player can stop at the first view and still have played correctly. Optional customization is available only when the player wants to make the place more personal.

### B. Current choice-led main menu — rejected

`launch -> choose mood/light/identity -> boat diorama`

This describes the existing implementation, not the approved product. It delays the sea, implies that a correct emotional choice is required, and lets a form-like panel dominate the first impression.

### C. Auto-filled choice-led menu — rejected

`launch -> show prefilled mood/light/identity panel -> press start -> boat diorama`

Default values remove only part of the friction. The player still begins in a menu, still sees mood as a system, and still needs to pass through an unnecessary confirmation step.

## 4. Player experience contract

```text
Open the game
  -> immediately see a small boat floating on the sea with a companion
  -> stay and look, or choose one quiet optional activity
  -> receive a gentle response or personal memory, never a grade
  -> keep resting, customize the shared place, or leave naturally
```

**Player promise.** My Little Boat is a small personal place where simply watching the sea with a companion is complete play.

**First thirty seconds.** The player sees buoyancy, a waterline, a shared boat silhouette, calm motion, and a sea-first horizon. No selection panel blocks the composition. The intended first memory is: “I opened it and was already there.”

**Meaningful choice.** The player chooses attention rather than efficiency: remain quiet, take a photo, fish, look through the Appreciation Camera, or make the boat feel more like their own. No choice is a loss and no action is required to earn companionship.

**No-pressure result.** An ignored activity, missed ambient moment, or zero catch does not produce a penalty, failed state, streak loss, or lesser ending.

## 5. System cards for the human GDD

Every core system in the rewritten GDD uses this five-part explanation: **what the player sees and does, why it exists, what feedback it gives, what pressure it deliberately avoids, and its actual implementation status.** Data structures and test names do not appear in the card body.

| System | What the player experiences | Why it belongs | No-pressure rule | Current status |
| --- | --- | --- | --- | --- |
| Floating rest | The avatar and companion share a boat that visibly meets and moves with the water. The player may simply watch. | This is the core game, not an idle waiting room. | Staying still is valid play. | `PLANNED_PRODUCT_DIRECTION`; current menu composition is rejected. |
| Appreciation Camera | The view favors the sea and horizon while hiding most nonessential UI. | It makes quiet looking an intentional mode without changing the game state. | It changes no timer, reward, or companion value. | `IMPLEMENTED_EARLIER_SLICE`; human comfort is not yet verified. |
| Customization | From `꾸미기`, the player can change appearance, companion species, and boat decor. | It makes the boat personal after the sea is already visible. | Cosmetic only. No stats, rare power, chores, or best configuration. | `IMPLEMENTED_EARLIER_SLICE`; entry point must move out of the startup flow. |
| Quiet activities | A player may take a photo, fish, or use a small interaction. | They add texture for a player who wants something to do. | They are invitations, not daily tasks or farming routes. | `PARTIAL_IMPLEMENTED`; exact product alignment remains separate. |
| Together time | Time spent actively resting with the selected companion slowly becomes a quiet album memory. | It makes shared presence meaningful without asking the player to optimize it. | No live level, bar, multiplier, species bonus, or action reward. | `CONFIRMED_NOT_IMPLEMENTED`. |
| Ambient discovery | Rare background moments appear naturally and save as a small personal memory. | They give the sea a sense of life without interrupting rest. | No first-event guarantee, task, reward claim, or social message. | `CONFIRMED_NOT_IMPLEMENTED`. |
| Album | The player revisits true personal traces of voyages, photos, catches, and future quiet-time memories. | It turns time spent in the game into a private record. | It is an archive, not a completion checklist. | `PARTIAL_IMPLEMENTED`. |

## 6. Visual disposition and guardrails

### Main-entry composition disposition

`VIS-ENTRY-001` is the user-supplied current menu composition described on 2026-08-28: a vertical scene with a boat image above a large translucent startup panel containing identity, light, and mood controls.

| Field | Disposition |
| --- | --- |
| Status | `REJECTED_FOR_MAIN_ENTRY_RUNTIME_USE` |
| Rejection reason | The boat does not convincingly float: waterline contact, local waves, wake, and reflection do not bind boat and sea into one physical space. The selector panel also displaces the rest-first first impression. |
| Narrow effect | Do not use this full composition as the startup screen or as reference for a replacement entry scene. |
| Not implied | Do not delete the individual boat, sea, or approved atmosphere binaries without a consumer audit. This is not a statement that every source asset is unusable. |
| Future acceptance | A future direct-entry diorama must show a readable boat-water contact line, coherent bob/wave response, reflection or occlusion consistent with the selected atmosphere, and a sea-first composition at 540 x 960. |

The approved visual language remains `HANDPAINTED_STORYBOOK_3D_DIORAMA` with `SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT`, C loose-knit/long-hair plus dog as the current identity anchor, and `INDIGO_RAIN_REFLECTION` for night. This design does not approve a new production image batch.

## 7. Documentation architecture

### Canonical human document

Create `docs/design/PROJECT_GDD.md` as the human-readable Project GDD. Its body is limited to these sections:

1. What this game is and its player promise.
2. The first thirty seconds and direct-entry flow.
3. Core loop, session rhythm, and what “complete play” means.
4. System cards from Section 5.
5. Screen and customization flow in player language.
6. Visual direction, the rejected main-entry composition, and float-contact requirements.
7. Current product status, verified evidence ceiling, and next implementation contract.
8. Explicit exclusions and unresolved questions.

### Supporting records, not a second player-facing GDD

| Owner | Keeps | Does not own |
| --- | --- | --- |
| `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md` | Exact current code, scene, asset, test, runtime-evidence boundaries and the next contract router. | The primary explanation of why the game is enjoyable. |
| `docs/evidence/` | Captures, logs, hashes, package and test receipts. | Product approval or human comfort proof. |
| `docs/visual/` | Visual locks, provenance, consumers, and asset coverage. | Inventing a screen or treating generated exploration as a runtime asset. |
| `docs/superpowers/specs/` and `docs/superpowers/plans/` | Historical design/implementation contracts. | Overriding the current human GDD. |

`docs/design/PROJECT_AI_PRODUCTION_SPEC.md` becomes a short supersession pointer to `PROJECT_GDD.md` and the supporting records above. Its current long body is no longer a live human-facing GDD, preventing two competing project explanations.

## 8. Required canonical corrections

The approved documentation pass will modify the following files, with no code or binary mutation:

| File | Required correction |
| --- | --- |
| `AGENTS.md` | Make repository canon primary after the completed migration, remove Notion as a current owner, replace mood-led core loop with direct boat entry, and retain the Phase 2 boundary. |
| `README.md` | Describe immediate boat entry and optional customization in the visible project summary. |
| `docs/CONCEPT.md` | Replace mood selection and pre-entry framing with the direct-entry player promise. |
| `docs/RESTING_EXPERIENCE_BIBLE.md` | Align the first-session flow and system language while preserving the approved together-time and ambient-discovery decisions. |
| `docs/design/PROJECT_GDD.md` | Become the concise current human GDD defined in Section 7. |
| `docs/design/PROJECT_AI_PRODUCTION_SPEC.md` | Become a supersession pointer; do not retain a second long technical GDD. |
| `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md` | Mark `main_menu.tscn`, `main_menu.gd`, mood-dependent `GameState` code, their current capture family, and related tests as `PRODUCT_SUPERSEDED_IMPLEMENTATION` for the future direct-entry contract. |
| `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md` | Retire the old main-entry and startup-selection surface as current product truth; record `VIS-ENTRY-001` and preserve individual asset provenance until a later consumer audit. |

## 9. Current implementation gap

The repository currently implements the older product route. This is not a code defect to fix in the documentation pass; it is an explicit gap for a separately approved Phase 2 implementation contract.

| Current runtime owner | Current behavior | Required future direction |
| --- | --- | --- |
| `scenes/main_menu.tscn` | Shows `DioramaAnchor` above a large panel with identity, time, and four mood buttons. | Replace startup scene/route with immediate boat diorama. Do not reuse the rejected full composition. |
| `scripts/ui/main_menu.gd` | Owns mood, identity, and time selection before entering gameplay. | Retire startup choice behavior; move cosmetic choices behind an in-voyage `꾸미기` entry. |
| `scripts/core/game_state.gd` | Stores `selected_mood`, accepts `select_mood`, and starts a voyage with `begin_voyage(mood)`. | Remove mood as product data and use direct voyage start. Preserve only approved local cosmetic/atmosphere state through a separately designed migration. |
| `scripts/voyage/game_scene.gd` | Applies mood-dependent presentation and record wording. | Remove mood dependence only under the dedicated implementation contract. |
| Main-menu, mood, and start-route tests/captures | Prove the older screen contract. | Retire or replace with direct-entry, customization-entry, and 540 x 960 float-contact evidence. |

No Phase 2 implementation begins from this document. In particular, it must not change `scenes/main_menu.tscn`, `scripts/ui/main_menu.gd`, `scripts/core/game_state.gd`, `scripts/voyage/game_scene.gd`, assets, tests, packages, or PR #19.

## 10. Future implementation contract acceptance criteria

When the user approves implementation separately, the contract must require all of the following:

1. A new save launches straight into the normal boat diorama in `bright` with no mood or setup UI.
2. A saved atmosphere value is restored on later direct entries without a startup choice.
3. Player, companion, and boat decor controls are reachable from a clearly optional in-voyage `꾸미기` surface.
4. Mood has no visible control, stored product meaning, voyage text, color rule, or test dependency after migration.
5. The boat, water, avatar, companion, and horizon are legible together at 540 x 960. The boat visibly floats rather than appearing composited above the water.
6. Existing local-first, no-combat, no-chore, no-social-pressure rules remain intact.
7. New automated route and persistence tests, targeted Godot scene smoke, runtime capture, and later human calm/comfort validation are recorded separately. A generated image alone is never proof.

## 11. Risks and deliberate non-decisions

| Item | Decision now | Deferred boundary |
| --- | --- | --- |
| Exact in-voyage atmosphere control | No new control is approved. | A future decision may choose whether atmosphere changes automatically, from a small ambient control, or not at all. |
| Direct-entry scene implementation | Not started. | Requires an implementation plan, asset-consumer audit, tests, and runtime capture. |
| Existing individual boat/sea assets | Preserve their provenance and current evidence. | A visual/consumer audit decides reuse, replacement, or retirement; the rejected full composition alone does not decide it. |
| Together time and ambient discovery | Keep their previously confirmed product directions. | Their data, UI, tests, and migration remain a separate Phase 2 contract. |
| Human usability and player calm | Not claimed. | Requires a real person to evaluate first 30 seconds and five minutes on the target device. |

## 12. Spec self-review

- No unfinished marker or invented runtime completion claim remains.
- The direct-entry decision does not authorize a new time-of-day interface, asset batch, social system, or implementation change.
- The source composition is rejected narrowly as an entry presentation, not confused with every underlying binary.
- The future contract names exact current code owners without treating them as changed in this documentation-only work.
- The human GDD has one canonical owner and supporting technical evidence has separate owners.
