# 현재 화면·시각 asset consumer 정본

**복구 상태:** `REBUILT_FROM_CURRENT_RUNTIME_2026-08-31`

**역할:** 이 문서는 visual direction, 실제 runtime consumer, asset provenance, 화면별 evidence의 관계를 기록합니다. 사람용 게임 설명은 [프로젝트 GDD](../design/PROJECT_GDD.md)가, 코드 수준 상태는 [현재 Godot handoff](../handoffs/CURRENT_GODOT_IMPLEMENTATION.md)가 소유합니다.

## 1. authority와 evidence를 구분하는 법

| 구분 | owner | 뜻 |
| --- | --- | --- |
| 제품 방향 | `PROJECT_GDD.md`, 사용자가 승인한 visual decision | 플레이어가 실제로 보게 되어야 하는 것 |
| runtime consumer | Scene, GDScript, Resource, tests, captures | 현재 game이 실제로 소비하는 것 |
| visual source/provenance | asset binary, SHA-256, 이 inventory | 어떤 파일이 어디에서 왔고 어디에 연결됐는지 |
| Human evidence | 실제 사람의 기기·플레이 관찰 | 아름다움·편안함·가독성이 확인됐는지 |

Notion은 historical archive이며 이 문서의 current owner가 아닙니다. 생성 exploration, 사용자 승인, canonical copy, Godot runtime asset, renderer capture, Human/device evidence는 서로 교환할 수 없습니다.

### 1.1 2026-09-02 standing image-production authorization

사용자는 기존 visual grammar와 실제 consumer 안에서 필요하다고 판단된 이미지를 per-file approval 없이 제작·등록·연결·검증하도록 승인했습니다. 따라서 concrete runtime consumer, current art direction, dimensions, state family와 rollback 계획을 먼저 확인한 뒤 candidate stop 없이 권장 경로를 계속할 수 있습니다. 생성 뒤에는 provenance와 source/canonical SHA-256을 기록하고 runtime consumer와 renderer evidence를 연결합니다. 이 standing authority는 새 게임 의미·새 public surface·새 asset family의 final visual lock·비용·권리 불명 source를 자동 승인하지 않으며, image generation·canonical registration·runtime implementation·Human/device acceptance는 계속 별도 상태로 기록합니다.

## 2. 확정 visual grammar

| layer | Keep | Avoid |
| --- | --- | --- |
| 전체 | `HANDPAINTED_STORYBOOK_3D_DIORAMA`, 넓은 바다·하늘, 안정된 수평선, soft-matte painterly material | glossy photoreal CG, noisy micro-detail, 다른 게임의 trade dress |
| 캐릭터·동반자 | 둥근 silhouette, 큰 hair/fur mass, 절제된 셀 명암, 친근한 chibi 비율 | 과도한 유리눈, glamour fashion, generic AI doll feel |
| 보트·소품 | 생활감 있는 넓은 painted value, 바다를 가리지 않는 제한된 decor | 과밀 장식, stats/rarity visual language |
| 바다·빛 | 느린 water motion, 낮거나 중간 대비, `INDIGO_RAIN_REFLECTION` night | 강한 점멸, 과한 bloom, 위협적인 날씨 spectacle |
| camera/UI | rear 3/4 diorama와 low-UI Appreciation parity, compact `쉬는 메뉴` | 큰 panel이 first view를 가리는 구성 |

기본 Normal anchor는 chestnut-bob chibi player + round dog입니다. 이는 다른 cosmetic pair를 제거하거나 능력 차이를 주는 결정이 아닙니다. alternate A/B player, cat/rabbit/otter, `stripe`·`moon` cushion은 2026-08-31 사용자 일괄 승인 뒤 같은 soft-matte chibi family로 canonical runtime path에 등록됐습니다. 기본 C+강아지, `floral` cushion, Album의 실제 항해 postcard는 유지합니다.

## 3. 현재 제품 화면과 actual runtime surface

