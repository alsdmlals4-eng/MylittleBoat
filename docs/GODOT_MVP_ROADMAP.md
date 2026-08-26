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
- `GameState` 저장
- 좋고/나쁜 날씨 판정 없이 하늘 톤만 미세 변경

## 3단계: Calm Voyage Vertical Slice — 완료

- 5분 항해
- 사진 / 감상 / 속도
- authored Ambient Discovery
- 조용한 선택형 낚시
- 항해 기록 / 앨범 / 동반자
- 다음 항해

## 4단계: 기술 검증 자동화 — 완료

- GitHub Actions Godot 4.7 stable
- headless import
- focused behavior contracts
- main menu / game / album Scene smoke

## 5단계: Rest-first Direction Contract — 완료

- wave-first soundscape
- 관리 의무 없는 resting pet
- soft sea + readable UI
- `CHORES / FARMING / FOMO` 보호선

## 6단계: Resting Core Authored Ocean Candidate — 구현 / Human 품질 미검증

- persistent `RestingSoundscape`
- 16초 stereo authored OceanBed
- soft ocean/light/mood-sky ceiling
- `RestingPetPlaceholder` 저밀도 idle

`AUTHORED_OCEAN_BED_RUNTIME = PASS`

`AUDIO_REST_HUMAN_LISTENING / VISUAL_REST_PASS / PET_REST_PASS = NOT_RUN`

## 7단계: Bondee Diorama + Delayed Bottle Architecture — 설계/계획 완료

승인된 제품 방향:

- normal play = visible player + pet + boat + sea의 3/4 Boat Diorama
- sea-focused Appreciation Camera 보존
- Boat Decoration = 8개 slot-zone 우선
- reusable low-pressure Interactable
- FriendBottle / DriftBottle = delayed correspondence
- core rest/voyage/decor/pet = local-first

소셜 상세 정본은 `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md`를 따른다.

## 8단계: Canon Migration + Diorama Shell — 기술 구현 완료 / Human visual QA 전

- `DioramaCamera3D` normal active
- visible `PlayerAvatarPlaceholder`
- Appreciation Camera preserved
- inactive Appreciation Camera input isolation
- Avatar/Pet/Boat deck composition shared bob

```text
TECH_DIORAMA_SHELL = PASS
VISIBLE_AVATAR_PLACEHOLDER = PASS
APPRECIATION_CAMERA = PASS
APPRECIATION_INPUT_ISOLATION = PASS
HUMAN_DIORAMA_COMFORT = NOT_RUN
FINAL_AVATAR_ART = NOT_INTEGRATED
REAL_MOBILE_CAMERA_INPUT = NOT_RUN
```

## 9단계: Local Boat Decoration + Low-pressure Interactable — 기술 구현 완료 / Human mobile QA 전

백엔드보다 먼저 **내 캐릭터·내 보트·내 펫이 생활하는 공간의 기술 구조**를 local-first로 구현했습니다.

### 9.1 BoatSpace owner

`BoatSpace` 아래에 BoatBow / Avatar / Pet / Rail / DecorSlots를 두고, drift bob은 parent에 한 번만 적용합니다. 장식이 늘어날 때 child별 bob 동기화 코드를 추가하지 않는 구조입니다.

### 9.2 8개 slot-zone

```text
bow_left
bow_right
center_left
center_right
rear_left
rear_right
rail_accent
pet_corner
```

starter technical decor:

```text
lantern
mug
cushion
plant
postcard
pet_cushion
```

- `BoatDecorCatalog`가 slot/category compatibility를 소유한다.
- invalid placement는 state mutation을 만들지 않는다.
- replace/clear는 비용·손실 없음.
- stats / rarity / price / currency / gacha / fill bonus / daily-shop pressure 없음.
- `GameState.boat_decor`는 `slot_id -> item_id`만 저장한다.
- Scene 전환과 새 항해에는 유지되지만 app restart persistence는 아직 없다.

