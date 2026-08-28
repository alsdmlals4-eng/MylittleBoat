# Direct entry runtime correction · 2026-08-29

## Incident

승인된 direct boat entry를 구현하는 동안 첫 runtime capture에서 세 가지 product-risk가 확인됐다.

1. 첫 night art는 낮 배경과 수평선 위치가 달라 보트가 바다 대신 sky 위에 떠 있는 듯 보였다.
2. hull과 sea 사이의 빈 틈 때문에 보트가 합성 sticker처럼 읽혔다.
3. 첫 distant scenery Sprite3D는 camera-attached backdrop에 가려 실제 runtime에서 보이지 않았다.
4. foreground flag가 있어도 항해 timer·낚시 대기·알림이 background에서 계속 tick되어 앱을 보지 않는 동안 기록이 생길 수 있었다.
5. 같은 automatic scenery의 저장은 허용했지만 복원은 중복을 제거해 앨범 기억 수가 세션 뒤 달라졌다.
6. 네 개의 historical capture runner가 retire된 mood/time API를 호출해 현재 evidence를 재생성할 수 없었다.

## Solution

- bright sea와 같은 horizon/sea proportion을 유지한 dedicated indigo-rain night source로 교체했다.
- `BoatWaterlineOverlay`라는 named wake/occlusion consumer를 `BoatSpace`에 추가했다.
- scenic prop은 input-free horizon `Control` overlay로 바꾸고, visible capture 및 consumer contract를 추가했다.
- `game_scene.gd`의 time-based runtime update를 application foreground gate 뒤로 옮겨 background elapsed time이 항해 기록을 만들지 않게 했다.
- automatic scenery의 local round-trip이 순서와 duplicate sighting을 그대로 복원하도록 고치고 계약을 추가했다.
- outdated capture runner를 실행 가능한 `HISTORICAL_RETIRED` marker로 교체하고, current evidence는 `capture_direct_boat_entry_atmospheres.gd` 하나로 고정했다.

## Lesson

보트·바다처럼 여러 depth layer가 겹치는 휴식 화면에서는 source art 단독 검토가 충분하지 않다. target resolution, actual camera, background depth, hull-water contact를 한 runtime capture에서 함께 확인해야 한다. 밤 원화도 시간대만 바꾸는 것이 아니라 동일 composition grammar를 지켜야 한다. 또한 "active foreground"은 scenery director 하나의 옵션이 아니라 모든 session-time consumer와 저장 round-trip까지 함께 검증해야 하는 제품 계약이다.

## Base promotion decision

`NO_BASE_PROMOTION`. 이 lesson은 Godot의 일반 도구 사용법이 아니라 My Little Boat의 boat/sea/horizon composition, approved style lock, direct-entry surface에 결합되어 있다. 일반화 가능한 작업 흐름으로 검증할 만큼 여러 프로젝트 evidence가 쌓이지 않았다.
