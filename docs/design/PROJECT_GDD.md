# 마이 리틀 보트 기획서

**현재 상태:** `CURRENT_HUMAN_FACING_GDD`
**갱신일:** 2026-08-30
**읽는 법:** 이 문서는 사람이 게임의 경험과 결정 상태를 이해하기 위한 정본입니다. 실제 코드·Scene·테스트·캡처는 [현재 Godot handoff](../handoffs/CURRENT_GODOT_IMPLEMENTATION.md)가, visual consumer와 provenance는 [visual inventory](../visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md)가 소유합니다.

## 0. Human Game Blueprint 읽기 profile

> `HUMAN_GAME_BLUEPRINT_GDD_LAYERED_PROFILE`

`NO_SEPARATE_BLUEPRINT_ARTIFACT`

이 GDD는 별도 Blueprint 문서·보드·부록을 만들지 않고, 현재 플레이 경험·시스템 카드·화면 흐름·증거 한계를 한 곳에서 계층적으로 읽게 합니다. 이전 AI specification은 `SUPERSEDED_AS_CURRENT_GDD` 역사 포인터이며 현재 편집 정본이 아닙니다.

### 산출물과 publication 경계

`exports/my-little-boat_MASTER_PRODUCTION_GDD_20260829.pdf` = `TRACKED_LATEST_PUBLICATION_SOURCE_BINDING_UNVERIFIED`.
`exports/my-little-boat_MASTER_PRODUCTION_GDD_20260828.pdf` = `HISTORICAL_DERIVED_NOT_CURRENT_SOURCE`.

`PDF_REISSUE_DEFERRED`: source SHA와 generator receipt가 없으므로 이번 정본 복구에서는 PDF binary를 수정하거나 새로 만들지 않습니다. 재발행은 source-bound publication package에서만 수행합니다.

### Layered reader route

| layer | 먼저 답할 질문 | 현재 section |
| --- | --- | --- |
| `PROJECT_PLAYER_LAYER` | 어떤 휴식 경험이며 무엇을 선택하지 않아도 되는가 | §1–§3 |
| `SYSTEM_LAYER` | 머무르기·분위기·기억이 어떤 흐름으로 이어지는가 | §4–§5 |
| `CONTENT_UX_PRESENTATION_LAYER` | 어떤 화면·시각·입력이 경험을 전달하는가 | §5–§6 |
| `PRODUCTION_EVIDENCE_LAYER` | 무엇이 구현됐고 어떤 기계·runtime·Human evidence가 남았는가 | §7–§8과 current handoff/visual inventory |

```text
3-MINUTE PROJECT / PLAYER READ
-> 10-MINUTE SYSTEM + CONTENT / UX / PRESENTATION READ
-> DETAIL READ
-> IMPLEMENTATION READ
-> VERIFICATION READ
```

### 상태와 evidence legend

> `STATE_AND_EVIDENCE_LEGEND`

| 상태 | 허용하는 주장 | 허용하지 않는 상위 주장 |
| --- | --- | --- |
| `CONFIRMED` | 현재 방향과 결정이 정본에 기록됨 | 구현·runtime 동작 |
| `IMPLEMENTED` / `IMPLEMENTED_AND_TESTED` | 실제 consumer와 지정 기계 계약이 있음 | 실제 기기 편안함·Human UX |
| `GPU_CAPTURED` | 지정 renderer에서 실제 화면이 렌더됨 | touch/audio/장시간 calmness |
| `PARTIAL_IMPLEMENTED` | 일부 consumer는 있으나 남은 product alignment가 있음 | 시스템 전체 완료 |
| `NOT_RUN` | 해당 device/Human/audio evidence가 없음 | 추정에 의한 PASS |

### Prospective future-package gate

`PLAN -> REQUIRED_IMAGE_AND_MATERIAL_PREPARATION -> BLUEPRINT_REVIEW_PUBLICATION -> USER_FINAL_REVIEW_APPROVAL -> IMPLEMENTATION`

- `NO_IMPLEMENTATION_BEFORE_USER_FINAL_APPROVAL`: 이 profile 이후의 새 package는 exact reviewed revision에 대한 명시적 `USER_FINAL_REVIEW_APPROVAL` 전 구현하지 않습니다.
- `PROSPECTIVE_ONLY_EXISTING_IMPLEMENTATION_EVIDENCE_PRESERVED`: 이미 구현·검증된 현재 code, Scene, test, runtime evidence는 소급 취소하지 않습니다.
- `PROSPECTIVE_ONLY_PREEXISTING_EXACT_USER_APPROVED_IMPLEMENTATION_AUTHORITY_PRESERVED`와 `EXACT_APPROVED_SCOPE_AND_REVISION_ONLY`는 동일 package·scope·revision에만 적용됩니다.
- `SCOPE_EXPANSION | SUCCESSOR_PACKAGE | INFERRED_BLANKET_APPROVAL`은 새 review gate가 필요합니다.
- 새 image deliverable은 `IMAGE_MODEL_REQUIRED_FOR_IMAGE_CREATION_OR_EDITING`을 따르며, exact 관계 정보는 `TEXT_NATIVE_EXACT_DIAGRAMS` 및 `STRUCTURED_INFORMATION_ARTIFACTS_REMAIN_TEXT_NATIVE`로 유지합니다.
### 2026-08-30 현재 runtime receipt

아래 상태가 현재 실행 build를 설명합니다. 이후의 pre-implementation 표와 `NOT_IMPLEMENTED` 표기는 historical context로만 읽고 이 receipt를 덮어쓰지 않습니다.

