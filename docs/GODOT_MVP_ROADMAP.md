# Godot MVP Roadmap

`my little boat` Godot MVP를 **핵심 감정이 실제 플레이에서 작동하는지 검증하는 순서**로 진행합니다.

> **Authority:** 사람용 기획·경험·시각 방향은 Notion 정본에서 승인합니다. 이 로드맵은 승인된 방향을 repository 구현·검증 단계로 옮기는 execution mirror입니다. 기술 GREEN은 Human/player experience PASS가 아닙니다.

## 1단계: 프로젝트 골격 — 완료

- `project.godot`
- `main_menu.tscn`, `game.tscn`, `album.tscn`
- Godot 4.7 stable / GDScript
- mobile portrait 우선 구조

## 2단계: 마음 선택 — 완료

- 평온 / 지침 / 외로움 / 설렘
- `GameState`에 선택 저장
- 좋고/나쁜 날씨 판정 없이 하늘 톤만 미세하게 변경
- 새 항해가 기존 실행 세션 기억을 지우지 않음

## 3단계: Calm Voyage Vertical Slice — 완료

- Scene 전환에도 이어지는 5분 항해
- 사진찍기
- 감상모드
- 속도조절
- authored Ambient Discovery
- 선택형 조용한 낚시
- 오늘의 항해 기록
- 앨범 / 동반자 호감도
- 다음 항해

## 4단계: 기술 검증 자동화 — 완료

- GitHub Actions Godot 4.7 stable
- `actions/checkout@v7`
- headless import
- 집중 behavior contracts
- main menu / game / album Scene smoke

## 5단계: Rest-first Direction Contract — 완료

- `docs/RESTING_EXPERIENCE_BIBLE.md`
- wave-first soundscape
- 관리 의무 없는 resting pet
- soft sea + readable UI
- `CHORES / FARMING / FOMO` 보호선

## 6단계: Resting Core Technical Prototype — 완료 / Human 품질 미검증

### 기술 구조

- persistent `RestingSoundscape` AutoLoad
- 4초 generated `AudioStreamWAV` OceanBed / `-16 dB` / loop
- `TECHNICAL_PROTOTYPE=true`
- ocean roughness/밝기 + light + runtime mood sky 기술 ceiling
- `RestingPetPlaceholder` 12~24초 저밀도 idle
- pet `has_care_obligation=false`

자동 상태:

`TECH_RESTING_CORE = PASS`

품질 상태:

`AUDIO_REST_PASS = NOT_RUN / VISUAL_REST_PASS = NOT_RUN / PET_REST_PASS = NOT_RUN`

## 7단계: Bondee Diorama + Delayed Bottle Architecture — 설계/계획 완료

승인된 제품 방향:

- normal play = visible player + pet + boat + sea의 **3/4 Boat Diorama**
- 기존 바다 중심 view = **Appreciation Camera**로 보존
- Boat Decoration = 8개 slot-zone 우선
- low-pressure reusable `Interactable`
- FriendBottle / DriftBottle = delayed correspondence
- core rest/voyage/decor/pet = local-first

소셜 설계 핵심:

- MVP online social 16+
- message max 400 chars + curated sticker 1개
- no public user directory / presence / typing / read receipt / feed / follower / ranking
- accepted bottle healthy target `<= 5 minutes`
- deliberate delay `45..210 sec`, active polling `20..30 sec`
- `poll-inbox`가 `deliver_at <= server_now`를 availability로 판정
- no eligible stranger recipient이면 전송을 accept하지 않고 local draft 유지
- stranger thread 최대 6통 후 mutual friendship gate
- Friend Invite = server-generated 8-char / 24h / one-time + invitee redemption + inviter confirmation
- Supabase Auth + Postgres/RLS + Edge Functions selected for MVP
- DriftBottle public flag는 production moderation + Terms + report/block + 운영 evidence 전까지 OFF

정본:

- `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md`
- `docs/superpowers/plans/2026-08-24-canon-migration-diorama-shell.md`

## 8단계: Canon Migration + Diorama Shell — 기술 구현 완료 / Human visual QA 전

이번 단계는 제품 설계를 실제 Scene/계약으로 옮기는 첫 구현 Slice입니다.

### 운영 정본

- `AGENTS.md`의 기존 `first-person only / invisible player / blanket online-letter prohibition`을 폐기했다.
- normal presentation을 visible-avatar 3/4 diorama로 명시했다.
- online은 approved delayed bottle subsystem에만 좁게 허용하며 realtime/global/public chat은 계속 금지한다.

### Diorama normal camera

- `VoyageWorld/DioramaCameraRig/DioramaCamera3D`
- normal mode에서 `current=true`
- fixed elevated 3/4 technical framing
- speed 선택에 따른 아주 작은 drift feedback

### Visible Avatar shell

- `PlayerAvatarPlaceholder`
- `TECHNICAL_PLACEHOLDER=true`
- future cosmetic-slot contract:
  - body
  - hair
  - top
  - bottom
  - head_accessory
  - accessory
  - color

현재 primitive mesh는 최종 캐릭터 아트가 아니다.

### Appreciation Camera preservation

- 기존 draggable camera를 `AppreciationCameraRig/AppreciationCamera3D`로 보존
- 감상모드에서만 current
- 대부분의 비필수 UI를 숨김
- voyage time / rewards / soundscape에 영향 없음
- controller는 Appreciation camera가 `current`일 때만 mouse/touch drag를 처리
- normal diorama mode에서 touch input을 훔치지 않음

자동 상태:

