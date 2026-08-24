# Local Boat Decoration + Low-pressure Interactable Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Add an 8-zone local-first boat decoration shell and a reusable low-pressure interaction contract without turning rest into inventory work, farming, or a freeform 3D editor.

**Architecture:** Keep the existing `GameState` as the process-lifetime memory owner, but store only `slot_id -> item_id` decoration choices there. Add a small catalog for compatibility, one technical `BoatDecorSlot` renderer, and one reusable `LowPressureInteractable` value object consumed by pet, rail, and decor props. Refactor visible boat-space objects under a single `BoatSpace` parent so boat bob automatically carries avatar, pet, rail, and all decorations instead of adding more manual synchronization paths. Reuse the existing `BottomPanel` with compact technical panels; direct 3D drag/tap placement is deliberately deferred until Human mobile evidence justifies the extra input complexity.

**Tech Stack:** Godot 4.7 stable, GDScript, existing SceneTree contract tests, GitHub Actions `Godot 4.7 validation`.

**Spec:** `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md`

## Global Constraints

- Normal play remains visible-avatar + pet + boat + sea in a calm 3/4 diorama; Appreciation Camera stays optional and sea-focused.
- Decoration uses exactly the approved initial eight zone identities: `bow_left`, `bow_right`, `center_left`, `center_right`, `rear_left`, `rear_right`, `rail_accent`, `pet_corner`.
- Decor is cosmetic/memory only: no stats, rarity score, mandatory fill bonus, gacha pressure, daily shop FOMO, or affection farming.
- Replace and clear are always lossless; invalid placement must not mutate stored state.
- Core rest/voyage/decor/pet systems stay local-first. This slice does not add FriendBottle, DriftBottle, Supabase, auth, moderation, or networking.
- Current persistence ceiling remains process lifetime only; app-restart save-file persistence is not added.
- New visuals are explicit technical placeholders created from Godot primitive meshes; no generated/final art is claimed.
- Interaction contract stays `get_actions(actor_context)`, `can_interact(actor_context, action_id)`, `perform(actor_context, action_id)` and never creates mandatory care, rapid-tap progress, reward farming, or forced Appreciation Camera exit.
- Mobile portrait remains primary. The technical UI uses existing controls and avoids a freeform 3D drag editor in this slice.
- Human mobile comfort, discoverability, final visual quality, and emotional rest quality remain `NOT_RUN` unless directly observed.

---

### Task 1: Decoration memory owner and catalog contract

**Files:**
- Create: `scripts/decor/boat_decor_catalog.gd`
- Modify: `scripts/core/game_state.gd`
- Create: `tests/test_boat_decoration_contract.gd`

**Interfaces:**
- Produces `BoatDecorCatalog.get_slot_ids() -> Array[String]`.
- Produces `BoatDecorCatalog.get_slot_label(slot_id: String) -> String`.
- Produces `BoatDecorCatalog.get_item_ids() -> Array[String]`.
- Produces `BoatDecorCatalog.get_item_definition(item_id: String) -> Dictionary`.
- Produces `BoatDecorCatalog.get_compatible_item_ids(slot_id: String) -> Array[String]`.
- Produces `BoatDecorCatalog.is_compatible(slot_id: String, item_id: String) -> bool`.
- Produces `GameState.set_boat_decor(slot_id: String, item_id: String) -> void` and `GameState.get_boat_decor(slot_id: String) -> String`.
- Stored data is `GameState.boat_decor: Dictionary`; `reset_session()` and `begin_voyage()` do not clear it.

- [ ] **Step 1: Write the failing decoration contract**

Create `tests/test_boat_decoration_contract.gd` so it loads the catalog only after checking `ResourceLoader.exists`, then asserts:

```gdscript
var expected_slots: Array[String] = [
    "bow_left", "bow_right", "center_left", "center_right",
    "rear_left", "rear_right", "rail_accent", "pet_corner",
]
```

The test must require the exact eight slots, require starter items `lantern`, `mug`, `cushion`, `plant`, `postcard`, `pet_cushion`, require broad compatibility such as `lantern` in `bow_left` and `rear_right`, require `postcard` only in `rail_accent`, and require invalid slot/item pairs to return `false`.

Then require `GameState.set_boat_decor("bow_left", "lantern")` to survive both `reset_session()` and `begin_voyage("평온")`, require `set_boat_decor("bow_left", "")` to clear the slot, and snapshot `companion_affection/photos/sceneries/letters/fish/voyage_records` to prove decoration does not change rewards or memories.

- [ ] **Step 2: Run the new test and verify semantic RED**

Run through the PR workflow once the test is registered. Expected failure is missing catalog/state API. A parse error in the test is not accepted as RED and must be corrected before implementation.

- [ ] **Step 3: Implement minimal catalog and state owner**

