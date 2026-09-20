# 첫 섬 P1 상태·시간·저장 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: `superpowers:executing-plans`로 아래 task를 순서대로 구현한다. 권장 실행 방식은 같은 작업에서 직접 구현하고 병합 전 독립 검토하는 Native다. 별도 작업 생성·플러그인 설치는 하지 않는다. 이 계획의 코드 블록은 구현 지침이지 이미 존재하는 제품 코드가 아니다.

**Goal:** 기존 보트 세이브를 건드리지 않고 6칸/2작물의 심기·돌보기·성장·수확·종료/복귀를 재현 가능한 상태/파일 검사로 완결한다.

**Architecture:** 순수 `FarmState`가 작물 규칙, `IslandSaveStore`가 ConfigFile/복구, Scene 소유 `IslandSession`이 clock/lifecycle/commit 순서를 맡는다. 작물 결과는 파일 확정 후만 발행한다. UI·모션은 상태를 소비하며 결과를 소유하지 않는다.

**Tech Stack:** Godot 4.7 stable, GDScript, 기존 SceneTree CLI 검사, ConfigFile. 기존 continuation의 `RecoverableConfigStore`만 선별 재사용한다.

**Spec:** [GDD MLB-ISLAND-SLICE-01 §5–6](../../design/PROJECT_GDD.md#5-농사결과시간-명세). 근거 기준 main `57295a59aafdd0fd2d796d6ecf3fe11b153b6dcb`. 실행 직전 최신 main/consumer를 다시 읽는다.

**Status:** `IMPLEMENTATION_PARTIAL / BLOCKED_LOCAL_SAVE_PROTECTION`. 사용자 '좋아 작업 계속 진행해'로 상세 계획의 Native 실행을 승인했다. Task 1–3의 코드/신규 검사와 CI 연결은 구현했으나 Task 4에서 기존 보트 테스트가 실사용 저장 두 파일을 변경해 중단했다. 실제 결과와 재개 결정은 [현재 handoff](../../handoffs/CURRENT_GODOT_IMPLEMENTATION.md)의 `MLB-P1-SAVE-INCIDENT-20260920`이 소유한다. 아래 checkbox는 원래 실행 요구 목록이며 완료 증거는 handoff/commit을 따른다. 최종 섬 아트/Blueprint와 새 섬 runtime은 별도다.

## Global Constraints

- 섬 1개, 플레이어 1명, 고정 밭 6칸, 작물 2종, 감상 장소 1곳, 바구니 1개라는 첫 Slice 상한을 유지한다. P1은 그중 상태/시간/저장만 담당한다.
- 씨앗 무료·무제한, care 세대당 1회, 고사/의무 일과/경쟁/화폐/온라인 없음. 초기 성장 180/480초와 care credit 0.20은 시험값이다.
- `user://island_farm_v1.cfg`만 새 production owner다. 기존 voyage/identity/comfort/photo 저장과 ID, `GameState`, autoload, `project.godot`, 승인 자산을 변경하지 않는다.
- 미래 배 나들이는 `MLB-BOAT-OUTING-01 / DEFERRED_NOT_IMPLEMENTED`. 출항 router·선박 상태·항로·빈 저장 필드는 P1에 만들지 않는다.
- `scripts/island/`와 테스트는 한국어 역할 주석을 둔다. 모든 API의 Dictionary는 외부로 넘길 때 deep copy한다. 호출자가 snapshot을 바꿔 상태를 오염시킬 수 없어야 한다.
- 새 class_name 충돌과 Godot 4.7.0 CI/로컬 4.7.2 API 차이를 실행 전에 확인한다. 새 플러그인·DB·서버 없음.
- 기존 두 전체 검토는 PR #109에서 소진했다. 이 후속 계획은 영향 검토와 필수 독립 병합 검토만 수행하며 전체 검토 횟수를 초기화하지 않는다.
- 새 섬 MACHINE/RUNTIME/HUMAN은 현재 `NOT_RUN`. P1 PASS도 그림·카메라·사람 재미 PASS가 아니다.

## Review Focus

아래는 일반 흐름만 시험하면 놓칠 조건이며 담당 task에 구체 assertion을 연결했다.

1. 백그라운드 복귀 알림이 두 번 들어옴 → 동일 경과를 한 번만 적용. Task 3 `set_foreground` 재입력 검사.
2. 미래 schema primary와 정상 구버전 backup 공존 → 구버전으로 덮지 않고 양쪽 보존. Task 2 byte 비교.
3. 첫 저장 중단 후 primary 부재·pending/receipt 존재 → 새 농장으로 자동 저장하지 않음. Task 2 first-write fault.
4. 오래된 버튼 입력이 수확·재심기 뒤 도착 → 다른 세대 작물을 건드리지 않음. Task 1 generation/revision 검사.
5. save 실패 뒤 재시도하면서 모션 callback이 도착 → 수확/성장이 중복되지 않음. Task 3 durable snapshot/이벤트·재확인 검사.

## 파일·인터페이스 계약

아래 경로는 **아직 없는 계획 파일**이다. 기존 파일 수정은 마지막 CI/README 연결과 재사용 모듈의 선택 이식뿐이다.

| Task | 파일 | 책임 |
| --- | --- | --- |
| 1 | `data/island/crops.json`, `scripts/island/farm_state.gd`, `tests/test_island_farm_state.gd` | 카탈로그 검증, 순수 snapshot/명령/시간 |
| 2 | `scripts/core/recoverable_config_store.gd`, `scripts/island/island_save_store.gd`, `tests/test_recoverable_config_store.gd`, `tests/test_island_save_contract.gd` | 기존 복구 코드/검사 선별 이식, 섬 schema 보호·파일 commit |
| 3 | `scripts/island/island_session.gd`, `tests/test_island_session_contract.gd` | 주입 clock·저장소, 상태 확정·실패·lifecycle |
| 4 | `.github/workflows/godot-validation.yml`, `README.md`, 기존 handoff | 실제 추가 검사 실행과 P1/제품 미구현 구분 |

`FarmState`는 RefCounted, `IslandSession`은 Node다. catalog는 Task 1이 `static func load_catalog(path: String) -> Dictionary`로 읽어 `{status, crops}`를 반환한다. 실패는 `INVALID_CATALOG`와 빈 crops다. **JSON 카탈로그에만** schema를 finite int/float의 값 1로 검증한 뒤 내부 int 1로 정규화한다. Godot JSON의 숫자는 float로 파싱될 수 있으므로 ConfigFile snapshot의 strict int 계약과 혼동하지 않는다. bool/string/분수/비유한 값은 거절한다. radish/tomato 두 key, finite 양수 growth, 0..0.25 credit, 0..1 안쪽 threshold, 비어 있지 않은 visual ID 문자열을 검증한다. 파일/JSON parse 실패나 잘못된 타입은 기본값으로 숨기지 않는다. Session의 순수 도메인은 성공한 catalog만 받는다.

| API | 정확한 입출력 |
| --- | --- |
| `FarmState.new(crops: Dictionary)` | catalog 사본 보유 |
| `new_snapshot(now_utc: float) -> Dictionary` | schema_version=1, revision=0, saved_at_utc, 6 plots, last_harvest_crop="", player={x:0.0,z:0.0,yaw:0.0} |
| `validate_snapshot(value: Variant) -> bool` | 타입/값/고정 ID 검사; 지형 판정·I/O 없음 |
| `phase(plot: Dictionary) -> String` | EMPTY / SEEDLING / YOUNG / MATURE |
| `advance_elapsed(state: Dictionary, seconds: float) -> Dictionary` | deep copy 후 성장; revision 불변. 음수/비유한 경과는 변화 0 |
| `preview_command(state: Dictionary, plot_id: String, action: String, crop_id: String, expected_generation: int, expected_revision: int) -> Dictionary` | `{status, snapshot}`. 성공 `APPLIED`는 후보일 뿐 파일 commit 아님; 실패 snapshot은 원본 사본 |
| `IslandSaveStore.new(path: String, farm: RefCounted, backend: RefCounted = null)` | 명시적 production/test 경로; null backend면 선택 이식 store 사용 |
| `load_state() -> Dictionary` | `{status, snapshot, error}`. OK/ABSENT/RECOVERY_REQUIRED/UNSUPPORTED_VERSION/IO_ERROR/CORRUPT. 읽기만 함 |
| `commit(snapshot: Dictionary) -> Dictionary` | `{status, error}`. COMMITTED/NOT_COMMITTED/RECOVERY_REQUIRED/UNSUPPORTED_VERSION |
| `recover() -> Dictionary` | 명시적 사용자 복구만. COMMITTED도 복구 동작 결과이며 재로드 전 편집 불가 |
| `IslandSession.configure(farm: RefCounted, store: RefCounted, utc_now: Callable, ticks_now: Callable) -> void` | owner와 초 단위 clock 주입, 아직 로드/저장 안 함 |
| `start() -> Dictionary`, `retry_load() -> Dictionary`, `recover_storage() -> Dictionary` | 상태 로드/복구. start 중복은 BUSY; retry는 거절된 명령을 재실행하지 않음 |
| `snapshot() -> Dictionary`, `can_edit() -> bool`, `tick() -> void`, `set_foreground(value: bool) -> void` | 사본 읽기, 현재 편집 가능, 성장/30초 flush, lifecycle 전환 |
| `request_action(plot_id: String, action: String, crop_id: String, expected_generation: int, expected_revision: int) -> Dictionary` | 사용자 입력을 한 번 처리. 거리/대상 도달은 P2 입력 owner가 먼저 검사; stale/state는 여기서 재검사 |
| `flush() -> Dictionary`, `set_player_pose(x: float, z: float, yaw: float) -> bool` | 정상 종료/pause 저장, 유효 숫자 위치 업데이트. Scene이 보행 위치만 전달 |
| Session signals | `state_changed(snapshot: Dictionary)`는 관측 상태, `action_committed(result: Dictionary)`는 COMMITTED 행동만, `storage_blocked(status: String)`는 실패 전환 1회 |

### 저장값·검증 목록

plot은 `{crop_id: String, generation: int, elapsed_seconds: float, cared: bool}`다. EMPTY는 crop_id="", elapsed=0, cared=false이며 generation은 재사용 방지를 위해 유지한다. `plant` 때 generation+1, 성공 명령 때만 전역 revision+1이다. generation/revision은 0..2^53-1 정수이며 상한이면 변경 없이 `COUNTER_LIMIT`. phase는 저장하지 않는다.

ConfigFile snapshot의 schema/revision/generation은 bool/float를 정수로 강제 변환해 받지 않는다. saved_at_utc는 finite 숫자 >=0, 위치 x/z/yaw는 finite 숫자다. 작물 elapsed는 0..growth_seconds, crop ID는 catalog 허용값, plots는 정확히 plot_01..plot_06, last_harvest_crop은 빈 문자열 또는 catalog ID다. Dictionary/배열/Resource를 문자열로 강제 변환하지 않는다. 알 수 없는 snapshot 키는 손상으로 간주해 거절한다. ConfigFile의 다른 section/key 보존은 기존 backend 책임이다. 정상 숫자지만 지형상 보행 불가인 위치는 P2에서 **위치만** fallback한다.

## Task 1. 작물 데이터와 순수 상태 규칙

**Consumes:** GDD §5의 두 작물/무벌점 규칙. **Produces:** 위 FarmState API. create 경로는 파일 표 Task 1과 같다.

세 신규 검사 파일의 공통 시작/종료 패턴은 아래와 같다. `subject_path`와 `test_body()`는 각 Task의 대상과 바로 아래 assertion으로 채운다. 저장 테스트의 `_finish()`에는 테스트가 생성한 정확한 경로의 teardown을 quit 전에 붙인다. `test_body`가 중간 return해도 `_run`이 종료 코드를 발행한다.

```gdscript
# 섬 상태의 실패·정상 경로를 격리해 검증한다.
extends SceneTree
var failures := 0
var subject_path := "res://scripts/island/farm_state.gd"
func _init() -> void:
    call_deferred("_run")
func _run() -> void:
    expect(ResourceLoader.exists(subject_path), "planned owner must exist")
    if failures == 0:
        test_body()
    _finish()
func expect(condition: bool, message: String) -> void:
    if not condition:
        failures += 1
        printerr("FAIL: " + message)
func _finish() -> void:
    print("PASS: " + subject_path if failures == 0 else "FAILURES: %d" % failures)
    quit(0 if failures == 0 else 1)
```

- [ ] 카탈로그와 아래 독립 SceneTree 검사부터 만든다. test의 `expect/_finish`는 위 실패 카운트·exit 1 패턴을 사용한다. 아래 테스트 호출은 이후 API와 동일하다.

```json
{"schema_version":1,"crops":{
  "radish":{"growth_seconds":180.0,"care_credit_ratio":0.20,"young_threshold":0.25,"visual_id":"IV05_RADISH"},
  "tomato":{"growth_seconds":480.0,"care_credit_ratio":0.20,"young_threshold":0.25,"visual_id":"IV05_TOMATO"}
}}
```

```gdscript
# Task 1 test run()의 핵심 assertion. expect(condition, message)는 실패 수만 누적한다.
var farm_script: Variant = load("res://scripts/island/farm_state.gd")
var catalog: Dictionary = farm_script.load_catalog("res://data/island/crops.json")
expect(catalog.status == "OK", "catalog valid")
if catalog.status != "OK":
    return
var farm: Variant = farm_script.new(catalog.crops)
var empty: Dictionary = farm.new_snapshot(1000.0)
var planted: Dictionary = farm.preview_command(empty, "plot_01", "plant", "radish", 0, 0)
expect(planted.status == "APPLIED", "plant candidate")
expect(empty.plots.plot_01.crop_id == "", "input never mutated")
var cared: Dictionary = farm.preview_command(planted.snapshot, "plot_01", "care", "", 1, 1)
expect(cared.snapshot.plots.plot_01.elapsed_seconds == 36.0, "care credit once")
expect(farm.preview_command(cared.snapshot, "plot_01", "care", "", 1, 2).status == "ALREADY_CARED", "duplicate care")
var grown: Dictionary = farm.advance_elapsed(cared.snapshot, 144.0)
expect(farm.phase(grown.plots.plot_01) == "MATURE", "mature at threshold")
var harvested: Dictionary = farm.preview_command(grown, "plot_01", "harvest", "", 1, 2)
expect(harvested.snapshot.last_harvest_crop == "radish", "basket matches crop")
expect(farm.phase(harvested.snapshot.plots.plot_01) == "EMPTY", "harvest clears plot")
var replanted: Dictionary = farm.preview_command(harvested.snapshot, "plot_01", "plant", "tomato", 1, 3)
expect(farm.preview_command(replanted.snapshot, "plot_01", "harvest", "", 1, 4).status == "STALE_COMMAND", "old generation rejected")
for bad in [-1.0, NAN, INF]:
    expect(farm.advance_elapsed(planted.snapshot, bad) == planted.snapshot, "bad elapsed unchanged")
var malformed: Dictionary = empty.duplicate(true)
malformed.revision = true
expect(not farm.validate_snapshot(malformed), "bool is not revision")
```

- [ ] 아래 로컬 runner에서 `test_island_farm_state.gd` 하나를 지정한다. 최초 script 미구현 FAIL과 exit!=0을 기록한다. 예상과 다른 engine/import 오류는 domain RED로 세지 않는다.
- [ ] `FarmState`에 역할 주석을 넣고 구현한다. `crops`는 생성자가 deep copy해 보유하는 검증된 카탈로그다. 성장 핵심은 다음과 같다.

```gdscript
func advance_elapsed(state: Dictionary, seconds: float) -> Dictionary:
    var next := state.duplicate(true)
    if not is_finite(seconds) or seconds < 0.0:
        return next
    for plot in next.plots.values():
        if not plot.crop_id.is_empty():
            plot.elapsed_seconds = minf(crops[plot.crop_id].growth_seconds, plot.elapsed_seconds + seconds)
    return next
```

`preview_command`는 입력 snapshot 검증→plot/action 검증→expected revision/generation 일치→상태별 조건→deep copy 수정 순서다. 실패 코드는 INVALID_STATE/INVALID_COMMAND/STALE_COMMAND/INVALID_CROP/INVALID_PHASE/ALREADY_CARED/COUNTER_LIMIT로 한정한다. EMPTY plant는 위 초기값, care는 elapsed+growth×ratio를 clamp하고 cared=true, mature harvest는 같은 사본에서 crop를 비우고 last_harvest_crop를 바꾼다. 모르는 action, plant 외 crop_id 입력, 빈 곳 care/harvest, 성장 중 plant/harvest는 거절한다. phase 경계는 해당 crop의 `young_threshold=t`를 읽어 [0,t), [t,1), 1이며 EMPTY 우선이다. 초기 t=0.25를 코드에 다시 고정하지 않는다. 테스트 전용 카탈로그에서 t=0.5인 무는 45초에 SEEDLING, 90초에 YOUNG라는 fixture를 추가하고 production catalog는 변경하지 않는다.

- [ ] 같은 검사를 PASS로 만들고 tomato 480초, 45초 phase 경계, 성숙 care 거절, 수정한 반환 사본이 원본을 바꾸지 않는 경우, 두 plot 독립성, 10년 경과 한 주기 상한을 assertion에 추가한다. catalog fixture는 schema JSON 숫자 1과 1.0 모두 OK, true/"1"/1.5/null/비유한 숫자는 INVALID_CATALOG를 요구한다. 각 fixture는 테스트의 격리 경로에 기록하며 ConfigFile snapshot에 float schema를 수용하는 근거로 쓰지 않는다.
- [ ] Task 1 파일만 commit한다. 메시지 `feat: add isolated island crop state`. 이 시점은 순수 MACHINE 증거만이다.

## Task 2. 기존 복구 저장을 섬 전용 파일에 연결

**Consumes:** `farm.validate_snapshot`, snapshot schema. **Produces:** IslandSaveStore API. 경로는 파일 표 Task 2다.

- [ ] 다음 선택 이식 원본을 다시 조회한다. `origin/codex/title-boat-flow-20260831`에서 `scripts/core/recoverable_config_store.gd`와 `tests/test_recoverable_config_store.gd` 두 파일만 비교·이식한다. 이번 관측 source는 `80ce184...`, 구체 blob은 구현 시 기록한다. 다른 owner·60개 commit은 병합하지 않는다. 기존 helper의 코드/테스트가 변경됐으면 해당 diff를 먼저 판정한다. **이식하는 helper 검사도** 고정 `user://test_recoverable_config_store`와 시작 시 전체 cleanup을 그대로 가져오지 않는다. PID+ticks 접미사의 새 격리 경로를 만들고 기존 경로가 있으면 삭제하지 않고 종료한다. 이번 실행의 생성 파일만 기록해 teardown한다. 다른 실행 경로에 sentinel을 남긴 병행 fixture의 hash가 불변인지 검사한다. 이 검증용 sentinel도 자기 격리 영역 안에서만 만들고 종료 시 정리한다.
- [ ] `tests/test_island_save_contract.gd`에 `user://test_island_p1_save_<PID>/farm.cfg`를 생성하고 생성 파일 경로를 배열로 기록한다. 모든 정상/실패 종료에서 이 테스트가 만든 경로만 teardown한다. production path는 사용하지 않는다.
- [ ] Task 2 runner로 최초 missing island store FAIL을 확인한 뒤, snapshot을 `[island] snapshot=<Dictionary>` 한 key에 넣는 adapter를 구현한다. `_encode`/`_decode`는 이 key와 FarmState validator만 사용한다.

```gdscript
func _encode(snapshot: Dictionary) -> ConfigFile:
    var cfg := ConfigFile.new()
    cfg.set_value("island", "snapshot", snapshot.duplicate(true))
    return cfg

func _valid(cfg: ConfigFile) -> bool:
    return cfg.has_section_key("island", "snapshot") and farm.validate_snapshot(cfg.get_value("island", "snapshot"))
```

`load_state/commit/recover` 모두 primary/last_good/pending 중 읽을 수 있는 island snapshot의 정수 schema가 1보다 크면 먼저 UNSUPPORTED_VERSION으로 종료한다. future version을 validator false→backup fallback으로 숨기지 않는다. 읽기 오류는 IO_ERROR, parse/shape 오류는 CORRUPT로 구분한다. 정상 backup만 있으면 RECOVERY_REQUIRED로 읽기용 snapshot을 반환할 수 있으나 쓰기는 잠근다. pending 또는 recovery.json이 있으면 ABSENT/OK로 편집을 허용하지 않는다. primary 부재+backup 부재+transaction 증거 부재인 경우만 ABSENT다.

`commit`은 위 preflight→snapshot validator→backend.write_validated 순서다. `recover`는 동일 future 보호 뒤 backend.recover_primary를 호출하고 **사용자의 명시적 복구 동작 외에는 호출하지 않는다**. backend의 receipt/해시/원본 archive를 우회하거나 .pending을 자동 삭제하지 않는다. 검증된 복구 뒤 Session은 다시 읽고 사용자가 행동을 재선택하게 한다.

- [ ] 아래 fixture를 실행하고 파일 bytes 및 directory 목록까지 비교한다. `seed`는 `_encode(snapshot).save(test_path)`, `store`는 주입 경로의 IslandSaveStore다.

```gdscript
var good: Dictionary = farm.new_snapshot(1000.0)
expect(store.commit(good).status == "COMMITTED", "first save")
expect(store.load_state().snapshot == good, "roundtrip")
var future := good.duplicate(true)
future.schema_version = 2
var cfg := ConfigFile.new()
cfg.set_value("island", "snapshot", future)
cfg.save(test_path)
var bytes := FileAccess.get_file_as_bytes(test_path)
expect(store.load_state().status == "UNSUPPORTED_VERSION", "future schema preserved")
expect(store.commit(good).status == "UNSUPPORTED_VERSION", "no downgrade write")
expect(store.recover().status == "UNSUPPORTED_VERSION", "no downgrade recovery")
expect(FileAccess.get_file_as_bytes(test_path) == bytes, "future bytes unchanged")
```

같은 저장 검사의 필수 fixture로 아래를 구현한다.

| fixture | assertion |
| --- | --- |
| 정상 구버전 backup+미래 schema primary | load/commit/recover 모두 UNSUPPORTED_VERSION, 두 파일 hash 불변 |
| 손상 primary+정상 backup | 읽기만 하면 원본 불변, RECOVERY_REQUIRED, 명시 recover 뒤 재로드해야 OK |
| 첫 save의 receipt 생성 뒤 `_save` 실패 | pending/receipt 보존, 재시작해도 편집 금지. 명시 복구로 ABSENT가 돼도 초기 snapshot을 자동 commit하지 않음 |
| `_copy`/`_replace`/readback/receipt 해제 실패 | 기존 FaultStore의 주입 지점을 사용해 NOT_COMMITTED/RECOVERY_REQUIRED와 정상본 또는 hash 포함 복구 근거 보존 확인 |
| NaN/음수/모르는 ID/plot 누락/미래 schema backup | 강제 변환해 수용하지 않고 거절, 호출 전후 원본 불변 |

- [ ] 복구 helper 검사와 섬 adapter 검사를 둘 다 PASS로 확인한다. 한국어 test role 설명을 유지한다. 기존 production 저장은 전후 해시만 비교하고 읽기/시험값 쓰기로 바꾸지 않는다.
- [ ] Task 2 파일만 commit한다. 메시지 `feat: isolate island save and recovery`.

## Task 3. 시간·lifecycle·행동 확정 Session

**Consumes:** FarmState와 IslandSaveStore의 위 API. **Produces:** Session API/signals. Scene child로만 구성하며 Node의 configure 이후 start를 명시 호출한다. P1에서 자동 `_process`·autoload 등록은 하지 않는다. P2 scene이 tick과 OS 알림을 연결한다.

- [ ] fake clock과 fake store를 `tests/test_island_session_contract.gd` 내부 class로 만든다. 실제 재부팅/시간 조작 없이 아래 API로 검사한다.

```gdscript
class FakeClock extends RefCounted:
    var utc := 1000.0
    var ticks := 0.0
    func utc_now() -> float: return utc
    func ticks_now() -> float: return ticks

class FakeStore extends RefCounted:
    var saved := {}
    var fail := false
    var writes := 0
    func load_state() -> Dictionary:
        return {"status": "ABSENT" if saved.is_empty() else "OK", "snapshot": saved.duplicate(true), "error": OK}
    func commit(value: Dictionary) -> Dictionary:
        writes += 1
        if fail: return {"status": "NOT_COMMITTED", "error": ERR_FILE_CANT_WRITE}
        saved = value.duplicate(true)
        return {"status": "COMMITTED", "error": OK}
    func recover() -> Dictionary:
        return {"status": "COMMITTED", "error": OK}
```

- [ ] 새 Session이 없는 상태에서 runner FAIL을 기록한 뒤 `working`(성장 중 관측값), `durable`(마지막 commit), `last_ticks`, `pause_utc`, `foreground`, `editable`, `busy`를 구현한다. 미저장 시간 변화는 revision을 올리지 않으며 action_committed도 발행하지 않는다.
- [ ] `start/retry_load`는 loader OK이면 max(0,UTC-saved_at)를 딱 한 번 working에 적용하고 ticks 기준을 새로 잡는다. ABSENT면 새 working을 만들되 파일은 쓰지 않는다. 그 외에는 editable=false; 쓸 수 있는 정상 snapshot이 없으면 빈 정상 게임으로 가장하지 않는다. signal은 반드시 deep copy다.
- [ ] `tick`은 editable+foreground일 때만 max(0,ticks-last_ticks)로 working 성장 후 ticks를 갱신한다. 활성 상태에서 UTC 이동은 성장 계산에 쓰지 않는다. 30초마다 flush를 한 번 호출하며 몰린 주기만큼 저장을 반복하지 않는다. 메뉴는 tick을 멈추지 않는다.
- [ ] `set_foreground(false)`의 최초 전환만 마지막 활성 경과 반영→현재 UTC pause anchor→flush→foreground=false 순서다. true는 pause에서의 UTC 차이를 한 번 적용하고 ticks 기준을 다시 잡는다. 앱 pause와 focus-out 중복, resume과 focus-in 중복은 무시한다. 비정상 clock(NaN/INF/음수 또는 ticks 역행)은 이번 변화 0 및 기준 재설정으로 처리하고 저장에 비유한 UTC를 쓰지 않는다. 유효한 UTC가 없으면 flush를 거절하고 편집을 잠근다.
- [ ] action은 tick의 시간 reconcile 후 아래 순서로 처리한다. 거리/입력은 P2에서 검사하지만 generation/revision/state는 이 계층에서도 확인한다. event callback이 재진입하면 busy일 때 BUSY를 반환하고 별도 명령 queue는 만들지 않는다.

```text
if not editable or not foreground -> reject LOCKED
if busy -> reject BUSY
busy=true
현재 monotonic 경과를 working에 적용
candidate=FarmState.preview_command(working, 전달한 6개 인자)
if status!=APPLIED -> busy=false; 후보 result 반환 (저장 없음)
candidate.snapshot.saved_at_utc=유효 UTC
result=store.commit(candidate.snapshot)
if result.status==COMMITTED:
    durable=candidate.snapshot deep copy
    working=durable deep copy
    state_changed(working deep copy)
    action_committed({status:COMMITTED, action, plot_id, revision})
else:
    working=durable deep copy; editable=false
    state_changed(working deep copy); storage_blocked(status)
busy=false
result 반환
```

첫 저장 실패로 durable이 아직 없으면 Session은 ABSENT 기반 초기 snapshot을 읽기용으로만 유지하며 편집/성공 이벤트를 금지한다. `flush`는 명령 revision을 늘리지 않고 동일 commit/failure 원칙을 사용한다. `retry_load`는 불확실한 디스크 상태를 다시 검증할 뿐 실패한 action을 재생하지 않는다. 저장 중단 receipt가 있으면 recover_storage의 명시적 복구가 먼저다. 모션 callback은 이 API를 호출할 권한이 없고 P2/P3 표시 종료만 담당한다.

- [ ] 아래 값을 assertion으로 고정한다. `session`은 new→configure(farm, store, clock.utc_now, clock.ticks_now) 후 start했고, signal count는 테스트의 정수 배열[0]을 lambda에서 증가시킨다.

```gdscript
session.request_action("plot_01", "plant", "radish", 0, 0)
clock.ticks = 10.0
clock.utc = 1010.0
session.tick()
session.set_foreground(false)
clock.utc = 1030.0
clock.ticks = 30.0
session.set_foreground(true)
session.set_foreground(true)
expect(session.snapshot().plots.plot_01.elapsed_seconds == 30.0, "resume counted once")
var prior: Dictionary = store.saved.duplicate(true)
store.fail = true
session.request_action("plot_01", "care", "", 1, 1)
expect(not session.can_edit(), "failure locks actions")
expect(store.saved == prior, "failed care never persisted")
expect(session.snapshot() == prior, "display returns to durable snapshot")
store.fail = false
session.retry_load()
expect(not session.snapshot().plots.plot_01.cared, "retry does not replay care")
```

- [ ] 두 Session을 순차 생성하는 재실행 검사에서 10년 offline→성숙만/바구니 변화0, 역행UTC→기존성장보존, 중복pause/resume→30초동일, menu활성→성장지속을 확인한다. save failure 전후 action_committed count가 변하지 않고, signal의 Dictionary를 수정해도 내부값이 불변인지 검사한다.
- [ ] Node/temporary RefCounted를 해제하고 격리 저장 정리까지 PASS 확인 후 commit한다. 메시지 `feat: connect island session clock and committed actions`.

## Task 4. 검사·인도 경로 연결

- [ ] `.github/workflows/godot-validation.yml`의 focused behavior contracts에 네 줄을 기존 status 누적 방식으로 추가한다. 기존 smoke/export/검사를 제거하거나 Node/Ubuntu 경고 교정을 섞지 않는다.

```bash
timeout 20s godot --headless --path . --script res://tests/test_recoverable_config_store.gd || status=1
timeout 20s godot --headless --path . --script res://tests/test_island_farm_state.gd || status=1
timeout 20s godot --headless --path . --script res://tests/test_island_save_contract.gd || status=1
timeout 20s godot --headless --path . --script res://tests/test_island_session_contract.gd || status=1
```

- [ ] README에는 같은 검사 명령과 'P1은 기술 기반이며 실행 첫 화면은 아직 구형 보트'를 기록한다. handoff에는 실제 파일/명령/결과·미실행·선별 재사용 source blob을 남긴다. 아래 명령은 **향후 구현 시 실행할 명령**이지 이번 계획 작성의 PASS가 아니다.

```powershell
$godotExe='C:/Users/user/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe'
& $godotExe --version
& $godotExe --headless --path . --import
if ($LASTEXITCODE -ne 0) { throw 'Import failed' }
foreach($scriptName in @('test_recoverable_config_store','test_island_farm_state','test_island_save_contract','test_island_session_contract')) {
    & $godotExe --headless --path . --script ('res://tests/'+$scriptName+'.gd')
    if ($LASTEXITCODE -ne 0) { throw ('Contract failed: '+$scriptName) }
}
& $godotExe --headless --path . --scene 'res://scenes/game.tscn' --quit-after 1
if ($LASTEXITCODE -ne 0) { throw 'Legacy scene regression' }
```

각 테스트는 기존 `expect/finish` 패턴으로 실패 시 exit 1, 성공 시 이름이 있는 PASS를 출력한다. 최초 RED는 각 Task의 해당 script 하나만 실행한다. 20초 timeout은 CI 보호이며 로컬 장기 실행이 발생하면 해당 task-owned process만 중단·조사한다. 기존 사용자의 Godot/editor는 종료하지 않는다.

- [ ] 기존 Python 9개, 전체 기존 CI와 위 새 검사, production save 전후 해시, 격리 test 잔여/소유 프로세스 상태를 확인한다. 코어 저장 손상·다른 세이브 변경·영구 입력 잠금이면 중단한다. 실패를 skip으로 바꾸지 않는다.
- [ ] 기존 승인 예산을 유지한 영향 검사·독립 병합 검토→정확한 HEAD CI→정상 동일 작업 PR→main readback→기존 월간 PDF 요약 누적을 수행한다. snapshot/코드만으로 새 섬 화면·Human 완료를 보고하지 않는다.

## 자산 준비와 P2 이후의 연결

P1은 이미지·모델·음향을 입력으로 소비하지 않는다. 아트가 없다는 이유로 P1의 순수 상태 검사를 가짜 이미지로 대체하지 않는다. 이번 계획 검토와 제품 Blueprint/자산 gate는 구분하고, 승인된 독립 작업만 진행한다.

1. visual inventory IV01–IV07 기준으로 섬/농장/캐릭터/바다가 함께 보이는 **아트 방향 후보 한 개**를 준비한다. 그 후보의 용도는 구도·비율·재질 일치 검토이며 단일 이미지로 최종 3D 자산을 대체하지 않는다.
2. 사용자 LOCK 뒤 지형·해안·하늘·구름·작물·플레이어 rig를 별도 실제 소비 파일로 만든다. 크로마키 제거는 독립 raster 요소에만 적용하고 3D mesh에는 적용하지 않는다. 이전 보트/캐릭터 승인 자료는 자동 재승인하지 않는다.
3. P2 scene은 Session의 snapshot/request_action만 소비한다. 사용자의 이동 위치가 보행 가능한지 Scene이 확인하고 set_player_pose로 넘긴다. UI나 animation이 파일을 직접 쓰지 않는다. P3는 승인 상태군/8개 clip/OceanBed를 연결한다.
4. P4는 농사를 전혀 안 하는 경로와 한 번 돌보고 쉬는 경로를 모두 내부 빌드로 검증한다. Human은 사용자 선언 시 진행한다. 그 뒤 배 나들이의 조작·출항/귀환·저장 경계를 별도 구체화한다.

## 근거·현재 증거와 되돌리기

2026-09-20 실제 main의 GameState `_ready`/voyage 함수, 기존 SceneTree 저장 검사와 CI, continuation의 RecoverableConfigStore 전문/주요 fault test를 읽었다. helper는 main에 아직 없으며 이번 턴에서 복사하지 않았다. [Godot Time](https://docs.godotengine.org/en/stable/classes/class_time.html)의 monotonic/시스템 시각 구분, [ConfigFile](https://docs.godotengine.org/en/stable/classes/class_configfile.html)의 load/save/Variant 구조, [MainLoop](https://docs.godotengine.org/en/stable/classes/class_mainloop.html)의 lifecycle 알림, [JSON](https://docs.godotengine.org/en/stable/classes/class_json.html)의 숫자 파싱 경계를 재확인했다. engine pin 변경 근거로 쓰지 않는다. 이전 12게임 조사와 §5–6 규칙은 유효한 기존 근거로 재사용하며 새 시장조사를 했다고 보고하지 않는다.

계획의 범위 밖인 P2 화면 입력, 지형/카메라, 리그·최종 아트, Human·기기 성능은 각각 후속 패키지다. P1 계획은 전체 게임 구현 명세를 대신하지 않는다. 이번 변경은 문서만 되돌릴 수 있으며 실행 전에도 기존 source/자산/세이브에 영향이 없다. 구현 rollback은 P1의 새 소비 연결/파일을 해당 PR 단위로 되돌리고, 사용자 저장이 생겼다면 파일을 삭제하거나 구형 포맷으로 덮지 않는다.
