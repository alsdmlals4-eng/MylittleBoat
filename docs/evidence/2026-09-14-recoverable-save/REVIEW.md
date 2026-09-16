# R07 저장 보호 구현 기록

## 범위와 현재 상태

사용자 2026-09-14 `좋아 권장안대로 작업진행해`로 R01–R12 실행을 승인했다. 시작 source는 `1b7188ff3c50d1068e17cc4851e6339b7e89307e`, 현재 작업 branch는 `codex/title-boat-flow-20260831`다. 다른 작업 PR #19는 read-only로 유지한다. Base remote `d830c0f6967678eed3c208ac6b24f9cd1b262ec3`를 확인했고 프로젝트 v9.4.4 adapter는 교체하지 않았다.

R07은 helper+첫 저장 owner → 나머지 owner → 상태/UI/사진 경계 순서로 나누어 검증한다. R07a helper+comfort는 `6e50ad0`, `3724c67`, `4773c68`에 구현·교정됐고 아래 기계 검증을 통과했다. 전체 R07 완료는 아니다. R01의 수면 texture와 sky는 FINAL_PENDING, 실제 근거리 model 파일은 자산 경로 조사에서 확인되지 않았다. 기존 화면은 변경하지 않았다.

## 작업 전 문제와 조사

- `ComfortPreferences`는 손상된 parse 입력의 덮어쓰기는 막지만 정상본/중단 복구가 없다.
- `CosmeticIdentityProfile`, `BoatDecorPersistence`, `TogetherTimePersistence`, `AmbientMemoryPersistence`, `MemoryLedgerPersistence`는 직접 ConfigFile.save를 사용한다. 대부분 GameState에서 성공 여부와 확정을 분리하지 않는다.
- `PhotoMemoryPersistence`는 손상 목록과 새 사진 저장 일부 실패를 보호하지만 전체 파일 교체 복구 및 앨범 경로 validator는 없다.
- 프로젝트 코드와 채택된 Base module manifest에 같은 책임의 실제 저장 helper consumer가 없다. Base에서 검색된 task/session recovery는 게임 save transaction과 책임이 다르므로 가져오지 않는다.

| 대안 | 판단 | 현재 프로젝트 적합성 |
|---|---|---|
| 직접 cfg 덮어쓰기 유지 | REJECT | 간단하지만 write 중단 뒤 정상본이 없고 owner별 실패 누락 반복 |
| 기존 cfg/schema + staging·검증 정상본·명시 복구 | ADAPT | 기존 파일·ID·owner 유지, 공통 파일 처리만 추출. fault test 가능 |
| SQLite 등 transaction 저장소 전환 | REJECT_THIS_SCOPE | 별도 migration·dependency·기존 자료 변환 비용. 현재 소규모 로컬 cfg에 불필요 |