`boat_decor_catalog.gd` is a `RefCounted` static-data owner with exactly six starter technical items:

```gdscript
const ITEM_DEFINITIONS := {
    "lantern": {"label": "랜턴", "category": "light", "shape": "lantern", "actions": [{"id": "toggle_light", "label": "불빛 바꾸기", "message": "랜턴 불빛을 조용히 바꿨습니다.", "toggle_key": "light_on"}]},
    "mug": {"label": "컵", "category": "small", "shape": "mug", "actions": [{"id": "hold", "label": "컵 들어보기", "message": "따뜻한 컵을 잠시 들어봅니다.", "toggle_key": "held"}]},
    "cushion": {"label": "쿠션", "category": "seat", "shape": "cushion", "actions": [{"id": "sit", "label": "기대어 쉬기", "message": "쿠션에 기대어 잠시 쉽니다."}]},
    "plant": {"label": "작은 화분", "category": "small", "shape": "plant", "actions": [{"id": "look", "label": "바라보기", "message": "작은 잎이 바람에 흔들리는 모습을 봅니다."}]},
    "postcard": {"label": "엽서", "category": "rail", "shape": "postcard", "actions": [{"id": "look", "label": "엽서 보기", "message": "난간의 엽서를 천천히 바라봅니다."}]},
    "pet_cushion": {"label": "펫 쿠션", "category": "pet", "shape": "pet_cushion", "actions": [{"id": "rest", "label": "함께 쉬기", "message": "동반자가 익숙한 쿠션에서 편히 쉽니다."}]},
}
```

Use broad allowed categories so normal deck slots accept several benign options, while `rail_accent` accepts `rail` and `pet_corner` accepts `pet`/`seat`. No price, rarity, score, currency, stat, or unlock field exists.

`GameState.set_boat_decor()` stores or erases a slot key and has no affection/reward side effect.

- [ ] **Step 4: Re-run decoration contract**

Expected: `PASS: boat decoration contract` while all pre-existing contracts remain unchanged.

- [ ] **Step 5: Commit the logical task**

Commit message: `Add local boat decoration state contract`.

---

### Task 2: Reusable low-pressure interaction contract

**Files:**
- Create: `scripts/interaction/low_pressure_interactable.gd`
- Modify: `scripts/voyage/resting_pet_placeholder.gd`
- Create: `scripts/voyage/boat_rail_interactable.gd`
- Create: `tests/test_low_pressure_interaction_contract.gd`

**Interfaces:**
- `LowPressureInteractable.configure(target_id: String, display_name: String, actions: Array[Dictionary]) -> void`.
- `get_actions(actor_context: Dictionary = {}) -> Array[Dictionary]`.
- `can_interact(actor_context: Dictionary, action_id: String) -> bool`.
- `perform(actor_context: Dictionary, action_id: String) -> Dictionary` returning at least `ok`, `target_id`, `action_id`, `message`, `state`.
- Actions with `toggle_key` toggle only component-local interaction state.
- Pet and rail delegate the same three public contract methods.

- [ ] **Step 1: Write the failing interaction contract**

The test must check the reusable script exists, configure a target with a toggle action, verify an unknown action is rejected, verify valid `perform()` returns `ok=true`, verify the toggle state changes deterministically, and snapshot all GameState reward/memory fields to prove interaction itself does not award affection or progression.

Instantiate `resting_pet_placeholder.gd` and require actions `pet` and `look_at_sea`. Instantiate `boat_rail_interactable.gd` and require actions `lean` and `look_at_sea`. Performing pet/rail actions must not change `GameState.appreciation_mode`.

- [ ] **Step 2: Register the test in `.github/workflows/godot-validation.yml` and verify semantic RED**

Expected failure: missing interaction script/delegates. Existing tests should remain green.

- [ ] **Step 3: Implement the reusable value-object contract and delegates**

`low_pressure_interactable.gd` extends `RefCounted`; it owns only target identity, action descriptors, and small local toggle state. It does not reference GameState.

Pet delegates to a configured component and may translate `pet` to its existing `glance` resting posture and `look_at_sea` to `watch_sea`, without affection gain. Rail delegates to a component and only returns calm messages; no avatar stat or timer change is introduced.

- [ ] **Step 4: Re-run interaction + existing contracts**

Expected: interaction PASS, resting-pet timing/care contract still PASS.

- [ ] **Step 5: Commit the logical task**

Commit message: `Add reusable low-pressure interactions`.

---

### Task 3: BoatSpace parent and eight technical decor slots

**Files:**
- Create: `scripts/decor/boat_decor_slot.gd`
- Modify: `scenes/game.tscn`
- Modify: `scripts/voyage/game_scene.gd`
- Modify: `tests/test_diorama_avatar_camera_contract.gd`
- Modify: `tests/test_resting_core_contract.gd` if its node paths require migration
- Create: `tests/test_boat_life_scene_contract.gd`

