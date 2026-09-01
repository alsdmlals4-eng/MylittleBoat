# 현재 Godot 구현 handoff

**프로젝트:** `MY_LITTLE_BOAT`
**역할:** 실제 코드·Scene·test·runtime evidence와 현재 제품 정본의 차이를 기록하는 기술 router
**현재 사람용 정본:** [프로젝트 GDD](../design/PROJECT_GDD.md)
**현재 작업:** 2026-08-31 user direction에 따른 title boat waiting, explicit voyage start boundary, time-paired static sky + independently flowing sea, 하단 boat framing과 승인된 narrow waterline contact motion reconciliation을 구현하고 current machine/runtime verification을 완료했다. 2026-09-01 Look Around는 whole-composite art 대신 angle-specific foreground를 shared static sky + flowing sea 위에 합성하도록 교정했다. Base 적용 순서와 운영 contract는 `docs/operations/MY_LITTLE_BOAT_BASE_ADAPTER.json`이 project-local로 소유한다. 기존 사용자 승인 후면 3/4 normal foreground, local motion comfort, actual voyage postcard와 fish/completed-voyage local ledger, saved floral cushion/main-postcard-omission evidence는 유지한다. Human/device comfort는 별도 요청 전까지 `NOT_RUN`이다.

## 0. 2026-08-30 현재 runtime receipt

아래 표가 현재 runtime truth다. 이후의 `Issue #99`/`Phase 2` 절은 구현 전 기록이므로 historical context로만 읽고, 이 receipt를 덮어쓰지 않는다.