```text
TECH_DIORAMA_SHELL = PASS
VISIBLE_AVATAR_PLACEHOLDER = PASS
APPRECIATION_CAMERA = PASS
APPRECIATION_INPUT_ISOLATION = PASS
```

남은 증거:

```text
HUMAN_DIORAMA_COMFORT = NOT_RUN
FINAL_AVATAR_ART = NOT_INTEGRATED
REAL_MOBILE_CAMERA_INPUT = NOT_RUN
```

## 9단계: Local Boat Decoration + Interactable — 다음 구현 단계

백엔드를 붙이기 전에 **내 캐릭터·내 보트·내 펫이 생활하는 공간의 재미**를 local-only로 먼저 검증합니다.

### Boat Decoration MVP

8개 slot-zone:

1. bow-left
2. bow-right
3. center-left
4. center-right
5. rear-left
6. rear-right
7. rail accent
8. pet corner

첫 대표 소품은 적은 수로 시작합니다. 예:

- lantern
- mug
- cushion
- blanket
- plant
- framed memory
- shell/postcard
- pet cushion

보호선:

- 능력치 없음
- rarity score 없음
- 슬롯을 모두 채우는 최적화 보상 없음
- gacha/daily-shop pressure 없음

### Interactable MVP

재사용 계약으로 대표 3~4개만 먼저 검증합니다.

```text
Interactable
- get_actions(actor_context)
- can_interact(actor_context, action_id)
- perform(actor_context, action_id)
```

초기 예:

- pet → 쓰다듬기 / 같이 보기
- rail → 기대기 / 바다 보기
- cup → 들기 / 내려놓기
- lantern → 켜기 / 끄기

상태:

`BOAT_DECORATION = NOT_IMPLEMENTED / INTERACTABLE_RUNTIME = NOT_IMPLEMENTED`

## 10단계: Social Fake Backend Contract — 예정

실제 서버를 연결하기 전에 Godot 로컬 fake로 social semantics를 TDD합니다.

검증할 것:

- 16+ eligibility
- Friend Invite lifecycle
- FriendBottle delay state
- DriftBottle recipient acceptance semantics
- no-recipient → local draft
- 6-letter stranger cap
- mutual friend gate
- block/report behavior
- offline draft
- healthy accepted delivery target 계산

실제 Supabase 호출/secret 없음.

## 11단계: Supabase Backend / Auth / RLS / Edge Functions — 예정

Social Fake 계약이 안정된 뒤 실제 backend adapter를 구현합니다.

- anonymous Auth
- email OTP link
- profiles / consent / invites / friendships / threads / bottles / blocks / reports
- RLS
- server rate limit
- server-generated recipient/matching
- `deliver_at` server timestamp
- no secret in Godot

공개 출시 전 Free-plan pause/limit가 5분 목표와 충돌하는지 별도 Deployment Gate를 다시 확인합니다.

## 12단계: Production Moderation + Social Safety Release Gate — 예정

`DriftBottle`은 아래가 실제 배포·테스트되기 전 public OFF입니다.

- Terms / Community Guidelines
- 16+ gate
- URL/contact deterministic filter
- production semantic moderation
- report content/user
- block
- immediate local hide
- moderation queue
- developer support/contact
- retention/deletion policy
- audit receipt

## 13단계: Real Delayed Bottle Integration — 예정

fake adapter와 동일한 Godot client contract 아래 real backend adapter를 연결합니다.

- FriendBottle
- DriftBottle
- polling 20~30 sec
- offline draft
- friendship conversion
- delivery evidence
- server/backend failure가 local rest를 막지 않는지 검증

## 14단계: Production Resting Assets — 병렬/후속 제작

실제 제품 품질을 위한 자산 단계입니다.

### Audio

1. 실제 자연 `OceanBed A/B` 청취
2. source/license/hash readback
3. 선택된 OceanBed를 persistent soundscape에 교체
4. `NearWater` 1개 추가 후 재검증

### Visual

- Bondee-inspired storybook diorama production color study
- rounded/matte player avatar
- 첫 실제 pet 1종
- boat material / representative decor
- calm sea / sky / horizon

이미지 작업은 프로젝트 Visual 정책대로 `텍스트 brief → 명시 승인 → 1건 제작` 순서를 유지합니다.

## 15단계: Human / Real-device Validation

실제 제작 자산과 주요 시스템이 들어간 뒤 확인합니다.

1. 3/4 portrait에서 Avatar + Pet + Boat + Sea가 편안하게 읽히는가.
2. Avatar/Pet/Decor가 바다를 과하게 가리지 않는가.
3. normal diorama → Appreciation Camera 전환이 자연스러운가.
4. 실제 모바일에서 normal touch와 Appreciation drag가 충돌하지 않는가.
5. 첫 30초에 아무것도 하지 않아도 머물고 싶은가.
6. 음악 OFF + 실제 파도만으로 공간이 성립하는가.
7. 5분이 `CALM`인가 `EMPTY`인가.
8. Decoration/Interaction이 `CHORES`나 최적화 압박으로 느껴지지 않는가.
9. 병편지가 instant messenger가 아니라 ambient human warmth로 느껴지는가.
10. 신고/차단이 필요할 때 쉽게 찾을 수 있는가.
11. healthy real network에서 accepted bottle delivery target이 측정되는가.
12. backend가 죽어도 local rest/voyage/decor가 정상 플레이 가능한가.

### 검증 환경

- 헤드폰
- 일반 PC/노트북 스피커
- 모바일 스피커
- 실제 모바일 세로 화면
- healthy / degraded / offline network conditions

Human evidence 전에는 visual/audio/social 감정 품질을 완료로 주장하지 않습니다.
