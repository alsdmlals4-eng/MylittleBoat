# 수면의 세계 항로 방향 연결 검증

## 작업 전 문제와 범위

시작 head는 `196748319f013366c7999fce3af2ddf1f3004331`, branch는 `codex/title-boat-flow-20260831`이며 작업 시작은 clean이었다. 현재 P5/P6의 연속 항해 목표 중 **수면의 수평 방향 연결**만 이번 논리 변경이다. 기존 코드는 조작 카메라의 상대 yaw를 사용하고 기본 카메라는 (0,1)로 고정해, 실제 기본 3/4 heading -2.66 rad와 직선 항로 +Z의 관계를 누락했다. 카메라와 원경 섬은 실제 공간에서 이동하지만 물은 다른 방향 기준을 사용했다.

현재 `AGENTS.md`, GDD P5/P6, handoff, visual inventory, 실제 Scene/route/controllers/shader/tests 및 adapter v9.4.4를 fresh-read했다. Base origin/main 관찰값 `d830c0f6967678eed3c208ac6b24f9cd1b262ec3`는 drift 정보이며 lock을 교체하지 않았다. 열린 PR #19 `feat/social-fake-backend-20260824`는 read-only로 보존했다. Hera status는 다른 GRIMOIRE 프로젝트를 가리켜 조작하지 않았고 프로젝트-local Godot 4.7.2 CLI로 실행했다.

## 조사·비교와 채택 이유

| 대안 | 판정 | 이유와 실제 consumer |
| --- | --- | --- |
| 상대 입력 yaw와 화면 아래 고정 흐름 | REJECT | 중립 3/4 카메라가 항로 정면이라는 잘못된 가정. 바다/섬의 방향 불일치를 유지함 |
| 실제 수평 카메라 축과 현재 직선 항로 축을 기존 shader에 연결 | ADAPT | 승인 원화·위상·속도·저장을 유지하면서 잘못된 방향만 바로잡음. `game_scene.gd::_apply_background_flow_to_backdrop`가 세 SeaBackdrop에 제공 |
| world 수면·sky와 모델 전체 전환 | DEFER_NEXT_PACKAGE | 최종 P5 목표는 유지. 이 좁은 수정과 함께 미준비 모델/재질·pitch 투영을 완료했다고 주장할 수 없음 |

