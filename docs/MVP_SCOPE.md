# 현재 MVP 범위

현재 사람용 기획 정본은 [프로젝트 GDD](design/PROJECT_GDD.md)입니다. 이 문서는 다음 구현 계약을 빠르게 확인하는 범위표입니다.

## 플레이 경험

```text
실행
→ 이미 바다 위에 떠 있는 보트, 캐릭터, 동반자, 수평선
→ 그냥 쉬기 또는 원할 때만 사진·낚시·감상·작은 상호작용
→ 원할 때만 꾸미기에서 외형·동반자·보트 장식 변경
→ 개인적인 기억을 남기거나 계속 머무르기
```

새 로컬 상태는 `bright`로 시작하고, 그 뒤에는 마지막 local atmosphere를 selector 없이 복원합니다. `오늘의 마음`은 시작 선택도, 다른 질문으로 바꿀 항목도 아닙니다.

## 이번 direct-entry 계약에 포함될 것

- direct boat entry Scene route.
- mood data와 mood 문구·색 규칙·관련 test의 안전한 migration/retire.
- 선택형 `꾸미기` entry로 cosmetic 외형·동반자·장식 선택 이동.
- 540 x 960에서 보트와 물의 접점이 읽히는 diorama runtime capture.
- route/persistence test, scene smoke, runtime capture, Human 30초·5분 검증의 분리 기록.

## 현재 제외할 것

- 새 production asset batch와 새 이미지 family.
- social, economy, progression, monetization, public release.
- 전투, 실패, 경쟁, chores, FOMO, pet care obligation.
- mood 선택을 대체하는 새 시작 질문.

## 증거 상태

- direct boat entry는 `CONFIRMED_NOT_IMPLEMENTED`입니다.
- 구형 main menu와 mood 선택은 `PRODUCT_SUPERSEDED_IMPLEMENTATION`입니다.
- 직접 시작의 Human usability와 Player Experience는 `NOT_RUN`입니다.
- 기존 코드·Scene·테스트의 상세 상태는 [현재 Godot handoff](handoffs/CURRENT_GODOT_IMPLEMENTATION.md)에서 읽습니다.
