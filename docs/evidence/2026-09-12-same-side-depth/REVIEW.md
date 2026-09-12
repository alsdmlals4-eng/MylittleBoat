# 같은 쪽 섬 통과·제한된 깊이 검증

기준 HEAD `8dc2d5dcbdb03734afe097a69f4e67660e664b86`. 최신 사용자 계속 진행/작업재개와 GDD의 항로 비침범·전진감 구현 승인 범위다. 실제 코드 변경은 기존 승인 봄섬 normal/Appreciation 소비처만이다. 같은 쪽 x 3.7→4.5, camera-relative z -14.75→-7.75로 접근하며 화면상 크기와 바깥쪽 변위를 만든다. 0 입력은 오른쪽, progress는 0..1 제한이다. 도착 목표·보상·새 저장·새 아트는 없다.

## 조사·대안과 책임 경계

- REJECT · 화면 전체 이동 또는 기존 중앙 횡단 유지. 하늘까지 움직이거나 바닷길을 침범한다.
- ADAPT · 기존 Sprite3D의 같은 쪽/깊이 투영. 승인 그림과 clock/comfort를 재사용하는 이번 제한된 해법이다.
- DEFER · 실제 world-space 섬과 3D 근거리. 최종 각도 연속성에는 필요하나 이번 단계를 완료 근거로 대신하지 않는다.

[Godot Camera3D](https://docs.godotengine.org/en/stable/classes/class_camera3d.html)의 원근 투영과 [Catlike Coding flow](https://catlikecoding.com/unity/tutorials/flow/texture-distortion/)의 두 위상 흐름을 대조했다. 후자는 Unity 예제의 원리를 참고한 것이며 Godot 호환성은 실제 GPU 검사로 분리했다. Base adapter v9.4.4와 RM-VIS-003의 분리·재사용 경계를 유지했다. Base local 68792fc, remote d830c0f는 드리프트 정보일 뿐 채택하지 않았다. Hera는 GRIMOIRE editor PID21468을 반환하여 건드리지 않고 프로젝트 CLI를 사용했다. PR19 read-only 유지.

## 검토·교정 루프

아래는 이 작은 변경의 누적 작업 상태에서 실행한 검토이며 전체 게임 5회 완료 선언이 아니다. 최종 소스와 명령 출력은 verification.json이 결속한다.

| 회차 | 범위 재검토·실행·발견 | 교정·회귀·대안/미변경 소비처 |
| --- | --- | --- |
| 1 | AGENTS/GDD/handoff/adapter/main/PR, 실제 island/camera/sea/기존 테스트 fresh-read, baseline 30초 촬영 | 동일 거리의 좌우 횡단 발견. 통그림 스크롤 대신 기존 분리 섬을 선택. shader/save/아트 무변경 |
| 2 | 양쪽 camera·좌/우/0 입력·중앙 clearance·연속 depth 검사 RED84 | 같은 쪽 접근+0 fallback+progress clamp로 GREEN. 기존 speed/gentle/still·비보상 계약 동시 검사 |
| 3 | 실제 30초 계절 촬영·초반/후반 이미지 검토, 원근/가림·기존 consumer diff | 섬이 오른쪽 경계로 지나감. 실제 world-space라고 부르지 않음. 다른 계절/motif는 그대로 남음 |
| 4 | 독립 리뷰가 촬영 timer/focus의 실제 시각 덮어쓰기 발견 | 촬영 전용 상속 clock으로 격리, 원본 lifecycle 재사용. 정적 preload가 GameState보다 빨라 compile 실패 → autoload 뒤 동적 load. 최종30.208초152frame 전부 bright/spring 확인 |
| 5 | 전체 headless60/Python18/GPU wrap0, 원본/분석 readback | 옛 접점 분석이 승인 -2.25 anchor를 2.254 이탈로 오판. 명시 anchor와 실제 residual 분리, 잘못된anchor/동적이탈 회귀2 RED→GREEN, Python20 및 최종 분석 PASS. production motion/승인asset 추가변경 없음 |

## 실제 결과와 실행 방법

- Godot 4.7.2 Vulkan Forward Mobile / RTX3050 / 540×960. 입력 차단·명시 foreground·고정12시/4월 촬영 fixture이며 실제 OS 입력·실제 시계 검증은 아니다.
- headless 기존 집합 60/60 통과. 이후 변경은 촬영 fixture/분석기이며 실제 캡처와 Python20으로 따로 검증했다.
- GPU `test_voyage_motion_continuity.gd` 통과, 반복 경계 오차 0.
- 실제 process 30.208초152frame. 표본 수면 유속 중앙값은 근거리6.997px/s, 원거리1px/s. 표본의 비음수 전진 비율1.0. 하늘 최대색차0.00392.
- 명시 anchor -2.25 대비 접점 residual0.0041602 <0.012. 절대 그림의 적절성이나 실제 수면 물리 접촉을 증명하지 않는다. `accepted`는 이 분석기의 제한된 조건 통과다.
- 사용 예: Godot의 `tests/capture_voyage_realtime_motion.gd`에 새 절대 출력 폴더와 `seasonal` 인자를 주고, `tools/analyze_voyage_motion_capture.py`에 `--contact-offset-y -2.25 --output <새 폴더>`를 지정한다. 기존 외형 분석 기본값0은 유지한다. 사진을 생성하는 도구가 아니라 실제 캡처를 원래 시간 간격의 WebP로 포장한다.

초기 실패 분석은 initial-analysis.json에 역사로 남는다. 최종 결과는 **verified-runtime**만 사용한다. 실패 결과의 accepted=false를 덮어쓰지 않았다. 실제 재생·telemetry·frame hash를 보존한다. 실패 분석 때 생성된 중복 재생/캡처 묶음은 바탕화면 삭제대기의 motion-obsolete-analysis로 이동하고 전후 해시를 대조했다. 현재 검증용 원본 프레임은 verification.json의 raw 경로에 보존한다.

## 남은 작업·학습

실제 world-space 수면/섬과 좌우·극점 시점, 봄 외 다른 motif의 가로 슬라이드, 3D 모델/rig/연속 회전, 장시간·모바일·Human·최신 Blueprint가 남는다. 기존 계절 GPU capture 스크립트는 과거 횡단/비활성 전제를 가지므로 이번 증거로 사용하지 않았으며 최신 capture_voyage_realtime_motion 경로를 사용한다. 새 분리 이미지가 필요하면 현재 승인 원본/consumer부터 대조한다.

공통 교훈은 ‘코드 좌표의 이동과 화면 이동은 별개’, ‘시각 fixture의 실제 활성 context도 기록’, ‘기준 anchor와 동적 residual을 구분’이다. 재사용은 기존 도구/회귀에 반영했으며 Base 공용 승격은 다른 consumer 검증 전 후보로 유지한다. 사용자 최종 외형 승인·Human/Device/Release는 이번 실행으로 승격하지 않는다.