| 주제 | 현재 구현 | 검증 상태 |
| --- | --- | --- |
| 게임명과 브랜드 표지 | `project.godot` display name은 `MY LITTLE BOAT`다. `MLB-BRAND-TITLE-001`은 user-locked asset이며 `GameScene/TitleOverlay/TitleLayout/BrandLogo`의 identity-neutral consumer에 연결됐다. | title-brand contract `PASS`; `2026-08-31-title-boat-flow` OpenGL capture `PASS`; Human brand/readability `NOT_RUN` |
| 시작 경로 | `project.godot`이 `res://scenes/game.tscn`으로 곧바로 진입한다. 첫 프레임은 실제 보트·동반자·바다와 로고·`항해 시작`만 보이는 타이틀 대기다. `start_voyage_from_title()`만 `GameState.begin_voyage()`를 호출하고, 그 뒤 compact `쉬는 메뉴`가 열린다. | title-entry contract `PASS`, headless game smoke `PASS`, 540×960 GPU capture `PASS`; Human calm `NOT_RUN` |
| 기분과 저장 시간대 | `GameState`에서 `selected_mood`와 saved time selector를 제거했다. 항해 기록은 `오늘의 항해`로 중립화했다. | state/album contracts `PASS` |
| 현지 시간대 | `RealTimeAtmosphereResolver`가 `05–08=dawn`, `09–16=bright`, `17–20=sunset`, `21–04=night`를 visual-only로 결정한다. 30초 갱신과 focus/resume 갱신이 있다. | injected-hour contract `PASS`, 네 시간대·두 카메라 capture `PASS` |
| 승인 풍경 asset | `MLB-BG-SPLIT-001..008`은 `dawn / bright / sunset / night`의 static `SkyBackdrop`와 flowing `SeaBackdrop` current pair다. `MLB-BOAT-FLT-005`는 `BoatWaterContact`, user-approved `MLB-BOAT-FLT-006`은 `BoatWaterlineContact`다. `MLB-AMB-MOTIF-001..006`은 active foreground의 dedicated normal·Appreciation `AmbientSceneryPass` consumer다. 이전 `MLB-BOAT-FLT-001/002/003/004` combined source와 `MLB-BP-VIS-001/002/003/004/005`는 historical/legacy consumer를 위해 보존하되 current split route에서는 superseded다. `006`은 Human Blueprint flow-map으로 runtime 미소비다. | split-background contract, time/ambient/look-around/capture guard contracts `PASS`; `2026-08-31-split-sky-sea-background` OpenGL 9장 captured; Human motion/color comfort `NOT_RUN` |
| 저밀도 풍경 | `DriftSceneryDirector`는 foreground delta만 누적해 첫 **기회**를 90–150초에 예약하고, 기회마다 65% 확률로 현재 local-time의 `MLB-AMB-MOTIF-001..006` 중 하나를 표시한다. 표시 여부와 무관하게 이후 기회는 120–180초 뒤에 다시 예약된다. bright·sunset은 즉시 같은 motif를 반복하지 않는다. `GameScene`은 static `SkyBackdrop` + flowing `SeaBackdrop`을 유지한 채 chosen exact texture를 normal·Appreciation `AmbientSceneryPass`에 넣고, authored side hint `backdrop_offset_x`를 ±21 world-unit transit로 넓혀 약 14초간 좌우 이동·입퇴장 fade한다. pass는 세로 화면 높이를 overscan하므로 수평 image edge가 보트 화면을 가르지 않는다. Look Around art는 건드리지 않는다. 버튼·목적지·만료·보상 track은 없고, `save_memory=true`만 `GameState.record_ambient_memory`를 거쳐 `user://ambient_memory_v1.cfg`에 즉시 저장한다. 0회 항해는 정상이며 UI에 확률·대기 시간·missed state는 없다. | director/scene + ambient persistence/state/game-scene + motif asset contracts `PASS`; six 540×960 OpenGL pass captures `PASS`; Human long-run observation `NOT_RUN` |
| 꾸미기 consumer | `DecorPanel`이 player/pet local selector와 boat decor controls를 제공하고, `DecorPreview`의 독립 `BoatSpace` instance가 그 state를 즉시 표시한다. 기본 C+강아지 final composite에서는 저장된 `pet_corner=pet_cushion, appearance=floral`만 bow-side overlay로 소비한다. 기존 save ID의 alternate A/B player, cat/rabbit/otter, `stripe`·`moon`은 user-approved canonical chibi paths로 layered card/decor texture에 연결된다. `rail_accent=postcard`는 main rest composite에 합성하지 않고 independent preview의 actual rail face로만 소비하며, 실제 voyage photo postcard는 Album에서 본다. 숨김 상태에서는 SubViewport 3D, render target, camera, preview BoatSpace를 모두 비활성화하고, 열 때만 함께 활성화한다. | identity/runtime-image/capture-guard/final-composite/decor-preview contracts `PASS`; alternate 540×960 GPU capture inspected; Human readability `NOT_RUN` |
| 함께한 시간 consumer | `GameScene`은 foreground active-voyage delta만 `GameState.together_time_seconds`에 더하고, `TogetherTimePersistence`가 `user://together_time_v1.cfg`에 local-only로 저장한다. `AlbumView`만 duration·관계 문구를 표시한다. | persistence/state/game-scene/Album contracts `PASS`, 540×960 Album GPU capture inspected; Human readability `NOT_RUN` |
| 모션 편안함과 기본 하늘·바다 흐름 | `ComfortPreferences`가 `user://comfort_preferences_v1.cfg`의 normalized `standard/gentle/still`만 저장한다. `GameScene`은 camera y bob, 하단 20% 기준의 `BoatSpace` y bob/roll, 목적지 없는 순환형 전후 surge와 미세한 측면 current, `BoatWaterContact`와 `BoatWaterlineContact`의 breath/offset/scale을 각각 `1.0 / 0.5 / 0.0`으로 곱한다. title waiting도 visual-only 저진폭 bob과 `voyage_split_sea_flow.gdshader`의 sea-only flow를 보이지만 voyage timer·together time·ambient director는 전진하지 않는다. static `SkyBackdrop`는 material override가 없고, `SeaBackdrop`만 shared flow offset을 받는다. 항해 시작 뒤 flow는 speed tier와 함께 빨라진다. 두 contact는 same x/z와 거의 같은 y bob을 따른다. `MLB-BOAT-FLT-006`은 depth test를 유지한 앞쪽의 얇은 선체 접점으로 runtime 소비되고, sea-focused Appreciation mode에서는 `BoatSpace`와 두 contact를 함께 숨겨 하단 UI와 겹치지 않는다. | split/background/time/ambient/look-around/capture guard contracts `PASS`; 2026-08-31 OpenGL bright frame pair sky `0.00%`, open sea `70.79%`, lower sea `83.81%` change; four-time 9-frame capture `PASS`; Human motion/color comfort `NOT_RUN` |
| 항해 포스트카드 | `PhotoMemoryPersistence`가 `user://voyage_postcards_v1.cfg`와 local PNG directory를 함께 소유한다. `GameScene._capture_voyage_postcard()`는 public `TakePhotoButton` 흐름에서 selection UI만 잠시 숨기고 post-draw `ViewportTexture.get_image()`를 저장한 뒤 가시성을 원상 복구한다. `AlbumView`는 유효 PNG만 newest-first 세 장으로 표시하며 score/reward/share를 만들지 않는다. | persistence/state/game-scene/Album contracts와 isolated bright/Album GPU capture `PASS`; Human readability `NOT_RUN` |
| 물고기와 완료 항해 기록 | `MemoryLedgerPersistence`가 `user://memory_ledger_v1.cfg`의 `fish`와 `voyage_records` string 목록만 즉시 local save·restore한다. `GameState.add_fish()`와 post-zero `complete_voyage()`가 각각 저장하고, Album은 복원된 최신 항목을 요약·recent memory로 소비한다. delayed bottle letter는 읽거나 쓰지 않는다. | persistence/state/Album contracts `PASS`; restored Album 540×960 OpenGL capture `PASS`; Human readability `NOT_RUN` |
| 조용한 낚시와 작은 상호작용 | `CalmFishingSession`은 catch·quiet no-catch·cancel을 별도 state로 처리한다. catch만 기존 `GameState.add_fish()`를 호출하며, quiet/cancel은 저장·점수·연속 보상·손해 없이 action label을 reset한다. 동반자 `나란히 쉬기`는 existing `rest` pose와 private `moment_id`를, 난간 `파도 소리 듣기`는 text-only `moment_id`를 반환한다. | focused fishing/interaction contracts `PASS`; game-scene OpenGL contract `PASS`; quiet-fishing·pet-rest 540×960 OpenGL captures `PASS`; Human readability `NOT_RUN` |
| 부유 보트와 기본 normal foreground | 보트가 없는 backdrop 위에 primary `BoatSpace` 한 개와 `BoatWaterContact` legacy ripple, `BoatWaterlineContact` narrow contact를 표시한다. 보트의 base y는 `-2.7`로 540×960 세로 화면 하단 20% 근처에 두며, 0.052 unit 상하 bob과 최대 1.15° roll, 목적지·경계·저장 없이 반복되는 최대 0.16 unit 전후 surge와 0.022 unit 측면 current를 갖는다. 두 수면 접점은 같은 전후·측면 offset을 따라가며, legacy ripple만 surge 때 미세하게 넓어진다. 기본 C+강아지 route의 `FinalDioramaCard`는 `chibi-normal-rear-chroma-key.png`와 `chibi_normal_chroma_key.gdshader`의 explicit `matte_texture` uniform을 소비해, 녹색 기술 배경만 alpha 처리한 stern-side chibi player·dog·boat foreground를 표시한다. player는 stern rail에 기대어 뒷모습으로, dog는 옆에서 함께 보인다. `DioramaCameraRig`만 보트 뒤쪽 위로 옮겼고 Look Around rig는 보존했다. Appreciation은 sea-first 화면을 위해 `BoatSpace`와 두 contact를 숨긴다. card `pixel_size`는 `0.0037`이며, time backdrop·water contact·bob과 분리된다. 숨긴 `DecorPreview`의 renderer, camera, BoatSpace도 함께 비활성화해 미리보기의 `CylinderMesh`가 normal capture 경로에 새지 않게 했다. | rear-normal/material/final-card/direct-entry/diorama/decor/forward-drift/waterline/appreciation contracts `PASS`; 540×960 Windows OpenGL lower-frame title/voyage/Appreciation capture `PASS`; Human motion comfort `NOT_RUN` |
| Look Around | `LookAroundCameraRig/LookAroundCamera3D`, `LookAroundButton`, `LookAroundCameraController`, local `_look_around_mode`와 explicit three-camera routing을 사용한다. active `InputEventScreenDrag`/PC drag만 yaw `±135°`, pitch `-16°..38°`, zero roll로 처리한다. Appreciation·decor·Album은 Look Around를 종료하며, gameplay state를 바꾸지 않는다. `LookAroundPresentationRouter`는 user-locked `MLB-LOOK-FG-001..004` exact foreground를 `port`·`starboard`·`aft`·`overhead`에 연결한다. `LookAroundForeground`는 opaque magenta technical matte를 `look_around_foreground_chroma_key.gdshader`로만 alpha 처리하고, non-front에서도 current static `SkyBackdrop`와 flowing `SeaBackdrop`을 함께 유지한다. non-front에서는 중복 normal card만 숨기고 primary `BoatSpace`와 `BoatWaterContact` state·motion은 유지한다. | foreground/router/input/game-scene/runtime-asset-guard contracts `PASS`; `2026-09-01-look-around-foreground-split` normal·네 각도·Appreciation 540×960 OpenGL capture `PASS`; 1.8초 port pair sky `0.00%` / open sea `58.44%` change; Human motion comfort, touch reachability, long-run calm `NOT_RUN` |

