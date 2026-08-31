# Look Around foreground split implementation research · 2026-09-01

**Decision status:** `RESEARCHED → FEASIBLE → SPECIFIED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`.

**Boundary:** This receipt covers the user-locked `port`·`starboard`·`aft`·`overhead` visual direction only. It does not add a destination, reward, save key, social system, time preference, or Human/device approval.

## Current finding

The starting revision `c6e8880` used current split `SkyBackdrop`/`SeaBackdrop` for the front Look Around route, but non-front angles replaced the sea layer with whole-composite still images. Those files embedded the boat, character, companion, sky, sea, and jellyfish in one texture. Therefore, keeping them could not satisfy the approved requirement that non-front water visibly flows while the sky remains still.

Godot's [Sprite3D reference](https://docs.godotengine.org/en/stable/classes/class_sprite3d.html) confirms that a 2D texture can be displayed in the 3D scene and that a material override changes the draw material. The [spatial shader reference](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html) documents transparent `ALPHA` output and `depth_prepass_alpha`, which is the renderer-valid depth mode used for the keyed foreground. These references were read against the current Godot 4.7 implementation before choosing the route.

## Alternatives compared

| option | decision | reason |
| --- | --- | --- |
| Retain the four whole-composite non-front images | `REJECT` | Existing static sea conflicts directly with the user-approved flowing water requirement. |
| Add four character/boat foregrounds over the existing 8 time-pair sky/sea assets | `ADOPT` | One angle-specific foreground plus shared time-of-day background keeps direction changes clear and preserves the tested sea-only motion surface. |
| Generate a whole scene for every time-of-day × angle combination | `REJECT` | It creates 16–32 duplicated backgrounds, makes visual drift likely, and reintroduces static composite sea risk without a current player value. |
| Replace the scene with a new 3D ocean/boat system | `REJECT` | It exceeds the approved presentation repair, risks the locked cozy illustration direction, and adds no required gameplay meaning. |

## Actual project mapping

| concern | current implementation |
| --- | --- |
| angle asset selection | `scripts/voyage/look_around_presentation_router.gd` maps `port`, `starboard`, `aft`, `overhead` to `MLB-LOOK-FG-001..004`. |
| scene consumer | `scenes/game.tscn` provides `LookAroundCamera3D/LookAroundForeground` in front of `SeaBackdrop`. |
| background motion | `scripts/voyage/game_scene.gd` keeps `_apply_split_backdrop_textures()` for every Look Around angle, so `SkyBackdrop` stays static and `SeaBackdrop` retains `voyage_split_sea_flow.gdshader`. |
| technical matte | `assets/shaders/look_around_foreground_chroma_key.gdshader` keys only the controlled magenta matte. The angle texture is passed into the explicit `source_texture` uniform whenever the view changes. |
| assets and provenance | `docs/visual/generated/2026-09-01-look-around-foreground-split/final/` preserves each source copy. `assets/images/runtime/voyage/look_around/foreground_split/` has the identical canonical runtime copy. |
| save and gameplay | No save migration or state mutation. `set_look_around_mode()` still changes only presentation/camera state. |
| rollback | Revert the one routing/scene/shader package and restore the exact superseded asset family from the prior repository revision. |

## Image-model technical boundary

The host image model supplied opaque checkerboard pixels when asked for RGBA alpha. Pixel inspection confirmed every sampled alpha value was `255`, so those outputs were rejected rather than silently used. The final four source sprites use an explicit opaque magenta technical matte. The runtime shader turns only that matte into alpha, which avoids a static background card while retaining the generated art as an image-model asset rather than recreating it with vector or primitive art.

## Five adversarial loops

| loop | exact scope read and check | validated finding | correction / result |
| --- | --- | --- | --- |
| 1 | Read `AGENTS.md`, current `game.tscn`, router, consumers, prior whole-composite assets, and focused Look Around contracts at `c6e8880`. Created and ran `test_look_around_foreground_split_contract.gd` before implementation. | Four final assets and `LookAroundForeground` were missing. Existing non-front route hid the split sky and removed the flowing-sea shader. | Correct RED receipt. Selected shared split background plus angle foreground. |
| 2 | Generated four individual angle sprites and inspected dimensions, hashes, and sampled alpha values. | The first image-model outputs visibly looked like checkerboard but had no alpha pixels. | Rejected those as runtime inputs. Generated controlled magenta-matte sources, preserved provenance/canonical hash pairs, and introduced the isolated runtime chroma-key route. |
| 3 | Ran import plus the foreground, scene, router, and asset-guard contracts. Read the exact shader error and the repository's working normal chroma shader. | `depth_draw_alpha_prepass` is invalid in this Godot version and `source_color` was an invalid local identifier. The focused test falsely printed PASS despite renderer compilation messages. | Changed to documented `depth_prepass_alpha`, renamed the local variable, and reran all focused contracts with no shader compilation error. |
| 4 | Captured all angles on Windows OpenGL at `540 × 960` and inspected port, aft, and overhead frames. | The initial foreground scale cropped the boat; the raw matte left a visible edge color when sampled linearly. | Reduced `LookAroundForeground.pixel_size` to `0.0055`, used nearest-mipmap sampling and color decontamination. Re-captured all six surfaces; complete boat and direction separation are visible. |
| 5 | Saved a 1.8-second port frame pair, measured static-sky/open-sea regions, searched every source consumer, deleted exact superseded composites, re-imported, ran all 56 headless contracts in bounded batches, and updated exact CI counters. | Whole-composite assets had no source/scene/test consumer. Non-front sky remained unchanged while sampled sea changed. | Removed 4 old tracked PNGs (`6,527,786` bytes) and 4 regenerable import sidecars. Current source set is 57 total contracts with 56 headless passes; remote CI and Human/device gates remain separate. |

## Evidence ceiling

- `docs/evidence/2026-09-01-look-around-foreground-split/` contains Windows OpenGL `540 × 960` normal, four angle, Appreciation, and 1.8-second port-pair captures.
- The port pair measured static sky `0.00%` changed pixels and sampled open sea `58.44%` changed pixels, with mean RGB delta `13.487`.
- This proves the current local renderer route and does not prove Human comfort, a physical device, accessibility, long-run calm, or release approval. Those remain `NOT_RUN` until the user explicitly requests human verification.
