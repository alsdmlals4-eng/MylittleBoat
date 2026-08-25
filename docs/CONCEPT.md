# Concept

> **Authority:** 사람용 프로젝트 개요·경험/시각 방향의 최신 승인 정본은 Notion Human Home과 관련 Core/Visual 페이지입니다. 이 파일은 그 방향을 repository 구현 작업이 소비할 수 있게 옮긴 **structured implementation mirror**이며, 더 최신의 승인된 Notion 방향을 임의로 덮어쓰지 않습니다. 실제 런타임 사실은 코드·Scene·Resource·Test와 실행 증거가 우선합니다.

`my little boat`는 **본디에서 참고한 작고 둥근 3D 디오라마 감성**을 바탕으로, 작은 보트 위에서 보이는 플레이어 캐릭터와 펫이 함께 쉬고 생활하며 잔잔한 바다·파도소리·작은 기억을 쌓는 rest-first 힐링 항해 게임입니다.

정상 플레이는 플레이어·펫·보트·바다가 함께 보이는 **3/4 Boat Diorama**를 사용하고, 원할 때는 기존 바다 중심 경험을 **Appreciation Camera**로 전환해 UI 개입을 줄이고 수평선과 파도에 집중합니다.

## Visual Style Mirror

The people-readable visual canon is owned by the Notion Visual Bible. The current approved direction is `SOFT_STORYBOOK_3D_DIORAMA`.

Implementation-facing summary:

- rounded, simplified, large-form stylized 3D silhouettes;
- soft matte / lightly painterly materials rather than photoreal PBR emphasis;
- stable horizon and low-to-medium environmental contrast;
- visible avatar + resting pet + personal boat + sea readable together in the normal 3/4 camera;
- readable functional contrast for text, buttons, and selection state;
- slow, bounded, predictable motion;
- decoration adds lived-in attachment without hiding the sea;
- Appreciation Camera remains the quieter sea/horizon-focused alternate view;
- do not reproduce identifiable Bondee / Animal Crossing / Spirit City / Garden Galaxy proportions, UI, branding, or trade dress.

Evidence boundary:

```text
VISUAL_STYLE_DIRECTION = APPROVED
REPRESENTATIVE_VISUAL_GDD_IMAGE = NOT_YET_PRODUCED
FINAL_AVATAR_ART = NOT_INTEGRATED
FINAL_PET_ART = NOT_INTEGRATED
FINAL_BOAT/SEA_ART = NOT_INTEGRATED
HUMAN_VISUAL_COMFORT_VALIDATION = NOT_RUN
```

## 핵심 감정

우선순위는 다음과 같습니다.

1. 편안함
2. 안정감
3. 잔잔함
4. 내 캐릭터·펫·보트에 대한 애착
5. 혼자 있지만 외롭지 않은 느낌
6. 부드러운 발견과 사람의 온기
7. 개인적인 기억이 공간에 쌓이는 느낌

## 핵심 약속

**목표는 이기는 것이 아니라 쉬는 것입니다.**

플레이어가 사진을 찍지 않고, 낚시를 하지 않고, 꾸미기·발견·상호작용을 지나쳐도 경험이 실패하지 않습니다. 파도와 바다, 보트의 미세한 흔들림, 보이는 플레이어와 옆에서 쉬는 펫만으로도 머물고 싶어야 합니다.

사운드는 장식이 아닙니다. **잔잔한 파도소리와 자연음은 화면을 적극적으로 보지 않을 때도 휴식 경험을 유지하는 핵심 콘텐츠**입니다. 음악은 선택 사항이며, 음악이 꺼져 있어도 경험이 성립해야 합니다.

## 플레이어 경험

플레이어는 오늘의 마음을 고르고 작은 보트 디오라마로 들어옵니다. 정상 화면에서는 자신의 기술용 Avatar, 펫, 보트와 바다가 함께 보입니다. 현재 구현 단계에서는 `PlayerAvatarPlaceholder`가 커스터마이즈 슬롯 계약만 제공하며 최종 아트가 아닙니다.

`Appreciation Mode`를 켜면 기존 sea-focused 카메라가 활성화되고 대부분의 비필수 UI가 숨겨집니다. 이 전환은 항해 시간·보상·사운드스케이프를 바꾸지 않습니다. Appreciation Camera의 마우스/화면 드래그 입력은 해당 카메라가 실제 활성 상태일 때만 동작해 정상 디오라마 터치를 빼앗지 않습니다.

항해 중 사진·속도조절·Ambient Discovery·조용한 낚시·보트 꾸미기·작은 상호작용은 모두 선택입니다. 시스템은 플레이어를 계속 호출하지 않고, 무시해도 손해가 없어야 합니다.

펫은 관리 대상이 아닙니다. 배고픔·청소·피로·방치 패널티 없이 바다를 바라보고, 눕고, 졸고, 가끔 플레이어를 보는 **정서적 동반자**입니다.

## 구현된 Local Boat Life 기술 Slice

### Boat Decoration

보트는 본디식 개인 공간처럼 점차 나만의 흔적이 쌓이는 장소가 됩니다. 첫 기술 구현은 자유배치 3D editor 대신 모바일에 적합한 **8개 slot-zone**을 사용합니다.