| screen_id | 제품에서의 의미 | actual runtime consumer | 상태 |
| --- | --- | --- | --- |
| `MLB-SCR-001` Title boat waiting | 확정 로고와 실제 보트·동반자·바다를 보고 항해를 시작하는 첫 장면 | `project.godot` → `game.tscn/TitleOverlay`, `GameScene.start_voyage_from_title()` | `IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| `MLB-SCR-003` Normal voyage diorama | character, companion, boat, sea와 낮은 밀도의 풍경을 함께 보는 core surface | `game.tscn`, `boat_space.tscn`, `game_scene.gd` | `IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| `MLB-OVR-004` Appreciation Camera | UI를 줄이고 수평선에 집중하는 선택 화면 | `AppreciationCameraRig`, `GameScene._set_normal_boat_foreground_visible(false)` | `IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| `MLB-OVR-005` 꾸미기 | arrival 뒤 원할 때 local cosmetic state를 바꾸는 surface | DecorPanel, `DecorPreview`, identity/decor local storage | `IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human readability/touch `NOT_RUN` |
| `MLB-SCR-010` Album | 실제 사진·기억·함께한 시간을 보는 archive | `scenes/album.tscn`, `AlbumView` | `PARTIAL_IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human readability `NOT_RUN` |
| `MLB-SCR-001-LEGACY` main menu | 시작 전 identity/time/mood selection의 이전 slice | `main_menu.tscn`, `main_menu.gd` | `SUPERSEDED_RUNTIME_SLICE`, current entry가 아님 |

### 3.1 확정 브랜드 타이틀

| asset id | canonical file | title / promise | provenance | allowed consumer | state |
| --- | --- | --- | --- | --- | --- |
| `MLB-BRAND-TITLE-001` | `assets/images/brand/my_little_boat_title_lockup_v1.png` | `MY LITTLE BOAT` / `파도 위에서, 함께 쉬는 시간` | built-in image generation, user `LOCK` 2026-08-31, `2172×724` RGB sRGB, SHA-256 `6A0511B1C2B74B742E250D556DD15D9F76A484DA5F2D8DE4D41025279C68DAFB` | store, splash, GDD cover, app/window title, `GameScene/TitleOverlay/TitleLayout/BrandLogo` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED`; `TITLE_ENTRY_RUNTIME_CONSUMER` |

`MLB-BRAND-TITLE-001`의 warm-ivory 배경과 player·dog illustration은 소개용 world-setting treatment이다. user가 승인한 title-entry runtime consumer에서만 `BrandLogo`로 표시하며, 그 아래의 실제 diorama player/pet state를 대체하지 않는다. `FinalDioramaCard`, playable player/pet selection, save ID, reward, voyage duration, soundscape에는 연결하지 않는다. 타이틀 대기에는 `GameState.begin_voyage()`를 호출하지 않으므로, title을 보는 시간이 progression으로 저장되지 않는다. 이 제한을 `TITLE_ENTRY_RUNTIME_CONSUMER`라고 표기한다.

#### 3.1.1 2026-08-31 lock 및 기계 검증 receipt

