# First Production Visual Slice — Benchmark Evidence

Observed: 2026-08-26

Purpose: support the bounded implementation choice for `docs/superpowers/plans/2026-08-26-first-production-visual-slice.md`. These sources inform production technique only; they do not replace the My Little Boat Notion visual canon or runtime evidence.

## Evidence 1 — Godot 4.7 StandardMaterial3D

- Source: https://docs.godotengine.org/en/4.7/tutorials/3d/standard_material_3d.html
- Evidence class: `OFFICIAL_FACT`
- Observed claim: `StandardMaterial3D` / `ORMMaterial3D` are Godot's default 3D material paths and provide most artist-facing material features without requiring custom shader code. Opaque rendering is the default and fastest general path. Godot 4.7 also documents per-vertex lighting as a potential performance improvement on low-end/mobile devices.
- Project applicability: HIGH. My Little Boat currently uses Godot 4.7, the Mobile renderer, primitive `MeshInstance3D`, and `StandardMaterial3D`.
- Causality allowed: false.
- Disposition: `ADOPT` as the first proof route; custom shader remains available only if direct runtime evidence shows the simpler material route cannot express the approved style.

## Evidence 2 — Dordogne art-direction production method

- Source: https://automaton-media.com/en/interviews/20230621-19630/
- Supporting source: https://www.gamedeveloper.com/design/q-a-hand-painting-the-watercolor-world-of-i-dordogne-i-
- Evidence class: `DEVELOPER_SELF_REPORT`
- Observed claim: art director Cédric Babouche describes mixing authored watercolor work with 3D, avoiding fake-looking watercolor shaders, and favoring a comparatively simple projection/shader approach. The Game Developer interview similarly warns that animated watercolor-shader imitation can look artificial or visually uncomfortable and describes a deliberately simple shader route.
- Project applicability: MEDIUM-HIGH as a technique principle, not as a literal implementation template. My Little Boat should preserve authored broad shapes/material intent and avoid adding procedural complexity before composition is proven.
- Causality allowed: false.
- Disposition: `ADAPT`. Reuse the principle `authored surface + simple rendering before shader complexity`; do not copy Dordogne's camera-mapping pipeline.

## Evidence 3 — Dordogne current player-response signal

- Source: https://store.steampowered.com/app/1272840/Dordogne/
- Evidence class: `PLAYER_REPORT_AGGREGATE`
- Observed claim: Steam currently classifies Dordogne's overall reviews as `Very Positive`, with roughly 92% positive reviews at observation time.
- Project applicability: LOW-MEDIUM. This is only evidence that a strongly hand-painted/illustrative presentation can be accepted by players; it does not prove the rendering technique caused commercial or critical success.
- Causality allowed: false.
- Disposition: `REFERENCE_ONLY`.

## Evidence 4 — SEASON: A letter to the future custom-shader counterpoint

- Source: https://www.play-season.com/post/january-2022-the-art-direction-of-season
- Evidence class: `DEVELOPER_SELF_REPORT`
- Observed claim: Scavengers Studio describes a custom-shader/PBR hybrid used to make the 3D world resemble concept art, including per-object local color/shadow-tint control. The same post notes that individually editable shadow tint made global lighting consistency difficult across lighting conditions and required a compromise with PBR.
- Project applicability: MEDIUM as a counterexample. It proves a shader-heavy illustrative route is viable, but also exposes tooling/lighting-consistency cost that is premature for a one-developer first proof.
- Causality allowed: false.
- Disposition: `REFERENCE_ONLY / DEFER` until the simpler slice fails its visual acceptance questions.

## Evidence 5 — SEASON current player-response signal and failure separation

- Source: https://store.steampowered.com/app/695330/SEASON_A_letter_to_the_future/
- Evidence class: `PLAYER_REPORT_AGGREGATE`
- Observed claim: Steam currently classifies SEASON's overall reviews as `Very Positive`. Recent user reports praise its visual/meditative qualities but also separately criticize navigation/control or narrative issues.
- Project applicability: MEDIUM for the principle that visual quality cannot substitute for interaction/usability quality.
- Causality allowed: false.
- Disposition: `ADAPT` the evidence boundary: run visual proof and Human/runtime validation separately; do not treat attractive art as proof that the 5-minute rest loop or UI is good.

## Decision Trace

```text
A. recolor current spheres/box only
→ REJECT: insufficient authorship/silhouette proof

B. real current Scene + bounded multi-part primitive silhouettes + simple matte StandardMaterial3D
→ ADOPT: lowest-cost route that can test composition, sea-first hierarchy, motion survival, and repeatability

C. custom watercolor/toon shader foundation
→ DEFER: viable, but adds rendering/performance/lighting-maintenance variables before the basic proof exists

D. external modeled/textured production bundle
→ DEFER: couples identity, rights, asset pipeline, integration, and final-art decisions too early
```

## Revisit Conditions

Reopen B vs C vs D only if direct 540x960 runtime evidence shows one or more of the following:

- the bounded StandardMaterial/multi-part route still reads as generic primitive/AI-like CG;
- broad value grouping and silhouette are insufficient without authored textures;
- motion destroys the intended storybook impression;
- performance or material behavior prevents the selected direction;
- an approved project-owned authored asset becomes available and materially lowers total production cost.
