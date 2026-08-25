# My Little Boat Handpainted Storybook 3D Diorama Design

Status: **USER-APPROVED DESIGN / SPEC REVIEW GATE**  
Date: 2026-08-25  
Project: `my little boat` / `MY_LITTLE_BOAT`  
Baseline project `main`: `a60f3a71ce7cb03f46aa3e20da5bbb96b83cfc95`  
Current-task branch: `plan/handpainted-storybook-style-20260825`  
Concurrent PR boundary: PR #19 `Implement deterministic local social fake backend` remains **READ_ONLY / NO ABSORPTION** for this task.

## 0. Decision summary

The approved visual direction is refined from the broad `SOFT_STORYBOOK_3D_DIORAMA` umbrella into a more specific production-facing style canon:

```text
HANDPAINTED_STORYBOOK_3D_DIORAMA
```

The selected direction is the **B+ hybrid** discussed with the user:

- preserve the current 3D boat diorama, camera, decoration, interaction, and Godot runtime structure;
- move the player, pet, boat, props, sea, sky, and UI surface language toward a hand-painted picture-book feel;
- use 3D geometry as the implementation foundation, but make the final frame feel closer to a moving illustrated storybook than glossy CG;
- reduce the generic AI-rendered character look through simplified shapes, deliberate silhouette design, restrained face detail, hand-painted color variation, and visible human-style surface irregularity;
- keep the calm sea/horizon and personal boat space more important than character beauty, UI density, or visual spectacle.

This decision **does not convert the game into a full 2D game** and does not invalidate the existing 3/4 diorama architecture.

## 1. Relationship to the previous canon

`SOFT_STORYBOOK_3D_DIORAMA` remains the broad parent direction that established:

- visible avatar + resting pet + personal boat + sea;
- calm 3/4 diorama composition;
- rounded, simplified forms;
- soft matte / lightly painterly materials;
- stable horizon;
- low-to-medium environmental contrast;
- readable mobile UI;
- slow bounded motion;
- no identifiable copying of benchmark games.

`HANDPAINTED_STORYBOOK_3D_DIORAMA` **supersedes the old direction only at the style-detail level**. It preserves the product structure and clarifies how the 3D scene should look and feel.

Use this interpretation:

```text
SOFT_STORYBOOK_3D_DIORAMA
= parent visual philosophy

HANDPAINTED_STORYBOOK_3D_DIORAMA
= current detailed visual-style canon
```

Do not treat the refinement as a gameplay redesign, camera redesign, or asset-complete state.

## 2. Why this refinement is needed

The first representative Visual GDD candidate proved that the product composition works, but the character treatment exposed a style problem:

- smooth generic SD proportions;
- overly clean CG surfaces;
- highly averaged facial construction;
- polished but non-specific hair and clothing forms;
- uniform softness with little authored irregularity;
- an overall impression that can read as generic generative-AI 3D rather than a deliberately art-directed game identity.

The style comparison exercise showed four useful directions:

1. matte toy-like 3D SD;
2. hand-drawn storybook 2D SD;
3. diorama pixel;
4. HD-2D cozy pixel.

The user preferred comparison **B — hand-drawn storybook 2D SD**. The selected long-term direction is not full 2D B, but **B+**: import B's hand-drawn visual language into the current 3D game architecture.

## 3. Comparison-image status

The generated comparison images are evaluation references, not production assets.

```text
STYLE_COMPARISON_B = USER_PREFERRED_REFERENCE
B_PLUS_HYBRID_DIRECTION = APPROVED
COMPARISON_IMAGE_B_PROJECT_ASSET_APPROVED = NO
COMPARISON_IMAGE_B_RUNTIME_INTEGRATED = NO
COMPARISON_IMAGE_B_FINAL_CHARACTER_CANON = NO
```

The B image is useful for:

- warmth;
- reduced CG gloss;
- illustrated-book surface language;
- quieter facial treatment;
- soft hand-painted sea and sky;
- relationship between character, pet, and boat.

