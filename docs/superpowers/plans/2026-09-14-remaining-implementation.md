# 남은 게임 구현 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking. 별도 사용자 요청 없이 실행 방식 선택 질문을 반복하지 않는다. 명세 준비 뒤 2026-09-14 `좋아 권장안대로 작업진행해`로 안전한 구현·검증 실행이 승인됐다. 최종 아트/기기/Human/출시 gate는 유지한다.

**Goal:** 목적지 없는 동반자 보트 휴식을 실제 공간 이동·연속 회전·안전한 기억 저장·사용 가능한 내부 빌드까지 연결한다.

**Architecture:** 기존 GameState/overlay/직선 VoyageRoute/저장 owner를 보존한다. 세계 수면·sky·모델·orbit은 한 좌표계를 공유하고, 새 아트는 격리 probe→실제 납품/lock→production 순서로 연결한다. 이 문서는 실행 절차이며 게임 의미·설계 계약을 중복 소유하지 않는다.

**Tech Stack:** Godot 4.7 stable, GDScript, glTF 2.0, 기존 Python 검증기, text-native Control/Theme. 유료 의존성/새 backend 없음.

**Spec:** [PROJECT_GDD.md — 2026-09-14 남은 작업 설계 명세 R01–R12](../../design/PROJECT_GDD.md). 실행자는 B5–B10, P1–P10과 해당 R 절을 함께 읽는다.

## Global Constraints

- `Godot 4.7 stable`. 현재 로컬 검증 실행 파일은 4.7.2이며 실행 때 다시 확인한다.
- `standard/gentle/still=1/0.5/0`. title은 부유만. Start 뒤 route 진행.
- `yaw ±135°`, `pitch -16°..38°`, `roll 0`. 새 orbit pitch의 의미/부호는 GDD R04를 따른다.
- `full overlay/앱 비활성에서 world·반응·풍경 시간 동결`. 저장·보상은 presentation이 역으로 진행시키지 않는다.
- 기존 3 style / 4 pet / 8 slot / 6 item와 저장 ID를 보존한다. 새 family 미지원 선택을 default로 바꾸지 않는다.
- candidate 생성/lock/정본 등록/실행 적용/실행 검증은 별도 상태. 없는 모델/음원 path를 납품 완료로 기록하지 않는다.
- `Human 검증은 사용자 선언 때만`. 공개 social/배포·서명·비용·외부 업로드는 이 계획의 자동 실행 범위가 아니다.
- 삭제 대신 날짜별 삭제 대기 폴더·원래 경로/사유/bytes/hash 목록. 다른 workstream·PR #19는 read-only.
- 매 단위 TDD→작은 구현→기계/필요 GPU→반례 검토 5회와 교정→정본/증거→단일 논리 commit. 테스트 횟수는 게임 완성률이 아니다.

## 기준과 실행 순서

2026-09-14 재개 상태. R07b1은 완료 증거 범위대로 유지한다. 첫 사용량 제한 뒤 재개한 R07b2는 `854fdce` 구현과 `817cd65` guard 교정, 전체65/마지막focused5·GPU·독립 scoped 재검토를 거쳐 해당 단위를 마쳤다. Android/iOS 사진 지원과 전체 R07은 완료가 아니다. 다음 단위 R07b3는 저장 성공 후 state 확정·복구 UI다. 크로마키 이미지 제작 정책과 별도 월간 AI 증빙 PDF 추가는 게임 R01–R12 완료율에 합산하지 않는다. 현재 상세 증거와 PDF 발행 상태는 `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`를 따른다.

기준 source `6b7949a563150bd93e08d5d5eb1e028eab7336ef`. origin/main `7181d5e6845e75107eade8c4d2e62e10334ab54b`와 다르므로 미래 실행 권한은 고정 SHA에서 추정하지 않는다. 실제 main·작업 branch·dirty 상태·PR·consumer·Base adapter를 매번 재독해한다.

```text
R01 세계 수면 ── R02 sky/명소 ─┐
R03 기본 모델 제작 ──────────┼─ R04 orbit/탑승 모션 ─ R05 시간대 ─┐
R07 저장 안전 ─ R06 draft ───┤                                 │
             └ R08 상세 ────┴─ R09 입력/선택 행동 ──────────────┤
R10 실제 필요 효과음 ──────────────────────────────────────────┤
R11 기준 측정(처음부터) ───────── 통합 soak/실기기/패키지 ──────┤
                                                             R12 통합/Blueprint
```

R06의 새 모델 전수 호환은 R03/R04 뒤, draft UI는 R07 뒤 독립 실행한다. R11 기준 측정은 지금도 가능하지만 최종 성능 검증은 통합 뒤다. R01/R02의 후보 probe와 production 승격은 별도 결과다. R03 도구/자산이 없을 때 다른 독립 작업을 막지 않되 모델 완료로 보고하지 않는다.

## 파일 경계와 공통 테스트 방식

