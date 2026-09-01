# Bright Spring Seasonal Parallax Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 밝은 봄의 작은 꽃섬과 독립 구름이 기존 고정 하늘·흐르는 바다·보트 앞뒤 깊이를 유지한 채 서로 다른 속도로 보이게 한다.

**Architecture:** 기존 `RealTimeAtmosphereResolver`에 시각 전용 월→계절 bucket을 추가하고, `DriftSceneryDirector`는 선택 인자로 받은 season에만 bright motif pool에 하나의 꽃섬 entry를 합친다. `GameScene`은 shared bright sky/sea를 교체하지 않고, 세 카메라의 chroma-key 구름 Sprite3D와 normal/Appreciation 전용 섬 Sprite3D를 별도 consumer로 관리한다. 구름은 local camera space에서 느린 visual-only parallax를 하고, 섬은 기존 14초 명소 기회/cadence를 공유하되 comfort multiplier가 0이면 transit progress도 0으로 유지한다.

**Tech Stack:** Godot 4.7 stable, GDScript, existing `GameState` Autoload, `Sprite3D`, `ShaderMaterial`, existing `look_around_foreground_chroma_key.gdshader`, headless SceneTree contracts, Windows OpenGL Compatibility renderer capture.

**Spec:** `docs/design/PROJECT_GDD.md` §8.1 `2026-09-01 계절형 자연 명소 분리 합성 Pass v1 Blueprint review` at approved revision `d9e398c94457b557c10be3314988e97e5f36b7d8`.

## Global Constraints

- Godot 4.7 stable과 GDScript를 유지하고, 새 source file 첫 줄에는 한국어 역할 주석을 넣는다.
- `05–08=dawn`, `09–16=bright`, `17–20=sunset`, `21–04=night` 시간대 결정은 변경하지 않는다.
- 월 `3..5`는 internal `spring` visual bucket만이며 날짜·계절·지역·날씨 UI, saved preference, reward, progress, notification을 만들지 않는다.
- v1은 `bright + spring`의 `MLB-AMB-SEASONAL-ISLAND-001` 하나만 소비한다. 나머지 월은 기존 motif pool을 사용하며 다른 계절 image를 만들거나 소비하지 않는다.
- `SkyBackdrop`, `SeaBackdrop`, `voyage_split_sea_flow.gdshader`, `BoatSpace`, Look Around foreground, UI hierarchy와 모든 save schema를 보존한다.
- `SeasonalCloudLayer`는 normal/Look Around/Appreciation의 세 camera path에, `SeasonalIslandLayer`는 normal/Appreciation path에만 둔다.
- Cloud는 `MLB-AMB-SEASONAL-CLOUD-001`과 기존 `look_around_foreground_chroma_key.gdshader`를 사용한다. 새 shader나 full-scene moving texture를 만들지 않는다.
- Still에서는 새 cloud and island transit visual movement가 advance하지 않는다. Gentle은 existing normalized motion scale `0.5`를 그대로 사용한다.
- headless image readback은 주장하지 않는다. rendered image proof는 Windows display renderer capture에서만 기록한다. Human/device comfort는 `NOT_RUN`으로 남긴다.

## File Map

| file | responsibility |
| --- | --- |
| `scripts/voyage/real_time_atmosphere_resolver.gd` | deterministic month→season lookup and system-date visual routing |
| `scripts/voyage/drift_scenery_director.gd` | add one compatible spring island to bright selection without changing chance/cadence/fallback |
| `scenes/game.tscn` | named, camera-local Sprite3D consumers with approved exact textures/depth positions |
| `scripts/voyage/game_scene.gd` | visual context application, chroma binding, camera visibility, cloud drift, comfort-aware island transit |
| `tests/test_seasonal_parallax_contract.gd` | real behavior contract for routing, consumers, foreground selection, motion boundary and no progression mutation |
| `tests/capture_bright_spring_seasonal_parallax.gd` | renderer-only normal and Appreciation screenshots with actual seasonal island event |
| `.github/workflows/godot-validation.yml` | update exact discovered contract counts after one headless-safe contract is added |
| `docs/design/PROJECT_GDD.md` | change approved package state only after current implementation evidence exists |
| `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md` | update source/canonical consumer and evidence state |
| `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md` | record code, test, display capture and five adversarial implementation loops |
| `README.md` | add the user-visible visual-only local-month behavior without presenting a setting or task |