It must **not** automatically canonize:

- the exact character's gender, age, hairstyle, clothing, or face;
- the depicted pet species;
- exact UI layout;
- exact boat construction;
- exact palette values;
- any generated textual labels;
- any layout artifact produced by the image model.

## 4. Top-level visual acceptance criterion

A normal gameplay frame should read in this order:

```text
my small place on the sea
→ player + pet resting together
→ soft horizon / water / light
→ lived-in boat details
→ optional interaction affordances
```

It should **not** read in this order:

```text
pretty AI character
→ busy UI
→ collectible objects
→ decorative sea background
```

The desired reaction is:

> "3D 게임인데 한 장의 움직이는 그림책처럼 보인다."

The style succeeds only if that picture-book authorship remains visible in the final runtime frame, not just in concept art.

## 5. Character visual language

### 5.1 Silhouette before face

Character recognition must come primarily from silhouette, posture, outerwear massing, and one or two deliberate shape anchors.

The player should not depend on a highly rendered face to be appealing.

Preferred principles:

- compact SD proportions appropriate for the mobile 3/4 camera;
- head large enough for emotional readability but not oversized into mascot/chibi caricature;
- torso, sleeves, lower body, and hair grouped into a few clear masses;
- one strong primary silhouette and one secondary accessory/detail anchor;
- readable from the normal 540×960 game viewport without zooming in.

Exact character identity, costume lore, gender expression, and final hairstyle remain separate character-design decisions. Visual tests must not silently promote a generated test character into story canon.

### 5.2 Face

Preferred:

- minimal eyes;
- small, restrained mouth;
- little or no explicit nose rendering at normal gameplay distance;
- expression carried by head tilt, pose, eyelid shape, and silhouette;
- small intentional asymmetry where appropriate;
- soft hand-painted value changes instead of glossy beauty shading.

Avoid:

- large glassy anime eyes;
- high-frequency iris highlights;
- smooth beauty-render skin;
- perfect bilateral symmetry;
- plastic doll cheeks;
- generic AI illustration face templates;
- excessive blush, lip detail, eyelashes, or cosmetic rendering at gameplay distance.

### 5.3 Hair

Hair should be built from 2–4 dominant painted masses rather than many generated-looking strands.

Preferred:

- chunky readable shapes;
- broad painted highlight planes;
- restrained edge breakup;
- simple silhouette rhythm;
- slight brush irregularity in texture and value.

Avoid:

- hundreds of fine hair strands;
- glossy salon hair;
- high-frequency anime sparkle;
- overly complex wisps that disappear on mobile.

### 5.4 Clothing

Clothing should support a cozy silhouette without becoming fashion-detail content.

Preferred:

- simple large garment shapes;
- visible but restrained cloth brush texture;
- clear folds only where they support pose and silhouette;
- muted color blocking;
- a small number of authored seams or knit cues.

Avoid:

- procedural micro-wrinkles;
- luxury-material gloss;
- dense accessories;
- costume detail that competes with the sea and pet.

## 6. Pet visual language

The pet is a supportive presence, not a collectible mascot or care obligation.

The final pet species is **not decided by the B comparison image**.

Preferred principles:

- compact, readable silhouette;
- large resting shapes rather than constant expressive animation;
- soft hand-painted fur or surface grouping;
- simple face readable at mobile distance;
- pose language centered on resting, watching the sea, sitting, lying down, napping, stretching, and occasional glance toward the player;
- color/value separation from the player and cushion without high contrast.

Avoid:

- oversized mascot head that dominates the boat;
- constant eye contact with the player;
- bouncing or attention-seeking idle cycles;
- hyper-detailed fur;
- care-state icons or visual pressure.

## 7. Boat and prop language

The boat remains a 3D personal space with current slot-zone decoration structure.

Preferred:

