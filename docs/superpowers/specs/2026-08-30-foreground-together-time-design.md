# Foreground Together Time Design

## Status

```text
DECISION = USER_APPROVED_PRODUCT_DIRECTION_PLUS_2026-08-30_CONTINUATION_AUTHORIZATION
SCOPE = LOCAL_FIRST_FOREGROUND_TOGETHER_TIME
PREVIOUS_PLACEHOLDER = PRODUCT_SUPERSEDED
NO_NEW_RUNTIME_ART = REQUIRED
HUMAN_PLAYER_EXPERIENCE_VALIDATION = NOT_RUN
```

## 1. Goal

동반자와 함께 실제로 항해 화면을 보고 머문 시간을 로컬에 조용히 누적하고, 기존 `AlbumView`에서만 읽기 쉬운 시간과 관계 문구로 돌아볼 수 있게 한다. 이 기능은 레벨, 보상, 목표, 성장 연출 또는 새로운 화면을 만들지 않는다.

## 2. Current problem and scope

현재 `GameState`는 사진·풍경·편지·낚시가 `companion_affection`을 증가시키지 않도록 이미 교정되었다. 그러나 `companion_affection: int` placeholder와 Album의 `동반자 호감도: Lv %d` 문구가 남아 있어 승인된 제품 방향과 충돌한다. foreground-only together-time은 아직 저장·누적·표시되지 않는다.

이번 범위는 다음만 바꾼다.

- `GameState`의 legacy `companion_affection` 값을 `together_time_seconds: float` 로 교체한다.
- Normal Diorama와 Appreciation Camera에서만, application foreground 중 실제 scene `delta`를 누적한다.
- 숫자는 Album의 정적 summary에만 표시한다.
- 독립 `ConfigFile`에 local-only로 저장하고, 장면을 떠나거나 app이 background로 갈 때 flush한다.
- 관련 Godot 계약·GPU capture·사람용 owner 문서를 현재 사실로 바꾼다.

다음은 명시적으로 범위 밖이다.

- 동반자 상세 화면, 탭, badge, progress bar, milestone, popup, animation, 새 이미지 또는 새 사운드.
- pet type별 ledger, 속도 multiplier, memory/action bonus, streak, loss, unlock, stat, economy, social 자격.
- 사진·풍경·낚시·편지의 전체 영속 저장 설계.
- 실제 모바일 Human comfort 판정.

## 3. Binding behaviour

### 3.1 Time source

- `GameScene._process(delta)`가 application foreground일 때에만 `GameState.advance_together_time(delta)`를 호출한다.
- `GameState.advance_together_time(delta)`는 `voyage_active`가 아닐 때, 음수 delta일 때, 또는 0일 때 상태를 바꾸지 않는다.
- Normal Diorama와 Appreciation Camera는 동일하게 1 real-time second당 1 together-time second를 누적한다.
- speed control, photos, scenery, letters, fish, decoration, interaction, atmosphere, pet type은 누적값을 바꾸지 않는다.
- 5분 항해 기록이 만들어진 뒤에도 `voyage_active`인 같은 항해 화면에 머무르면 계속 누적한다.
- album, legacy main menu, backgrounded/paused application에서는 누적하지 않는다.

### 3.2 Local persistence and migration

`TogetherTimePersistence`는 `user://together_time_v1.cfg`의 `[together_time] seconds` 값 하나만 책임진다.

- 읽기 실패, 값 누락, 문자열·container·NaN·음수 값은 `0.0`으로 안전하게 정규화한다.
- `GameState`는 새 Autoload 값 `together_time_seconds`를 load/save/flush한다.
- 15 seconds 이상 새 시간이 쌓이면 한 번 저장한다. application focus-out, pause, album 전환, scene exit에서는 남은 값을 즉시 flush한다.
- 과거 `companion_affection`은 실제 시간으로 역산할 수 없고 disk에 별도 저장된 사실도 없으므로 변환하지 않는다. migration은 legacy 값을 삭제하고 새 설치·기존 설치 모두 `0.0`부터 시작하는 것으로 끝낸다.
- test는 기존 cosmetic persistence와 같은 방식으로 `set_together_time_storage_path(path)`를 사용해 격리된 `user://` 파일을 선택한다. test-only production API는 추가하지 않는다.

