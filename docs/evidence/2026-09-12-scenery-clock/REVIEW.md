# 풍경 이동 시간 동기화

## 범위와 현재 정본

2026-09-12 사용자 연속 구현 요청에 따른 기존 이동 연출의 결함 교정이다. 기준 HEAD는 `be4f6dfe09b011456be1eac804f6a0fe61729646`이다. 프로젝트 AGENTS, 현재 GDD/handoff, 실제 풍경·부유·overlay consumer와 Base adapter를 다시 읽었다. Base remote `d830c0f6967678eed3c208ac6b24f9cd1b262ec3`의 공용 검토 절차를 조사했지만 프로젝트 v9.4.4 채택 계약을 교체하지 않았다. Base의 최신 2회 상한과 프로젝트의 5회 최소는 드리프트이며 프로젝트 규칙이 우선한다. 다른 open PR #19는 읽기 전용으로 유지했다.

## 작업 전 문제

일반 풍경의 Tween은 벽시계로 재생되어 still에서도 움직였다. 일반·계절 풍경의 복귀 Timer 역시 속도와 무관하여 느린 풍경을 통과 전에 지웠다. 수정 전 still Tween/Timer 동결 테스트가 두 항목 실패했다.

## 실무 조사와 비교

| 사례 | 확인한 제작 원칙 | 프로젝트 적용 |
|---|---|---|
| [Spiritfarer 공식 소개](https://thunderlotusgames.com/games/spiritfarer/) | 보트에서 동료와 시간을 보내는 경험, 애니메이션과 선택 활동 | ADAPT. 동반자와 쉬는 기본 경험은 유지한다. 반복 자원 관리나 성장 의무는 REJECT |
| [A Short Hike 제작자 GDC 개요](https://www.gdcvault.com/play/1026613/) | 작은 오픈월드의 범위·시각·레벨 설계와 제작 과정 | ADAPT. 좁은 실제 소비처부터 검증한다. 발표 개요만 확인했으며 내부 카메라 구현을 역공학했다고 주장하지 않는다 |
| [DREDGE 개발진의 Apple 발표](https://developer.apple.com/videos/play/meet-with-apple/247/) | 실제 플레이 관찰, 터치 UI와 입력 흐름 재설계, 항해 중 주변 시야 보존, 반복 프로토타입 | ADAPT. 속도·화면 전환·복귀의 연속성을 실행 검사한다. 직접 조타·낚시 반복 경제를 이 게임에 도입하지 않는다 |
| [Godot Tween 공식 문서](https://docs.godotengine.org/en/stable/classes/class_tween.html) | bound pause, speed scale, finished, custom_step | ADOPT. 기존 Tween의 수명과 재생 배율을 활용하고 전역 시간을 바꾸지 않는다 |

구현 대안은 ① Timer 잔여 시간을 속도 변경마다 재계산하는 방식(REJECT, 중복 시계), ② 모든 풍경을 새 공통 progress 시스템으로 재작성하는 방식(DEFER, 현재 범위보다 큰 교체), ③ 기존 Tween 배율과 계절 progress 완료를 연결하는 방식(ADAPT)이다. ③은 저장·보상·소리·씬 구조를 바꾸지 않고 재현된 오류를 고친다. FEASIBLE이다.

## 실제 변경

`game_scene.gd`의 `_sync_scenery_motion_clock`가 일반 풍경 Tween에 현재 speed × comfort를 적용한다. 생성 직후·설정 버튼·표류 갱신에서 호출한다. 활성 풍경의 legacy Timer는 paused로 두며 일반 풍경은 Tween.finished, 계절 섬은 progress 1에서 기존 복원/정리 함수를 호출한다. overlay/비활성의 bound process 정지는 보존한다. Timer 노드 삭제나 저장 마이그레이션은 없다. 롤백은 이 변경의 코드·회귀 테스트만 되돌리는 단위다.

예를 들어 풍경 통과 중 still로 바꾸면 위치·시각 만료가 멈추고, standard로 돌아오면 같은 풍경의 남은 이동이 이어진다. 발견·기록의 foreground 시간은 변경하지 않았다. 추가 전체범위 검토에서 GDD P2와 충돌하는 후속 이벤트 교체를 발견했다. 실제 director 이벤트 20개 seed로 기존 Tween 교체를 재현하여 실패 1을 확인한 후, 기록 처리 뒤 still의 새 시각 배치를 생략하도록 수정했다. 큐를 만들지 않으므로 복귀 때 누적 풍경을 몰아 재생하지 않는다. 현실 시간대 변경은 별도 context 전환 계약이며 이번 수정의 대상이 아니다.

## 검증과 한계

최종 후속 교정 후 headless 전체 60개 실패 0, Python 20개 PASS, OpenGL 실제 overlay 실행 실패 0을 다시 확인했다. 최종 상태별 결과와 소스·캡처 해시는 verification.json을 따른다. 첫 읽기 리뷰에서는 결함을 찾지 못했으나 정본 전체 재검토에서 후속 이벤트 교체 문제를 발견하여 RED→GREEN으로 교정했다. 짧은 테스트나 최초 리뷰만으로 종료하지 않은 사례다. 새 이미지·모델·save·보상·온라인 기능 변경은 없다.

자동 5회 회귀 반복은 전체 범위의 적대적 검토 5회 완료로 간주하지 않았다. 추가 finding 교정 후 아래 독립 전체범위 재검토 5회를 새로 수행했다. 장기 실행·모바일·Human·전체 아트/3D/Blueprint 최종 동기화는 남아 있다. 이번 제한된 수정의 PASS를 게임 전체 완성 또는 전진감의 사용자 승인으로 확대하지 않는다.

### 교정 후 전체범위 재검토 5회 영수증

읽기 전용 reviewer `stern_review`가 수행했다. 중단된 finding 발견 회차와 자동 회귀 반복은 포함하지 않는다. 각 회차 HEAD는 `be4f6dfe09b011456be1eac804f6a0fe61729646`, code/test SHA는 verification.json의 최종 SHA와 동일했다. 매번 AGENTS, GDD, handoff, 채택 adapter, game_scene 전체, director, GameState, AlbumView, game.tscn, 변경 테스트 전체, REVIEW, verification을 `Get-Content -Raw`로 다시 읽었다. `git rev-parse HEAD`, `git diff`, `git diff --check`, `git diff --numstat`, 미변경 consumer `git diff --exit-code`와 파일 SHA를 확인했다. 아래 중점은 전체범위 읽기에 추가한 검토이며 부분 관점만 5회 셈한 것이 아니다.

| 회차/KST | finding·교정 readback | 회귀·미변경 소비처 | 대안·장기 적합성 |
|---|---|---|---|
| 1 / 10:00:44 | 기록 뒤·공통 show 앞 still guard, 일반/계절 교체 억제와 큐 없음 확인. 기존 finding 해소, 새 finding 없음 | 20-seed RED→GREEN 읽기, root 전체 suite와 동시 실행하지 않음. 코드/테스트 hash 및 전체 diff 확인 | director 정지는 기록 cadence 변경, 큐는 P2 위반. 표시 dispatch만 생략 채택 유지 |
| 2 / 10:01:34 | 생성→finished/progress→restore→clear 전체 수명 재확인. 이전 Tween/Timer 정리 유지, 새 finding 없음 | reviewer headless overlay exit0/실패0. 실행 후 hash 동일, 저장/director/scene/album 미변경 | Timer 재계산은 중복 시계, 노드 삭제는 불필요한 범위 확대. 완료 경계 재사용 유지 |
| 3 / 10:01:57 | 생성/버튼/drift의 배율과 overlay/focus/title 경계 재확인, 새 finding 없음 | reviewer seasonal 및 forward drift PASS/exit0, root 전체60 PASS readback | 전역 time_scale 부적합, 전면 progress 재작성 과대. 현재 기존 소비처 재사용 유지 |
| 4 / 10:02:27 | 발견·개인기록·함께한 시간·저장 격리·teardown 재확인. 실패 복구는 실패 count 보존, 새 finding 없음 | reviewer ambient motif 및 direct entry PASS/exit0. GameState/director/AlbumView/game scene diff 없음 | still 발견/보상 제거는 범위 밖. 새 저장 모델 없이 표시만 교정 |
| 5 / 10:03:09 | 최신 문서·전체 diff·no-queue·기록 유지 재확인. 캡처4개 SHA 일치, after-album 직접 확인. 새 blocker 없음 | reviewer OpenGL overlay exit0/실패0. 10:03:26 최종 hash 동일/diffcheck PASS/test_overlay 잔여 없음 | 추가 추상화 없이 기존 owner와 회귀 결속 유지. 더 나은 필수 범위 내 대안 없음 |

실행 파일은 `C:/Users/user/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe`다. headless 명령은 `--headless --path . --script res://tests/<계약>`이며 각각 `test_voyage_overlay_continuity.gd`, `test_seasonal_parallax_contract.gd`, `test_voyage_forward_drift_contract.gd`, `test_ambient_motif_game_scene_contract.gd`, `test_direct_boat_entry_contract.gd`를 실행했다. 마지막 display 명령은 `--path . --rendering-method gl_compatibility --script res://tests/test_voyage_overlay_continuity.gd`다.

미변경 소비처 SHA는 director `A026469AFB21FA848A8FB1A3EE8F95F6F1E6ED7901CEDCB19CE850425FA83FE5`, GameState `DEBA8142F9F16839BD6677B560FB8416B18F8B617F49A96BEF6AAB169A767454`, AlbumView `E5E646A8E4C88208DFD345D1B18EE46CD4039351887AE771533DC3BDCD521DF7`, game.tscn `CE2266EDCB6FF697900BB42C4D79ECC20B32F635C409EA1E2E764F0F5ED9FC89`로 5회 모두 같았다. 문서와 실행 receipt는 작업 중 갱신된 상태를 매번 다시 읽었으며 마지막 검토 뒤에는 이 closeout 영수증만 추가했다.

## 자동화·학습

기존 overlay 회귀에 still 유지, 일반·계절 시각 완료 정리, 3단계 속도 배율을 추가하여 기존 CI 60개 집합에서 자동 재검사한다. 공용 후보 교훈은 ‘시각 연출과 벽시계 만료를 혼용하지 말고 pause/speed 전환과 실제 완료 경계를 함께 검사’이다. 아직 단일 프로젝트 사례이므로 Base를 수정하거나 공용 정본에 자동 승격하지 않는다.

## 임시 산출물

중간 캡처 8개/4,365,192 bytes는 `C:/Users/user/Desktop/MyLittleBoat_삭제대기_20260912`의 `scenery-clock-intermediate`, `scenery-clock-before-followup`에 옮겼다. 각각의 이동안내에 원래 경로/사유/개수/용량/이동 전후 SHA-256을 남겼으며 비교 일치를 확인했다. 직접 삭제하지 않았다. 최종 캡처 4개와 승인 자산·production save는 보존했다.