- Loop 1 — current `AGENTS.md`, `DOCUMENTATION_MAP.md`, GDD, screen inventory, `project.godot`, direct-entry Scene/test를 fresh-read했다. 첫 보트 진입과 legacy menu 격리를 유지하는 것이 retained boundary로 확인됐다.
- Loop 2 — `test_title_brand_asset_contract.gd`를 asset/doc/config보다 먼저 작성해 실행했다. canonical file, asset ID, `BRAND_DEPLOYMENT_ONLY`, GDD title/promise가 없어서 예상한 여섯 assertion이 실패했다.
- Loop 3 — 2026-08-31에 user `LOCK`한 generator source의 SHA-256과 project canonical copy를 대조했다. 양쪽 모두 `6A0511B1C2B74B742E250D556DD15D9F76A484DA5F2D8DE4D41025279C68DAFB`이며, source는 `1,273,356` bytes, `2172×724`, `RGB`였다.
- Loop 4 — Godot `--headless --path . --import` 뒤 title contract를 rerun했다. raw `Image.load_from_file`가 남긴 export-warning을 발견해 imported `Texture2D` consumer 방식으로 test를 고쳤고, warning 없이 `PASS`를 확인했다.
- Loop 5 — `test_title_brand_asset_contract.gd`, `test_direct_boat_entry_contract.gd`, `test_main_menu_identity_contract.gd`, `game.tscn` headless scene smoke, project headless smoke, `test_human_game_blueprint_profile.py` 5 cases, `git diff --check`를 다시 실행했다. title/direct-entry/identity contract와 smoke/profile checks는 `PASS`; `git diff --check`는 pre-existing CRLF conversion notices만 출력하고 whitespace error는 없었다.

이 receipt는 title asset이 imported resource와 config title로 읽힌다는 machine evidence다. store rendering, splash composition, readable contrast at distribution sizes, actual platform window title, player impression은 아직 확인하지 않아 Human/brand acceptance는 `NOT_RUN`이다.

## 4. 기본 Normal과 Look Around asset 경계

