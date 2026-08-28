# 현재 화면·시각 asset consumer 정본

**역할:** 이 문서는 visual direction, 실제 runtime consumer, asset provenance, 화면별 evidence의 관계를 기록합니다. 사람용 게임 설명은 [프로젝트 GDD](../design/PROJECT_GDD.md), 코드 수준 gap은 [현재 Godot handoff](../handoffs/CURRENT_GODOT_IMPLEMENTATION.md)가 소유합니다.

## 1. authority와 상태를 구분하는 법

| 구분 | owner | 뜻 |
| --- | --- | --- |
| 제품 방향 | `PROJECT_GDD.md`, approved visual lock | 플레이어가 실제로 보게 되어야 하는 것 |
| runtime consumer | Scene, GDScript, Resource, tests, captures | 현재 main이 실제로 소비하는 것 |
| visual source/provenance | asset binary와 evidence record | 어떤 파일이 어디에서 왔고 어디에 연결됐는지 |
| Human evidence | 실제 사람의 기기/플레이 관찰 | 아름다움·편안함·가독성이 확인됐는지 |

Notion은 historical archive이며 이 문서의 current owner나 destination이 아닙니다. 생성 exploration, direction lock, standalone raster, Godot runtime asset, capture, Human approval은 서로 교환할 수 없습니다.

## 2. 현재 제품 화면과 실제 runtime surface

| screen_id | 제품에서의 의미 | 현재 runtime consumer | 상태 |
| --- | --- | --- | --- |
| `MLB-SCR-001` Direct boat entry | 실행 즉시 떠 있는 보트와 바다를 보여 주는 첫 화면 | 없음. current product target | `CONFIRMED_NOT_IMPLEMENTED` |
| `MLB-SCR-001-LEGACY` 선택형 main menu | identity/time/mood를 고른 뒤 출발하던 이전 slice | `scenes/main_menu.tscn`, `scripts/ui/main_menu.gd`, four menu captures | `SUPERSEDED_RUNTIME_SLICE` |
| `MLB-OVR-002-LEGACY` 시작 identity/light/mood selection | 시작 전에 외형·동반자·빛·마음을 묻던 이전 overlay | `IdentityPanel`, `TimeOfDayOption`, mood buttons | `SUPERSEDED_RUNTIME_SLICE` |
| `MLB-SCR-003` Normal voyage diorama | 캐릭터·동반자·보트·바다를 함께 보는 core surface | `scenes/game.tscn`, `scenes/boat_space.tscn`, `scripts/voyage/game_scene.gd` | `PARTIAL_IMPLEMENTED` |
| `MLB-OVR-004` Appreciation Camera | UI를 줄이고 수평선을 보는 선택형 감상 | current camera rig/controller | earlier slice `IMPLEMENTED`; Human comfort `NOT_RUN` |
| `MLB-OVR-005` 꾸미기 | arrival 뒤 원할 때 cosmetic change | current decor panel과 local cosmetic storage | `PARTIAL_IMPLEMENTED`; entry relocation 필요 |
| `MLB-OVR-006/007` 상호작용·낚시 | 원할 때만 쓰는 작은 행동 | current game UI/session | `PARTIAL_IMPLEMENTED` |
| `MLB-OVR-008` Ambient Discovery | passive local memory | legacy action-gated offer | `PRODUCT_SUPERSEDED_IMPLEMENTATION` |
| `MLB-SCR-010` Album | 실제 개인 기록을 보는 archive | `scenes/album.tscn`, album UI | `PARTIAL_IMPLEMENTED` |

## 3. 확정 visual grammar

| layer | Keep | Avoid |
| --- | --- | --- |
| 전체 | `HANDPAINTED_STORYBOOK_3D_DIORAMA`, 넓은 바다·하늘, 안정된 수평선, soft matte/painterly material | glossy photoreal CG, noisy micro-detail, 다른 게임의 trade dress |
| 캐릭터·동반자 | `SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT`, 둥근 silhouette, 큰 hair mass, 절제된 셀 명암 | 큰 유리눈, glamour fashion, 실제 유아화, generic AI doll feel |
| 보트·소품 | 생활감 있는 넓은 painted value, 바다를 가리지 않는 제한된 decor | 과밀 장식, stats/rarity visual language |
| 바다·빛 | 느린 water motion, 낮거나 중간인 대비, `INDIGO_RAIN_REFLECTION` night | 강한 점멸, 과한 bloom, 위협적인 날씨 spectacle |
| camera/UI | 3/4 diorama와 low-UI Appreciation parity, 기능 대비를 지키는 UI | 큰 panel이 first view를 가리는 구성 |

