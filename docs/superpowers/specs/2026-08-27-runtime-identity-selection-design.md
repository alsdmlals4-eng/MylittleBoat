# Runtime Identity Selection Design

**Date:** 2026-08-27
**Status:** User-approved design direction; implementation plan pending written-spec review
**Decision:** Keep C + dog as the default, then add a local-first, cosmetic-only identity selector whose choices visibly change the normal boat diorama.

## 1. Intent

`My Little Boat` needs the player's visible avatar and resting companion to feel personally chosen without turning identity into a reward system, a shop, or a maintenance obligation. The result must remain close to the approved hand-painted storybook references: a quiet 3/4 boat, warm worn wood, soft matte values, a stable sea/horizon, and a companion who rests rather than performs.

The current C + dog production composition is the approved default. It is not replaced, reinterpreted, or downgraded. A user who never opens the selector continues to see that exact default.

## 2. Scope and non-goals

### In scope

- A main-menu entry point for choosing a player appearance and companion species.
- Three approved player families: `a_soft_hooded`, `b_short_cape`, `c_loose_knit`.
- Four approved companion species: `cat`, `rabbit`, `otter`, `dog`.
- Cosmetic-only local persistence of the two selected IDs, isolated from boat decor persistence.
- Runtime scene selection that visibly applies the choice in normal play.
- Seven source subject assets (three player cards and four pet cards) in the established storybook style, created only because each has a concrete runtime consumer.
- Local asset storage, Notion Asset Library registration, SHA-256/provenance, and a durable binary locator for every newly approved runtime asset.
- Contract tests for defaults, validation, persistence, UI selection, and normal-play visual routing.

### Out of scope

- Stats, affection changes, rewards, unlocks, purchase flows, random draws, or progression gates.
- Changing voyage duration, camera semantics, resting soundscape rules, decor rules, album semantics, or bottle/social scope.
- A character editor, arbitrary colors, clothing slots, naming, lore, gender/age canon, animation overhaul, or a separate avatar system.
- A four-time atmosphere system, main-menu artwork replacement, UI icon pack, or UV/model texture pipeline.
- Changes to PR #19. It remains read-only/no-absorption.

## 3. Approaches considered

| Approach | Result | Decision |
| --- | --- | --- |
| Selection UI without scene rendering | Stores a label but does not change the boat view | Reject. It would be a misleading cosmetic feature. |
| Twelve fully composited boat images | Every avatar/pet pair receives a bespoke whole-scene render | Reject for now. It duplicates the same boat/sea asset and makes later decor/camera work brittle. |
| Separate subject cards plus existing boat/sea composition | Three avatar cards and four pet cards are independently selected in the shared diorama | Adopt. It creates visible, testable choices while keeping the asset count and runtime structure proportional. |

## 4. Player-facing flow

1. The main menu presents the existing mood actions and one quiet `내 모습과 동반자` entry.
2. Selecting it opens a single lightweight sheet. It shows the three player labels and four companion labels, with the current selection clearly marked.
3. Selecting a player or companion applies immediately to the sheet preview and writes only cosmetic identity state locally. There is no confirmation cost, warning, or reward.
4. Returning to the main menu leaves mood selection unchanged.
5. Starting a voyage uses the selected visual pair. The normal 3/4 view visibly changes the player/pet subject while retaining the boat, decor, sea, and the existing C + dog default experience.
6. Appreciation Camera keeps its present horizon-first behavior and does not mutate the selected identity or persistent soundscape.

The default pair is always `c_loose_knit` + `dog`.

## 5. Runtime architecture

### Ownership

| Unit | Responsibility | Does not own |
| --- | --- | --- |
| `CosmeticIdentityProfile` | Validate, load, and save only player-style/pet-type IDs in `user://identity_profile_v1.cfg` | Boat decor, memories, rewards, session state |
| `GameState` | Expose the currently selected IDs and delegate persistence to the profile | Asset rendering and selector UI layout |
| Main-menu identity sheet/controller | Let the player choose valid IDs and communicate them to `GameState` | Voyage starts, reward changes, art generation |
| `BoatSpace` identity visual router | Show precisely one player card and one pet card for the selected IDs | Save files, camera rules, interaction semantics |
| Subject asset catalog | Map stable IDs to runtime texture paths and readable Korean labels | Dynamic external asset discovery |

### Stable data contract

```text
player_style_id: a_soft_hooded | b_short_cape | c_loose_knit
pet_type_id:     cat | rabbit | otter | dog
defaults:        c_loose_knit + dog
```

Invalid, missing, corrupt, or unknown values normalize to the approved defaults. The profile never stores arbitrary labels, asset paths, mood, decor, memories, or gameplay values.

