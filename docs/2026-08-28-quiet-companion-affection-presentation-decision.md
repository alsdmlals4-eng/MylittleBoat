# Quiet Companion Affection Presentation Decision · 2026-08-28

## Status

```text
DECISION = USER_APPROVED_PRODUCT_DIRECTION
TRACKING_ISSUE = #93
COMPANION_AFFECTION_SOURCE = ACTIVE_FOREGROUND_VOYAGE_TIME_ONLY
FIRST_DISPLAY_CONSUMER = ALBUM_VIEW
VOYAGE_SCREEN_NUMERIC_AFFECTION = FORBIDDEN
VOYAGE_SCREEN_PROGRESS_BAR = FORBIDDEN
VOYAGE_SCREEN_GROWTH_POPUP = FORBIDDEN
DISPLAY_LANGUAGE = TOGETHER_TIME_PLUS_QUIET_RELATION_SENTENCE
CURRENT_MAIN_IMPLEMENTATION = ACTION_BASED_LIVE_LEVEL_AND_PRODUCT_SUPERSEDED
RUNTIME_IMPLEMENTATION = NOT_STARTED
HUMAN_PLAYER_EXPERIENCE_VALIDATION = NOT_RUN
```

## User approval

사용자는 권장안 A를 승인했습니다. 동반자 호감도는 쉬는 동안 최적화해야 할 live level이 아니라, 나중에 앨범에서 조용히 돌아보는 `함께한 시간`입니다.

첫 구현 소비처는 새 화면을 추가하지 않고 현재 `AlbumView`입니다. 앨범에는 전역 누적 항해 시간을 읽을 수 있는 짧은 요약과, 점수·단계가 아닌 정서적 관계 문구 한 줄만 둡니다. 항해 화면과 Appreciation Camera는 호감도 수치·레벨·진행바·성장 알림을 표시하지 않습니다.

## Binding product rules

1. `함께한 시간`은 승인된 `ACTIVE_FOREGROUND_VOYAGE_TIME`만 설명합니다. Normal Diorama와 Appreciation Camera, 5분 기록 뒤에 같은 항해 화면에서 더 머문 시간은 같은 전역 시간으로 읽습니다.
2. 첫 구현은 기존 AlbumView의 정적 요약 영역입니다. 새로운 동반자 상세 Scene, 탭, badge 또는 별도 진입 동선을 이 결정만으로 추가하지 않습니다.
3. 앨범에는 `함께한 시간`의 읽기 쉬운 duration과 조용한 관계 문구 한 줄을 둡니다. 관계 문구는 점수·효율·다음 보상·해야 할 행동을 암시하지 않습니다.
4. voyage TopPanel, Appreciation Camera, 사진·낚시·꾸미기·Ambient Discovery·상호작용 화면에 실시간 affection number, `Lv`, progress bar, timer, milestone, confetti, toast 또는 growth prompt를 두지 않습니다.
5. 현재 고양이·토끼·강아지·수달은 cosmetic-only이므로, 표시는 pet type별 관계·종별 시간·선택한 펫 전용 progress를 암시하지 않습니다. 외형 변경은 global together-time을 바꾸지 않습니다.
6. 표시는 unlock, 능력치, reward, economy, rarity, streak, loss, daily goal, completion, 경쟁 또는 소셜 자격을 만들지 않습니다.
7. 정확한 duration format, 관계 문구 catalogue, time rate, data persistence/migration과 localization은 후속 단일 Phase 2 계약에서 정합니다. 관계 문구를 위한 새 runtime art/animation도 이 결정의 범위가 아닙니다.

## Alternatives and disposition

| Candidate | Disposition | Reason |
| --- | --- | --- |
| A. 앨범/동반자 화면의 함께한 시간 + 조용한 관계 문구 | **ADOPT** | 휴식을 timer/level loop로 바꾸지 않으면서 시간의 의미를 전달한다. 현재 AlbumView를 첫 소비처로 재사용한다. |
| B. 3~5단계 친밀도와 드문 milestone 축하 알림 | REJECT | 성장 감각은 분명하지만 항해 중 보상 기대와 popup 압박을 만든다. |
| C. 수치 없이 idle/자리 변화만으로 표현 | DEFER | 가장 자연스럽지만 새 animation/art와 Human interpretation 검증이 선행돼야 한다. |

## Current implementation conflict

Current `main` remains action-based and product-superseded:

- `scripts/core/game_state.gd` uses `companion_affection: int` and `_increase_affection()` from photo, scenery, and letter counts.
- `scripts/voyage/game_scene.gd` puts `동반자 Lv %d` in `MoodStatusLabel`, creating a live voyage-facing level.
- `scripts/ui/album_view.gd` also displays `동반자 호감도: Lv %d`.
- album capture/contract tests seed and assert the old placeholder state.

These facts are implementation evidence only. They do not satisfy the approved time source or quiet presentation.

## Future implementation contract boundary

A later single implementation contract must:

1. replace action-based affection mutation with active foreground voyage-time accumulation and explicit local persistence/migration;
2. remove live `Lv` display from GameScene and show the approved album summary without introducing a new screen;
3. define duration formatting and a non-pressuring relation-copy catalogue without level thresholds or reward mechanics;
4. preserve Normal/Appreciation parity, post-record resting, cosmetic identity neutrality, and no background-time accrual;
5. update focused tests and 540×960 Game/Album runtime captures;
6. keep automated proof separate from Human review of whether the album summary feels warm rather than like an obligation.

No GDScript, Scene, UI, Resource, visual asset, text catalogue, saved data, runtime evidence, or Human usability PASS is created by this decision packet.

## Provenance and disposition

- User approved the GPT recommendation, Alternative A, on 2026-08-28.
- `NO_BASE_PROMOTION`: this rest-first affection presentation belongs to My Little Boat and is not a reusable Base workflow rule.
