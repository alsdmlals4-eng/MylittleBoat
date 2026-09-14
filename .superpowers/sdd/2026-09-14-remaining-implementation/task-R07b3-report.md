# R07b3 실제 state/UI 성공 경계와 복구 보고서

## 현재 범위와 기준

- effective task base: `cf7860d` (`988854bc610f11677d716d34404035e2ce5b9e48`의 게임 source/Scene/test 기준과 동일하며, `cf7860d`는 부모의 PDF-only 교정이다.)
- 구현 범위: `GameState`, 기존 `GameScene` 쉬는 메뉴, `CalmFishingSession`, 관련 기존 fixture와 새 격리 계약·capture.
- 제외: R06/R08, 사진 상세, 모바일 사진 지원, GDD/handoff/PDF 본문, Human/device/final-art/release 승인.
- Godot 실행은 `C:/Users/user/AppData/Local/Temp/MyLittleBoat-r07b1-3fd622b196824aaca3c9e30075f23483`의 custom user-dir QA project에서 수행했다. 다른 Hera editor는 `urban-legend` PID 10052로 확인되어 선택·변경하지 않았다.

## TDD RED → GREEN 기록

1. 새 `test_save_success_state_contract.gd`를 먼저 실행했다. `apply_identity_selection`, `apply_decor_selection`, `get_storage_status`, `recover_storage`, `retry_pending_voyage_record` 부재 5건으로 예상 RED였다.
2. `test_fishing_session.gd`에 같은 ready fish 후보 보존 계약을 먼저 추가했다. `prepare_catch`, `get_ready_catch` 부재 2건으로 예상 RED였다.
3. COMMITTED 뒤 cache 반영, invalid 입력 불변, non-finite 시간 거부, pending 항해 summary 중복 0, fish candidate 보존을 구현한 뒤 두 focused 계약이 GREEN이었다.
4. 확장 UI fixture의 `scene` 지역 변수 타입 추론 parse error를 실제 로그로 확인했다. `scene: Node`로 최소 교정한 뒤 GREEN이었다.
5. comfort 실패 fixture에서 profile만 재시도되어 volume이 복원되지 않는 RED 1건을 확인했다. owner의 기존 validated ConfigFile을 재사용하는 `save_preferences` 단일 commit으로 profile+volume과 unknown section/key를 함께 보존했다.
6. 전체 회귀 도중 `test_boat_life_scene_contract.gd`, `test_boat_life_ui_contract.gd`가 기존 non-test decor owner와 stale appearance cache에 의존해 실패했다. 두 fixture를 정확한 `user://test_*` decor owner로 격리하고 decor/appearance를 함께 초기화·teardown한 뒤 GREEN이었다.

## 구현 결과

- 외형·장식·풍경·물고기·항해 기록은 candidate deep copy를 owner에 먼저 저장하며 COMMITTED 뒤에만 runtime cache를 바꾼다.
- `apply_identity_selection(player_style, pet_type)`와 `apply_decor_selection(decor, appearances)`는 승인 catalog/slot-item/appearance 호환을 검사하고 invalid 요청에서 file/cache를 유지한다.
- 저장된 장식을 Scene에 표시하는 `_apply_stored_boat_decor`는 더 이상 cfg를 쓰거나 unknown 선택을 지우지 않는다.
- together-time은 NaN/Inf를 거부하고, 실패 뒤 미저장 누적을 유지하며 15초 시도 간격을 별도 accumulator로 유지한다.
- 항해 종료 저장 실패는 동일 pending summary 하나를 유지하고 `voyage_record_created`/배열을 확정하지 않는다. 쉬는 메뉴 재시도로 성공한 뒤 정확히 한 번 확정한다.
- 낚시는 ready fish 후보를 세션에 보존하고 ledger COMMITTED 뒤에만 입질을 소비한다. Album 진입/cancel은 기존처럼 후보까지 무패널티 취소한다.
- ambient 저장 실패는 배열과 성공 문구를 확정하지 않되 화면의 풍경 관찰은 계속한다.
- comfort/mute는 저장 실패에도 live 값을 유지한다. 재시도는 profile+volume을 기존 validated config의 unknown key와 함께 단일 commit한다. 명시 복구도 현재 live 값을 덮지 않는다.
- owner ID는 고정 mapping만 허용한다. unknown ID는 빈 status/false로 닫힌다. `RECOVERED` 읽기와 primary `COMMITTED` 복구를 구분한다.
- 쉬는 메뉴는 정상 상태에서 storage control을 숨기고 오류 owner에만 `저장 확인 필요`와 `정상본으로 복구` 또는 `저장 다시 시도`를 표시한다. 복구 성공 뒤 identity router/boat decor consumer를 즉시 동기화한다.

