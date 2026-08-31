# Passive Ambient Discovery Decision · 2026-08-28

## Status

```text
DECISION = USER_APPROVED_PRODUCT_DIRECTION
TRACKING_ISSUE = #91
AMBIENT_DISCOVERY_MODE = RANDOM_PASSIVE_BACKGROUND_MEMORY
PLAYER_ACTION_REQUIRED = FALSE
TRANSIENT_NOTIFICATION = SMALL_NON_BLOCKING_AUTO_FADE
AUTOSAVE = LOCAL_AMBIENT_MEMORY
BOTTLE_LETTER_AUTOSAVE = FORBIDDEN
COMPANION_AFFECTION_EFFECT = FORBIDDEN
APPROVED_DENSITY_TARGET = APPROXIMATELY_1_TO_2_PER_NOMINAL_5_MINUTE_VOYAGE
FIRST_DISCOVERY_GUARANTEE = FORBIDDEN
<<<<<<< HEAD
CURRENT_CADENCE = FIRST_OPPORTUNITY_90_TO_150_SECONDS_THEN_65_PERCENT_EMIT_PER_OPPORTUNITY_FOLLOW_UP_120_TO_180_SECONDS
CURRENT_MAIN_IMPLEMENTATION = PASSIVE_FOREGROUND_DIRECTOR_WITH_NAMED_LOCAL_AMBIENT_PERSISTENCE_AND_NO_FIRST_EVENT_GUARANTEE
CURRENT_APPROVED_MOTIF_SET = MLB_AMB_MOTIF_001_TO_006
RUNTIME_IMPLEMENTATION = IMPLEMENTED_MACHINE_VERIFIED_RUNTIME_CAPTURE_VERIFIED
=======
CURRENT_MAIN_IMPLEMENTATION = FOREGROUND_ONLY_DRIFTING_SCENERY_WITH_LOCAL_AUTOSAVE
RUNTIME_IMPLEMENTATION = IMPLEMENTED_AND_TESTED
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
HUMAN_PLAYER_EXPERIENCE_VALIDATION = NOT_RUN
```

## User decision

Ambient Discovery는 플레이어가 버튼을 눌러 기록할지 결정하는 선택형 미션이 아니라, 항해 중 낮은 빈도로 자연스럽게 지나가는 **확률형 순수 배경 연출**입니다. 등장하면 작은 알림이 잠시 보이고, 그 장면은 즉시 로컬 항해 기억으로 자동 저장됩니다.

플레이어의 일은 이를 놓치지 않기 위해 화면을 감시하거나 반응하는 것이 아닙니다. 운 좋게 목격한 바다·하늘·먼 거리의 작은 변화가 `잔잔함 ≠ EMPTY`를 지지하고, 나중에 앨범에서 조용히 남는 경험입니다.

## Binding product rules

1. 활성 항해 화면에서만 확률적으로 한 번의 background-only ambient event가 나타날 수 있습니다. 승인된 밀도 target은 명목상 5분 항해에 대체로 1~2회이며, 첫 event는 보장하지 않습니다. 현재 v1은 첫 **기회**를 90–150초에 예약하고, 각 기회에서 65% 확률로만 event를 표시합니다. 표시하지 않은 기회와 표시한 기회 모두 다음 기회는 120–180초 뒤에 예약합니다. 이 수치는 화면에 보이지 않으며, 새 motif·weight·density 변경은 새 구현계약에서만 정합니다.
2. event는 Normal Diorama와 Appreciation Camera 모두에서 같은 휴식 경험의 일부로 동작합니다. Appreciation Camera에서는 감상을 가리지 않는 더 작은 비차단 알림만 남깁니다.
3. 알림은 button, dismiss action, countdown, modal, choice, badge stack, sound cue 또는 재촉 문구 없이 자동으로 사라집니다.
4. 등장 즉시 해당 event는 로컬 `ambient memory`로 저장됩니다. 플레이어의 입력, 사진 촬영, 별도 수집 확인은 필요하지 않습니다.
5. `ambient memory`는 FriendBottle / DriftBottle, 병편지, 외부 메시지, UGC, 소셜 알림이 아닙니다. 임의의 배경 발견을 `letter`로 autosave하는 것은 금지합니다.
6. Ambient Discovery는 동반자 호감도, 보상, 경제, 물고기, 꾸미기, 점수, unlock, 세션 timer, mood, time-of-day, camera 또는 소셜 자격을 바꾸지 않습니다.
7. event가 겹치거나 짧은 시간에 연속으로 주의를 빼앗지 않도록 one-at-a-time / low-density를 보호합니다. 0회인 항해도 정상이며, 메인 메뉴, 앨범, 백그라운드 또는 일시정지된 항해에는 나타나지 않습니다.
8. 저장은 `local-first`입니다. 일일 숙제, 놓침 패널티, completion rate, streak, 희귀도, 확률 구매, FOMO를 만들지 않습니다.

