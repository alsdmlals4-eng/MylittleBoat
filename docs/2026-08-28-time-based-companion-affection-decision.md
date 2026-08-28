# Time-Based Companion Affection Decision · 2026-08-28

## Status

```text
DECISION = USER_APPROVED_PRODUCT_DIRECTION
TRACKING_ISSUE = #89
COMPANION_AFFECTION_SOURCE = ACTIVE_FOREGROUND_VOYAGE_TIME
OPTIONAL_ACTION_AFFECTION_SOURCE = FORBIDDEN
CURRENT_MAIN_IMPLEMENTATION = ACTION_BASED_AND_PRODUCT_SUPERSEDED
RUNTIME_IMPLEMENTATION = NOT_STARTED
HUMAN_PLAYER_EXPERIENCE_VALIDATION = NOT_RUN
```

## User decision

동반자 호감도는 사진·풍경·편지·낚시·꾸미기·상호작용을 얼마나 자주 했는지가 아니라, 해당 동반자와 함께 게임을 켜 두고 보낸 시간에 따라 천천히 증가합니다.

이 결정의 목적은 `아무것도 하지 않아도 완전한 플레이`라는 rest-first 약속을 보호하는 것입니다. 플레이어가 바다를 바라보거나, 캐릭터와 펫이 쉬는 모습을 보기만 해도 함께 보낸 시간은 동등하게 의미가 있습니다.

## Binding product rules

1. 호감도는 활성 상태의 항해 화면에서 경과한 실제 시간만 누적합니다. Normal Diorama와 Appreciation Camera는 같은 항해 시간이므로 동일하게 누적합니다.
2. 화면을 터치하지 않아도 누적합니다. 낚시 대기·그냥 머물기·보트 보기·펫 보기 사이에 효율 차이가 없습니다.
3. 현재 선택 가능한 고양이·토끼·강아지·수달은 외형 선택이므로, 호감도는 pet type별 별도 ledger가 아닌 전역 `함께 보낸 시간`입니다. 외형을 바꿔도 잃거나 초기화되지 않으며, 종에 따른 증가율 차이도 없습니다.
4. 사진, 풍경, 편지, 물고기, Ambient Discovery, 꾸미기, 저압력 상호작용, 마음, 시간대, 속도 조절은 호감도의 원천·가산치·배율이 될 수 없습니다.
5. 앱이 백그라운드·일시정지되어 실제 항해 프레임이 진행되지 않는 시간, 메인 메뉴와 앨범에 머문 시간은 동반자와 보낸 항해 시간으로 계산하지 않습니다.
6. 5분 항해 기록이 만들어진 뒤에도 플레이어가 같은 항해 화면에서 더 머물면 그 시간은 누적할 수 있습니다. 다음 항해를 시작할 필요가 없습니다.
7. 호감도는 손실, 방치 패널티, streak, 일일 숙제, 능력치, 경제 효율, 경쟁, 소셜 자격을 만들지 않습니다.
8. 현재 단계에서는 호감도 수치가 능력치나 unlock 조건을 만들지 않습니다. 추후 idle/자리 변화 같은 정서적 표현을 연결하려면 별도 승인과 Human evidence가 필요합니다.

## Rate and presentation boundary

- `companion_affection`의 정확한 분당 증가량, 레벨 임계값, 표시 문구와 저장 migration은 아직 `PHASE_2_IMPLEMENTATION_CONTRACT_REQUIRED`입니다.
- 현행 `Lv 1..3`은 action-based placeholder의 구현 수치일 뿐, 시간 기반 호감도의 균형 정본이 아닙니다.
- 구현 시 시간은 플레이어의 휴식 자체를 보이는 작은 동행 기록으로 읽혀야 하며, 진행 바·알림·팝업으로 휴식을 방해하지 않습니다.

## Current conflict and required future verification

Current `main` has `GameState.add_photo`, `add_scenery`, and `add_letter` call `_increase_affection`; `game_scene.gd` and `album_view.gd` show `동반자 Lv`. These are technically implemented but product-superseded by this decision.

A later, separately approved single implementation contract must:

1. remove optional-action affection mutation;
2. accumulate only active foreground voyage time without speed multiplier;
3. preserve Normal/Appreciation parity and post-record resting;
4. define local persistence and migration explicitly;
5. test no action farming, no background-time accrual, scene-return continuity, and no new failure/pressure behavior;
6. capture real 540×960 runtime evidence and leave Human 5-minute calm/pressure judgment explicitly separate.

## Provenance and disposition

- User selected the earlier recommendation to remove action-based farming, with the refinement that affection should grow from time spent together.
- `NO_BASE_PROMOTION`: this is a My Little Boat-specific rest-loop rule and does not generalize to Base workflow policy.
