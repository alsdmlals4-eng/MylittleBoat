# Ambient Discovery 로컬 기억 영속화 설계

**상태:** `SPECIFIED / USER_AUTHORIZED_CONTINUATION`

**제품 정본:** [프로젝트 GDD](../../design/PROJECT_GDD.md)

**결정 정본:** [Passive Ambient Discovery Decision](../../2026-08-28-passive-ambient-discovery-decision.md), [Density Decision](../../2026-08-28-passive-ambient-discovery-density-decision.md)

## 1. 현재 문제

`DriftSceneryDirector`는 active foreground에서만 낮은 빈도로 풍경 장면을 만들고, `GameScene`은 `save_memory`가 참인 경우 `GameState.sceneries`에 문구를 더한다. 그러나 이 배열은 process-lifetime 상태라 앱을 다시 열면 사라진다.

이는 자동 발견이 입력 없이 즉시 **로컬 ambient memory**로 남아야 한다는 승인 결정과 다르다. 이 작업은 그 저장 경계만 완성하며, 풍경의 발생률·무작위성·문구·알림·카메라·보상에는 손대지 않는다.

## 2. 채택한 구조

`AmbientMemoryPersistence`가 `user://ambient_memory_v1.cfg`의 `[ambient_memory] entries`에 문자열 배열만 저장하고 복원한다.

- `GameState.ambient_memories`는 영속되는 ambient-only 원장이다.
- `GameState.record_ambient_memory(entry)`만 production writer다. 빈 문구는 무시하고, 유효 문구는 `ambient_memories`와 기존 Album 읽기 모델인 `sceneries`에 한 번씩 넣은 뒤 즉시 저장한다.
- 시작 복원은 `ambient_memories`를 읽고 그 복사본을 `sceneries`에 제공한다. 따라서 Album은 새 화면·점수·collection goal 없이 기존 풍경 앨범 행을 계속 사용한다.
- 기존 `GameState.add_scenery()`는 범용 process-lifetime fixture/legacy helper로 남기며 자동 저장 writer가 아니다. 사진·편지·낚시·항해 기록은 이 작업에서 저장하지 않는다.
- ConfigFile이 없거나 배열이 아니거나 문자열 아닌 값·공백만 있으면 해당 값은 버리고 빈 배열로 시작한다. 기존 process-lifetime `sceneries`에는 durable provenance가 없으므로 migration하거나 추정 저장하지 않는다.

Godot `ConfigFile`은 section/key 기반의 로컬 저장을 지원하지만 변경을 남기려면 명시적 `save()`가 필요하다. [Godot ConfigFile 공식 문서](https://docs.godotengine.org/en/stable/classes/class_configfile.html)

## 3. 비교

| 후보 | 판정 | 이유 |
| --- | --- | --- |
| 사진·풍경·편지·낚시를 하나의 전체 저장으로 확대 | `REJECT` | 현재 승인 범위를 벗어나고, 각 memory 종류의 migration/UX 결정을 함께 강제한다. |
| 기존 `sceneries`를 모든 호출에서 바로 저장 | `REJECT` | 테스트·legacy helper의 임시 문구까지 player data로 기록할 수 있고 ambient-only 경계가 흐려진다. |
| 별도 ambient 원장과 한 개의 production 기록 API | `ADOPT` | 승인된 ambient-only 자동 저장을 완성하면서 Album consumer, 비사회성, 비보상성을 보존한다. |

## 4. 불변 조건

1. `record_ambient_memory`는 풍경 문구 하나만 기록하며, 동반자 함께한 시간·보상·낚시·꾸미기·속도·카메라·시간대·소셜 상태를 바꾸지 않는다.
2. `GameScene`은 director의 `save_memory=true` 이벤트에서만 이 API를 호출한다. 버튼·확인·카운트다운·letter/bottle 변환을 만들지 않는다.
3. 저장은 즉시 로컬에서 끝나며 backend·계정·동기화·새 UI·새 image는 만들지 않는다.
4. Normal Diorama와 Appreciation Camera는 같은 director와 writer를 사용한다. foreground와 post-record rest 규칙도 기존 그대로다.
5. Album은 이 저장을 progress, ratio, rarity, streak, badge, milestone으로 표현하지 않는다.

## 5. 검증 계약

1. 없는 파일은 빈 배열을 돌려준다.
2. 유효 ambient 문자열 배열은 새 persistence instance에서 순서대로 복원된다.
3. 문자열이 아닌 값과 공백 문구는 복원하지 않는다.
4. inactive voyage나 일반 `add_scenery`는 ambient persistence writer가 되지 않는다.
5. active voyage의 `record_ambient_memory`는 함께한 시간을 바꾸지 않고, 저장 경로를 바꿔 새 `GameState` load에서도 풍경 앨범에 복원된다.
6. `GameScene`의 `save_memory=true` foreground event는 named ambient writer를 통해 복원 가능한 memory를 만든다.
7. existing `test_*.gd` 전체와 headless scene smoke, 540×960 Album runtime capture가 통과한다. 캡처는 rendering evidence일 뿐 Human calm, text readability, or five-minute observation PASS가 아니다.

## 6. 범위 밖

- 사진·편지·물고기·항해 기록의 영속 저장, full-save, cloud sync, account, backup/export, data merge.
- 풍경 확률·cooldown·seed·motif catalog·notification copy의 재조정.
- new scene, panel, button, progress, quest, reward, social, analytics, image, animation, sound.
- Human/device calm, noticeability, touch, motion, accessibility, and text readability completion claims.