아래 Create 경로·API는 **제안이며 현재 존재하는 구현이 아니다**. Modify는 실제 확인한 파일이다. 작은 독립 책임만 추출하고 game_scene 전체를 재작성하지 않는다. 각 작업의 코드 블록은 회귀 테스트 핵심 본문이며 다음 공통 fixture 안에서 실행한다. 이미지·모델 품질 자체를 이 assertion만으로 판정하지 않는다.

새 Godot behavior test는 기존 `tests/test_voyage_route_continuity.gd`의 SceneTree 구조를 재사용하되 다음 격리를 갖춘다. `run_cases`의 본문은 해당 작업의 사례로 작성하고 존재하지 않는 method는 먼저 명시적 실패로 검사한다. API가 없는 상태에서 parser error를 RED 증거로 사용하지 않는다.

```gdscript
# 해당 기능의 실제 소비 경로와 저장 격리를 검사한다.
extends SceneTree
var failures := 0
var paths: Array[String] = []

func _init() -> void:
    call_deferred("run")

func expect(ok: bool, message: String) -> void:
    if not ok:
        failures += 1
        printerr(message)

func new_required_script(path: String) -> Object:
    var exists := ResourceLoader.exists(path)
    expect(exists, "required implementation is missing: " + path)
    if not exists:
        return null
    return load(path).new()

func run() -> void:
    var state := root.get_node("GameState")
    for kind in ["comfort", "together_time", "memory_ledger", "identity", "boat_decor", "ambient_memory"]:
        var path := "user://test_remaining_%s.cfg" % kind
        paths.append(path)
        state.call("set_%s_storage_path" % kind, path)
    state.reset_session()
    var game := load("res://scenes/game.tscn").instantiate() as Control
    root.add_child(game)
    await process_frame
    game.set_process(false)
    game.set_application_foreground(true)
    await run_cases(game, state)
    game.queue_free()
    await process_frame
    root.get_node("RestingSoundscape").release_ocean_bed_for_shutdown()
    for frame in 4:
        await process_frame
    for path in paths:
        if FileAccess.file_exists(path):
            DirAccess.remove_absolute(ProjectSettings.globalize_path(path))
    print("REMAINING_CONTRACT_FAILURES=%d" % failures)
    quit(1 if failures else 0)
```

사진·backup 테스트는 해당 단위의 별도 `user://test_*` 디렉터리와 모든 파생 파일을 추가 격리한다. 위 공통 fixture만으로 사진 저장이 격리됐다고 생각하지 않는다. 동시에 실행하지 않는다. production persistence 경로에 fault injection 금지. GPU 캡처는 headless에서 하지 않고 새로운 절대 출력 경로만 사용한다.

공통 실행 명령은 다음과 같다. `$taskGodot`은 새 PowerShell 세션마다 이 값으로 설정한다.

```powershell
$taskGodot='C:/Users/user/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe'
& $taskGodot --version
& $taskGodot --headless --path . --import
& $taskGodot --headless --path . --script tests/test_voyage_route_continuity.gd
python -m unittest discover -s tests -p 'test_*.py' -v
git diff --check
```

새 `test_*.gd`를 실제 추가하면 `.github/workflows/godot-validation.yml`, `README.md`, `docs/PROJECT_WORK_REUSE_HANDOFF.json`의 계약 수와 display-only 구분을 함께 수정한다. 수는 현재 파일과 CI 목록에서 재계산하며 이 문서의 제안 테스트를 구현된 테스트로 세지 않는다. R07a 직후 기준은 64개/63 headless다.

## Task R01 — 공통 world 수면

**Files.** Create `scripts/voyage/world_ocean.gd`, `assets/shaders/world_ocean.gdshader`, `tests/test_world_ocean_contract.gd`. Modify `scenes/game.tscn`, `scripts/voyage/game_scene.gd`. Reuse `scripts/voyage/voyage_route.gd`, 기존 capture/analyzer. Candidate path/lock은 GDD R01/B9.

**Interfaces.** Consumes route transform와 기존 active delta/comfort. Produces GDD R01의 `advance_visual`, `sample_height`, `set_boat_anchor`; 평균 y=0과 world XZ UV. 이 API는 새 `OceanPlane` script가 소유한다.

- [ ] RED. `OceanPlane.visible`과 아래 height 함수 부재를 명시적으로 실패시킨다. 실제 height 반복/정지 assertion을 추가한다.

```gdscript
var ocean := game.get_node("VoyageWorld/OceanPlane")
expect(ocean.has_method("sample_height"), "world water must expose contact height")
if not ocean.has_method("sample_height"):
    return
var before: float = ocean.sample_height(Vector2(0, 2))
ocean.advance_visual(60.0, 0.0, true)
expect(is_equal_approx(before, ocean.sample_height(Vector2(0, 2))), "still must freeze water height")
ocean.advance_visual(60.0, 1.0, false)
expect(is_equal_approx(before, ocean.sample_height(Vector2(0, 2))), "inactive must freeze water height")
```

