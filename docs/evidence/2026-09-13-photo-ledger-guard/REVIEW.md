# 사진 목록 손상 시 원본 보존

## 범위와 기준

기준 HEAD `3e1961eecff4725876b1cf6527ad72a98b625175`, continuation branch `codex/title-boat-flow-20260831`. 최신 사용자 목표는 게임 전체 구현·완성이며 이번은 GDD P8/IMP-05의 저장 안전성 단위다. Base adapter v9.4.4를 유지했다. 열린 다른 workstream PR #19는 read-only로 확인했고 수정하지 않았다. production 변경은 `PhotoMemoryPersistence.save_photo()`와 같은 클래스의 ID 예약 입력뿐이다. GameState, album view, game scene, 승인 이미지, 보상/항해 진행/소리 구현은 그대로다.

## 문제와 비교

기존 구현은 읽지 못한 목록을 빈 배열로 처리하여 사진 저장 시 손상된 기존 원본을 덮어썼다. [ConfigFile 공식 문서](https://docs.godotengine.org/en/stable/classes/class_configfile.html)의 load 오류와 save overwrite 의미를 확인했다.

| 대안 | 판단 | 이유 |
| --- | --- | --- |
| 잘못된 목록을 빈 앨범으로 초기화 | REJECT | 정상처럼 성공해 복구 가능한 원본을 잃음 |
| PNG 생성 전 원본 구조 검사, 오류면 원본 보존 | ADOPT | 현재 저장 형식/consumer 유지, 부작용 전 차단, 기존 실패 UI 재사용 |
| transaction/backup 자동 복구 | DEFER_NEXT_PACKAGE | 쓰기 중 실패·전원 차단·Windows replace 검증이 별도로 필요하며 이 guard의 증거로 확대 불가 |

공식 Windows master의 rename 구현은 목적 파일을 지운 뒤 MoveFile을 호출한다. 이 조회는 실행 중인 엔진 exact revision의 증거가 아니고, 단순 rename을 atomic이라고 간주하지 않는다. 이번에는 rename이나 backup 파일을 추가하지 않았다.

## 구현과 실제 교정

파일이 없으면 새 앨범을 만든다. 파일이 있으면 파싱, section/key, Array, 각 Dictionary의 필수 4개 non-empty String을 먼저 검사한다. 유효 snapshot을 ID 예약과 저장에 함께 쓰며 누락 PNG의 정상 metadata는 보존한다. 실패하면 성공 entry를 만들지 않고 기존 bytes/PNG를 건드리지 않는다. load의 기존 관대한 표시 동작은 유지한다.

- wrong-type/missing-section fixture RED 6건, partial-row RED 3건을 실제 재현한 뒤 guard로 GREEN.
- 독립 검토에서 숫자 필드를 str로 변환해 덮는 경로를 발견했다. 네 필드 각각 숫자인 fixture의 RED 12건을 재현하고 저장 전 String 검사로 GREEN.
- 실제 malformed ConfigFile의 `ERR_PARSE_ERROR`와 원본 bytes/PNG 보존을 검사한다. [Engine 공식 문서](https://docs.godotengine.org/en/stable/classes/class_engine.html)에 따라 예상된 동기 parser 호출에서만 오류 출력을 잠시 끄며 await 없이 기존 설정을 즉시 복구한다. `EXPECTED_CONFIG_PARSE_FAILURE_EXERCISED`가 명시 증거이며 이후 assertion/전체 suite 오류는 숨기지 않는다.
- 첫 GPU 표본은 내부 photo 호출로 접힌 메뉴의 문구를 확인했다. 화면 재검토 후 실제 photo 버튼이 메뉴 내부에 있다는 consumer를 확인하고 테스트를 `RestMenuButton → TakePhotoButton` 신호 경로로 수정했다. production 알림 UI를 추가하지 않았다. 최종 검사는 실패 문구가 tree에서 실제 visible인지도 확인한다.

## 실행 및 다섯 범위 검토

모든 시간은 2026-09-13 KST. 기준 HEAD 위의 명시된 dirty source를 검토했으며 최종 source identity는 `verification.json`에 있다. 반복 검사 수를 다섯 번의 제품 개선으로 세지 않는다.

| 회차 | 실제 읽기·검사와 범위 검토 | 교정/결과와 장기 적합성 |
| --- | --- | --- |
| 1 · 09:19:40–09:20:09 | persistence 전체, state test/consumer, 사진 consumer, GDD P8, 5개 photo/state/album/overlay 계약과 GPU 첫 표본 readback | typed-field 수정 유지. 기존 정상 PNG 누락/ID/앨범 보존. 표시 성공을 문자열 검사만으로 판정하지 않는 후속 확인 필요 |
| 2 · 09:20:10–09:21:05 | 첫 PNG, rest-menu open/close, scene StatusLabel parent, photo button connection, overlay 직접 호출 대조 및 GPU 재실행 | 실제 사용자 경로로 테스트 교정, 새 UI 제안 철회. metadata 보존과 visible 실패 피드백 모두 확인. 기존 game scene/저장 성공 경로 유지 |
| 3 · 09:21:12–09:21:16 | 최종 PNG, album memory/composition consumers, 전체 변경 목록, 동일 5개 계약 | 이전 사진 페이지·누락 caption·함께한 시간 표시 보존. 재생성/자동 삭제보다 기존 consumer 재사용 적합. 새 MUST_FIX 없음 |
| 4 · 09:21:31–09:22:24 | persistence diff, album view, 전체 61개 headless 계약, 20개 Python 검사 | 모두 PASS. UI/낚시/장식/시간/모션 등 untouched consumer 회귀 없음. 읽기 보호와 transaction 복구의 증거 경계 유지 |
| 5 · 09:22:25–09:22:46 | 최신 GDD/handoff, 6개 source hash, worktree/open PR, photo/state/album/overlay 5개+route/seasonal 2개 재실행, Base compatibility 검사 | 모두 PASS, scene·voyage source hash 불변. 다른 worktree 보존. 정본 lock 교체/범용 저장 framework 불필요. retained guard에 새 MUST_FIX 없음 |

독립 read-only reviewer는 최종 네 코드/테스트 파일을 재확인하여 앞선 타입/파서 결함 해소와 추가 MUST_FIX 없음으로 보고했다. 실행 증거는 별도로 위 로컬 검사가 소유한다.

## 사용과 증거 수준

실제 사용 경로는 쉬는 메뉴 → 사진찍기 → 성공 시 앨범, 실패 시 기존 기록을 보존하고 실패 문구 표시다. [실제 실패 화면](runtime/photo-save-error.png), [실제 앨범](runtime/album-history-540x960.png), [작은 logical viewport](runtime/album-history-360x640.png)를 포함한다. GPU 검사는 Godot 4.7.2, Windows Vulkan/Forward Mobile, RTX 3050이다. Mobile renderer는 실제 모바일 기기 검증을 뜻하지 않는다. 테스트가 버튼 신호를 호출한 증거이며 사람의 OS 입력/접근성 경험 검증은 아니다.

MACHINE_VERIFIED 및 제한된 RUNTIME_VERIFIED. Human/실기기/전원차단/디스크 부족/동시 외부 수정/자동 복구/최종 Release는 NOT_RUN 또는 미구현이다. 기존 유효 metadata의 추가 unknown key 보존과 경로 정규화는 이 guard의 확장 완료로 주장하지 않는다. 승인 아트/입체 모델/전체 게임 완성과도 별개다.

## 자동화·정리·다음 작업

숫자 타입·파서 오류·GameState 상태 불변·실제 버튼의 visible 실패 문구를 기존 tests에 영구 추가했다. Base 새 module은 만들지 않고 기존 실패 보존/consumer 실행 검증 원칙을 적용했다. 사용이 끝난 첫 GPU 출력 9개/4,068,188 bytes는 프로젝트 밖 `MyLittleBoat_삭제대기_20260913/photo-ledger-intermediate`로 옮겼고 인접 manifest가 각 원래 경로/이동 경로/전후 SHA-256을 기록한다. 사용자 직접 삭제 정책을 유지한다. 최종 9개 PNG는 runtime evidence consumer가 있어 보존한다.

다음 전체 제품 작업은 현재 GDD의 공통 공간 수면/원경, 모델·리그와 회전/좌석 접점, 시간대/외형/동반자 조합, 안전한 저장 transaction, soundscape 설정, 긴 실제 시간 실행/패키지/Blueprint를 계속 대조한다. 이번 작은 guard가 전체 안전 저장이나 게임 완성의 대체물은 아니다.
