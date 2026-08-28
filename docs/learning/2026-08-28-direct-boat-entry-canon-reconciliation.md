# Incident / Solution / Lesson — Direct Boat Entry 정본 충돌

## Incident

사용자가 `오늘의 마음`과 시작 전 선택을 제거하고 바로 바다 위 보트에서 시작하도록 결정한 뒤에도, 현재 문서 일부는 mood-first main menu와 Notion을 active owner처럼 설명했습니다. 실제 `main_menu.tscn`과 관련 test도 이전 선택형 flow를 계속 소비합니다. 구형 full composition은 보트가 바다 위에 떠 있다는 공간 관계가 약해 main-entry runtime use에서 거부됐습니다.

## Solution

- 사람용 정본을 `docs/design/PROJECT_GDD.md`로 정리하고, 시작 흐름·시스템 목적·시각 방향·구현 가능성·증거 ceiling을 한국어로 분리했습니다.
- README, Concept, Experience Bible, MVP scope, implementation guide, Work 5 receipt, handoff, visual inventory를 같은 direct-entry 상태로 조정했습니다.
- 구형 menu와 mood code는 삭제나 완료로 포장하지 않고 `PRODUCT_SUPERSEDED_IMPLEMENTATION`으로 기록했습니다.
- 보트/바다 source binary는 구형 composition이 거부됐다는 이유만으로 폐기하지 않고, future consumer audit 전까지 보존하도록 했습니다.
- Phase 2 code/asset/runtime work와 User Human validation은 시작하지 않았습니다.

## Lesson

제품 flow가 바뀌면 “코드가 존재한다”와 “현재 제품에서 승인됐다”를 같은 의미로 다루면 안 됩니다. 첫 화면처럼 player promise를 직접 전달하는 surface는 사람용 GDD, actual consumer, runtime capture, Human validation을 별도로 기록해야 합니다.

## Base 승격 판정

`NO_BASE_PROMOTION`입니다. mood 제거, direct-entry diorama, 보트-물 접점, cosmetic entry는 마이 리틀 보트의 고유 제품 결정입니다. 일반화 가능한 적대적 검토·fresh official research 규칙은 이미 이 repository의 `AGENTS.md` 작업 규칙으로 명시했으며, Base 변경을 요구할 만큼 새로운 공통 mechanism 증거는 없습니다.