---

### Task 1: Month Bucket and Seasonal Motif Selection

**Files:**
- Modify: `tests/test_seasonal_parallax_contract.gd` (create)
- Modify: `scripts/voyage/real_time_atmosphere_resolver.gd`
- Modify: `scripts/voyage/drift_scenery_director.gd`

**Interfaces:**
- Consumes: `resolve_hour(hour: int) -> String`, `advance(delta: float, atmosphere_id: String) -> Dictionary`.
- Produces: `resolve_season_for_month(month: int) -> String`, `resolve_system_season() -> String`, `advance(delta: float, atmosphere_id: String, season_id: String = "") -> Dictionary`.

- [ ] **Step 1: Write failing routing and selection behavior tests.**

```gdscript
_expect(resolver.resolve_season_for_month(3) == "spring", "March must route to the visual-only spring bucket")
_expect(resolver.resolve_season_for_month(5) == "spring", "May must route to the visual-only spring bucket")
_expect(resolver.resolve_season_for_month(2).is_empty(), "February must fall back without a seasonal bucket")
_expect(resolver.resolve_season_for_month(13).is_empty(), "invalid month must resolve safely without a seasonal bucket")

var event := _event_for_context("bright", "spring", "MLB-AMB-SEASONAL-ISLAND-001")
_expect(not event.is_empty(), "bright spring must make the approved island selectable")
_expect(event.get("use_seasonal_island_layer", false), "seasonal island must choose its dedicated layer")
```

- [ ] **Step 2: Run the new contract before production changes.**

Run:

```powershell
$godot = 'C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe'
& $godot --headless --path . --script res://tests/test_seasonal_parallax_contract.gd
```

Expected: fail because resolver month routing, third bright selection entry and dedicated-layer event field do not yet exist.

- [ ] **Step 3: Implement only the requested routing and selection.**

```gdscript
func resolve_season_for_month(month: int) -> String:
	return "spring" if month >= 3 and month <= 5 else ""

func advance(delta: float, atmosphere_id: String, season_id: String = "") -> Dictionary:
	# Preserve current foreground, cadence and chance behavior; only use season when choosing a motif.
	var motif := _pick_motif_for_context(atmosphere_id, season_id)
```

The spring entry must have id `MLB-AMB-SEASONAL-ISLAND-001`, the exact canonical island path, a quiet label, authored side offset, and `use_seasonal_island_layer=true`. It must be added only to a copied bright selection pool when `season_id == "spring"`, so all old two-argument calls and 6–2 month behavior remain unchanged.

- [ ] **Step 4: Run the new and existing director contracts.**

Run:

```powershell
& $godot --headless --path . --script res://tests/test_seasonal_parallax_contract.gd
& $godot --headless --path . --script res://tests/test_drift_scenery_director.gd
```

Expected: both PASS; immediate-repeat exclusion applies to the three-item bright/spring pool and old bright two-item pool remains valid.

### Task 2: Camera-local Seasonal Consumers and Visual Context

**Files:**
- Modify: `tests/test_seasonal_parallax_contract.gd`
- Modify: `scenes/game.tscn`
- Modify: `scripts/voyage/game_scene.gd`

**Interfaces:**
- Consumes: resolver season output, director `use_seasonal_island_layer`, existing `GameState.get_motion_comfort_scale()`.
- Produces: `apply_real_time_visual_context_for_tests(hour: int, month: int) -> String`, `get_active_season_id() -> String`.

- [ ] **Step 1: Extend the failing test with scene-level consumers.**

```gdscript
_expect(scene.get_node_or_null("VoyageWorld/DioramaCameraRig/DioramaCamera3D/SeasonalCloudLayer") is Sprite3D, "normal camera needs a named cloud layer")
_expect(scene.get_node_or_null("VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/SeasonalCloudLayer") is Sprite3D, "Look Around needs the shared cloud layer")
_expect(scene.get_node_or_null("VoyageWorld/AppreciationCameraRig/AppreciationCamera3D/SeasonalCloudLayer") is Sprite3D, "Appreciation needs the shared cloud layer")
_expect(scene.get_node_or_null("VoyageWorld/LookAroundCameraRig/LookAroundCamera3D/SeasonalIslandLayer") == null, "Look Around must retain its angle-specific foreground policy")
scene.apply_real_time_visual_context_for_tests(12, 4)
_expect(scene.get_active_season_id() == "spring", "injected April must activate spring only for visuals")
```

