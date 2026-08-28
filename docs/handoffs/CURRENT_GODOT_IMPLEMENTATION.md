# 현재 Godot 구현 handoff

**프로젝트:** `MY_LITTLE_BOAT`

**갱신일:** 2026-08-29

**현재 작업:** GitHub Issue #101의 direct boat entry, 현실 시간 분위기, foreground drifting scenery 구현

**사람용 정본:** [프로젝트 GDD](../design/PROJECT_GDD.md)
**시각 consumer/provenance:** [visual inventory](../visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md)

## 1. authority와 읽는 순서

1. `AGENTS.md`
2. `docs/design/PROJECT_GDD.md`
3. 이 handoff
4. `scenes/game.tscn`, `scenes/boat_space.tscn`, `scripts/core/game_state.gd`, `scripts/voyage/game_scene.gd`
5. `tests/test_*`와 [2026-08-29 runtime evidence](../evidence/2026-08-29-direct-boat-entry/README.md)

Notion은 historical discovery archive다. current write/readback target이 아니며, 실제 runtime 사실은 repository source와 실행 evidence가 소유한다.

## 2. 현재 실제 상태

| 주제 | 현재 code/runtime | evidence ceiling |
| --- | --- | --- |
| 시작 | `project.godot`의 main scene은 `scenes/game.tscn`이다. 첫 화면에는 보트·캐릭터·동반자·바다와 `메뉴`만 보인다. | automated contract와 540 x 960 GPU capture `PASS`; Human `NOT_RUN` |
| 구형 menu 경로 | `scenes/main_menu.tscn`은 오래된 링크용 호환 route로 즉시 `game.tscn`으로 넘긴다. mood/time/identity 선택을 제품 UI로 노출하지 않는다. | headless smoke `PASS` |
| 오늘의 마음 | `GameState`의 mood와 시작 choice를 retire했다. 항해 기록은 중립 문구다. | state contract `PASS` |
| 현실 시간 분위기 | `RealTimeAtmosphereResolver`가 현지 시간 05–08 dawn, 09–16 bright, 17–20 sunset, 21–04 night를 매핑한다. 시작·focus/resume·30초 refresh에서 visual만 바꾼다. | resolver/game contract `PASS`; GPU capture `PASS` |
| 밤 바다 | night는 전용 `sea_night_indigo_rain_storybook.png`를 두 카메라에 적용한다. 낮/새벽/해질녘은 같은 bright sea art의 tone을 쓴다. | resource-path contract와 GPU capture `PASS` |
| 보트-물 접점 | `BoatWaterlineOverlay`가 hull 하단의 wake를 가려 보트가 바다와 분리되어 보이는 문제를 줄인다. | 540 x 960 GPU capture `PASS`; Human visual judgment `NOT_RUN` |
| foreground session | 앱이 background/paused면 항해 timer·낚시 대기·풍경 drift·자동 알림이 멈춘다. background 경과로 항해 기록을 만들지 않는다. | game-scene foreground contract `PASS` |
| 흘러가는 풍경 | `DriftSceneryDirector`는 foreground delta만 누적한다. 약 90–150초 뒤 부표·작은 섬·등대가 horizon layer를 천천히 가로지른다. | director/runtime contracts `PASS`; 5분 빈도 Human judgment `NOT_RUN` |
| Ambient memory | 풍경 event의 일부만 local `ConfigFile`에 즉시 저장하며 같은 목격도 순서와 중복을 보존한다. 작은 자동 소멸 알림 외 reward, task, tap, missed penalty, affection 변화가 없다. | persistence/GameState round-trip contracts `PASS`; UX noticeability `NOT_RUN` |
| 꾸미기 | 외형·동반자·보트 장식은 `메뉴 → 꾸미기`에만 있고 live boat visual에 적용된다. | identity contract `PASS`; mobile touch `NOT_RUN` |
| 함께 보낸 시간 | foreground time 기반 호감도/album 표현은 아직 없다. | `CONFIRMED_NOT_IMPLEMENTED` |

## 3. 핵심 runtime owner

| owner | 책임 |
| --- | --- |
| `scripts/voyage/real_time_atmosphere_resolver.gd` | 시스템 현지 시각을 승인 atmosphere ID로 변환하는 순수 함수 |
| `scripts/voyage/game_scene.gd` | direct entry, 30초 refresh, focus lifecycle, 두 camera 적용, UI, scenery consumer |
| `scripts/voyage/drift_scenery_director.gd` | foreground-only scenery timing 및 memory 기회 생성 |
| `scripts/core/ambient_memory_persistence.gd` | `user://ambient_memories_v1.cfg`의 local memory 저장·복원 |
| `scenes/distant_scenery.tscn` | runtime horizon overlay prop의 공통 surface |
| `scenes/boat_space.tscn` | boat, avatar/pet visual, hull-water wake overlay |

