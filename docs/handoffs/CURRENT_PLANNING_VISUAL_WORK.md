# Current Planning & Visual Work

> Stable current-work pointer for the **pre-implementation planning and visual closeout** of `MY_LITTLE_BOAT`. This is a router/handoff, not a second game-design canon.

## Current task

```yaml
project: MY_LITTLE_BOAT
mode: GPT_PLANNING_VISUAL_CLOSEOUT
current_goal: COMPLETE_PRE_IMPLEMENTATION_PLANNING_AND_VISUALS
current_owner: GPT_NONCODING_PLANNING_VISUAL_OWNER
next_godot_owner: CODEX_AFTER_VISUAL_CLOSEOUT_ONLY
implementation_baseline: RESOLVE_CURRENT_COMPLETED_MAIN_AT_RESUME
concurrent_pr_19: READ_ONLY_NO_ABSORPTION
current_visual_step: IMAGE_B_BOAT_SEA_FOUR_TIME_ATMOSPHERE
status: PLANNING_VISUAL_CLOSEOUT_IN_PROGRESS
```

The user's priority remains explicit: **finish planning and image work first; do not start the Godot production slice yet.**

At every resume, re-read current `main`, Project Notion, approved Visual records, current open PRs, and latest user decisions. Historical implementation-ready packets remain paused until this closeout is complete.

## Direct discovery package

Human/product authority:

- Notion Human Home: `3c41b237-eb1c-8194-8b8e-d88362cafafa`
- Notion Visual Bible: `3c11b237-eb1c-81ae-97f3-dc28a0905304`
- Notion Asset Library: `3c11b237-eb1c-8120-b7db-d48e11756146`
- Notion Project Plan: `3c11b237-eb1c-810c-80dd-e57ab44c9b23`
- Notion Production Handoff: `3c11b237-eb1c-81b0-b281-ec54d67c9552`
- Notion AI Evidence: `3c61b237-eb1c-812f-a9f5-f5a116a98370`

Repository support:

- approved style spec: `docs/superpowers/specs/2026-08-25-handpainted-storybook-3d-diorama-design.md`
- Image A customization decision: `docs/visual/2026-08-26-image-a-customization-decision.md`
- **current Image B generation brief:** `docs/visual/2026-08-26-image-b-generation-brief.md`
- historical umbrella A/B/C brief: `docs/visual/2026-08-26-preimplementation-image-briefs.md` — its Image A one-winner questions are superseded by the approved customization decision; do not use them as current gates
- visual-closeout benchmark evidence: `docs/research/2026-08-26-planning-visual-closeout-benchmark.md`
- paused downstream Godot handoff: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`

## Why Godot implementation is still paused

The art direction and Image A customization set are approved, but the environment/final representative visual decisions are not closed:

```text
VISUAL_STYLE_DIRECTION = APPROVED
DETAILED_VISUAL_STYLE_CANON = HANDPAINTED_STORYBOOK_3D_DIORAMA
IMAGE_A_VISUAL_APPROVAL = PASS
CHARACTER_SELECTION_SET = APPROVED
PET_SELECTION_SET = APPROVED
PET_CUSHION_CUSTOMIZATION = APPROVED_AT_FEATURE_MEANING_LEVEL
BOAT_DECOR_REPRESENTATIVE_LANGUAGE = NOT_YET_CLOSED
FOUR_TIME_ATMOSPHERE_DIRECTION = NOT_YET_CLOSED
REPRESENTATIVE_UI_PRESENCE = NOT_YET_CLOSED
APPROVED_REPRESENTATIVE_VISUAL_GDD = NOT_YET_PRODUCED
FINAL_RUNTIME_ART = NOT_INTEGRATED
```

Starting Godot art translation now would still allow environment/UI placeholder choices to become accidental design authority.

## Product decisions already protected

Do not reopen without new user direction:

- rest-first healing voyage promise;
- visible player + resting pet + personal boat + sea in normal 3/4 diorama;
- Appreciation Camera as sea/horizon alternate view;
- `SOFT_STORYBOOK_3D_DIORAMA` parent philosophy;
- `HANDPAINTED_STORYBOOK_3D_DIORAMA` detailed visual canon;
- silhouette-first, restrained-face character language;
- quiet non-obligation pet role;
- matte / painted / broad-value boat and environment language;
- stable horizon and sea-first hierarchy;
- four atmosphere states: dawn / bright / sunset / night;
- no paid-asset dependency, no runtime generative AI, no social-workstream absorption.

## Approved Image A — customization canon

Image A is approved as a **customization-system visual proof**, not as a one-winner selection board.

### Character selection

All three base style families are selectable:

```text
A = SOFT_HOODED_LAYER
B = SHORT_CAPE_SAILOR_LAYER_RHYTHM
C = LOOSE_KNIT_LONG_HAIR_MASS
```

They are visual choices only. They do not create class/stat/rarity/monetization differences.

### Pet selection

The first selectable pet set is:

```text
CAT
RABBIT
DOG
OTTER_LIKE
```

All share the same no-obligation resting-companion semantics.

### Pet cushion customization

`PET_CUSHION_CUSTOMIZATION = APPROVED_AT_FEATURE_MEANING_LEVEL`.

The exact cushion catalog, UI location, persistence mechanics, and number of variants are not yet fixed. Those details must later reuse the existing Boat Decoration architecture where feasible rather than creating a parallel inventory system by default.

### Image A evidence

- user visual approval: `PASS`
- generation locator: `gen_id 608ba7ff-441b-4c58-b415-94c79a9d7ae6`
- original observed PNG: `1535×1024`
- original SHA-256: `5de0a90edad069003be0aa4f2935223ab86883701e51263ca8e3cc36760e7946`
- Notion Asset Library record: added 2026-08-26
- Notion-native preview: attached; original local binary itself is represented by provenance metadata because the current connector path cannot directly ingest it.

## Current planning decisions still to close

1. **Boat memory signature**
   - representative 3–5 existing decor motifs;
   - one warm living accent;
   - clutter ceiling that keeps the sea/horizon dominant.

2. **Four-time atmosphere set**
   - dawn / bright / sunset / night remain the same place through color, light, water, and living-light response;
   - choose one representative time state for the final Visual GDD after comparison.

3. **Representative UI presence**
   - lock only how much UI is visible and its hierarchy in the representative frame;
   - do not prematurely finalize typography, icon family, every panel, or customization flow timing.

4. **Representative Visual GDD**
   - one final approved image explains normal 3/4 play, customization-capable avatar/pet relationship, personal boat/decor, sea-first hierarchy, and quiet interaction/UI presence;
   - the depicted character/pet pair is an **example loadout**, not the only playable identity;
   - it bridges planning to implementation but does not prove runtime quality.

## Current visual sequence

### Image A — Player + Pet Customization Board

```text
STATUS = APPROVED
```

Closed decisions:
- three selectable character style families;
- four selectable pet species families;
- pet cushion customization as a feature axis.

Do not ask the user to reduce A/B/C or the pet set to one exclusive winner unless the user later changes direction.

### Image B — Boat / Sea / Four-Time Atmosphere Board

```text
STATUS = NEXT / TEXT_BRIEF_READY / IMAGE_NOT_RUN
```

**Use `docs/visual/2026-08-26-image-b-generation-brief.md` as the current generation authority.**

Use one exact boat/camera/decor composition across four equal variants:

```text
DAWN | BRIGHT | SUNSET | NIGHT
```

Keep character/pet detail omitted or as small neutral silhouettes so the environment comparison stays controlled.

Image B must answer:
- whether all four states unmistakably read as the same place;
- representative time-of-day preference for Image C;
- 3–5 item decor cluster and clutter ceiling;
- one warm living-light accent;
- sea/horizon versus boat/decor value hierarchy;
- whether any time state becomes too dramatic, high-contrast, or gamey for rest-first use.

Do not change map identity, boat layout, camera, or decor positions between time states merely to make each panel more attractive.

### Image C — Representative Visual GDD

```text
STATUS = BLOCKED_BY_IMAGE_B
```

Generate only after Image B decisions are recorded.

Image C must:
- use one **representative example** from the approved character/pet selection sets, not imply exclusivity;
- show personal boat/decor language selected from Image B;
- use the selected representative time state;
- keep sea/horizon dominant;
- show restrained representative UI/affordance presence;
- show Normal play and, only if useful, a small Appreciation-view inset;
- communicate that avatar/pet/cushion are customizable in supporting planning text without turning the key frame into a catalog screen.

It becomes `APPROVED_REPRESENTATIVE_VISUAL_GDD` only after explicit user visual approval and Notion Asset Library upload/readback.

## Visual generation policy

```text
IMAGE_A = APPROVED
IMAGE_B = NOT_RUN
IMAGE_C = NOT_RUN
```

Before each new generated result:

1. Use the current text brief and latest user decisions.
2. Verify it does not silently decide unrelated lore/gameplay/UI.
3. Treat one generated result as one evidence item; do not claim unseen alternates.
4. Record generation provenance and approval status in the Asset Library.
5. Preserve rejection reasons as design evidence.

## Benchmark disposition

Full locators and evidence remain in `docs/research/2026-08-26-planning-visual-closeout-benchmark.md`.

- **ADAPT — Spirit City: Lofi Sessions:** readable avatar identity + personal space + companion presence; reject productivity/XP pressure.
- **ADAPT — Dordogne:** authored painterly surface + camera-aware composition + restrained technical complexity; do not copy literal watercolor treatment.
- **REFERENCE_ONLY / ADAPT selectively — SEASON: A letter to the future:** simplification, silhouette/readability, believable time-of-day mood; do not infer that My Little Boat needs its custom shader stack.
- **REJECT — identifiable trade-dress copying.**

## Exit gate before Codex/Godot resumes

All must be true:

```text
CHARACTER_SELECTION_SET = APPROVED
PET_SELECTION_SET = APPROVED
PET_CUSHION_CUSTOMIZATION = APPROVED_AT_FEATURE_MEANING_LEVEL
BOAT_DECOR_REPRESENTATIVE_LANGUAGE = APPROVED
FOUR_TIME_ATMOSPHERE_DIRECTION = APPROVED
REPRESENTATIVE_UI_PRESENCE = APPROVED_AT_MEANING_LEVEL
APPROVED_REPRESENTATIVE_VISUAL_GDD = PRODUCED_AND_APPROVED
ASSET_LIBRARY_READBACK = PASS
VISUAL_BIBLE_CURRENT_DECISIONS = SYNCED
PROJECT_PLAN_CURRENT_NEXT_WORK = SYNCED
```

Then update `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md` from paused to implementation-ready and fresh-read repository default branch + Project Notion + actual Godot structure before any Scene/Resource/GDScript mutation.

## Evidence ceiling while active

```text
PLANNING_VISUAL_CLOSEOUT = IN_PROGRESS
IMAGE_A_VISUAL_APPROVAL = PASS
CHARACTER_SELECTION_SET = APPROVED
PET_SELECTION_SET = APPROVED
PET_CUSHION_CUSTOMIZATION = APPROVED_AT_FEATURE_MEANING_LEVEL
IMAGE_B_TEXT_BRIEF = READY
IMAGE_B = NOT_RUN
IMAGE_C = NOT_RUN
APPROVED_REPRESENTATIVE_VISUAL_GDD = NOT_YET_PRODUCED
HANDPAINTED_3D_RUNTIME_SLICE = NOT_RUN
MOBILE_30S_VISUAL_REVIEW = NOT_RUN
MOBILE_5M_VISUAL_REVIEW = NOT_RUN
HUMAN_RUNTIME_STYLE_APPROVAL = NOT_RUN
REAL_DEVICE_TOUCH_QA = NOT_RUN
```