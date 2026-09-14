# 현재 Godot 구현 handoff

**프로젝트:** `MY_LITTLE_BOAT`
**역할:** 실제 코드·Scene·test·runtime evidence와 현재 제품 정본의 차이를 기록하는 기술 router
**현재 사람용 정본:** [프로젝트 GDD](../design/PROJECT_GDD.md)
**현재 작업:** 2026-08-31 catch·조용한 무수확·취소를 구분하는 낚시와 동반자/난간의 짧은 휴식 반응, 그 GPU capture, 그리고 user-approved alternate chibi visual family의 canonical runtime 연결을 완료한 상태. 기존 사용자 승인 후면 3/4 normal foreground, local motion comfort, actual voyage postcard와 fish/completed-voyage local ledger, 여섯 승인 자연 명소와 saved floral cushion/main-postcard-omission evidence는 유지한다.

## 0. 2026-08-30 현재 runtime receipt

아래 표가 현재 runtime truth다. 이후의 `Issue #99`/`Phase 2` 절은 구현 전 기록이므로 historical context로만 읽고, 이 receipt를 덮어쓰지 않는다.

| 주제 | 현재 구현 | 검증 상태 |
| --- | --- | --- |
| 시작 경로 | `project.godot`이 `res://scenes/game.tscn`으로 곧바로 진입한다. 첫 프레임은 승인된 보트·동반자·바다 장면과 compact `쉬는 메뉴`만 보인다. | direct-entry contract `PASS`, headless game smoke `PASS`, 540×960 runtime capture `PASS` |
| 기분과 저장 시간대 | `GameState`에서 `selected_mood`와 saved time selector를 제거했다. 항해 기록은 `오늘의 항해`로 중립화했다. | state/album contracts `PASS` |
| 현지 시간대 | `RealTimeAtmosphereResolver`가 `05–08=dawn`, `09–16=bright`, `17–20=sunset`, `21–04=night`를 visual-only로 결정한다. 30초 갱신과 focus/resume 갱신이 있다. | injected-hour contract `PASS`, 네 시간대·두 카메라 capture `PASS` |
| 승인 풍경 asset | `MLB-BOAT-FLT-001/002/003/004`는 water-only normal·Appreciation `SeaBackdrop`의 current base texture이고, `MLB-BOAT-FLT-005`는 `BoatWaterContact`다. `MLB-AMB-MOTIF-001..006`은 active foreground 자연 명소의 temporary normal·Appreciation consumer다. 이전 `MLB-BP-VIS-001/002/003/004/005`는 historical Blueprint/reference asset으로 보존하되, 현재 passive Director consumer에서는 superseded다. `006`은 Human Blueprint flow-map으로 runtime 미소비다. | image/runtime asset contracts `PASS`; `2026-08-30-water-only-atmosphere-v2` GPU 8장과 `2026-08-30-ambient-motifs` GPU 6장 captured |
| 저밀도 풍경 | `DriftSceneryDirector`는 foreground delta만 누적해 첫 **기회**를 90–150초에 예약하고, 기회마다 65% 확률로 현재 local-time의 `MLB-AMB-MOTIF-001..006` 중 하나를 표시한다. 표시 여부와 무관하게 이후 기회는 120–180초 뒤에 다시 예약된다. bright·sunset은 즉시 같은 motif를 반복하지 않는다. `GameScene`은 chosen exact texture와 per-motif `backdrop_offset_x`를 normal·Appreciation `SeaBackdrop`에 10초간 적용한 뒤 현재 base atmosphere로 복귀한다. Look Around art는 건드리지 않는다. 버튼·목적지·만료·보상 track은 없고, `save_memory=true`만 `GameState.record_ambient_memory`를 거쳐 `user://ambient_memory_v1.cfg`에 즉시 저장한다. 0회 항해는 정상이며 UI에 확률·대기 시간·missed state는 없다. | director/scene + ambient persistence/state/game-scene + motif asset contracts `PASS`; six 540×960 OpenGL captures `PASS`; Human long-run observation `NOT_RUN` |
| 꾸미기 consumer | `DecorPanel`이 player/pet local selector와 boat decor controls를 제공하고, `DecorPreview`의 독립 `BoatSpace` instance가 그 state를 즉시 표시한다. 기본 C+강아지 final composite에서는 저장된 `pet_corner=pet_cushion, appearance=floral`만 bow-side overlay로 소비한다. 기존 save ID의 alternate A/B player, cat/rabbit/otter, `stripe`·`moon`은 user-approved canonical chibi paths로 layered card/decor texture에 연결된다. `rail_accent=postcard`는 main rest composite에 합성하지 않고 independent preview의 actual rail face로만 소비하며, 실제 voyage photo postcard는 Album에서 본다. 숨김 상태에서는 SubViewport 3D, render target, camera, preview BoatSpace를 모두 비활성화하고, 열 때만 함께 활성화한다. | identity/runtime-image/capture-guard/final-composite/decor-preview contracts `PASS`; alternate 540×960 GPU capture inspected; Human readability `NOT_RUN` |
| 함께한 시간 consumer | `GameScene`은 foreground active-voyage delta만 `GameState.together_time_seconds`에 더하고, `TogetherTimePersistence`가 `user://together_time_v1.cfg`에 local-only로 저장한다. `AlbumView`만 duration·관계 문구를 표시한다. | persistence/state/game-scene/Album contracts `PASS`, 540×960 Album GPU capture inspected; Human readability `NOT_RUN` |
| 모션 편안함 | `ComfortPreferences`가 `user://comfort_preferences_v1.cfg`의 normalized `standard/gentle/still`만 저장한다. `GameScene`은 기존 drift phase·속도·항해 시간·함께한 시간·수면 시간대를 바꾸지 않고, 카메라 y bob·BoatSpace y bob/roll·BoatWaterContact breath/offset 진폭만 각각 `1.0 / 0.5 / 0.0`으로 곱한다. | comfort preference/state/game-scene contracts `PASS`, standard·gentle·still bright GPU capture `PASS`; Human motion comfort `NOT_RUN` |
| 항해 포스트카드 | `PhotoMemoryPersistence`가 `user://voyage_postcards_v1.cfg`와 local PNG directory를 함께 소유한다. `GameScene._capture_voyage_postcard()`는 public `TakePhotoButton` 흐름에서 selection UI만 잠시 숨기고 post-draw `ViewportTexture.get_image()`를 저장한 뒤 가시성을 원상 복구한다. `AlbumView`는 유효 PNG만 newest-first 세 장으로 표시하며 score/reward/share를 만들지 않는다. | persistence/state/game-scene/Album contracts와 isolated bright/Album GPU capture `PASS`; Human readability `NOT_RUN` |
| 물고기와 완료 항해 기록 | `MemoryLedgerPersistence`가 `user://memory_ledger_v1.cfg`의 `fish`와 `voyage_records` string 목록만 즉시 local save·restore한다. `GameState.add_fish()`와 post-zero `complete_voyage()`가 각각 저장하고, Album은 복원된 최신 항목을 요약·recent memory로 소비한다. delayed bottle letter는 읽거나 쓰지 않는다. | persistence/state/Album contracts `PASS`; restored Album 540×960 OpenGL capture `PASS`; Human readability `NOT_RUN` |
| 조용한 낚시와 작은 상호작용 | `CalmFishingSession`은 catch·quiet no-catch·cancel을 별도 state로 처리한다. catch만 기존 `GameState.add_fish()`를 호출하며, quiet/cancel은 저장·점수·연속 보상·손해 없이 action label을 reset한다. 동반자 `나란히 쉬기`는 existing `rest` pose와 private `moment_id`를, 난간 `파도 소리 듣기`는 text-only `moment_id`를 반환한다. | focused fishing/interaction contracts `PASS`; game-scene OpenGL contract `PASS`; quiet-fishing·pet-rest 540×960 OpenGL captures `PASS`; Human readability `NOT_RUN` |
| 부유 보트와 기본 normal foreground | 보트가 없는 backdrop 위에 primary `BoatSpace` 한 개와 `BoatWaterContact` ripple을 표시한다. 보트는 0.052 unit 상하 bob과 최대 1.15° roll을 갖는다. 기본 C+강아지 route의 `FinalDioramaCard`는 `chibi-normal-rear-chroma-key.png`와 `chibi_normal_chroma_key.gdshader`의 explicit `matte_texture` uniform을 소비해, 녹색 기술 배경만 alpha 처리한 stern-side chibi player·dog·boat foreground를 표시한다. player는 stern rail에 기대어 뒷모습으로, dog는 옆에서 함께 보인다. `DioramaCameraRig`만 보트 뒤쪽 위로 옮겼고 Look Around·Appreciation rig는 보존했다. card `pixel_size`는 `0.0037`이며, time backdrop·water contact·bob과 분리된다. 숨긴 `DecorPreview`의 renderer, camera, BoatSpace도 함께 비활성화해 미리보기의 `CylinderMesh`가 normal capture 경로에 새지 않게 했다. | rear-normal/material/final-card/direct-entry/diorama/decor contracts `PASS`; bright·night 540×960 GPU capture visual inspection `PASS` |
| Look Around | `LookAroundCameraRig/LookAroundCamera3D`, `LookAroundButton`, `LookAroundCameraController`, local `_look_around_mode`와 explicit three-camera routing을 사용한다. active `InputEventScreenDrag`/PC drag만 yaw `±135°`, pitch `-16°..38°`, zero roll로 처리한다. Appreciation·decor·Album은 Look Around를 종료하며, gameplay state를 바꾸지 않는다. `LookAroundPresentationRouter`는 승인된 `MLB-LOOK-CHIBI-TRN-001..004` exact texture를 `port`·`starboard`·`aft`·`overhead`에 연결한다. non-front에서는 중복 normal card만 숨기고 primary `BoatSpace`와 `BoatWaterContact` state·motion은 유지한다. | router/input/game-scene/runtime-asset-guard contracts `PASS`; `2026-08-30-look-around-chibi-transparent` normal·네 각도·Appreciation 540×960 GPU capture `PASS`; Human motion comfort, touch reachability, long-run calm `NOT_RUN` |