## 4. 실행 검증과 한계

- Headless behavior contracts와 `game.tscn`, `main_menu.tscn`, `album.tscn` smoke를 실행했다.
- Windows OpenGL Compatibility renderer에서 540 x 960 GPU capture를 생성하고 낮·새벽·해질녘·밤·원거리 섬 화면을 직접 확인했다.
- 현재 visual evidence runner는 `tests/capture_direct_boat_entry_atmospheres.gd` 하나다. 네 개의 old mood/time capture runner는 `HISTORICAL_RETIRED` marker만 출력하며 current runtime evidence를 만들지 않는다.
- capture는 코드가 해당 화면을 만들었다는 evidence다. 실제 기기 성능, 터치, 30초 첫인상, 5분 동안의 평온함, 알림의 과하지 않음, 오디오 편안함은 아직 증명하지 않는다.
- Headless run의 `ObjectDB instances were leaked` 경고는 기존 plugin 종료 경고로 exit code 0의 behavior contract 결과와 분리해 기록한다. task-related runtime error는 관찰하지 않았다.

## 5. 적대적 검토와 교정 receipt

| 공격 질문 | finding | 교정 | 결과 |
| --- | --- | --- | --- |
| 밤 원화가 낮과 같은 수평선 구도를 지키는가 | 첫 night candidate는 sea horizon이 너무 낮아 보트가 sky 위에 뜬 것처럼 읽혔다. | bright sea와 같은 lower-half ocean/horizon 구도의 night art로 교체하고 GPU capture를 다시 생성했다. | `CORRECTED_AND_CAPTURED` |
| 보트가 바다와 물리적으로 분리돼 보이는가 | hull 하단과 sea 사이의 빈 공간이 첫 capture에서 읽혔다. | `BoatWaterlineOverlay`를 boat consumer로 추가해 wake/occlusion을 맞췄다. | `CORRECTED_AND_CAPTURED` |
| 3D distant prop이 실제 camera에서 보이는가 | 첫 Sprite3D prop은 camera background에 가려졌다. | input 없는 horizon `CanvasLayer`-equivalent Control overlay로 좁은 2.5D consumer를 사용했다. | `CORRECTED_AND_TESTED` |
| 자동 저장이 행동 보상으로 바뀌는가 | 기존 scenery/letter path는 affection을 바꾸는 오래된 slice였다. | local ambient persistence path는 letter/Bottle path와 분리하고 scenery event는 affinity를 바꾸지 않게 했다. | `CORRECTED_AND_TESTED` |
| 앱을 보고 있지 않아도 항해가 끝나는가 | foreground flag는 있었지만 timer·낚시·알림이 계속 tick돼 background 경과만으로 기록이 생길 수 있었다. | scene process를 foreground gate 뒤로 옮기고 회귀 계약을 추가했다. | `CORRECTED_AND_TESTED` |
| 같은 풍경 기억이 재시작 뒤 사라지는가 | 저장은 duplicate를 허용했지만 복원은 중복을 제거했다. | saved order와 duplicate를 그대로 복원하는 GameState round-trip 계약으로 교정했다. | `CORRECTED_AND_TESTED` |
| 구형 capture가 현재 정본을 재생성하는가 | retired mood/time API를 호출해 error와 hanging process를 만들었다. | 네 runner를 explicit historical retirement marker로 교체하고 current runner를 한 경로로 고정했다. | `CORRECTED_AND_EXECUTED` |
| 구현/정적 이미지/Human PASS를 혼동하는가 | capture만으로 휴식 경험을 과장할 위험이 있다. | 모든 current docs에 GPU capture와 Human `NOT_RUN`을 분리했다. | `CLEAN` |

## 6. 다음 작업

1. 사용자가 실제 기기에서 첫 30초와 5분 항해를 해 보고 보트-물 접점, 메뉴 발견성, 시간대 전환, 풍경 빈도, 알림의 존재감을 평가한다.
2. 사용자가 승인한 별도 계약으로 foreground 함께 보낸 시간에 따른 조용한 동반자 관계 표현을 구현한다.
3. audio soundscape와 실제 mobile performance는 별도 scope로 검증한다.

## 7. 다른 workstream 경계

- PR #19 `feat/social-fake-backend-20260824`는 `READ_ONLY_NO_ABSORPTION`이다.
- direct main, force push, reset/clean/rebase, Bottle social 확장은 이 작업의 범위가 아니다.
- generated source, project asset, capture, Human evidence의 provenance는 visual inventory에서 분리 관리한다.
