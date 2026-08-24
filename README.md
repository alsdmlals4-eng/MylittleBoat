# my little boat - Godot MVP

`my little boat`는 **본디에서 참고한 작고 둥근 3D 디오라마 감성**을 바탕으로, 작은 보트에서 보이는 플레이어 캐릭터와 펫이 함께 쉬고 생활하며 잔잔한 바다·파도소리·작은 기억을 쌓는 rest-first 힐링 항해 게임입니다.

이 저장소는 **Godot 4.7 stable + GDScript** 기준입니다. 전투·실패·경쟁·광고·결제·실시간/공개 소셜 압박은 핵심 방향에서 제외합니다. 온라인 기능은 승인된 **delayed FriendBottle / DriftBottle** 범위와 그 안전 운영에만 한정하며, 기본 휴식 게임은 local-first로 유지합니다.

> **Authority:** 사람용 프로젝트 개요·경험·시각·에셋 방향의 최신 승인 정본은 Notion입니다. 이 저장소의 Concept/Resting/Design 문서는 그 방향을 코드·Scene·Test가 소비하도록 옮긴 implementation mirror/contract이며, 실제 런타임 사실은 repository 구현과 실행 증거가 우선합니다.

## 프로젝트 열기

1. Godot 4.7 stable을 실행합니다.
2. `Import`에서 이 폴더의 `project.godot`을 선택합니다.
3. 프로젝트를 연 뒤 실행하거나 `scenes/main_menu.tscn`에서 시작합니다.

권장 작업 폴더:

```text
C:\Users\user\Documents\GitHub\MyLittleBoat
```

## 현재 구조

```text
MyLittleBoat/
  project.godot
  scenes/
    main_menu.tscn
    game.tscn
    album.tscn
  scripts/
    audio/
      resting_soundscape.gd
    avatar/
      player_avatar_placeholder.gd
    core/
      game_state.gd
    ui/
      main_menu.gd
      album_view.gd
    voyage/
      boat_camera_controller.gd
      fishing_session.gd
      resting_pet_placeholder.gd
      game_scene.gd
  tests/
    test_calm_voyage_state.gd
    test_fishing_session.gd
    test_game_scene_contract.gd
    test_album_memory_contract.gd
    test_camera_input_contract.gd
    test_resting_core_contract.gd
    test_diorama_avatar_camera_contract.gd
  assets/
    images/
    audio/
    fonts/
  docs/
    CONCEPT.md
    RESTING_EXPERIENCE_BIBLE.md
    MVP_SCOPE.md
    GODOT_MVP_ROADMAP.md
    superpowers/
      specs/2026-08-24-bondee-diorama-delayed-bottle-design.md
      plans/2026-08-24-canon-migration-diorama-shell.md
```

## Product North Star

최상위 목표는 **기능이 많은 힐링 게임**이 아니라 **내 캐릭터·펫·보트와 함께 머무는 것만으로 쉬는 작은 바다 공간**입니다.

- normal play는 **visible avatar + pet + boat + sea가 함께 보이는 3/4 Boat Diorama**입니다.
- `Appreciation Camera`는 바다와 수평선에 집중하는 기존 low-UI 감상 경험을 보존합니다.
- 파도/자연음은 BGM보다 우선하는 핵심 콘텐츠입니다.
- 펫은 배고픔·청소·피로·방치 패널티가 없는 `resting companion`입니다.
- 사진·낚시·발견·미래 상호작용은 모두 선택형입니다.
- 꾸미기는 능력치가 아니라 기억과 자기표현입니다.
- 미래 병편지는 실시간 채팅이 아니라 천천히 표류하는 보조 소셜입니다.
- 수집·파밍·일일과제·FOMO·인기 경쟁이 휴식을 대체하지 않도록 차단합니다.

## 현재 구현된 기능

### Calm Voyage Vertical Slice

- 오늘의 마음 4종: 평온 / 지침 / 외로움 / 설렘
- Scene 전환에도 이어지는 5분 항해 상태
- 사진찍기
- 감상모드
- 느림 / 보통 / 빠름 표류 리듬
- authored Ambient Discovery: 병 속 편지 / 풍경
- 실패·점수·판매 경제가 없는 선택형 조용한 낚시
- 5분 종료 시 항해당 오늘의 항해 기록 1개
- 같은 실행 세션 동안 누적되는 사진 / 풍경 / 편지 / 물고기 / 항해 기록
- 앨범 + 동반자 호감도 Lv 1~3