## 현재 검증 증거

- focused GREEN: save-success state, fishing session/outcome, ambient state/GameScene, identity, decor persistence, together-time, ledger, ocean volume, comfort, boat-life scene/UI.
- 전체 headless discovery는 67개 중 display-only 1개를 제외한 66개를 custom user-dir QA project에서 정렬 순서로 실행했다. 실행 도구의 30초 yield 경계 때문에 동일 순서의 연속 batch로 나뉘었으며 모든 66개가 PASS 또는 계약상 명시된 headless capture assertion SKIP으로 종료했다. 손상 ConfigFile parse 진단은 의도한 corruption fixture의 별도 예상 진단이다.
- GPU Forward Mobile/NVIDIA RTX 3050 실제 버튼 capture PASS. 최종 외부 신규 디렉터리 `C:/Users/user/AppData/Local/Temp/MyLittleBoat-R07b3-evidence-20260914-v3`에 `storage_recovery_required.png`(332929 bytes, SHA-256 `2b4312dbf70809ebc45698d2c653751a55780be4fdf72c59f6a9fbf6a531020f`), `storage_recovery_committed.png`(333699 bytes, SHA-256 `f668f4db6c99707b1bdcddb3a8ce2caca92078c3bb1c15ab93b855dc2bcab6e5`)를 생성했다. 첫 화면은 오류 때만 한 줄 상태+복구 버튼, 둘째는 controls가 사라지고 `정상본 복구를 마쳤습니다.`를 표시한다.
- capture tool은 custom `MyLittleBoat_test_*` user dir, resolved absolute external directory, project-root 밖, 기존 출력 부재를 모두 fail-closed 검사한다. `_save_frame` 실패는 bool로 호출자에 전달되어 성공 종료로 덮이지 않는다.
- Human/device/accessibility comfort/final-art/release: `NOT_RUN`.

## 검토 루프 진행 기록

모든 루프의 exact source state는 `cf7860d779feb02e1d0440961586399e43a27368` + 당시 working-tree diff였다. 부모 소유 `docs/design/PROJECT_GDD.md`, `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`는 read-only dirty로 분리했다.

1. 전체 scope/consumer read. `Get-Content task-R07b3-brief.md`, GDD R07, adapter, `game_state.gd`, `game_scene.gd`, 7 owner와 catalog를 읽고 `rg`로 모든 setter/complete/fishing/ambient consumer를 대조했다. 선반영 cache, 장식 2회 저장, 항해 성공 문구, fish 선소비, ambient 선추가, together-time 실패 누적 삭제를 finding으로 확정하고 candidate-first 구조로 교정했다. 새 DB/다중 transaction `REJECT`, 기존 owner별 candidate commit `ADAPT`, UI-only 성공 문구 패치 `REJECT`다.
2. 실패 fixture/회귀 read. 새 state/fishing RED와 focused 명령을 실행하고 `test_boat_life_scene_contract.gd`, `test_boat_life_ui_contract.gd`를 전부 읽었다. non-finite timer, pending summary 중복, ready fish 후보, startup decor read-no-write를 검사했다. 전체 실행에서 발견한 shared production-like owner/stale appearance 의존을 exact `user://test_*` owner+sidecar teardown으로 교정했다. fixture만 완화 `REJECT`, 모든 테스트에 새 framework `REJECT`, 두 실제 consumer fixture 격리 `ADAPT`다.
3. recovery/UI consumer read. `identity_visual_router.gd`, `_recover_or_retry_storage`, `_apply_stored_boat_decor`와 실제 route getter를 대조하고 corruption fixture에서 `RECOVERED != COMMITTED`, unknown owner false, 정상 hidden, pointer `MOUSE_FILTER_STOP`을 검사했다. 복구 뒤 state만 바뀌고 보트 route가 남는 finding을 identity/decor consumer sync로 교정하고 focused GREEN으로 readback했다.
4. accessibility/unknown preservation read. `comfort_preferences.gd`의 `_save_value` 전체와 GDD의 session-only 예외를 재독했다. parent 검토 finding인 live motion/mute overwrite, volume retry 누락, 새 ConfigFile로 unknown key 삭제 위험을 실제 RED로 재현했다. 개별 두 transaction `REJECT`, live 값을 복구본으로 덮기 `REJECT`, validated existing ConfigFile에 두 값을 한 번 commit `ADAPT`로 교정했다.
5. capture/long-term-fit read. `capture_storage_recovery_ui.gd`, QA `project.godot`의 custom user-dir, 두 540×960 GPU 결과를 읽었다. 첫 capture에서 좁은 두-column label 줄바꿈을 확인해 한 줄 상태+tooltip으로 교정했다. parent 검토 finding인 project 내부/기존 evidence overwrite, non-isolated user-dir, `_save_frame` 실패 종료 덮기를 모두 fail-closed guard와 bool 전파로 교정했다. Hera는 `urban-legend`만 살아 있어 선택하지 않았고 isolated MyLittleBoat display route를 유지했다.

