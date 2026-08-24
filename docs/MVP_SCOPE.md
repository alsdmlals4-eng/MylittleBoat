# MVP Scope

## 핵심 경험

`오늘의 마음 선택 → 3/4 보트 디오라마 → 보이는 캐릭터·펫과 쉬기 → 바다/파도소리에 머물기 → 작은 발견·선택형 낚시 → 기록·앨범 → 계속 머물기 또는 다음 항해`

목표는 이기는 것이 아니라 작은 보트와 바다에 **쉬러 오는 것**입니다. 꾸미기·상호작용·병편지는 이 감정을 강화할 때만 확장합니다.

### Rest-first acceptance

MVP가 궁극적으로 통과해야 하는 기준:

- 아무 조작 없이도 30초 이상 머물고 싶은가.
- 음악을 끄고 실제 파도/자연음만 들어도 공간이 성립하는가.
- 5분이 `CALM`으로 느껴지고 `EMPTY`나 `CHORES`로 변하지 않는가.
- 보이는 플레이어와 펫이 작은 보트 공간에 애착을 만드는가.
- 펫이 할 일을 만드는 존재가 아니라 곁에서 같이 쉬는 존재로 느껴지는가.
- 사진·낚시·발견·상호작용을 무시해도 손해나 불안이 없는가.
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

현재 normal play presentation은 기술적으로 **visible-avatar 3/4 boat diorama**로 마이그레이션되었습니다.

### 3/4 Diorama

- `VoyageWorld/DioramaCameraRig/DioramaCamera3D`가 normal play의 active camera다.
- `PlayerAvatarPlaceholder`가 보트 안에 보이는 기술용 플레이어 shell로 존재한다.
- Avatar는 `TECHNICAL_PLACEHOLDER=true`를 노출한다.
- 미래 cosmetic contract 슬롯은 `body / hair / top / bottom / head_accessory / accessory / color`이다.
- 현재 placeholder mesh는 final avatar art가 아니다.

### Appreciation Camera preserved

- 기존 sea-focused draggable view는 `AppreciationCameraRig/AppreciationCamera3D`로 보존된다.
- Appreciation Mode에서는 대부분의 비필수 UI를 숨기고 이 카메라가 current가 된다.
- normal diorama mode에서는 Appreciation Camera가 inactive다.
- inactive Appreciation Camera controller는 mouse/touch drag를 소비하지 않는다.
- camera mode toggle 자체는 voyage time, speed choice, 사진/풍경/편지/물고기 수를 변경하지 않는다.

현재 자동 evidence:

`TECH_DIORAMA_SHELL = PASS / VISIBLE_AVATAR_PLACEHOLDER = PASS / APPRECIATION_CAMERA = PASS / APPRECIATION_INPUT_ISOLATION = PASS`

Human visual comfort와 실제 모바일 터치/구도는 아직 `NOT_RUN`입니다.

## 현재 Resting Core Technical Prototype

### Technical soundscape

- `RestingSoundscape` AutoLoad가 메뉴/항해/앨범 Scene 전환에 유지된다.
- 런타임에서 4초 합성 `AudioStreamWAV`를 생성하고 `-16 dB`에서 loop한다.
- 합성 OceanBed는 `TECHNICAL_PROTOTYPE=true`이며 production 자연 파도 자산이 아니다.

### Technical resting pet

- `RestingPetPlaceholder`가 둥근 기술 mesh로 존재한다.
- 12~24초 저밀도 resting state와 아주 작은 호흡을 사용한다.
- 배고픔 / 청소 / 피로 / 방치 의무가 없다.

### Technical soft sea

- ocean roughness/밝기와 조명, 마음별 runtime 하늘을 soft-resting 기술 범위로 보호한다.

자동 evidence:

`TECH_RESTING_CORE = PASS`

아직 자동/기술 PASS로 승격하지 않는 것:

`AUDIO_REST_PASS / VISUAL_REST_PASS / PET_REST_PASS / MOBILE_REST_PASS = NOT_RUN`

## 승인됐지만 아직 구현하지 않은 MVP 시스템

### Boat Decoration

- 8개 slot-zone 방식부터 시작한다.
- 꾸미기는 기억과 자기표현이며 능력치/희귀도 최적화가 아니다.
- 자유 3D 배치는 첫 구현에서 제외한다.

상태: `BOAT_DECORATION = NOT_IMPLEMENTED`.

### Low-pressure Interactable

- 펫 / 난간 / 쿠션 / 랜턴 / 컵 / 앨범 / 낚싯대 / 병편지 스테이션을 공통 interaction 계약으로 확장한다.
- rapid-tap farming, 방치 손해, 강제 상호작용은 금지한다.

상태: `INTERACTABLE_RUNTIME = NOT_IMPLEMENTED`.

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
- NearWater부터 단계적으로 추가하고, 음악 OFF에서도 경험이 성립해야 한다.
- 큰 효과음/보상 징글/갑작스러운 고역을 피한다.

현재 production 자연 audio asset은 없다.

### Bondee-inspired storybook visual

- 둥글고 단순한 미니어처 3D 형태
- matte하고 부드러운 재질
- 본디식 개인 공간 감성 + 동화적인 바다/빛
- 안정적인 수평선과 낮은 시각 자극
- Avatar/Pet/Boat가 한 화면에 있지만 바다를 가리지 않는 구도

현재 Diorama/Avatar/Pet는 technical placeholder이며 최종 Visual PASS가 아니다.

## 우선 플랫폼

- 모바일 세로 화면 우선
- PC 지원
- Appreciation Camera의 mouse + `InputEventScreenDrag` 기술 계약 존재
- 실제 모바일 손감각/버튼 크기/구도/가독성은 `NOT_RUN`

## 현재 의도적으로 미포함

- 앱 재실행을 넘는 save file persistence
- 실제 사진 PNG 저장
- 제작 아바타/펫/보트/바다 최종 아트
- production 자연 오디오
- Boat Decoration runtime
- Interactable runtime
- FriendBottle / DriftBottle runtime
- Supabase Auth / DB / RLS / Edge Functions
- production moderation/report queue
- 어종 대량화
- 미끼 / 낚싯대 장비 / 줄 내구도
- 낚시 판매 / 요리 / 가격 / 경제
- 낚시 실패 패널티 / 경쟁 점수
- 고급 물 셰이더
- 실기기 모바일 Human QA 완료 주장

## 금지

- 전투
- 체력 / 피해 / 사망
- 실패 조건
- 경쟁 시스템 / 랭킹
- 강제 일일과제 / 체크리스트 압박
- 펫 배고픔 / 청소 / 피로 / 방치 패널티
- 반복 터치·낚시·상호작용 파밍을 핵심 성장으로 만드는 구조
- 실시간/글로벌/공개 채팅
- 공개 피드 / follower 경쟁 / 인기 점수
- 위치 기반 매칭 / 데이팅
- 사용자 미디어 첨부형 낯선 편지(MVP)
- 결제
- 광고
- 런타임 생성형 AI
- 유료 에셋 의존
- 복잡한 상점