이전 direct-entry 보강은 Godot `4.7.1.stable.official.a13da4feb`에서 `tests/test_*.gd` 36/36 `PASS`를 기록했다. 현재 설치된 Godot `4.7.2.stable.official.ed1daf0bf`에서 natural-motif, main-postcard-omission, fish/completed-voyage ledger, quiet-action, alternate chibi canonical rebind 뒤 focused 계약을 다시 실행했다. `tests/capture_approved_alternate_chibi_family.gd`는 NVIDIA RTX 3050 OpenGL 3.3에서 A+cat+stripe, B+rabbit+moon, A+otter+stripe의 540×960 frame을 기록했다. `RestingSoundscape`는 headless에서 출력 없는 generated audio를 시작하지 않고, real-display lifecycle에서는 stop·stream release를 수행한다. Human/device visual and audio comfort는 `NOT_RUN`이다.

### 2026-08-31 machine-verification addendum

- Godot `4.7.2.stable.official.ed1daf0bf`에서 현재 `tests/test_*.gd` 51/51을 headless 경고 없이 실행했다. 이 경로에서는 `ViewportTexture`를 읽을 수 없으므로, 포스트카드 저장 assertion만 명시적으로 `SKIP`하고 나머지 게임 계약은 실행한다.
- 동일한 포스트카드 저장 assertion은 NVIDIA RTX 3050 OpenGL 3.3에서 `test_game_scene_contract.gd`로 실제 수행했다. 독립 GPU 프로세스 종료 전에 `RestingSoundscape`의 generated audio stream을 stop·release하고 네 프레임을 기다리도록 검사 teardown을 정리했으며, 5회 중 5회 모두 ObjectDB/resource leak 경고 없이 `PASS`했다.
- `test_chibi_normal_chroma_material_proof.gd`도 같은 OpenGL 환경에서 `PASS`했다. 이 결과는 machine/runtime contract 경계이며, 실제 기기 종료 동작과 Human audio comfort는 여전히 `NOT_RUN`이다.