## 최종 명령·readback

- RED 원본은 이 Codex task turn의 tool output에만 있으며 별도 raw log 파일은 만들지 않았다. 최초 state RED는 API 5개 부재, fishing RED는 API 2개 부재, comfort RED는 persisted ocean volume 불일치 1건이었다.
- focused 예시 명령은 `Godot_v4.7.2-stable_win64_console.exe --headless --path <isolated-qa> --script res://tests/test_save_success_state_contract.gd`이며 최종 PASS다. corruption fixture의 ConfigFile parse 오류는 의도된 손상 입력 진단으로, 일반 실행 오류 0 주장과 분리한다.
- 전체 discovery 명령은 PowerShell에서 정렬한 `tests/test_*.gd` 67개 중 `test_chibi_normal_chroma_material_proof.gd` 하나만 제외하고 동일 isolated QA `--path`로 각 script exit를 검사했다. 앱 tool의 30초 output yield 경계 때문에 실행 순서를 끊지 않은 뒤 독립 명령 batch로 남은 구간을 이어 검증했다. 합계 66/66 exit 0이며 raw output은 이 Codex task turn tool outputs에만 있다.
- 별도 display 명령 `Godot...console.exe --path <isolated-qa> --script res://tests/test_chibi_normal_chroma_material_proof.gd`는 Forward Mobile/NVIDIA에서 PASS했다.
- storage UI 최종 display 명령은 신규 외부 v3 directory를 지정하고 `--resolution 540x960 --log-file C:/Users/user/AppData/Local/Temp/MyLittleBoat-R07b3-evidence-20260914-v3/gpu-runtime.log --script res://tests/capture_storage_recovery_ui.gd`로 실행했으며 PASS했다. raw GPU log는 1843 bytes, SHA-256 `ddf0183ebda943b4f10272b92266373365a5766223df276fd57d0c2a3afaecdb`다. 의도된 corrupted ConfigFile parse 진단 2건과 종료 시 ObjectDB 2개 leak warning은 raw log에 분리 보존했고 일반 runtime 오류 0으로 주장하지 않는다. retained source의 output/custom-user-dir guard 적용 뒤 생성된 이 v3 결과만 최종 증거로 사용한다.
- `Godot...console.exe --headless --path <isolated-qa> --scene res://scenes/game.tscn --quit-after 1` exit 0.
- `python -m unittest tests.test_ci_contract_coverage tests.test_base_adapter_contract -v` 5/5 PASS.
- `git diff --check` 오류 0. LF→CRLF 알림은 Git working-copy 경고이며 whitespace error가 아니다.
- QA user dir의 `test_*` 잔존 조회 결과 0건. production save를 fault fixture로 사용하거나 삭제하지 않았다.

## 자동화·학습·남은 위험

- CI/reuse/README discovery count를 실제 67 total/66 headless로 동기화했다. 새 공용 Base module 승격은 하지 않았다. 재사용 학습은 owner별 candidate commit, live accessibility 예외, consumer readback, isolated capture guard다.
- rollback은 아래 scoped commit 하나를 revert하는 방식이며 save migration/deletion은 없다.
- Human/device/accessibility comfort/final-art/release는 `NOT_RUN`. Android/iOS 사진 경로, R06 draft, R08 사진 상세, power-loss 플랫폼 보장은 남는다.
- 앞선 GPU 결과 디렉터리 `...evidence-20260914`, `...-v2`는 최종 증거로 사용하지 않는다. 유효한 v3 외부 결과도 프로젝트 파일이 아니며 사용자가 확인 후 직접 삭제할 수 있다.
