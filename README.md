# my little boat - Godot MVP

`my little boat`는 **본디에서 참고한 작고 둥근 3D 디오라마 감성**을 바탕으로, 작은 보트에서 보이는 플레이어 캐릭터와 펫이 함께 쉬고 생활하며 잔잔한 바다·파도소리·작은 기억을 쌓는 rest-first 힐링 항해 게임입니다.

이 저장소는 **Godot 4.7 stable + GDScript** 기준입니다. 전투·실패·경쟁·광고·결제·실시간/공개 소셜 압박은 핵심 방향에서 제외합니다. 온라인 기능은 승인된 delayed FriendBottle / DriftBottle 범위와 그 안전 운영에만 한정하며, 기본 휴식 게임은 local-first로 유지합니다.

> **Authority:** 사람용 프로젝트 개요·경험·시각·에셋 방향의 최신 승인 정본은 Notion입니다. 이 저장소 문서는 그 방향을 코드·Scene·Test가 소비하도록 옮긴 implementation mirror/contract이며, 실제 런타임 사실은 repository 구현과 실행 증거가 우선합니다.

## 프로젝트 열기

1. Godot 4.7 stable을 실행합니다.
2. `Import`에서 이 폴더의 `project.godot`을 선택합니다.
3. 실행하거나 `scenes/main_menu.tscn`에서 시작합니다.

## 핵심 방향

- normal play는 **visible avatar + pet + boat + decor + sea가 함께 보이는 3/4 Boat Diorama**입니다.
- `Appreciation Camera`는 바다와 수평선 중심의 low-UI 감상 경험을 보존합니다.
- 파도/자연음은 BGM보다 우선하는 핵심 콘텐츠입니다.
- 펫은 care obligation이 없는 resting companion입니다.
- 사진·낚시·발견·꾸미기·상호작용은 전부 선택형이며 무시해도 손해가 없어야 합니다.
- 꾸미기는 능력치나 rarity가 아니라 기억과 자기표현입니다.
- 미래 병편지는 실시간 채팅이 아니라 delayed correspondence입니다.

## 현재 구현된 Slice

### Calm Voyage

- 오늘의 마음 4종
- Scene 전환에도 이어지는 5분 항해
- 사진 / 감상모드 / 속도조절
- authored Ambient Discovery
- 실패 없는 선택형 낚시
- 항해 기록 / 앨범 / 동반자

### Resting Core Technical Prototype

- persistent `RestingSoundscape` AutoLoad
- generated technical OceanBed
- soft sea/light/mood-sky 기술 경계
- 관리 의무 없는 `RestingPetPlaceholder`

### 3/4 Diorama Shell

- normal `DioramaCamera3D`
- visible `PlayerAvatarPlaceholder`
- preserved `AppreciationCamera3D`
- inactive Appreciation Camera mouse/touch input isolation

### Local Boat Decoration + Low-pressure Interaction

`BoatSpace`가 BoatBow / Avatar / Pet / Rail / DecorSlots를 함께 소유하며 drift bob을 한 번만 받습니다.

8개 slot-zone:

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

6개 starter technical decor:

```text
lantern
mug
cushion
plant
postcard
pet_cushion
```

- `BoatDecorCatalog`가 slot/item compatibility를 소유합니다.
- invalid placement는 state를 바꾸지 않습니다.
- replace/clear는 비용·손실이 없습니다.
- stats / rarity / price / currency / gacha / fill bonus / daily-shop FOMO가 없습니다.
- `GameState.boat_decor`에는 `slot_id -> item_id`만 저장합니다.
- Scene 전환과 새 항해에는 유지되지만 앱 재시작 저장은 아직 없습니다.
- primitive mesh는 **TECHNICAL_PLACEHOLDER**이며 final art가 아닙니다.

공통 low-pressure interaction 계약:

```text
get_actions(actor_context)
can_interact(actor_context, action_id)
perform(actor_context, action_id)
```

현재 pet / rail / placed interactive decor가 같은 계약을 사용합니다. 상호작용은 local posture/toggle/message만 바꾸며 affection, timer, rewards, voyage records를 만들지 않고 Appreciation 상태도 강제로 바꾸지 않습니다.

기술 UI:

- BottomPanel의 `꾸미기`, `상호작용` 버튼 2개
- hidden DecorPanel / InteractionPanel
- OptionButton으로 slot/item/target/action 선택
- compatible item만 노출
- 패널 상호 배타적 open
- Appreciation Mode에서 새 버튼 hide + 열린 panel close
- 감상 종료 후 panel 자동 재오픈 없음
- 자유 3D drag placement는 Human mobile evidence 전까지 defer

### Social Fake Backend Contract

실제 서버·계정·네트워크를 연결하기 전에 approved delayed-bottle product contract만 Godot 내부에서 deterministic하게 재현합니다.

- `scripts/social/social_session_fake.gd`는 `local_only / anonymous_social / linked_social`, 16+ 및 Drift eligibility를 fake state로 재현합니다.
- `scripts/social/bottle_client_fake.gd`는 순수 `RefCounted` in-memory fake이며 `HTTPRequest`, WebSocket, Supabase, secret을 사용하지 않습니다.
- accepted bottle은 configurable deterministic delay를 사용하되 승인 범위 `45..210초` 안으로 clamp됩니다.
- `advance_time()` + `poll_inbox()`로 CI가 실제 시간을 기다리지 않고 `deliver_at` 경계를 검증합니다.
- recipient가 없는 DriftBottle은 `NO_RECIPIENT_AVAILABLE`이며 accepted/send로 취급하지 않고 local draft를 보존합니다.
- stranger thread는 6통 이후 `friendship_gate`가 되고 7번째 stranger message는 거부됩니다.
- 400 Unicode chars는 허용하고 401 chars는 거부하는 기술 계약이 있습니다.
- fake record에는 typing/presence/read receipt/public feed/follower/ranking 의미를 넣지 않습니다.
- fake social 호출은 voyage timer, appreciation, affection, album memories, fishing, boat decor를 변경하지 않습니다.

