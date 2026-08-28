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
CURRENT_MAIN_IMPLEMENTATION = ACTION_GATED_PENDING_DISCOVERY_AND_PRODUCT_SUPERSEDED
RUNTIME_IMPLEMENTATION = NOT_STARTED
HUMAN_PLAYER_EXPERIENCE_VALIDATION = NOT_RUN
```

## User decision

Ambient Discovery는 플레이어가 버튼을 눌러 기록할지 결정하는 선택형 미션이 아니라, 항해 중 낮은 빈도로 자연스럽게 지나가는 **확률형 순수 배경 연출**입니다. 등장하면 작은 알림이 잠시 보이고, 그 장면은 즉시 로컬 항해 기억으로 자동 저장됩니다.

플레이어의 일은 이를 놓치지 않기 위해 화면을 감시하거나 반응하는 것이 아닙니다. 운 좋게 목격한 바다·하늘·먼 거리의 작은 변화가 `잔잔함 ≠ EMPTY`를 지지하고, 나중에 앨범에서 조용히 남는 경험입니다.

## Binding product rules

1. 활성 항해 화면에서만 확률적으로 한 번의 background-only ambient event가 나타날 수 있습니다. 승인된 밀도 target은 명목상 5분 항해에 대체로 1~2회이며, 첫 event는 보장하지 않습니다. exact probability, minimum/maximum cooldown, catalogue와 visual asset은 후속 구현계약에서 정합니다.
2. event는 Normal Diorama와 Appreciation Camera 모두에서 같은 휴식 경험의 일부로 동작합니다. Appreciation Camera에서는 감상을 가리지 않는 더 작은 비차단 알림만 남깁니다.
3. 알림은 button, dismiss action, countdown, modal, choice, badge stack, sound cue 또는 재촉 문구 없이 자동으로 사라집니다.
4. 등장 즉시 해당 event는 로컬 `ambient memory`로 저장됩니다. 플레이어의 입력, 사진 촬영, 별도 수집 확인은 필요하지 않습니다.
5. `ambient memory`는 FriendBottle / DriftBottle, 병편지, 외부 메시지, UGC, 소셜 알림이 아닙니다. 임의의 배경 발견을 `letter`로 autosave하는 것은 금지합니다.
6. Ambient Discovery는 동반자 호감도, 보상, 경제, 물고기, 꾸미기, 점수, unlock, 세션 timer, mood, time-of-day, camera 또는 소셜 자격을 바꾸지 않습니다.
7. event가 겹치거나 짧은 시간에 연속으로 주의를 빼앗지 않도록 one-at-a-time / low-density를 보호합니다. 0회인 항해도 정상이며, 메인 메뉴, 앨범, 백그라운드 또는 일시정지된 항해에는 나타나지 않습니다.
8. 저장은 `local-first`입니다. 일일 숙제, 놓침 패널티, completion rate, streak, 희귀도, 확률 구매, FOMO를 만들지 않습니다.

## Current implementation conflict

Current `main` has an action-gated, product-superseded discovery implementation:

- `scripts/voyage/game_scene.gd` schedules a discovery, creates `letter` or `scenery`, shows `LetterButton` / `SceneryButton`, waits up to 18 seconds, and then clears it if the player does nothing.
- `GameState.set_pending_discovery` stores a pending choice rather than immediately storing a neutral local ambient memory.
- `_record_pending_letter` and `_record_pending_scenery` mutate the old memory paths only after a button press.
- `GameState.add_scenery` and `add_letter` currently reach the old action-based `_increase_affection` placeholder. That conflicts with the separately approved time-based affection direction as well as this decision.

The current code is evidence of an earlier technical slice, not evidence that the approved passive behavior is implemented.

## Future implementation contract boundary

A later single Phase 2 implementation contract must define and verify:

1. a local ambient-memory data type and album/voyage presentation that is distinct from Bottle/letter data;
2. random low-density scheduling, one-at-a-time guarding, and foreground voyage lifecycle behavior;
3. a small auto-fading notification compatible with both camera modes;
4. immediate local persistence plus a migration choice for existing pending discoveries;
5. removal or retirement of the Letter/Scenery action buttons and pending-choice semantics without changing unrelated fishing, photo, decor, interaction, timer, or camera behavior;
6. automated proof for no input requirement, no missed-event penalty, auto-save, no affinity mutation, no Bottle semantics, camera parity, no background accrual, and no duplicate event overlap;
7. 540×960 runtime evidence and separate Human 5-minute calm/noticeability judgment.

No Godot scene, script, resource, production visual asset, probability value, event catalogue, audio cue, or Human UX PASS is created by this decision packet.

## Provenance and disposition

- User selected the recommended **B** alternative: an event that remains entirely in the background, with a small notification and automatic save on appearance.
- `NO_BASE_PROMOTION`: the particular relation between ambient discovery, album memory, and rest-first pressure is specific to My Little Boat rather than reusable Base workflow policy.
