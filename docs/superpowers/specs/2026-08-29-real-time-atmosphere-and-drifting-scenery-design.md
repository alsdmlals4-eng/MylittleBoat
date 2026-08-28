# 현실 시간 분위기와 흘러가는 풍경 구현 설계

**상태:** `CONFIRMED_IMPLEMENTATION_INPUT`

**제품 정본:** [프로젝트 GDD](../../design/PROJECT_GDD.md)

**실제 구현 상태:** [현재 Godot handoff](../../handoffs/CURRENT_GODOT_IMPLEMENTATION.md)

## 1. 목적

플레이어가 아무것도 고르지 않고 보트 위에 도착했을 때, 현실의 낮·밤과 플레이 중 천천히 지나가는 주변 풍경으로 바다가 살아 있다고 느끼게 합니다. 이 변화는 보상이나 목표가 아니라 휴식을 돕는 배경입니다.

## 2. 확정 규칙

### 현실 시간 분위기

기기의 현지 시간을 읽어 아래 상태를 자동 적용합니다.

| 현지 시각 | 상태 | 화면 의미 |
| --- | --- | --- |
| 05:00–08:59 | `dawn` | 옅은 새벽빛과 차분한 수면 |
| 09:00–16:59 | `bright` | 맑고 열린 낮 바다 |
| 17:00–20:59 | `sunset` | 부드러운 해질녘 반사 |
| 21:00–04:59 | `night` | `INDIGO_RAIN_REFLECTION`의 인디고 밤바다 |

- 시작, 앱 재집중, 30초 주기 확인 때 현재 상태를 다시 읽습니다.
- 상태 경계에서는 같은 보트·카메라·UI 안에서 sky, light, sea tone만 약 1.5초에 걸쳐 부드럽게 이어집니다.
- 수동 selector, saved atmosphere, 시간대에 따른 보상·기억·호감도·세션 시간 변화는 없습니다.
- 시스템 시계가 비정상이거나 읽기 실패하면 `bright`로 안전하게 보입니다. 기기 시계를 바꿔도 시각만 바뀝니다.

### 흘러가는 풍경

- `GameScene`이 앱 focus를 가진 동안에만 active foreground 시간이 누적됩니다. background, pause, 다른 앱 전환 시간은 누적하지 않습니다.
- 첫 약 90–150초에는 넓은 열린 바다를 유지합니다. 그 뒤 먼 부표·작은 섬·등대처럼 수평선의 작은 구조물과 주변 풍경이 보트와 무관하게 천천히 지나갑니다.
- 명목 5분 안에는 약 1–2개의 풍경 장면을 목표로 합니다. 이 장면이 개인 memory로 저장되는 일은 확률형이며 zero도 정상입니다.
- memory가 저장되는 경우만 작고 사라지는 알림을 냅니다. 구조물은 탭할 수 없고, 놓쳐도 손해·재시도·보상·작업 목록이 없습니다.
- 구현 첫 배치는 existing visual lock을 지키는 far-distance scenery만 포함합니다. 새 UI, 지역 지도, 수집 점수, NPC 대화, 날씨 위험, social 기능은 포함하지 않습니다.

## 3. 구현 경계

| owner | 변경 |
| --- | --- |
| `project.godot` | 시작 Scene을 `game.tscn`으로 변경 |
| `scripts/voyage/time_of_day_catalog.gd` | 시간 ID와 tone은 유지하고, hour mapping을 테스트 가능한 함수로 추가 |
| `scripts/core/game_state.gd` | mood와 selected-time preference를 retire하고 mood 없는 항해 시작으로 변경 |
| `scripts/voyage/game_scene.gd` | 현실 시간 refresh, focus notification, mood tone 제거, passive scenery consumer 연결 |
| `scripts/voyage/drift_scenery_director.gd` | active foreground elapsed와 distant scenery/memory 기회를 관리하는 작은 owner |
| `scenes/game.tscn` | refresh timer, distant scenery anchor, optional low-UI notification surface 추가 |
| `scenes/main_menu.tscn`, `scripts/ui/main_menu.gd` | 시작 route에서 retire. 더 이상 main scene이나 제품 consumer가 아님 |
| tests/captures | mood/main-menu selection contract를 direct entry, hour mapping, foreground-only scenery, no-selection screen contract로 교체 |

`Time.get_time_dict_from_system(false)`는 현지 시간이라는 제품 의도에 사용합니다. Godot는 system clock을 정밀 시간 계산에 쓰지 말라고 명시하므로 scenery progress는 `delta`와 focus notification으로만 누적합니다. [Godot Time](https://docs.godotengine.org/en/stable/classes/class_time.html), [Godot Node application focus notifications](https://docs.godotengine.org/en/stable/classes/class_node.html)

## 4. 검증 계약

자동 검증은 실제 컴퓨터 시계에 의존하지 않습니다. hour·focus·경과 시간은 test에서 주입합니다.

1. hour `5`, `9`, `17`, `21`, `0`가 각각 승인된 atmosphere ID를 반환합니다.
2. 시스템 시간이 아닌 test hour가 달라도 voyage record, memory, affection, speed는 바뀌지 않습니다.
3. main scene이 `game.tscn`이고 mood/identity/pet/time startup panel이 first view에 존재하지 않습니다.
4. focus-in 상태에서만 scenery director의 elapsed와 다음 풍경 기회가 진행합니다.
5. focus-out, pause, 재개 전에는 scenery elapsed가 증가하지 않습니다. 재집중 때 현실 시간 tone은 즉시 다시 맞춥니다.
6. memory notification은 저장 성공 때만 잠깐 보이고, scenery 자체에 button·reward·실패 경로가 없습니다.
7. headless scene smoke와 540 x 960 runtime capture에서 보트-waterline·수평선·시간대별 visual grammar를 확인합니다.
8. 사람은 실제 기기에서 낮/밤 각각 30초, 한 번의 5분 휴식, 앱 전환 후 복귀를 확인합니다. 이 Human evidence 전에는 comfort `PASS`를 주장하지 않습니다.

## 5. 적대적 검토 기준

| 공격 | 방어 기준 |
| --- | --- |
| 현실 시계를 progression exploit로 쓰는가 | 시계는 visual only. 모든 progress는 focus가 있는 `delta`만 쓴다. |
| 자동 변화가 방치 보상·FOMO가 되는가 | 기억은 zero가 정상이고, missed-event penalty·목표·알림 누적이 없다. |
| 낮·밤이 다른 게임처럼 보이는가 | 같은 boat/camera/material/UI grammar 안에서 tone과 distant scenery만 바꾼다. |
| 풍경 때문에 새 콘텐츠·UI·경제가 불어나는가 | 첫 batch는 distant passive scenery와 small memory notification만이다. |
| 자동 test가 실제 시계나 GPU capture를 과장하는가 | clock/focus를 주입하고, runtime capture와 Human evidence를 별도 상태로 기록한다. |

## 6. 이번 변경에서 하지 않는 일

- 계절, 위치 기반 천문 계산, 날씨 API, 온라인 동기화.
- player-controlled time selection, saved atmosphere, gameplay effect.
- structure interaction, collectible map, quest, currency, fishing reward expansion.
- 동반자 함께 보낸 시간의 rate/threshold 구현. 이 시스템은 active foreground 원칙만 공유하며 별도 계약으로 유지합니다.
