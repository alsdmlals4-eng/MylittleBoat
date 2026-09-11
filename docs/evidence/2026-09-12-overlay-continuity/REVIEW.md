# IMP-01 앨범·전체 꾸미기 연속성 검증

기준 HEAD `87350d96ed52cdfec405901ac375f5d61a2bf26f` 위의 bounded 변경이다. 승인 범위는 같은 항해 장면을 유지하는 앨범/꾸미기, Timer/Tween 동결, 복귀·입력·사진·기존 낚시 취소·소리 유지다. 새 모델·아트·저장 schema·보상·병편지 의미는 변경하지 않는다. 최신 상태는 `verification.json`의 소스 Git blob과 실제 검사 결과를 기준으로 읽는다.

## 문제·대안·선택

이전 앨범 진입/복귀는 game scene을 교체해 장면의 위상을 보존하지 않았다. foreground를 false로 놓아도 scenery Tween/Timer는 별개로 진행했다. 세 대안을 대조했다. 전체 Scene 재생성+모든 transient 상태 저장은 REJECT(복잡한 저장 책임), 수동 transient snapshot은 rollback 대안으로 TEST, 같은 game scene+기존 album overlay는 ADOPT다. 전역 SceneTree pause는 UI/audio까지 멈출 수 있어 사용하지 않고 game의 process domain만 동결했다. 명시적 ALWAYS UI와 autoload audio는 분리한다.

[Godot pause/process mode](https://docs.godotengine.org/en/stable/tutorials/scripting/pausing_games.html)와 [bound Tween](https://docs.godotengine.org/en/stable/classes/class_tween.html)을 읽고 실제 4.7.2에서 확인했다. Hera status는 다른 프로젝트 OMENWARD의 editor PID 37728을 반환했으므로 제어하지 않았으며, 프로젝트 adapter의 명시적 경로 CLI 실행을 사용했다. Base v9.4.4 lock은 유지했다.

## 검토·교정 회차

모든 회차는 위 기준 HEAD에 누적 변경된 상태를 검토했다. 실제 명령은 `Godot --headless --path . --script res://tests/test_voyage_overlay_continuity.gd` 및 같은 검사의 Vulkan display 실행, 전체 sorted contract 집합이다. source/최종 출력은 verification에 보존한다. 아래는 이 bounded 구현의 검토 기록이지 전체 기획/3D/Human 완료 선언이 아니다.

| 회차 | 전체 연결 범위에서 확인한 문제·대안 | 교정·회귀·미변경 소비처 |
| --- | --- | --- |
| 1 | AGENTS/GDD P2·IMP-01, game/album, scene Timer, director, persistence, adapter/branch/PR 확인. decor phase/time/Timer와 album scene identity RED 4 | 기존 album 재사용 + game process domain. 같은 객체·위상과 20회 왕복 GREEN. save/social/아트 변경 없음 |
| 2 | focus notification과 사진 await 경계 재검토. same-hour refresh가 풍경을 kill, 촬영 중 album 요청 유실 RED 2 | 동일 context no-op + overlay 동안 전환 연기, 사진 UI 복원 뒤 deferred open. 실제 viewport 사진 연타 1회 저장 GREEN. 새 영구 상태 불필요 |
| 3 | 독립 리뷰와 P2 취소 계약 대조. WAITING/BITE/QUIET 취소 후 낚시 버튼 상태 불일치 RED 3 | 두 진입 경로 idle label 복구. Escape/소리/20회 왕복 재검사. 낚시 결과·페널티 의미 무변경 |
| 4 | 전체 60개 회귀에서 옛 fixture가 비활성 상태의 Tween 진행을 기대함. 실제 viewport mouse press→album→release→back에서 stale drag RED | 옛 fixture는 process callback만 차단하는 표본으로 분리, 실제 비활성 동결은 새 검사 책임. 두 기존 camera owner의 drag 취소로 GREEN. 이미지 방향 카드 자체는 유지 |
| 5 | 독립 재검토가 최초 기본 ID와 실제 시각 ID 일치 시 tone 초기화 누락 발견. 일치 ID·0 조명 fixture RED | 최초 tone은 강제 적용, 후속 동일 context만 no-op. 초기화·입력·사진·왕복 GPU GREEN, 최종 전체 소스 회귀/증거 hash 재대조. 실제 3D/시간대 전체 미술/OS·Human은 별도 |

## 실행·검증 경계

실제 캡처는 runtime/before-album.png, album.png, after-album.png, decor.png다. 540×960 Vulkan Forward Mobile에서 기존 화면을 촬영했으며 새 그림을 만들지 않았다. 테스트는 격리 저장, 실제 process 프레임, viewport로 주입한 Escape/마우스 입력을 사용한다. OS/기기 입력 전달·오디오 청취·주관적 전진감은 이 증거로 승인하지 않는다. headless는 기존 soundscape가 의도적으로 재생하지 않으므로 재생 assertion과 사진 검사는 display에서만 수행한다.

동일 hour/season에서는 복귀 때 풍경/Tween을 보존한다. 실제 시간대가 달라졌으면 overlay를 닫은 뒤 새 context를 적용한다. 시간대 family의 부드러운 시각 전환은 후속 아트/공간 작업이다. standalone album scene의 기존 복귀 fallback도 남긴다.

초기 전체 검사 1개 실패는 위 fixture 교정 후 개별 재검사했다. 중간 전체 실행에서 한 명령의 완료 코드가 수집되지 않은 결과는 PASS로 쓰지 않고 최종 수집기는 종료까지 기다려 다시 검사했다. 이전 screenshot 4장은 사용자의 수동 삭제 방침에 따라 바탕화면 삭제 대기 폴더의 overlay-continuity-first-capture로 이동했고 해시를 대조했다. 최종 캡처와 승인 자산은 보존한다.

## 학습·잔여 작업

최종 headless 전체 60개와 Python 18개는 통과했다. 추가 stern GPU 회귀는 최초 2개 모션 assertion이 실패했으나 진단을 넣은 재실행에서 foreground=true와 0 failures였다. GPU await 동안 OS focus가 바뀔 수 있는 fixture의 수동 모션 표본 직전에 foreground=true를 명시했다. 생산 코드 변경 없이 GPU 두 차례·headless 한 차례 재검사 통과했다. 최초 실패 순간의 foreground 값은 수집되지 않았으므로 OS focus 원인은 추정이며, 전체 60개 실행 뒤 변경된 이 fixture는 별도 재검사 결과로 구분한다. 비활성 동결 assertion은 그대로 유지한다.

기존 기능의 성공 경로뿐 아니라 실제 notification, async 사진 복원, 입력 release가 overlay에서 소비되는 경우, 최초 초기화와 후속 no-op의 차이를 회귀로 남겼다. 새 공용 프레임워크를 만들지 않고 기존 owner에 작은 책임을 추가했다. Base 승격은 두 번째 프로젝트 소비처 검증 전 후보다.

다음 핵심 작업은 실제 수면/원경의 공간과 전진감, 승인 외형 3D/rig/연속 회전, 전체 시간대/상태군, 장시간·다기기 검증 및 최신 구현 반영 Blueprint다. Human은 사용자가 선언할 때만 수행한다. 전체 출시·전체 IMP-01 오류 주입 행렬 완료를 주장하지 않는다.
