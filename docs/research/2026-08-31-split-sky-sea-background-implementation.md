# 고정 하늘·흐르는 바다 구현 조사 및 검증 · 2026-08-31

**분류:** `RESEARCHED → FEASIBLE → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`

## 문제와 선택

기존의 한 장 `SeaBackdrop`은 수평선 아래 UV만 움직였다. 같은 원화 안의 하늘은 멈추고 바다는 이동하므로, 화면에서 절반이 고정된 카드처럼 읽힐 수 있었다. 사용자는 하늘과 바다를 별도 이미지로 만들고, 하늘은 고정하고 바다는 흐르게 요청했다.

| 대안 | 결과 | 이유 |
| --- | --- | --- |
| 한 장의 합성 원화 + 아래쪽 UV mask 유지 | `REJECT` | 정확히 보고된 ‘반은 움직이고 반은 멈춘’ 인상을 유지한다. |
| `SkyBackdrop` + alpha-masked `SeaBackdrop` 두 장 | `ADOPT` | `Sprite3D`별 texture/material override와 spatial shader `ALPHA`를 써 수평선·구름은 정지하고 바다만 이동한다. 기존 voyage state와 UI·save·reward는 바꾸지 않는다. |
| 실제 3D ocean plane와 parallax camera를 전면 도입 | `REJECT` | 현행 painterly diorama·승인된 2D boat/Look Around 원화와 다른 depth/occlusion 체계를 요구하며, 현재 문제에 비해 비용과 회귀 범위가 크다. |
| 좌·우·후·상부 Look Around마다 보트 matte + 바다·하늘 새 asset family 제작 | `DEFER` | 해당 네 화면은 보트와 수면이 하나로 그려진 승인 composite이다. 이번에 바다만 강제로 덮으면 선체가 가려진다. 그래서 whole-image still presentation으로 보존하며, 별도 matte family가 user-approved candidate로 준비될 때만 재검토한다. |

## 엔진 근거

- [Godot Sprite3D documentation](https://docs.godotengine.org/en/stable/classes/class_sprite3d.html) confirms that each `Sprite3D` owns a texture and can use a `GeometryInstance3D.material_override`.
- [Godot spatial shader documentation](https://docs.godotengine.org/en/4.6/tutorials/shaders/shader_reference/spatial_shader.html) specifies that `ALPHA` drives transparency, `blend_mix` is alpha mixing, and `depth_draw_never` avoids writing a transparent background layer into depth.
- [Godot material documentation](https://docs.godotengine.org/en/stable/tutorials/3d/standard_material_3d.html) documents transparent mix behavior and depth-draw tradeoffs. The chosen sea layer stays behind foreground scenery and boat contacts, at `z=-14.98`, while the static sky stays at `z=-15`.

## Actual project mapping

| concern | actual implementation |
| --- | --- |
| static sky | Three camera-local `SkyBackdrop` Sprite3D nodes in `scenes/game.tscn` consume the exact time-pair `*-static-sky.png` resource with no material override. |
| moving sea | Existing three `SeaBackdrop` nodes consume `*-flowing-sea.png` and `voyage_split_sea_flow.gdshader`. The shader emits alpha only below `sea_start=0.42`, then applies the shared `flow_offset`. |
| state parity | `scripts/voyage/game_scene.gd` applies the same time-pair and color modulation to Diorama, front Look Around, and Appreciation. Camera changes keep voyage time, speed, save, rewards, and soundscape unchanged. |
| protected angle art | Non-front Look Around hides `SkyBackdrop`, restores the approved composite texture, and removes the sea-flow material, preventing a half-moving boat composite. |
| assets | `MLB-BG-SPLIT-001..008` canonical files live in `assets/images/runtime/voyage/split/`; source candidates are preserved in `docs/visual/generated/2026-08-31-split-sky-sea/`. |
| rollback | Revert this one logical commit restores the old scene/material maps. The original combined time assets remain for legacy, historical, and non-game consumers. |

## Five adversarial loops

1. At `HEAD=026f39b` with tracked branch/upstream relation `0/0`, read `AGENTS.md`, GDD, visual inventory, `game.tscn`, `game_scene.gd`, existing time/backdrop contracts, existing asset consumers, Base adoption, remote status, and free disk space. Valid finding: single composite source was the reported mismatch.
2. Compared the four alternatives above and read current Godot primary documentation. Valid finding: separate `Sprite3D` layers with a transparent spatial sea shader are feasible at the existing camera-local surface.
3. Wrote `test_split_sky_sea_background_contract.gd` before implementation. It failed with 45 expected assertions for missing pair assets, nodes, and shader.
4. Generated the user-locked bright pair, created matching dawn/sunset/night pairs, registered provenance/canonical copies, implemented the split nodes/shader/router, and passed focused split, time, forward-drift, ambient, Look Around, and capture-guard contracts.
5. Captured all four time states on Windows OpenGL. Valid finding: Sunset was orange-overloaded (`r=0.97` runtime backdrop multiplier) against the visual lock. Added a failing constraint, changed the multiplier to `Color(0.86, 0.91, 0.96, 1.0)`, reran the contract and all runtime frames. A final import run exposed Hera editor resources leaking only in headless import, so a failing guard contract was added and the plugin now returns before server/UI registration in headless mode. The final bright pair measures still sky `0.00%` change and open sea `27.70%` changed pixels after 1.8 seconds; the 55-contract headless set, renderer capture, and clean import were then rerun.

## Evidence boundary

The implementation and renderer capture establish that the exact assets, scene nodes, shader routing, and time states work on the tested GPU. They do **not** establish actual-device color, touch reachability, a 5-minute rest experience, visual fatigue, or motion comfort. Those remain `NOT_RUN` until the user explicitly requests Human validation.
