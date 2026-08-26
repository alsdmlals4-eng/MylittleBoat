# Boat Decor Local Persistence Design

## Goal

앱을 다시 열어도 플레이어가 선택한 보트 꾸미기와 펫 쿠션 외형을 같은 로컬 기기에서 복원한다.

## Player experience

플레이어가 보트에 랜턴, 컵, 쿠션, 화분, 엽서, 펫 쿠션을 놓고 게임을 다시 열면, 내 보트의 작은 생활감이 그대로 남아 있다. 저장 실패나 손상된 저장 파일은 오류 화면이나 벌점 없이 빈 기본 보트로 시작한다.

## Scope

- 저장 대상은 `GameState.boat_decor`와 `GameState.boat_decor_appearances`뿐이다.
- `user://boat_decor_v1.cfg`에 Godot `ConfigFile`로 저장한다.
- `GameState`가 준비될 때 저장값을 한 번 읽고, 장식 또는 외형이 바뀔 때 저장한다.
- 저장 읽기/쓰기를 `BoatDecorPersistence` 한 파일로 분리한다.
- 자동 테스트는 실제 임시 user 경로에서 저장, 새 인스턴스 복원, 손상 파일 fail-closed를 검증한다.

## Exclusions

- 항해 시간, 현재 mood, 사진, 풍경, 편지, 물고기, 애정, 항해 기록, 속도, 감상 모드, 발견, 보상, 소셜 상태는 저장하지 않는다.
- 계정 로그인, 클라우드 동기화, 복수 슬롯, 내보내기, 데이터 병합, UI, 새 이미지, 꾸미기 규칙 변경은 만들지 않는다.
- PR #19는 수정하거나 흡수하지 않는다.

## Data contract

`BoatDecorPersistence`는 다음 API만 제공한다.

```gdscript
func save(decor: Dictionary, appearances: Dictionary) -> Error
func load() -> Dictionary # {"decor": Dictionary, "appearances": Dictionary}
```

`load()`는 파일이 없거나 읽기/파싱에 실패할 때 빈 두 Dictionary를 반환한다. String key/value만 복원한다. `GameState`의 기존 setter는 변형 후 저장을 호출하며, session reset과 voyage start는 저장된 장식을 지우지 않는다.

## Acceptance criteria

1. 유효한 장식과 펫 쿠션 appearance가 새 `BoatDecorPersistence` 인스턴스에서 동일하게 복원된다.
2. 없는 파일 또는 파싱 불가 파일은 빈 결과만 반환하고 오류를 던지지 않는다.
3. `GameState`의 두 장식 setter는 저장을 요청하며, 항해 시작/리셋은 저장된 장식을 지우지 않는다.
4. 꾸미기 저장은 보상, 애정, 항해 상태, 소셜에 영향을 주지 않는다.
5. 관련 계약, 전체 계약, main menu/game/album headless smoke가 통과한다.

## Verification

- `tests/test_boat_decor_persistence.gd`를 Godot headless로 실행한다.
- 기존 `tests/test_boat_decoration_contract.gd`와 `tests/test_boat_life_ui_contract.gd`를 실행한다.
- 전체 `tests/test_*.gd`와 세 scene smoke를 실행한다.
- 실제 앱 재시작 확인은 사용자가 요청한 모바일 검증과 별개이며 `NOT_RUN`로 남긴다.