- [ ] **Step 2: Run it and observe the missing-node/API failure.**

Run:

```powershell
& $godot --headless --path . --script res://tests/test_seasonal_parallax_contract.gd
```

Expected: fail because named nodes and injected visual context are absent.

- [ ] **Step 3: Add the minimum scene and GameScene route.**

```text
SkyBackdrop z=-15.00
SeaBackdrop z=-14.98
SeasonalCloudLayer z=-14.97 (only cloud alpha, therefore visible over the sky/horizon)
SeasonalIslandLayer z=-14.75 (sea front / boat behind)
Boat/player/pet/water contact
```

Add exact cloud texture to three `SeasonalCloudLayer` nodes and exact island texture to normal/Appreciation `SeasonalIslandLayer` nodes. Bind each cloud node to the pre-existing chroma-key shader; do not create a new shader resource. Set default layer visibility false. In `GameScene`, apply a `bright + spring` boolean to the cloud route, preserve current camera visibility ownership, and use the injected test route instead of mutating system time.

- [ ] **Step 4: Verify the scene contract and untouched split layers.**

Run:

```powershell
& $godot --headless --path . --script res://tests/test_seasonal_parallax_contract.gd
& $godot --headless --path . --script res://tests/test_split_sky_sea_background_contract.gd
& $godot --headless --path . --script res://tests/test_look_around_foreground_split_contract.gd
```

Expected: seasonal layers route only under bright/spring; static sky and flowing sea paths remain exact and Look Around has no island layer.

### Task 3: Comfort-aware Independent Motion and Transit

**Files:**
- Modify: `tests/test_seasonal_parallax_contract.gd`
- Modify: `scripts/voyage/game_scene.gd`

**Interfaces:**
- Consumes: `GameState` motion profile and `SeasonalIslandLayer` event flag.
- Produces: visual-only cloud offset and island transit positions internal to `GameScene`; no new `GameState` field or save method.

- [ ] **Step 1: Add failing observable motion and no-progression assertions.**

```gdscript
scene.apply_real_time_visual_context_for_tests(12, 4)
var cloud_before := cloud.position.x
scene.call("_apply_drift_motion", 1.0)
_expect(not is_equal_approx(cloud.position.x, cloud_before), "bright spring cloud must drift independently over live frames")

game_state.set_motion_comfort_profile("still")
var still_cloud_before := cloud.position.x
var still_island_before := island.position.x
scene.call("_apply_drift_motion", 1.0)
_expect(is_equal_approx(cloud.position.x, still_cloud_before), "still must freeze cloud parallax")
_expect(is_equal_approx(island.position.x, still_island_before), "still must freeze island transit")
_expect(game_state.photos.size() == before_photos, "seasonal visuals must not create photos")
_expect(game_state.voyage_records.size() == before_records, "seasonal visuals must not create voyage records")
```

- [ ] **Step 2: Run it and observe motion/no-save failure.**

Run:

```powershell
& $godot --headless --path . --script res://tests/test_seasonal_parallax_contract.gd
```

Expected: fail because no independent cloud offset or comfort-aware seasonal island transit exists.

- [ ] **Step 3: Implement the smallest visual-only motion state.**

```gdscript
var seasonal_motion_delta := safe_delta * visual_motion_multiplier * comfort_scale
_seasonal_cloud_phase += seasonal_motion_delta * SEASONAL_CLOUD_PHASE_PER_SECOND
if _seasonal_island_active:
	_seasonal_island_progress = minf(1.0, _seasonal_island_progress + seasonal_motion_delta / AMBIENT_SCENERY_PASS_DURATION_SECONDS)
```

The cloud offset must be lower amplitude/slower than the existing sea flow. The island route must fade and travel only its named island layers. Existing `AmbientSceneryPass` tween behavior and all `GameState` reward/save/together-time behavior remain unchanged. The shared return timer clears both scenery routes without adding a seasonal timer, reward, or persistence.

- [ ] **Step 4: Verify comfort and ambient regressions.**

Run:

```powershell
& $godot --headless --path . --script res://tests/test_seasonal_parallax_contract.gd
& $godot --headless --path . --script res://tests/test_comfort_preferences.gd
& $godot --headless --path . --script res://tests/test_ambient_motif_game_scene_contract.gd
& $godot --headless --path . --script res://tests/test_voyage_forward_drift_contract.gd
```

Expected: seasonal layer moves in bright/spring, freezes in still, is reduced in gentle, and existing normal/Appreciation motifs and boat/sea behavior remain green.

### Task 4: Renderer Evidence, CI Coverage, and Current Owners

**Files:**
- Create: `tests/capture_bright_spring_seasonal_parallax.gd`
- Modify: `.github/workflows/godot-validation.yml`
- Modify: `docs/design/PROJECT_GDD.md`
- Modify: `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md`
- Modify: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`
- Modify: `README.md`

**Interfaces:**
- Consumes: production visual-context test API, deterministic director test scheduling, exact asset SHA inventory, display renderer capture route.
- Produces: two `540×960` renderer screenshots, current contract count, and evidence-correct implementation status.

- [ ] **Step 1: Write the renderer-only capture.**

```gdscript
scene.apply_real_time_visual_context_for_tests(12, 4)
director.set_next_event_seconds_for_tests(0.0)
seed(seasonal_island_seed)
scene.call("_advance_drift_scenery", 0.1)
await create_timer(1.0).timeout
_save_runtime_image("bright_spring_normal_540x960.png")
scene.call("_toggle_appreciation_mode")
await create_timer(1.0).timeout
_save_runtime_image("bright_spring_appreciation_540x960.png")
```

The capture verifies both seasonal island route and cloud material binding before writing files. Store only the two final evidence PNGs in the existing project evidence directory.

- [ ] **Step 2: Import, run current contracts and scene smokes.**

Run:

```powershell
& $godot --headless --path . --import
$tests = Get-ChildItem tests -Filter 'test_*.gd' -File | Sort-Object Name
foreach ($test in $tests) {
    if ($test.Name -eq 'test_chibi_normal_chroma_material_proof.gd') { continue }
    & $godot --headless --path . --script ("res://tests/" + $test.Name)
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
& $godot --headless --path . --scene res://scenes/main_menu.tscn --quit-after 1
& $godot --headless --path . --scene res://scenes/game.tscn --quit-after 1
& $godot --headless --path . --scene res://scenes/album.tscn --quit-after 1
```

Expected: every headless-safe contract passes and one named display-only material proof remains excluded by capability, not marked as a headless pass.

- [ ] **Step 3: Run display renderer captures and inspect both saved images.**

Run the project executable with a display renderer, `--path . --script res://tests/capture_bright_spring_seasonal_parallax.gd`, then inspect both 540×960 PNGs. Verify cloud alpha/matte, static sky, flowing sea, island depth behind boat, boat water contact, and Appreciation camera are visible.

- [ ] **Step 4: Update current owners only after the evidence exists.**

Update GDD §8.1, visual inventory, handoff and README with exact code path, asset consumers, headless/display command results, warning boundary, and five implementation review loops. Update CI expected total/headless count to discovered file count. Do not call Human/device/motion comfort a pass.

- [ ] **Step 5: Final hygiene, verification and logical commit.**

Run:

```powershell
python -m unittest tests.test_ci_contract_coverage
git diff --check
git status --short
```

Read back final asset/evidence paths, remove only task-generated files outside the evidence/docs consumers, commit the one logical seasonal-parallax package, push the current branch, then read back the remote head. Do not create, alter, close, merge, or force-push any PR.

## Plan Self-Review

- **Spec coverage:** all §8.1 requirements map to Tasks 1–4. The constraints prohibit whole-scene movement, season UI, additional seasonal assets, persistence, rewards and Look Around island insertion.
- **Type consistency:** the plan introduces only `resolve_season_for_month`, `resolve_system_season`, optional third `advance` argument, `apply_real_time_visual_context_for_tests`, and `get_active_season_id`; every later task uses these exact names.
- **Test boundary:** headless contracts assert routing/real nodes/motion state; rendered pixels are captured only on a display renderer. No source-text-only test is proposed.
- **No-placeholder check:** completed; all paths, interfaces, expected states, verification routes and excluded renderer boundary are explicit.