- [ ] 실행. `& $taskGodot --headless --path . --script tests/test_world_ocean_contract.gd`. 기존 구현의 실패 메시지를 보존한다.
- [ ] 구현. world plane geometry carrier에 승인 texture/material을 연결한다. shader UV 핵심은 `world_xz / tile_size + tile_origin_xz`, clock은 명시 uniform이다. route translation을 추가 UV offset에 다시 넣지 않는다. 동일 파동 식/계수를 CPU `sample_height`와 GPU displacement에 사용한다. 먼저 격리 후보 scene으로 검사하고 승인 전 production toggle을 기본 활성화하지 않는다.
- [ ] 검증. 128/512 경계·plane 재중심화·동일 world 표식의 세 시점 좌표, 전체 bob 접점, title/Start/still/overlay. 30초 실제 시간과 멈춤 시나리오 capture를 GDD 기준으로 판정한다. 투명도 B안이 실패하면 원인을 기록하고 완료 상태를 올리지 않는다.
- [ ] 교정·기록·commit. 기존 후면 접점/수면 family 회귀 후 이 단위만 commit. rollback은 새 consumer 비활성+기존 family 복귀이며 원화 삭제 없음.

## Task R02 — sky·cloud·원경

**Files.** Create `scripts/voyage/world_scenery_layer.gd`, `tests/test_world_scenery_contract.gd`. Modify `scenes/game.tscn`, `scripts/voyage/game_scene.gd`; existing `drift_scenery_director.gd`는 cadence/ID 보존. Sky resource의 정확한 새 path는 실제 승인 material 생성 시 manifest와 함께 등록한다.

**Interfaces.** Consumes R01 좌표계와 기존 motif ID. Produces `present_motif`, `advance_visual`, `clear_motif`(GDD R02), `VoyageWorld/WorldScenery` Node3D. sky는 WorldEnvironment owner.

- [ ] RED. camera-local motif 대신 동일 world 앵커가 없음을 실패로 확인한다.

```gdscript
var layer := game.get_node_or_null("VoyageWorld/WorldScenery")
expect(layer != null, "one world scenery consumer is required")
if layer == null:
    return
expect(layer.present_motif("MLB-AMB-MOTIF-003", Transform3D.IDENTITY), "known motif must be accepted")
expect(not layer.present_motif("unknown", Transform3D.IDENTITY), "unknown motif must not replace current scenery")
```

- [ ] 구현. 현재 봄섬의 고정 world anchor 방식에서 공통 부분만 추출한다. GDD의 radius+lane clearance를 계산하고 한 큰 motif만 유지한다. UI/확률/기억은 director에 남긴다. sky panorama와 true-alpha cloud는 독립 승인 입력이다.
- [ ] 검증. 위 test 실행 후 기존 `tests/probe_world_space_island.gd` GPU probe를 확대해 일반 6종+봄섬 1종을 모두 검사한다. ray/camera 변화에도 동일한 섬이고, 자동 진행에서 sky 방향이 바뀌지 않으며, 수동 yaw에는 sky 방향이 바뀌어야 한다.
- [ ] 교정·commit. 방향 카드 경계/반대쪽 sky 빈 공간이 하나라도 있으면 family 적용 보류. 기존 cadence/save·approved hash를 재확인한다.

## Task R03 — 기본 모델/리그 1세트

**Files.** 예정 Create `assets/models/boat/boat.glb`, `assets/models/player/player.glb`, `assets/models/companion/dog.glb`, `tests/test_model_family_contract.gd`. Modify `scenes/boat_space.tscn`, 기존 visual manifest/inventory. 현재 파일은 없음.

**Interfaces.** GDD R03의 anchor 이름·+Z/meter 규약·rest_loop/notice/settle clip을 R04/R06에 납품한다.

- [ ] 준비 실패를 명시. 실제 파일 존재, import 가능성, 모델 도구·권리·원본을 먼저 확인한다.

```gdscript
for path in ["res://assets/models/boat/boat.glb", "res://assets/models/player/player.glb", "res://assets/models/companion/dog.glb"]:
    expect(ResourceLoader.exists(path), "missing model delivery: " + path)
```

- [ ] 제작. 원본 모델→UV/재질→rig→3 clip→glTF export→Godot wrapper 순서. B10 pose와 GDD R03 규격을 납품 brief로 사용한다. 없는 도구·아트를 code-generated primitive/card로 대체하지 않는다. 이미지 모델은 texture/모델 입력 이미지용, Aseprite는 실제 2D layer/frame packaging용이다.
- [ ] 검증. 파일/mesh/geometry/Skeleton3D/clip와 anchors를 실제 instantiated scene에서 검사한다. 모델을 2회 재import하고 wrapper 설정이 유지되는지 확인한다. GPU에서 전 각도와 3 clip을 재생한다. source/asset approval이 없는 상태는 production 활성화 금지.
- [ ] 교정·commit. default 한 가족의 납품·왕복·lock 상태를 기록하고 source/provenance를 보존한다. 아직 전 style/pet 지원 완료가 아니다.

## Task R04 — orbit·탑승 pose

**Files.** Create `scripts/voyage/voyage_orbit_controller.gd`, `scripts/companion/rest_pose_controller.gd`, `tests/test_voyage_orbit_contract.gd`, `tests/test_rest_pose_contract.gd`. Modify `scenes/game.tscn`, `scenes/boat_space.tscn`, `scripts/voyage/game_scene.gd`, 기존 look-around/boat controllers의 라우팅.

