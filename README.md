# my little boat - Godot MVP

`my little boat`는 작은 보트에 앉아 바다를 감상하는 1인칭 힐링 표류 게임입니다.

이 저장소는 **Godot 4.7 stable + GDScript** 기준으로 작업합니다. 전투, 실패, 경쟁, 결제, 광고, 온라인 편지 공유는 MVP 범위에서 제외합니다.

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
  assets/
    images/
    audio/
    fonts/
  docs/
    CONCEPT.md
    MVP_SCOPE.md
    CODEX_GOALS.md
    GODOT_DIRECTION.md
    GODOT_MVP_ROADMAP.md
```

## MVP 방향

플레이어는 작은 보트에 앉은 시점으로 바다를 감상합니다. 플레이어의 몸은 보이지 않습니다. 목표는 이기는 것이 아니라 **오늘의 마음으로 약 5분 동안 바다에 머물며 작은 발견과 기억을 남기는 것**입니다.

현재 Vertical Slice 기능:

- 마음 선택 4종: 평온, 지침, 외로움, 설렘
- 모바일 세로 화면 우선 UI
- PC 마우스 드래그 카메라 입력
- 사진찍기
- 실제 UI 개입을 줄이는 감상모드
- 느림 / 보통 / 빠름에 따라 미세한 표류 리듬이 달라지는 속도조절
- Scene 전환에도 이어지는 5분 항해 상태
- 일정 시간 뒤 자연스럽게 나타나는 병 속 편지 / 풍경 발견
- 선택형 낚시: 캐스팅 → 기다림 → 입질 → 낚기
- 실패 패널티·점수·판매 경제가 없는 낚시
- 5분 종료 시 항해당 정확히 1개의 오늘의 항해 기록
- 사진 / 풍경 / 편지 / 물고기 / 항해 기록이 같은 실행 세션 동안 누적되는 앨범
- 누적 기록에 따라 변하는 동반자 호감도 Lv 1~3

## 현재 구현 경계

현재는 **핵심 감정 Vertical Slice**입니다.

- 앨범을 열었다가 바다로 돌아와도 현재 항해 타이머와 상태가 이어집니다.
- 새 항해를 시작해도 이전 사진·풍경·편지·물고기·항해 기록과 동반자 진행은 지우지 않습니다.
- 다만 앱을 완전히 종료했다가 다시 실행했을 때까지 유지되는 save file persistence는 아직 구현하지 않았습니다.
- 사진은 아직 실제 PNG 파일을 저장하지 않고 텍스트 기록으로 남깁니다.
- 낚시는 현재 조용한 보조 콘텐츠만 구현하며 어종 대량화, 미끼, 장비, 판매, 요리, 낚시 경제는 다음 기획 결정 전까지 추가하지 않습니다.
- 제작 아트·오디오와 최종 모바일 실기기/Human QA는 별도 단계입니다.

## 현재 Godot 골격

- `scenes/main_menu.tscn`: 오늘의 마음 선택 후 새 항해 시작
- `scenes/game.tscn`: 1인칭 보트 감상, 5분 상태, 핵심 조작, Ambient Discovery, 선택형 낚시
- `scenes/album.tscn`: 사진·풍경·편지·물고기·항해 기록 확인
- `scripts/core/game_state.gd`: Scene 전환보다 오래 살아야 하는 현재 항해 상태와 누적 기억을 보관하는 AutoLoad
- `scripts/voyage/fishing_session.gd`: 실패 없는 `IDLE → WAITING → BITE_READY → IDLE` 낚시 상태 머신
- `scripts/voyage/boat_camera_controller.gd`: PC 마우스 드래그 카메라 회전

## 자동 검증

Pull Request에서는 `.github/workflows/godot-validation.yml`이 Godot 4.7 stable을 설치해 다음을 검증합니다.

```text
Godot 버전 확인
→ headless project import
→ 항해 상태 계약
→ 낚시 상태 계약
→ game scene 의미 계약
→ album memory 계약
→ main menu / game / album scene smoke
```

이 자동 검증은 코드·Scene 동작을 증명하지만 **게임이 실제로 편안하고 기억에 남는지**까지 증명하지 않습니다. Human usability / player emotion은 직접 플레이 관찰 전까지 `NOT_RUN`입니다.

## 협업 방식

이 저장소는 GitHub Desktop, GPT, Codex가 함께 쓰는 작업 공간입니다.

기본 흐름:

```text
Godot에서 작업
→ GitHub Desktop에서 변경사항 확인
→ Commit / Push
→ PR 자동 검증
→ GPT/Codex가 GitHub 기준으로 분석·수정·검토
```

관련 문서:

- `AGENTS.md`: AI/Codex가 지켜야 할 Godot 작업 규칙
- `AI_COLLABORATION.md`: GPT/Codex 협업 방식
- `CONTRIBUTING.md`: 기여와 테스트 기준
- `docs/CONCEPT.md`: 게임 콘셉트
- `docs/MVP_SCOPE.md`: MVP 범위
- `docs/GODOT_MVP_ROADMAP.md`: 현재 구현 단계와 다음 검증

## 테스트 체크리스트

### 자동 검증

- [ ] Godot 4.7 stable에서 프로젝트가 import 된다.
- [ ] `main_menu.tscn`, `game.tscn`, `album.tscn`이 headless smoke에서 열린다.
- [ ] 새 항해가 누적 앨범 기록을 삭제하지 않는다.
- [ ] 앨범 왕복 뒤 현재 항해 시간이 이어진다.
- [ ] 완료된 항해는 기록을 정확히 1개 만든다.
- [ ] 감상모드가 실제로 비필수 UI를 숨기고 다시 돌아올 수 있다.
- [ ] 속도조절이 카메라/보트의 미세 표류 리듬을 바꾼다.
- [ ] 편지·풍경 버튼은 발견이 있을 때만 나타난다.
- [ ] 낚시는 캐스팅 → 기다림 → 입질 → 낚기 상태를 갖고 취소해도 패널티가 없다.
- [ ] 앨범에 물고기와 항해 기록도 표시된다.

### 사람 검증

- [ ] 첫 30초에 버튼을 누르지 않아도 바다에 머물고 싶은가.
- [ ] 5분이 편안한가, 아니면 EMPTY하게 느껴지는가.
- [ ] 편지·풍경·낚시가 체크리스트보다 작은 발견처럼 느껴지는가.
- [ ] 감상모드와 버튼이 바다 감상을 방해하지 않는가.
- [ ] 모바일 세로 화면에서 핵심 조작이 잘 보이고 누르기 쉬운가.
- [ ] PC 마우스 카메라가 과하게 움직이거나 수평선을 불편하게 만들지 않는가.

## 제외한 것

- 전투 / 체력 / 피해 / 사망
- 실패 조건 / 경쟁 점수
- 결제 / 광고
- 온라인 편지 공유
- 유료 에셋 의존
- 복잡한 상점
- 낚시 판매·요리·장비 경제
- 낚시 실패 패널티
- 런타임 생성형 AI
