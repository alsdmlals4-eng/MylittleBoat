# my little boat - Godot MVP

`my little boat`는 작은 보트에 앉아 **잔잔한 바다와 파도소리, 곁에서 같이 쉬는 펫**과 함께 아무것도 하지 않아도 편안하게 머무는 1인칭 힐링 항해 게임입니다.

이 저장소는 **Godot 4.7 stable + GDScript** 기준으로 작업합니다. 전투, 실패, 경쟁, 결제, 광고, 온라인 편지 공유는 MVP 범위에서 제외합니다.

> **Authority:** 사람용 프로젝트 개요·경험·시각·에셋 방향의 최신 승인 정본은 Notion입니다. 이 저장소의 Concept/Resting 문서는 그 방향을 코드·Scene·Test·자산 제작이 소비하도록 옮긴 implementation mirror/contract이며, 실제 런타임 사실은 repository 구현과 실행 증거가 우선합니다.

## 프로젝트 열기

1. Godot 4.7 stable을 실행합니다.
2. `Import`를 누릅니다.
3. 이 폴더의 `project.godot`을 선택합니다.
4. 프로젝트를 연 뒤 `scenes/main_menu.tscn` 또는 실행 버튼을 눌러 시작합니다.

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
    core/
      game_state.gd
    ui/
      main_menu.gd
      album_view.gd
    voyage/
      boat_camera_controller.gd
      fishing_session.gd
      game_scene.gd
  tests/
    test_calm_voyage_state.gd
    test_fishing_session.gd
    test_game_scene_contract.gd
    test_album_memory_contract.gd
    test_camera_input_contract.gd
  assets/
    images/
    audio/
    fonts/
  docs/
    CONCEPT.md
    RESTING_EXPERIENCE_BIBLE.md
    MVP_SCOPE.md
    CODEX_GOALS.md
    GODOT_DIRECTION.md
    GODOT_MVP_ROADMAP.md