**Interfaces.** Consumes R01 height와 R03 CameraFocus/seat anchors/clips. Produces GDD R04의 orbit API 및 pose API. 현재 `get_angle_id`는 입력 분류용으로만 보존한다.

- [ ] RED. 드래그 뒤 camera position이 실제 focus 주변에서 변해야 하고 world clock/reward는 그대로라는 검사를 만든다. 모델 없는 probe와 production 결과를 구분한다.

```gdscript
var rig := game.get_node("VoyageWorld/LookAroundCameraRig")
var original: Vector3 = rig.global_position
rig.set_view_angles(60.0, 0.0)
expect(rig.global_position.distance_to(original) > 0.1, "orbit must move camera, not only rotate in place")
expect(rig.has_method("reset_view"), "reset must restore the same voyage framing")
```

- [ ] 구현. orbit 중심과 시선 목표를 분리한다. 위치는 focus+rotated radius, elevation=`29.793805+relative_pitch`, yaw=`reference_yaw+relative_yaw`. 방향은 focus+UP×framing_height를 바라보며 계산하고 -elevation으로 덮지 않는다. GDD R04의 범위 탐색으로 normal/reset/resize 때 구도를 맞춘다. `Camera3D.unproject_position(focus)`를 viewport 크기로 나눈 좌표가 (0.5,0.80)±(0.03,0.03)인지 별도 assertion을 추가한다. 기존 drift의 rig position 덮어쓰기를 제거하고 controller에 focus transform을 전달한다. route position 자체는 변경하지 않는다.
- [ ] pose 구현. elapsed는 active일 때만 더한다. 45–90초 RNG는 test seed로 고정. REST deadline→NOTICE 1.2→SETTLE 1.8→REST, 중복 notice 요청 무시. AnimationPlayer/AnimationTree는 실제 3 clip만 소비한다. 접점은 model root가 아니라 지지 anchors 기준으로 검사한다.
- [ ] 검증. 위 tests와 `tests/test_camera_input_contract.gd`, `tests/test_look_around_camera_input_contract.gd`, `tests/test_voyage_overlay_continuity.gd` 실행. GPU 전 각도·입력 경계·기본 복귀 20회·still 수동 조작, actual pose contact를 capture.
- [ ] 교정·commit. 부호 교정으로 변경된 pitch 실제 범위를 GDD/inventory에 기록하고 모델/세계/저장 회귀를 확인한다.

## Task R05 — 시간대 동기 전환

**Files.** Create `scripts/voyage/atmosphere_transition.gd`, `tests/test_atmosphere_transition.gd`. Modify `scripts/voyage/game_scene.gd`, `scripts/voyage/time_of_day_catalog.gd`, 새 ocean/sky material consumers.

**Interfaces.** GDD R05의 request/advance/get_blend_weight. 문자열 ID는 기존 resolver 결과, weight는 모든 visual consumer 공통.

- [ ] RED. 같은 atmosphere 재요청은 restart하지 않고 3초 내 요청 변화는 한 target으로만 향해야 한다. 새 class를 load한 뒤 method 존재 확인 후 아래 본문을 실행한다.

```gdscript
var transition = new_required_script("res://scripts/voyage/atmosphere_transition.gd")
if transition == null:
    return
transition.request_atmosphere("bright") # 첫 요청은 즉시 초기화
transition.request_atmosphere("sunset")
transition.advance_visual(1.5, true)
expect(is_equal_approx(transition.get_blend_weight(), 0.5), "one shared three-second blend")
transition.advance_visual(99.0, false)
expect(is_equal_approx(transition.get_blend_weight(), 0.5), "inactive must freeze transition")
```

- [ ] 구현. 첫 family 즉시 설정, 다음부터 elapsed/3 clamp. 전환 중 요청은 latest_requested_id 문자열 하나만 덮어쓰고 진행 중 weight/target은 유지한다. 완료 뒤 최신 요청이 다를 때만 다음 전환을 시작하며 texture는 현재/다음 최대 두 family다. still/focus 복귀는 GDD R05 정책을 적용한다. 이전 family 참조는 완료 후 해제한다. 계절 motif는 R02 소유이며 새 계절 전용 sky/sea 확대는 이 Task 밖이다.
- [ ] 검증. 현재 `test_time_of_day_contract.gd`, `test_game_scene_time_of_day_contract.gd`에 모든 시각 경계/전환 중 최신 요청/invalid ID/overlay 추가. A→B 50%에서 C/D 요청에도 weight 불변, B 완료 후 D만 시작, 상주 family≤2, endpoint 화면 연속성을 확인한다. GPU 중간 0/1.5/3초에서 sky/sea/boat 모두 같은 family weight인지 판정.
- [ ] 교정·commit. 네 시간대 자산 납품과 blend 코드 결과를 따로 기록한다.

## Task R06 — draft와 호환 외형

