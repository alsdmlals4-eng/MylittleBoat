# MVP Scope

## 핵심 경험

`오늘의 마음 선택 → 3/4 보트 디오라마 → 보이는 캐릭터·펫과 쉬기 → 선택형 꾸미기·작은 상호작용 → 바다/파도소리에 머물기 → 작은 발견·선택형 낚시 → 기록·앨범 → 계속 머물기 또는 다음 항해`

목표는 이기는 것이 아니라 작은 보트와 바다에 **쉬러 오는 것**입니다. 꾸미기·상호작용·병편지는 이 감정을 강화할 때만 확장합니다.

### Rest-first acceptance

MVP가 궁극적으로 통과해야 하는 기준:

- 아무 조작 없이도 30초 이상 머물고 싶은가.
- 음악을 끄고 실제 파도/자연음만 들어도 공간이 성립하는가.
- 5분이 `CALM`으로 느껴지고 `EMPTY`나 `CHORES`로 변하지 않는가.
- 보이는 플레이어와 펫, 작은 꾸미기가 보트 공간에 애착을 만드는가.
- 펫이 할 일을 만드는 존재가 아니라 곁에서 같이 쉬는 존재로 느껴지는가.
- 사진·낚시·발견·꾸미기·상호작용을 무시해도 손해나 불안이 없는가.
- 미래 병편지가 즉답 압박이나 랜덤채팅 느낌보다 천천히 도착하는 사람의 온기로 느껴지는가.

제작 아트/자연 오디오/실제 캐릭터·펫 자산과 실기기 Human playtest 전에는 감정 품질을 `PASS`로 표시하지 않습니다.

## 현재 구현된 Vertical Slice

- 마음 선택 4종: 평온 / 지침 / 외로움 / 설렘
- 마음을 좋고/나쁜 날씨로 판정하지 않는 미세한 하늘 톤 변화
- 모바일 세로 화면 우선 UI
- Scene 전환에도 이어지는 5분 항해 타이머
- 사진찍기
- 느림 / 보통 / 빠름의 미세 표류 리듬 속도조절
- Ambient Discovery: authored 병 속 편지 / 풍경 기록
- 실패 없는 선택형 조용한 낚시
- 오늘의 항해 기록
- 같은 실행 세션 동안 누적되는 사진 / 풍경 / 편지 / 물고기 / 항해 기록
- 사진·풍경·편지 기억에 따른 동반자 호감도 Lv 1~3
- 앨범 기본 구조

## Canon Migration + Diorama Shell — 기술 구현

- `VoyageWorld/DioramaCameraRig/DioramaCamera3D`가 normal play active camera다.
- `PlayerAvatarPlaceholder`가 기술용 visible player shell이다.
- 기존 sea-focused draggable view는 `AppreciationCameraRig/AppreciationCamera3D`로 보존된다.
- inactive Appreciation Camera는 mouse/touch drag를 소비하지 않는다.
- camera mode toggle 자체는 voyage time, speed choice, rewards를 변경하지 않는다.

자동 evidence:

`TECH_DIORAMA_SHELL = PASS / VISIBLE_AVATAR_PLACEHOLDER = PASS / APPRECIATION_CAMERA = PASS / APPRECIATION_INPUT_ISOLATION = PASS`

Human visual comfort와 실제 모바일 터치/구도는 `NOT_RUN`입니다.

## Local Boat Decoration + Low-pressure Interaction — 기술 구현

### BoatSpace

- `VoyageWorld/BoatSpace`가 BoatBow / Avatar / Pet / Rail / DecorSlots를 함께 소유한다.
- drift bob은 BoatSpace에 한 번만 적용해 child 상대 위치를 유지한다.
- 새 장식마다 bob 동기화 코드를 추가하지 않는다.

### 8개 slot-zone

정확히 다음 여덟 슬롯을 사용한다.

1. `bow_left`
2. `bow_right`
3. `center_left`
4. `center_right`
5. `rear_left`
6. `rear_right`
7. `rail_accent`
8. `pet_corner`

starter technical decor는 `lantern / mug / cushion / plant / postcard / pet_cushion`이다. 모두 Godot primitive mesh 기반 placeholder이며 final art가 아니다.

- 슬롯 호환성은 `BoatDecorCatalog`가 소유한다.
- invalid placement는 저장 상태를 바꾸지 않는다.
- replace/clear는 비용·손실이 없다.
- 가격, 재화, 능력치, rarity score, gacha, fill bonus, daily-shop FOMO가 없다.
- `GameState.boat_decor`는 `slot_id -> item_id`만 저장한다.
- Scene 전환과 새 항해에는 유지되지만 앱 재시작 persistence는 아직 없다.

### Low-pressure Interactable

공통 계약:

```text
get_actions(actor_context)
can_interact(actor_context, action_id)
perform(actor_context, action_id)
```

현재 pet / rail / 배치된 interactive decor가 같은 계약으로 라우팅된다. 대표 행동은 쓰다듬기, 같이 바다 보기, 기대기, 랜턴 불빛 바꾸기, 컵 들어보기 등이며, 행동 자체는 affection, timer, speed, photo/scenery/letter/fish/voyage-record reward를 만들지 않고 Appreciation 상태도 강제로 바꾸지 않는다.