`BoatDecorPersistence` remains limited to `user://boat_decor_v1.cfg`. Identity uses its own ConfigFile so a future reset or repair of one cosmetic domain cannot silently erase the other.

### Rendering route

- Existing C + dog final diorama art remains the default visual route.
- For a non-default selection, the composite C + dog card is hidden and the normal scene uses the shared boat/sea presentation plus exactly one matching player subject card and one matching resting-pet subject card.
- The card assets use transparent backgrounds, stable anchors, and the same camera-facing presentation as the current storybook cards. They must not include a full boat, border, external canvas, drop shadow, baked directional lighting, or a second horizon.
- The existing low-pressure pet interaction node, shared bob parent, decor slots, and camera nodes are not renamed or reparented. Only their visual child selection changes.

## 6. Asset contract

The first implementation set contains these actual runtime source assets:

| ID | Local runtime path | Subject direction |
| --- | --- | --- |
| `a_soft_hooded` | `assets/images/runtime/storybook/avatar_a_soft_hooded_storybook.png` | small warm hooded traveler, soft cream/teal layers, seated/resting 3/4 silhouette |
| `b_short_cape` | `assets/images/runtime/storybook/avatar_b_short_cape_storybook.png` | short sailor cape, muted navy/cream layers, seated/resting 3/4 silhouette |
| `c_loose_knit` | existing approved C runtime art, normalized to the same router contract | long brown hair, cream knit, muted blue skirt, seated/resting 3/4 silhouette |
| `cat` | `assets/images/runtime/storybook/pet_cat_storybook.png` | curled quiet cat, low resting silhouette |
| `rabbit` | `assets/images/runtime/storybook/pet_rabbit_storybook.png` | tucked rabbit, low resting silhouette |
| `otter` | `assets/images/runtime/storybook/pet_otter_storybook.png` | rounded resting otter, low resting silhouette |
| `dog` | existing approved dog runtime art, normalized to the same router contract | warm beige dog with brown floppy ears, low resting silhouette |

Every new file is 1024×1024, transparent RGBA sRGB, with no presentation canvas. The router can use the already approved C/dog cards directly; it does not duplicate them. Any new asset is inspected at native size and normal gameplay size, then recorded in Notion and locally with SHA-256, provenance, and a durable binary locator before it is treated as implementation-ready.

## 7. Failure handling and safety

- A missing or unreadable selected texture falls back to the current approved C + dog default, not an empty or technical-placeholder scene.
- A corrupt profile also falls back to default without creating a warning modal or blocking a voyage.
- Failed persistence keeps the selection visible for the current process but does not affect voyage, memories, decor, or companion affection.
- Selector actions do not call album, decor, fishing, discovery, bottle, or affection APIs.

## 8. Acceptance criteria

1. A fresh install and an invalid identity profile resolve to `c_loose_knit` + `dog`.
2. The main menu can select all three player IDs and four pet IDs with clear current-state feedback.
3. A chosen valid pair survives a scene restart and an application restart using only `user://identity_profile_v1.cfg`.
4. The normal game scene presents exactly one selected player and one selected companion. Selecting anything other than C + dog does not leave the C + dog composite visibly overlaid.
5. Existing C + dog default art, boat decor, postcard, pet cushion appearances, camera toggle, low-pressure pet interaction, and soundscape behavior remain valid.
6. No choice alters rewards, affection, voyage time, timer speed, photo/album data, or any social state.
7. Automated contracts pass and Godot opens headless without new errors. Mobile real-device comfort remains an explicitly deferred manual check.
8. New source assets are saved locally and individually registered in Notion with provenance/SHA/durable locator before final runtime approval is claimed.

## 9. Verification plan

- Unit/contract test for profile defaults, allowed-ID normalization, separate persistence file, and corrupted-file fallback.
- Scene/UI contract test for all seven selectable IDs and the main-menu route.
- Boat-space route test: default composite path; non-default player/pet routes; exactly-one subject visibility; no scene-node or interaction contract regression.
- Existing full Godot contract suite.
- Headless editor/project smoke and normal/appreciation scene smoke.
- Captures at the existing 540×960 profile. Human visual and later mobile-device validation remain separate evidence, not automatic claims.

## 10. Documentation and completion evidence

- Update `CURRENT_GODOT_IMPLEMENTATION.md`, `GODOT_MVP_ROADMAP.md`, and relevant asset-library records only after implementation evidence exists.
- Preserve the current C + dog Notion records; add one individual Notion record per newly created source asset.
- Completion report lists selected asset paths, SHA-256 values, Notion records, durable locators, tests, runtime captures, and any visual limitation that still needs human review.
