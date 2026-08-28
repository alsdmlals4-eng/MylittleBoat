# 마이 리틀 보트

`my little boat`는 내 캐릭터와 동반자가 작은 보트 위에서 바다를 바라보며 쉬는, 휴식 우선의 Godot 4.7 게임입니다. 이 게임에서 아무것도 하지 않고 머무르는 일은 비어 있는 시간이 아니라 완전한 플레이입니다.

## 먼저 알아둘 것

- 현재 사람용 정본은 [프로젝트 GDD](docs/design/PROJECT_GDD.md)입니다.
- 사람이 읽는 최신 PDF 출력은 [GDD PDF](exports/my-little-boat_MASTER_PRODUCTION_GDD_20260829.pdf)입니다.
- 실제 코드·Scene·테스트·캡처의 사실은 [현재 Godot handoff](docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md)가 소유합니다.
- 이전 Notion은 이관이 끝난 historical archive이며 새 작업의 정본이나 동기화 대상이 아닙니다.
- 현재 기본 실행은 `scenes/game.tscn`의 direct boat entry입니다. `scenes/main_menu.tscn`은 오래된 링크를 보트 화면으로 넘기는 호환 경로이며, 선택 UI를 제품 화면으로 노출하지 않습니다.

## 플레이 경험

```text
실행
→ 이미 바다 위에 떠 있는 보트, 캐릭터, 동반자, 수평선
→ 그냥 쉬기 또는 사진·낚시·감상·작은 상호작용
→ 원할 때만 꾸미기에서 외형·동반자·보트 장식 변경
→ 개인적인 기억을 남기거나 계속 머무르기
```

시작하면 기기의 **현지 현실 시간**에 맞춰 새벽·밝음·해질녘·밤 분위기가 자동으로 보입니다. 시작 화면이나 수동 분위기 선택은 없고, 기기 시계는 보상·진행·저장에 영향을 주지 않습니다. 게임을 켜 두고 실제로 보고 있는 active foreground 시간에만 항해 timer·낚시 대기·먼 구조물·주변 풍경이 낮은 빈도로 진행되며, background 시간은 항해 기록을 만들지 않습니다.

## 핵심 보호선

- 전투, 실패 상태, 경쟁, 랭킹, 광고, 결제, 일일 과제, 펫 관리 의무를 넣지 않습니다.
- 꾸미기와 동반자는 능력치·희귀도·최적화가 아닌 자기표현과 함께 보낸 시간입니다.
- 사진·낚시·상호작용·Ambient Discovery는 선택형입니다. 하지 않아도 손해가 없습니다.
- `FriendBottle`과 `DriftBottle`은 실시간 채팅이나 공개 소셜이 아닌, 안전 조건을 충족한 뒤에만 가능한 느린 편지입니다.

## 시각 방향

기본 방향은 `HANDPAINTED_STORYBOOK_3D_DIORAMA`이며, 캐릭터와 펫에는 `SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT`을 적용합니다. 기본 identity anchor는 C 니트·긴 머리와 강아지입니다. 밤은 `INDIGO_RAIN_REFLECTION` 분위기를 사용합니다.

메인 진입은 보트 hull과 물의 접점에 잔물결·wake를 겹치고 넓은 수평선을 유지합니다. 실제 GPU capture는 [direct boat entry evidence](docs/evidence/2026-08-29-direct-boat-entry/README.md)에 남깁니다. 이는 실제 기기에서의 5분 휴식·터치·오디오 편안함까지 통과했다는 뜻은 아닙니다.

## 프로젝트 열기

1. Godot 4.7 stable 계열로 `project.godot`을 Import합니다.
2. 기본 main scene을 실행하면 바로 보트 위 장면이 열립니다.
3. `메뉴`를 눌렀을 때만 사진·감상·속도·낚시·꾸미기 같은 선택 행동이 열립니다.

문서만 변경한 PR은 runtime 성공, 실제 기기 사용성, 5분 휴식 감정, 오디오 편안함을 증명하지 않습니다. 각 상태와 근거 ceiling은 프로젝트 GDD와 handoff에서 확인합니다.
