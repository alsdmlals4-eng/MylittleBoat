# 현재 화면·시각 asset consumer 정본

**복구 상태:** `REBUILT_FROM_CURRENT_RUNTIME_2026-08-31`

**역할:** 이 문서는 visual direction, 실제 runtime consumer, asset provenance, 화면별 evidence의 관계를 기록합니다. 사람용 게임 설명은 [프로젝트 GDD](../design/PROJECT_GDD.md)가, 코드 수준 상태는 [현재 Godot handoff](../handoffs/CURRENT_GODOT_IMPLEMENTATION.md)가 소유합니다.

## 섬 플레이 시각 제작 후보 — 2026-09-20

`MLB-ISLAND-SLICE-01 / VISUAL_REQUIREMENTS_PLANNED / NO_NEW_ASSET_CREATED`

현재 방향은 [GDD 첫 섬 설계 후보](../design/PROJECT_GDD.md#첫-섬-플레이-설계-후보--2026-09-20)의 일본 청춘 애니메이션풍 작은 섬이다. 아래 §1 이후의 chibi/storybook grammar와 승인표는 **구형 보트의 보존 기록**이다. 새 섬 캐릭터·비율·팔레트·카메라·자산 lock이 아니며 이 후보 작성으로 기존 승인을 취소하지 않는다.

GDD가 행동/성장/입력/시간과 후보 수치를, 이 절은 자산 상태군·제작 순서·소비 규격을 소유한다. 계획 경로와 ID는 전부 `PLANNED`이며 생성·승인·등록·구현·실행 검증은 없다. 새 bitmap이나 3D 자산을 이번 작업에서 제작하지 않았다.

| 계획 ID | 실제 예정 사용처 | 최소 상태/분리 구조 | 제작·검증 계약 |
| --- | --- | --- | --- |
| IV01 섬 지형 | `scenes/island/island_slice.tscn`의 IslandTerrain | 보행면/해안 경계/돌/밭/감상 장소 분리 | Blender source→GLB→Godot wrapper. 미터 단위, +Y up 최종 확인, origin/scale 적용, 보행 충돌은 단순 별도 mesh. 밭·휴식 동선과 카메라 시야를 우선 |
| IV02 하늘·원경 | 같은 Scene의 SkyLayer/DistantLand | 하늘/구름/원경 육지 별도. 시점 안에서 수평선 일관 | 하늘은 불투명 texture/sky material, 구름 cutout 필요 시 크로마키→RGBA. 바다를 배경에 굽지 않음. 임시 원본 해상도보다 실제 crop/시야 범위를 먼저 lock |
| IV03 바다·해안 | 같은 Scene의 SeaSurface/Shore | 독립 수면 mesh/material, 해안 접촉 표시 | world 기준 UV/normal, 잔잔한 반사·움직임. 물 밑 전체 시뮬레이션/동적 파도 물리는 첫 Slice 제외. 수면과 땅의 틈·교차·과한 bloom·저감/정지 설정 검사 |
| IV04 플레이어·도구 | `island_player.gd`의 CharacterBody3D 아래 CharacterVisual | idle/walk/plant/care/harvest/rest_enter/rest_idle/rest_exit와 물뿌리개 socket | 새 비율 후보 1개 먼저 검토. 회전 가능한 rigged 3D 권장, 발바닥 기준 origin, in-place locomotion. 카메라 뒷/옆/농사 크기에서 얼굴·손·발/도구 정합. 2D 합성 후면 한 장으로 대체하지 않음 |
| IV05 두 작물·밭 | `crop_plot.tscn`의 PlantVisual/SoilVisual | EMPTY soil 공용, 두 종의 seedling/young/mature, cared 표식, tomato 지지대 | phase/cared는 state에서 읽음. 메시 swap 또는 material 상태를 선택하고 규칙은 넣지 않음. 색뿐 아니라 실루엣/짧은 상태 문구로 구분. 뿌리 pivot 통일 |
| IV06 휴식 장소·바구니 | island_slice의 RestSpot/HarvestBasket | 앉기 접점, 바구니 empty/radish/tomato | 마지막 수확 종류만 표시. 보상 화폐/희귀도 표시 없음. 손·도구·의자 관통과 REST 카메라에서 내 밭/바구니 일부의 가독성 확인 |
| IV07 UI·피드백·음향 | island_scene의 CanvasLayer/동작 이벤트 | 대상/가용·불가 이유/선택/확정/실패/복구/메뉴, OceanBed+짧은 행동음 | 한글은 텍스처에 굽지 않음. 540×960 기준 긴 문구·소리 0·모션 저감에서도 결과 구분. 입력 효과와 저장 성공을 구분 |

**자산 생산 초기 예산은 측정 전 가설**이다. 캐릭터 색 texture 1024² 한 장에서 시작하고 식물/소품은 512² atlas 후보로 묶되, UV bleed 여백·mipmap·texture filter를 실제 카메라 거리에서 검사한다. 이 크기는 최종 모바일 메모리 합격선이 아니다. 동일 상태군은 scale/pivot/광원/명암 단계를 통일한다. 불필요한 normal/metallic texture와 여러 투명 겹침은 추가하지 않는다. 재질 조절은 Godot wrapper의 공용 material에서 시작해 Blender 복잡 node tree 자동 이식을 전제하지 않는다.

**제작 순서**는 공간/카메라 설계 후보 검토 → 섬·캐릭터·밭·바다를 함께 볼 art-direction 후보 한 개 → 사용자 `LOCK / REVISE / REJECT` → 승인 상태군을 실제 GLB/texture/clip로 연결 → 같은 구도와 감상 시점에서 runtime 비교다. 후보 한 장의 승인이 만들어지지 않은 다른 자산군까지 자동 승인하지 않는다. 이미지가 필요한 독립 요소는 단색 크로마키 원본/프롬프트/제거 설정/RGBA/hash를 보존한다. sky·sea 같은 불투명 texture에는 불필요하게 배경 제거를 적용하지 않는다. Blender mesh/rig는 raster 배경 제거 규칙의 대상이 아니다.

자산 manifest에는 원본·파생 GLB/PNG·export 설정·hash·계획 ID·실제 Scene/Node·필요 상태·fallback을 기록한다. missing 승인 자산은 내부 기술 시험에서만 명시적 placeholder로 표시하고 최종 Slice/art PASS를 막는다. `.blend` 직접 자동 import는 전역 설정/CI Blender 의존을 늘리므로 이번 후보에서는 명시적 GLB export를 권장한다. source 파일은 재현 가능한 보존 위치에 두며 자동 importer가 불필요한 backup을 읽지 않도록 한다.

**현재 근거의 상한**은 2026-09-20 합성 큐브의 Blender→GLB→Godot 왕복뿐이다. 새 캐릭터 리그·재질·식물·수면·최종 조합·기기 성능은 `NOT_RUN`. static art 승인, animation 연결, runtime 캡처, 사람의 편안함은 각각 별도로 기록한다.

## 1. authority와 evidence를 구분하는 법

| 구분 | owner | 뜻 |
| --- | --- | --- |
| 제품 방향 | `PROJECT_GDD.md`, 사용자가 승인한 visual decision | 플레이어가 실제로 보게 되어야 하는 것 |
| runtime consumer | Scene, GDScript, Resource, tests, captures | 현재 game이 실제로 소비하는 것 |
| visual source/provenance | asset binary, SHA-256, 이 inventory | 어떤 파일이 어디에서 왔고 어디에 연결됐는지 |
| Human evidence | 실제 사람의 기기·플레이 관찰 | 아름다움·편안함·가독성이 확인됐는지 |

Notion은 historical archive이며 이 문서의 current owner가 아닙니다. 생성 exploration, 사용자 승인, canonical copy, Godot runtime asset, renderer capture, Human/device evidence는 서로 교환할 수 없습니다.

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
| `MLB-SCR-001` Direct boat entry | 실행 즉시 떠 있는 보트·동반자·바다를 보는 첫 장면 | `project.godot` → `scenes/game.tscn` | `IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| `MLB-SCR-003` Normal voyage diorama | character, companion, boat, sea와 낮은 밀도의 풍경을 함께 보는 core surface | `game.tscn`, `boat_space.tscn`, `game_scene.gd` | `IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| `MLB-OVR-004` Appreciation Camera | UI를 줄이고 수평선에 집중하는 선택 화면 | `AppreciationCameraRig`, `GameScene` | `IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| `MLB-OVR-005` 꾸미기 | arrival 뒤 원할 때 local cosmetic state를 바꾸는 surface | DecorPanel, `DecorPreview`, identity/decor local storage | `IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human readability/touch `NOT_RUN` |
| `MLB-SCR-010` Album | 실제 사진·기억·함께한 시간을 보는 archive | `scenes/album.tscn`, `AlbumView` | `PARTIAL_IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human readability `NOT_RUN` |
| `MLB-SCR-001-LEGACY` main menu | 시작 전 identity/time/mood selection의 이전 slice | `main_menu.tscn`, `main_menu.gd` | `SUPERSEDED_RUNTIME_SLICE`, current entry가 아님 |

## 4. 기본 Normal과 Look Around asset 경계

| asset id | canonical consumer | state |
| --- | --- | --- |
| `MLB-LOOK-CHIBI-NORMAL-REAR-001`과 derived matte | default C+dog `BoatSpace/FinalDioramaCard`의 explicit chroma shader | `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human/device comfort `NOT_RUN` |
| `MLB-LOOK-CHIBI-TRN-001..004` | `LookAroundPresentationRouter`의 port/starboard/aft/overhead exact routing | `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human motion comfort `NOT_RUN` |
| `MLB-AMB-MOTIF-001..006` | current local-time bucket의 temporary `SeaBackdrop` | `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human long-run observation `NOT_RUN` |

`FinalDioramaCard`는 기본 C+강아지 route에서만 사용한다. alternate pair는 동일한 `BoatSpace`의 layered `Sprite3D` route를 사용한다. 이 차이는 save 의미·voyage 시간·reward·soundscape를 바꾸지 않는다.

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

`test_resting_core_contract.gd` covers the headless non-playback boundary and explicit release. The minimal `--headless --path . --quit --verbose` smoke now exits without the former two `ObjectDB` audio-instance warning. OpenGL runtime capture also exits without that warning. Human audio comfort remains `NOT_RUN`.

## 8. evidence ceiling and remaining review

The renderer evidence proves that the named resources loaded and appeared in controlled frames. It does not prove real-device color, touch reachability, long-session visual fatigue, motion comfort, or sound comfort. Those Human/device checks stay `NOT_RUN` until the user explicitly asks for human validation.
