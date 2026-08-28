# 마이 리틀 보트

`my little boat`는 내 캐릭터와 동반자가 작은 보트 위에서 바다를 바라보며 쉬는, 휴식 우선의 Godot 4.7 게임입니다. 이 게임에서 아무것도 하지 않고 머무르는 일은 비어 있는 시간이 아니라 완전한 플레이입니다.

## 먼저 알아둘 것

- 현재 사람용 정본은 [프로젝트 GDD](docs/design/PROJECT_GDD.md)입니다.
- 실제 코드·Scene·테스트·캡처의 사실은 [현재 Godot handoff](docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md)가 소유합니다.
- 이전 Notion은 이관이 끝난 historical archive이며 새 작업의 정본이나 동기화 대상이 아닙니다.
- 현재 코드에는 이전 선택형 메인 메뉴가 남아 있습니다. 이는 승인된 제품 흐름이 아니라 다음 Phase 2 구현 계약에서 교체할 `PRODUCT_SUPERSEDED_IMPLEMENTATION`입니다.

## 플레이 경험

```text
실행
→ 이미 바다 위에 떠 있는 보트, 캐릭터, 동반자, 수평선
→ 그냥 쉬기 또는 사진·낚시·감상·작은 상호작용
→ 원할 때만 꾸미기에서 외형·동반자·보트 장식 변경
→ 개인적인 기억을 남기거나 계속 머무르기
```

새 로컬 상태는 `bright` 분위기로 시작합니다. 이후에는 마지막으로 저장된 분위기를 사용하되, 시작할 때 선택 화면을 보여주지 않습니다. 분위기를 바꾸는 미래 UI는 아직 결정하지 않았습니다.

## 핵심 보호선

- 전투, 실패 상태, 경쟁, 랭킹, 광고, 결제, 일일 과제, 펫 관리 의무를 넣지 않습니다.
- 꾸미기와 동반자는 능력치·희귀도·최적화가 아닌 자기표현과 함께 보낸 시간입니다.
- 사진·낚시·상호작용·Ambient Discovery는 선택형입니다. 하지 않아도 손해가 없습니다.
- `FriendBottle`과 `DriftBottle`은 실시간 채팅이나 공개 소셜이 아닌, 안전 조건을 충족한 뒤에만 가능한 느린 편지입니다.

## 시각 방향

기본 방향은 `HANDPAINTED_STORYBOOK_3D_DIORAMA`이며, 캐릭터와 펫에는 `SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT`을 적용합니다. 기본 identity anchor는 C 니트·긴 머리와 강아지입니다. 밤은 `INDIGO_RAIN_REFLECTION` 분위기를 사용합니다.

메인 진입에서 보트가 물 위에 합성된 것처럼 보이는 기존 구성은 사용하지 않습니다. 다음 direct-entry 장면은 보트와 물의 접점, 잔물결·wake, 반사 또는 가림, 540 x 960에서의 수평선 구도를 함께 검증해야 합니다. 이 판단은 보트·바다의 개별 source binary 전체 폐기를 뜻하지 않습니다.

## 프로젝트 열기

1. Godot 4.7 stable 계열로 `project.godot`을 Import합니다.
2. 현재 구현 상태를 보려면 기본 main scene을 실행합니다.
3. 이 화면은 현재 제품 정본과 다를 수 있습니다. direct-entry 제품 변경은 별도 승인된 Phase 2 구현 계약 전에는 적용되지 않습니다.

문서만 변경한 PR은 runtime 성공, 실제 기기 사용성, 5분 휴식 감정, 오디오 편안함을 증명하지 않습니다. 각 상태와 근거 ceiling은 프로젝트 GDD와 handoff에서 확인합니다.
