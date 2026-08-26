# Planning + Visual Closeout Benchmark Evidence

Observed: 2026-08-26

Purpose: support the decision to finish representative player/pet/boat/environment visual planning before starting the Godot hand-painted runtime slice. These are principle references only; they do not replace My Little Boat's Notion canon or user approval.

## 1. Spirit City: Lofi Sessions — ADAPT

Source:
- Steam: https://store.steampowered.com/app/2113850/Spirit_City_Lofi_Sessions/

Observed product pattern:
- the product explicitly combines avatar customization, a customizable personal room, ambient soundscapes, and companion creatures;
- the personal avatar + personal space + companion triangle is a clear attachment surface;
- as of the observation date the Steam page shows strong user reception and continued 2026 updates.

Use for My Little Boat:

```text
ADAPT
= readable player identity
+ personal-space expression
+ companion presence
```

Do not import:
- productivity XP/reward pressure;
- task/habit optimization loop;
- creature collection as mandatory progression;
- room-scale UI/productivity framing.

My Little Boat must preserve `rest-first / doing nothing is valid` rather than turning attachment into a reward treadmill.

## 2. Dordogne — ADAPT

Sources:
- AUTOMATON interview with art director Cédric Babouche: https://automaton-media.com/en/interviews/20230621-19630/
- GameDeveloper Q&A: https://www.gamedeveloper.com/design/q-a-hand-painting-the-watercolor-world-of-i-dordogne-i-

Observed production lesson:
- Babouche describes intentionally mixing traditional watercolor and 3D;
- the team designed around camera needs and kept the technical method simple enough to preserve authored illustration;
- he explicitly preferred controlled painted results over spending excessive effort on shader complexity he did not control.

Use for My Little Boat:

```text
ADAPT
= authored surface first
+ camera-aware composition
+ keep technical stylization subordinate to art intent
```

Do not copy Dordogne's literal watercolor projection/camera-mapping production technique. My Little Boat has a persistent 3D boat space and broader camera/runtime interaction needs.

## 3. SEASON: A letter to the future — REFERENCE_ONLY / ADAPT SELECTIVELY

Sources:
- Official art-direction post: https://www.play-season.com/post/january-2022-the-art-direction-of-season
- Official level-design interview: https://www.play-season.com/post/level-design-interview-april-2022

Observed production lesson:
- the team aimed for every frame to retain concept-art/illustrative intent;
- their art direction emphasizes simplification, silhouette/readability, local color, mood, natural-light inspiration, and balancing illustrative texture with believable lighting;
- the team used custom rendering because it served their specific production context.

Use for My Little Boat:

```text
ADAPT
= simplify rather than add detail
+ preserve silhouette hierarchy
+ use time-of-day as mood/light variation of one believable place
```

Do not infer that My Little Boat needs SEASON's custom shader stack. That remains a future trade-study only if the bounded Godot approach cannot express the approved visual canon.

## 4. Implication for the next three visual results

The benchmark evidence supports narrowing the remaining visual planning in this order:

1. **Identity** — player silhouette + companion species/resting read.
2. **Place** — representative boat/decor + one coherent sea space across dawn/bright/sunset/night.
3. **Integrated frame** — one Representative Visual GDD combining the approved identity and place decisions.

This order reduces rework because the final key frame is produced only after the identity and environment decisions it depends on are approved.

## 5. Anti-copy boundary

Benchmarks provide principles only. Do not copy:
- exact character proportions or clothing from Spirit City;
- Dordogne's signature watercolor look or scene composition;
- SEASON's palette package, shader appearance, landmarks, or UI;
- any identifiable trade dress, branded decor, or signature key art.

My Little Boat remains `HANDPAINTED_STORYBOOK_3D_DIORAMA` with its own sea-first rest identity.