- chunky simple construction;
- rounded or worn-soft edges rather than razor-sharp hard-surface modeling;
- hand-painted wood value variation;
- broad brush-like texture breakup;
- low-frequency material detail;
- slightly imperfect hue/value distribution;
- readable silhouettes for lantern, mug, cushion, plant, postcard, and pet cushion;
- props spaced to create lived-in memory, not inventory density.

Avoid:

- photoreal wood grain;
- physically perfect repeating textures;
- excessive bevel/gloss showcase;
- clutter that hides the deck or sea;
- rarity-tier visual language.

## 8. Sea, sky, and horizon

The sea remains core content, not a backdrop.

Preferred:

- stable horizon;
- broad painted sky shapes;
- soft cloud masses;
- low-to-medium environmental contrast;
- simplified water bands and slow highlight patterns;
- hand-painted color transitions;
- low-frequency reflection accents;
- gentle time-of-day variation without dramatic weather pressure.

The sea should read as authored through deliberate color and shape rather than as a photoreal water simulation.

Avoid:

- dense physically based water detail;
- highly reflective chrome-like ocean;
- tiny glitter everywhere;
- dramatic storm lighting;
- cinematic bloom that reduces mobile legibility;
- constant high-contrast moving highlights.

## 9. Material and shader direction

The target is **3D geometry with hand-painted surface authorship**.

Preferred production direction:

- matte-biased materials;
- reduced specular response;
- restrained roughness variation;
- painted albedo carrying more visual identity than PBR micro-detail;
- broad value grouping;
- subtle hand-authored texture irregularity;
- optional lightweight lighting quantization or soft ramping only if it improves the illustrated read without creating a toon-shader look that conflicts with the calm tone.

Do not add expensive rendering techniques solely to simulate illustration.

The MVP must remain compatible with the current Godot 4.7 mobile-oriented renderer and the project's zero-extra-cost default.

## 10. Lighting direction

Lighting should support storybook readability rather than cinematic spectacle.

Preferred:

- one clear broad key-light direction;
- soft fill;
- warm/cool separation kept subtle;
- readable face/silhouette values without spotlighting the character as a hero unit;
- stable deck readability;
- sea/horizon retained as a major value mass;
- limited bloom and glow.

Avoid:

- dramatic rim-light portraits;
- strong character spotlight;
- neon edge lighting;
- high-contrast night scenes that turn the boat into a dark combat-like stage.

## 11. Color direction

The palette remains calm and sea-led.

Preferred hierarchy:

1. broad sea/sky family;
2. warm natural boat family;
3. low-saturation player/pet family;
4. small warm living accents;
5. functional UI contrast.

Color variation should feel painted rather than mathematically uniform.

Do not lock final RGB/HEX values in this design. Final palette values require an actual production color study viewed in the game camera and on a mobile display.

## 12. UI visual language

UI remains secondary to the world.

The B+ style may borrow the **feeling** of a quiet notebook/storybook interface, but must not convert the game into a paper-themed menu system without a separate UX decision.

Preferred:

- simple shapes;
- readable functional contrast;
- low visual noise;
- limited decorative linework;
- soft off-white / muted surfaces when a panel is necessary;
- restrained icons;
- clear active/inactive state.

Avoid:

- ornate scrapbooking around every control;
- parchment borders everywhere;
- tiny handwritten fonts;
- decorative textures that reduce accessibility;
- generated-text visual artifacts becoming UI canon.

Final navigation, button geometry, icon family, and typography remain separate UI-design decisions.

## 13. Animation and motion language

Hand-painted style must survive motion.

Preferred:

- slow, low-amplitude body motion;
- readable held poses;
- pet idle changes at low frequency;
- simple animation arcs;
- small secondary cloth/hair motion only when necessary;
- boat/camera bob kept subtle;
- water motion broad and slow.

Avoid:

- high-frequency squash-and-stretch mascot animation;
- constant breathing exaggeration;
- rapid head turns;
- procedural jiggle everywhere;
- animation noise that destroys the illustrated still-frame quality.

## 14. 3D implementation preservation

The style refinement must preserve current architectural advantages:

- normal 3/4 diorama camera;
- Appreciation Camera as alternate sea-focused view;
- current boat-space hierarchy;
- slot-zone decoration;
- low-pressure interaction surfaces;
- avatar + pet + boat shared space/bob relationship;
- mobile portrait presentation;
- local-first core gameplay.

A style task must not replace these with 2D scene swaps unless a future approved trade study proves the current 3D approach is no longer suitable.

## 15. First production validation slice

The cheapest useful proof is **one bounded visual slice**, not a full asset conversion.

The first slice should contain only:

- one neutral test player character using the new hand-painted 3D language;
- one temporary resting-pet test model or existing placeholder restaged with the style surface treatment, without canonizing species;
- the existing boat space with one material pass;
- sea/sky color treatment;
- one small decor cluster;
- current normal diorama camera;
- current Appreciation Camera.

It should answer:

1. Does the player stop reading as generic AI 3D?
2. Does the frame feel hand-authored at actual mobile gameplay size?
3. Does the sea remain more important than the character face?
4. Does the style remain readable in motion?
5. Can the look be produced within a solo-developer budget and current renderer?

Do not convert every asset before this slice is reviewed.

## 16. Production validation matrix

The style is not complete until the following evidence exists.

| Evidence | Requirement |
|---|---|
| Static comparison | B+ production test compared against current placeholder frame |
| Mobile 30-second viewing | character/pet/sea hierarchy remains readable without visual fatigue |
| Mobile 5-minute viewing | style remains calm rather than visually flat or noisy |
| Motion check | illustrated feel survives idle, boat bob, and Appreciation transition |
| Silhouette check | avatar and pet remain distinguishable at normal gameplay distance |
| Material check | no return to glossy generic CG surfaces |
| Performance check | visual treatment remains practical in Godot 4.7 mobile renderer |
| Human review | user explicitly approves or requests correction |

Until those are observed, use `NOT_RUN` or `NOT_INTEGRATED` rather than `PASS`.

## 17. Anti-AI-look review checklist

Before promoting any player/pet/boat art candidate, attack it with these questions:

- Does the face look like a generic AI illustration template?
- Are the eyes more detailed than the gameplay distance needs?
- Is the hair composed of readable authored masses or random fine strands?
- Are all surfaces unnaturally smooth and evenly polished?
- Is asymmetry intentional and controlled rather than accidental generation noise?
- Do textures show authored brush/value decisions?
- Does the character silhouette remain identifiable when the face is hidden?
- Does the scene still work if the character occupies less attention?
- Does the pet feel like a quiet companion rather than a mascot?
- Does the frame feel like one art-directed world rather than individually generated objects?

Any candidate that fails several of these questions returns to `REVIEW_REQUIRED`.

## 18. Pixel-art alternatives

The pixel studies remain valuable alternatives but are **not the selected current canon**.

```text
DIORAMA_PIXEL = ALTERNATIVE / NOT_SELECTED
HD2D_COZY_PIXEL = ALTERNATIVE / NOT_SELECTED
```

They should be revisited only if:

- the hand-painted 3D slice cannot escape the generic CG look;
- mobile performance or solo production cost becomes unacceptable;
- the user explicitly reopens the pixel-art direction.

Do not mix pixel characters into the selected B+ runtime style without a new design decision.

## 19. What remains intentionally undecided

This style decision does **not** decide:

- final player character identity;
- player gender/age/lore;
- exact hairstyle or clothing design;
- pet species;
- final boat model;
- final UI layout;
- final typeface;
- final palette values;
- final texture resolution;
- exact shader implementation;
- final production asset source/pipeline.

These are not missing requirements for the style canon. They are intentionally separate decisions to avoid using a generated comparison image as accidental product canon.