```

## Rest-first 방향

이 프로젝트의 최상위 목표는 **기능이 많은 힐링 게임**이 아니라 **켜두고 머무는 것만으로 쉬는 5분 공간**입니다.

- 파도/자연음은 BGM보다 우선하는 핵심 콘텐츠입니다.
- 음악 OFF 상태에서도 경험이 성립해야 합니다.
- 바다는 안정적인 수평선, 부드러운 색과 느린 움직임을 우선합니다.
- 펫은 배고픔·청소·피로·방치 패널티가 없는 `resting companion`입니다.
- 사진·낚시·발견은 선택이며 무시해도 손해가 없어야 합니다.
- 수집·파밍·일일과제·FOMO가 휴식을 대체하지 않도록 차단합니다.

사람용 방향은 Notion 정본에서 관리하고, repository 구현 보호선은 `docs/RESTING_EXPERIENCE_BIBLE.md`, 오디오 자산 계약은 `assets/audio/README.md`에 mirror합니다.

## 현재 Vertical Slice 기능

- 마음 선택 4종: 평온, 지침, 외로움, 설렘
- 선택한 마음에 따라 좋고/나쁨을 판정하지 않고 하늘 톤만 미세하게 달라짐
- 모바일 세로 화면 우선 UI
- PC 마우스 드래그 + 모바일 화면 드래그 카메라 입력
- 사진찍기
- 실제 UI 개입을 줄이는 감상모드
- 느림 / 보통 / 빠름에 따라 미세한 표류 리듬이 달라지는 속도조절
- Scene 전환에도 이어지는 5분 항해 상태
- 일정 시간 뒤 자연스럽게 나타나는 병 속 편지 / 풍경 발견
- 선택형 낚시: 캐스팅 → 기다림 → 입질 → 낚기
- 실패 패널티·점수·판매 경제가 없는 낚시
- 낚은 물고기는 앨범 기억에 남지만 반복 낚시가 동반자 호감도 파밍 수단이 되지는 않음
- 5분 종료 시 항해당 정확히 1개의 오늘의 항해 기록
- 기록 후 바다에 계속 머물거나 `다음 항해`로 마음 선택 화면에 돌아갈 수 있음
- 사진 / 풍경 / 편지 / 물고기 / 항해 기록이 같은 실행 세션 동안 누적되는 앨범
- 사진·풍경·편지 기억에 따라 변하는 동반자 호감도 Lv 1~3

## 현재 구현 경계

현재는 **기능 Vertical Slice는 존재하지만 최종 휴식 경험 자산은 아직 없는 상태**입니다.

- 앨범을 열었다가 바다로 돌아와도 현재 항해 타이머와 상태가 이어집니다.
- 새 항해를 시작해도 이전 사진·풍경·편지·물고기·항해 기록과 동반자 진행은 지우지 않습니다.
- 활성 항해가 없으면 `complete_voyage()`가 고아 기록을 만들지 않습니다.
- 앱을 완전히 종료했다가 다시 실행했을 때까지 유지되는 save file persistence는 아직 구현하지 않았습니다.
- 사진은 아직 실제 PNG 파일을 저장하지 않고 텍스트 기록으로 남깁니다.
- 낚시는 현재 조용한 보조 콘텐츠입니다. 어종 대량화, 미끼, 장비, 판매, 요리, 낚시 경제는 **별도 기획 결정 전까지 현재 범위에서 추가하지 않습니다.**
- 모바일 화면 드래그는 자동 입력 계약으로 기술 연결을 검증했지만 실제 스마트폰 손감각·버튼 크기·가독성은 `NOT_RUN`입니다.
- `assets/audio`에는 아직 production audio가 없습니다. 파도소리 휴식감은 `NOT_RUN`입니다.
- 제작 펫 모델/idle 애니메이션이 없습니다. 펫의 실제 시각적 휴식감은 `NOT_RUN`입니다.
- 현재 placeholder 바다/보트는 최종 Visual PASS가 아닙니다.

## 다음 우선 작업

기능 수를 늘리지 않고 **Resting Core Asset Prototype**을 먼저 만듭니다.

1. 잔잔한 파도 `OceanBed` A/B 후보 청취 및 권리 readback
2. 가까운 물결 + 낮은 바람 + 드문 선체 소리 최소 soundscape
3. 편안한 바다/하늘 color study
4. 첫 펫 1종의 `바다 보기 / 앉기 / 눕기 / 졸기 / 하품·기지개` idle prototype
5. 제작 자산이 들어간 30초 / 5분 Human rest test

## 현재 Godot 골격

- `scenes/main_menu.tscn`: 오늘의 마음 선택 후 새 항해 시작
- `scenes/game.tscn`: 1인칭 보트 감상, 5분 상태, 핵심 조작, Ambient Discovery, 선택형 낚시, 다음 항해 진입
- `scenes/album.tscn`: 사진·풍경·편지·물고기·항해 기록 확인
- `scripts/core/game_state.gd`: Scene 전환보다 오래 살아야 하는 현재 항해 상태와 누적 기억을 보관하는 AutoLoad
- `scripts/voyage/fishing_session.gd`: 실패 없는 `IDLE → WAITING → BITE_READY → IDLE` 낚시 상태 머신
- `scripts/voyage/boat_camera_controller.gd`: PC 마우스와 모바일 화면 드래그 시야 회전

## 자동 검증

Pull Request에서는 `.github/workflows/godot-validation.yml`이 Godot 4.7 stable을 설치해 다음을 검증합니다.

```text
Godot 버전 확인
→ headless project import
→ 항해 상태 계약
→ 낚시 상태 계약
→ game scene 의미 계약
→ album memory 계약
→ camera input 계약
→ main menu / game / album scene smoke
```

이 자동 검증은 코드·Scene 동작을 증명하지만 **게임이 실제로 편안한지, 파도소리가 휴식을 주는지, 펫이 같이 쉬는 존재로 느껴지는지**는 증명하지 않습니다. Human listening / viewing / player emotion / real-device QA는 직접 관찰 전까지 `NOT_RUN`입니다.

## 협업 방식

```text
Notion 사람용 방향 승인
→ repository structured mirror/contract 동기화
→ Godot에서 작은 prototype
→ Commit / Push
→ PR 자동 검증
→ Human listening/viewing/playtest
→ 실제 근거가 있는 항목만 PASS 승격
```

관련 문서:

- `AGENTS.md`: AI/Codex가 지켜야 할 Godot 작업 규칙
- `AI_COLLABORATION.md`: GPT/Codex 협업 방식
- `CONTRIBUTING.md`: 기여와 테스트 기준
- `docs/CONCEPT.md`: 승인된 사람용 방향의 repository concept mirror
- `docs/RESTING_EXPERIENCE_BIBLE.md`: 휴식 경험의 구현용 structured mirror / acceptance contract
- `docs/MVP_SCOPE.md`: MVP 범위와 금지선
- `docs/GODOT_MVP_ROADMAP.md`: 현재 구현 단계와 다음 검증
- `assets/audio/README.md`: 파도 중심 soundscape와 audio asset 계약

## 테스트 체크리스트

### 자동 검증

- [ ] Godot 4.7 stable에서 프로젝트가 import 된다.
- [ ] `main_menu.tscn`, `game.tscn`, `album.tscn`이 headless smoke에서 열린다.
- [ ] 새 항해가 누적 앨범 기록을 삭제하지 않는다.
- [ ] 활성 항해가 없을 때 고아 항해 기록이 생기지 않는다.
- [ ] 앨범 왕복 뒤 현재 항해 시간이 이어진다.
- [ ] 완료된 항해는 기록을 정확히 1개 만든다.
- [ ] 완료 후 `다음 항해` 경로가 나타난다.
- [ ] 마음이 하늘 톤에 미세한 실제 차이를 만든다.
- [ ] 감상모드가 실제로 비필수 UI를 숨기고 다시 돌아올 수 있다.
- [ ] 속도조절이 카메라/보트의 미세 표류 리듬을 바꾼다.
- [ ] 편지·풍경 버튼은 발견이 있을 때만 나타난다.
- [ ] 낚시는 캐스팅 → 기다림 → 입질 → 낚기 상태를 갖고 취소해도 패널티가 없다.
- [ ] 반복 낚시만으로 동반자 호감도를 파밍할 수 없다.
- [ ] 앨범에 물고기와 항해 기록도 표시된다.
- [ ] synthetic 모바일 화면 드래그가 카메라를 돌리면서 pitch clamp와 수평을 보존한다.

### Resting Core 사람 검증 — 제작 자산 통합 후

- [ ] 첫 30초에 버튼을 누르지 않아도 바다에 머물고 싶은가.
- [ ] 음악 OFF + 파도소리만으로 공간이 성립하는가.
- [ ] 5분이 편안한가, 아니면 `EMPTY`/`CHORES`로 느껴지는가.
- [ ] 마음별 미세한 하늘 톤 차이가 감정을 강요하지 않고 자연스럽게 느껴지는가.
- [ ] 파도 loop seam, 큰 소리, 날카로운 고역이 거슬리지 않는가.
- [ ] 환경은 부드럽지만 UI 텍스트와 핵심 버튼은 충분히 읽히는가.
- [ ] 바다의 반사·bob·움직임이 눈이나 멀미에 부담을 주지 않는가.
- [ ] 펫이 `관리할 대상`보다 `같이 쉬는 존재`로 느껴지는가.
- [ ] 편지·풍경·낚시가 체크리스트보다 작은 발견처럼 느껴지는가.
- [ ] 감상모드와 버튼이 바다 감상을 방해하지 않는가.
- [ ] 모바일 세로 화면에서 핵심 조작이 잘 보이고 누르기 쉬운가.
- [ ] 모바일 화면 드래그 감도가 편안한가.
- [ ] PC 마우스 카메라가 과하게 움직이거나 수평선을 불편하게 만들지 않는가.

## 제외한 것

- 전투 / 체력 / 피해 / 사망
- 실패 조건 / 경쟁 점수
- 강제 일일과제 / 생산성 체크리스트 압박
- 펫 배고픔 / 청소 / 피로 / 방치 패널티
- 반복 터치·낚시 파밍을 핵심 성장으로 만드는 구조
- 결제 / 광고
- 온라인 편지 공유
- 유료 에셋 의존
- 복잡한 상점
- 낚시 판매·요리·장비 경제
- 낚시 실패 패널티
- 런타임 생성형 AI