**Interfaces:**
- `BoatDecorSlot.slot_id: String` exported in Scene.
- `apply_item(item_id: String) -> bool` validates catalog compatibility and builds/clears one primitive technical visual.
- `get_item_id() -> String`.
- `is_technical_placeholder() -> bool` returns `true`.
- Decor slot delegates `get_actions/can_interact/perform` for its current item when the catalog defines actions.
- `GameScene.apply_boat_decor(slot_id: String, item_id: String) -> bool` is the single mutation route used by UI/tests.
- `GameScene.clear_boat_decor(slot_id: String) -> void`.

- [ ] **Step 1: Write the failing scene contract**

Require the following hierarchy:

```text
VoyageWorld/BoatSpace
├─ BoatBow
├─ PlayerAvatarPlaceholder
├─ RestingPetPlaceholder
├─ BoatRail
└─ BoatDecorSlots
   ├─ BowLeft
   ├─ BowRight
   ├─ CenterLeft
   ├─ CenterRight
   ├─ RearLeft
   ├─ RearRight
   ├─ RailAccent
   └─ PetCorner
```

Pre-seed `GameState.boat_decor` with `bow_left=lantern` and `rear_right=mug`, instantiate the Scene, and require those slot nodes to report the stored items. Require an invalid placement such as `pet_corner=postcard` to return `false` without state mutation. Require a valid replacement and clear to update state immediately.

Measure Avatar/Pet/decor local Y relative to `BoatSpace`, call drift processing, and assert those local positions remain unchanged while `BoatSpace.position.y` changes. This replaces the prior manual multi-node bob contract with one shared parent owner.

- [ ] **Step 2: Verify semantic RED**

Expected failure: missing `BoatSpace`, slot nodes, slot renderer, and `apply_boat_decor` API. Existing Diorama/Appreciation contracts should fail only for intentional migrated paths, not unrelated behavior.

- [ ] **Step 3: Implement `BoatSpace` migration and slot renderer**

Move BoatBow, Avatar, Pet under `VoyageWorld/BoatSpace`, add a simple rail mesh with `boat_rail_interactable.gd`, and add the eight positioned slot nodes with `boat_decor_slot.gd`. `game_scene.gd` stores only `_boat_space_base_position`; `_apply_drift_motion()` bobs `BoatSpace` once rather than manually synchronizing every deck child.

`BoatDecorSlot` creates one primitive MeshInstance3D based on catalog `shape`, uses a soft technical material, and clearly reports `TECHNICAL_PLACEHOLDER`. For `lantern`, create a very low-energy child `OmniLight3D` and bind its visibility to the interaction toggle. For `mug`, a held toggle may apply only a tiny vertical visual offset. These effects are technical observability, not final animation/art.

- [ ] **Step 4: Update intentional node-path consumers and run the suite**

Update only tests/scripts/docs that actually depend on the moved Avatar/Pet/Boat paths. Expected: new BoatLife scene contract PASS, Diorama/Appreciation/Resting Core contracts PASS, no unrelated path churn.

- [ ] **Step 5: Commit the logical task**

Commit message: `Add eight boat decor slot zones`.

---

### Task 4: Compact decoration and interaction UI integration

**Files:**
- Modify: `scenes/game.tscn`
- Modify: `scripts/voyage/game_scene.gd`
- Extend: `tests/test_boat_life_scene_contract.gd`
- Modify: `tests/test_game_scene_contract.gd` only where new controls affect explicit expectations

**Interfaces:**
- New bottom controls: `%DecorButton`, `%InteractButton`.
- New hidden panels: `$DecorPanel`, `$InteractionPanel`.
- Decor panel uses `%DecorSlotOption`, `%DecorItemOption`, `%DecorApplyButton`, `%DecorClearButton`, `%DecorCloseButton`.
- Interaction panel uses `%InteractionTargetOption`, `%InteractionActionOption`, `%InteractionPerformButton`, `%InteractionCloseButton`.
- `get_interaction_target_ids() -> Array[String]` returns `pet`, `rail`, plus currently placed interactive decor targets as `decor:<slot_id>`.
- `perform_interaction(target_id: String, action_id: String) -> Dictionary` routes to the shared contract and never changes timer/rewards/Appreciation state.

- [ ] **Step 1: Extend the failing scene contract**

Require Decor/Interact buttons and both panels. Verify panels start hidden. Open Decor panel, choose/apply a compatible item through the same mutation API, and verify the state/slot changed without changing remaining time, speed, affection, photos, scenery, letters, fish, or voyage records.

