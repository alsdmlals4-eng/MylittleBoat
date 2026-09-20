# 마이 리틀 보트 기획서

**현재 상태:** `CURRENT_HUMAN_FACING_GDD`
**갱신일:** 2026-09-20
**읽는 법:** 이 문서는 사람이 게임의 경험과 결정 상태를 이해하기 위한 정본입니다. 실제 코드·Scene·테스트·캡처는 [현재 Godot handoff](../handoffs/CURRENT_GODOT_IMPLEMENTATION.md)가, visual consumer와 provenance는 [visual inventory](../visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md)가 소유합니다.

## 현재 결정 — 작은 섬 농장과 바다 감상

`MLB-DIRECTION-20260916 / USER_APPROVED_DIRECTION / ISLAND_RUNTIME_NOT_IMPLEMENTED`

사용자가 확정한 방향은 **작은 섬에서 농장을 돌보고 바다를 바라보며 쉬는 게임**, **일본 청춘 애니메이션풍**이다. 보트 전진감 추가 개발은 중단한다. 이름은 `my little boat`로 유지한다. 농사 행동·성장 시간·진행 구조·카메라·캐릭터 비율·최종 아트는 아직 확정하지 않았다. 의무 일과·작물 고사·경쟁·전투·유료 압박을 임의로 추가하지 않는다.

기존 보트 구현·승인 자산·세이브 ID·실행 증거는 보존한다. 아래 §0–§8의 항해 흐름·치비 lock·구현 표는 **구형 보트 버전의 보존 기록**이며 새 섬 게임의 명세/완료 근거가 아니다. 구형 브랜치 `codex/title-boat-flow-20260831`의 후속 구현도 자동 통합하지 않는다. local 저장·사진/앨범·감상·바다 소리는 재사용 후보이며, 동반자·낚시·편지는 새 필수 기능으로 확정하지 않았다.

### 재미·표현 검증 기준

`MLB-FUN-20260920 / METHOD_ADOPTED / EXPERIENCE_HYPOTHESES_UNVERIFIED`