### 2026-08-31 승인 narrow waterline v2와 하단 boat framing delivery receipt

**판정:** `FEASIBLE → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`. 이 판정은 user-approved image의 repository copy, actual `Sprite3D` consumer, machine contracts와 Windows OpenGL capture에만 적용합니다. 사람의 실제 모바일 휴식감·색감·터치·장시간 motion comfort는 `NOT_RUN`입니다.

| Loop | 실제 확인 | 검증된 finding | 적용 또는 상태 | 회귀 증거 |
| --- | --- | --- | --- | --- |
| 1 | current `AGENTS.md`, GDD, visual inventory, `game.tscn`, `game_scene.gd`, legacy ripple consumer, approved generator candidate를 fresh-read | 선체 하단의 얇은 별도 접점은 actual runtime consumer가 필요했고, 기존 ripple은 확산 수면으로 유지하는 편이 범위·시각 역할에 맞음 | `MLB-BOAT-FLT-006`을 v2 좁은 contact 전용 asset ID로 선택 | existing boat/contact drift와 save/reward 경계는 유지 |
| 2 | `test_waterline_contact_v2_contract.gd`를 code보다 먼저 실행 | canonical PNG와 `BoatWaterlineContact`가 없어서 예상한 두 assertion이 실패 | source와 canonical copy의 SHA-256을 대조한 뒤 Scene consumer와 drift owner를 추가 | focused contract `PASS` |
| 3 | Windows OpenGL 540×960 title capture에서 깊이·높이 대안을 비교 | 초기 `y=0.20, z=-0.04`는 너무 낮고 camera-side라 waterline이 거의 읽히지 않음 | depth test를 유지한 `y=0.30, z=0.38`, bright alpha `0.42`로 보정 | title/voyage capture에서 캐릭터·동반자를 가리지 않는 얇은 양옆 접점 확인 |
| 4 | user가 요구한 더 낮은 framing을 contract와 GPU frame으로 재확인 | 첫 낮춤은 보트가 화면 중앙 아래에 남아 요청한 하단 20% 근처에 미달 | `BoatSpace=-2.7`, legacy ripple=-2.7, narrow contact=-2.4로 같은 기준을 이동 | lower-frame title/voyage capture에서 `쉬는 메뉴`와 비중첩 |
| 5 | Godot import, sorted 53 headless contracts, Windows GL display-only chroma proof, main/game/album/project smoke, Python profile·CI checks, exact capture hash readback | 기존 forward-drift test가 절대 world-y=0 가정을 갖고 있어 하단 배치를 잘못 실패로 판정 | test를 lowered `BoatSpace` 대비 상대 water-contact base 검증으로 교정하고 재실행 | all=54, headless=53, display-only=1, failures=0; Python `7 passed`; OpenGL evidence hashes are recorded in `docs/evidence/2026-08-31-waterline-contact-v2/` |
| 6 | same lower-frame OpenGL capture에서 Appreciation surface를 확인 | 낮아진 normal BoatSpace가 `감상 끝내기`와 겹침 | Appreciation enter/leave마다 `BoatSpace`와 두 contact를 함께 토글하도록 보정 | diorama avatar-camera contract `PASS`; 540×960 Appreciation capture shows sea/horizon and the non-overlapping exit control |