Godot `ConfigFile`은 section/key 기반 Variant 저장과 `user://` 경로 저장을 지원한다. `ConfigFile`의 값 변경은 `save()`가 호출되어야 disk에 반영되므로, timed flush와 lifecycle flush를 함께 둔다. [ConfigFile official documentation](https://docs.godotengine.org/en/stable/classes/class_configfile.html)

`GameState`는 Scene 사이에서 유지되는 Autoload이므로, scene-local process에서 누적한 값을 Album이 읽고 app 재시작 뒤 저장 파일에서 복원하는 owner로 적합하다. [Godot Autoload official documentation](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)

### 3.3 Album-only presentation

`TogetherTimePresentation`은 seconds를 다음처럼 읽기 쉬운 Korean text로 바꾼다.

| 입력 | duration copy | relation copy |
| --- | --- | --- |
| `0 <= seconds < 60` | `함께한 시간: 잠시` | `동반자와 같은 바다에 머물고 있어요.` |
| `60 <= seconds < 3600` | `함께한 시간: N분` | `동반자와 같은 바다를 천천히 바라봤어요.` |
| `seconds >= 3600` | `함께한 시간: H시간` 또는 `함께한 시간: H시간 M분` | `동반자와 같은 바다를 천천히 바라봤어요.` |

- duration은 초 단위를 노출하지 않으며, minute은 floor 처리한다.
- relation copy는 threshold, 단계, 효율, 보상, 다음 행동을 암시하지 않는다.
- `AlbumView`의 SummaryLabel에 duration과 relation copy를 각각 한 줄로 추가한다.
- voyage TopPanel, Appreciation Camera, 꾸미기, 낚시, 상호작용 화면에는 together-time 숫자·레벨·진행 UI를 추가하지 않는다.

## 4. Alternatives reviewed

| Alternative | Decision | Reason |
| --- | --- | --- |
| A. foreground real-time + local persistence + Album-only static copy | **ADOPT** | 실제 함께 머문 시간을 반영하면서 level/목표 압박을 만들지 않고, 현존 `GameState`와 `AlbumView`만 확장한다. |
| B. 항해 기록 수 × 5분으로 추정 | REJECT | 5분 뒤 더 머문 시간, 중단된 항해, 실제 foreground 시간을 잃고 완료 횟수 최적화를 유도한다. |
| C. pet type별 관계 ledger 또는 milestone copy | REJECT | cosmetic 선택을 progression처럼 보이게 하며, reward/milestone 기대를 만든다. |

## 5. Data flow

```text
game.tscn foreground _process(delta)
  -> GameScene checks application foreground
  -> GameState.advance_together_time(delta)
  -> together_time_seconds and unsaved accumulator
  -> TogetherTimePersistence.save() every 15 seconds or lifecycle flush

album.tscn
  -> AlbumView.refresh_album()
  -> TogetherTimePresentation duration + relation copy
  -> existing SummaryLabel
```

## 6. Acceptance criteria

1. A new active voyage accumulates exactly the passed positive foreground delta, regardless of speed or camera mode.
2. Background/paused application, Album, no active voyage, memory actions, decoration, pet changes, and zero/negative delta do not add together-time.
3. The value is restored from a valid local config file, while corrupt/missing/negative data resolves to zero.
4. Returning to Album shows duration and quiet relation copy, with no `Lv`, `호감도`, progress bar, threshold, or reward phrasing.
5. A completed five-minute record does not stop together-time while the player stays in the same active foreground voyage.
6. Existing direct-entry, time atmosphere, passive scenery, cosmetics, fishing, and Album memory contracts remain green.
7. A 540×960 GPU capture proves the Album consumer renders; Human/device readability and five-minute comfort remain `NOT_RUN`.

## 7. Evidence boundary and adversarial constraints

- Automated contracts prove source behaviour and local persistence only.
- Headless and GPU capture prove the scenes run and are rendered, not that their text or rhythm feels calming to people.
- No external assets, services, plugin, paid dependency, social capability, or `DriftBottle` work is introduced.
- The implementation must preserve the existing direct-entry C+dog backdrop and must not reactivate the legacy main-menu startup flow.