방법의 출처는 [Base 재미 검증 생명주기](https://github.com/alsdmlals4-eng/Base/blob/23ecad5a3084f97c4e5d1e39a9a6d70d1eeb37ef/skills/analyzing-and-refining-game-concepts/references/concept-evidence-and-gates.md#fun-verification-lifecycle)와 [경험→효과·비주얼·UI 가이드](https://github.com/alsdmlals4-eng/Base/blob/23ecad5a3084f97c4e5d1e39a9a6d70d1eeb37ef/docs/knowledge/game-development/EXPERIENCE_TO_PRESENTATION_GUIDE.md)다. 프로젝트 의미의 원본은 위 `MLB-DIRECTION-20260916`이며 채택/재조회 경계는 `docs/operations/MY_LITTLE_BOAT_BASE_ADAPTER.json`이 소유한다. Base의 방어/전투 예시와 고정 재미 점수는 채택하지 않는다.

**핵심 경험**은 선택적인 농장 돌보기와 바다 감상이다. 부담 없이 머무는 느낌, 돌본 결과에 대한 작은 애착은 검증할 경험 가설이지 이미 입증된 재미가 아니다. 대상 플레이어는 잠시 쉬고 싶은 사람이라는 기획 가설이며 연령·세션 길이·기기별 선호는 연구 전 미확정이다. 사진/표현/소리 같은 보조 경험은 실제 섬 consumer의 필요가 확인될 때만 재사용한다.

| requirement ID | 경험 가설과 방향 | 대표 구간·반증 질문 | 실제 구현/증거 연결과 현재 상태 |
| --- | --- | --- | --- |
| MLB-ISLAND-REST-01 | `AMPLIFY / HYPOTHESIS`. 농사 행동을 하지 않아도 바다를 보며 편안하게 머물 수 있다. | 작은 농장과 바다를 함께 보는 구간에서 쉬기만 선택한다. 알림·의무·자동 카메라 때문에 일을 해야 한다고 느끼거나 움직임/소리가 피곤하면 반증이다. | 새 섬 Scene·camera·입력은 `PLANNED`. 기존 `scenes/game.tscn`과 `scripts/voyage/game_scene.gd`의 감상/comfort, `scripts/audio/resting_soundscape.gd`는 재사용 검토 대상일 뿐. 섬 MACHINE/RUNTIME/HUMAN은 `NOT_RUN`. |
| MLB-ISLAND-CARE-01 | `AMPLIFY / HYPOTHESIS`. 짧은 돌보기 행동과 눈에 보이는 결과가 내 작은 장소에 대한 애착을 만든다. | 승인 후 대표 돌보기 한 번→결과 확인→바다 휴식 복귀를 완성형 짧은 구간으로 본다. 무엇이 바뀌었는지 모르거나 반복 노동/손실 회피로만 행동하면 반증이다. | crop state owner·성장 규칙·저장·입력/취소는 `PLANNED`. 담당 owner는 이 GDD, 다음 행동은 농장 루프/카메라 대안 조사와 bounded spec 승인. 미정 수치에 의존하는 농사 구현만 보류한다. |
| MLB-ISLAND-PRESENT-01 | `SUPPORT / HYPOTHESIS`. 일본 청춘 애니 분위기 안에서도 대상·선택·확정 결과가 구별되고, 표현이 휴식을 방해하지 않는다. | 같은 구간의 기본/저감 모션·음소거·작은 화면·반복 입력/복귀를 대조한다. 예쁘지만 대상을 못 찾거나 성공처럼 보였는데 결과/저장이 다르면 반증이다. | 시각 owner는 `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md`; 새 섬 asset/state family는 `PLANNED`. 구형 승인 자산은 자동 재승인되지 않는다. 새 아트/사용성/재미는 `NOT_RUN`. |

기능 기획부터 교정까지 같은 ID를 유지한다.

1. **기획.** 승인 경험 원본과 가설·반증·보호 범위를 연결한다. 작은 L1은 기존 Decision/handoff 한 단락, 주요 L2만 필요한 상세 명세를 사용한다.
2. **설계.** 입력·진입/종료 상태·규칙/state owner·선택·공개할 정보·취소/복귀·저장/실패를 정한다. 효과/모션/UI는 접수와 확정 결과를 구분하고 실제 결과를 표시만 한다. 반복/중단/동시 효과·reduced motion·mute에서 필수 정보가 남는지 명시한다. 값은 프로젝트 초기값/계산식·조정 범위·검증 장면으로 정하며 미정은 담당 owner와 의존 작업을 남긴다.
3. **구현.** ID→실제 Scene/Node/Script/데이터/자산→검사를 연결하고, 화면/검사에서 ID와 승인 원본으로 역추적한다. 경로가 존재해도 실제로 호출/표시되지 않으면 연결 완료가 아니다. `PLANNED` 경로를 구현으로 세지 않는다.
4. **검증.** exact commit/build·환경·설정·입력·대표 구간·관찰 질문·중단 기준을 먼저 기록한다. MACHINE은 상태/저장/중단·복귀, RUNTIME은 실제 표시/모션/입력, HUMAN은 행동 관찰·자기보고·반증을 대조한다. 오래 플레이함=재미, 로그 PASS=편안함으로 해석하지 않는다.
5. **교정.** 못 봄/오해함, 규칙·선택 문제, 표현·감각 문제, 반복 피로, 빌드/환경 결함을 구분한다. 같은 승인 범위는 최소 수정·회귀 후 `KEEP / CHANGE / DEFER / RETEST`로 기존 기록에 남긴다. 경험·아트 방향·주요 UX·비용/범위 변경만 재승인한다.

검증할 개발 결정은 “짧은 돌보기와 휴식이 양립하는가, 다음 제작으로 확대할 근거가 있는가”다. 성공은 의도한 결과를 이해하며 쉬기를 자유롭게 선택하는 관찰과 자기보고가 뒷받침되는 경우, 반박은 강제 노동/손실 회피·혼란·감각 피로가 드러나는 경우다. 저장 손상·조작 불능·불편 호소 시 해당 세션을 중단한다. 표본/시간/점수 합격선을 임의로 만들지 않으며 실제 사람 세션 전에 질문·대상·범위를 확정한다.

`DOC / MACHINE / RUNTIME / HUMAN / USER_APPROVAL / RELEASE`는 별개다. 사람 검증은 사용자가 선언할 때만 수행하고, 미실행은 `NOT_RUN`으로 둔다. 승인된 구현은 계속할 수 있지만 자동 검사나 AI 평가를 `FUN_PASS`로 승격하지 않는다. 회색 상자나 Blender 연결 시험은 기술 확인일 뿐 재미 증거가 아니다. 사람 검증은 전체 게임 완성을 기다리지 않고 필요한 아트·소리·UI가 연결된 짧은 대표 Slice로 준비한다. 새로운 감독 skill·분석 서버·중복 재미 보고서는 만들지 않는다.

## 보존된 구형 보트 기획과 실행 증거

이하 “현재”라는 표현은 해당 과거 receipt의 시점이다. 2026-09-20 실제 main의 복구/검사 상태와 다음 작업은 [최신 handoff](../handoffs/CURRENT_GODOT_IMPLEMENTATION.md)를 우선한다.

## 0. 2026-08-30 현재 runtime receipt

아래 상태는 2026-08-30 보트 실행 build의 기록입니다. 이후의 pre-implementation 표와 `NOT_IMPLEMENTED` 표기는 historical context로만 읽고 이 receipt를 덮어쓰지 않습니다.

| 주제 | 현재 상태 | evidence ceiling |
| --- | --- | --- |
| Direct boat entry | 실행 즉시 사용자 승인 후면 3/4 치비 player·강아지·ivory/deep-teal 보트·바다 구도와 compact `쉬는 메뉴`가 보입니다. 플레이어는 stern 쪽에 기대어 뒷모습으로, 강아지는 옆에서 함께 쉬는 모습으로 읽힙니다. `MLB-LOOK-CHIBI-NORMAL-REAR-001`의 보관 원본에서 만든 foreground matte를 `FinalDioramaCard`의 explicit shader material에 연결해, 보트 bob·water-contact·시간대 backdrop을 분리한 채 stern-side normal 3/4를 보입니다. 저장된 `꽃` 펫 쿠션만 bow-side overlay로 보입니다. `엽서`는 main rest composite에 합성하지 않고 꾸미기 preview 난간 장식과 Album의 항해 포스트카드에서 읽습니다. | rear-normal/material/final-card/direct-entry/decor contracts와 bright·night 540×960 GPU capture `PASS`; Human comfort `NOT_RUN` |
| 현지 시간과 풍경 | 현지 시간은 visual-only 네 분위기를 정하고, foreground에 머문 시간만 low-density 자연 명소 기회를 보냅니다. 새벽 아치·해초 모래톱·흰 절벽·사암 코브·갈대섬·밤 생물발광은 각 시간대에만 조용히 지나가며, 첫 기회는 90–150초, 기회별 표시는 65%, 다음 기회는 표시 여부와 무관하게 120–180초입니다. | 47 contracts와 여섯 540×960 GPU capture `PASS`; Human long-run observation `NOT_RUN` |
| 꾸미기 | `꾸미기`에서 플레이어 외형, 동반자 종류, 보트 장식을 local-only로 고르고, 별도 보트 preview에서 즉시 확인합니다. 기본 first-view backdrop은 바꾸지 않습니다. A/B player, cat/rabbit/otter, `stripe`·`moon` cushion은 승인된 soft-matte 치비 family로 실제 선택 경로에 연결됐습니다. | identity/decor/asset-guard contracts와 alternate family 540×960 GPU capture `PASS`; Human readability `NOT_RUN` |
| 함께한 시간 | foreground 항해의 실제 시간을 local-only로 누적하고 Album에서만 분 단위·관계 문구로 보여 줍니다. | together-time contracts와 540×960 Album capture `PASS`; Human readability `NOT_RUN` |
| 모션 편안함 | `파도: 기본/잔잔/고요`는 보트·카메라·수면 접점의 자동 진폭만 `1.0 / 0.5 / 0.0`으로 바꾸는 local-only 선택입니다. | preference/state/scene contracts와 bright GPU capture `PASS`; Human motion comfort `NOT_RUN` |
| 항해 포스트카드 | `사진`은 UI 없는 실제 렌더 프레임 PNG와 메타데이터를 기기에 저장하고, Album은 최신 세 장을 점수·보상 없이 보여 줍니다. | persistence/state/scene/Album contracts와 bright·Album GPU capture `PASS`; Human readability `NOT_RUN` |
| 둘러보기 | `LookAroundCamera3D`와 드래그 입력, 기본·감상 전환, 꾸미기/Album 격리가 구현되었습니다. 사용자가 승인한 투명 수면 치비 family의 좌·우·뒤·위 원화가 exact canonical asset으로 연결됩니다. non-front에서는 중복 normal card만 숨기고 부유 보트 상태와 수면 접점은 유지합니다. | mode/input contracts와 540×960 GPU capture `PASS`; `MLB-LOOK-CHIBI-TRN-001..004` `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`; Human motion comfort `NOT_RUN` |

## 0. Human Game Blueprint 읽기 profile

`HUMAN_GAME_BLUEPRINT_GDD_LAYERED_PROFILE`

`NO_SEPARATE_BLUEPRINT_ARTIFACT`

이 profile은 새 Blueprint 문서·보드·부록을 만들지 않고 현재 editing master인 이 GDD 안에서 기존 경험·system card·flow·구현 evidence를 계층적으로 읽게 합니다. `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`는 `SUPERSEDED_AS_CURRENT_GDD` 안내 포인터이며 current editing master로 승격하지 않습니다. 이 profile의 역사적 repository baseline은 `main@50909b33bd1d4a4ebc550b5be2a4f9cfe7ccf6d6`입니다.

### 산출물과 publication 경계

`exports/my-little-boat_MASTER_PRODUCTION_GDD_20260829.pdf` = `TRACKED_LATEST_PUBLICATION_SOURCE_BINDING_UNVERIFIED`. tracked latest publication이지만 generator, source SHA, publication receipt가 없으므로 이 GDD의 source-bound current projection이라고 주장하지 않습니다. `exports/my-little-boat_MASTER_PRODUCTION_GDD_20260828.pdf` = `HISTORICAL_DERIVED_NOT_CURRENT_SOURCE`.

`PDF_REISSUE_DEFERRED`: 이번 profile adoption은 두 PDF binary를 수정하거나 새 PDF를 생성하지 않습니다. source-bound generator와 receipt가 설치된 뒤 별도 publication package에서 재발행합니다.

### Layered reader route

| layer | 먼저 답할 질문 | 현재 section |
| --- | --- | --- |
| `PROJECT_PLAYER_LAYER` | 어떤 휴식 경험이며 무엇을 선택하지 않아도 되는가 | §1–§3 |
| `SYSTEM_LAYER` | 머무르기·분위기·풍경·기억이 어떤 flow와 상태로 이어지는가 | §4–§5 |
| `CONTENT_UX_PRESENTATION_LAYER` | 어떤 화면·시각·입력·audio가 경험을 전달하는가 | §5–§6 |
| `PRODUCTION_EVIDENCE_LAYER` | 무엇이 구현됐고 어떤 test/runtime/Human evidence가 남았는가 | §7–§8 및 current handoff/visual inventory |

```text
3-MINUTE PROJECT / PLAYER READ
-> 10-MINUTE SYSTEM + CONTENT / UX / PRESENTATION READ
-> DETAIL READ
-> IMPLEMENTATION READ
-> VERIFICATION READ
```

### 상태와 evidence legend

`STATE_AND_EVIDENCE_LEGEND`

| 상태 | 허용하는 주장 | 허용하지 않는 상위 주장 |
| --- | --- | --- |
| `CONFIRMED` | current GDD·Decision에 제품 방향이 기록됨 | 구현·runtime 동작 |
| `IMPLEMENTED` / `IMPLEMENTED_AND_TESTED` | exact code/Scene/data consumer가 있고 지정 자동 계약이 존재하거나 통과한 receipt가 있음 | 실제 기기 편안함·Human UX |
| `GPU_CAPTURED` | 지정 renderer와 화면 크기에서 화면이 실제 렌더됨 | touch/audio/5분 calmness |
| `PARTIAL_IMPLEMENTED` | 일부 consumer만 존재하고 남은 product alignment가 있음 | system 전체 완료 |
| `CONFIRMED_NOT_IMPLEMENTED` | 제품 방향은 확정됐지만 runtime consumer가 없음 | 구현 시작·완료 |
| `NOT_RUN` | 해당 device/Human/audio evidence가 아직 없음 | 추정에 의한 PASS |

### Prospective future-package gate

`PLAN -> REQUIRED_IMAGE_AND_MATERIAL_PREPARATION -> BLUEPRINT_REVIEW_PUBLICATION -> USER_FINAL_REVIEW_APPROVAL -> IMPLEMENTATION`

`NO_IMPLEMENTATION_BEFORE_USER_FINAL_APPROVAL`: 이 profile 채택 뒤 새 implementation package는 exact reviewed Blueprint revision에 대한 명시적 `USER_FINAL_REVIEW_APPROVAL` 전 시작하지 않습니다. 계획·task breakdown·acceptance는 준비할 수 있지만 implementation execution은 blocked입니다.

`PROSPECTIVE_ONLY_EXISTING_IMPLEMENTATION_EVIDENCE_PRESERVED`: 이미 merge된 code/data/Scene/test와 기존 GPU/runtime evidence는 역사적 사실로 유지되며 이 gate 때문에 취소·하향되지 않습니다.

`PROSPECTIVE_ONLY_PREEXISTING_EXACT_USER_APPROVED_IMPLEMENTATION_AUTHORITY_PRESERVED`: profile 채택 전에 package ID, exact scope, artifact revision/branch/SHA에 연결된 명시적 사용자 구현 승인이 있었다면 그 package의 기존 authority는 유지합니다. `EXACT_APPROVED_SCOPE_AND_REVISION_ONLY`: grandfathering은 승인 기록과 같은 package·scope·revision만 허용합니다. `SCOPE_EXPANSION | SUCCESSOR_PACKAGE | INFERRED_BLANKET_APPROVAL`에는 기존 authority를 재사용할 수 없습니다. PR #19를 포함한 별도 workstream의 authority는 이 profile로 추정하거나 흡수하지 않습니다.

새 image deliverable의 생성·편집은 최신 프로젝트 AGENTS의 승인 경계와 `IMAGE_MODEL_REQUIRED_FOR_IMAGE_CREATION_OR_EDITING`을 따라야 합니다. exact flow/state/system 관계는 `TEXT_NATIVE_EXACT_DIAGRAMS`와 `STRUCTURED_INFORMATION_ARTIFACTS_REMAIN_TEXT_NATIVE`에 따라 Mermaid/Flow/table로 유지합니다. 이미지 생성 성공은 asset 승인·runtime 연결·Human PASS가 아닙니다.

## 1. 이 게임은 무엇인가

`마이 리틀 보트`는 내 캐릭터와 동반자가 바다 위 작은 보트에서 목적지 없이 천천히 지나가며 함께 쉬는 휴식 우선 게임입니다. 플레이어는 목표를 해내기 위해 보트에 오르는 것이 아니라, 게임을 여는 순간 이미 그곳에 있습니다.

### 플레이어 약속

> “게임을 열자마자 내 작은 보트가 동반자와 함께 잔잔한 바다를 목적지 없이 지나가고, 나는 아무것도 하지 않아도 잠시 쉬어 갈 수 있다.”

정상 화면은 보트 뒤쪽 위의 calm 3/4 diorama입니다. 플레이어는 stern 쪽에 기대어 뒷모습으로, 동반자는 바로 옆에서 함께 보이며, 보트·장식·바다와 수평선이 한 장면에 함께 읽힙니다. `Appreciation Camera`는 같은 세계에서 UI를 줄이고 바다·수평선을 더 오래 바라보는 선택적 감상 모드입니다.

### 이 게임이 남기려는 감정

- 편안함과 안정감
- 내 캐릭터·동반자·보트가 만드는 작은 애착
- 혼자 있지만 외롭지 않은 느낌
- 성과보다 개인적인 기억이 남는 느낌

전투, 실패, 경쟁, 등급, 효율, 숙제, 실시간 소셜 압박은 위 감정과 충돌하므로 넣지 않습니다.

## 2. 첫 30초와 시작 흐름

### 확정된 첫 경험

```text
실행
→ 이미 물 위에 떠 있는 보트와 바다를 봄
→ 캐릭터와 동반자가 함께 있는 모습을 봄
→ 그냥 머무르거나, 원할 때만 작은 행동을 선택함
→ 계속 쉬거나 나만의 기억을 남김
```

시작할 때 `오늘의 마음`, 시간대, 외형, 동반자, 장식 중 무엇도 고르게 하지 않습니다. 기기의 **현지 현실 시간**이 새벽·밝음·해질녘·밤 분위기를 자동으로 정합니다. 수동 분위기 control과 마지막 분위기 저장은 없습니다. 기기 시계는 시각 표현에만 쓰며 보상, 항해 진행, 기억 저장, 호감도에는 영향을 주지 않습니다.

외형·동반자·보트 장식은 바다를 본 뒤에만, 원할 때 `꾸미기`에서 바꿉니다. 모든 꾸미기 선택은 cosmetic이며 능력치, 희귀도, 보상, 최적 조합을 만들지 않습니다.

### 첫인상 수용 기준

- 보트 hull과 물의 접점이 읽힌다.
- 느린 bob, 잔물결 또는 wake, 반사·가림이 보트와 바다를 하나의 공간으로 묶는다.
- 캐릭터·동반자·보트는 보이되 수평선과 넓은 바다를 가리지 않는다.
- 큰 선택 panel이 first view를 덮지 않는다.
- 540 x 960 실제 gameplay 크기에서 위 관계가 읽힌다.

현재 제공된 구형 main-entry 구성은 이 기준을 충족하지 않아 `REJECTED_FOR_MAIN_ENTRY_RUNTIME_USE`입니다. 현재 기본 route는 `game.tscn`의 direct boat entry이며, `main_menu.tscn`은 오래된 링크를 이 화면으로 넘기는 호환 경로만 유지합니다. 이 결정은 보트·바다 source binary를 일괄 폐기한다는 뜻이 아닙니다.

## 3. 플레이는 어떻게 이어지는가

### 핵심 반복

```text
바다 위 보트에 머문다
→ 바다와 동반자를 바라본다
→ 원하면 사진·낚시·감상·작은 상호작용·꾸미기를 한다
→ 작은 반응이나 개인적인 기억을 남긴다
→ 계속 머물거나 자연스럽게 떠난다
```

핵심 행동은 “머무르기”입니다. 선택 행동은 정적 화면의 빈틈을 메우는 과제가 아니라, 지금 하고 싶은 만큼만 사용하는 생활감입니다.

### 한 번의 휴식

명목상 한 항해는 약 5분입니다. 기록이 남은 뒤에도 플레이어는 더 머물 수 있습니다. 시간을 끝까지 채우거나 모든 행동을 해야만 완성되는 세션은 아닙니다.

### 남는 기억

사진, 풍경, 낚시 기억, 보트 장식, 함께한 시간, ambient memory는 개인적인 앨범과 보트의 흔적으로 돌아옵니다. 이들은 power, currency, social qualification, collection completion을 위한 재료가 아닙니다.

### 선택과 결과

| 선택 | 플레이어가 고민하는 것 | 관찰 가능한 결과 | 손해가 아닌 것 |
| --- | --- | --- | --- |
| 그냥 머무르기 | 지금은 아무것도 하지 않고 쉬고 싶은가 | 바다·동반자·보트의 조용한 움직임 | 아무 행동도 하지 않는 것 |
| 사진 | 이 순간을 기록하고 싶은가 | 개인 album의 사진 기억 | 사진을 찍지 않는 것 |
| 낚시 | 잠시 기다리는 행동이 어울리는가 | 기다림 뒤 catch, 입질 없는 조용한 거두기, 또는 언제든 취소 | catch가 없거나 중단하는 것 |
| Appreciation Camera | 화면을 덜 보고 바다를 더 볼 것인가 | 낮은 UI의 수평선 감상 | normal view를 유지하는 것 |
| 꾸미기 | 내 공간을 어떤 모습으로 두고 싶은가 | cosmetic appearance 변화 | 장식을 바꾸지 않는 것 |

### 첫 5·15·30분 truth table

`FIRST_5_MINUTES_NOMINAL_SESSION_HYPOTHESIS`: 첫 5분은 반드시 채워야 하는 목표가 아니라 한 번의 명목상 휴식 세션을 설명하는 hypothesis입니다. 실제 기기에서 이 시간이 calm한지는 actual-device calmness `NOT_RUN`입니다.

`FIRST_15_30_MINUTES_CONDITIONAL_OPTIONAL_EXTENDED_STAY_NOT_FORCED_MILESTONES`: 첫 15분과 30분은 플레이어가 스스로 더 머물 때만 생기는 conditional optional extended stay이며 forced onboarding·retention·reward milestone이 아닙니다.

| 시간 | 경험 contract | evidence |
| --- | --- | --- |
| 첫 5분 | 명목상 한 항해에서 머무르거나 원할 때 낮은 압력 행동을 쓰고 자연스럽게 떠날 수 있음 | implementation/automation 일부 존재; actual-device calmness `NOT_RUN` |
| 첫 15분 | 선택적으로 더 머물며 분위기·풍경·개인 기록을 느슨하게 경험할 수 있음 | optional extended-stay hypothesis; Human `NOT_RUN` |
| 첫 30분 | 선택적으로 계속 머물거나 album/꾸미기를 오갈 수 있음 | optional extended-stay hypothesis; Human `NOT_RUN` |

## 4. 시스템 카드

`REUSABLE_FLOW_AND_SYSTEM_CARDS`

기존 system 설명은 아래 공통 card field를 공유합니다. 새 규칙을 복제하지 않고 각 section과 실제 owner를 연결합니다.

| card field | 이 GDD의 표현 |
| --- | --- |
| player purpose | `플레이어가 보고 하는 일`, `필요한 이유` |
| trigger/input + choice/condition | §3 핵심 반복·선택과 결과, §5 화면 flow |
| state/data change | current handoff의 foreground/session/persistence owner |
| output/feedback + failure/recovery | `피드백`, `피해야 할 압박`; 실패 pressure는 N/A |
| content/UX/presentation consumer | §5 화면, §6 visual direction, soundscape requirement |
| implementation owner | `CURRENT_GODOT_IMPLEMENTATION.md`의 exact Scene/script table |
| acceptance/evidence | §7 상태, Blueprint evidence ceiling, tests/captures/Human boundary |

### Core flow card

| flow ID | player purpose | trigger/input | choice/condition | state/data change | output/feedback | owner/evidence |
| --- | --- | --- | --- | --- | --- | --- |
| `FLOW-REST-001` | 보트 위에 바로 도착해 압박 없이 머무름 | app 실행 또는 normal voyage 복귀 | 머무르기·선택 행동·자연스럽게 떠나기 | foreground time과 선택적 local memory만 변화 | calm diorama, atmosphere, 낮은 밀도 풍경 | `game.tscn`, `game_scene.gd`; automated/GPU evidence, Human `NOT_RUN` |

### System traceability cards

`LAYERED_TRACEABILITY_REQUIRED`

| system ID | player contract | exact implementation owner | content/UX/presentation consumer | acceptance/evidence |
| --- | --- | --- | --- | --- |
| `SYS-REST-001` | 아무 입력 없이 머무르기도 complete play | `scenes/game.tscn`, `scenes/boat_space.tscn`, `scripts/voyage/game_scene.gd` | Direct boat entry, normal/appreciation camera, boat-water presentation | direct-entry contracts + 540 x 960 GPU capture; device calmness `NOT_RUN` |
| `SYS-ATMOS-001` | 현실 시간은 시각 분위기만 바꿈 | `scripts/voyage/real_time_atmosphere_resolver.gd`, `scripts/voyage/game_scene.gd` | dawn/bright/sunset/night sea and light | resolver/game contracts + GPU captures; Human transition judgment `NOT_RUN` |
| `SYS-SCENERY-001` | foreground에서 풍경이 낮은 밀도로 지나감 | `scripts/voyage/drift_scenery_director.gd`, `scenes/distant_scenery.tscn` | buoy/islet/lighthouse, auto-fade notice | director/runtime contracts + islet capture; 5-minute frequency `NOT_RUN` |
| `SYS-MEMORY-001` | 일부 풍경이 보상 압박 없는 local memory로 남음 | `scripts/core/ambient_memory_persistence.gd` | Ambient Discovery, Album | persistence/GameState round-trip contracts; noticeability `NOT_RUN` |
| `SYS-RELATIONSHIP-001` | 함께 머문 시간이 조용한 관계 문구로 남음 | runtime owner 없음 | future Album relationship copy | `CONFIRMED_NOT_IMPLEMENTED` |

### 떠 있는 휴식

**플레이어가 보고 하는 일.** 캐릭터와 동반자가 탄 보트가 잔잔한 바다를 목적지 없이 천천히 지나가는 모습을 보고, 원하면 아무 입력 없이 머뭅니다.

**필요한 이유.** 이 게임의 핵심 재미는 보상 전 대기 시간이 아니라 함께 존재하는 장소를 보는 데 있습니다.

**피드백.** 보트의 느린 전진과 bob, 바다·하늘의 변화, 동반자의 낮은 빈도 idle, 파도 중심 soundscape가 “함께 흘러가고 있다”는 감각을 줍니다.

현지 시간이 바뀌면 하늘·빛·바다의 색과 반사가 천천히 이어집니다. active foreground로 머문 시간이 쌓이면 새벽의 바다 아치, 밝은 낮의 해초 또는 절벽, 해질녘의 사암 코브 또는 갈대섬, 밤의 먼 생물발광처럼 한 장면이 낮은 밀도로 흘러갑니다. 이 장면은 10초 뒤 현재 시간대의 물만 있는 기본 바다로 돌아오며, 버튼·목적지·보상·과제가 아닙니다. 둘 다 해야 할 일이나 보상이 아니라, 같은 장소가 살아 있다는 배경 감각입니다.

**피해야 할 압박.** 방치 벌, timer 실패, idle 보상, 매분 확인 요구, 목적지·항로·도착 보상.

**상태.** 자연 명소 여섯 장은 `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`입니다. 실제 기기에서의 휴식감은 `NOT_RUN`입니다.

### 감상 카메라

**플레이어가 보고 하는 일.** 필요할 때 UI를 줄이고 바다와 수평선에 집중합니다.

**필요한 이유.** 캐릭터와 보트를 보는 휴식과 바다만 보는 휴식은 서로 다른 순간에 필요합니다.

**피드백.** 같은 항해 시간과 soundscape 안에서 시야만 조용해집니다.

**피해야 할 압박.** 보상, timer, 동반자 관계, ambient discovery 확률을 바꾸는 별도 게임 모드.

**상태.** earlier runtime slice에 존재합니다. 실제 기기에서의 편안함은 `NOT_RUN`입니다.

### 둘러보기

**플레이어가 보고 하는 일.** 원할 때 보트 주변을 천천히 드래그해 좌우·뒤·위 시점을 바라봅니다. 마음에 드는 곳에서 멈춰도 되고, 기본 3/4 시점이나 감상 카메라로 언제든 돌아갈 수 있습니다.

**필요한 이유.** 같은 보트 안의 사람·동반자·랜턴·물결을 다른 거리와 각도에서 보는 작은 변화가, 목적지 없이도 살아 있는 항해 감각을 더 분명하게 합니다.

**피드백.** 카메라만 바뀌며 항해 시간, 속도, 함께한 시간, 장식, 사진·풍경·낚시 기억, 저장, soundscape는 바뀌지 않습니다. 화면은 PC의 왼쪽 버튼 드래그와 모바일 화면 드래그를 쓰고, 수평선은 기울지 않으며 큰 자동 회전·줌·번쩍임은 없습니다.

**피해야 할 압박.** 특정 시점을 모두 찾아야 하는 수집, 각도별 보상, 생물 추적, 목표표식, 이동 강요, 멀미를 유발하는 관성·강제 카메라.

**상태.** 입력·mode 격리, 승인된 `port`·`starboard`·`aft`·`overhead` canonical asset routing, 기본 Normal의 후면 치비 foreground material, 저장된 `꽃` 펫 쿠션·`엽서`의 치비 decor consumer, 그리고 normal·네 각도·Appreciation의 540×960 GPU capture가 `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`입니다. 이 상태는 항해 시간·속도·저장·보상·soundscape를 바꾸지 않습니다. 기본 C+강아지 Normal은 `MLB-LOOK-CHIBI-NORMAL-REAR-001` 보관 원본에서 만든 `MLB-LOOK-CHIBI-NORMAL-REAR-MATTE-001`를 `FinalDioramaCard`에 연결하고 stern-side rig에서 보여 주며, water-only backdrop과 BoatSpace 부유를 유지합니다. 사용자가 승인한 alternate A/B player, cat/rabbit/otter, `stripe`·`moon` cushion 7종은 exact canonical copy와 기존 save ID를 사용해 layered `Sprite3D`와 decor texture consumer에 연결됐습니다. 실제 기기의 motion comfort, touch reachability, 장시간 휴식감은 `NOT_RUN`입니다.

### 꾸미기

**플레이어가 보고 하는 일.** 도착 뒤 원할 때 외형, 동반자 species, 보트 장식을 바꿉니다.

**필요한 이유.** 공간이 “게임의 배경”이 아니라 “내 작은 장소”로 느껴지게 합니다.

**피드백.** 기본 바다 화면을 바꾸지 않는 별도 보트 preview에서 바뀐 외형·동반자·장식이 즉시 보입니다.

**피해야 할 압박.** stats, rarity, gacha, price, daily shop, 모든 slot 채우기, 최적 배치.

**상태.** in-voyage `꾸미기`, local-only preview, 기존 ID를 보존한 alternate 치비 asset family가 `IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_CAPTURE_VERIFIED`입니다. 실제 기기에서의 readability와 touch comfort는 `NOT_RUN`입니다.

### 사진·조용한 낚시·작은 상호작용

**플레이어가 보고 하는 일.** 지금의 풍경을 찍고, 조용히 기다리거나, 보트의 작은 물건·동반자와 가볍게 반응합니다.

**필요한 이유.** 가만히 쉬기와 별개로 손을 조금 쓰고 싶은 플레이어에게 낮은 밀도의 생활감을 줍니다.

**피드백.** 사진은 UI 없는 실제 항해 프레임을 local PNG와 메타데이터로 남기고, Album의 최신 세 장 포스트카드로 돌아옵니다. catch만 물고기 기억으로 남고, 입질 없는 거두기·취소·작은 상호작용은 짧은 문구와 작은 pose만 남기며 저장·보상·함께한 시간을 만들지 않습니다.

**피해야 할 압박.** 반복 탭, 확률 보상 farming, 실패 패널티, 행동 횟수에 따른 동반자 보상.

**상태.** 사진의 local PNG 저장·메타데이터 복원·UI 복구·Album 최근 세 장 표시는 `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`입니다. 낚시는 `catch → 저장`, `무수확 → 조용한 거두기`, `기다림 → 취소`를 모두 손해 없이 처리하고, 상호작용은 동반자의 `나란히 쉬기`와 난간의 `파도 소리 듣기`를 포함합니다. focused 계약과 540×960 OpenGL capture가 `IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_CAPTURE_VERIFIED`입니다. 실제 기기에서 사진·앨범·새 문구의 가독성이 편안한지는 `NOT_RUN`입니다.

### 함께 보낸 시간

**플레이어가 보고 하는 일.** 동반자와 active foreground 항해에서 함께 보낸 시간이 앨범에 조용히 쌓이는 것을 봅니다.

**필요한 이유.** 동반자를 행동 보상으로 바꾸지 않고도 함께 머문 시간이 의미 있게 느껴지게 합니다.

**피드백.** 앨범의 시간과 짧은 관계 문구.

**피해야 할 압박.** live level, progress bar, growth popup, species bonus, action multiplier.

**상태.** active foreground delta만 누적하고 `user://together_time_v1.cfg`에 local-only로 저장하는 구현이 `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`입니다. 실제 기기에서의 readability와 pressure 판단은 `NOT_RUN`입니다.

### 흘러가는 풍경과 배경 발견 연출

**플레이어가 보고 하는 일.** active foreground로 머무는 동안 새벽의 바다 아치, 밝은 낮의 해초 또는 흰 절벽, 해질녘의 사암 코브 또는 갈대섬, 밤의 먼 생물발광처럼 바다의 자연경관이 천천히 지나가는 것을 봅니다. 일부 낮은 빈도의 장면은 짧은 알림과 함께 개인 memory로 자동 저장됩니다.

**필요한 이유.** 바다가 정지한 배경이 아니라 천천히 흘러가는 장소처럼 느껴지되, 휴식을 끊지 않게 합니다.

**피드백.** 현재 시간대의 자연 명소, 짧고 사라지는 notification, local ambient memory.

**피해야 할 압박.** 발견을 보기 위한 기다림, button 요구, reward claim, task, social message, missed-event penalty, 구조물을 탭해야 하는 상호작용.

**상태.** active foreground 시간만 사용하고, 명목 5분에 약 1-2회가 지나가되 zero도 정상이라는 cadence와 여섯 승인 motif의 runtime consumer는 `IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_CAPTURE_VERIFIED`입니다. actual device에서의 5분 휴식감·noticeability·반복 피로는 `NOT_RUN`입니다.

### Album

**플레이어가 보고 하는 일.** 실제 사진, 기록, catch와 함께한 시간을 돌아봅니다.

**필요한 이유.** 효율표가 아닌 개인적 기억이 시간이 남는 방식입니다.

**피드백.** 내가 실제로 남긴 기록과 조용한 관계 문구.

**피해야 할 압박.** completion checklist, 가짜 illustrative photo, collection score.

**상태.** Album surface는 `PARTIAL_IMPLEMENTED`입니다. 함께한 시간의 Album-only 표현, 실제 사진 포스트카드, 자동 풍경, 물고기와 완료 항해 기록의 local save·restore는 각각 `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`입니다. delayed bottle 편지 내용과 그 밖의 전체 memory save는 별도 범위입니다.

## 5. 화면과 정보의 흐름

| 화면 또는 상태 | 플레이어 목표 | 주요 행동 | 다음 연결 | 제품 상태 |
| --- | --- | --- | --- | --- |
| Direct boat entry | “여기는 어떤 장소인가”를 즉시 느낌 | 보기, 머무르기 | normal voyage | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` |
| Normal voyage diorama | 캐릭터·동반자·보트·바다와 시간에 따라 바뀌는 풍경을 함께 보기 | 쉬기, 사진, 낚시, 감상, 꾸미기 | album 또는 계속 머무르기 | direct-entry atmosphere/scenery `RUNTIME_CAPTURE_VERIFIED`; Human calm `NOT_RUN` |
| Appreciation Camera | 수평선과 바다에 집중 | 감상 시작·종료 | 같은 normal voyage | `IMPLEMENTED`; Human comfort `NOT_RUN` |
| 꾸미기 | 공간을 내 취향으로 두기 | 외형·동반자·장식 변경 및 별도 preview 확인 | 같은 normal voyage | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human readability `NOT_RUN` |
| Album | 남은 개인 기록과 함께한 시간 보기 | 최근 포스트카드 세 장, 복원된 물고기·항해 기록 읽기, 바다로 돌아가기 | normal voyage | together-time·postcard·ambient·fish/voyage ledger `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; delayed-letter persistence를 포함한 전체 memory save `PARTIAL_IMPLEMENTED` |

첫 화면은 메뉴가 아니라 direct boat entry입니다. `main_menu.tscn`은 오래된 링크를 넘기는 compatibility route이며, 그 identity/time/mood capture runner는 `HISTORICAL_RETIRED`입니다. 현재 디자인 정본이나 visual approval, current runtime evidence로 사용하지 않습니다.

## 6. 확정된 시각 방향

### 시각 방향 고정

- 전체: `HANDPAINTED_STORYBOOK_3D_DIORAMA`
- 둘러보기 foreground: `MLB-LOOK-STYLE-006`의 soft-matte chibi player + round dog + matte ivory/deep-teal rounded dinghy
- 기본 Normal Diorama foreground: 기본 C+강아지 route는 stern 쪽에 기대어 뒷모습으로 보이는 `MLB-LOOK-CHIBI-NORMAL-REAR-001`의 user-approved source와 그 기술용 foreground matte `MLB-LOOK-CHIBI-NORMAL-REAR-MATTE-001`를 `FinalDioramaCard` shader material로 소비한다. normal rig는 보트 뒤쪽 위에서 바라보며, card `pixel_size=0.0037`은 새 원화의 넓은 하늘 여백 속에서도 보트·player·dog가 모바일에서 읽히도록 한다. material은 녹색 기술 배경만 alpha 처리하고, 시간대별 water-only backdrop·수면 접점·BoatSpace bob을 유지한다. user-approved `꽃` 펫 쿠션만 bow-side overlay로 보인다. `엽서`는 main normal art에 합성하지 않으며, independent 꾸미기 preview 난간 장식과 Album 항해 포스트카드로만 소비한다. alternate identity와 `stripe`·`moon` decor variant도 승인 치비 family로 current consumer에 연결됐지만, 기본 C+강아지 first-view route는 바꾸지 않는다.
- 밤: `INDIGO_RAIN_REFLECTION`

### 유지할 것

- 넓은 바다·하늘, 안정된 수평선, 낮거나 중간인 환경 대비.
- 부드러운 matte/painterly 재질과 큰 painted mass.
- 3/4 diorama 안에서 함께 읽히는 캐릭터·동반자·보트.
- 둥글고 애니메이션적인 치비 캐릭터 silhouette, 큰 머리카락 mass, 절제된 셀 명암.
- 느리고 예측 가능한 bob, 물결, idle.

### 피할 것 / 흔들리지 말 것

- glossy photoreal CG, 과한 PBR micro-detail, random AI noise.
- 큰 유리눈, glamour fashion, 실제 유아화, character만 과도하게 강조하는 rim light.
- 빠른 깜빡임, 과한 bob, attention call, 넓은 고휘도 반사.
- 보트와 물이 분리되어 보이는 합성, 바다를 가리는 거대한 UI panel.
- 다른 게임의 character proportion, UI, branding, trade dress를 닮게 복제하는 것.

### 증거를 구분하는 법

`APPROVED_DIRECTION`은 그림체의 선택입니다. 생성 exploration은 runtime asset이 아니며, source binary가 있다고 runtime alignment가 증명되는 것도 아닙니다. 실제 540 x 960 capture는 화면이 실행됐다는 증거이고, Human comfort는 사람이 확인하기 전까지 `NOT_RUN`입니다.

## 7. 현재 제품 상태와 구현 가능성

### 현재 상태

| 항목 | 상태 | 의미 |
| --- | --- | --- |
| Rest-first direction | `CONFIRMED` | 머무르기가 complete play라는 제품 방향 |
| Direct boat entry | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | `game.tscn`이 startup route이며 Human comfort는 별도 검증 전 |
| 오늘의 마음 제거 | `IMPLEMENTED / MACHINE_VERIFIED` | mood data와 pre-entry prompt를 current product route에서 retire함 |
| 현실 시간 분위기 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | 현지 시간은 시각만 바꾸고, startup selector·saved preference는 없음 |
| 흘러가는 풍경 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | 첫 기회 90–150초와 기회별 65% 표시를 사용하며, local ambient memory 저장은 구현됨. 0회 항해도 정상이고 Human five-minute observation은 별도 검증 전 |
| cosmetic 꾸미기 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | in-voyage selector와 독립 preview가 local cosmetic state만 바꿈 |
| 함께 보낸 시간 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | active foreground delta만 누적하고 Album에만 표시. Human readability는 별도 검증 전 |
| Ambient Discovery | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | active foreground의 자동 풍경만 `user://ambient_memory_v1.cfg`에 저장·복원. no-first-guarantee cadence는 구현됐고 Human five-minute observation은 별도 |
| foreground session | `IMPLEMENTED_AND_TESTED` | 앱이 foreground일 때만 항해 timer·낚시 대기·풍경 drift·자동 알림이 진행되며 background 경과는 기록을 만들지 않음 |
| Visual direction | `APPROVED_DIRECTION` | production asset batch와 runtime alignment는 별도 |
| Human usability / Player Experience | `NOT_RUN` | 실제 30초·5분 기기 경험 검증 전 |

### 구현 가능성 확인

현재 Godot 구조에서 direct boat entry는 구현 가능한 범위입니다. `GameState`처럼 Autoload된 Node는 Scene 전환을 넘어 state를 유지할 수 있고, 이는 mood를 retire한 뒤 local cosmetic state와 active foreground session state를 owner로 유지하는 데 맞습니다. [Godot Autoload 공식 문서](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)

Godot `Time`은 현지 시스템 시간을 읽을 수 있으므로 현실 시간 기반의 순수 시각 분위기에 맞습니다. 다만 시스템 시계는 사용자가 바꿀 수 있으므로 precise progress에는 쓰지 말아야 합니다. active foreground scenery는 monotonic tick 또는 scene delta로 계산합니다. [Godot Time 공식 문서](https://docs.godotengine.org/en/stable/classes/class_time.html)

작은 local cosmetic과 ambient memory는 `user://`와 `ConfigFile`로 저장·복원할 수 있습니다. 이 저장은 시간대 자체를 저장하지 않으며, 기존 mood data migration과 save 실패 처리는 구현 계약에서 정합니다. [Godot ConfigFile 공식 문서](https://docs.godotengine.org/en/stable/classes/class_configfile.html), [Godot user data filesystem 공식 문서](https://docs.godotengine.org/en/stable/tutorials/scripting/filesystem.html)

main scene을 direct boat route로 바꾸고 optional customization을 같은 게임 내 surface로 연결하는 것은 Godot 표준 SceneTree 전환의 범위입니다. 이 가능성은 아직 전환 구현이나 mobile performance 검증을 뜻하지 않습니다. [Godot Scene 전환 공식 문서](https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html)

### 구현 receipt와 남은 검증

아래 기능은 current runtime에 반영됐습니다.

1. `project.godot`은 `game.tscn`을 시작 route로 사용하며, 첫 화면은 메뉴를 닫은 normal boat diorama입니다.
2. 새벽 `05:00–08:59`, 밝음 `09:00–16:59`, 해질녘 `17:00–20:59`, 밤 `21:00–04:59`가 기기의 현지 시각으로 자동 적용됩니다. selector와 saved atmosphere는 없습니다.
3. mood data와 시작 선택 UI를 retire하고 항해 기록을 중립 문구로 바꿨습니다.
4. foreground 전용 session clock이 항해 timer·낚시 대기·풍경 drift·자동 알림을 함께 멈추며, drifting scenery director는 여섯 승인 자연 명소 중 시간대에 맞는 motif를 낮은 밀도로 표시하고 일부를 local ambient memory로 자동 저장합니다.
5. 외형·동반자·장식은 optional `메뉴 → 꾸미기`에만 있습니다.
6. 540 x 960 GPU capture에서 boat-water contact, 시간대, 원거리 작은 섬을 확인했습니다.

남은 것은 사람 검증입니다. 실제 기기 첫 30초, 5분 휴식, 터치, 알림 noticeability, 오디오 편안함은 `NOT_RUN`입니다. 함께 보낸 foreground 시간의 Album-only 표현은 기존 코드에 구현되어 있고 사람의 부담/가독성 검증은 미실행입니다.

### Blueprint evidence ceiling

| evidence subject | current ceiling | next proof |
| --- | --- | --- |
| Direct boat entry | `IMPLEMENTED_AND_GPU_CAPTURED` | actual-device first 30 seconds |
| Real-time atmosphere | `IMPLEMENTED_AND_TESTED`; GPU capture exists | device transition/readability observation |
| Foreground scenery | `IMPLEMENTED_AND_GPU_CAPTURED` | normal 5-minute density observation |
| Ambient memory | `IMPLEMENTED_AND_TESTED` | noticeability and calmness observation |
| Relationship/shared-time expression | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | Human/device readability and pressure review `NOT_RUN` |
| Device first 30 seconds / 5 minutes | `NOT_RUN` | named Human/device session |
| Touch / audio / notification intensity | `NOT_RUN` | real touch, soundscape, notification observation |

Static docs, automated tests, generated assets, and GPU captures do not promote any `NOT_RUN` row to Human or device PASS.

## 8. 금지 범위와 열린 결정

### 금지 범위

- 전투, 체력, 피해, 적, 죽음, 실패 조건, retry pressure.
- 경쟁, rank, follower, popularity, public feed, realtime chat.
- ads, payments, gacha, rare power, stats, economy farming, daily FOMO.
- 펫의 배고픔·청소·피로·방치 벌.
- direct-entry 변경을 핑계로 하는 asset batch, social expansion, unrelated refactor.

### 열린 결정

| 항목 | 현재 결정 | 나중에 정할 것 |
| --- | --- | --- |
| 현실 시간 분위기 | 현지 현실 시간이 자동 적용 | 계절·지역 일몰까지 반영할지 여부. 첫 구현에는 포함하지 않음 |
| direct-entry visual production | 구형 composition reject, water-only backdrop·기본 normal chibi material foreground·저장된 `꽃` 쿠션/`엽서` chibi decor consumer와 alternate identity/`stripe`·`moon` family가 runtime consumer로 확정 | actual-device color, readability, motion/visual comfort review |
| 함께 보낸 시간 | active foreground 시간만 1:1 누적, Album-only 분 단위 copy, local ConfigFile | Human/device readability와 5분 pressure review |
| 물고기와 완료 항해 기록 | `memory_ledger_v1.cfg`에 string 목록만 local save·restore, Album-only 소비 | Human/device readability와 delayed bottle letter의 별도 safety gate |
| 흘러가는 풍경 / Ambient Discovery | active foreground, passive, auto-save, 첫 기회 90–150초, 기회별 65% 표시, `ambient_memory_v1.cfg` | Human five-minute calm/noticeability와 장기 표현 검증 |
| Human validation | 아직 `NOT_RUN` | 실제 기기에서 first 30 seconds와 5 minutes가 calm인지 |

새 결정은 current owner와 공식 근거를 대조한 뒤에만 정본으로 올립니다. 충돌은 해당 owner만 교정한 뒤 적대적 검토를 다시 통과합니다.
