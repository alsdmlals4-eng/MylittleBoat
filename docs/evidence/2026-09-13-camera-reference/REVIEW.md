# 공통 관찰축과 수면 방향 연결

기준 commit `b3f0b170b545d29308c8e46b37e64252b7d527a0`. 사용자가 승인한 실제 경로/공통 공간 구현의 두 번째 단위다. 실행 전 계획은 current handoff 상단에 기록했다. 기존 기본 rear 구도·승인 자산·저장·보상·overlay·soundscape는 보존한다.

## 선택과 실제 교정

카메라마다 반대 세계 방향을 유지하는 안은 REJECT, 기본 rear 기준과 상대 드래그를 분리하는 안은 ADOPT, 모든 카메라를 하나로 합치는 재작성은 현재 consumer 손실 위험으로 DEFER했다. [Godot Node3D](https://docs.godotengine.org/en/stable/classes/class_node3d.html)의 local/global transform 구분과 [카메라 보간 공식 문서](https://docs.godotengine.org/en/stable/tutorials/physics/interpolation/advanced_physics_interpolation.html)를 참고했다. 이번은 기준축만 연결하며 독립 추적 보간 자체는 구현하지 않았다.

초기 heading assertion은 기존 두 camera의 반대 방향에서 RED였다. LookAround/Appreciation의 초기 x/z와 yaw를 기본 카메라에 맞췄다. GPU 진단에서 LookAround의 기존 절대 pitch clamp가 보트를 화면 밖으로 밀어내는 문제를 발견했다. neutral full-basis 일치 RED를 추가하고 기준 pitch와 상대 pitch를 분리하여 교정했다. yaw ±135°, pitch -16°..38°는 이제 기본 구도에 대한 상대 입력이며 실제 pitch -45.793805°..8.206195°를 GDD에 명시했다.

독립 review와 전체 suite는 수면 consumer가 여전히 절대 yaw를 사용해 중립 전환에서 흐름이 역전함을 검출했다. 두 camera controller의 `get_relative_yaw_radians()`를 실제 shader 방향 consumer에 연결했다. neutral/port 및 Appreciation 실제 touch의 수면 방향 RED→GREEN, 기존 ±90° 흐름 검사를 재실행했다. 처음 neutral assertion의 극소 각도 양자화는 벡터 거리 허용오차 0.0001로 명시했다. 구형 rear test의 반대편 +Z 위치 요구는 새 승인 방향과 충돌하므로 같은 출발 위치·독립 회전의 행동 검증으로 교체했다.

## 실제 증거와 한계

`projection`은 pitch 교정 전 실패를 드러낸 진단, `corrected-projection`은 pitch 교정 뒤 진단이다. 둘 다 `probe_world_space_island.gd`가 실행 중에만 world 섬을 복제한 STATIC DIAGNOSTIC이며 production에 단일 world 섬을 설치한 증거가 아니다. 교정 후 normal/neutral look의 같은 trial 섬 투영은 (662.9066,432.0846)/(662.8428,432.0740)로 일치하고 App은 (587.2938,567.1236)이다. app·normal의 기존 중복 섬 global 간격은 11.0099에서 1.8717로 줄었지만 0이 아니다. 남은 중복/깊이/해역 통과 문제를 해결했다고 보고하지 않는다.

변경된 source 최종 회귀와 검토 결과는 아래에 추가한다. 이전 route의 30초 Mobile 재생은 이전 commit의 증거이며 새 camera 변경 뒤 30초 시험으로 재사용하지 않는다. 모델·리그 생산 경로, world 수면·섬, 고정점 통과와 곡선 경로, 실제 모바일/Human/Release는 미완료다.

최종 전체 61 headless PASS, Python20 PASS. Mobile/Vulkan RTX3050에서 `test_voyage_motion_continuity.gd`의 GPU 반복 경계 오차 0·실패0, `test_voyage_overlay_continuity.gd`의 실패0을 확인했다. final-projection의 actual PNG도 직접 읽었다. 한 projection 종료에 ObjectDB 2 instance 경고가 있었고 이어진 verbose GPU 재실행에서는 재현되지 않았다. 원인을 추정해 생산 코드를 수정하지 않았으며 간헐적 종료 경고는 미확정 위험으로 남긴다. verbose의 RGB8→RGBA8 전환과 optional extension 안내도 GPU 성능 PASS로 포장하지 않는다. exact source hash와 검증 경계는 `verification.json`에 있다.

## 교정 후 다섯 검토 checkpoint

reviewer는 root의 Godot 실행과 병렬로 파일을 읽기만 했다. 모든 회차에서 HEAD `b3f0b17`과 core hash를 재확인했다. 01:14:03은 전체 diff/GDD/handoff·상대 yaw 교정, 01:14:14는 controller 전체·수면 caller·parent 계약·diff check, 01:14:28은 test/Scene/보호 consumer 재독, 01:14:42는 mode/reset/art/pause/focus·GDD 재독, 01:15:01은 전체 변경 scope·기준각 검색·hash/diff 재검토다. 대안은 기준/상대 분리 ADOPT, clamp 확대·게임 내부 이름별 각도 중복 REJECT, 단일 camera 재작성 DEFER였다. 기존 MUST_FIX는 수정 확인됐고 새 actionable finding은 없었다. 생산 script/Scene hash는 verification.json과 같다. Windows wildcard 검색 오류는 `rg -g` 방식으로 교정했다.

이 다섯 회차를 다섯 번 runtime 실행이나 제품 전체 clean exit로 확대하지 않는다. 문서 evidence·종료 경고·미구현 world 공간의 경계를 함께 유지한다. 공용 교훈은 기준 좌표 변경 시 shader·입력 분류 등 모든 파생 consumer를 검색하고 실제 중립 상태를 검증해야 한다는 것으로, Base 승격 후보이지 새 공용 module 완성이 아니다.

## 임시 산출물 readback

최종 `final-projection`만 저장소에 보존한다. 위에서 설명한 projection/corrected-projection/verbose-projection 18파일·7,525,676 bytes는 `C:/Users/user/Desktop/MyLittleBoat_삭제대기_20260913/camera-reference-intermediate`로 이동했다. 상위 폴더의 `camera-reference-intermediate-manifest.json`에 원래 위치·이유·SHA를 기록하고 이동 전후 전부 일치함을 확인했다. 직접 삭제하지 않았다. 이전 실패 경과의 설명은 이 REVIEW에 남으며 사용자 승인 원본과 다른 작업 산출물은 건드리지 않았다.