이 Slice는 **실제 소셜 기능 구현이 아닙니다.** Auth/RLS/DB/Edge Function/moderation/report/block/network delivery는 아직 없습니다.

현재 기술 evidence:

```text
TECH_DIORAMA_SHELL = PASS
APPRECIATION_INPUT_ISOLATION = PASS
TECH_RESTING_CORE = PASS
TECH_BOAT_DECORATION = PASS
LOW_PRESSURE_INTERACTABLE = PASS
BOAT_LIFE_TECH_UI = PASS
SOCIAL_FAKE_BACKEND = PASS
```

증거 ceiling:

```text
DECOR_HUMAN_USABILITY = NOT_RUN
REAL_MOBILE_DECOR_QA = NOT_RUN
FINAL_DECOR_ART = NOT_INTEGRATED
APP_RESTART_DECOR_PERSISTENCE = NOT_IMPLEMENTED
PRODUCTION_OCEAN_AUDIO = NOT_INTEGRATED
HUMAN_SOCIAL_USABILITY = NOT_RUN
FRIEND_BOTTLE_REAL_NETWORK = NOT_IMPLEMENTED
DRIFT_BOTTLE_REAL_NETWORK = NOT_IMPLEMENTED
SUPABASE_AUTH_RLS_EDGE = NOT_IMPLEMENTED
PRODUCTION_MODERATION_SAFETY = NOT_IMPLEMENTED
```

## 현재 구조

```text
scenes/
  main_menu.tscn
  game.tscn
  boat_space.tscn
  album.tscn
scripts/
  audio/resting_soundscape.gd
  avatar/player_avatar_placeholder.gd
  core/game_state.gd
  decor/boat_decor_catalog.gd
  decor/boat_decor_slot.gd
  interaction/low_pressure_interactable.gd
  social/social_session_fake.gd
  social/bottle_client_fake.gd
  voyage/boat_rail_interactable.gd
  voyage/boat_camera_controller.gd
  voyage/resting_pet_placeholder.gd
  voyage/fishing_session.gd
  voyage/game_scene.gd
tests/
  test_calm_voyage_state.gd
  test_fishing_session.gd
  test_game_scene_contract.gd
  test_album_memory_contract.gd
  test_camera_input_contract.gd
  test_resting_core_contract.gd
  test_diorama_avatar_camera_contract.gd
  test_boat_decoration_contract.gd
  test_low_pressure_interaction_contract.gd
  test_boat_life_scene_contract.gd
  test_boat_life_ui_contract.gd
  test_social_fake_backend_contract.gd
```

## 자동 검증

PR에서 Godot 4.7 stable로 다음을 실행합니다.

```text
headless project import
→ calm voyage state
→ fishing
→ game scene
→ album memory
→ Appreciation Camera input/isolation
→ Resting Core
→ Diorama Avatar Camera
→ boat decoration
→ low-pressure interaction
→ boat life scene
→ boat life UI
→ social fake backend contract
→ main menu / game / album Scene smoke
```

자동 검증은 기술 동작을 증명하지만 실제로 예쁘고 편안하며 모바일에서 쓰기 좋은지, 실제 소셜이 안전하고 이해 가능한지는 증명하지 않습니다.

## 다음 구현 순서

1. **Real backend implementation readiness** — current fake interface를 기준으로 실제 provider adapter가 필요한 최소 API/schema/RLS/Edge Function/secret boundary를 구현계획으로 확정합니다.
2. **Supabase/Auth/RLS/Edge Functions** — 보안·계정 권한 Gate 후 실제 adapter 구현.
3. **Moderation/Safety release gate** — DriftBottle public enable 전 실제 Terms/age/report/block/moderation 운영 검증.
4. **Real Delayed Bottle integration**.
5. Production audio/visual/pet/decor art와 Human/mobile validation.

실제 Supabase project 생성, 계정 연결, secret/API key 취급, public social enable은 이 README의 기술 fake PASS만으로 자동 승인하지 않습니다.

## Human 검증 — 아직 NOT_RUN

- 3/4 portrait에서 Avatar + Pet + Boat + Decor + Sea가 편안하게 읽히는가.
- 8-slot 방식이 모바일에서 이해하기 쉽고 충분한 자기표현을 주는가.
- OptionButton 기반 panel이 방해가 되지 않는가.
- 자유 3D drag placement가 실제로 필요한가.
- 상호작용이 `CHORES`나 reward farming이 아닌 작은 생활감으로 느껴지는가.
- Appreciation Camera와 새 panel이 실제 touch에서 충돌하지 않는가.
- 병편지의 delayed/no-recipient/6통 제한이 실제 UI에서 자연스럽고 이해 가능한가.
- 첫 30초/5분이 `CALM`인가 `EMPTY`인가.

## 계속 금지하는 것

- 전투 / 체력 / 피해 / 사망
- 실패 조건 / 경쟁 점수 / 랭킹
- 강제 일일과제 / 체크리스트 압박
- 펫 배고픔 / 청소 / 피로 / 방치 패널티
- 반복 터치·낚시·상호작용 파밍
- 꾸미기 stats / rarity / gacha / daily-shop FOMO
- realtime/global/public chat
- 공개 social feed / follower 경쟁 / popularity score
- 위치 기반 매칭 / 데이팅
- 결제 / 광고
- 유료 에셋 의존
- 런타임 생성형 AI