| asset id | canonical consumer | state |
| --- | --- | --- |
| `MLB-LOOK-CHIBI-NORMAL-REAR-001`과 derived matte | default C+dog `BoatSpace/FinalDioramaCard`의 explicit chroma shader | `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human/device comfort `NOT_RUN` |
| `MLB-LOOK-FG-001..004` | `LookAroundPresentationRouter`의 port/starboard/aft/overhead exact foreground와 `LookAroundForeground` chroma-key shader. shared static sky와 flowing sea는 유지 | `USER_LOCKED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; 2026-09-01 OpenGL six-angle capture, 1.8초 port pair sky `0.00%` / open sea `58.44%` change; Human motion comfort `NOT_RUN` |
| `MLB-LOOK-CHIBI-TRN-001..004` | 이전 whole-composite non-front Look Around art | `SUPERSEDED_PENDING_CLEANUP`; current router consumer를 제거했으며 full source/consumer search와 regression 후에만 exact deletion |
| `MLB-BG-SPLIT-001..008` | `dawn / bright / sunset / night`별 `SkyBackdrop` + `SeaBackdrop`, normal·front Look Around·Appreciation | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; 2026-08-31 OpenGL 9-frame capture, Human motion/color comfort `NOT_RUN` |
| `MLB-AMB-MOTIF-001..006` | current local-time bucket의 normal·Appreciation `AmbientSceneryPass`, split sky·flowing sea는 유지 | `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; 2026-08-31 six-pass capture, Human long-run observation `NOT_RUN` |
| `MLB-AMB-SEASONAL-REF-001` | 2026-09-01 밝은 봄 꽃섬의 visual-direction source. runtime consumer 없음 | `USER_APPROVED → CANON_REGISTERED → REFERENCE_ONLY`; full-scene source는 split layer를 대체하지 않음 |
| `MLB-AMB-SEASONAL-ISLAND-001` | Bright/spring `SeasonalIslandLayer`, Normal·Appreciation의 existing ambient-scene transit 위. 원본의 투명 캔버스는 runtime `region_rect`로 제외하고, 수평선의 원거리 landmark만 보인다 | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; alpha source/canonical SHA equality, headless contract, normal transit early/mid/late와 Appreciation 2026-09-02 OpenGL capture verified. Human `NOT_RUN` |
| `MLB-AMB-SEASONAL-CLOUD-001` | Bright/spring `SeasonalCloudLayer`, 세 camera path의 static sky 위 runtime-local chroma-key parallax | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; matte-key/material isolation, upper-cloud capture guard and 2026-09-01 OpenGL two-view capture verified. Human `NOT_RUN` |
| `MLB-BOAT-FLT-006` | `assets/images/runtime/voyage/boat-waterline-contact-v2.png` → `GameScene/VoyageWorld/BoatWaterlineContact` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human motion comfort `NOT_RUN` |

`FinalDioramaCard`는 기본 C+강아지 route에서만 사용한다. alternate pair는 동일한 `BoatSpace`의 layered `Sprite3D` route를 사용한다. 이 차이는 save 의미·voyage 시간·reward·soundscape를 바꾸지 않는다.

`MLB-BOAT-FLT-006`은 built-in image generation으로 만든 `2172×724` transparent RGBA waterline strip이며, 사용자가 2026-08-31에 승인했습니다. canonical binary SHA-256은 `8C145B545B913567A19F47927A13E83FB7328177D7DCC8A195B4BA857F10C22B`입니다. 기존 `MLB-BOAT-FLT-005`의 넓은 legacy ripple은 뒤쪽의 느린 확산 수면으로 남기고, 이 자산은 depth test를 유지한 전면 선체 하단의 좁은 접점만 담당합니다. 둘은 `BoatSpace`와 같은 lateral·forward·vertical drift를 따르며, `still` comfort에서는 모두 base position으로 돌아갑니다.

### 4.1 2026-08-31 사용자 승인 분리 하늘·바다 family

`MLB-BG-SPLIT-001..008`은 built-in image generation으로 만든 한 family다. 사용자는 밝은 시간대의 candidate 쌍을 검토한 뒤 권장 구조로 연속 진행하도록 승인했다. 각 candidate source는 `docs/visual/generated/2026-08-31-split-sky-sea/`에, 같은 SHA-256의 canonical runtime copy는 `assets/images/runtime/voyage/split/`에 보존한다. static sky는 material override가 없고, flowing sea만 `voyage_split_sea_flow.gdshader`로 수평선 아래 alpha/motion을 가진다.

| asset id | canonical runtime file | SHA-256 | consumer |
| --- | --- | --- | --- |
| `MLB-BG-SPLIT-001` | `bright-static-sky.png` | `3BCF0A54CF7939556E39F31F1029FA4016D595CC05B01F9486E266E6AF58D4A6` | Bright `SkyBackdrop` |
| `MLB-BG-SPLIT-002` | `bright-flowing-sea.png` | `AA43722C3B5EC89F784CA338F877B5FB11173F22AC1ED003E5B883501522A0A1` | Bright `SeaBackdrop` |
| `MLB-BG-SPLIT-003` | `dawn-static-sky.png` | `83F024878A9EC3619058AA7BBEF11A56C0345965C4F05CD40D13D1A146AD1950` | Dawn `SkyBackdrop` |
| `MLB-BG-SPLIT-004` | `dawn-flowing-sea.png` | `6358DF903FDB3D6293B6DE52CBAEB440C3A56F44E15664A0A894097D0AD0BE0A` | Dawn `SeaBackdrop` |
| `MLB-BG-SPLIT-005` | `sunset-static-sky.png` | `F00AA8D4A68FA96F809C402E7232A0A112BED0E4CF7474200D04D574AE2144FD` | Sunset `SkyBackdrop` |
| `MLB-BG-SPLIT-006` | `sunset-flowing-sea.png` | `1BF695BB6CBC806B60864BA0D10948D1FF7405DDCE126A92469E5E40657277E6` | Sunset `SeaBackdrop` |
| `MLB-BG-SPLIT-007` | `night-static-sky.png` | `FE7AD39F9812A947E396DE7DC1DE81AA7B72CD68CA59C008BC99B407B3E395E1` | Night `SkyBackdrop` |
| `MLB-BG-SPLIT-008` | `night-flowing-sea.png` | `87B44108258C7047FBF9C4B887E6C8334678992B9CDB5651D9AD1C00D87C37EA` | Night `SeaBackdrop` |

### 4.2 2026-09-01 user-approved bright spring seasonal parallax material

사용자는 전체 풍경 candidate의 거리감·색감·작은 명소 방향을 승인했지만, 하늘·구름·바다·섬이 한 장으로 함께 움직이는 runtime 사용은 승인하지 않았습니다. 따라서 전체 scene은 visual-direction source로만 보존하고, runtime은 기존 `Bright SkyBackdrop`과 `Bright SeaBackdrop`을 재사용한 뒤 구름과 섬을 독립 Sprite3D layer로 합성합니다. 이 경계는 보트·동반자·water contact의 foreground depth와 existing flowing-sea evidence를 보존합니다.

| asset id | source / canonical file | dimensions / format | SHA-256 | approved role | implementation boundary |
| --- | --- | --- | --- | --- | --- |
| `MLB-AMB-SEASONAL-REF-001` | `docs/visual/generated/2026-09-01-seasonal-parallax-bright/bright-spring-direction-reference.png` | `1672×941`, RGB | `5E2CCBA025C584C8B8871EB08F9B650DCF9436916122BEB5663998B14A7EB960` | bright spring islet의 source composition·palette·distance reference | runtime texture가 아니며, full scene을 `AmbientSceneryPass`로 이동시키지 않음 |
| `MLB-AMB-SEASONAL-ISLAND-001` | source `docs/visual/generated/2026-09-01-seasonal-parallax-bright/bright-spring-islet-candidate.png` → runtime `assets/images/runtime/voyage/seasonal_parallax/bright-spring-islet.png` | `1672×941`, RGBA | `22E9AE8B74B331F7147936B780823D81EA59DD407837BF4ACBC9F82FFC046987` | sky·ocean·reflection 없이 꽃·나무·풀·바위만 남긴 Bright/spring distant island | `GameScene/SeasonalIslandLayer` normal·Appreciation only. Existing source를 복제하지 않고 `region_enabled`, `Rect2(632, 350, 1028, 350)`, `pixel_size=0.005`로 투명 여백을 제외한 원거리 landmark만 사용하며 하단 보트 항로에는 진입하지 않음 |
| `MLB-AMB-SEASONAL-CLOUD-001` | source `docs/visual/generated/2026-09-01-seasonal-parallax-bright/bright-spring-clouds-chroma-candidate.png` → runtime `assets/images/runtime/voyage/seasonal_parallax/bright-spring-clouds-chroma.png` | `1672×941`, RGB technical matte | `27174AB314DDB9D93E5FE2FA45821F7F6D3C2C38080E2A34AACFA5BCFF2B2557` | three small bright clouds above horizon on magenta technical matte | three `SeasonalCloudLayer` paths reuse `look_around_foreground_chroma_key.gdshader` with per-node runtime material. Matte itself is never player-visible |
| existing `MLB-BG-SPLIT-001` / `002` | `bright-static-sky.png` + `bright-flowing-sea.png` | `1672×941`, RGB pair | see §4.1 | static sky + independently flowing sea | re-used without duplicate generation or changed asset identity |

`MLB-AMB-SEASONAL-ISLAND-001`의 empty-canvas samples are actual `A=0`; island sample is `A=253`. 불투명 alpha bounds는 `Rect2(644, 362, 1002, 322)`이고, runtime consumer는 이 영역을 충분한 여백과 함께 포함하되 source canvas의 네 변은 제외한 `Rect2(632, 350, 1028, 350)`만 표시한다. `MLB-AMB-SEASONAL-CLOUD-001` is intentionally opaque because the current built-in image output did not preserve actual transparent pixels for cloud candidates. Its non-cloud matte samples satisfy existing chroma-key thresholds with chroma `0.710–0.847` and brightness `0.827–0.882`; cloud samples do not meet the key condition. The source-level compatibility is now supplemented, not replaced, by `tests/test_seasonal_parallax_contract.gd` and `tests/capture_bright_spring_seasonal_parallax.gd`: Windows OpenGL normal early/mid/late and Appreciation captures are `540×960`, recorded at `docs/evidence/2026-09-01-bright-spring-seasonal-parallax/`. The normal capture guard requires an upper-sky cloud mark, a visible horizon-band island, no island-colour samples in the lower boat lane outside the fixed boat silhouette, and at least `80px` of early/late rendered-island center displacement. Current renderer output measured `213px`. Human/device comfort is still `NOT_RUN`.

The two generated RGB checkerboard cloud attempts and one reflective-island exploration are `REJECTED_GENERATED_CANDIDATES`; they have no project copy, canonical ID, runtime consumer, capture, or release meaning. Candidate-store deletion was attempted after their rejection but platform deletion protection blocked it. No repository capacity, Godot importer, or build path consumes them.

## 5. 승인 decor와 alternate 치비 family

`rail_accent=postcard`는 main rest composite에 합성하지 않는다. 이 선택은 independent `DecorPreview`의 rail face와 Album의 실제 항해 postcard에만 보인다. 기본 C+강아지 final composite은 `pet_cushion=floral`만 bow-side clear space에 표시한다.

| asset id | canonical file | consumer | state |
| --- | --- | --- | --- |
| `MLB-DECOR-CHIBI-CUSHION-FLORAL-001` | `assets/images/decor/pet_cushion/cushion_floral_chibi.png` | default C+dog bow-side `StorybookPetCushionSurface` | `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| `MLB-DECOR-CHIBI-POSTCARD-001` | `assets/images/decor/postcard/postcard_chibi_moonboat.png` | independent DecorPreview `TechnicalPostcardFace`, no main overlay | `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |

### 5.1 2026-08-31 user-approved alternate chibi family

이 seven-asset batch는 기존 alternate player·pet과 unselected `stripe`·`moon` cushion의 고밀도/사실적 질감을, 현재 soft-matte chibi visual grammar에 맞추기 위해 제작했다. user가 제공한 치비 이미지는 큰 머리, 둥근 silhouette, 단순한 색 블로킹, 친근한 낮은 detail이라는 일반 reference로만 사용했으며 특정 캐릭터, 의상, 플랫폼 UI, 작가 또는 서비스의 고유 식별 요소를 재현하지 않았다. candidate bytes는 `docs/visual/generated/2026-08-31-alternate-chibi-family/`에 보존되고 아래 canonical file은 동일 SHA-256의 non-destructive sibling copy다.

| canonical asset id | preserved candidate source | canonical file and exact consumer | dimensions | SHA-256 | state |
| --- | --- | --- | --- | --- | --- |
| `MLB-ALT-CHIBI-001` | `candidate-player-a-soft-hooded-chibi.png` | `assets/images/runtime/chibi_alternates/avatar_a_soft_hooded_chibi.png` → `a_soft_hooded` Sprite3D | `1199×1312` | `FDEAA5D7C69445CCBD126101A44B2615D781D2E55C4E295F1FAAB3EE53E3634F` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human visual comfort `NOT_RUN` |
| `MLB-ALT-CHIBI-002` | `candidate-player-b-sailor-cape-chibi.png` | `assets/images/runtime/chibi_alternates/avatar_b_short_cape_chibi.png` → `b_short_cape` Sprite3D | `1214×1295` | `054C6EDBD0581D751331846761EFF26861B14B0489D230F7CBE1CD47103A7C88` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human visual comfort `NOT_RUN` |
| `MLB-ALT-CHIBI-003` | `candidate-pet-cat-chibi.png` | `assets/images/runtime/chibi_alternates/pet_cat_chibi.png` → `cat` Sprite3D | `1214×1295` | `ADA2EC057D77FEE2951915672C1B272D8D40102F526D78F3F3527FDAD54108A3` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human visual comfort `NOT_RUN` |
| `MLB-ALT-CHIBI-004` | `candidate-pet-rabbit-chibi.png` | `assets/images/runtime/chibi_alternates/pet_rabbit_chibi.png` → `rabbit` Sprite3D | `1214×1295` | `4E7110A3F84516E7676B807107E149244102F3360FB1B9B1B6F934FCE056DAF9` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human visual comfort `NOT_RUN` |
| `MLB-ALT-CHIBI-005` | `candidate-pet-otter-chibi.png` | `assets/images/runtime/chibi_alternates/pet_otter_chibi.png` → `otter` Sprite3D | `1312×1199` | `47793AE64210FDD3F586ABBE3C5567BD2441FB395A3C23A764205D671E2C2439` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human visual comfort `NOT_RUN` |
| `MLB-ALT-CHIBI-006` | `candidate-cushion-stripe-chibi.png` | `assets/images/decor/pet_cushion/cushion_stripe_chibi.png` → `pet_cushion=stripe` | `1254×1254` | `88F6C0081DBBE29139EC45D2F28C080E8B6A3579CB0C3AFB30D1561D2ECB5438` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human visual comfort `NOT_RUN` |
| `MLB-ALT-CHIBI-007` | `candidate-cushion-moon-chibi.png` | `assets/images/decor/pet_cushion/cushion_moon_chibi.png` → `pet_cushion=moon` | `1254×1254` | `AF0E460B7FBC21A8C4C3C775DF21D53E2432651D7FFD7B6E8D87E33B7469A6C2` | `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human visual comfort `NOT_RUN` |