**Human evidence ceiling:** 실제 기기의 첫 30초·5분 휴식감, 터치 target, 모션 민감성, 텍스트 가독성, 사운드 편안함은 `NOT_RUN`이다. 기계 계약과 capture가 이를 대체하지 않는다.

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
| 흘러가는 풍경 | active foreground 시간에만 low-density distant scenery와 durable ambient memory | `GameScene` foreground director → `GameState.record_ambient_memory` → `ambient_memory_v1.cfg` | `IMPLEMENTED / MACHINE_VERIFIED`; Human long-run observation `NOT_RUN` |
| 함께 보낸 시간 | active foreground voyage time만 Album에 조용히 표시 | `GameScene` foreground delta → `GameState` local total → `AlbumView` duration/relation copy | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human readability `NOT_RUN` |
| Ambient Discovery | low-density passive presentation + 작은 알림 + local auto-save | `DriftSceneryDirector` + non-interactive label + named local persistence owner | `IMPLEMENTED / MACHINE_VERIFIED`; Human long-run observation `NOT_RUN` |

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
- `MLB-LOOK-CHIBI-NORMAL-REAR-001`의 opaque rear 3/4 source는 2026-08-30 사용자 승인 뒤 repository canonical path에 등록됐다. 이 source의 sky/water를 기술용 green matte로 분리한 `MLB-LOOK-CHIBI-NORMAL-REAR-MATTE-001`은 user-approved derived runtime asset이며, `BoatSpace/FinalDioramaCard`의 `ShaderMaterial_chibi_normal_chroma`와 explicit `matte_texture` uniform에 연결됐다. `ALPHA` chroma key는 technical green background만 투명하게 만들어 time backdrop·bob·water contact를 보존한다. stern-side rig, GPU material proof와 bright/night capture는 `ASSET_READY → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`까지의 증거이며 Human/device comfort는 아니다. 기존 `MLB-LOOK-CHIBI-NORMAL-001`과 matte는 provenance만 유지하는 superseded default-normal asset이다.
- 현재 `main_menu` atmosphere background와 legacy C+dog diorama binary는 여전히 legacy menu surface에서 소비될 수 있다. 기본 game entry는 새 치비 normal consumer를 사용한다. user-approved saved `postcard`와 `pet_cushion=floral`은 새 chibi decor assets로 정본 등록·runtime 연결됐고, surface가 player/dog focal zone을 가리지 않는 540×960 GPU capture가 있다. user-approved alternate A/B identity, cat/rabbit/otter, `stripe`·`moon` decor variant도 non-destructive canonical copies로 current runtime family에 연결됐으며 saved IDs는 보존한다.
- `HANDPAINTED_STORYBOOK_3D_DIORAMA`, `SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT`, `INDIGO_RAIN_REFLECTION`은 `APPROVED_DIRECTION`입니다. generated exploration, source binary, runtime capture, Human approval은 서로 다른 evidence입니다.
- real-device touch, five-minute calm, visual fatigue, audio comfort는 모두 `NOT_RUN`입니다. direct-entry와 Album runtime capture는 존재하지만 Human/device evidence가 아닙니다.

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
