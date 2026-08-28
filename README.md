# my little boat - Godot MVP

`my little boat`는 **본디에서 참고한 작고 둥근 3D 디오라마 감성**을 바탕으로, 작은 보트에서 보이는 플레이어 캐릭터와 펫이 함께 쉬고 생활하며 잔잔한 바다·파도소리·작은 기억을 쌓는 rest-first 힐링 항해 게임입니다.

이 저장소는 **Godot 4.7 stable + GDScript** 기준입니다. 전투·실패·경쟁·광고·결제·실시간/공개 소셜 압박은 핵심 방향에서 제외합니다. 온라인 기능은 승인된 delayed FriendBottle / DriftBottle 범위와 그 안전 운영에만 한정하며, 기본 휴식 게임은 local-first로 유지합니다.

> **Authority:** 사람용 프로젝트 개요·경험·시각·에셋 방향의 최신 승인 정본은 Notion입니다. 이 저장소 문서는 그 방향을 코드·Scene·Test가 소비하도록 옮긴 implementation mirror/contract이며, 실제 런타임 사실은 repository 구현과 실행 증거가 우선합니다.

## 프로젝트 열기

1. Godot 4.7 stable을 실행합니다.
2. `Import`에서 이 폴더의 `project.godot`을 선택합니다.
3. 실행하거나 `scenes/main_menu.tscn`에서 시작합니다.

## 내부 Windows 빌드 받기

`main`에 연결된 성공한 **Godot 4.7 validation** 실행 또는 수동 실행의 Artifacts에서 `my-little-boat-windows-internal`을 내려받아 압축을 풉니다. `my_little_boat.exe`와 같은 폴더의 `my_little_boat.pck`를 함께 둔 채 실행합니다. `SHA256SUMS.txt`에는 두 파일의 SHA-256이 들어 있습니다.

이 경로는 저장소 사용자용 internal Windows x86_64 debug package입니다. Android APK, public store release, code signing, 실제 스마트폰/사람 comfort 검증을 뜻하지 않습니다.

## 핵심 방향

- normal play는 **visible avatar + pet + boat + decor + sea가 함께 보이는 3/4 Boat Diorama**입니다.
- `Appreciation Camera`는 바다와 수평선 중심의 low-UI 감상 경험을 보존합니다.
- 파도/자연음은 BGM보다 우선하는 핵심 콘텐츠입니다.
- 펫은 care obligation이 없는 resting companion입니다.
- 사진·낚시·발견·꾸미기·상호작용은 전부 선택형이며 무시해도 손해가 없어야 합니다.
- 승인된 다음 동반자 방향은 행동 횟수가 아니라 활성 항해에서 함께 보낸 시간으로만 호감도가 천천히 쌓이는 것입니다. 이 방향의 구현·저장·UI 전환은 아직 별도 계약 전입니다.
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

### Resting Core Authored Ocean Candidate

- persistent `RestingSoundscape` AutoLoad
- 16-second stereo authored OceanBed
- soft sea/light/mood-sky 기술 경계
- 관리 의무 없는 `RestingPetPlaceholder`

### 3/4 Diorama Shell

- normal `DioramaCamera3D`
- visible `PlayerAvatarPlaceholder`
- preserved `AppreciationCamera3D`
- inactive Appreciation Camera mouse/touch input isolation

### 내 모습과 동반자

- 메인 메뉴의 `내 모습과 동반자`에서 승인된 플레이어 외형 3종과 동반자 4종을 고릅니다.
- 선택은 순수한 시각 효과이며 항해 시간, 마음, 보상, 친밀도, 앨범, 꾸미기, 소셜 상태를 바꾸지 않습니다.
- 기본 조합은 승인된 C 니트·긴 머리 + 강아지이며, 기존 최종 디오라마 합성 이미지를 그대로 사용합니다.
- 선택은 기기 로컬 `user://identity_profile_v1.cfg`에만 저장되며 보트 꾸미기 저장과 분리됩니다.

### 오늘의 빛

- 메인 메뉴에서 새벽·밝음·해질녘·밤 중 다음 항해의 빛을 고릅니다. 기본값은 밝음입니다.
- 선택은 같은 보트·바다·수평선·주인공·동반자·카메라를 유지한 채 환경광·키라이트·바다 배경의 절제된 색만 바꿉니다.
- 시간, 보상, 친밀도, 낚시, 발견, 꾸미기, 소셜, 저장 상태에는 영향을 주지 않습니다. 앱 재시작 뒤에도 선택을 보존하지 않습니다.

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
- `GameState.boat_decor`는 `slot_id -> item_id`를 유지하고, 펫 쿠션의 순수 외형만 별도 cosmetic appearance로 저장합니다.
- Scene 전환·새 항해·앱 재시작 뒤에도 기기 로컬 저장으로 유지됩니다.
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
- OptionButton으로 slot/item/target/action 선택, 펫 쿠션일 때만 줄무늬·달·꽃 외형 선택
- compatible item만 노출
- 패널 상호 배타적 open
- Appreciation Mode에서 새 버튼 hide + 열린 panel close
- 감상 종료 후 panel 자동 재오픈 없음
- 자유 3D drag placement는 Human mobile evidence 전까지 defer

현재 기술 evidence:

```text
TECH_DIORAMA_SHELL = PASS
APPRECIATION_INPUT_ISOLATION = PASS
TECH_RESTING_CORE = PASS
TECH_BOAT_DECORATION = PASS
LOW_PRESSURE_INTERACTABLE = PASS
BOAT_LIFE_TECH_UI = PASS
```

증거 ceiling:

```text
C_DOG_DEFAULT_RUNTIME_CAPTURE = PASS
C_DOG_HUMAN_VISUAL_APPROVAL = PASS
HANDPAINTED_3D_RUNTIME_SLICE = USER_APPROVED_MERGED_MAIN
MOBILE_30S_VISUAL_REVIEW = NOT_RUN
MOBILE_5M_VISUAL_REVIEW = NOT_RUN
DECOR_HUMAN_USABILITY = NOT_RUN
REAL_MOBILE_DECOR_QA = NOT_RUN
FINAL_AVATAR_ART = USER_APPROVED_NOTION_REGISTERED_LOCATOR_PASS
FINAL_PET_ART = USER_APPROVED_NOTION_REGISTERED_LOCATOR_PASS
FINAL_DECOR_ART = CODEX_RUNTIME_PROOF_USER_APPROVED_MERGED_MAIN
FINAL_BOAT_SEA_ART = USER_APPROVED_NOTION_REGISTERED_LOCATOR_PASS
APP_RESTART_DECOR_PERSISTENCE = AUTOMATED_LOCAL_RESTORE_PASS
PRODUCTION_OCEAN_AUDIO = AUTHORED_RUNTIME_CANDIDATE
AUDIO_REST_HUMAN_LISTENING = NOT_RUN
REAL_FRIEND_BOTTLE_NETWORK = NOT_IMPLEMENTED
REAL_DRIFT_BOTTLE_NETWORK = NOT_IMPLEMENTED
SOCIAL_BACKEND = NOT_IMPLEMENTED_ON_MAIN
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
  core/cosmetic_identity_profile.gd
  decor/boat_decor_catalog.gd
  decor/decor_visual_assets.gd
  decor/boat_decor_slot.gd
  interaction/low_pressure_interactable.gd
  identity/identity_visual_catalog.gd
  identity/identity_visual_router.gd
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
  test_handpainted_visual_slice_contract.gd
  test_boat_decoration_contract.gd
  test_low_pressure_interaction_contract.gd
  test_boat_life_scene_contract.gd
  test_boat_life_ui_contract.gd
  test_runtime_image_asset_contract.gd
  test_cosmetic_identity_profile.gd
  test_identity_visual_contract.gd
  test_main_menu_identity_contract.gd
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
→ approved runtime image assets
→ local cosmetic identity profile and visual route
→ main-menu cosmetic selector
→ four-time atmosphere catalog / menu selector / shared game-scene application
→ main menu / game / album Scene smoke
→ Windows x86_64 internal package export / ZIP content / SHA-256 manifest
```

자동 검증과 Windows package artifact는 기술 동작·구성·재현 가능한 전달 경로를 증명하지만, 실제로 예쁘고 편안하며 모바일에서 쓰기 좋은지는 증명하지 않습니다.

## 다음 구현 순서

현재 completed `main`은 승인된 그림체를 C+강아지 최종 2.5D 화면, 로컬 외형 선택, 방석·엽서 표면, 네 시간대 분위기로 이미 통합했습니다. 새 mainline은 이 결과를 다시 만드는 일이 아니라 별도 승인된 다음 Product Slice입니다.

1. **현재 런타임 결과 유지** — C+강아지 기본 합성, A/B/C 플레이어·4종 펫의 로컬 외형 선택, 방석 3종, Bright Boat 엽서, 네 시간대 분위기는 자동 계약·540×960 런타임 증거와 함께 `main`에 있습니다. 실제 기기 터치 검증은 보류입니다.
2. **Human visual validation** — 30초/5분의 실제 편안함, `CALM / EMPTY / NOISY`, sea-first hierarchy, visual fatigue는 아직 사람 검증이 필요하지만 사용자의 지시에 따라 보류합니다.
3. **PR #19 Social Fake Backend** — 별도 독립 workstream으로 OPEN / READ_ONLY / NO ABSORPTION입니다. 현재 visual workstream에서 rebase·merge·수정하지 않으며, social 작업을 명시적으로 재개할 때 latest `main`과 다시 reconcile합니다.
4. **Supabase/Auth/RLS/Moderation/Real Delayed Bottle** — Social Fake 계약이 current main에 안전하게 정합된 뒤 별도 보안·계정·release gate로 진행합니다.
5. **새 Product Slice** — 기능·asset·backend 추가는 concrete consumer와 별도 승인된 범위가 생긴 뒤 시작합니다. 이미 완료된 시각 통합을 이유 없이 다시 만들지 않습니다.

현재 Godot 제품 구현의 **첫 진입점**:

- `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md` — current Goal/보호 범위/evidence ceiling과 구현 방법 자율성의 stable router.

Supporting planning artifacts:

- `docs/superpowers/specs/2026-08-26-first-production-visual-slice-design.md`
- `docs/superpowers/plans/2026-08-26-first-production-visual-slice-reconciled.md`
- `docs/evidence/2026-08-26-first-production-visual-slice/`
- `docs/superpowers/specs/2026-08-26-c-storybook-dog-default-design.md`
- `docs/superpowers/plans/2026-08-26-c-storybook-dog-default.md`
- `docs/evidence/2026-08-26-c-storybook-dog-default/`

v1 plan/handoff의 정확한 Node 이름·테스트 형태는 planning example이며, current router의 outcome/acceptance/protected semantics가 우선합니다.

## Human 검증 — 아직 NOT_RUN

- 3/4 portrait에서 Avatar + Pet + Boat + Decor + Sea가 편안하게 읽히는가.
- 8-slot 방식이 모바일에서 이해하기 쉽고 충분한 자기표현을 주는가.
- OptionButton 기반 panel이 방해가 되지 않는가.
- 자유 3D drag placement가 실제로 필요한가.
- 상호작용이 `CHORES`나 reward farming이 아닌 작은 생활감으로 느껴지는가.
- Appreciation Camera와 새 panel이 실제 touch에서 충돌하지 않는가.
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