**Files.** Create `scripts/decor/decor_edit_session.gd`, `tests/test_decor_edit_session.gd`. Modify `scripts/voyage/game_scene.gd`, `scripts/decor/decor_preview.gd`, `scripts/core/game_state.gd`, `scenes/game.tscn`, `scripts/identity/identity_visual_router.gd`. R07 파일 처리 재사용.

**Interfaces.** GDD R06의 session API와 GameState의 두 apply 메서드. `snapshot("identity")` 키는 player_style/pet_type, `snapshot("decor")` 키는 decor/appearances. snapshot은 deep copy. 저장 성공 뒤 `mark_applied(tab_id: String)`로 해당 draft를 새 baseline으로 바꾼다.

- [ ] RED. 선택만 할 때 GameState/cfg가 달라지는 현재 동작을 실제 옵션 이벤트로 확인한다. session 단위에서는 아래 독립 draft 사례를 사용한다.

```gdscript
var draft = new_required_script("res://scripts/decor/decor_edit_session.gd")
if draft == null:
    return
var original := {"player_style": "c_loose_knit", "pet_type": "dog"}
draft.begin(original, {"decor": {}, "appearances": {}})
draft.set_identity("a_soft_hooded", "cat")
expect(original.pet_type == "dog", "preview must not mutate committed identity")
draft.discard("identity")
expect(draft.snapshot("identity").pet_type == "dog", "cancel must restore committed identity")
```

- [ ] 구현. option handlers는 draft만 수정. preview에 snapshot 전달. Apply→owner validate/save→GameState 확정→draft.mark_applied(현재 탭)→실제 router 갱신. 실패 시 기존 모습 복귀와 문구. 탭별 적용을 버튼에 명시하고 닫기는 미적용 draft만 취소한다.
- [ ] 호환 확대. catalog에서 12 identity 조합·호환 slot/item/appearance를 열거해 모델 mapping 작성. unsupported는 legacy family 유지 사실을 표시하고 ID를 쓰기 변경하지 않는다.
- [ ] 검증. cfg byte 비교, Apply 연타/실패/닫기/탭 이동, preview-camera 입력 충돌. 기존 identity/decor 테스트 전체와 12조합 GPU. 실제 새 모델이 없으면 draft만 완료로 기록한다.
- [ ] 교정·commit. 데이터 UI와 모델 확대는 독립적으로 검토 가능한 두 commit으로 분리한다.

## Task R07 — owner별 저장 안전

실행 상태. R07a 공통 helper+comfort 첫 consumer가 `4773c68`에 구현됐다. 최초 저장의 원본 의도 기록은 pending 생성 전 수행하도록 독립 검토에서 교정했다. 이후 나머지 owner, GameState/UI 성공 경계, 사진 경로를 검증한 뒤에만 전체 R07을 완료로 올린다. 아래 전체 Task 체크박스는 부분 납품만으로 완료 처리하지 않는다. [현재 증거](../../evidence/2026-09-14-recoverable-save/REVIEW.md).

실행 묶음은 R07b1의 다섯 단순 owner → 사진 PNG/목록과 경로 경계 → GameState 성공 확정·복구 UI다. 각 묶음 독립 검토 뒤 다음으로 이어간다. 실패 시 together-time의 미저장 누적을 지우지 않고, 물고기는 목록 저장 성공 전 입질 상태를 소비하지 않는다. 항해 기록도 성공 전 생성 완료를 표시하지 않는다. 이 연결 뒤 R06 draft/R08 상세로 이어가며 저장 helper만으로 전체 완성을 주장하지 않는다.

**Files.** Create `scripts/core/recoverable_config_store.gd`, `tests/test_recoverable_config_store.gd`. Modify 실제 `scripts/core/comfort_preferences.gd`, `cosmetic_identity_profile.gd`, `boat_decor_persistence.gd`, `together_time_persistence.gd`, `ambient_memory_persistence.gd`, `memory_ledger_persistence.gd`, `photo_memory_persistence.gd`; GameState는 성공 확정 경로만 변경.

**Interfaces.** GDD R07의 read/write 결과와 `PhotoMemoryPersistence.resolve_photo_path(entry) -> String`. schema validator는 owner가 제공한다. 공통 store가 문자열/사진/장식 schema를 소유하지 않는다.

- [ ] RED. 테스트 전용 파일에서 parse 실패/unknown key/invalid field 및 각 단계 쓰기 실패를 재현한다. 단계별 writer 대역은 테스트 fixture에만 두고 실제 owner 소비 경로 assertion을 유지한다.

```gdscript
var store = new_required_script("res://scripts/core/recoverable_config_store.gd")
if store == null:
    return
var valid := func(config: ConfigFile) -> bool:
    return config.has_section_key("test", "value")
var result: Dictionary = store.read_validated("user://test_store_missing.cfg", valid)
expect(result.status == "ABSENT", "missing is not corrupt or recovered")
var photo := PhotoMemoryPersistence.new("user://test_photo_safe.cfg", "user://test_photo_safe")
expect(photo.has_method("resolve_photo_path"), "photo reads require a path boundary")
if photo.has_method("resolve_photo_path"):
    expect(photo.call("resolve_photo_path", {"id": "x", "image_path": "user://outside.png"}) == "", "external photo path must be rejected")
```

