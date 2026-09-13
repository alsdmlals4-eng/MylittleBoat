# 바다 소리 조절 — 구현·실행 검증

## 현재 권위와 범위

기준 HEAD `769ed6bf7378ec94229fb6e1f8345df1af907330`, 작업 branch `codex/title-boat-flow-20260831`. 시작 시 fetch/pull 결과 최신이며 다른 OPEN PR #19는 read-only다. Base remote `d830c0f6967678eed3c208ac6b24f9cd1b262ec3`, project adapter v9.4.4 유지. Base 최신 identity template의 2회와 프로젝트 5회 차이는 자동 채택하지 않았다. AgentMemory MCP는 목록에 없어 조회하지 않았고 현재 파일을 fresh-read했다. Hera status는 다른 프로젝트 GRIMOIRE pid 11900을 가리켜 조작하지 않고 project adapter의 로컬 CLI 경로를 사용했다.

전체 게임 완성 목표 중 GDD P7의 실제 OceanBed consumer에 대한 제한된 구현이다. 공통 공간/입체 보트·캐릭터·리그가 준비됐다는 뜻이 아니다. 현재 카메라의 rotation-only 구조와 GDD P5의 모델 미준비를 확인하고, 그 문제를 작은 시점 보정으로 완료 처리하지 않았다.

## 문제 → 조사 → 선택