| 주제 | 현재 상태 | evidence ceiling |
| --- | --- | --- |
| Direct boat entry | 실행 즉시 사용자 승인 후면 3/4 치비 player·강아지·ivory/deep-teal 보트·바다 구도와 compact `쉬는 메뉴`가 보입니다. 보트는 540×960 세로 화면의 하단 20% 부근에 있고, 플레이어는 stern 쪽에 기대어 뒷모습으로, 강아지는 옆에서 함께 쉬는 모습으로 읽힙니다. `MLB-LOOK-CHIBI-NORMAL-REAR-001`의 보관 원본에서 만든 foreground matte를 `FinalDioramaCard`의 explicit shader material에 연결해, 보트 bob·legacy ripple·`MLB-BOAT-FLT-006` narrow waterline·시간대 backdrop을 분리한 채 stern-side normal 3/4를 보입니다. 감상모드는 이 normal foreground와 두 수면 접점을 숨겨 바다·수평선과 `감상 끝내기`만 남깁니다. 저장된 `꽃` 펫 쿠션만 bow-side overlay로 보입니다. `엽서`는 main rest composite에 합성하지 않고 꾸미기 preview 난간 장식과 Album의 항해 포스트카드에서 읽습니다. | rear-normal/material/final-card/direct-entry/decor/waterline/appreciation contracts와 bright title·voyage·Appreciation 540×960 GPU capture `PASS`; Human comfort `NOT_RUN` |
| 현지 시간과 풍경 | 현지 시간은 visual-only 네 분위기를 정하고, foreground에 머문 시간만 low-density 자연 명소 기회를 보냅니다. 각 시간대의 고정 하늘과 독립 흐름 바다는 그대로 유지되고, 새벽 아치·해초 모래톱·흰 절벽·사암 코브·갈대섬·밤 생물발광은 전용 pass에서 약 14초 동안 수평선을 가로질러 조용히 지나갑니다. 첫 기회는 90–150초, 기회별 표시는 65%, 다음 기회는 표시 여부와 무관하게 120–180초입니다. | split background/time contracts와 여섯 540×960 GPU pass capture `PASS`; Human long-run observation `NOT_RUN` |
| 꾸미기 | `꾸미기`에서 플레이어 외형, 동반자 종류, 보트 장식을 local-only로 고르고, 별도 보트 preview에서 즉시 확인합니다. 기본 first-view backdrop은 바꾸지 않습니다. A/B player, cat/rabbit/otter, `stripe`·`moon` cushion은 승인된 soft-matte 치비 family로 실제 선택 경로에 연결됐습니다. | identity/decor/asset-guard contracts와 alternate family 540×960 GPU capture `PASS`; Human readability `NOT_RUN` |
| 함께한 시간 | foreground 항해의 실제 시간을 local-only로 누적하고 Album에서만 분 단위·관계 문구로 보여 줍니다. | together-time contracts와 540×960 Album capture `PASS`; Human readability `NOT_RUN` |
| 모션 편안함 | `파도: 기본/잔잔/고요`는 보트·카메라·수면 접점의 자동 진폭만 `1.0 / 0.5 / 0.0`으로 바꾸는 local-only 선택입니다. | preference/state/scene contracts와 bright GPU capture `PASS`; Human motion comfort `NOT_RUN` |
| 항해 포스트카드 | `사진`은 UI 없는 실제 렌더 프레임 PNG와 메타데이터를 기기에 저장하고, Album은 최신 세 장을 점수·보상 없이 보여 줍니다. | persistence/state/scene/Album contracts와 bright·Album GPU capture `PASS`; Human readability `NOT_RUN` |
| 둘러보기 | `LookAroundCamera3D`와 드래그 입력, 기본·감상 전환, 꾸미기/Album 격리가 구현되었습니다. user-locked cute chibi `MLB-LOOK-FG-001..004`가 `LookAroundForeground`에서 좌·우·뒤·위 각도로 바뀌고, static sky와 independently flowing sea는 non-front에서도 유지됩니다. opaque magenta technical matte는 전용 chroma-key shader만 alpha 처리하며, non-front에서는 중복 normal card만 숨기고 부유 보트 상태와 수면 접점은 유지합니다. | mode/input/foreground/router/capture-guard contracts와 540×960 OpenGL GPU capture `PASS`; 1.8초 port pair sky `0.00%`, open sea `58.44%` change; `MLB-LOOK-FG-001..004` `USER_LOCKED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`; Human motion comfort `NOT_RUN` |

## 1. 이 게임은 무엇인가

`마이 리틀 보트`는 내 캐릭터와 동반자가 바다 위 작은 보트에서 목적지 없이 천천히 지나가며 함께 쉬는 휴식 우선 게임입니다. 플레이어는 목표를 해내기 위해 보트에 오르는 것이 아니라, 게임을 여는 순간 이미 그곳에 있습니다.

### 게임명과 세계관 문장

- 표기 게임명: `MY LITTLE BOAT`
- 약속 문장: `파도 위에서, 함께 쉬는 시간`
- 확정 브랜드 자산: `MLB-BRAND-TITLE-001` — 잔잔한 파도 위의 작은 보트, 뒤를 향한 사람과 동반자, 작은 별빛을 제목 주변의 상징으로만 쓴 가로형 title lockup

이 제목은 목적지·정복·탐험 과업이 아니라 동반자와 함께 머무는 시간을 약속한다. latest user direction에 따라 title lockup은 store, splash, GDD 표지와 `game.tscn`의 identity-neutral `TitleOverlay/BrandLogo`에 쓴다. 실제 실행은 **타이틀 대기** 상태의 보트 diorama로 곧바로 들어간다. 이때 실제 보트·현재 player/pet·바다는 보이지만 `GameState.begin_voyage()`와 함께한 시간·기억·보상은 아직 호출하지 않는다. `항해 시작`을 누른 뒤에만 normal voyage와 `쉬는 메뉴`가 열린다. 이미지 속 특정 사람·강아지는 기본 player/pet identity, save, reward, 혹은 runtime character asset을 정하지 않는다.

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

