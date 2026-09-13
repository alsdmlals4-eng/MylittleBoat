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
