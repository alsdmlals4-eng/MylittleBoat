# 낮 봄섬 공간 배치 검증 계획과 결과

## 실행 전 계획

사용자 2026-09-13 `진행해`는 앞서 제안한 낮 바다 한 장면 공간 검증과 근거리 3D 제작 경로 확인을 승인한다. 기준 HEAD `cad196c3900964e1f50fe13a013a770576d677f6`. 이번은 진단 probe이며 생산 게임 변경이나 최종 3D 구현 완료가 아니다.

1. 실제 game.tscn과 승인 봄섬을 불러와 기본/감상 camera-local 섬의 global 위치를 측정한다.
2. 기본 카메라 섬을 실행 중 복제하여 world에 한 번만 배치한다. 원본 두 레이어를 진단 실행에서만 숨긴다.
3. 기본/감상/둘러보기의 투영 좌표·카메라 뒤 여부·실제 캡처를 비교한다. 단일 world 위치 보존과 화면의 자연스러움은 별도로 판단한다.
4. 실제 모델 파일과 무료 로컬 제작 경로를 확인한다. 모델/리그 없음을 이미지나 primitive로 충족했다고 보고하지 않는다.
5. 결과를 읽고 생산 변경 범위를 다시 산정한다. 기존 Scene·코드·승인 자산·save owner는 그대로 유지한다.

완료 기준은 재현 가능한 측정 JSON과 실제 캡처, 발견한 공간/가림 결함, 세 대안 판정, 다음 구현의 선행 조건이다. 실제 이동 시간·Human·모바일·리그·production 증거는 이번 정적 probe 범위 밖이다.

## 대안과 조사

- A 카메라별 그림 좌표 조정. 비교 기준으로 유지하지만 같은 물체의 세계 좌표를 보장하지 못한다.
- B 분리 이미지를 world-space 원경으로 배치. 이번 TEST 대상이다. 가림·깊이·카메라 방향을 실제로 검증한 뒤 채택 여부를 정한다.
- C 근거리 실제 3D + 분리 원경. GDD P5의 최종 방향 유지. 모델/리그·재질·Godot 왕복 증거는 별도 준비가 필요하다.