현재 제공된 구형 main-entry 구성은 이 기준을 충족하지 않습니다. 보트가 바다 위에 합성된 것처럼 보이고 시작 panel이 휴식보다 먼저 보이므로 `REJECTED_FOR_MAIN_ENTRY_RUNTIME_USE`입니다. 현재 선택형 main menu code도 이 제품 흐름에서는 `PRODUCT_SUPERSEDED_IMPLEMENTATION`입니다. 이 결정은 보트·바다 source binary를 일괄 폐기한다는 뜻이 아닙니다.

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

### 첫 5·15·30분 truth table

`FIRST_5_MINUTES_NOMINAL_SESSION_HYPOTHESIS`: 첫 5분은 반드시 채워야 하는 목표가 아니라 한 번의 명목상 휴식 세션을 설명하는 hypothesis입니다. 실제 기기에서 이 시간이 calm한지는 actual-device calmness `NOT_RUN`입니다.

`FIRST_15_30_MINUTES_CONDITIONAL_OPTIONAL_EXTENDED_STAY_NOT_FORCED_MILESTONES`: 첫 15분과 30분은 플레이어가 스스로 더 머물 때만 생기는 conditional optional extended stay이며 forced onboarding·retention·reward milestone이 아닙니다.

| 시간 | 경험 contract | evidence |
| --- | --- | --- |
| 첫 5분 | 명목상 한 항해에서 머무르거나 원할 때 낮은 압력 행동을 쓰고 자연스럽게 떠날 수 있음 | 기계 계약과 runtime capture가 존재하며 actual-device calmness `NOT_RUN` |
| 첫 15분 | 선택적으로 더 머물며 분위기·풍경·개인 기록을 느슨하게 경험할 수 있음 | optional extended-stay hypothesis; Human `NOT_RUN` |
| 첫 30분 | 선택적으로 계속 머물거나 Album·꾸미기를 오갈 수 있음 | optional extended-stay hypothesis; Human `NOT_RUN` |
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

## 4. 시스템 카드

> `REUSABLE_FLOW_AND_SYSTEM_CARDS`

`LAYERED_TRACEABILITY_REQUIRED`: 아래 카드와 §5–§7은 플레이어 약속, 화면·시각 표현, 구현/기계 증거, Human `NOT_RUN` 한계를 같은 reader route에서 연결합니다. 정확한 code·Scene·test 경로는 사람용 설명을 중복하지 않고 current handoff와 visual inventory가 소유합니다.

### 떠 있는 휴식

**플레이어가 보고 하는 일.** 캐릭터와 동반자가 탄 보트가 잔잔한 바다를 목적지 없이 천천히 지나가는 모습을 보고, 원하면 아무 입력 없이 머뭅니다.

**필요한 이유.** 이 게임의 핵심 재미는 보상 전 대기 시간이 아니라 함께 존재하는 장소를 보는 데 있습니다.

**피드백.** 보트의 느린 전진과 bob, 바다·하늘의 변화, 동반자의 낮은 빈도 idle, 파도 중심 soundscape가 “함께 흘러가고 있다”는 감각을 줍니다.

현지 시간이 바뀌면 하늘·빛·바다의 색과 반사가 천천히 이어집니다. active foreground로 머문 시간이 쌓이면 새벽의 바다 아치, 밝은 낮의 해초 또는 절벽, 해질녘의 사암 코브 또는 갈대섬, 밤의 먼 생물발광처럼 한 장면이 낮은 밀도로 흘러갑니다. 이 장면은 10초 뒤 현재 시간대의 물만 있는 기본 바다로 돌아오며, 버튼·목적지·보상·과제가 아닙니다. 둘 다 해야 할 일이나 보상이 아니라, 같은 장소가 살아 있다는 배경 감각입니다.

**피해야 할 압박.** 방치 벌, timer 실패, idle 보상, 매분 확인 요구, 목적지·항로·도착 보상.

**상태.** 자연 명소 여섯 장은 `USER_APPROVED → CANON_REGISTERED → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`입니다. 보트의 전후·측면 움직임은 목적지·항로·보상·저장과 무관한 순환형 시각 표현이며, `파도: 고요`에서는 기존 bob·roll과 함께 멈춥니다. 실제 기기에서의 휴식감은 `NOT_RUN`입니다.

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

