# Ambient Discovery 로컬 기억 영속화 실행 계획

**목표:** 자동으로 기록된 풍경만 `user://ambient_memory_v1.cfg`에 즉시 저장하고 다음 실행의 Album 풍경 행으로 복원한다.

**범위:** `AmbientMemoryPersistence`, `GameState`의 ambient-only API·load 경계, `GameScene`의 production writer 연결, 계약 테스트와 현행 정본 갱신.

**범위 밖:** 전체 Album save, photo/letter/fish persistence, 풍경 발생률 변경, UI/asset/social 확장.

## 작업 순서

1. `tests/test_ambient_memory_persistence.gd`에서 누락 파일·round trip·malformed value의 실패 계약을 먼저 작성하고 red를 확인한다.
2. `scripts/core/ambient_memory_persistence.gd`에 ConfigFile v1 serializer를 최소 구현하고 persistence contract를 green으로 만든다.
3. `tests/test_ambient_memory_state_contract.gd`에서 named writer, no-together-time side effect, generic helper 분리, isolated path restore를 red로 작성한다.
4. `GameState`에 ambient ledger/persistence owner/load API를 추가하고 `GameScene`의 `save_memory=true` consumer만 named writer를 호출하도록 바꾼다.
5. foreground event → persistent ambient memory의 scene contract를 red/green으로 추가한다.
6. Album rendering capture와 전체 contract/smoke를 재실행한 뒤 GDD, handoff, AI spec, inventory의 ambient state를 `IMPLEMENTED` 범위로만 올린다. Human evidence는 계속 `NOT_RUN`으로 남긴다.

## 완료 기준

- 자동 저장된 풍경은 앱 재시작 경계에서 Album의 풍경 count·최근 풍경에 복원된다.
- manual/test helper, action, speed, camera, pet type, background 시간은 저장을 우회하거나 cadence만 유지한다.
- no `letter`/Bottle/score/progress UI가 추가된다.
- full 32+ `test_*.gd`, game/album smoke, capture, diff check의 실제 결과를 기록한다.
