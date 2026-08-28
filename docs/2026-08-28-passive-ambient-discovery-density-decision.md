# Passive Ambient Discovery Density Decision · 2026-08-28

## Status

```text
DECISION = USER_APPROVED_PRODUCT_DIRECTION
TRACKING_ISSUE = #95
AMBIENT_DISCOVERY_DENSITY_TARGET = APPROXIMATELY_1_TO_2_PER_NOMINAL_5_MINUTE_VOYAGE
FIRST_DISCOVERY_GUARANTEE = FORBIDDEN
ONE_AT_A_TIME = REQUIRED
EXACT_PROBABILITY_AND_COOLDOWN = PHASE_2_IMPLEMENTATION_CONTRACT_REQUIRED
CURRENT_MAIN_IMPLEMENTATION = EARLY_FORCED_AND_HIGHER_FREQUENCY_PRODUCT_SUPERSEDED
RUNTIME_IMPLEMENTATION = NOT_STARTED
HUMAN_PLAYER_EXPERIENCE_VALIDATION = NOT_RUN
```

## User approval

사용자는 권장안 A를 승인했습니다. Ambient Discovery는 명목상 5분 항해에서 **대체로 1~2회** 보이는 낮은 밀도를 목표로 합니다. 이 값은 `반드시 한 번 이상`이나 `정확히 두 번`을 약속하는 timer가 아니라, 잔잔함을 깨지 않으면서 바다가 비어 보이지 않게 하는 경험 목표입니다.

첫 발견은 보장하지 않습니다. 어떤 5분 항해는 발견 없이 지나갈 수 있으며, 그것은 놓친 보상이나 실패가 아닙니다. 항해 기록 이후 같은 화면에서 더 머물면 같은 낮은 밀도 원칙이 이어지되, 짧은 시간에 알림이 몰리거나 보상처럼 반복되어서는 안 됩니다.

## Binding product rules

1. `약 5분`의 정상 활성 항해에서 관찰 가능한 event 수는 대체로 1~2회를 목표로 합니다. 이 target은 첫 5분과 이후 연속 휴식 모두에 적용되는 density envelope입니다.
2. 첫 event는 보장하지 않고, zero-event voyage도 정상적인 휴식 결과입니다. 플레이어에게 예상 시간, 남은 횟수, 확률, cooldown 또는 missed-event를 보여 주지 않습니다.
3. event는 계속 확률적으로 발생하며 one-at-a-time을 지킵니다. 직전 event의 작은 알림이 사라지고 auto-save가 끝나기 전에는 새 event가 겹치지 않습니다.
4. exact probability, minimum/maximum cooldown, random seed policy, event catalogue별 weight와 session-boundary handling은 후속 단일 Phase 2 구현계약에서만 정합니다.
5. 밀도는 Normal Diorama와 Appreciation Camera에서 같은 휴식 약속을 지킵니다. 카메라 전환, 속도, 마음, 시간대, 외형, 사진, 낚시, 꾸미기, 상호작용, 호감도 또는 Ambient memory 수는 발생률을 가산·감산하지 않습니다.
6. 밀도는 reward cadence가 아닙니다. 점수, progress, rarity, collection completion, streak, purchase, 알림 stack, FOMO, player action requirement를 만들지 않습니다.

## Alternatives and disposition

| Candidate | Disposition | Reason |
| --- | --- | --- |
| A. 대체로 1~2회 / 첫 등장 보장 없음 | **ADOPT** | 5분 안에 바다가 살아 있음을 느낄 기회를 주면서 알림 리듬과 관찰 압박을 낮춘다. |
| B. 2~4회 | REJECT | 변화는 늘지만 작은 알림이 시스템의 반복 신호처럼 읽히고 motif 제작량도 증가한다. |
| C. 0~1회 | REJECT | 가장 조용하지만 첫 세션에서 `EMPTY`로 오해될 가능성이 커진다. |

## Current implementation conflict

Current `main` uses an earlier action-gated schedule in `scripts/voyage/game_scene.gd`:

- first discovery is scheduled in 18–30 seconds, effectively guaranteeing an early prompt;
- later discovery waits are 35–60 seconds, so a nominal five-minute voyage can produce substantially more than the approved density;
- Appreciation Camera stops the scheduler entirely;
- each discovery is a timed `letter`/`scenery` button offer rather than a passive auto-save.

This is implementation evidence for a superseded technical slice, not evidence of the approved density or passive behavior.

## Future implementation contract boundary

A later single Phase 2 implementation contract must:

1. define an algorithm whose sampled active-voyage behavior stays within the approved 1–2-per-5-minute density target without a first-event guarantee;
2. preserve one-at-a-time, foreground-only lifecycle, Normal/Appreciation parity, post-record resting, and no burst after scene return;
3. keep the passive auto-save and no-reward boundaries from `docs/2026-08-28-passive-ambient-discovery-decision.md`;
4. specify deterministic test hooks and distribution-oriented automated checks without asserting that every individual voyage has an event;
5. capture 540×960 runtime evidence and run separate Human five-minute `CALM / EMPTY / NOTICEABILITY` review.

No probability value, cooldown, code, Scene, UI, asset, audio, runtime evidence, or Human UX PASS is created by this decision packet.

## Provenance and disposition

- User approved the GPT recommendation, Alternative A, on 2026-08-28.
- `NO_BASE_PROMOTION`: the density envelope is a My Little Boat rest-loop tuning decision, not a reusable Base workflow rule.