기본 character/companion anchor는 C loose-knit/long hair + dog입니다. 이는 다른 cosmetic pair를 제거하는 결정이 아니며, 각 pair가 power difference를 가져서도 안 됩니다.

## 4. `VIS-ENTRY-001` main-entry disposition

`VIS-ENTRY-001`은 사용자가 2026-08-28에 거부한 구형 vertical main-entry composition입니다. 상단 보트 이미지와 하단 translucent selection panel을 함께 사용하고 identity, light, mood를 시작 전에 묻습니다.

| 항목 | disposition |
| --- | --- |
| 상태 | `REJECTED_FOR_MAIN_ENTRY_RUNTIME_USE` |
| 문제 | 보트와 waterline의 접점, local wave/wake, 반사 또는 가림이 약해 보트가 물 위에 붙여진 것처럼 보인다. 큰 선택 panel도 sea-first first impression을 밀어낸다. |
| 금지하는 consumer | startup screen, direct-entry reference, 새 메인 화면의 기본 구도 |
| 금지하지 않는 것 | 개별 boat/sea/background source binary의 자동 삭제·폐기·재생성 |
| future acceptance | 540 x 960 runtime capture에서 boat-water contact, coherent bob, wave/wake 또는 reflection/occlusion, avatar/pet/boat/sea/horizon hierarchy, panel-free first view를 함께 확인 |

## 5. asset family와 consumer 상태

| asset family | 현재 consumer | 상태 | Issue #99 이후의 해석 |
| --- | --- | --- | --- |
| C+dog diorama binary | legacy `DioramaAnchor`, current normal voyage context | `RUNTIME_CONSUMED` | new direct-entry visual approval이 아님. consumer audit 전 유지 |
| four menu atmosphere backgrounds | legacy `AtmosphereBackground`, album background reuse | `RUNTIME_CONSUMED` | new direct-entry composition의 approved art가 아님. existing provenance 유지 |
| normal boat/sea/identity visuals | normal/appreciation runtime route | `RUNTIME_CONSUMED` | visual lock과 완전 alignment는 별도 production/consumer scope |
| cushion/postcard decor | current decor slots | `RUNTIME_CONSUMED` | cosmetic self-expression evidence. direct entry와 무관 |
| generated boards/comparisons | planning visual documents | `GENERATED_EXPLORATION` 또는 `APPROVED_DIRECTION` | standalone runtime asset, implementation, Human usability proof가 아님 |

새 asset family, UI icon pack, portrait filler, fake album image, production image batch는 Issue #99의 범위가 아닙니다.

## 6. 다음 direct-entry visual contract가 검증할 것

1. 새 local state에서 first frame이 `bright` normal boat diorama인지.
2. mood selector와 pre-entry identity/pet/time UI가 보이지 않는지.
3. 보트가 바다에 뜬다는 관계가 540 x 960에서 실제로 읽히는지.
4. character, companion, boat, sea, horizon, optional UI의 정보 위계가 approved grammar와 맞는지.
5. `꾸미기` entry가 optional이고 cosmetic only인지.
6. generated source, approved direction, Godot consumer, runtime capture, Human comfort evidence가 각각 올바른 owner에 기록됐는지.

이 contract는 새 consumer가 정해지고 Phase 2 구현 계획이 승인된 뒤에만 시작합니다.

## 7. Issue #99 correction receipt

| finding | correction | evidence ceiling |
| --- | --- | --- |
| previous inventory가 startup selection을 current target build로 기록 | direct product screen과 legacy runtime slice를 별도 rows로 분리 | direct entry `NOT_IMPLEMENTED` |
| previous inventory가 Notion을 current visual destination으로 기록 | repository owner 구조로 교체 | historical archive는 current destination 아님 |
| menu assets/captures가 current product approval처럼 읽힐 위험 | asset consumer와 product direction을 분리하고 `VIS-ENTRY-001`을 명시 | source binary 보존, new direct-entry approval 없음 |
| generated visual과 runtime proof 경계가 흐려질 위험 | evidence types를 section 1과 5에 명시 | Human comfort `NOT_RUN` |

Issue #99의 최종 clean review 결과는 handoff의 adversarial receipt와 Draft PR exact-head validation에서 확인합니다.
