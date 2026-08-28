# 현재 Godot 구현 handoff

**프로젝트:** `MY_LITTLE_BOAT`
**역할:** 실제 코드·Scene·test·runtime evidence와 현재 제품 정본의 차이를 기록하는 기술 router
**현재 사람용 정본:** [프로젝트 GDD](../design/PROJECT_GDD.md)
**현재 작업:** Issue #99 / Draft PR #100의 direct boat entry 정본화. 이 문서는 runtime 변경을 포함하지 않습니다.

## 1. 먼저 읽을 것

1. `AGENTS.md`
2. `docs/design/PROJECT_GDD.md`
3. 이 handoff
4. `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md`
5. 실제 Scene, GDScript, 테스트, capture

이 repository는 Notion을 현재 정본으로 사용하지 않습니다. 이전 Notion은 historical discovery archive이며, active implementation 판단은 repository source와 runtime evidence를 우선합니다.

## 2. 현재 제품 방향과 runtime gap

| 주제 | 현재 제품 정본 | 현재 main code | disposition |
| --- | --- | --- | --- |
| 시작 | 실행 즉시 normal 3/4 boat diorama | `scenes/main_menu.tscn`의 선택형 panel 뒤 `game.tscn` 진입 | `PRODUCT_SUPERSEDED_IMPLEMENTATION` |
| 오늘의 마음 | 제품에서 제거 | `selected_mood`, mood button, mood tone, record wording, 관련 test가 존재 | `PRODUCT_SUPERSEDED_IMPLEMENTATION` |
| 꾸미기 entry | 바다를 본 뒤 optional `꾸미기` | identity/pet/time 선택이 menu에 있고 decor는 game panel에 존재 | `PRODUCT_SUPERSEDED_IMPLEMENTATION` |
| 시간 기반 분위기 | 기기의 현지 현실 시간이 자동 적용, selector·saved preference 없음 | process-lifetime selection만 존재하고 menu OptionButton이 소비 | `PRODUCT_SUPERSEDED_IMPLEMENTATION` |
| 흘러가는 풍경 | active foreground 시간에만 low-density distant scenery와 ambient memory | action-gated offer, early forced prompt, button/expiry path | `PRODUCT_SUPERSEDED_IMPLEMENTATION` |
| 함께 보낸 시간 | active foreground voyage time만 album에 조용히 표시 | 행동으로 `companion_affection`을 올리고 voyage/album `Lv`를 표시 | `PRODUCT_SUPERSEDED_IMPLEMENTATION` |
| Ambient Discovery | low-density passive presentation + 작은 알림 + local auto-save | action-gated offer, early forced prompt, button/expiry path | `PRODUCT_SUPERSEDED_IMPLEMENTATION` |

현재 code가 존재한다는 사실은 해당 제품 방향이 여전히 승인되었다는 뜻이 아닙니다. 반대로 GDD 결정은 code/test/capture가 바뀌기 전까지 runtime PASS를 뜻하지 않습니다.

## 3. Issue #99의 구현 금지선

이 문서 정본화 PR에서는 아래 runtime owner를 수정하지 않습니다.

```text
scenes/main_menu.tscn
scripts/ui/main_menu.gd
scripts/core/game_state.gd
scripts/voyage/game_scene.gd
tests/test_calm_voyage_state.gd
tests/test_game_scene_contract.gd
tests/test_game_scene_time_of_day_contract.gd
tests/test_main_menu_identity_contract.gd
tests/test_main_menu_time_of_day_contract.gd
tests/test_main_menu_atmosphere_background_contract.gd
tests/capture_main_menu_atmospheres.gd
assets/
```

PR #19 `feat/social-fake-backend-20260824`도 `READ_ONLY_NO_ABSORPTION`입니다.

## 4. 다음 Phase 2 implementation contract

다음 구현은 위 gap을 따로 쪼개서 부분적으로 고치지 않습니다. 아래를 한 contract로 묶어 설계·테스트·runtime capture·Human validation까지 검증합니다.