<<<<<<< HEAD
## Historical implementation conflict

The following describes the pre-2026-08-30 action-gated baseline, not the current product route:

- `scripts/voyage/game_scene.gd` schedules a discovery, creates `letter` or `scenery`, shows `LetterButton` / `SceneryButton`, waits up to 18 seconds, and then clears it if the player does nothing.
- `GameState.set_pending_discovery` stores a pending choice rather than immediately storing a neutral local ambient memory.
- `_record_pending_letter` and `_record_pending_scenery` mutate the old memory paths only after a button press.
- `GameState.add_scenery` and `add_letter` currently reach the old action-based `_increase_affection` placeholder. That conflicts with the separately approved time-based affection direction as well as this decision.

That code was evidence of an earlier technical slice and must not be used as current evidence.
=======
## Current implementation receipt

- `scripts/voyage/drift_scenery_director.gd` accumulates only active foreground delta, waits roughly 90–150 seconds before each opportunity, and produces a buoy, islet, or lighthouse event with an independent memory-save chance.
- `scripts/voyage/game_scene.gd` consumes the event without a button, task, reward, countdown, or response requirement. It moves one input-free horizon prop across the screen and, only for a save event, shows a 2.5-second auto-fading notification.
- `scripts/core/ambient_memory_persistence.gd` writes the shared `GameState.sceneries` album list when an automatic sighting occurs to `user://ambient_memories_v1.cfg`. Saved order and duplicate sightings are preserved; the path is distinct from letter/Bottle data and does not alter affinity.
- `tests/test_drift_scenery_director.gd`, `tests/test_ambient_memory_persistence.gd`, `tests/test_ambient_memory_game_state_roundtrip.gd`, and `tests/test_distant_scenery_runtime_contract.gd` cover foreground-only advancement, local persistence, duplicate round-trip, and the actual runtime consumer.

The 540 x 960 capture verifies the islet consumer can render. Human judgement of the nominal five-minute frequency and notification quietness remains `NOT_RUN`.
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564

## Current implementation receipt

`DriftSceneryDirector` now manages an active-foreground first opportunity at 90–150 seconds. Each opportunity independently rolls 65% before creating the non-interactive scene, and both an empty opportunity and a displayed scene schedule the next opportunity at 120–180 seconds. `GameScene` keeps the note non-interactive; only `save_memory=true` calls `GameState.record_ambient_memory`. `AmbientMemoryPersistence` immediately writes the normalized string ledger to `user://ambient_memory_v1.cfg`, and startup restores it to the existing Album scenery consumer. A zero-event five-minute foreground voyage is an automated valid outcome, not a missed reward.

Automated contracts cover foreground cadence including a valid zero-event five-minute voyage, no input/no together-time side effect, malformed ConfigFile values, named writer isolation, and scene-to-storage restore. The earlier controlled bright-lagoon capture is historical. The current receipt is six controlled 540×960 GPU captures for `MLB-AMB-MOTIF-001..006`, one per approved local-time landscape. These do not prove Human five-minute calm, noticeability, text readability, or device comfort.

<<<<<<< HEAD
## Remaining review boundary

1. Run a separate Human five-minute `CALM / EMPTY / NOTICEABILITY` review in both camera modes.
2. Keep photo, letter, fish, and voyage-record full persistence out of this ambient-only completion claim.
3. Do not add Bottle semantics, score, progress, or a new collection surface while polishing this slice.


이 원래 결정 packet 자체는 당시 Godot scene, script, resource, production visual asset, probability value, event catalogue, audio cue, or Human UX PASS를 만들지 않았습니다. 위 current implementation receipt는 2026-08-30의 별도 구현·검증 결과입니다.
=======
The decision packet itself did not create runtime proof. Issue #101 subsequently created the bounded Godot consumer described above. It still does not prove Human UX PASS, audio comfort, mobile performance, or a broader production asset batch.
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564

## Provenance and disposition

- User selected the recommended **B** alternative: an event that remains entirely in the background, with a small notification and automatic save on appearance.
- User approved the exact v1 no-guarantee cadence on 2026-08-30: first opportunity 90–150 seconds, 65% display chance per opportunity, and 120–180 second follow-up opportunities after either result.
- `NO_BASE_PROMOTION`: the particular relation between ambient discovery, album memory, and rest-first pressure is specific to My Little Boat rather than reusable Base workflow policy.