**상태.** 입력·mode 격리, 승인된 `port`·`starboard`·`aft`·`overhead` canonical asset routing, 기본 Normal의 후면 치비 foreground material, 저장된 `꽃` 펫 쿠션·`엽서`의 치비 decor consumer, 그리고 normal·네 각도·Appreciation의 540×960 GPU capture가 `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`입니다. 이 상태는 항해 시간·속도·저장·보상·soundscape를 바꾸지 않습니다. 기본 C+강아지 Normal은 `MLB-LOOK-CHIBI-NORMAL-REAR-001` 보관 원본에서 만든 `MLB-LOOK-CHIBI-NORMAL-REAR-MATTE-001`를 `FinalDioramaCard`에 연결하고 stern-side rig에서 보여 주며, time-paired static sky·flowing sea backdrop과 BoatSpace 부유를 유지합니다. 정면 Look Around은 같은 분리 배경을 사용하고, `port`·`starboard`·`aft`·`overhead`의 보트+바다 composite 원화는 선체가 가려지지 않도록 whole-image still로 보존합니다. 사용자가 승인한 alternate A/B player, cat/rabbit/otter, `stripe`·`moon` cushion 7종은 exact canonical copy와 기존 save ID를 사용해 layered `Sprite3D`와 decor texture consumer에 연결됐습니다. 실제 기기의 motion comfort, touch reachability, 장시간 휴식감은 `NOT_RUN`입니다.

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
| 타이틀 대기 | “여기는 어떤 장소인가”를 로고와 실제 보트로 즉시 느낌 | 보기, `항해 시작` | normal voyage | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human calm `NOT_RUN` |
| Normal voyage diorama | 캐릭터·동반자·보트·바다와 시간에 따라 바뀌는 풍경을 함께 보기 | 쉬기, 사진, 낚시, 감상, 꾸미기 | album 또는 계속 머무르기 | direct-entry atmosphere/scenery `RUNTIME_CAPTURE_VERIFIED`; Human calm `NOT_RUN` |
| Appreciation Camera | 수평선과 바다에 집중 | 감상 시작·종료 | 같은 normal voyage | `IMPLEMENTED`; Human comfort `NOT_RUN` |
| 꾸미기 | 공간을 내 취향으로 두기 | 외형·동반자·장식 변경 및 별도 preview 확인 | 같은 normal voyage | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human readability `NOT_RUN` |
| Album | 남은 개인 기록과 함께한 시간 보기 | 최근 포스트카드 세 장, 복원된 물고기·항해 기록 읽기, 바다로 돌아가기 | normal voyage | together-time·postcard·ambient·fish/voyage ledger `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; delayed-letter persistence를 포함한 전체 memory save `PARTIAL_IMPLEMENTED` |

첫 화면은 설정 메뉴가 아니라 **타이틀 대기**입니다. `TitleOverlay`는 로고와 `항해 시작`만 표시하고, 배경에는 same `BoatSpace`·동반자·바다를 사용합니다. 따라서 현재 `main_menu.tscn`의 identity/time/mood UI와 그 capture는 code evidence일 뿐, 이 화면 흐름의 디자인 정본이나 visual approval이 아닙니다.

## 6. 확정된 시각 방향

### 시각 방향 고정

- 전체: `HANDPAINTED_STORYBOOK_3D_DIORAMA`
- 브랜드 표지: `MLB-BRAND-TITLE-001`은 deep teal ink, warm ivory paper, 작은 파도·별빛으로 `MY LITTLE BOAT`와 `파도 위에서, 함께 쉬는 시간`을 읽히게 한다. `USER_APPROVED → CANON_REGISTERED → ASSET_READY → IMPLEMENTED`; user가 요청한 `TitleOverlay/BrandLogo` runtime consumer에서만 쓰며 player/pet identity consumer는 없다.
- 둘러보기 foreground: `MLB-LOOK-STYLE-006`의 soft-matte chibi player + round dog + matte ivory/deep-teal rounded dinghy
- 기본 Normal Diorama foreground: 기본 C+강아지 route는 stern 쪽에 기대어 뒷모습으로 보이는 `MLB-LOOK-CHIBI-NORMAL-REAR-001`의 user-approved source와 그 기술용 foreground matte `MLB-LOOK-CHIBI-NORMAL-REAR-MATTE-001`를 `FinalDioramaCard` shader material로 소비한다. normal rig는 보트 뒤쪽 위에서 바라보며, card `pixel_size=0.0037`은 새 원화의 넓은 하늘 여백 속에서도 보트·player·dog가 모바일에서 읽히도록 한다. material은 녹색 기술 배경만 alpha 처리하고, 시간대별 static `SkyBackdrop`·flowing `SeaBackdrop`·수면 접점·BoatSpace bob을 유지한다. user-approved `꽃` 펫 쿠션만 bow-side overlay로 보인다. `엽서`는 main normal art에 합성하지 않으며, independent 꾸미기 preview 난간 장식과 Album 항해 포스트카드로만 소비한다. alternate identity와 `stripe`·`moon` decor variant도 승인 치비 family로 current consumer에 연결됐지만, 기본 C+강아지 first-view route는 바꾸지 않는다.
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
| 타이틀 대기 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | `game.tscn`이 startup route이며, `항해 시작` 전에는 voyage state를 만들지 않는다. Human comfort는 별도 검증 전 |
| 오늘의 마음 제거 | `IMPLEMENTED / MACHINE_VERIFIED` | mood data와 pre-entry prompt를 current product route에서 retire함 |
| 현실 시간 분위기 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | 현지 시간은 시각만 바꾸고, startup selector·saved preference는 없음 |
| 기본 하늘·바다 흐름 | `IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_CAPTURE_VERIFIED` | 각 시간대의 `SkyBackdrop`은 material override 없이 고정되고, `SeaBackdrop`만 `voyage_split_sea_flow.gdshader`의 alpha mask와 shared flow offset으로 타이틀 대기·항해 중 계속 느리게 흐른다. 항해 시간·저장·보상에는 영향을 주지 않는다. Bright 1.8초 frame pair에서 upper sky `0.00%`, open sea `70.79%`, lower sea `83.81%` changed-pixel 증거가 남아 있다. |
| 밝은 봄 분리 parallax | `IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_CAPTURE_VERIFIED` | 현지 월 `3..5`의 `bright` visual context에서만 구름이 세 camera path에, 꽃섬은 normal·Appreciation의 기존 저밀도 기회 위에 별도 Sprite3D로 합성된다. 꽃섬은 원본의 투명 캔버스를 제외한 수평선용 영역만 쓰므로 보트가 지나가는 하단 바다 항로에 들어오지 않는다. static sky, flowing sea, 보트, 저장·보상은 바꾸지 않는다. Human/device motion comfort는 별도 검증 전. |
| 선체-수면 접점 | `IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_CAPTURE_VERIFIED` | existing ripple은 보트의 x/z와 거의 같은 y bob을 따른다. user-approved `MLB-BOAT-FLT-006` narrow waterline raster는 `BoatWaterlineContact`가 depth test를 유지한 채 선체 하단에만 표시하며, 같은 x/z·vertical drift와 `still` comfort base return을 사용한다. 540×960 title·voyage capture에서 캐릭터·동반자·`쉬는 메뉴`를 가리지 않는다. Human comfort는 별도 검증 전 |
| 흘러가는 풍경 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | 첫 기회 90–150초와 기회별 65% 표시를 사용하며, local ambient memory 저장은 구현됨. 0회 항해도 정상이고 Human five-minute observation은 별도 검증 전 |
| cosmetic 꾸미기 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | in-voyage selector와 독립 preview가 local cosmetic state만 바꿈 |
| 함께 보낸 시간 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | active foreground delta만 누적하고 Album에만 표시. Human readability는 별도 검증 전 |
| Ambient Discovery | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED` | active foreground의 자동 풍경만 `user://ambient_memory_v1.cfg`에 저장·복원. no-first-guarantee cadence는 구현됐고 Human five-minute observation은 별도 |
| Visual direction | `APPROVED_DIRECTION` | production asset batch와 runtime alignment는 별도 |
| Human usability / Player Experience | `NOT_RUN` | 실제 30초·5분 기기 경험 검증 전 |