## 6. implementation and evidence receipt

- `IdentityVisualCatalog` resolves the existing `a_soft_hooded`, `b_short_cape`, `cat`, `rabbit`, and `otter` IDs to their seven-family canonical paths. Unknown IDs still normalize to the existing C+dog defaults.
- `boat_space.tscn` binds the five alternate `Sprite3D` cards to the canonical copies. It does not alter default `FinalDioramaCard` or Look Around routing.
- `DecorVisualAssets` resolves the existing `stripe` and `moon` appearance IDs to the canonical cushion copies. No save migration, reward, stats, or new slot was added.
- Candidate-to-canonical SHA-256 equality is checked for all seven files. Player/pet sources are transparent cutouts; cushion sources are opaque full-bleed textures.
- `test_identity_visual_contract.gd`, `test_runtime_image_asset_contract.gd`, and `test_runtime_capture_guard_contract.gd` pass after the rebind. The identity contract verifies the selected scene card's actual texture path, not catalog text alone.
- OpenGL 3.3 GPU capture `tests/capture_approved_alternate_chibi_family.gd` recorded `a+cat+stripe`, `b+rabbit+moon`, and `a+otter+stripe` at 540×960 in `docs/evidence/2026-08-31-approved-alternate-chibi-family/`.

## 7. machine-only shutdown-audio receipt

`RestingSoundscape` generates and plays its authored ocean bed only when a real display server is present. Headless machine checks keep the persistent `OceanBed` owner but do not allocate a silent generated `AudioStreamWAV`; normal runtime exit also explicitly stops playback and releases the generated stream. This is a test/runtime resource-lifecycle boundary, not a change to player-facing sound design.

`test_resting_core_contract.gd` covers the headless non-playback boundary and explicit release. The minimal `--headless --path . --quit --verbose` smoke exits without the former two `ObjectDB` audio-instance warning. In contrast, the Windows display-server smoke and the 2026-09-01 Bright/spring OpenGL capture both still exit `0` while reporting the same two documented generated-WAV `AudioStreamWAV` / `AudioStreamPlaybackWAV` instances after explicit stream release. The existing minimal display reproduction shows this is an engine/lifecycle baseline rather than seasonal-parallax ownership; it is not a Human audio-comfort or device-shutdown PASS.

## 8. evidence ceiling and remaining review

The renderer evidence proves that the named resources loaded and appeared in controlled frames. It does not prove real-device color, touch reachability, long-session visual fatigue, motion comfort, or sound comfort. Those Human/device checks stay `NOT_RUN` until the user explicitly asks for human validation.
