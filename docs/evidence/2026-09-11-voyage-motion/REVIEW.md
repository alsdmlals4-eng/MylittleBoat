# 실제 항해 이동 연출 — 구현·검증 기록

## 최신 승인 후면 slice — 구현과 실제 화면

기준 HEAD `b2b0e427c9c33a867281bea3e3abdaf1a021aa08`에 이번 변경을 더한 상태다. `verification.json`의 Git blob 목록이 검증 코드의 정확한 결속이며 아래 이전 `590b5da` 결과와 섞지 않는다. 최신 사용자 `확정하고 진행해`는 분리본 외형과 후면 적용/모션 연결 승인이지 전체 3D·Human·Blueprint 최종 승인이 아니다.

기존 전체 합성 카드 유지안은 독립 동작을 할 수 없어 REJECT, 승인 분리 자산을 SubViewport로 조립하는 안은 기본 후면 범위에서 ADAPT, 실제 모델·리그는 연속 회전용 최종 구조로 유지하되 아직 PARTIAL이다. [Godot cutout animation](https://docs.godotengine.org/en/stable/tutorials/animation/cutout_animation.html)의 부품별 변환/가림 구조를 현재 Sprite3D 소비처 안에 적용했다. 문서의 버전 경고를 실제 4.7.2 GPU 검증으로 보완했다. [SpringArm3D](https://docs.godotengine.org/en/4.7/tutorials/3d/spring_arm.html)는 실제 3D 모델/충돌체가 없는 카드에 임의로 붙이지 않았다. [Viewport 입력 격리](https://docs.godotengine.org/en/stable/classes/class_viewport.html)는 촬영 fixture에만 적용하고 실제 게임 입력을 막지 않았다.

### 실제 검토·교정 checkpoint

모든 행은 위 기준 HEAD의 연속 수정 상태다. 검사 이름과 최신 결과는 [verification.json](stern-runtime/verification.json)에 보존한다. 아래는 실제 재현·수정 기록이며 **전체 기획 범위의 five-loop clean exit를 주장하지 않는다**. 다른 각도/3D/world-depth/Human의 미완료가 남아 있다.

| 회차 | 실제 읽기·검사·발견 | 적용 교정·회귀 | 범위/대안/잔여 경계 |
| --- | --- | --- | --- |
| 1 | AGENTS, GDD, adapter, main/open PR, 실제 FinalDioramaCard/router/asset hash. 새 integration에서 구형 texture·독립 part 없음·카메라 진행 없음 RED | 승인 RGBA 원본 그대로 연결, AtlasTexture/SubViewport 조립, 공통 시간축 진행. 새 계약 GREEN | 새 3D를 가장하지 않는 후면 범위 선택. 기존 save/social/다른 workstream 무변경 |
| 2 | GPU 조립 texture의 강한 magenta 1,025px, 첫 실제 캡처의 높은 선체/접점 확인 | 기술 despill shader, main에만 낮춘 위치, contact/waterline 보정. 잔여 magenta 0, 정지/접점 계약 재검사 | source pixel 재제작 대신 가역 재질 적용. shared preview 위치를 함께 바꾸지 않음 |
| 3 | 독립 리뷰와 실제 세 번째 캡처에서 공중의 옛 쿠션 발견. 항상 갱신되는 숨은 viewport·장기 좌표 무제한도 발견 | 쿠션을 동일 조립 viewport 안에 재연결, UPDATE_WHEN_VISIBLE, 512 제한. 각 항목 RED→GREEN | 기존 선택 쿠션 삭제나 새 저장 구조 대신 기존 consumer 유지. 대체 외형 경로 보존 |
| 4 | 전체 headless 59개와 Python 18개. 중성색 GPU fixture가 0.6→0.3608 변색 재현, 미리보기 중심 실패 | shader의 texture 이중 곱셈 제거, preview 전용 중심/FOV와 대체 외형 복귀. 중성색/preview GREEN | 단순 명도 보정 덧씌우기 대신 원인 수정. 원본·기존 승인 패턴 보존 |
| 5 | 독립 리뷰 후 default→rabbit→dog 전환 검사를 추가하자 camera refresh의 기본 카드 중첩 RED. 혼합 상태 촬영은 성공 증거에서 제외 | 세 카드 복귀 분기 모두 현재 identity 조건 적용. GPU GREEN. 촬영 identity/decor/ambient 격리·입력 차단, 실패 경로도 exact-path teardown. 최종 전체 headless 59/59·Python 18/18 재실행 | 코드 읽기만으로 놓친 결함을 상태 전환으로 검출. 최종 독립 재검토 Critical/Important 없음은 해당 코드/두 정지 화면 범위이며 전체 Human 검수가 아님 |

### 결과와 사용 경로

게임을 시작하면 새 후면 배·등을 보이는 파란 후드 캐릭터·오른쪽 강아지가 나타난다. Start 뒤 수면 흐름과 기존 부유에 맞춰 탑승자가 작게 반응한다. 고요/비활성 정지, 꾸미기 미리보기, 다른 동반자 선택 후 복귀를 검사했다. 이 움직임은 분리 부품의 작은 회전/변위이며 breathing/notice/settle 전체 관절 clip이 아니다. 원근 수면 흐름은 기존 shader를 유지한다. 공통 카메라/보트 좌표의 변화만으로 세계 풍경 통과나 사용자 전진감을 PASS 처리하지 않는다.

새 실제 실행은 [30초 animated WebP](stern-runtime/voyage-30s.webp), [항해](stern-runtime/voyage.png), [타이틀](stern-runtime/title.png), [꾸미기](stern-runtime/decor-preview.png), [telemetry](stern-runtime/telemetry.json)다. 생성 이미지나 보간 프레임이 아니라 Vulkan Forward Mobile의 실제 540×960 프레임을 원래 촬영 간격으로 재인코딩했다. 입력/foreground fixture 경계와 프레임·소스 hash는 verification owner를 따른다.

새 GPU 통합 검사의 초기 종료에서 ObjectDB 2개 경고가 나왔으며 fixture teardown에 기존 audio release를 호출한 최종 재실행은 해당 경고 없이 끝났다. 전체 저장소의 모든 경고가 해결됐다고 확장하지 않는다. 임시 raw captures는 파생 증거 보존 후 exact-path 정리 대상으로 두며 승인 원본/다른 worktree는 지우지 않는다.

최종 cleanup 시 `C:/Users/user/AppData/Local/Temp/mlb-stern-motion-20260911-` 접두사의 이번 작업 전용 8개 경로(first, second, third, final, delivery, reviewed, isolated, verified)를 읽어 exact-path로 검증했다. 합계 520,150,940 bytes(약 496 MiB)이며 recursive 삭제 요청은 실행 전 도구 정책에 차단됐다. 삭제 완료로 기록하지 않고 다른 도구로 우회하지 않는다. 이전 회차의 별도 cleanup-blocked 폴더도 건드리지 않았다. 프로젝트 user-data의 `test_*` 잔여는 최종 audit에서 없었다. Godot import가 재생성한 기존 후보 renderer 2개의 `.gd.uid`는 삭제를 반복하지 않고 source 메타데이터로 보존한다.

### 자동화·남은 위험

새 회귀는 실제 승인 texture 연결, 잔여 key color, 중성색 보존, 독립 part 반응, title/still/inactive, 장기 좌표, preview 중심과 identity roundtrip을 검증한다. CI 계약 수를 60개/59 headless로 갱신했다. Base 공용 승격 후보는 ‘identity router와 camera router 간 표시 충돌을 roundtrip으로 검증’, ‘shader 중성색 fixture로 이중 샘플링 검출’이며 두 번째 consumer 검증 전 공용 규칙을 변경하지 않는다.

남은 것은 실제 3D/rig/세계 깊이, 전체 각도와 다른 외형의 새 아트, 독립 세부 동작, 장시간/다기기/Human 검증이다. 새 후면 slice 적용 성공과 이 전체 항해 경험의 최종 수용은 별개다.

---

## 이전 수면 연속성 구현 기록 — 역사적 증거

**후속 사용자 평가 — 전체 이동 경험 미충족.** 사용자는 구형 아트가 유지되고 카메라·캐릭터를 포함한 전진감이 부족하다고 지적했다. 아래 테스트/캡처는 기존 수면의 기술 증거로만 보존한다. 수정 아트의 실제 적용, 통합 탑승 모션, 사용자 수용 또는 현재 교정 작업의 five-loop clean exit 증거로 재사용하지 않는다.

기준 HEAD `590b5dacfefefd529f29527f8c43df38176578cd`, main `7181d5e6845e75107eade8c4d2e62e10334ab54b`. 사용자 승인 범위는 벤치마킹 후 실제 보트 이동 연출 구현이다. 전체 Blueprint·새 아트/모델·Human 승인은 별도다. 작업 브랜치는 `codex/title-boat-flow-20260831`, PR #19는 read-only다.

## 문제와 원인

기존 shader는 하단에 편중된 UV 변형을 누적하다 1→0에서 갑자기 되돌렸다. 같은 변형값을 모든 시선에 사용했고, still에서도 횡방향 물 흐름이 계속됐다. GPU 좌표 fixture에서 반복 경계 색 오차 0.866667, 상태 검사에서 still/비활성/시선 세 항목 실패를 실제 재현했다. 비활성 화면은 멈춰도 항해 시간이 계속 누적되는 추가 문제도 실패 테스트로 확인했다.

## 조사·세 대안

| 대안 | 판정 | 프로젝트에 맞춘 이유 |
| --- | --- | --- |
| 통배경 전체 스크롤 | REJECT | 하늘·수평선까지 움직이고 원근 차이가 없다. 분리 이미지 계약과 충돌 |
| 물리 해수면 + 실제 월드 이동 | DEFER / 새 3D 패키지에서 TEST | 각도/깊이의 장기 해법이지만 현재 승인된 새 모델·리그가 없고 FFT 시뮬레이션은 필요 이상 |
| 기존 수면의 원근·시선 상대 흐름 + 두 위상 교차 | ADAPT / 이번 적용 | 기존 texture/scene/save와 호환, 새 art 승격 없음. 근거리와 원거리 속도 차이·주기 연속성을 실제 GPU에서 검사 가능 |

- [Valve, Water Flow in Portal 2, SIGGRAPH 2010](https://cdn.cloudflare.steamstatic.com/apps/valve/2010/siggraph2010_vlachos_waterflow.pdf). 방향성·반복 왜곡 억제·제한된 shader 비용을 참고한다. 이 게임에 길찾기나 목적지 보상을 도입하지 않는다.
- [Catlike Coding, Texture Distortion](https://catlikecoding.com/unity/tutorials/flow/texture-distortion/). 비균일 UV 누적의 변형/리셋 문제와 두 위상 blend 원리를 읽고 Godot spatial shader로 독립 구현했다. 예제의 Unity API나 원본 texture를 복사하지 않았다.
- [Rare, The Technical Art of Sea of Thieves, SIGGRAPH 2018](https://history.siggraph.org/wp-content/uploads/2022/09/2018-Talks-Ang_The-Technical-Art-of-Sea-of-Thieves.pdf). 조용한 물에서는 물체 접점의 foam을 중시하는 방식을 참고하고, 기존 contact layer를 유지했다. FFT·폭풍·물리 부력 전체는 채택하지 않았다.
- [Godot stable Spatial shaders](https://docs.godotengine.org/en/stable/tutorials/shaders/shader_reference/spatial_shader.html). 현재 spatial material/sampler 경로를 사용한다. 실제 4.7.2 OpenGL와 Forward Mobile Vulkan에서 별도 실행했다.

Base adapter v9.4.4는 유지했다. Base remote `2f93e872d9ed4fa18018ac759b01acd7d34e9b58`는 drift 정보로만 읽었다. 최신 Base 정책의 2회와 프로젝트 5회 차이는 프로젝트 규칙 우선이며 자동 교체하지 않았다. 채택 release에서 새 정책 경로가 없다는 read 실패도 확인했으며, 기존 production workflow의 repository-native capture 방법과 프로젝트 adapter를 재사용했다.

## 구현·수정 방법

`game_scene.gd`는 Start·속도·comfort·foreground를 받아 물/선체 위상을 관리한다. `SeaBackdrop`마다 독립 material을 갖고 `travel_direction`을 전달한다. `voyage_split_sea_flow.gdshader`는 수면 전체에 연속적인 깊이 가중을 적용하고, 두 제한된 이동 위상을 혼합해 reset 순간을 감춘다. 원본의 하늘 영역은 수면으로 반복하지 않는다.

수면 흐름 → 선체 주변을 통과하는 무늬 → 보트의 작은 부유 → 같은 위상의 contact/waterline 순서로 경험이 연결된다. 배는 하단 구도를 유지한다. 하늘 자동 스크롤·카메라 roll·노 젓기·새 보상·save migration은 추가하지 않았다. `FORWARD_WATER_FLOW_UNITS_PER_SECOND`는 시각 속도, shader의 depth/passage는 원근 표현 조정점이다. GameState의 기록 속도를 곱하지 않는다.

고요는 물/부유 위상을 멈춘다. gentle은 기존 ‘같은 위상에서 부유 진폭 절반’ 계약을 유지한다. 비활성 상태는 game process를 중단해 시간이 화면보다 앞서가지 않도록 한다. 별도 Tween/Timer의 전체 pause 도메인, album 재진입의 phase 보존은 아직 다음 continuity 패키지다.

## 실제 검증과 한계

- `test_voyage_motion_continuity.gd`는 RED 4항목 → GREEN을 확인했다. 이후 inactive clock RED → GREEN도 확인했다. OpenGL/Vulkan 두 GPU에서 1→0/0.5 경계 검사, 상태/시선 검사를 실행했다.
- 최초 30초 촬영은 호스트에 focus가 있어 foreground 0/151, 실제 흐름 0이었다. 성공으로 쓰지 않고 폐기했다. 촬영 fixture를 명시 foreground로 교정하되 `_process` delta는 실제 시간 그대로 사용한다.
- 교정 후 OpenGL 151프레임/29.94초, 근수면 중앙값 7px/초·먼 수면 1px/초, 추적 표본의 아래방향/정지 비율 100%, contact 상대 높이 최대 오차 0.00416 world units를 기록했다. 이는 측정한 crop의 값이며 전 화면/모든 시간대의 보편값이 아니다.
- 표준 상태의 기본 화면을 검증한다. 전체 각도에서 실제 3D 투영·가림, 새 캐릭터/보트/동반자 모델, 모든 기기·Human 편안함·최종 아트 승인은 NOT_RUN이다. 현재 화면은 기존 승인 runtime art이며 새 Blueprint art가 아니다.
- `tools/analyze_voyage_motion_capture.py`는 실제 crop block matching으로 이동 방향을 측정한다. 단순 픽셀 변화율만으로 전진 PASS를 주지 않는다. 완전히 정지한 촬영은 foreground/유속 기준에서 거절한다. 화면 밖·강한 변형·가림에는 일반 광학 흐름 해석으로 확장해서 주장하지 않는다.

## 검토·교정 기록

각 회차에서 전체 범위(전진/분리 하늘/시선/접점/속도·comfort·비활성/기존 art·save·금지 범위)와 미완료 경계를 다시 대조했다. 아래 상태는 기준 HEAD 위의 작업 중 변경을 가리킨다.

| 회차 | 실제 읽기·실행과 finding | 교정·회귀·대안/장기 적합성 |
| --- | --- | --- |
| 1 · 원인/범위 | AGENTS, GDD, handoff, inventory, adapter, main/PR, 기존 shader/game/camera/forward tests. 새 실패 검사에서 4항목 재현 | 세 대안 비교 후 기존 owner/asset 재사용 선택. 다른 PR·save·art 무변경. shader는 지속 누적 대신 제한된 두 위상 |
| 2 · 실제 GPU/상태 | 수정 shader/material/phase 전체 읽기, Godot display 검사. GDScript yaw 타입 추론 parse error도 확인 | 명시 float로 교정. OpenGL reset 오차 0, 상태 검사 PASS. 공유 material 대신 camera별 복제로 방향 간 덮어쓰기 차단. 외부 framework 배제 |
| 3 · 재생/증거 | 30초 실제 process 프레임·telemetry·분석, 기존 capture와 비교. 첫 촬영 foreground 0/151 발견 | 정지 결과 제외, 명시 foreground fixture로 재촬영. 근7/원1px 흐름 측정. 수동 delta·보간 생성 영상 대신 실제 프레임만 encoding. artifact를 Human 증거로 승격하지 않음 |
| 4 · 전체 회귀/호환 | 58 headless 집합 분할 실행. gentle 위상 회귀, 계절 test의 inactive 상태를 이용한 수동 진행 관행, inactive clock 불일치 확인 | gentle 진폭 의미 복원; 계절 fixture는 set_process(false)+foreground로 명확화; clock 가드 교정 후 해당 tests PASS. 새로운 pause framework보다 기존 process guard 재사용. shader blob `f596da6c623229e28a68e7d6ced7c1a061feccca`, game blob `54e6897de3be904e62f13ded11c43d369bc5f625` |
| 5 · 최종 readback | 최종 변경·artifact 결속·기존 consumers·두 renderer·Python/CI count·전체 headless 재검사 | 결과는 아래 최종 readback에 기록. 역사적 PDF를 재생성하지 않고 snapshot 결속 유지. 새 Base module 대신 프로젝트 검사에 회귀 방지 흡수 |

## 자동화·남은 작업

### 최종 readback

- 전체 58개 headless 계약 재실행에서 실패 0. Python 18 tests PASS. 최종 Forward Mobile GPU continuity 검사 실패 0, wrap 색 오차 0. Import 완료 exit 0.
- 최종 보존 재생은 `runtime/voyage-30s.webp`(540×960, 152프레임), `voyage-10s.png`, `telemetry.json`, `motion-analysis.json`이다. 실제 timestamp 간격으로 encoding했으며 원근 추적값은 근수면 6.924px/s·원수면 1.003px/s, 총 30.203초다. 최종 report의 소스 SHA-256 4개 및 raw capture frame hash 152개를 readback했다.
- 첫 Vulkan 종료의 ObjectDB 2개 경고는 같은 30초 verbose 재실행에서 재현되지 않았다. 해결됐다고 단정하지 않는다. verbose의 기존 RGB8→RGBA8 하드웨어 변환 경고, import의 격리 candidate project 발견 경고가 있어 ‘무경고 PASS’는 아니다. 해당 경고를 숨기기 위한 shader/engine 설정 변경은 하지 않았다.
- production 이미지·모델·scene·project.godot·save/core/audio 구현 diff 없음. 기존 PDF bytes·snapshot은 보존하고 현재 GDD만 범위 승인과 구현 상태를 갱신했다. 새 증거 폴더는 `.gdignore`로 importer에서 제외했다.
- 독립 read-only 코드 리뷰에서 Critical/Important 없음, Minor 2개가 나왔다. 좌우 vector 부호의 기대값 검사를 추가했다. analyzer의 `accepted`는 기본 재생/전진/접점 조건만 판정하며 근거리>원거리의 원근 관계는 별도 측정값을 사람이/검토자가 대조하는 항목이다. 현재 6.924>1.003은 만족하지만 이를 일반 자동 원근 gate로 과장하지 않는다. 전체 각도의 실제 GPU 방향 추적도 남은 별도 검사다.
- 최종 영상·대표 PNG·telemetry·hash 보존 뒤 task별 7개 Temp 폴더 삭제를 시도했으나 실행 환경이 `blocked by policy`로 거절했다. 우회하지 않았다. 약 293MiB는 아직 남아 있으며, 정리 완료가 아니다. 대상은 `C:/Users/user/AppData/Local/Temp/` 아래 `mlb-motion-20260911-r1`, `-r2`, `-mobile-final`, `-mobile-audit`, `-analysis-r1`, `-analysis-r2`, `-analysis-mobile-final`이다(각 이름의 공통 접두사는 `mlb-motion-20260911`). unrelated worktree·과거 자산·사용자 save는 삭제하지 않았다.

새 tool/skill/plugin을 늘리지 않고 테스트와 실제 촬영 분석을 기존 저장소에 추가했다. 재사용 교훈은 ‘픽셀 변화가 아닌 방향·깊이별 통과 속도와 실제 foreground를 검증’이다. Base 승격은 두 번째 소비처 검증 전 후보로만 둔다.

다음은 전체 Blueprint의 새 모델/리그와 동일 3D 공간의 섬/수면/카메라, album/overlay continuity, 실제 기기 comfort 검증이다. 현 단계는 기존 runtime의 전진 수면 연출 개선이며 전체 게임 재제작 완료가 아니다. rollback은 이번 scoped commit의 shader/game/test/docs를 되돌리는 것으로 가능하고 binary asset·save migration에 의존하지 않는다.