- [ ] 구현. GDD R07의 validate→pending write/readback→last_good copy/hash→replace→readback 순서를 helper에 구현한다. Dictionary의 COMMITTED만 UI/state 성공으로 전달한다. 교체 후 검증 실패에는 복원+hash를 확인하여 NOT_COMMITTED 또는 RECOVERY_REQUIRED를 반환한다. 후자는 owner 쓰기 잠금·마지막 committed 메모리·모든 복구 증거 보존·복구 필요 UI를 적용한다. recover_primary의 검증 성공만 잠금을 해제한다. 기존 pending/손상/unknown key는 새 쓰기 전에 보존한다.
- [ ] 각 owner 적용. 하나씩 legacy 정상/손상 fixture를 실행한다. 한 owner 교체가 다른 파일 format을 바꾸지 않는지 diff/readback. 사진은 별도 PNG/list commit 경계와 path validator를 적용한다. recovery 파일은 백업 소비처이므로 임시파일로 지우지 않는다.
- [ ] 검증. `tests/test_photo_memory_persistence.gd`, `tests/test_photo_memory_state_contract.gd`, 각 기존 persistence 검사와 새 fault matrix. 교체 후 readback 실패/복원 성공, 복원 실패/잠금 유지, 기존 primary 없음, interrupted pending, backup 읽기 성공이 쓰기 잠금 해제로 오인되지 않는 경우를 추가한다. R06/R09도 RECOVERY_REQUIRED를 성공으로 소비하지 않아야 한다. 실제 프로세스 강제 종료는 별도 테스트 앱/격리 save에서만 시행. 전원차단 보장 문구는 실제 플랫폼 검증 없으면 금지.
- [ ] 교정·commit. helper+첫 owner, 나머지 owner 묶음을 의존 순서대로 작은 commit. rollback 후에도 recovery 자료를 보존한다.

## Task R08 — 사진 상세

**Files.** Modify `scenes/album.tscn`, `scripts/ui/album_view.gd`; Create `tests/test_album_detail_contract.gd`. Reuse R07 path resolver, 현재 pagination.

**Interfaces.** `AlbumView.open_photo_detail(photo_id: String) -> bool`, `close_photo_detail() -> void`; PhotoDetail node. 상세의 ID는 기존 entry id를 사용한다.

- [ ] RED. 실제 앨범을 instantiate하고 없는 detail API/입력 consumer를 실패로 확인한다.

```gdscript
var album := load("res://scenes/album.tscn").instantiate() as Control
root.add_child(album)
await process_frame
expect(album.has_method("open_photo_detail"), "album needs a detail consumer")
if album.has_method("open_photo_detail"):
    expect(not album.open_photo_detail("missing-id"), "unknown id must not open unrelated file")
album.queue_free()
```

- [ ] 구현. card→ID→validated path→one detail image. 닫기 시 texture 참조 해제, 원래 페이지/스크롤 유지. 기본 GameScene world는 새로 만들지 않는다. caption/Back을 Container로 배치한다.
- [ ] 검증. 0/1/3/4/100 기록·missing/corrupt PNG·external path·큰 이미지·20회 재개·전체 비율/3화면 크기. GPU에서 실제 사진 ID와 나타난 그림을 대조. 사진 삭제·공개 공유 없음.
- [ ] 교정·commit. 기존 앨범·overlay·photo busy 회귀 후 기록.

## Task R09 — 입력·낚시·문구 수용

**Files.** Modify `scenes/game.tscn`, `scenes/album.tscn`, `scripts/voyage/game_scene.gd`, `scripts/voyage/fishing_session.gd`(validated failure가 있을 때만), 기존 UI tests. Theme는 현재 적용 경로를 먼저 조사하고 새 자산이 필요하면 `assets/themes/rest_ui.tres`를 제안 경로로 사용한다.

**Interfaces.** 기존 Start/overlay/busy/fishing/session이 owner. 새로운 진행률·보상·의무 flow 없음.

- [ ] RED. 실제 버튼 입력으로 작동 순서와 취소 시 무결과를 검사한다. 낚시 state 기본 사례는 다음과 같다.

```gdscript
var fishing := CalmFishingSession.new()
fishing.cast_line(0.0, "catch")
fishing.cancel()
expect(fishing.resolve_catch("test fish") == "", "cancel cannot produce a catch")
fishing.cast_line(0.0, "quiet")
expect(fishing.resolve_quiet(), "quiet completion is not failure")
expect(not fishing.resolve_quiet(), "quiet outcome cannot resolve twice")
```

- [ ] 구현. 발견된 누락에만 기존 state/Container/Theme를 교정한다. catch 저장 오류는 성공 전 state 소비 금지. back 우선순위와 UI-consumed input 차단을 GDD R09에 맞춘다. font scale1/1.25/1.5와 48px hit target 검사 fixture를 추가한다.
- [ ] 검증. `tests/test_fishing_session.gd`, `tests/test_fishing_outcome_contract.gd`, `tests/test_voyage_overlay_continuity.gd`, `tests/test_camera_input_contract.gd`, 사진 capture guard. 세 viewport/긴 화면 safe area/긴 caption과 메뉴 드래그 GPU 입력.
- [ ] 교정·commit. 기계 가독성 확인과 Human 편안함을 구분한다. 외부 접근성 인증을 주장하지 않는다.

