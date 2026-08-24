# Calm Voyage + Fishing Vertical Slice Design

## Goal

현재 버튼형 MVP 골격을 마이 리틀 보트의 핵심 약속인 **조용한 5분 항해 → 작은 발견 → 개인적인 기억 축적**을 실제로 검증할 수 있는 작은 Vertical Slice로 올린다. 낚시는 이 루프를 대체하지 않는 선택형 보조 콘텐츠로만 추가한다.

## Protected identity

- Godot 4.7 stable + GDScript.
- 모바일 세로 우선, PC 마우스 지원.
- 플레이어 몸은 보이지 않는다.
- 전투, 체력, 피해, 사망, 실패 조건, 경쟁 점수, 결제, 광고, 온라인 편지 공유를 추가하지 않는다.
- 런타임 생성형 AI와 유료 API를 추가하지 않는다.
- 바다·빛·파도·작은 발견이 콘텐츠이며, 버튼이 콘텐츠를 즉시 지급하는 구조를 핵심 루프로 만들지 않는다.

## Player promise

플레이어는 오늘의 마음을 고르고 작은 보트에 앉아 약 5분 동안 바다에 머문다. 사진·감상모드·속도조절은 항해의 감각을 조절하는 도구이고, 풍경·병 속 편지·낚시는 항해 중 자연스럽게 발생하는 작은 발견이다. 항해가 끝나면 성공/실패가 아니라 오늘의 기억 하나가 남는다.

## Architecture

### GameState — persistent memory + active voyage state

`GameState`가 Scene 전환보다 오래 살아야 하는 상태를 소유한다.

**누적 기억**
- photos
- sceneries
- letters
- fish
- voyage_records
- companion_affection

**현재 항해**
- selected_mood
- voyage_active
- remaining_seconds
- speed_index
- appreciation_mode
- voyage_record_created
- pending_discovery_type
- pending_discovery_value

`reset_session()`은 호환성을 위해 유지하되, 누적 기억을 삭제하지 않고 현재 항해의 transient state만 초기화한다. 새 항해는 `begin_voyage(mood)`를 통해 시작한다.

### FishingSession — 작은 독립 상태 머신

낚시는 경제/장비/전투 시스템이 아니라 한 번의 조용한 기다림을 모델링한다.

상태:

`IDLE → WAITING → BITE_READY → IDLE`

- `cast_line(wait_seconds)`로 시작한다.
- `advance(delta)`가 기다림을 진행한다.
- 입질 뒤 한 번의 입력으로 잡는다.
- 실패 패널티, 줄 내구도, 점수, 판매가, 희귀도 최적화는 이번 Slice에 없다.
- 잡은 물고기는 `GameState.add_fish()`를 통해 앨범 기억으로 남긴다.

### Ambient Discovery

`편지 발견`, `풍경 기록`은 항상 누를 수 있는 보상 버튼이 아니다.

- 항해 중 일정 시간이 지나면 `pending_discovery`가 생긴다.
- 편지 또는 풍경 중 하나가 현재 발견으로 나타난다.
- 해당 기록 버튼만 잠시 노출한다.
- 기록하지 않아도 실패나 손해가 없다.
- 다음 발견은 다시 기다린 뒤 생긴다.

### Appreciation Mode

감상모드가 켜지면 핵심 감상 외 UI를 실제로 줄인다.

- 사진, 속도, 앨범, 낚시, 발견 버튼과 상단 상태 정보를 숨긴다.
- 감상모드 버튼만 남겨 언제든 돌아올 수 있게 한다.
- 타이머는 내부에서 계속 진행한다.

### Speed Control

속도는 보상 효율이 아니라 체감 리듬을 바꾼다.

- 느림/보통/빠름은 세션 길이와 보상량을 바꾸지 않는다.
- 카메라/보트의 미세 bob 주파수와 이동 리듬만 바꾼다.

### Album / voyage record

앨범 Scene을 열었다 돌아와도 현재 항해 상태는 `GameState`에 남는다. 5분이 끝나면 `complete_voyage()`가 정확히 한 번만 `voyage_records`에 항목을 추가한다.

앨범은 사진/풍경/편지/물고기/항해 기록 수와 최근 기록을 보여준다.

## Fishing benchmark trade study

1. **대규모 Fishing RPG** — 어종, 장비, 미끼, 판매, 요리, 경제를 중심으로 확장. 현재 프로젝트 정체성과 유지비에 비해 과함. REJECT for current slice.
2. **힘겨루기/텐션 미니게임** — 낚시 손맛은 강하지만 입력 실패와 반복 마찰이 핵심 Calm 경험 검증을 방해할 위험이 큼. DEFER.
3. **기다림 기반 선택형 낚시** — 던지고 기다린 뒤 입질에 한 번 반응한다. 항해의 템포를 깨지 않고 작은 발견을 더한다. ADAPT / SELECTED.

## Acceptance

- 새 항해가 photos/sceneries/letters/fish/voyage_records를 삭제하지 않는다.
- 앨범 왕복 뒤 remaining_seconds와 현재 항해 상태가 유지된다.
- 5분 종료는 항해 기록을 정확히 1개 만든다.
- 감상모드는 UI를 실제로 줄이며 되돌릴 수 있다.
- 속도 3단계가 실제 보트/카메라의 미세 리듬을 변화시킨다.
- 풍경/편지는 ambient discovery가 있을 때만 기록 가능하다.
- 낚시는 cast → wait → bite → catch가 되고 실패/점수/경제가 없다.
- 물고기 기록이 앨범에 누적된다.
- Godot 4.7 headless project smoke + focused behavior tests가 PR에서 GREEN이다.
- Human usability / player emotion evidence는 실제 관찰 전까지 NOT_RUN이다.

## Deferred

- 앱 재실행을 넘는 save file persistence.
- 실제 사진 PNG 저장.
- 어종 대량화, 미끼, 장비, 낚시 경제, 요리, 판매, 도감 희귀도 최적화.
- 실제 제작 아트/오디오 및 승인 Visual.
- 최종 모바일 실기기/Human QA.