### Resting Core Technical Prototype

- `RestingSoundscape` AutoLoad가 Scene 전환에도 유지됩니다.
- 런타임 생성 4초 `AudioStreamWAV` OceanBed가 `-16 dB`로 loop됩니다.
- 이 합성음은 `TECHNICAL_PROTOTYPE`이며 production 자연 파도음이 아닙니다.
- 바다 material/조명/마음별 하늘 톤에 soft-resting 기술 경계를 둡니다.
- 둥근 `RestingPetPlaceholder`가 12~24초 저밀도 idle과 미세 호흡을 사용합니다.
- 펫 placeholder에는 care obligation이 없습니다.

### Canon Migration + Diorama Shell

현재 정상 플레이의 기술 presentation을 3/4 디오라마로 전환했습니다.

- `DioramaCameraRig/DioramaCamera3D`가 normal mode의 active camera입니다.
- `PlayerAvatarPlaceholder`가 보이는 기술용 플레이어 shell입니다.
- Avatar는 `TECHNICAL_PLACEHOLDER=true`를 노출합니다.
- 미래 cosmetic 슬롯 계약은 `body / hair / top / bottom / head_accessory / accessory / color`입니다.
- 기존 드래그 가능한 바다 카메라는 `AppreciationCameraRig/AppreciationCamera3D`로 보존했습니다.
- 감상모드 전환은 항해 시간·속도 선택·사진/풍경/편지/물고기 보상을 변경하지 않습니다.
- Appreciation Camera controller는 해당 카메라가 `current`일 때만 PC mouse / `InputEventScreenDrag`를 처리합니다. 따라서 normal diorama touch를 빼앗지 않습니다.
- Diorama와 Appreciation camera 모두 속도 선택에 따른 아주 작은 drift 피드백을 유지합니다.

현재 기술 evidence:

```text
TECH_DIORAMA_SHELL = PASS
VISIBLE_AVATAR_PLACEHOLDER = PASS
APPRECIATION_CAMERA = PASS
APPRECIATION_INPUT_ISOLATION = PASS
TECH_RESTING_CORE = PASS
```

이것은 **최종 시각 품질이나 실제 모바일 편안함 PASS가 아닙니다.**

## 현재 구현 경계

```text
BOAT_DECORATION = NOT_IMPLEMENTED
INTERACTABLE_RUNTIME = NOT_IMPLEMENTED
FRIEND_BOTTLE = NOT_IMPLEMENTED
DRIFT_BOTTLE = NOT_IMPLEMENTED
SOCIAL_BACKEND = NOT_IMPLEMENTED
FINAL_AVATAR_ART = NOT_INTEGRATED
PRODUCTION_OCEAN_AUDIO = NOT_INTEGRATED
HUMAN_VISUAL_COMFORT = NOT_RUN
HUMAN_AUDIO_LISTENING = NOT_RUN
REAL_MOBILE_QA = NOT_RUN
APP_RESTART_SAVE = DEFERRED
```

- 현재 Avatar/Pet/Sea/Boat는 기술 placeholder입니다.
- 사진은 실제 PNG 파일 저장이 아니라 기록 데이터입니다.
- 앱을 완전히 종료했다 다시 실행하면 누적 기억을 복원하는 save-file persistence는 아직 없습니다.
- 실제 스마트폰 손감각·portrait 구도·버튼 가독성·멀미 여부는 아직 검증하지 않았습니다.

## 승인된 다음 시스템

### 1. Local Boat Decoration + Interactable

다음 구현 Slice입니다.

- 보트 꾸미기는 자유 3D editor보다 **8개 slot zone**으로 시작합니다.
- 아이템은 능력치/희귀도 최적화가 아니라 개인 기억과 자기표현입니다.
- 펫·난간·쿠션·랜턴·컵·앨범·낚싯대 등을 공통 low-pressure `Interactable` 계약으로 묶습니다.
- rapid-tap farming, 방치 손해, 강제 상호작용은 만들지 않습니다.

### 2. Delayed Bottle Social

구현은 그 뒤 별도 Slice로 진행합니다.