### 구현 가능성 확인

현재 Godot 구조에서 direct boat entry는 구현 가능한 범위입니다. `GameState`처럼 Autoload된 Node는 Scene 전환을 넘어 state를 유지할 수 있고, 이는 mood를 retire한 뒤 local cosmetic state와 active foreground session state를 owner로 유지하는 데 맞습니다. [Godot Autoload 공식 문서](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)

Godot `Time`은 현지 시스템 시간을 읽을 수 있으므로 현실 시간 기반의 순수 시각 분위기에 맞습니다. 다만 시스템 시계는 사용자가 바꿀 수 있으므로 precise progress에는 쓰지 말아야 합니다. active foreground scenery는 monotonic tick 또는 scene delta로 계산합니다. [Godot Time 공식 문서](https://docs.godotengine.org/en/stable/classes/class_time.html)

작은 local cosmetic과 ambient memory는 `user://`와 `ConfigFile`로 저장·복원할 수 있습니다. 이 저장은 시간대 자체를 저장하지 않으며, 기존 mood data migration과 save 실패 처리는 구현 계약에서 정합니다. [Godot ConfigFile 공식 문서](https://docs.godotengine.org/en/stable/classes/class_configfile.html), [Godot user data filesystem 공식 문서](https://docs.godotengine.org/en/stable/tutorials/scripting/filesystem.html)

main scene을 direct boat route로 바꾸고 optional customization을 같은 게임 내 surface로 연결하는 것은 Godot 표준 SceneTree 전환의 범위입니다. 이 가능성은 아직 전환 구현이나 mobile performance 검증을 뜻하지 않습니다. [Godot Scene 전환 공식 문서](https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html)

### 완료된 Direct Boat Entry package의 역사적 구현 계약

아래 항목은 2026-08-30부터 2026-09-01까지 구현·기계/runtime 검증으로 이어진 Direct Boat Entry package의 당시 contract입니다.

1. main scene이 현지 현실 시간에 맞는 normal boat diorama로 바로 시작한다.
2. 새벽 `05:00–08:59`, 밝음 `09:00–16:59`, 해질녘 `17:00–20:59`, 밤 `21:00–04:59`를 첫 구현의 local-time mapping으로 사용한다. 수동 selector와 saved atmosphere는 retire한다.
3. mood data, mood wording, mood color rule, mood-dependent test를 migration과 함께 retire한다.
4. active foreground 시간만 사용하는 low-density drifting scenery director를 추가한다. 명목 5분에 약 1-2개의 먼 풍경 장면이 지나가며, zero도 정상이다. 실제 scene asset은 named consumer가 없는 한 만들지 않는다.
5. 외형·동반자·장식 선택을 optional `꾸미기`로 이동한다.
6. direct-entry diorama가 540 x 960에서 float-contact 기준을 충족하는 runtime capture를 만든다.
7. 자동 route/time-mapping/foreground-progress tests, targeted scene smoke, runtime capture, Human 30초·5분 검증을 서로 구분해 기록한다.

위 contract의 scene, state, scenery, customization entry, water-contact, test, GPU capture 경로는 현재 receipt에 따라 구현되었습니다. 이 문단은 현재 작업 순서를 정하는 새 구현 queue가 아닙니다. 이후 작업은 `docs/operations/MY_LITTLE_BOAT_BASE_ADAPTER.json`의 fresh-read → reuse/benchmark → bounded owner change → evidence → review 순서를 따르며, Human/device evidence는 계속 별도 gate입니다.

### Blueprint evidence ceiling

| evidence subject | current ceiling | next proof |
| --- | --- | --- |
| Direct boat entry | `IMPLEMENTED_AND_GPU_CAPTURED` | actual-device first 30 seconds |
| Real-time atmosphere | `IMPLEMENTED_AND_TESTED`; GPU capture exists | device transition/readability observation |
| Foreground scenery | `IMPLEMENTED_AND_GPU_CAPTURED` | normal five-minute density observation |
| Ambient memory | `IMPLEMENTED_AND_TESTED` | noticeability and calmness observation |
| Relationship/shared-time expression | `IMPLEMENTED_AND_TESTED`; Album GPU capture exists | Human readability and pressure observation |
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
| direct-entry visual production | 구형 composite-flow composition reject, static sky + flowing sea pair·기본 normal chibi material foreground·저장된 `꽃` 쿠션/`엽서` chibi decor consumer와 alternate identity/`stripe`·`moon` family가 runtime consumer로 확정 | actual-device color, readability, motion/visual comfort review |
| 함께 보낸 시간 | active foreground 시간만 1:1 누적, Album-only 분 단위 copy, local ConfigFile | Human/device readability와 5분 pressure review |
| 물고기와 완료 항해 기록 | `memory_ledger_v1.cfg`에 string 목록만 local save·restore, Album-only 소비 | Human/device readability와 delayed bottle letter의 별도 safety gate |
| 흘러가는 풍경 / Ambient Discovery | active foreground, passive, auto-save, 첫 기회 90–150초, 기회별 65% 표시, `ambient_memory_v1.cfg` | Human five-minute calm/noticeability와 장기 표현 검증 |
| Human validation | 아직 `NOT_RUN` | 실제 기기에서 first 30 seconds와 5 minutes가 calm인지 |

새 결정은 current owner와 공식 근거를 대조한 뒤에만 정본으로 올립니다. 충돌은 해당 owner만 교정한 뒤 적대적 검토를 다시 통과합니다.

### 8.1 2026-09-01 계절형 자연 명소 분리 합성 Pass v1 Blueprint review

**상태.** `RESEARCHED → FEASIBLE → USER_APPROVED_MATERIAL → ASSET_READY → BLUEPRINT_REVIEW_READY → USER_FINAL_REVIEW_APPROVED → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`입니다. 이 상태는 exact Bright/spring v1 Scene·GDScript·contract·Windows OpenGL capture에만 적용합니다. Human/device five-minute calmness, touch, color, motion comfort와 release acceptance는 `NOT_RUN`입니다.

**목표.** 밝은 봄의 작은 꽃섬과 느린 구름이 existing clear sea 위에서 서로 다른 깊이와 속도로 움직여, 보트가 목적지 없이 계속 떠가고 있다는 감각을 강화합니다. 배경은 풍부해지되, 명소를 보거나 사진을 찍거나 기다려야 하는 목적은 만들지 않습니다.

**플레이어가 보게 되는 흐름.** 기기의 현지 시간이 `bright`이고 현지 월이 3–5월이면, 일반 항해와 Appreciation Camera의 현재 low-density scenery opportunity가 기존 bright motif 또는 작은 꽃섬 중 하나를 지나가게 할 수 있습니다. 같은 기간에는 sky 위의 작은 구름이 섬보다 느리게, existing sea shader는 두 layer와 독립적으로 흐릅니다. 명소를 전혀 만나지 않아도 정상이며, 구름은 save·notice·reward를 만들지 않습니다.

**범위와 고정 경계.**

- `bright`의 시간 범위와 current `dawn / bright / sunset / night` decision은 바꾸지 않습니다.
- 월 3–5월은 내부 `spring` visual bucket일 뿐, 날짜·계절 이름·지역·날씨·달력 UI·saved preference를 표시하지 않습니다.
- first v1은 `bright + spring`의 one-island vertical slice입니다. 6–2월과 bright의 다른 기존 motif는 current pool로 fallback하며, 다른 계절 image batch는 이 package에 자동 포함하지 않습니다.
- `SkyBackdrop`은 그대로 고정하고, existing `SeaBackdrop`과 `voyage_split_sea_flow.gdshader`를 재사용합니다. 새 sea image, full-scene moving texture, whole-sky pan은 만들지 않습니다.
- `SeasonalCloudLayer`는 three camera path의 sky와 sea 사이에서 only-cloud parallax를 보이고, `SeasonalIslandLayer`는 current normal·Appreciation ambient transit에서 sea 앞/boat 뒤의 수평선 landmark로만 보입니다. 꽃섬의 source alpha bounds를 포함하는 runtime crop과 작은 scale을 사용해 하단 보트 항로와 교차하지 않습니다. Look Around의 angle-specific foreground와 existing ambient policy는 변경하지 않습니다.
- 꽃섬은 current `DriftSceneryDirector`의 foreground-only cadence, one-at-a-time state, 65% display chance, 0-event-valid rule, existing short label, and optional local ambient memory save를 그대로 공유합니다. chance, cadence, save rate, camera mode, speed tier, cosmetic identity, together time, fishing, decor, affection, reward는 바꾸지 않습니다.
- 구름은 visual-only loop이며 ambient memory, notification, timer, reward, photo requirement, score, completion, collection slot, seasonal event, daily goal, missed-state, social action을 만들지 않습니다.
- user `still` motion comfort setting에서는 새 cloud parallax와 new island transit movement도 advance하지 않습니다. `standard / gentle`은 current normalized motion multiplier를 재사용해 amplitude와 transit speed를 낮춥니다. 이 behavior는 existing approved sea and boat semantics를 변경하지 않습니다.

**approved material and composition.** `MLB-AMB-SEASONAL-REF-001` is a non-runtime visual direction source. `MLB-AMB-SEASONAL-ISLAND-001` is the actual RGBA island texture. `MLB-AMB-SEASONAL-CLOUD-001` is an intentionally opaque magenta technical matte that uses the existing verified `look_around_foreground_chroma_key.gdshader`, not a new image conversion or a new shader family. `MLB-BG-SPLIT-001 / 002` remain the current bright static-sky / flowing-sea pair. Exact paths, dimensions, hashes, candidate provenance, and state distinctions are owned by the current visual inventory.

**implementation mapping after final approval.**

| owner | bounded responsibility | save / rollback boundary |
| --- | --- | --- |
| `scripts/voyage/real_time_atmosphere_resolver.gd` | injectably resolve `spring` for months `3..5`; invalid month safely resolves to empty seasonal bucket | device date is visual-only; no persistence, reward, or progress use. Godot system time is not a monotonic gameplay clock |
| `scripts/voyage/drift_scenery_director.gd` | select the existing bright motif pool plus exactly one `bright + spring` island when compatible; preserve no-immediate-repeat and fallback behavior | no new cadence/state persistence; reverting the seasonal entry restores the current six motif selection |
| `scenes/game.tscn` | add named `SeasonalCloudLayer` to three camera paths and named `SeasonalIslandLayer` only beside existing normal/Appreciation `AmbientSceneryPass`; island keeps the canonical source but uses `region_enabled`, `Rect2(632, 350, 1028, 350)`, and `pixel_size=0.005` for a horizon-only silhouette | no changed BoatSpace, Look Around foreground, sky/sea source, or UI hierarchy |
| `scripts/voyage/game_scene.gd` | bind exact approved textures, existing chroma-key shader, visual month bucket, cloud loop, island transit, and comfort multiplier without touching voyage/save semantics | a package reversion removes the named nodes/routes and returns exact current scene behavior |
| `tests/test_seasonal_parallax_contract.gd` and focused existing contracts | injected month / atmosphere matrix, source-to-canonical hash, alpha/matte guard, layer order, runtime crop excluding source-canvas edges, distant projected scale, fallback, no save/reward mutation, still/gentle motion boundaries | display capture assertions stay renderer-only and never report headless texture readback as PASS |

**alternatives compared.**

| alternative | verdict | reason |
| --- | --- | --- |
| Existing sky + existing flowing sea + separately composited cloud/island parallax | **ADOPT** | direct response to the user's movement-depth request, reuses approved surfaces and a tested chroma-key route, and keeps foreground boat legible |
| Four fully illustrated seasonal full-screen backgrounds that move as one card | **REJECT** | repeats the original whole-image movement problem, duplicates the sea/sky asset family, and expands asset count without preserving independent motion |
| Real-time daily quests, seasonal event calendar, photo objectives, collection completion or notice-driven rewards | **REJECT** | converts visual context into a chore/FOMO loop and violates the rest-first no-pressure boundary |
| Local month only changing a static tint with no new landmark layers | **ADAPT later only** | cheap but does not solve the user-requested depth and continuous movement issue |

**feasibility and test path.** Godot `Time.get_date_dict_from_system(false)` exposes local month data, but system-clock values can be changed by the user or OS; therefore the package uses it only for visual routing and injected deterministic tests, never elapsed-time, reward, or save computation. [Godot Time 공식 문서](https://docs.godotengine.org/en/stable/classes/class_time.html) `Sprite3D.region_enabled` displays only the configured `region_rect`, so it can consume the existing island source without a derivative PNG while excluding its transparent canvas margin. [Godot Sprite3D 공식 문서](https://docs.godotengine.org/en/stable/classes/class_sprite3d.html) `test_seasonal_parallax_contract.gd` first failed on absent month routing, three-argument seasonal selection, named camera consumers and motion behavior, then passed after the bounded implementation. The distance correction adds a source-edge crop and projected-scale contract. The renderer capture now requires a horizon island and clear lower boat lane in three normal frames of one transit, then measures an early/late island-center displacement of at least `80px`; current Windows OpenGL run measured `213px`. This remains machine/runtime evidence, not Human/device comfort proof.

**final approval boundary.** The user approved this exact Blueprint revision before implementation. That authority was consumed only for this Bright/spring vertical slice. It did not authorize other seasonal images, daily systems, location settings, social features, or Human validation.

#### 8.1.1 Preimplementation material and Blueprint review receipt

| loop | exact review | validated result | correction / retained boundary | evidence ceiling |
| --- | --- | --- | --- | --- |
| 1 | current `AGENTS.md`, current GDD/handoff/visual inventory, `game.tscn`, `GameScene`, `DriftSceneryDirector`, existing split bright images and prior runtime evidence | whole-scene `AmbientSceneryPass` would move sky, sea and landmark together, while existing bright sea is already a separate flowing asset | adopt separate cloud/island composition and reuse existing static-sky/flowing-sea pair | current runtime remains unchanged |
| 2 | Tiny Glade, Cozy Grove, TOEM, Palia and Godot Time primary/official material comparison with project no-pressure constraints | landmark variation is feasible; full seasonal screens and daily/quest/photo completion systems conflict with the product | select one bright/spring visual-only vertical slice with month `3..5` and no UI/reward/save meaning | research/feasibility, not runtime proof |
| 3 | built-in image generation output plus alpha/matte pixel inspection | direction-reference scene, isolated island and cloud art met the intended composition; first island contained reflection and two cloud outputs were opaque checkerboard RGB | retain user-approved reference, regenerate reflection-free RGBA island, reject opaque checkerboard attempts, use existing chroma-key route for cloud matte | source asset quality only |
| 4 | exact source/canonical byte hashes, free-space preflight, non-overwriting project copies, Godot `--headless --path . --import`, project headless smoke | source/canonical pairs match; two runtime textures import without project startup regression | register only source/reference plus exact two implementation-ready textures; no full-scene runtime duplicate or new sea file | asset import and project smoke only |
| 5 | runtime-isolation search, documented ID/path readback, island alpha samples, cloud-key threshold samples, `git diff --check` | new asset paths have no Scene/script/test consumer before final approval; island alpha and chroma matte meet their respective source-level contracts; no whitespace error | preserve `NOT_IMPLEMENTED` / `NOT_RUN` status and require failure-first implementation contracts and display renderer capture next | no seasonal runtime, Human, device, audio, accessibility or release PASS |

No valid MUST_FIX remains in the material-preparation scope. The rejected candidate-store outputs are not project assets. The only remaining gate is user review of this exact Blueprint revision before code implementation.

#### 8.1.2 Implementation and adversarial review receipt

| loop | exact review | validated result | correction / retained boundary | regression / evidence |
| --- | --- | --- | --- | --- |
| 1 | user-approved §8.1 revision, current `AGENTS.md`, `game.tscn`, `game_scene.gd`, resolver, director, comfort owner and approved hashes | month can remain visual-only and the existing bright pool can safely accept one additional entry only under `spring` | `resolve_season_for_month(3..5)` and optional director season argument were selected; 6–2 and old two-argument callers retain fallback | initial seasonal contract failed as expected on missing resolver/selection behavior |
| 2 | resolver/director green run and existing director/ambient/split contracts | direct append into a constant-backed motif array produced Godot `Array is in read-only state` | copied the array before appending; no cadence, chance, save rate or old motif source changed | seasonal, director, ambient and split contracts passed |
| 3 | Scene consumer contract, three camera nodes and Look Around foreground material | shared chroma-key `ShaderMaterial` would overwrite the existing angle foreground texture binding | each `SeasonalCloudLayer` now gets a runtime-local shader material while reusing the same approved shader source | named normal/Look Around/Appreciation cloud layers, normal/Appreciation island layers and untouched Look Around policy passed |
| 4 | motion contract with no-save deterministic island event and existing comfort/forward-drift/ambient contracts | dedicated island needed manual comfort-aware transit rather than the old tween, which would move even in `still` | cloud phase and island progress use existing `standard/gentle/still` scale; the shared return timer clears the visual route without a new saved timer | standard motion, gentle reduction, still freeze and photo/fish/record/together-time non-mutation passed |
| 5 | Windows OpenGL capture, image readback, 57 headless contracts in two bounded batches, import and current CI guard | first normal capture had cloud source above the tighter 3/4 frame despite correct chroma alpha | moved only camera-local cloud Sprite y to `-3.2`; the later island-distance correction is recorded separately below | historical pre-distance normal SHA `05620478B85A1C86D5E3D4EC7735C69B21C2DF43F7EB21918FD9EC655D6B3AE7`, Appreciation SHA `6DDC2C5C882EB95F435140C2E72C0D100585AEA378DAF72A9B1FA528C58F1235`; Human/device remains `NOT_RUN` |

#### 8.1.3 2026-09-01 원거리 꽃섬 항로 보정 receipt

사용자 방향은 “섬은 멀리 두고 배는 바다만 지난다”입니다. 이 보정은 `MLB-AMB-SEASONAL-ISLAND-001` 원본·승인·hash·chance·cadence·save·reward·camera mode를 바꾸지 않고, 두 existing `SeasonalIslandLayer`의 표시 영역과 scale만 좁힙니다.

| loop | exact review | validated finding | applied correction / retained boundary | regression / evidence |
| --- | --- | --- | --- | --- |
| 1 | latest user direction, current `AGENTS.md`, `game.tscn`, current normal OpenGL capture, island asset consumer | island source full canvas was displayed at the same scale as the ambient pass, so its large transparent canvas made the landmark read near the boat lane | choose source-preserving runtime crop plus smaller projected scale; do not add a new island image or move the boat, sea, reward, or transit schedule | initial static geometry and renderer lane guards fail before correction |
| 2 | failure-first `test_seasonal_parallax_contract.gd` geometry assertion and normal renderer lower-lane assertion | full-canvas source does not exclude empty margins, cannot prove horizon scale, and can leave island-colour samples in the lower boat lane | require a non-edge `region_rect`, `region_enabled`, and normal-camera projected height ratio `≤ 0.30`; renderer also requires a horizon mark and clear lower lane | failure output retained before Scene correction |
| 3 | exact source alpha inspection and official `Sprite3D` region semantics | `1672×941` source has opaque alpha only in `Rect2(644, 362, 1002, 322)` | retain source bytes and select padded `Rect2(632, 350, 1028, 350)` with `pixel_size=0.005` in normal and Appreciation layers | crop contains every opaque source pixel while excluding all four source-canvas edges |
| 4 | iterative scene diff, actual 540×960 display capture, untouched `SkyBackdrop` and `SeaBackdrop` readback | an overly broad scene edit briefly changed the normal sky/sea card scale, visibly producing blue frame bars | restore both normal sky/sea `pixel_size` values exactly to their prior `0.02`; retain only the two island `region` and `pixel_size` changes | current scene diff is restricted to the two seasonal island layers; sky, flowing sea, BoatSpace and Look Around remain untouched |
| 5 | Godot `--import`, normal scene smoke, 57 headless contracts in `27 + 30` batches, display-only material proof, Windows OpenGL normal/Appreciation capture, hash/readback | all machine checks passed. The initial aggregate harness falsely treated the exit-0 Windows export contract as failure because it prints `Windows export contract passed` rather than `PASS:`; its source assert and exit code were read, then batch two was rechecked by exit code | retain the project test sources unchanged and make the aggregation receipt use engine exit code. Final scene diff is still limited to the two island layers | normal SHA `C6B652B85D83E30C54406EFA0646248A52761F81DA059D807920B2638E330E7C`, Appreciation SHA `291E141B8021E46A20A613AA91E3238D59227A9E0891C58A08F8B8F3C9B010F0`; Human/device remains `NOT_RUN` |

#### 8.1.4 2026-09-02 꽃섬 transit renderer proof receipt

| loop | exact review | validated finding | correction / retained boundary | regression / evidence |
| --- | --- | --- | --- | --- |
| 1 | latest user standing image authorization, current `AGENTS.md`, GDD, visual inventory, `game.tscn`, `GameScene`, capture source and prior single normal/Appreciation evidence | previous evidence proves a safe single frame but does not prove that the distant island traverses the screen while maintaining the lower boat lane | retain existing asset and scene; add only a renderer-evidence pair inside the actual 14-second transit | no new image consumer, gameplay meaning, save, reward, camera mode, or asset source change |
| 2 | three alternatives against the existing rest-first loop and Godot display-capture path | a physical island collision/route changes passive play, a newly generated island duplicates an approved consumer, and a timed renderer pair directly verifies the reported risk | **ADOPT** timed renderer pair, **REJECT** collision/waypoint route and duplicate island art, **ADAPT** existing capture guard with pixel-center measurement | [Godot RenderingServer 공식 문서](https://docs.godotengine.org/en/stable/classes/class_renderingserver.html)의 `frame_post_draw` semantics에 맞춘 runtime proof design이며 Human proof가 아니다 |
| 3 | failure-first `test_seasonal_parallax_contract.gd` capture-source contract | capture had no early/late files, displacement threshold, or rendered-silhouette locator | add early/late normal files, `MIN_MOTION_HORIZONTAL_DELTA_PIXELS`, and island center extraction to the existing capture route | initial focused contract failed on all four missing proof requirements |
| 4 | Windows OpenGL capture failures, scene route state, event timer and island progress/position instrumentation | first timing attempt spent the old 7-second wait plus the new wait, while the next attempt sampled outside the narrow normal-camera visibility window | remove duplicated timing budget and sample the same active transit at `6.5`, `7.0`, `7.5` seconds. Remove temporary diagnostics after the cause is known | `AmbientSceneryReturnTimer` stays `14` seconds; game Scene and asset source remain unchanged |
| 5 | clean Windows OpenGL capture, four PNG readback and pixel guard | three normal frames contain cloud, horizon island and clear lower boat lane; early/late island center differs by `213px` | retain minimal capture-only change and record exact files/hashes in evidence owner | renderer capture `PASS`; Human/device motion comfort, touch and five-minute calmness remain `NOT_RUN` |