## Task R10 — 필요 효과음만

**Files.** Modify `scripts/audio/resting_soundscape.gd`, `scripts/core/comfort_preferences.gd`, `scripts/core/game_state.gd`, `scenes/game.tscn`. Create `tests/test_near_effect_audio_contract.gd`는 실제 음원/consumer 착수 때만 추가. 실제 audio resource path는 제작/권리 확인 후 catalog에 기록.

**Interfaces.** GDD R10의 `play_near_effect`와 `set_effect_volume`; 기존 ocean API와 stream은 유지한다.

- [ ] 필요성/파일 gate. 짧은 waterline/선체/notice 이벤트 중 실제 청취 가능한 납품을 먼저 확인한다. 빈 slider/placeholder 효과음부터 배포하지 않는다.
- [ ] RED. 없는 효과 호출을 명시 실패시키고 기존 OceanBed의 stream/재생 위치가 바뀌지 않는 사례를 쓴다.

```gdscript
var sound := root.get_node("RestingSoundscape")
expect(sound.has_method("play_near_effect"), "effect requires an actual sound consumer")
if sound.has_method("play_near_effect"):
    expect(not sound.play_near_effect("unknown"), "unknown effect must be ignored without restarting ocean")
```

- [ ] 구현. 실제 효과 전용 bus/최대 voice 2/queue 없음. optional effects_volume을 실제 소비할 때만 저장한다. mute 전 초기화 순서와 저장 실패 session-only는 현재 OceanBed 패턴 재사용.
- [ ] 검증. invalid volume/voice limit/loop seam/peak/mute startup/화면 전환. 현재 `tests/test_ocean_volume_contract.gd` headless+display 회귀. 청취는 Human 선언 후.
- [ ] 교정·commit. 실제 layer가 없는 경우 R10은 BASELINE 유지/PARTIAL로 남기며 무의미한 새 구조를 추가하지 않는다.

## Task R11 — 실제 시간·실기기·패키지

**Files.** Modify 기존 `tests/capture_voyage_realtime_motion.gd`, `tools/analyze_voyage_motion_capture.py`, `.github/workflows/godot-validation.yml`, `export_presets.cfg`(target 권한 확인 때만). 필요 Create `tests/capture_voyage_soak.gd`는 실제 시간 duration/새 output dir을 받는 fixture로 한정.

**Interfaces.** 기존 telemetry에 실제 hardware/renderer/engine/revision/frame-time/memory/calls를 추가한다. 측정값은 QA output이고 게임 저장값이 아니다.

- [ ] 기준 측정. 현재 internal Windows baseline을 기록한 뒤 같은 장치/viewport/quality에서 새 family와 비교한다.
- [ ] 검사 작성. 30/300/1800초 wall-clock과 frame delta를 함께 기록한다. 자동 input replay는 own viewport에만, 모든 save는 test directory로 분리한다. water-only ROI/world 표식과 접점 metrics를 별도 항목으로 둔다.
- [ ] 실행. 아래 export는 공개 배포가 아닌 현재 내부 preset이다. 출력은 기존 파일을 덮지 않는 새 task 경로로 지정한다.

```powershell
& $taskGodot --headless --path . --import
$taskBuild='C:/Users/user/AppData/Local/Temp/mlb-internal-package-20260914'
if (Test-Path -LiteralPath $taskBuild) { throw '출력 경로가 이미 있습니다. 기존 산출물을 덮지 말고 새 작업 경로를 정하세요.' }
New-Item -ItemType Directory -Path $taskBuild
& $taskGodot --headless --path . --export-debug 'Windows Desktop' (Join-Path $taskBuild 'my_little_boat.exe')
```

- [ ] 검증. 새 패키지에서 Start/무입력 휴식/사진/앨범/꾸미기/mute·restart 실제 확인. raw frame 전체를 repo에 중복 저장하지 않고 source-bound 요약·대표 frame·재생본을 남긴다. 5분/30분 p95/p99와 residency 증가를 기록한다.
- [ ] 실기기 gate. 사용 가능한 실제 모바일 OS/장치/SDK/서명/연결 권한을 확인한다. 없으면 Device=NOT_RUN과 정확한 준비물만 보고한다. PC Mobile renderer 결과를 모바일 기기 PASS로 쓰지 않는다.
- [ ] 교정·commit. 성능 병목 consumer만 줄이고 낮은 품질이 core 가독성을 무너뜨리면 반영하지 않는다.

## Task R12 — main·Blueprint·최종 gate

**Files.** 기존 `docs/design/PROJECT_GDD.md`, handoff, visual inventory, `docs/DOCUMENTATION_MAP.md`, 기존 PDF generator와 publication receipt. generator 경로는 `rg --files tools | rg 'blueprint.*pdf|pdf.*blueprint'`로 현재 책임 파일을 확인한다. 새 master 문서나 PDF generator를 만들지 않는다.