- `FriendBottle`: 승인된 친구와 지연 병편지.
- `DriftBottle`: 제한된 낯선 사용자 병편지.
- 모든 MVP 온라인 소셜은 16+.
- accepted bottle은 healthy backend/network에서 server-receivable `<= 5 minutes` 목표.
- no recipient인 DriftBottle은 sent로 수락하지 않고 local draft를 유지합니다.
- 공개 user search / presence / typing / read receipt / public feed / follower / ranking 없음.
- DriftBottle은 production moderation + Terms + report/block + 운영 경로가 검증되기 전 feature flag OFF입니다.

세부 설계는 `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md`를 따릅니다.

## 현재 Godot 골격

- `scenes/main_menu.tscn`: 오늘의 마음 선택 후 항해 시작
- `scenes/game.tscn`: 3/4 Boat Diorama, visible Avatar/Pet placeholder, Appreciation Camera, 5분 상태, Ambient Discovery, 선택형 낚시
- `scenes/album.tscn`: 사진·풍경·편지·물고기·항해 기록 확인
- `scripts/core/game_state.gd`: 현재 항해 상태와 실행 세션 누적 기억 AutoLoad
- `scripts/audio/resting_soundscape.gd`: persistent 기술용 OceanBed AutoLoad
- `scripts/avatar/player_avatar_placeholder.gd`: visible Avatar 기술 evidence + future cosmetic-slot contract
- `scripts/voyage/boat_camera_controller.gd`: active Appreciation Camera 전용 PC/touch drag controller
- `scripts/voyage/resting_pet_placeholder.gd`: 관리 의무 없는 저밀도 pet idle 기술 placeholder
- `scripts/voyage/fishing_session.gd`: 실패 없는 fishing state machine

## 자동 검증

Pull Request에서 `.github/workflows/godot-validation.yml`이 Godot 4.7 stable로 다음을 검증합니다.

```text
Godot version
→ headless project import
→ calm voyage state contract
→ fishing contract
→ game scene contract
→ album memory contract
→ Appreciation Camera input/isolation contract
→ Resting Core technical contract
→ Diorama Avatar/Camera contract
→ main menu / game / album scene smoke
```

자동 검증은 Scene/코드 계약을 증명하지만 **실제로 예쁘거나 편안한지**는 증명하지 않습니다.

## 협업 방식

```text
Notion 사람용 방향 승인
→ repository structured spec/plan
→ 작은 TDD Slice
→ PR exact-head CI
→ 적대적 검토
→ 병합/readback
→ Notion evidence sync
→ Human/device 검증 뒤 품질 PASS
```

관련 문서:

- `AGENTS.md`: 프로젝트 운영/금지선
- `docs/CONCEPT.md`: 현재 방향의 repository mirror
- `docs/RESTING_EXPERIENCE_BIBLE.md`: rest-first 구현 보호선
- `docs/MVP_SCOPE.md`: 구현/미구현 범위
- `docs/GODOT_MVP_ROADMAP.md`: 단계별 실행 순서
- `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md`: 디오라마 + delayed bottle architecture
- `assets/audio/README.md`: 파도 중심 soundscape asset 계약

## Human 검증 — 아직 NOT_RUN

- [ ] 3/4 portrait 구도에서 Avatar + Pet + Boat + Sea가 편안하게 읽히는가.
- [ ] Avatar/Pet가 바다를 과하게 가리지 않는가.
- [ ] 감상모드 전환이 자연스럽고 바다 감상에 실제로 도움이 되는가.
- [ ] normal diorama touch와 Appreciation Camera drag가 실제 모바일에서 충돌하지 않는가.
- [ ] 카메라/보트 bob이 눈이나 멀미에 부담을 주지 않는가.
- [ ] 첫 30초에 아무것도 하지 않아도 머물고 싶은가.
- [ ] 음악 OFF + 실제 파도소리만으로 공간이 성립하는가.
- [ ] 5분이 `CALM`이고 `EMPTY`/`CHORES`가 아닌가.

## 계속 금지하는 것

- 전투 / 체력 / 피해 / 사망
- 실패 조건 / 경쟁 점수 / 랭킹
- 강제 일일과제 / 생산성 체크리스트 압박
- 펫 배고픔 / 청소 / 피로 / 방치 패널티
- 반복 터치·낚시·상호작용 파밍
- realtime/global/public chat
- 공개 social feed / follower 경쟁 / popularity score
- 위치 기반 매칭 / 데이팅
- 결제 / 광고
- 유료 에셋 의존
- 복잡한 상점 / 낚시 경제
- 런타임 생성형 AI