- `bow_left`
- `bow_right`
- `center_left`
- `center_right`
- `rear_left`
- `rear_right`
- `rail_accent`
- `pet_corner`

현재 starter decor는 `lantern / mug / cushion / plant / postcard / pet_cushion` 6종의 primitive technical placeholder입니다. 슬롯 호환성은 catalog가 소유하고, 유효하지 않은 배치는 저장 상태를 바꾸지 않습니다. 교체·비우기는 비용과 손실이 없습니다.

꾸미기 상태는 `GameState`에 `slot_id -> item_id`로 보관되어 **Scene 전환과 새 항해 동안 유지**되지만, 앱 종료/재실행을 넘는 save-file persistence는 아직 없습니다. 아이템에는 능력치·가격·희귀도 점수·재화·가챠·슬롯 완성 보너스가 없습니다.

### Low-pressure Interaction

펫·난간·현재 배치된 장식은 재사용 가능한 공통 계약을 사용합니다.

```text
get_actions(actor_context)
can_interact(actor_context, action_id)
perform(actor_context, action_id)
```

대표 행동은 펫 쓰다듬기/같이 바다 보기, 난간 기대기/바다 보기, 랜턴 불빛 바꾸기, 컵 들어보기 등입니다. 행동은 component-local posture/toggle 또는 차분한 메시지만 바꾸며, 호감도·항해 시간·사진·수집·보상·Appreciation 상태를 올리지 않습니다.

### BoatSpace + Compact UI

`BoatSpace`가 Boat/Avatar/Pet/Rail/DecorSlots의 공통 공간 owner가 되어 bob을 한 번만 적용합니다. 그래서 앞으로 장식 종류가 늘어도 각 child에 별도 동기화 코드를 추가하지 않습니다.

기술 UI는 기존 BottomPanel에 `꾸미기`와 `상호작용` 버튼 2개만 추가하고, 각 패널은 `OptionButton`으로 슬롯/아이템/대상/행동을 선택합니다. 8개 슬롯을 항상 화면에 노출하거나 자유 3D drag editor를 만들지 않았습니다. Appreciation Mode에서는 새 버튼이 숨겨지고 열린 패널도 닫히며, 감상 종료 후 자동 재오픈하지 않습니다.

현재 기술 상태:

```text
TECH_BOAT_DECORATION = PASS
LOW_PRESSURE_INTERACTABLE = PASS
BOAT_LIFE_TECH_UI = PASS
DECOR_HUMAN_USABILITY = NOT_RUN
REAL_MOBILE_DECOR_QA = NOT_RUN
FINAL_DECOR_ART = NOT_INTEGRATED
APP_RESTART_DECOR_PERSISTENCE = NOT_IMPLEMENTED
```

## 승인된 다음 확장

### Delayed Bottle Social

친구와 모르는 사람의 병편지는 실시간 채팅이 아니라 의도적으로 천천히 표류하는 보조 콘텐츠입니다.

- `FriendBottle`: 승인된 친구에게 지연 전달.
- `DriftBottle`: 조건을 통과한 16+ 사용자 사이의 제한적 낯선 편지.
- 수락된 편지는 정상 서버/네트워크에서 5분 이내 server-receivable 목표.
- 공개 피드·글로벌 채팅·온라인 상태·타이핑·읽음 표시·팔로워·랭킹은 만들지 않습니다.
- `DriftBottle`은 production moderation + Terms + 16+ gate + report/block + 운영 경로가 검증되기 전 공개 활성화하지 않습니다.

현재 상태: **설계 승인 / 서버·런타임 NOT_IMPLEMENTED**.

상세 설계는 `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md`를 따릅니다.

## 경험 보호선

새 기능은 아래를 모두 만족할 때만 핵심 경험에 들어옵니다.

- 아무것도 하지 않아도 편안하다.
- 무시해도 손해가 없다.
- 바다·파도·캐릭터·펫보다 UI/보상을 더 신경 쓰게 하지 않는다.
- 반복 파밍이나 효율 최적화가 최선의 플레이가 되지 않는다.
- 꾸미기가 인벤토리 관리나 능력치 최적화가 되지 않는다.
- 소셜은 즉답 압박이나 인기 경쟁을 만들지 않는다.
- 백엔드 장애가 기본 휴식 플레이를 막지 않는다.
- 1인 개발 유지비가 핵심 휴식 품질보다 커지지 않는다.

구현 세부 보호선은 `docs/RESTING_EXPERIENCE_BIBLE.md`와 승인된 Diorama/Bottle spec에 구조화해 mirror하며, 사람용 방향 변경은 Notion 정본에서 승인된 뒤 동기화합니다.

## 금지 방향

- 전투
- 체력, 피해, 사망
- 실패 조건
- 경쟁 점수 / 랭킹
- 강제 일일과제 / 체크리스트 압박
- 펫 배고픔·청소·피로·방치 패널티
- 반복 터치/낚시/상호작용 파밍을 핵심 성장으로 만드는 구조
- 꾸미기 능력치·희귀도 점수·가챠·daily-shop FOMO
- 결제
- 광고
- 실시간/글로벌/공개 채팅
- 공개 소셜 피드 / 팔로워 경쟁
- 사용자 위치 기반 매칭 / 데이팅
- 런타임 생성형 AI