Place lantern and mug, refresh interaction targets, and require `pet`, `rail`, `decor:bow_left`, and the mug slot to appear. Perform one decor action and one pet action; require `GameState.appreciation_mode` and rewards to remain unchanged.

Set Appreciation mode on and apply `_apply_appreciation_mode()`. Require new buttons hidden and both panels closed. Exiting Appreciation restores buttons but does not auto-open panels.

- [ ] **Step 2: Verify RED**

Expected failure: missing controls/panels/target-routing API.

- [ ] **Step 3: Implement the compact technical UI**

Reuse `BottomPanel/ButtonGrid`; add only `꾸미기` and `상호작용` buttons. Each opens one small PanelContainer, closes the other, and uses OptionButtons rather than eight always-visible slot buttons. Decor item options are rebuilt from `BoatDecorCatalog.get_compatible_item_ids(selected_slot)` so invalid choices are not presented. Replacing or clearing requires no confirmation because it has no loss/cost.

Interaction targets are rebuilt from pet, rail, and placed decor slots with non-empty actions. Performing an action displays its calm message in the existing StatusLabel. No new reward banner, success jingle, streak, or notification loop is added.

- [ ] **Step 4: Run full behavior suite and three Scene smokes**

Expected: all contracts PASS and `main_menu.tscn`, `game.tscn`, `album.tscn` smoke PASS.

- [ ] **Step 5: Commit the logical task**

Commit message: `Integrate calm boat life controls`.

---

### Task 5: Evidence boundary, docs, final review, PR, merge, Notion readback

**Files:**
- Modify: `README.md`
- Modify: `docs/CONCEPT.md`
- Modify: `docs/MVP_SCOPE.md`
- Modify: `docs/GODOT_MVP_ROADMAP.md`
- Modify: `docs/RESTING_EXPERIENCE_BIBLE.md` only if an active protection statement needs the implemented status
- Modify: `.github/workflows/godot-validation.yml` only for the new focused test commands

**Interfaces / evidence labels:**
- `TECH_BOAT_DECORATION=PASS` only after exact-head CI proves state/catalog/scene integration.
- `LOW_PRESSURE_INTERACTABLE=PASS` only after exact-head interaction contract.
- `BOAT_LIFE_TECH_UI=PASS` only after scene contract/smoke.
- `DECOR_HUMAN_USABILITY=NOT_RUN`.
- `REAL_MOBILE_DECOR_QA=NOT_RUN`.
- `FINAL_DECOR_ART=NOT_INTEGRATED`.
- `APP_RESTART_DECOR_PERSISTENCE=NOT_IMPLEMENTED`.
- Social systems remain `NOT_IMPLEMENTED`.

- [ ] **Step 1: Update repository mirrors only after GREEN runtime evidence**

Document the eight slot-zone shell, primitive technical visuals, process-lifetime persistence, common interaction contract, and the deliberate decision to defer freeform placement/direct 3D manipulation until Human mobile evidence. Do not describe technical placeholder props as final art.

- [ ] **Step 2: Whole-state adversarial review until clean**

Run at least five whole-state loops after the last correction. Each loop must re-attack: rest-first pressure, decoration becoming optimization, compatibility frustration, panel clutter, Appreciation regression, Avatar/Pet/decor bob ownership, process-vs-app persistence wording, reward farming, mobile-touch future compatibility, stale docs, scope creep into social/backend, and whether a smaller solution would be better. Any valid finding resets the clean-loop count to 1 after correction and regression verification.

- [ ] **Step 3: Exact-head verification**

Require the current PR exact HEAD to have one successful `Godot 4.7 validation` run with all focused contracts and three Scene smokes. Inspect job steps/logs rather than relying only on the run badge. Preserve any pre-existing non-blocking warning as a warning rather than claiming warning-free evidence.

- [ ] **Step 4: Review surface and merge gate**

Confirm current-task PR only, latest main unchanged or reconcile if it moved, comments/reviews/unresolved threads, exact HEAD, and mergeability. Merge by squash with `expected_head_sha`; never force, direct-push main, or bypass rules.

- [ ] **Step 5: Postmerge readback and Notion sync**

Read back new `main` SHA and Issue closure. Update Project Registry, Human Home, `Boat Decoration`, `Low-pressure Interaction`, 5-minute core-loop evidence boundary, and Production Handoff. Only Decoration/Interaction records become `SYNCED`; FriendBottle/DriftBottle/Safety remain `REPO_UPDATE_REQUIRED`. Fetch every updated Notion destination to verify durable saved state.

- [ ] **Step 6: Completion recalculation**

For this approved slice, required work is zero only after repository + Notion readback and final clean review. Project-wide remaining work is expected to include Social Fake Backend/Supabase/Safety/Delayed Bottle, Human mobile/comfort validation, final art/audio, and app-restart persistence; do not collapse those into this Slice's completion.
