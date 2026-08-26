# Image A Customization Decision

Status: `USER_APPROVED_CUSTOMIZATION_CANON`
Date: 2026-08-26
Project: `MY_LITTLE_BOAT`

## Decision summary

The approved Image A is no longer a board for choosing one exclusive player identity and one exclusive pet species. It is an approved visual proof for three player-facing customization axes:

```text
CHARACTER_SELECTION
+ PET_SELECTION
+ PET_CUSHION_CUSTOMIZATION
```

This decision supersedes earlier planning gates that required one `PLAYER_REPRESENTATIVE_IDENTITY` and one `FIRST_PET_SPECIES` before visual closeout.

## Character selection set

All three Image A base silhouette families are available player choices:

1. `SOFT_HOODED_LAYER`
2. `SHORT_CAPE_SAILOR_LAYER_RHYTHM`
3. `LOOSE_KNIT_LONG_HAIR_MASS`

They share the same `HANDPAINTED_STORYBOOK_3D_DIORAMA` art direction and are customization options, not separate gameplay classes.

Do not infer from this approval:

- combat/job/class semantics;
- stat differences;
- rarity or monetization tiers;
- fixed name, age, gender, lore, or personality;
- a complete modular hair/clothing editor.

Exact selection UX and any deeper part-level customization remain separate planning/implementation decisions.

## Pet selection set

The first approved selectable pet species set is:

```text
CAT
RABBIT
DOG
OTTER_LIKE
```

All must preserve the same role:

- quiet resting companion;
- no care obligation;
- no hunger/cleaning/fatigue pressure;
- no gameplay-stat advantage;
- no rarity/gacha hierarchy;
- low-frequency resting behavior and sea-watching relationship.

Species is a preference/customization choice, not a progression reward gate.

## Pet cushion customization

`PET_CUSHION_CUSTOMIZATION = APPROVED_AT_FEATURE_MEANING_LEVEL`.

The pet cushion is a personal-space customization surface associated with the selected companion. It may vary in visual treatment, but this decision does not yet fix:

- exact number of cushion variants;
- colors/patterns/material catalog;
- whether selection occurs at onboarding, boat-decor mode, or a pet-specific panel;
- save/persistence implementation;
- exact UI controls.

Those details should be solved reuse-first with the existing Boat Decoration system when implementation planning resumes.

## Approved Image A evidence

- visual approval: `PASS`
- generation locator: `gen_id 608ba7ff-441b-4c58-b415-94c79a9d7ae6`
- approved original PNG observed: `1535×1024`
- original PNG SHA-256: `5de0a90edad069003be0aa4f2935223ab86883701e51263ca8e3cc36760e7946`
- Notion Asset Library: approved record added on 2026-08-26
- Notion-native preview: `320×213` SVG preview; original PNG metadata remains the provenance authority because the current connector cannot directly upload the local binary original.

## Consequence for final Representative Visual GDD

Image C does **not** canonize one exclusive character or pet. It should show one representative example loadout while making it visually clear in accompanying planning text that the game supports the approved selection sets.

The final Visual GDD must not imply that the depicted example is the only playable identity.

## Current next visual work

Proceed to `Image B — Boat / Sea / Four-Time Atmosphere Board`.

Image B should stay focused on the same boat composition across:

```text
DAWN | BRIGHT | SUNSET | NIGHT
```

It must answer environment/decor questions without reopening Image A customization:

- same-place continuity across four time states;
- sea/horizon hierarchy;
- representative 3–5 item lived-in decor cluster;
- one warm living accent;
- decor-density ceiling;
- representative time state for Image C.

Character/pet detail in Image B should be omitted or kept as small neutral silhouettes so the environment comparison remains controlled.

## Evidence ceiling

```text
IMAGE_A_VISUAL_APPROVAL = PASS
CHARACTER_SELECTION_SET = APPROVED
PET_SELECTION_SET = APPROVED
PET_CUSHION_CUSTOMIZATION = APPROVED_AT_FEATURE_MEANING_LEVEL
IMAGE_B = NOT_RUN
IMAGE_C = NOT_RUN
APPROVED_REPRESENTATIVE_VISUAL_GDD = NOT_YET_PRODUCED
HANDPAINTED_3D_RUNTIME_SLICE = NOT_RUN
```