선정 구조는 `ADOPT`입니다. `BoatWaterContact`는 뒤쪽의 넓은 확산 ripple로 유지하고, user-approved transparent `MLB-BOAT-FLT-006`은 선체 하단의 좁은 contact로 분리합니다. `REJECT`한 대안은 v1처럼 보트·승객을 넓게 덮는 front puddle과, 보트만 움직이고 수면 접점을 world height에 고정하는 방식입니다. Godot `Sprite3D`는 3D world에서 texture를 표시하고, `Camera3D`는 viewport의 active camera로 scene projection을 제공하므로, 실제 renderer capture로 최종 depth·height를 검증했습니다. [Godot Sprite3D 공식 문서](https://docs.godotengine.org/en/stable/classes/class_sprite3d.html), [Godot Camera3D 공식 문서](https://docs.godotengine.org/en/stable/classes/class_camera3d.html)

### 2026-08-31 타이틀 보트·연속 수면 흐름 delivery receipt

이 receipt의 current exact base는 `7181d5e`이며, implementation은 shared dirty worktree에서 아직 commit·push 전이다. `git fetch origin --prune` 후 `HEAD=7181d5e`, `origin/main=7181d5e`, ahead/behind=`0/0`을 확인했다. 다른 owner의 uncommitted 변경이 넓게 남아 있으므로, 이 상태에서 direct `main` pull/push나 unrelated staging은 금지한다.

| Loop | 실제 확인 | 검증된 finding | 적용 또는 상태 | 회귀 증거 |
| --- | --- | --- | --- | --- |
| 1 | latest user direction, `AGENTS.md`, GDD, visual inventory, `game.tscn`, `game_scene.gd`, `GameState`, existing contact capture를 fresh-read | startup은 `_ready()`에서 즉시 `begin_voyage()`를 호출했고, `SeaBackdrop`은 camera-local fixed card이며, contact origin은 `y=-0.06`이었다 | title wait boundary와 below-horizon continuous flow를 approved bounded package로 채택 | old direct-entry contract를 새 acceptance로 rewrite할 준비 완료 |
| 2 | `test_direct_boat_entry_contract.gd`, identity/title/forward-drift contract를 code보다 먼저 실행 | title overlay, explicit start boundary, water-flow shader, contact placement가 없어서 expected 15 assertions가 실패 | failure-first receipt를 유지하고 source/Scene 구현 시작 | failure output preserved in session tooling; no false PASS claim |
| 3 | `game.tscn`, `game_scene.gd`, 초기 합성 수면 흐름 셰이더를 구현하고 focused 4 contracts와 game scene smoke를 실행 | title wait에서 `_apply_appreciation_mode()`가 rest button을 다시 노출함 | title presentation을 final UI pass 뒤 다시 적용해 title 동안 menu를 숨김. 합성 수면 셰이더는 2026-08-31 분리 하늘·바다 구조로 교체됐다 | direct-entry, identity, title-brand, forward-drift contracts와 headless scene smoke `PASS` |
| 4 | Windows OpenGL 540×960 title/voyage 0s·2s capture와 height/depth contact probes를 실제로 비교 | wide legacy ripple은 보트 하단 waterline을 충분히 읽히게 하지 못했다. procedural shadow probe도 밝은 바다에서 효과가 불충분했다 | ineffective shadow source/node/test를 제거했다. one dedicated waterline raster를 built-in image model로 생성했지만 `GENERATED_CANDIDATE`로만 유지한다 | current flow capture persists at `docs/evidence/2026-08-31-title-boat-flow`; candidate has no repo path, no consumer, no canon registration |
| 5 | Godot import, sorted 52 headless contracts, display-only chroma proof, two Python profile checks, project/scene smoke, persisted frame region delta를 rerun | no new code/test regression. lower-water `y=650..850` region changed `93.17%` in title 2s pair and `95.98%` in voyage 2s pair | title entry and continuous flow retained. waterline contact remains explicitly `PARTIAL_IMPLEMENTED` pending user `LOCK` | 52/52 headless `PASS`; OpenGL chroma proof `PASS`; Python `7 passed`; project and game scene smoke `PASS` |

이전 broad v1 waterline candidate는 historical rejected exploration이다. 이는 repository canonical asset·Scene consumer·test reference·release evidence가 아니다. 현재 승인·구현 asset은 `MLB-BOAT-FLT-006` v2이며 위 receipt와 `docs/evidence/2026-08-31-waterline-contact-v2/`가 owner다.

이전 direct-entry 보강은 Godot `4.7.1.stable.official.a13da4feb`에서 `tests/test_*.gd` 36/36 `PASS`를 기록했다. 현재 설치된 Godot `4.7.2.stable.official.ed1daf0bf`에서 natural-motif, main-postcard-omission, fish/completed-voyage ledger, quiet-action, alternate chibi canonical rebind 뒤 focused 계약을 다시 실행했다. `tests/capture_approved_alternate_chibi_family.gd`는 NVIDIA RTX 3050 OpenGL 3.3에서 A+cat+stripe, B+rabbit+moon, A+otter+stripe의 540×960 frame을 기록했다. `RestingSoundscape`는 headless에서 출력 없는 generated audio를 시작하지 않고, real-display lifecycle에서는 stop·stream release를 수행한다. Human/device visual and audio comfort는 `NOT_RUN`이다.

### 2026-08-31 malformed-merge recovery machine-verification addendum

- `7181d5e`의 literal VCS conflict block 100개를 제거하고, current runtime에 맞는 첫 번째 부모 `4cf09d9`의 exact blob 35개를 복구했다. 복구 뒤 `git diff --check`, marker scan, `godot --headless --path . --quit`, main/game/album scene smoke가 모두 통과했다.
- malformed-merge recovery 당시 Godot 계약 52개 중 headless-safe 51개를 정렬된 CI discovery와 같은 inclusion/exclusion 경계로 실제 다시 실행했다. 이 경로의 postcard `ViewportTexture` assertion은 명시적으로 `SKIP`이며, skip은 renderer PASS가 아니다.
- `test_chibi_normal_chroma_material_proof.gd`는 Windows display driver + `gl_compatibility`에서 NVIDIA GeForce RTX 3050, OpenGL 3.3.0 NVIDIA 572.16으로 실제 실행해 `PASS`했다. 생성된 `user://machine-test-evidence/chibi-normal-material-proof/chibi_normal_chroma_material_proof_540x960.png`은 SHA-256 `0198EDCD08C2F682C36D94ABA0FAC478277D9F2B6D121AEEFC1A8FFE7936878D`이며, shader가 녹색 technical matte를 남기지 않고 warm boat/player/dog foreground를 유지하는 machine renderer evidence다. 이전 GPU receipt는 historical evidence이며, 실제 기기 종료 동작과 Human audio comfort도 여전히 `NOT_RUN`이다.
- 이후 `godot-validation.yml`의 headless CI는 수동 명령 목록이 아니라 정렬된 `tests/test_*.gd` discovery를 사용한다. initial recovery receipt는 `all=52, headless=51, display_only=1`이었고, user-locked title brand contract가 추가된 current set은 `all=53, headless=52, display_only=1`이다. 새 52개 headless 집합은 local Godot 4.7.2에서 다시 exit 0으로 종료했다. 이 workflow 구성은 원격 CI PASS가 아니며, 예외 계약은 위 Windows GL Compatibility machine evidence로만 확인한다.

- **Current 2026-09-01 Look Around foreground receipt:** `all=57, headless=56, display_only=1`이다. `test_look_around_foreground_split_contract.gd`는 네 non-front foreground exact path, visible static sky, flowing sea ShaderMaterial, duplicate normal-card hiding을 확인한다. 56개 current headless 계약은 로컬 Godot 4.7.2에서 네 bounded batch로 aggregate success를 기록했고, import도 exit 0으로 끝났다. Windows OpenGL capture와 1.8초 port frame-pair 증거는 `docs/evidence/2026-09-01-look-around-foreground-split/`가 current owner다. 원격 CI와 Human/device comfort는 각각 `NOT_RUN`이다.

**Human evidence ceiling:** 실제 기기의 첫 30초·5분 휴식감, 터치 target, 모션 민감성, 텍스트 가독성, 사운드 편안함은 `NOT_RUN`이다. 기계 계약과 capture가 이를 대체하지 않는다.

## 1. 먼저 읽을 것

1. `AGENTS.md`
2. `docs/design/PROJECT_GDD.md`
3. 이 handoff
4. `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md`
5. 실제 Scene, GDScript, 테스트, capture

이 repository는 Notion을 현재 정본으로 사용하지 않습니다. 이전 Notion은 historical discovery archive이며, active implementation 판단은 repository source와 runtime evidence를 우선합니다.

## 2. Issue #99 당시 제품 방향과 runtime gap

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

## 3. Issue #99 당시 구현 금지선

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

## 4. Issue #99 당시 Phase 2 implementation contract

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

## 5. Issue #99 당시 시각 consumer와 evidence ceiling

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