## 20. Human-facing Notion projection

After this written spec is approved and implementation planning begins, the people-readable surfaces should be updated in this order:

1. Visual Bible — mark `HANDPAINTED_STORYBOOK_3D_DIORAMA` as the detailed current visual canon and explain its relationship to the previous umbrella direction.
2. Project Home — replace the style label while preserving the existing Living GDD hierarchy and visual evidence ceiling.
3. Visual/UX/Assets detail — record the B comparison as a user-preferred reference, not an approved production asset.
4. Asset Library — only add/promote an image if its lifecycle status is explicit and the source/rights/provenance fields are appropriate.
5. AI Workspace — retain exact branch/PR/evidence/NOT_RUN information.

The Human Home must not expose raw commit SHA, PR, workflow run, prompt, hash, or asset-generation metadata.

## 21. Repository projection

Repository structured canon should mirror the final approved style in planning Markdown only until a real production slice is implemented.

Expected repository consumers:

- `docs/CONCEPT.md`
- `docs/RESTING_EXPERIENCE_BIBLE.md` if its visual section requires the refined terminology
- this spec and its later implementation plan

Do not modify gameplay scripts/scenes/resources merely to make documentation appear synchronized.

## 22. Image-generation boundary

The comparison images already generated remain conversation/reference artifacts.

Future image work follows the project image conversation gate:

```text
current canon review
→ text brief
→ separate explicit user approval
→ generate exactly one image
→ stop for user review
```

Image generation success is not user approval, project-asset approval, or runtime integration.

## 23. Safety / scope / cost constraints

This style work must not introduce:

- paid assets without explicit approval;
- paid APIs or runtime generative AI;
- dependency-heavy rendering plugins;
- a new external dashboard or asset-management source of truth;
- combat, failure, progression pressure, economy, or social-pressure mechanics;
- changes to PR #19.

Prefer the smallest production experiment that can prove or reject the visual hypothesis.

## 24. Acceptance criteria

The design is ready for implementation planning when all are true:

- [ ] `HANDPAINTED_STORYBOOK_3D_DIORAMA` is understood as a refinement of the existing 3D diorama, not a full 2D conversion.
- [ ] B comparison image is clearly reference-only and does not silently decide player identity, pet species, or final UI.
- [ ] character anti-AI-look rules are explicit enough to review future candidates consistently.
- [ ] pet, boat, sea, material, lighting, UI, and motion language are specified.
- [ ] current 3D camera/interaction/decor architecture is protected.
- [ ] first production validation slice is bounded and solo-developer practical.
- [ ] Human/Asset/runtime evidence ceilings are separated.
- [ ] pixel alternatives remain available without mixing into current canon.
- [ ] zero-extra-cost default remains protected.
- [ ] PR #19 remains read-only and independent.

## 25. Evidence state at this spec gate

```text
USER_SELECTED_B_REFERENCE = YES
B_PLUS_HANDPAINTED_3D_DIRECTION = APPROVED
WRITTEN_SPEC = IMPLEMENTED_ON_CURRENT_TASK_BRANCH
NOTION_VISUAL_BIBLE_UPDATE = NOT_RUN
NOTION_HOME_STYLE_UPDATE = NOT_RUN
ASSET_LIBRARY_PROMOTION = NOT_RUN
PRODUCTION_CHARACTER_SLICE = NOT_RUN
PRODUCTION_PET_SLICE = NOT_RUN
PRODUCTION_BOAT_SEA_STYLE_SLICE = NOT_RUN
MOBILE_VISUAL_REVIEW = NOT_RUN
HUMAN_STYLE_VALIDATION = NOT_RUN
RUNTIME_INTEGRATION = NOT_RUN
PR_CREATED = NO
MERGE = NOT_RUN
```

The next architectural gate after this spec is **user review of the written spec**. Only after that approval should `writing-plans` be invoked.