### Compact technical UI

- 기존 BottomPanel에 `꾸미기`, `상호작용` 버튼만 추가한다.
- DecorPanel과 InteractionPanel은 기본 hidden이다.
- OptionButton으로 slot/item/target/action을 선택해 8개 슬롯을 항상 화면에 펼치지 않는다.
- 호환 가능한 decor만 선택지에 노출한다.
- 두 패널은 서로 동시에 열리지 않는다.
- Appreciation Mode 진입 시 새 버튼이 숨겨지고 열린 패널도 닫힌다.
- 감상 종료 후 패널을 자동 재오픈하지 않는다.
- 자유 3D drag/tap placement editor는 실제 모바일 Human evidence 전까지 보류한다.

현재 자동 evidence:

```text
TECH_BOAT_DECORATION = PASS
LOW_PRESSURE_INTERACTABLE = PASS
BOAT_LIFE_TECH_UI = PASS
```

증거 ceiling:

```text
DECOR_HUMAN_USABILITY = NOT_RUN
REAL_MOBILE_DECOR_QA = NOT_RUN
FINAL_DECOR_ART = NOT_INTEGRATED
APP_RESTART_DECOR_PERSISTENCE = NOT_IMPLEMENTED
```

## Resting Core Technical Prototype

- persistent `RestingSoundscape` AutoLoad
- generated 4초 `AudioStreamWAV` OceanBed / `-16 dB` / loop
- `RestingPetPlaceholder` 12~24초 저밀도 idle / care obligation 없음
- soft ocean/light/mood-sky 기술 ceiling

자동 evidence: `TECH_RESTING_CORE = PASS`.

`AUDIO_REST_PASS / VISUAL_REST_PASS / PET_REST_PASS / MOBILE_REST_PASS = NOT_RUN`.

## 승인됐지만 아직 구현하지 않은 Social 시스템

### FriendBottle / DriftBottle

- 모든 MVP 온라인 소셜은 16+.
- FriendBottle과 DriftBottle은 실시간 채팅이 아닌 delayed correspondence다.
- 수락된 편지는 healthy backend/network에서 server-receivable 5분 이내 목표.
- 공개 feed/global chat/presence/typing/read receipt/follower/ranking 없음.
- DriftBottle은 production moderation, Terms, age gate, report/block, 운영 경로가 검증되기 전 공개 OFF.

상태:

`FRIEND_BOTTLE = NOT_IMPLEMENTED / DRIFT_BOTTLE = NOT_IMPLEMENTED / SOCIAL_BACKEND = NOT_IMPLEMENTED`

세부 정본: `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md`.

## Production 목표 — 아직 Human PASS 아님

### Wave-first soundscape

- 실제 잔잔한 자연 파도 `OceanBed`를 핵심 소리로 둔다.
- NearWater부터 단계적으로 추가한다.
- 음악 OFF에서도 경험이 성립해야 한다.
- 큰 효과음/보상 징글/갑작스러운 고역을 피한다.

현재 production 자연 audio asset은 없다.

### Bondee-inspired storybook visual

- 둥글고 단순한 미니어처 3D 형태
- matte하고 부드러운 재질
- 개인 공간 감성 + 동화적인 바다/빛
- 안정적인 수평선과 낮은 시각 자극
- Avatar/Pet/Decor가 한 화면에 있지만 바다를 가리지 않는 구도

현재 Avatar/Pet/Decor/Sea는 technical placeholder이며 최종 Visual PASS가 아니다.

## 우선 플랫폼

- 모바일 세로 화면 우선
- PC 지원
- Appreciation Camera mouse + `InputEventScreenDrag` 기술 계약 존재
- 실제 모바일 손감각/버튼 크기/구도/가독성은 `NOT_RUN`

## 현재 의도적으로 미포함

- 앱 재실행을 넘는 save-file persistence
- 자유배치 3D decor editor / 직접 3D drag placement
- 제작 아바타/펫/보트/장식/바다 최종 아트
- production 자연 오디오
- FriendBottle / DriftBottle runtime
- Supabase Auth / DB / RLS / Edge Functions
- production moderation/report queue
- 실제 사진 PNG 저장
- 어종 대량화 / 미끼 / 장비 / 판매 / 요리 / 낚시 경제
- 낚시 실패 패널티 / 경쟁 점수
- 고급 물 셰이더
- 실기기 모바일 Human QA 완료 주장

## 금지

- 전투 / 체력 / 피해 / 사망
- 실패 조건
- 경쟁 시스템 / 랭킹
- 강제 일일과제 / 체크리스트 압박
- 펫 배고픔 / 청소 / 피로 / 방치 패널티
- 반복 터치·낚시·상호작용 파밍을 핵심 성장으로 만드는 구조
- 꾸미기 stats / rarity score / gacha / daily-shop FOMO
- 실시간/글로벌/공개 채팅
- 공개 피드 / follower 경쟁 / 인기 점수
- 위치 기반 매칭 / 데이팅
- 사용자 미디어 첨부형 낯선 편지(MVP)
- 결제 / 광고
- 런타임 생성형 AI
- 유료 에셋 의존
- 복잡한 상점