[Godot ConfigFile](https://docs.godotengine.org/en/stable/classes/class_configfile.html)은 load/save Error를 제공하며 save는 기존 파일을 덮어쓴다. 알려지지 않은 section/key 값은 owner가 보존하고, 성공 저장 때 주석/서식이 다시 직렬화되는 것과 장애 복구용 원본 bytes 보존은 구별한다.

[Godot FileAccess](https://docs.godotengine.org/en/stable/classes/class_fileaccess.html)의 flush/close와 [DirAccess](https://docs.godotengine.org/en/stable/classes/class_diraccess.html)의 파일 연산을 사용하되 전원차단 내성이나 OS 전체 atomicity를 추정하지 않는다. [SQLite의 atomic commit 설명](https://www.sqlite.org/atomiccommit.html)에서는 원본 보존·저장 순서·실패 가정을 비교 참고했다. SQLite의 보장을 이 ConfigFile 구현이 가진다고 주장하지 않는다.

## 검증 상태

- 착수 전 Python 검사 20개 PASS.
- 최초 helper 부재와 comfort 결과 API 부재를 각각 명시 assertion RED로 확인한 뒤 GREEN.
- `4773c68` 최종 headless 집합은 `test_*.gd` 전체 64개 중 display-only `test_chibi_normal_chroma_material_proof.gd` 하나를 제외한 63개다. 작성자가 순차 실행하며 각 exit와 SCRIPT ERROR/ERROR/WARNING을 검사한 결과 `FINAL_HEADLESS total=63 failed=0`, exit 0. UI/scene consumer를 포함한 엔진 자동 검사이며 GPU/플레이 검증이 아니다.
- parent 독립 focused 실행에서 helper PASS, comfort PASS, `OCEAN_VOLUME_FAILURES=0`. 마지막 Python `Ran 20 tests / OK`, 문서 상대 링크 및 `git diff --check` PASS.
- Device / Human / 전원차단 / 공개 배포는 NOT_RUN.

## 구현·반례 검토·교정 증거

실행 파일은 `C:/Users/user/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe`, 실제 version `4.7.2.stable.official.ed1daf0bf`다. focused 명령은 `--headless --path . --script res://tests/test_recoverable_config_store.gd` 및 `tests/test_comfort_preferences.gd`, 음량 소비 회귀는 `tests/test_ocean_volume_contract.gd`다. parser 오류는 기능 RED로 세지 않았다.

| 검토 상태 | 실제 읽기·실험·finding 및 교정 | 회귀·대안·기존 소비처 |
|---|---|---|
| 기본 구현 `6e50ad0` 전 | AGENTS/brief/GDD/plan/helper/comfort/두 test/cleanup owner 전체를 다섯 차례 읽고 매회 helper+comfort 실행. schema/중단/rollback/부재/소비 경계를 각각 대조 | 매회 다른 7개 저장/state owner diff 0. unknown key 보존 및 정상 10회 저장의 파일 수 2개 확인. 새 DB 대신 기존 cfg 유지 |
| 복구 승자 교정 | schema-valid 미확정 primary를 복구 정상본으로 채택하는 반례 RED, original_hash 기준 복구로 GREEN | 새 instance도 마지막 committed 값과 잠금 유지. 단순 parser 성공을 commit으로 해석하지 않음 |
| receipt 검증 교정 | original_absent 문자열이 삭제 권한으로 소비되던 반례 RED 2건 → 엄격 type/hash 검사 GREEN | 손상된 증거로 원본 제거 금지. 확인 불가 상태는 RECOVERY_REQUIRED |
| 읽기 격리 `3724c67` | 실제 GameState._ready와 테스트 진입 대조, read 전후 디렉터리 목록 변화 RED → read-only 교정 GREEN. 전체 63개 PASS 후 기존 다섯 관점 재독해/focused 검사 | archive는 저장·복구 요청에서만 수행. 정상 게임 초기 읽기와 테스트 초기 읽기의 부수효과 방지 |
| 독립 검토 `3724c67` | 별도 reviewer가 범위 diff와 실제 음량 consumer를 읽고 최초 pending 실패 뒤 영구 잠금 Important 발견 | 먼저 partial/full stage failure × 기존 원본 유무 4조합 테스트 추가. 잘못된 최초 부재 추정 대안은 거부 |
| 최초 저장 교정 `4773c68` | 위 테스트 RED 4 failures → 의도 기록을 staging 앞으로 이동 → helper/comfort GREEN. 별도 scoped re-review에서 finding ADDRESSED, 새 Critical/Important 없음 | parent가 최종 scope/API/fault body와 변경 diff 재독해하고 63개 전체 회귀 PASS. unknown orphan pending은 추정 복구하지 않음 |

초기 다섯 회의 source hash는 helper `2E77C649FA3985FAB4710D02CA3EC97DFC0F755D882974C1C2963413B33DDB6C`, comfort `B4B79E09353350359EFD65494400E43C44ED8B79FEE512488E935B3414AA2C90`다. 읽기 교정 후 다섯 회는 helper `72C888B18F20FCD7F0BFF45678E984D74C856F4FDD233A597F1C4A148D234602`, comfort `50AAEF48CA46DBE80CFB84DF8B11E0EB3A19348DC9A8EA02D5866C73A7A8C307` 상태다. 이 역사적 반복을 마지막 교정까지 포함한 동일-head 검사로 소급하지 않는다. 마지막 교정의 증거는 `4773c68` scoped re-review와 최종 63개 회귀다. 횟수를 게임 완성률로 보고하지 않는다.

fault test는 실제 격리 파일과 테스트 subclass의 파일 연산 실패를 사용한다. pending write/readback, backup copy/hash, receipt write, 교체 후 readback, rollback copy, unlock 제거, 원래 부재 복원 실패를 다룬다. OS 프로세스를 강제 종료하거나 실제 전원을 끊은 실험은 아니다. 단일 앱 동기 호출 직렬화이며 여러 앱 process 간 lock 보장은 없다.

## 사용 예와 현재 한계

기존 쉬는 메뉴에서 음량·움직임 설정을 바꾸면 comfort owner가 새 store를 소비한다. 정상 변경은 새 값 검증 뒤 성공하며 직전 정상본만 유지한다. 손상/복구 불확실 때는 영구 쓰기를 거부해도 이번 실행의 음소거는 허용한다. 엔진의 `ComfortPreferences.recover_primary()`가 명시 복구 진입점이고, 이를 플레이어에게 제공하는 복구 UI는 다음 단위다. 새 버튼이 이미 구현된 것으로 표현하지 않는다.

수면·카메라·모델·신규 이미지와 다른 persistence owner는 이번 R07a commit에서 미변경이다. 따라서 새 이동감/GPU 화면 캡처는 만들지 않았다. rollback은 해당 코드 commit의 정상 revert 경로이며 사용자 save/backup/recovery 파일을 삭제하지 않는다.

## 남은 작업과 학습 경계

파일 API 성공과 내용 검증 성공, rollback 성공과 RECOVERY_REQUIRED를 구별한다. 검증된 정상본은 임시 폐기 대상이 아니다. 테스트는 자기 격리 경로의 파생 파일까지 정리해야 한다. 공용화는 여러 owner 적용과 반례 검증 후 후보로 평가하며 Base를 지금 수정하지 않는다.

후속 owner 적용 전 실제 소비 경로 점검 결과를 다음 작업에 연결한다.

| owner / 현재 consumer | 필요한 연결 |
|---|---|
| comfort / GameState 및 쉬는 메뉴 | session-only mute/움직임 저감 유지. 영구 저장 성공과 복구 필요 안내 분리 |
| identity, decor / GameState·꾸미기 | 선택을 먼저 state에 쓰는 현재 경로를 R06의 draft+COMMITTED 확정으로 교정 |
| together time / flush_together_time | 저장 실패 시 unsaved 시간을 성공처럼 0으로 지우지 않기. active time 자체를 보상 재시도와 섞지 않기 |
| ambient memory / record_ambient_memory | 현재 append 후 저장이므로 COMMITTED 이전 durable collection 확정 금지 |
| memory ledger / 낚시·항해 기록 | 기존 row/unknown key 보존. 저장 실패와 게임 실패는 별개이며 무손실 재시도 계약 필요 |
| photo / album_view | 목록 commit 불확실 상태에서 새 PNG를 지우지 않기. 검증 경로만 열고 깨진 metadata 자체는 보존 |

정상 저장마다 모든 이전 정상본을 영구 사본으로 쌓는 방식은 채택하지 않는다. 평상시에는 rolling last_good 하나와 현재 파일로 제한하고, 실제 중단/손상 때에만 복구 증거를 보존하도록 검사한다. 저장 안전성 강화가 평상시 저장 공간 누적으로 이어지지 않게 한다.

읽기 책임 교정. 실제 `GameState._ready`는 테스트의 저장 경로 격리보다 먼저 기본 comfort를 읽는다. 따라서 `read_validated`는 디스크를 변경하지 않고 상태·검증된 읽기 결과만 반환해야 한다. archive/receipt는 실제 쓰기 또는 명시 복구 때만 만든다. 읽기 단계에서 손상 파일을 발견해도 원본은 그대로이며, 후속 쓰기 거부 조건은 유지한다.

최종 hygiene 반례. 63개 테스트가 통과해도 parent의 실제 파일 열거에서 동적 경로 4개의 sidecar 8개가 남았다. 대상은 `test_motion_continuity_comfort.cfg`, `test_overlay_comfort.cfg`, `test_route_comfort.cfg`, `test_stern_motion_comfort.cfg` 각각 `.last_good`/`.recovery.json`이다. 해당 fixture가 primary만 제거하는 consumer를 실제로 확인했다. 따라서 초기 7개 fixture만으로 cleanup 전체 PASS를 주장하지 않는다. 네 테스트의 setup/teardown과 실제 파일 부재 재확인을 추가하며 production 파일/다른 workstream은 대상 밖이다.

`70f2e07`에서 네 동적 fixture의 setup/teardown을 exact cfg 공통 helper로 교정했다. 해당 네 Godot 명령의 결과는 `MOTION_CONTINUITY_FAILURES=0`, `OVERLAY_CONTINUITY_FAILURES=0`, `ROUTE_CONTINUITY_FAILURES=0`, `STERN_MOTION_FAILURES=0`이며 각 exit 0이다. 여덟 경로 전부 ABSENT, `NAMED_SIDECARS_REMAINING=0`. 이는 테스트 자체 teardown으로 제거한 파일이며 사용자 삭제 대기 대상이 아니다. production은 `4773c68`과 동일하므로 63개 전체 production 회귀와 이 tests-only 변경의 네 focused 검증을 구분한다.

최종 scoped hygiene review는 spec PASS/quality APPROVED, 신규 finding 없음이다. parent가 여덟 경로 부재와 `git diff --quiet 4773c68..HEAD -- scripts scenes assets project.godot`의 무변경을 재확인했다. 마지막 Python 20개와 문서 형식 검사도 통과했다. 전체 R01–R12 branch/main merge review나 출시 승인이 아니라 R07a의 검토 결과다.

생산 설정은 내용을 읽지 않고 파일 metadata만 확인했다. 정확한 comfort primary 하나(30 bytes, lastWriteTimeUtc `2026-09-10 13:10:44`)만 있었으며 해당 production 파생 sidecar는 없었다. 읽기 교정 전 부수 파일 생성의 역사적 절대 부재까지 추정하지 않는다.

## R07b1 — 다섯 단순 owner 연결

기준 `b828f78`, 구현 `b07f8b8`, 우선순위 교정 `6f6f716`, 공통 읽기 분기 추출 `02e5a256`. `boat_decor_persistence`, `cosmetic_identity_profile`, `together_time_persistence`, `ambient_memory_persistence`, `memory_ledger_persistence`가 같은 공통 store를 소비한다. 기존 signature/key/normalizer를 유지하며 COMMITTED만 OK, 각 owner의 status/recover API를 제공한다. GameState/UI/photo/comfort production 변경은 이 범위 밖이다. 독립 검토에서 지적된 중복을 교정한 뒤 scoped spec PASS/quality Approved, 남은 finding 없음이다.

현재 미지원 identity ID는 strict validator에서 지원 불가를 포함한 CORRUPT로 분류하고 caller의 기존 fallback은 읽기로만 유지한다. decor는 임의 String dictionary라는 기존 저장 domain을 유지하되 unknown slot/item/appearance가 있는 원본의 전체 교체는 ERR_UNAVAILABLE/NOT_COMMITTED로 거부한다. 원본을 지우거나 일부 변경을 성공으로 반환하지 않는다. 미해결 pending/receipt가 함께 있으면 RECOVERY_REQUIRED가 우선한다. 이 우선순위는 실제 RED 2건 뒤 교정했으며 helper를 우회하는 별도 lock 판별을 복제하지 않았다.

| 검증 | source·결과와 한계 |
|---|---|
| TDD 기본 연결 | 최초 backup/API 부재 RED 10 → focused GREEN. future decor 보존 RED 2 → guard GREEN |
| owner 회귀 | 기존 다섯 owner와 신규 `test_simple_owner_recovery.gd`의 정상/손상/복구/unknown/secondary key/NaN·Inf/쓰기 실패 검사 통과 |
| 전체 headless | b07f8b8 code의 전체 65개 중 display-only 1개 제외, 64개 exit 0 / failed 0. 전용 사용자 저장 공간에서 실행 |
| 마지막 교정 | 6f6f716의 pending/receipt+unsupported 조합 RED 2 → SIMPLE_OWNER_RECOVERY_FAILURES=0. 전체 suite 중복 실행이 아닌 해당 범위 재검증 |
| capture 정리 | 수정한 capture/probe 10개 `--check-only` 통과. 실제 GPU 캡처를 새로 했다는 뜻이 아님 |
| 부모 문서 검사 | 작업 중 count 갱신 이전 Python20은 2개 실패, count 동기화 후 재실행 20개 통과. 중간 실패를 최종 성공으로 소급하지 않음 |
| 원본 보호 | 원본 project.godot SHA256 `C59566A16130C7629EC897EE9399420753F1391ABD8875C430D49BDDB5A0770A` 동일. 구현자가 실제 사용자 파일 8개의 이름/크기/hash 전후 일치 확인, 내용 미출력. 격리 test_* 잔여 0 |

다섯 실제 scoped 검토는 baseline/RED→wrapper, future-ID 보존, 기존 fixture teardown, secondary-field/실제 staging failure, 최종 전체 consumer+격리 실행 순서로 수행했다. 각 단계에서 GDD R07·다섯 owner·helper/comfort·관련 fixture를 재독해했고, 원본 경로와 untouched GameState/UI/photo를 대조했다. 상세 command/output/source blob은 작업 보고서에 보존하며 이 표만으로 전체 게임 5회 검증을 주장하지 않는다. 정상 overwrite 유지/새 DB보다 기존 helper 재사용을 채택하고, unknown row silent merge 대신 명시 저장 거부를 선택했다.

외부 active QA project는 `C:/Users/user/AppData/Local/Temp/MyLittleBoat-r07b1-3fd622b196824aaca3c9e30075f23483`다. project.godot 사본에 custom user-dir만 추가했고 실제 probe 출력은 `C:/Users/user/AppData/Roaming/MyLittleBoat_test_r07b1_3fd622b196824aaca3c9e30075f23483`였다. 원본 source directories는 junction, 다른 root files는 hard link이므로 그 경로에서 원본을 편집하거나 root를 재귀삭제하면 안 된다. 후속 검증 consumer로 보존하며 사용자 삭제대기 산출물과 구분한다. 원본 사용자 저장 경로에서 직접 실행한 검증은 아니다.

### 부모 설계·조사 재대조

1. branch/main/PR 및 Base adapter를 재조회했다. origin/main `7181d5e`, 현재 branch는 이 시작점에서 44 commits 앞섰다. 열린 PR19는 read-only, Base remote `d830c0f`는 드리프트 입력이고 v9.4.4를 유지했다.
2. 기존 GDD R01/R07/B1–B4, 실제 route/water/fishing/GameState/Album 소비처를 대조했다. 같은 GameScene album overlay가 이미 있는데 W3가 미구현처럼 표현되어 이를 현재 회귀 위험으로 교정했다.
3. DREDGE 제작진의 파도/이동 분리, Apple의 모바일 재설계 발표, Lake 접근성, Tiny Glade 제작진의 요소별 파이프라인을 재독해했다. GDD에 채택/변형/제외·consumer·검증 한계를 연결했다. 인터뷰에 없는 알고리즘이나 측정 전 최적 성능을 추정하지 않았다.
4. GameState의 선반영/성공 문구와 startup decor 재저장을 읽고 후속 R07b3에 성공 후 확정·읽기 무쓰기·미저장 시간·입질 보존을 명세했다. 사진의 무제한 임의 경로 디코드보다 owner 경계·유한 상한을 선택하고 R07b2로 분리했다.
5. 수정 GDD/계획/현재 handoff를 재대조하고 `git diff --check` 및 Python20을 확인했다. 실제 파일이 없는 모델·후보 final lock·GPU/Device/Human/출시를 완료로 높이지 않았다. actor와 별도 reviewer의 source 검토는 독립 gate다.

이 단계의 학습은 같은 파일 처리 helper를 실제 여섯 owner가 소비하도록 넓혔다는 점과 fixture setup만으로 사용자 저장 격리가 보장되지 않는다는 점이다. Base 승격은 아직 하지 않았고 별도 범용 framework를 추가하지 않았다. 뒤이어 사진 저장/경로→실제 GameState·복구 UI→draft/사진 상세를 구현한다. 모델 납품·세계 수면·카메라 통합과 R11/R12는 그대로 남아 있다.

독립 검토 round 1은 다섯 owner에 반복된 읽기 전용 legacy fallback 정책을 Important로 지적했다. `02e5a256`에서 기존 helper의 `config_for_legacy_read` 하나로 추출했고 strict read/write/recover 본문과 owner validator/normalizer는 유지했다. owner 통합+기존 다섯 owner+comfort+store 총 8개 focused 계약을 추출 전후에 실행해 각각 exit 0 / 오류 패턴 없음. scoped 재검토는 ADDRESSED/새 breakage 없음이었다. 부모는 같은 head의 격리 game Scene `--quit-after 1` exit 0과 Python20 PASS를 확인했다. 기존 전체64 결과와 마지막 focused8/Scene smoke를 분리하며 최종 head 전체64를 다시 실행했다고 쓰지 않는다.

## R07b2 — 사진 저장과 실제 앨범 읽기

시작 기준 `472017a`, 구현 `854fdce`, 미지원 플랫폼 guard 교정 `817cd65`. 사용량 제한으로 중단된 이전 worker의 의도된 변경을 보존해 이어갔다. 사진 목록은 기존 `RecoverableConfigStore`, PNG·중단 의도는 사진 owner가 책임진다. 추가 DB·전역 오류 억제·원본 resize를 만들지 않았다. raw metadata path를 직접 열던 Album은 `GameState.load_photo_image → PhotoMemoryPersistence`로 연결된다. 미확정 PNG는 원본/PNG 해시와 사진별 receipt를 남겨 보존한다. 정상 commit 후 불필요한 receipt는 남기지 않는다.

| 검증 층 | 이번 실제 결과와 한계 |
|---|---|
| 저장·읽기 | unknown section/key/추가 row fields 보존, 손상 primary/backup, 명시 복구, 확정·미확정 쓰기 실패, PNG와 receipt 보존 확인 |
| 크기 반례 교정 | 4097×1 입력의 저장 성공/읽기 실패를 RED로 재현. 같은 축4096/총16,777,216pixels/압축32MiB 상한으로 저장도 거부한 뒤 GREEN |
| 경로 | basename/ID/외부 절대경로/prefix sibling/상위경로/역슬래시 거부. Windows 실제 junction 감지와 읽기·쓰기 차단, test-owned teardown 확인 |
| 전체 자동 검사 | `854fdce` 코드에서 전체66 중 display-only1 제외 headless65 실행, 모든 exit0/FAILED_COUNT=0. [전체 로그](photo-runtime/MyLittleBoat-r07b2-full-headless-20260914-final.log) |
| 마지막 guard | `817cd65`의 미지원 검사 seam RED7→GREEN. recovery/persistence/state/Album memory/Album composition focused5 exit0 및 post-commit recovery failures0. 마지막 head 전체65 재실행 주장은 하지 않음 |
| 손상 압축 입력 | CRC 정상·압축 스트림 손상에서 예상 libpng/Godot 진단, null/error, 원본 byte 보존. [별도 음성 검사](photo-runtime/MyLittleBoat-r07b2-malformed-deflate-20260914.log). 일반 실행 오류0과 혼합하지 않음 |
| GPU fixture | Windows RTX3050/OpenGL3.3 Compatibility/Godot4.7.2의 실제 Album texture 정상 연결·위조 path unavailable. 초기 오디오 종료 누수는 test teardown의 기존 soundscape release로 교정. [교정 뒤 로그](photo-runtime/MyLittleBoat-r07b2-gpu-album-20260914.log). 초기 경고는 tool output에만 남았으며 최신 로그를 초기 실패 증거로 쓰지 않음 |
| 실제 게임 촬영 | `854fdce`, 2026-09-14 22:55:51 KST. 격리 game Scene의 실제 촬영 버튼 → 사진1장 commit → 같은 항해 Album overlay. [촬영 원본](photo-runtime/voyage-photo.png), [앨범 화면](photo-runtime/album-photo.png), [실행 로그](photo-runtime/runtime.log). REAL_PHOTO_CAPTURE_FAILURES=0 |
| 비용 표본 | 단색540×960 3장19.370ms와 실제 게임 사진1장(567,869bytes)을 3회 읽은136.498ms는 서로 다른 표본. 이 머신의 일회 측정이며 모바일/모든 앨범 크기/UX 상한 검증이 아님 |
| 부모 연결 검사 | CI coverage count 드리프트 RED2→66/65 동기화→GREEN2. Godot를 실행하지 않는 Python19 중18PASS/1SKIP(선택적 기존 PDF geometry inspector 없음). 새 증빙 PDF 렌더 검수와 별개 |

부모가 실제 읽은 외부 로그·화면 hash를 복사본과 대조했다. 전체 로그 SHA256 `720671ebfc10b4f0d91bf070ea57fe7722e822ecda2685c057156abee667fbdb`, GPU 로그 `b50ba2821b598a634f87c823664f2c84a2b2df319843bb84c82270b5f698a588`, 손상 입력 로그 `7501f6676e6287663cd53afad020f8abf933a71e13bbdf6d529df148e49bf18e`. 실제 촬영 PNG SHA256 `22b41da1707542fe3b0565a1f21a1adcd2016ce3b653bbbfbae0b6f2b7956244`. `photo-runtime/.gdignore`는 문서용 증거의 엔진 import만 막으며 게임 자산 consumer를 변경하지 않는다.

검토 순서는 ①현재 owner/consumer·격리 경계 ②저장 원본/복구·opaque 데이터 ③경로/실제 junction·손상 PNG ④저장/읽기 크기 불일치 반례 교정 ⑤실제 Album GPU·종료 정리·전체 회귀였다. 각 단계에서 관련 범위를 다시 읽고 untouched 항해/기록/아트/표시 전용 검사를 구분했다. 상세 command와 검토 내용은 active 작업 보고서에 유지한다. 독립 검토는 미지원 플랫폼 추정을 Important로 지적했고 `817cd65`로 교정, scoped 재검토에서 ADDRESSED/신규 Critical·Important 없음으로 확인됐다. 긴 stateful 테스트 분리는 Minor로 최종 branch review에 전달하며 지금 기능 완료의 대체 증거로 쓰지 않는다.

플랫폼 제한. [Godot 공식 DirAccess](https://docs.godotengine.org/en/stable/classes/class_diraccess.html)는 `is_link` 구현을 Windows/Linux/macOS로 명시한다. Windows junction은 실제 실행했고 Linux/macOS는 이 작업에서 문서 근거만 있다. Android/iOS/unknown은 현재 사진 경로·새 저장을 거부한다. 모바일용 안전 경로 소비처를 실제 검증하기 전 모바일 사진 기능 완료로 표시하지 않는다. OS의 악의적 동시 바꿔치기 완전 방어, 전원 차단 보장, Human/실기기/출시는 미검증이다.

학습·후속. 저장 성공 입력은 같은 owner가 다시 읽을 수 있는 범위 안이어야 한다. 단색 이미지의 비용을 실제 화면 디코드 성능으로 대표시키지 않는다. 차단된 filesystem 명령의 다른 도구 우회를 재사용 방법으로 승격하지 않는다. 테스트가 생성한 정확한 fixture teardown만 별도 계약으로 관리한다. 프로젝트 테스트로 고정했으며 Base 승격은 아직 하지 않았다. R07b3 성공 후 state 확정/복구 UI, R06 적용·취소, R08 사진 상세와 세계 수면·모델 작업은 그대로 남았다.

## R07b3 — 저장 성공 확정과 쉬는 메뉴 복구

**2026-09-16 마감 갱신.** 보트 후속 작업은 사용자 방향 변경으로 중단했다. 아래 fix round1 진행 중 표기는 당시 기록이다. `920db8f`에서 네 Important를 교정했고 관련9개·GPU 증거는 `state-round1/`에 보존한다. `48f98fc`는 테스트 종료 후 함께한 시간 fixture가 다시 생성되는 순서를 교정했다. 9월16일 부모 직접 같은 save-success 계약 실행 PASS, 의도된 손상 parse10건, 종료 뒤 `test_r07b3*` 잔존0을 재확인했다. 전체66를 이 head에서 부모가 재실행한 것은 아니다. **정상 백업 부재와 복구 뒤 저장 실패의 사용자 안내 구분은 Important 미해결**로 보존한다. 새 섬 게임에서 재사용 전 교정해야 하며 R07 전체 clean exit/출시 완료를 주장하지 않는다.

구현 기준 `cf7860d`, 구현 `e67872b`, 캡처 종료 정리 교정 `8041b6c`. 최신 사용자 재개 후 같은 작업의 미커밋 변경을 보존해 이어갔다. 독립 검토는 네 Important를 발견해 fix round1을 진행 중이며 R07b3/전체 R07/게임 완료를 선언하지 않는다.

외형·장식·풍경·물고기·항해 기록은 실제 owner commit 뒤에만 GameState를 확정한다. 실패한 항해 기록은 같은 summary 하나를 유지하고, 물고기는 저장 성공 전 ready 후보를 소비하지 않는다. 함께한 시간은 미저장 누적과 저장 시도 간격을 분리한다. 꾸미기 표시 readback은 저장을 수행하지 않는다. 정상 저장 상태에는 복구 버튼을 숨기고, 문제 owner만 쉬는 메뉴에서 복구/재시도한다. 복구 뒤 외형과 장식의 실제 표시도 동기화한다. comfort는 현재 live motion/volume을 유지하고 두 값을 기존 unknown key와 함께 재시도한다.

| 검증 층 | 확인 결과와 증거 범위 |
|---|---|
| 구현자 전체 회귀 | 67개 발견 중 display-only1 제외66 exit0 보고. 정렬한 연속 batch의 raw 출력은 구현자 tool history에만 있으며 이 문서에 가짜 합성 로그를 만들지 않음. display-only는 별도 Windows Mobile renderer PASS 보고 |
| 부모 직접 검사 | `8041b6c`에서 격리 QA project로 `--headless --script res://tests/test_save_success_state_contract.gd` 실행, exit0/PASS. [원본 로그](state-runtime/parent-state-headless.log). 의도한 손상 cfg의 parse 진단4건과 정상 실행 오류를 구분 |
| 복구 GPU | Godot4.7.2/Vulkan Forward Mobile/RTX3050/540×960. 실제 game Scene 쉬는 메뉴의 버튼 신호→owner 복구→성공 안내. [복구 전](state-runtime/storage_recovery_required.png), [복구 후](state-runtime/storage_recovery_committed.png), [실행 로그](state-runtime/gpu-runtime.log). physical touch/Human 입력 증거는 아님 |
| 경고 교정 | 이전 v3의 종료 ObjectDB 경고는 tool stdout에만 있었음. 캡처에서 scene 해제·프레임 대기·기존 soundscape shutdown을 수행한 v4는 경고0 보고. 부모가 읽은 v4 raw log에는 의도한 corruption parse2건만 있으며 이를 일반 오류0으로 표기하지 않음 |
| 문서·격리 | 부모 Python19 중18PASS/1SKIP. 추가 test count의65→66 불일치 교정 확인. 부모 직접 test 후 QA user dir의 test_* 잔존0. 다른 프로젝트 editor/production saves는 사용하지 않음 |

증거 사본4개는 부모가 원본과 SHA256 대조 후 복사했다. GPU log `d772a8b585c2cb722614e5fc3499cd9711f09750e3475fc7c874094b0938a3e5`, 부모 state log `d00277d3750823b34ce8e64d1bd5f3a1e92ee294cea8230e1df8c6ae15a0d500`, 복구 전PNG `2b4312dbf70809ebc45698d2c653751a55780be4fdf72c59f6a9fbf6a531020f`, 복구 후PNG `049b32c0e049797531f347e0e83cc3195132bd53a562341d3722c27be95f955e`. `.gdignore`로 문서 증거를 엔진 import에서 제외한다. 이전 v1–v3 결과는 덮어쓰지 않았다.

실제 다섯 검토는 전체 state/owner 소비처, 실패·기존 fixture 격리, 복구 UI와 visual readback, live 접근성·unknown key 보존, 캡처 격리·종료 정리 순으로 진행됐다. 각각 발견한 문제를 관련 focused 계약과 GPU로 재확인했으며, 전체66를 매 루프 반복한 것으로 세지 않는다. 상세 명령·발견·대안은 active plan 보고서에 있다. 새 DB/전체 migration 대신 기존 owner·테스트 seam을 재사용했다. power-loss·모바일 사진·Human·최종 아트·출시는 여전히 미검증이고, R06 draft/R08 상세는 후속 독립 단위다.

부모 GPU 재실행. `8041b6c`에서 `MLB_R07B3_CAPTURE_DIR=C:/Users/user/AppData/Local/Temp/MyLittleBoat-R07b3-parent-20260914-2340`, 동일 격리 QA `--path`, `--resolution 540x960 --script res://tests/capture_storage_recovery_ui.gd`로 직접 실행했다. exit0와 실제 복구 버튼 PASS, 예상 parse2건 외 ObjectDB/자원 경고 없음. [부모 실행 로그](state-runtime/parent-gpu-runtime.log)는 같은 코드·호출 순서여서 v4 로그와 byte/hash가 동일하다. 같은 출력 대상으로 다시 시도하니 preflight exit1로 거부하고 기존 PNG hash를 유지했다. 이는 의도한 음성 검증이며 실패를 숨긴 성공 표시가 아니다. 부모가 실제 본 복구 후 화면에는 이전 family의 어두운 선체 일부가 보이므로 최종 외형 품질 검수는 R03/R06에 남기며 이 UI 검증으로 승인하지 않는다.

독립 검토 발견. ① 손상 ledger primary 복구 뒤 pending summary가 남아도 정상 status로 재시도 UI가 사라짐 ② NOT_COMMITTED 기록 재시도 성공 뒤 NextVoyageButton 미동기화 ③ comfort backup 복구 뒤 live pair가 미저장이어도 안내가 사라짐 ④ photo NOT_COMMITTED를 지원하지 않는 generic retry로 보내고 뒤 owner 접근도 막음. 이는 기존 PASS가 시험하지 않은 실제 경로의 누락이며 테스트 통과만으로 완료하지 않는다. 원래 구현자에게 네 반례의 RED/GREEN과 실제 버튼·저장 readback을 함께 교정하도록 전달했다. 사진은 실패한 원본을 보존하지 않았는데 되살렸다고 표시하지 않고, 단순 실패는 기존 재촬영 경로·실제 손상 상태는 명시 복구 경로로 구분한다.