### 9.3 Low-pressure Interactable

```text
get_actions(actor_context)
can_interact(actor_context, action_id)
perform(actor_context, action_id)
```

pet / rail / 현재 배치된 interactive decor가 같은 계약을 사용합니다. 상호작용은 local posture/toggle/message만 바꾸며 항해 시간·호감도·수집·기록·Appreciation state를 보상 루프로 사용하지 않습니다.

### 9.4 Compact technical UI

- BottomPanel에 `꾸미기`, `상호작용` 버튼 2개 추가.
- hidden DecorPanel / InteractionPanel.
- OptionButton으로 slot/item/target/action을 선택.
- compatible decor만 노출.
- 두 패널은 상호 배타적으로 열린다.
- Appreciation Mode에서 버튼과 패널 모두 숨김/닫힘.
- 감상 종료 후 패널 자동 재오픈 없음.
- 자유 3D drag placement는 실제 모바일 Human evidence 전까지 보류.

자동 상태:

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
APP_RESTART_DECOR_PERSISTENCE = AUTOMATED_LOCAL_RESTORE_PASS
```

## 10단계 진입 전 Current Priority Overlay · 2026-08-26

8월 25일 hand-painted visual canon/approved proof closeout 이후, completed `main`에서 가장 큰 증거 공백은 **승인된 visual direction과 실제 primitive runtime 사이**입니다. 따라서 현재 mainline next work는 아래 bounded proof입니다.

### First Production Visual Slice — Runtime capture + technical validation complete / Human review pending

```text
HANDPAINTED_STORYBOOK_3D_DIORAMA approved canon
→ actual game.tscn / BoatSpace bounded visual study
→ 540x960 Normal + Appreciation runtime capture
→ technical regression
→ 30s / 5m Human visual review (current gate)
```

범위:

- neutral player visual study. 최종 identity canonization 금지.
- non-species resting companion treatment. 최종 pet species canonization 금지.
- existing boat material/shape pass.
- existing dynamic decor rendering pass + small cluster through current decor system.
- existing sea/sky/light treatment.
- custom watercolor shader, broad asset replacement, four-state time behavior는 이번 Slice에서 제외.

현재 실제 Godot 제품 구현의 **첫 진입점**:

- `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md` — current Goal/보호 범위/evidence ceiling과 Codex 구현 방법 자율성의 stable router.

Supporting planning artifacts:

- `docs/superpowers/plans/2026-08-26-first-production-visual-slice.md`
- `docs/handoffs/2026-08-26-first-production-visual-slice-codex.md`
- `docs/research/2026-08-26-first-production-visual-slice-benchmark-evidence.md`

v1 plan/handoff의 정확한 Node 이름·테스트 형태는 planning example이며 current router의 outcome/acceptance/protected semantics가 우선합니다.

증거 ceiling:

```text
TECH_VISUAL_SLICE = PASS
NORMAL_540X960_RUNTIME_CAPTURE = PASS
APPRECIATION_540X960_RUNTIME_CAPTURE = PASS
HANDPAINTED_3D_RUNTIME_SLICE = USER_APPROVED_MERGED_MAIN
C_DOG_DEFAULT_RUNTIME_CAPTURE = PASS
C_DOG_HUMAN_VISUAL_APPROVAL = PASS
MOBILE_30S_VISUAL_REVIEW = NOT_RUN
MOBILE_5M_VISUAL_REVIEW = NOT_RUN
HUMAN_STYLE_APPROVAL = NOT_RUN
REAL_DEVICE_TOUCH_QA = DEFERRED_BY_USER
DEFAULT_AVATAR_C_VISUAL = USER_APPROVED_RUNTIME_PROOF_MERGED_MAIN
DEFAULT_DOG_VISUAL = USER_APPROVED_RUNTIME_PROOF_MERGED_MAIN
FINAL_AVATAR_ART = USER_APPROVED_NOTION_REGISTERED_LOCATOR_PASS
FINAL_PET_ART = USER_APPROVED_NOTION_REGISTERED_LOCATOR_PASS
FINAL_BOAT_SEA_ART = USER_APPROVED_NOTION_REGISTERED_LOCATOR_PASS
```

## 10단계: Social Fake Backend Contract — 독립 OPEN workstream / 현재 visual workstream에서는 READ_ONLY

PR #19 `Implement deterministic local social fake backend`에 local fake 구현과 과거 exact-head CI 증거가 존재하지만, 현재 completed `main`에서 갈라진 독립 workstream입니다.

현재 visual workstream에서는:

```text
READ_ONLY
NO_ABSORPTION
NO_REBASE
NO_MERGE
NO_CLOSE
```

Social 작업을 명시적으로 다시 시작할 때 latest completed `main`과 PR #19 exact head/CI/review/thread를 다시 reconcile합니다.

승인된 fake semantics:

- 16+ eligibility
- Friend Invite lifecycle
- FriendBottle delay state
- DriftBottle recipient acceptance
- no recipient → local draft
- stranger thread max 6 letters
- mutual friend gate
- block/report semantics
- offline draft
- healthy accepted delivery target 계산

실제 Supabase 호출/secret은 아직 current main에 넣지 않습니다.

## 11단계: Supabase Backend / Auth / RLS / Edge Functions — 예정

Social Fake 계약이 future current main에 안전하게 정합된 뒤 실제 backend adapter를 구현합니다.

- auth / account link
- profiles / consent / invites / friendships / threads / bottles / blocks / reports
- RLS
- server rate limit
- server-generated recipient/matching
- `deliver_at` server timestamp
- provider/service-role secret client 금지

## 12단계: Production Moderation + Social Safety Release Gate — 예정

`DriftBottle` public flag는 아래가 실제 배포·테스트되기 전 OFF입니다.

- Terms / Community Guidelines
- 16+ gate
- deterministic URL/contact filter
- semantic moderation
- report / block / local hide
- moderation queue
- developer support
- retention/deletion policy
- audit receipt

## 13단계: Real Delayed Bottle Integration — 예정

- FriendBottle / DriftBottle
- polling 20~30 sec
- offline draft
- friendship conversion
- delivery evidence
- backend 장애 시 local rest/voyage/decor 정상 유지

## 14단계: Production Resting Assets — First Production Visual Slice 증거 뒤 재계산

### Audio

- 실제 자연 OceanBed A/B 청취
- source/license/hash readback
- selected OceanBed integration
- NearWater 1개부터 추가

### Visual

- First Production Visual Slice 결과를 기준으로 final asset pipeline 결정
- four-state `새벽 / 밝음 / 해질녘 / 밤` atmosphere layer는 별도 bounded Slice
- final player identity / pet species는 별도 승인 결정
- representative final decor / boat / sea assets는 runtime proof 뒤 제작

이미지 제작은 `텍스트 brief → 명시 승인 → 1건 제작` 순서를 유지합니다.

## 15단계: Human / Real-device Validation

1. 3/4 portrait에서 Avatar + Pet + Boat + Decor + Sea가 편안하게 읽히는가.
2. 장식이 바다를 과하게 가리지 않는가.
3. 꾸미기 패널이 모바일에서 작고 이해하기 쉬운가.
4. 8-slot 방식이 답답하지 않고 충분한 자기표현을 주는가.
5. 직접 3D drag editor가 정말 필요한가.
6. 상호작용이 `CHORES`/reward farming이 아니라 작은 생활감으로 느껴지는가.
7. Appreciation Camera 전환과 신규 panel이 충돌하지 않는가.
8. 첫 30초/5분이 `CALM`인가 `EMPTY`인가.
9. 미래 병편지가 instant messenger가 아니라 ambient human warmth로 느껴지는가.
10. backend가 죽어도 local rest/voyage/decor가 정상인가.

Human evidence 전에는 visual/audio/decor/social 감정 품질을 완료로 주장하지 않습니다.