실제 바다 소리는 -18 dB로 고정되어 사용자 음량/무음 선택이 없었다. [Lake 공식 접근성 목록](https://whitethorngames.com/lake/accessibility)은 분리된 음량과 라디오 선택을 제공한다. [XAG 105](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/105)의 사용자 오디오 제어를 참고한다. 우리 게임에는 현재 별도 음악/효과음/대사 consumer가 없으므로 그 UI를 복제하지 않는다.

| 대안 | 판단 | 현재 구현 대응 |
| --- | --- | --- |
| OS 음량에만 의존 | REJECT | 다른 앱의 소리까지 바뀌고 게임의 무음 선호를 저장하지 못함 |
| 기존 메뉴의 바다 소리 5단계 | ADAPT | 현재 OceanBed만 조절, 기존 설정 파일·autoload·실패 안내 재사용 |
| 새 다채널 mixer/설정 scene | DEFER | 향후 효과음 consumer가 실제 생길 때 확장. 지금은 불필요한 빈 설정·관리 계층 |

[AudioStreamPlayer](https://docs.godotengine.org/en/stable/classes/class_audiostreamplayer.html)의 linear gain/지속 stream과 [ConfigFile](https://docs.godotengine.org/en/stable/classes/class_configfile.html)의 load/save 의미를 확인했다. 기존 파일을 읽고 지정 key만 수정한다. 완전한 atomic replace/손상 자동 복구는 이 단위의 보장이 아니다.

## 구현과 사용

- `ComfortPreferences`가 기존 `comfort_preferences_v1.cfg`의 `[comfort] ocean_volume` 숫자 0..1을 소유한다. legacy 파일은 1.0, 잘못된 값도 기본 1.0으로 표시한다. motion profile·다른 section/key를 보존한다. 파싱 불가 원본은 덮지 않는다.
- `GameState`가 유효 음량을 적용하고 signal을 보낸 뒤 디스크 저장 성공을 반환한다. 쓰기 불가여도 이번 실행의 mute를 막지 않으며 UI가 영구 저장 실패를 알린다. 시간/보상/사진/기억은 바꾸지 않는다.
- `RestingSoundscape`가 기존 -18 dB gain × 선택 비율을 적용한다. stream 교체/stop/play 없이 누적 process delta 기준 full-range 150ms로 선형 전환하며 목표에 도달하면 추가 process를 끈다. 초기 저장값을 먼저 적용한 후 stream을 시작한다.
- 쉬는 메뉴의 `OceanVolumeOption`에서 끄기·25·50·75·100%를 선택한다. 100%는 기존 믹스이며 추가 증폭이 아니다. 감상 카메라에는 조절기를 숨긴다. 실제 목록의 18px 글자와 48px 행 목표를 적용했고 전체 기존 UI 테마를 재설계하지 않았다.

## 재현·교정

기존 코드에서 저장 method 부재와 실제 메뉴/음량 consumer 부재가 RED로 확인됐다. 최소 구현 뒤 GREEN. 필드 저장 교차 보존, legacy/default, mute reload, NaN/Inf/음수/증폭 입력 거부, 다른 section 보존, 손상 원본 byte 보존을 추가 검사했다.

초기 테스트는 OptionButton signal만 직접 호출했다. 독립 리뷰 후 실제 입력 경로로 보완했다. PopupMenu는 Home 키 동작을 제공하지 않으며 Viewport 직접 input 경로도 native popup 입력과 달랐다. 실제 엔진 실행과 공식 engine source를 대조한 뒤, `Input.parse_input_event`에 서로 다른 press/release 객체를 보내고 flush하는 경로를 사용한다. Space → Up → Up → Enter가 실제 목록을 열고 mute를 선택/닫으며, Escape는 변경 없이 취소한다. 이벤트 재사용 경고도 새 객체로 교정했다. 이는 테스트 harness 수정이지 플레이어 입력 기능을 고장났다고 판정한 것이 아니다.

초기 작은 popup 행은 48px 목표 미달 RED였다. 기존 font 높이를 측정해 필요한 separation만 추가한 뒤 GREEN. 초기 Python 2건 실패는 새 test 때문에 정본 CI count가 61로 남은 것이 원인이며 workflow/structured record/README를 63개 중 62개 headless로 함께 갱신했다. test 제거/skip 추가/검사 약화는 없다.

## 다섯 범위 검토

모든 시각은 2026-09-13 KST, 위 기준 HEAD의 작업 변경 상태다. 같은 오디오 범위를 다시 검토한 기록이며 다섯 번의 별도 제품 개선으로 계산하지 않는다. 전체 범위는 P7·menu→state→preferences/audio·새/기존 tests·실제 소비 화면·untouched 항해/기억·rollback이다.

| 회차·시각 | 실제 읽기·검사 | 발견·교정·대안/장기 적합성 |
| --- | --- | --- |
| 1 · 19:07:33–19:08:25 | P7, 전체 preferences/audio, scene/state 연결과 기존 음향 검색, 360px 캡처, comfort/audio 계약 | 다른 음향 consumer 없음. 저장 교차 보존/원본 손상/새 owner 초기 mute 검사를 보강. 새 mixer 대신 기존 owner가 적합 |
| 2 · 19:08–19:11:32 | 전체 새 test, state tick/complete·menu 흐름, PopupMenu 공식 source, 독립 리뷰와 실제 GPU | 직접 signal/시작점 phase만으로 성공을 주장할 수 없음. 실제 키 입력과 누적 fade 중간값·재생 phase를 교정, GPU 0 failures. 항해 완료 fixture도 실제 complete 단계 호출 |
| 3 · 19:11:52–19:13:54 | 전체 62개 계약, Python/CI count owners, popup 이미지/크기, code review | headless 62 PASS. Python RED 2건 교정 후 20 PASS. 작은 목록 RED 1건 교정 후 audio/comfort GREEN. 새 scene 대신 국소 항목 간격 보완 유지 |
| 4 · 19:14:30–19:16:11 | 최종 5개 GPU 화면, audio/overlay GPU, GDD/handoff, startup/state/teardown/UID readback, 전체 import | audio/overlay 0 failures. menu/앨범/감상과 종료 후 작은 화면 보존. import exit 0. 알려진 nested project 경고는 별도이며 무경고라고 하지 않음 |
| 5 · 19:16:37–19:18:20 | 최종 diff 전체·preferences 전체·overlay/complete 경로, CI structured counts, 62개 전체 회귀, Python20/Base checker, UID/source pairing·임시 저장 경로 | 모두 PASS. test_ocean* 잔여 없음. 8개 새 UID는 실제 기존/신규 source와 짝이 맞는 Godot identity로 보존. 관련 기능에 새 MUST_FIX 없음. art/model·device/청취·atomic 저장까지 확대하지 않음 |

독립 read-only reviewer는 초기 증거 공백 수정 후 재검토에서 새로운 MUST_FIX 없음으로 확인했다. reviewer는 Godot를 실행하지 않았고 위 실행 결과는 메인 작업의 로컬 증거다.

## 검증 증거와 한계

- Godot 4.7.2 Windows Vulkan Forward Mobile / NVIDIA RTX 3050. `test_ocean_volume_contract.gd` 및 기존 `test_voyage_overlay_continuity.gd` GPU 실패 0. 물리 모바일 검증 아님.
- 전체 headless 62/62, Python 20/20, Base v9.4.4 checker PASS. `test_chibi_normal_chroma_material_proof.gd`의 display-only 예외는 그대로다. 원격 CI/merge 성공 증거는 아니다.
- [540px 실제 목록](runtime/volume-popup.png), [360px 실제 목록](runtime/volume-popup-360.png), [무음 540×960](runtime/muted-540x960.png). logical 360×640/540×960/720×1280을 검사했다. 열린 목록과 항해 종료 후 버튼의 화면 내 배치를 확인했다.
- mute=0, 50%=약0.06294627 linear gain. 통합 delta 50/100/150ms의 fade 값 검사와 실제 재생 position의 경과 시간 비교. 이것은 스피커에서의 지연/클릭음/음향 만족도/프레임 정지 때의 150ms 보장이 아니다.
- import에서 `tools/candidate-render-project`의 nested project를 무시한다는 기존 경고 1개를 관찰했다. 그 독립 프로젝트나 cache를 삭제하지 않았다.
- Human 청취/휴식감, 물리 터치, 실제 모바일 오디오, 화면낭독기, 장시간/전원차단 저장 복구, 최종 Release는 NOT_RUN 또는 이번 범위 밖이다.

## 정리·재사용·롤백·다음

새 schema 파일/범용 설정 framework/추가 음원/이미지는 만들지 않았다. 회귀는 기존 tests와 한 실제 오디오 통합 test에 추가했다. 실행 입력은 press/release 객체를 재사용하지 않는 교훈을 테스트에 반영했다. Base 공용 변경은 하지 않고 기존 evidence/input 검증 원칙을 적용했다.

이전 캡처 7개 3,086,277 bytes는 프로젝트 밖 `MyLittleBoat_삭제대기_20260913`의 `mlb-ocean-volume-20260913-01`, `...-02`로 이동했다. `ocean-volume-manifest.json`에 전후 해시/원래 경로/이동 사유가 있다. 직접 삭제하지 않았다. 최종 5개 캡처는 현재 evidence로 보존한다. 신규 UID 8개도 짝 source와 함께 보존한다.

rollback은 이 단위의 코드/UI/검사 변경을 함께 되돌리되 사용자 cfg는 삭제하지 않는다. 기존 버전은 추가 key를 읽지 않으며 다음 기존 profile 저장에서 그 key를 유지하지 않을 수 있다. 현재 구현은 다른 key를 유지한다. 승인 이미지·소셜 PR·다른 worktree는 건드리지 않는다.

전체 게임에는 공통 world 수면/카메라, 실제 근거리 모델·리그·회전/좌석 접점, 시간대별 조합, 쓰기 중 장애 복구, 장시간 실행/실행 패키지/현재 Blueprint가 여전히 남는다. 음량 기능을 게임 전체 완료로 표시하지 않는다.