[Godot 3D transforms 공식 설명](https://docs.godotengine.org/en/stable/tutorials/3d/using_transforms.html)의 global basis와 축 관계를 확인했다. [Catlike Coding 제작자의 Texture Distortion](https://catlikecoding.com/unity/tutorials/flow/texture-distortion/)에서 두 위상 흐름의 교차와 reset 처리 원리를 대조했다. 기존 프로젝트 shader를 재사용하며 새 shader·물리 부력·외부 의존성·공용 module은 추가하지 않았다. Base reuse-first 문서의 기존 consumer 우선 원칙은 재사용하되 그 문서의 historical Notion 동기화 예시는 채택하지 않는다.

## 구현·사용 예

현재 직선 route의 세계 +Z와 카메라의 수평 right/forward를 같은 좌표계에서 비교한다. 오른쪽으로의 물 통과는 배 진행의 반대 부호이며 전후 성분은 기존 shader의 화면 원근 변형에 전달한다. 기본 카메라 방향은 약 `(-0.463191, 0.886258)`, 기준에서 +76° 둘러보기는 약 `(-0.971989, -0.235027)`다. 따라서 항로 측면을 넘어서 뒤쪽을 보기 시작하면 물의 전후 성분도 반전된다.

실행 후 Start → 항해 → 둘러보기/감상으로 관찰한다. 메뉴·저장·보상·속도 tier·title/still/background/overlay 규칙은 바꾸지 않는다. `travel_direction`만 교정하고 shader 원근과 수평선은 그대로다. rollback은 이번 단일 논리 commit을 되돌리는 것이며 asset/save migration은 없다.

## 실제 검증과 다섯 검토 회차

모든 회차는 위의 동일 bounded scope(세 수면 consumer의 방향, 기존 phase/route/state/asset 보존)를 대상으로 했다. 시작 head는 위 SHA이며 production 수정 뒤의 작업 파일 SHA-256은 `5a772702ff02c56259e4fbf3eb7a71e2687388e2d7972a0b19d9f8fd6b131a52`다. 전체 게임의 다섯 완료 회차나 Human 검사라는 뜻이 아니다.

| 회차 | 실제 읽기·검사 | 발견·교정 / 보호 영역 확인 / 대안·장기 적합성 |
| --- | --- | --- |
| 1. 재현·root cause | Scene의 세 camera/backdrop, route +Z, shader passage, 두 controller, GDD 범위와 기존 tests를 읽고 `test_voyage_route_continuity.gd` 실행 | 새 기대값에서 RED 14건 확인 후 실제 basis 연결, 같은 검사 GREEN. route 512 경계·title/still/background/보상 보존도 같은 실행에서 재검사. 상대 입력값 유지안보다 실제 축 재사용을 선택 |
| 2. 수면 소비·반복 경계 | 수정 함수와 shader의 `UV - passage * phase` 부호, material 분리를 대조하고 route/motion headless 및 display `test_voyage_motion_continuity.gd` 실행 | 실패 0, GPU wrap error 0. 기존 shader·위상 소비처를 바꾸지 않음. 새 물리/원화 변형 없이 방향만 교정하는 안이 현재 범위에 적합 |
| 3. 독립 반례 검토 | read-only reviewer가 전체 bounded diff와 Scene/route/controllers/shader/GDD/adapter를 재독해, 입력 각도가 아니라 실제 세계 축인가·부호 역전인가·title 전진이 생기는가 확인 | Critical/Important 없음. cardinal/pitch helper는 Diorama만 검사하므로 `all camera consumers`라는 설명을 좁힘. 나머지 두 rig는 neutral/회전 fixture로 별도 검사. 보상·저장·art diff 없음. 전체 world 수면으로 포장하지 않는 한 작은 재사용 수정으로 적합 |
| 4. 통합 회귀·정본 | 동일 production hash에서 모든 headless `test_*.gd`(display-only 한 개 제외), Python suite, Base release checker 및 GDD/handoff/visual inventory 상호 참조 대조 | headless 62/62, Python 20/20, Base v9.4.4 PASS. 음량·사진·앨범·입력·시간대·계절·접점 등 변경하지 않은 consumer 포함. 오래된 relative-yaw 설명은 역사적 기록으로 구분하고 current owner 교정. 새 module/설정/테스트 파일 증식 없음 |
| 5. 실행·증거 readback | 실제 30초 촬영 분석, 세 시점 8개 GPU 표본, GPU overlay 검사와 source hash·diff·cleanup 목록을 대조 | 151 frames / 30.012초, 분석 acceptance true. 원경 공유 위치와 통과 후 정리 유지, capture_errors=0, overlay failures=0. 분석을 촬영 완료 전에 호출한 작업 순서 오류는 capture exit 0 확인 뒤 재실행. 긴 cleanup 출력은 잘려 40개 단위 재독해로 목록 복구. 실제 world 수면/모델 전환이 다음 더 큰 해법이며 이 수정은 그 완료를 주장하지 않음 |

검사 명령의 실행 파일은 `Godot_v4.7.2-stable_win64_console.exe`다. 공통 인수는 `--path . --script <test>`이며 headless 검사에만 `--headless`를 붙였다. 추가 실행은 다음과 같다.

- `tests/capture_voyage_realtime_motion.gd -- <new-absolute-directory> seasonal`
- `python tools/analyze_voyage_motion_capture.py <capture> --output <new-directory> --contact-offset-y -2.25`
- `tests/probe_world_space_island.gd -- <new-absolute-directory>`
- `tests/test_voyage_overlay_continuity.gd`
- `python -m unittest discover -s tests -p 'test_*.py' -v`
- `python ../Base/tools/check_base_v9_4_4_release.py`

실제 renderer는 Windows Vulkan / NVIDIA RTX 3050 / Forward Mobile이다. 모바일 기기 검증이 아니다. headless에서는 GPU assertion을 SKIP하며 그 부분의 PASS는 별도 display 실행으로만 기록한다.

## 실행 이미지와 분석 한계

- [실제 30초 항해 재생](runtime/voyage-30s.webp), [10초 표본](runtime/voyage-10s.png)
- [원본 시점/시간 telemetry](runtime/telemetry.json), [측정값·원본 frame hash·source hash](runtime/motion-analysis.json)
- [시점별 world island 결과](views/projection.json), [중립](views/look-neutral-5s.png), [회전](views/look-left-5s.png), [감상](views/appreciation-5s.png)

실시간 촬영은 수동 delta가 아닌 실제 `_process` 시간이다. 자동 촬영 fixture에서 foreground를 명시하고 입력을 막았으므로 OS focus 전달/사용자 조작 증거는 아니다. 시점별 8개 표본은 **수동 delta**이며 실시간 촬영과 구분한다.

분석값은 sky max error `0.0039215684`, 선체 접점의 선언된 -2.25 anchor 대비 최대 오차 `0.0041594505`(허용 0.012), 표본의 forward nonnegative fraction `1.0`이다. 이미지 patch 추적은 섬/물 무늬에 영향을 받는 휴리스틱이다. 근경 dy 중앙값 약 6.12 px/s, 원경 약 7.07 px/s여서 **이 값으로 원근에 따른 속도 순서까지 검증했다고 말하지 않는다**. 정확한 world 수면이나 정량 유체 속도/가속도 증거도 아니다.

## 자동화·학습과 정리

기존 route/motion 계약에 cardinal 부호·기본 heading·공통 세계 회전 불변성을 추가했다. 프로젝트 고유 교훈은 `PROJECT_WORK_REUSE_HANDOFF.json`에 연결한다. basis/증거 분리 패턴이 이미 존재하고 다중 프로젝트 반복 근거가 없어 Base 신규 module 승격은 하지 않는다.

현재 사용되는 압축 재생·표본·분석·시점 증거만 repository에 보존한다. 원본 154개, 77,341,201 bytes와 조기 분석으로 생긴 빈 폴더는 `C:/Users/user/Desktop/MyLittleBoat_삭제대기_20260913` 아래로 이동했다. 삭제는 하지 않았다. `water-heading-manifest.json`에 원래/현재 경로, 사유, 크기와 파일 hash를 남겼다. 이동 명령에서 전후 hash를 검증했고 잘린 목록은 목적지에서 분할 재조회했다. 다른 작업·승인 원본·현재 consumer·기존 evidence는 이동하지 않았다.

## 미검증·다음 구현

1. 물과 sky가 아직 camera-local이다. pitch 변화에 따른 수평선·원근과 공통 world 수면은 미완료다.
2. 근거리 선체/플레이어/동반자의 실제 모델·리그·가림·연속 orbit은 미완료다. 방향별 구형 카드가 이를 대체하지 않는다.
3. 실제 모바일 성능·물리 터치·Human 편안함/청취·최종 visual lock·release는 NOT_RUN/별도 승인 경계다.
4. 이번 branch 수정은 전체 게임 완성이나 main 병합이 아니다. 원격 동기화는 commit 뒤 exact head readback으로 별도 보고한다.