1. `project.godot`의 startup route가 새 local state에서 곧바로 normal boat diorama를 연다.
2. `GameState`가 mood를 retire하고, 현지 현실 시간을 순수 visual atmosphere로 resolve한다. selector·saved atmosphere를 만들지 않는다.
3. active foreground 시간만 쓰는 drifting scenery director가 distant scenery와 low-density ambient memory를 관리한다.
4. player appearance, pet species, boat decor가 in-voyage optional `꾸미기`에서만 접근 가능하다.
5. mood-facing UI, wording, color rule, test/capture dependency가 제거되거나 direct-entry contract로 대체된다.
6. 540 x 960 capture에서 boat-water contact, bob/wave/wake/reflection, avatar/pet/boat/sea/horizon hierarchy가 검증된다.
7. direct entry, local-time mapping, foreground-only scenery progress, no-mood migration, customization entry, camera parity를 test한다.
8. 사람의 첫 30초와 5분 휴식, mobile touch, sound comfort를 별도 Human evidence로 기록한다.

Godot 구현 가능성의 근거는 다음 공식 안정판 문서에 있다. Autoload는 Scene 사이 state를, `ConfigFile`과 `user://`는 local persistence를, SceneTree route는 main scene transition을 지원한다. 구현 세부와 error handling은 해당 Phase 2 contract에서 source/test를 읽고 결정한다.

- https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
- https://docs.godotengine.org/en/stable/classes/class_configfile.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/filesystem.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html

## 5. 시각 consumer와 evidence ceiling

- `VIS-ENTRY-001`은 구형 main-entry full composition입니다. 보트가 물에 뜬다는 물리적 관계가 약하고 large selection panel이 sea-first first impression을 가리므로 `REJECTED_FOR_MAIN_ENTRY_RUNTIME_USE`입니다.
- 현재 `main_menu` atmosphere background와 C+dog diorama binary는 runtime에서 소비되지만, new direct-entry composition 승인 또는 final art가 아닙니다. consumer audit 전 삭제·교체·재생성을 하지 않습니다.
- `HANDPAINTED_STORYBOOK_3D_DIORAMA`, `SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT`, `INDIGO_RAIN_REFLECTION`은 `APPROVED_DIRECTION`입니다. generated exploration, source binary, runtime capture, Human approval은 서로 다른 evidence입니다.
- real-device touch, five-minute calm, visual fatigue, audio comfort, new direct-entry runtime capture는 모두 `NOT_RUN` 또는 `NOT_IMPLEMENTED`입니다.

## 6. Issue #99 적대적 검토 receipt

| Loop | 공격 질문 | finding | correction owner | 상태 |
| --- | --- | --- | --- | --- |
| 1 | 사용자 승인, human GDD, current code가 mood/start flow에서 충돌하는가 | 기존 docs가 mood selector를 current product로 설명 | GDD, README, Concept, Experience Bible, handoff, visual inventory | `CORRECTED` |
| 2 | 사람이 시스템의 행동·이유·피드백·압박 회피를 이해하는가 | 이전 master GDD가 AI/evidence 구조를 앞세움 | `PROJECT_GDD.md` | `CORRECTED` |
| 3 | 직접 시작·local persistence가 Godot 4.7 구조에서 가능한가 | 구현 가능성 근거가 사람용 문서에 없음 | GDD와 이 handoff의 official stable links | `CORRECTED` |
| 4 | 구형 composition rejection이 source binary 전체 폐기로 과장되는가 | old visual inventory가 menu asset을 current product approval으로 표현 | visual inventory | `CORRECTED` |
| 5 | 문서가 runtime/Human PASS, social 확대, asset batch를 암시하는가 | source/status 문구의 overclaim 위험 | GDD/handoff evidence ceiling | `CORRECTED` |
| clean recheck | 문서 owner·stale allowlist·GDD 구조·PDF text/visual·staged diff를 correction 뒤 다시 실행 | material conflict 없음 | 이 handoff | `CLEAN` |

이 clean recheck는 8-section GDD, 7-page PDF text/visual readback, active-current stale allowlist, staged diff scope까지 확인한 상태입니다. PR exact-head readback은 push 뒤 다시 기록합니다.

발견한 정본 충돌의 Incident / Solution / Lesson과 Base 승격 판정은 [2026-08-28 direct boat entry 정본 충돌 기록](../learning/2026-08-28-direct-boat-entry-canon-reconciliation.md)에 남깁니다.