**Interfaces.** 모든 R의 exact revision/evidence/asset 상태를 소비하여 current source-bound publication을 생산한다. 과거 receipt를 overwrite하지 않는다.

- [ ] fresh gate. 아래 read-only 조회 후 관련 PR 범위·diff·required checks·unmerged worktree를 확인한다.

```powershell
git fetch origin
git status --short
git log --oneline origin/main..HEAD
gh pr list --state open --json number,headRefName,title
```

- [ ] 정상 통합. current-task 변경만 권한 범위의 PR로 검토한다. force/admin/direct-main push 없음. main 통합 후 R11 clean import/export 및 전체 tests를 main에서 다시 실행한다. PR #19는 건드리지 않는다.
- [ ] Blueprint. 현재 구현 capture, 화면/자산 atlas, SWOT 강화/보완 결과, 데이터/시스템/모션 설명과 남은 gate를 GDD에서 파생한다. PDF 스킬을 읽고 렌더→글자 겹침/그림 중복/누락/이미지 상태 설명을 검사한다. 이번 명세 작성 턴에는 PDF를 만들지 않는다.
- [ ] 최종 판정. Machine/Runtime/Device/Human/User lock/Release를 따로 표기한다. local core는 social 서버 없이 실행돼야 한다. 공개 bottle은 기존 social owner와 production moderation gate가 충족돼야 별도 검토한다.
- [ ] 전달. 사용 방법, 실행 파일·현재 Blueprint, 남은 사용자 결정, 삭제 대기 링크를 제공한다. 테스트 수나 문서량으로 완성률을 계산하지 않는다.

## 명세 검토 기록과 실행 경계

이 항목은 문서 준비의 검사 기록이다. 위 구현 체크박스는 모두 미실행으로 유지한다. source 기준/실제 read/검사 결과를 [현재 handoff](../../handoffs/CURRENT_GODOT_IMPLEMENTATION.md)의 2026-09-14 항목에 연결한다. 런타임 코드는 이번 턴에서 변경하지 않는다.

2026-09-14 문서 검토 5회. 공통 source 기준은 위의 branch/main SHA, 검토 대상은 이 계획·GDD R01–R12·현재 handoff·문서 router의 작업 중 변경이다. 아래는 게임 구현의 5회 검증이 아니라 명세 범위의 검토다.

| 회차 | 실제 읽기·검사 및 교정 | 회귀·다른 consumer·대안/장기 적합성 |
|---|---|---|
| 1 | AGENTS, GDD B/P 계약, handoff, branch/main/열린 PR, Base adapter 대조. 기존 구현과 R01–R12 잔여 분리 | 최신 Base 자동 교체 대신 v9.4.4 유지. 기존 route/overlay/사진 보호를 미구현으로 되돌리지 않음 |
| 2 | game_scene의 외형 handler, album card 입력, persistence, 시간대/모션/catalog/asset 파일 대조. R06 즉시 저장 및 R08 상세 부재 확인 | 별도 GDD master 대신 기존 GDD 보강. 탭별 적용으로 다중 cfg transaction 확대를 피함. 기존 ID/미지원 legacy 보존 |
| 3 | 전체 Task의 파일/API/테스트 fixture/선행 조건 대조. mark_applied 누락과 없는 API의 parser 실패 위험 교정 | 명시적 missing-script/method 검사, 격리 저장 teardown, 실제 자산 미납품 구분. 문서 ID·로컬 링크 검사 및 Python 20 tests 통과 |
| 4 | 독립 검토 및 작성자 재대조. R04 중앙 시선/하단 구도 충돌, R05 두 family/즉시 retarget 충돌, R07 복원 실패 상태 누락 교정 | pivot/aim 분리, latest-ID 한 개, RECOVERY_REQUIRED 채택. 계절 owner 분리. 재검토에서 지적 범위 추가 MUST_FIX 없음. runtime 파일 무변경 재확인 |
| 5 | 수정 후 12 Task와 GDD 계약·handoff·router 교차 읽기, diff 공백 검사, Python 전체 20 tests 재실행 | R06 실패 판정을 R07 상태와 재연결. 새 PDF/게임/자산/Device/Human 검증으로 과장하지 않음. 실행 시 fresh-read와 개별 RED/GREEN 필요 |

검사 명령은 `git diff --check`, `python -m unittest discover -s tests -p 'test_*.py' -q`, `git diff --quiet -- scripts scenes assets tests project.godot export_presets.cfg`다. Python 20개는 기존 문서·도구 검사이며 여기 제안한 새 Godot 테스트 본문은 실행하지 않았다. 파일/링크 대조는 R01–R12 양쪽 존재와 문서 내 상대 링크 대상 존재를 확인했다. 미해결 자산·실기기·Human·출시 경계는 R03/R11/R12에 그대로 남긴다.

실행 전에 해당 Task와 GDD R 계약을 다시 읽고, 파일 존재/승인/연결 상태가 달라졌으면 명세와 현재 owner를 먼저 동기화한다. 없는 모델·새 final lock·실기기/배포 gate를 일괄 승인된 것으로 해석하지 않는다.
