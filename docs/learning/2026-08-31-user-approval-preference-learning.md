# 사용자 판단·승인 선호 학습 · 2026-08-31

**상태:** `PROJECT_LEARNING_RECORDED`

## 직접 요청에서 확인한 선호

사용자는 분리 하늘·바다 후보를 본 뒤 “권장안대로 진행해”라고 지시하고, 사용자의 판단과 승인 선호를 다음 작업에 반영하도록 요청했다.

| 학습 항목 | 다음 작업에서의 적용 | 적용하지 않는 범위 |
| --- | --- | --- |
| 시안 확인 뒤 권장안 연속 진행 | 같은 승인 범위 안에서 asset 등록, 구현, machine/runtime 검증, 오류 교정, 문서·정리·push까지 반복 확인 없이 진행한다. | 새 기능군, 경제/저장 의미 변경, 새 social surface, 비용·권한·파괴적 migration은 별도 판단이다. |
| 실제 화면 품질 우선 | contract가 통과해도 capture에서 정본과 충돌하는 색·합성·움직임 문제를 발견하면 실패 테스트를 추가하고 즉시 교정한다. | renderer capture를 Human UX/comfort PASS로 부풀리지 않는다. |
| 후보에서 판단할 수 있는 형태 선호 | 새 image consumer가 필요한 경우, 실제 consumer·규격·provenance를 먼저 읽고 한 쌍의 비교 가능한 후보를 제시한다. `LOCK` 뒤에는 canonical copy와 runtime integration을 진행한다. | candidate 자체를 사용자 승인·runtime 적용으로 혼동하지 않는다. |
| Human 검증 시점 | 자동/renderer 검증을 우선하고, 사람의 기기·휴식감 검증은 사용자가 선언할 때만 시작한다. | 기계적 PASS로 사람의 판단을 대체하지 않는다. |

## 자동화와 Base 판정

이번 작업에는 새 Skill, module, plugin을 만들지 않았다. 이미 채택된 Godot `Sprite3D`/shader, asset provenance, TDD, capture evidence 구조로 충족되며, 한 프로젝트의 승인 선호만으로 Base 공용 규칙을 추가하면 과설계가 된다.

**Base disposition:** `NO_BASE_PROMOTION_YET`. 같은 ‘candidate approval → recommended continuation → actual capture correction’ 패턴이 독립 프로젝트에서 반복되고 기존 Base 규칙으로 충분히 표현되지 않을 때만 재평가한다.