[Godot Node3D](https://docs.godotengine.org/en/stable/classes/class_node3d.html)는 parent-local과 global transform을 구분한다. [Sprite3D](https://docs.godotengine.org/en/stable/classes/class_sprite3d.html)는 3D 안의 2D 이미지이지 입체 모델이 아니다. [3D import](https://docs.godotengine.org/en/stable/tutorials/assets_pipeline/importing_3d_scenes/index.html)는 엔진의 지원 경로이며 프로젝트 모델 제작 완료의 증거가 아니다.

## 실행 상태

진단 코드는 `tests/probe_world_space_island.gd`, 촬영 시계는 기존 fixture를 재사용한다. isolated test 저장 경로와 overwrite 금지, headless 이미지 읽기 생략을 적용했다. Hera 연결 editor가 없어 프로젝트 adapter의 명시적 Godot CLI 경로를 사용했다. AgentMemory sessions/recall 도구는 현재 없어 repository를 재개 정본으로 사용했다.

## 측정·판정

Godot 4.7.2 OpenGL Compatibility 실행 exit0. 최종 `verified-runtime/projection.json`과 PNG 5장이 실제 출력이다. 관찰은 고정 progress 0.5, 낮/봄, 540×960의 정적 투영 비교다. 시간 경과 이동·드래그 입력·모바일/Human 검증은 아니다.

기본과 감상 레이어의 global 중심은 각각 `(-2.7965,-0.5560,4.0718)`, `(4.1000,0.9013,-4.3860)`이며 거리 **11.0099 engine units**다. 둘러보기에는 production SeasonalIslandLayer가 없다. 같은 섬 이미지와 같은 local 진행값이 같은 세계의 섬을 의미하지 않는다.

단일 world 복제는 카메라 전환 후에도 좌표를 유지했다. 그러나 중심 투영은 기본 `(662.91,432.08)`, 감상 `(-443.17,1063.02)`, 둘러보기 `(-2435.87,2594.99)`였다. 모두 camera behind 판정은 false이며 화면 밖 투영과 카메라 뒤는 다르다. 기본의 중심이 화면 밖이어도 이미지 일부는 오른쪽에 보인다. 감상 trial은 섬 조각이 하단에 나타나고 둘러보기 trial에서는 섬이 보이지 않는 것을 캡처로 확인했다. 렌더링의 가림 원인을 분리하는 추가 depth 실험은 아직 수행하지 않았다.

따라서 **B의 단순 reparent만 production에 적용하는 안은 REJECT**한다. 단일 세계 방향·관찰축·수면/원경 깊이를 함께 설계한 B는 여전히 TEST 대상이다. A는 기존 build 보존용, C는 GDD P5 최종 방향이며 실현성 PARTIAL을 유지한다. 잘못된 world 배치를 본게임에 반영하지 않았다.

추가 캡처 검토에서 baseline 감상 화면에도 하단 왼쪽의 섬 조각이 있음을 확인했다. 기존 카메라 배경 visibility 함수는 SeasonalIslandLayer를 함께 토글하지 않아 기본/감상 섬이 모두 world에 존재한다. 따라서 trial 하단 조각을 새로 생긴 현상이라고 해석하지 않는다. 카메라별 레이어 노출 정리는 다음 생산 수정의 확인 대상이며, 이번 보고서는 기존 노출을 숨기거나 새 결함으로 위장하지 않는다.

## 모델 제작 경로 확인

현재 `assets`의 glb/gltf/blend/fbx/obj 검색 결과 없음. PATH의 blender와 `C:/Program Files/Blender Foundation`, `C:/Program Files/Blender`, `C:/Users/user/AppData/Local/Programs/Blender Foundation`에서 실행 경로를 찾지 못했다. 현재 callable tool 목록에도 Blender/rigging/3D 생성 경로가 없었다. 전체 PC에 없다는 증명은 아니며 모델 제작 능력 자체의 불가능을 뜻하지 않는다. 설치·외부 서비스 구매·새 캐릭터 생성은 하지 않았다. 모델/리그/재질/3상태 왕복 검증은 BLOCKED_UNVERIFIED다.

## 다음 구현 계획의 선행 조건

1. 현재 기본/감상/둘러보기의 forward·target·회전축을 같은 세계 기준으로 명세한다. 기존 구도는 비교 기준으로 보존한다.
2. 낮 한 장면에서 동일한 수면 높이·항해 방향·섬 위치를 공유하는 시험 경로를 분리한다. sky/sea의 카메라 부착 카드가 world 물체를 가리는지 depth별로 검사한다.
3. 기존 승인 섬의 투영 경계·중앙 항로·카메라 회전·기본 복귀를 검사하고, 수치와 실제 캡처가 모두 맞을 때만 생산 연결한다.
4. 근거리 모델은 무료 로컬 제작 경로를 별도 검증한 뒤 한 조합만 준비한다. 카드 여러 장으로 연속 모델 회전 완료를 대신하지 않는다.

이번 진단은 위 구현의 원인을 좁혔으나 1–4를 완료하지 않았다. production shader/scene/code/asset/save는 변경하지 않았다. 기존 60개 gameplay PASS를 새 world 구조의 PASS로 재사용하지 않는다.

## 정리와 증거 보존

초기 접점 갱신 전 진단 6파일/2,826,143 bytes는 `C:/Users/user/Desktop/MyLittleBoat_삭제대기_20260913/world-space-initial`로 이동했다. 이동목록 JSON에 원래 경로·사유·개수·용량·파일별 SHA를 기록하고 이동 전후 일치를 확인했다. 직접 삭제하지 않았다. 최종 접점 초기화를 적용한 `verified-runtime`만 현재 진단 증거다. 실행 중 source clone은 종료 시 해제되며 기존 게임 Scene에는 저장하지 않는다.

## 검토 영수증

root는 OpenGL 진단 exit0, 기존 출력 재사용 거부 exit2, Python 20 tests PASS, source/output 해시 일치와 production diff 없음, 최종 캡처 직접 읽기를 확인했다. 전체 gameplay 60개는 이번 진단 작업에서 재실행하지 않았다.

독립 reviewer stern_review는 이전 회차를 재사용하지 않고 이 진단 패키지 전체를 5회 다시 읽었다. 매회 HEAD `cad196c3900964e1f50fe13a013a770576d677f6`, probe SHA `D367C6B24E35C212DB7BA03DC6C303D4FBB5514733B7455D6A4BD42D7559EF22`였다. AGENTS/GDD/handoff/adapter, probe/fixture, game_scene/GameState/game.tscn, REVIEW/verification/projection의 전체 재독과 `Get-Date`, `git rev-parse HEAD`, `Get-Content -Raw`, `Get-FileHash`, `git diff --check`, `git diff --stat`, production diff 확인을 각 회차 수행했다.

| 회차·KST | finding·회귀/readback·미변경 소비처 | 대안·장기 적합성 |
|---|---|---|
| 1 / 00:14:55 | 저장 setter·종료 flush·clone·teardown·handoff 검토. 생산 저장 덮기 없음, 새 결함 없음 | 실제 game fixture 재사용이 별도 fake scene보다 drift를 줄임 |
| 2 / 00:15:15 | ready/process/pause/exit, mode/visibility, 생성·진행·clear, PNG4종 직접 확인. 기존 baseline 하단 조각 발견·보고 | trial 신규 결함으로 확대 금지, A 비교 유지·단순 B 성공 주장 금지 |
| 3 / 00:15:46 | source5개/output6개 SHA 일치, region/pixel size/depth/부착 관계 재확인. baseline/trial-normal 동일 SHA 설명 가능 | 단순 reparent REJECT, 세계축 포함 B는 TEST 유지 |
| 4 / 00:16:11 | 기존 출력 폴더 지정 실행 exit2, 저장/입력/모델 경로 및 해석 보완 readback. 덮어쓰기 없음 | C 최종 방향 유지, 모델/리그는 BLOCKED_UNVERIFIED |
| 5 / 00:16:25–27 | 최종 전체 scope/hash/probe/fixture/문서, 생산 diff·저장/보상 미변경 확인. 새 진단 MUST_FIX 없음 | 새 framework 없이 진단·후속 공간축/depth 구현 분리 적합 |

reviewer가 직접 실행한 것은 `Godot --headless --path . --script res://tests/probe_world_space_island.gd -- <기존 verified-runtime 절대경로>` 보호 검사다. 새 GPU/Python 실행을 했다고 기록하지 않는다. 최종 검토 뒤에는 이 영수증과 verification closeout만 추가했다. 기존 production visibility 문제와 모델 경로 미검증은 남아 있으며, 진단 gate 통과는 해당 게임 문제의 해결을 뜻하지 않는다.
