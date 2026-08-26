# Current Planning & Visual Work

> Stable current-work pointer for pre-implementation visual closeout. This is a router, not a second game-design canon.

## Current task

```yaml
project: MY_LITTLE_BOAT
mode: GPT_PLANNING_VISUAL_CLOSEOUT
current_visual_step: IMAGE_C_REPRESENTATIVE_VISUAL_GDD
status: IMAGE_C_READY
next_godot_owner: CODEX_AFTER_VISUAL_CLOSEOUT_ONLY
concurrent_pr_19: READ_ONLY_NO_ABSORPTION
```

The user priority remains: finish planning and images before Godot product implementation.

## Authority
- Notion Human Home: `3c41b237-eb1c-8194-8b8e-d88362cafafa`
- Notion Visual Bible: `3c11b237-eb1c-81ae-97f3-dc28a0905304`
- Notion Asset Library: `3c11b237-eb1c-8120-b7db-d48e11756146`
- Notion Visual Production Checklist: `3c81b237-eb1c-810c-b3f8-fce023a453cb`
- Image A decision: `docs/visual/2026-08-26-image-a-customization-decision.md`
- Image B approval: `docs/visual/2026-08-26-image-b-approval-decision.md`
- current Image C brief: `docs/visual/2026-08-26-image-c-representative-visual-gdd-brief.md`
- paused downstream Godot handoff: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`

## Approved visual decisions

```text
VISUAL_STYLE_DIRECTION = APPROVED
DETAILED_VISUAL_STYLE_CANON = HANDPAINTED_STORYBOOK_3D_DIORAMA
IMAGE_A = APPROVED
CHARACTER_SELECTION_SET = SOFT_HOODED_LAYER | SHORT_CAPE_SAILOR_LAYER_RHYTHM | LOOSE_KNIT_LONG_HAIR_MASS
PET_SELECTION_SET = CAT | RABBIT | DOG | OTTER_LIKE
PET_CUSHION_CUSTOMIZATION = APPROVED_AT_FEATURE_MEANING_LEVEL
IMAGE_B = APPROVED
FOUR_TIME_ATMOSPHERE_SET = DAWN | BRIGHT | SUNSET | NIGHT
REPRESENTATIVE_VISUAL_GDD_TIME = BRIGHT
BOAT_DECOR_DENSITY = LOW / APPROX_3_TO_5_VISIBLE_MOTIFS
LANTERN = WARM_LIVING_LIGHT_ANCHOR
SEA_HORIZON = PRIMARY_VISUAL_MASS
IMAGE_C = NOT_RUN
```

All avatar/pet choices are cosmetic/personal-attachment choices only. No stat, rarity, gacha, monetization, or progression advantage.

## Image B evidence
- user approval: PASS
- generation locator: `4b4acca6-8f90-4a9f-b2fe-ca517270c1ae`
- original PNG: `1672×941`
- SHA-256: `2bf7cb88e7ce89ff481e78f3ccc9e2ca3c6ef376651b06b04a1441ac5fae10fa`
- Notion Asset Library approval record/native preview: PASS
- `BRIGHT` is the representative explanatory frame; Dawn/Bright/Sunset/Night all remain approved atmosphere states.

## Current Image C contract
Use `docs/visual/2026-08-26-image-c-representative-visual-gdd-brief.md`.

Recommended example loadout for the explanatory frame:

```text
SOFT_HOODED_LAYER + CAT + customizable pet cushion
```

This is an example loadout, not exclusive canon.

Image C must show:
- normal 3/4 personal boat diorama in gentle Bright daylight;
- wide calm sea and stable horizon as dominant content;
- player + pet resting together;
- low-density 3–5 motif lived-in decor cluster;
- restrained representative UI presence;
- optional small Appreciation Camera inset of the same place;
- enough supporting visual language to show avatar/pet/cushion customization without turning the frame into a catalog.

## Remaining closeout gate

```text
IMAGE_C = PRODUCED_AND_USER_APPROVED
APPROVED_REPRESENTATIVE_VISUAL_GDD = APPROVED
ASSET_LIBRARY_READBACK = PASS
VISUAL_BIBLE_CURRENT_DECISIONS = SYNCED
PROJECT_PLAN_CURRENT_NEXT_WORK = SYNCED
```

Only after those gates close should `CURRENT_GODOT_IMPLEMENTATION.md` be unpaused and the actual Godot project be fresh-read for implementation.

## Evidence ceiling

```text
HANDPAINTED_3D_RUNTIME_SLICE = NOT_RUN
PRODUCT_TDD_RED_GREEN = NOT_RUN
MOBILE_30S_VISUAL_REVIEW = NOT_RUN
MOBILE_5M_VISUAL_REVIEW = NOT_RUN
HUMAN_RUNTIME_STYLE_APPROVAL = NOT_RUN
REAL_DEVICE_TOUCH_QA = NOT_RUN
```

PR #19 remains an independent open/read-only workstream.