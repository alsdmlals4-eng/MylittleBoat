# 카메라 간 풍경 누출 수정

## 실행 전 계획과 범위

사용자 승인에 따라 d37b8e3에서 진단한 타 카메라 섬 누출을 먼저 재현하고 최소 production 수정, 상태 보존 검사, GPU 비교, 회귀와 검토를 수행한다. 실제 공통 공간/모델 제작은 이 수정의 완료 범위가 아니다. 기존 승인 그림·저장·보상·항로·소리·모션 위상은 변경하지 않는다.

## 조사와 선택

Godot 공식 [Camera3D cull mask](https://docs.godotengine.org/en/stable/classes/class_camera3d.html#class-camera3d-property-cull-mask)와 [VisualInstance3D layers](https://docs.godotengine.org/en/stable/classes/class_visualinstance3d.html#class-visualinstance3d-property-layers)를 2026-09-13 fresh-read했다. 노드가 카메라의 자식이라는 사실만으로 해당 카메라에만 보이는 것은 아니다.

| 대안 | 판정 | 이유 |
|---|---|---|
| 시점 변경마다 풍경 visible 토글 | REJECT | 현재 양쪽 consumer의 활성/진행 상태와 표시 정책을 결합한다. |
| 전용 render layer와 camera mask | ADAPT / FEASIBLE | 기존 lifecycle을 유지하면서 렌더링 대상만 제한한다. |
| 단일 world-space로 전면 재배치 | DEFER / PARTIAL | 이전 probe에서 감상/둘러보기 투영 이탈이 확인됐으며 카메라와 근거리 모델 준비가 선행한다. |

## 실제 변경

- `game_scene.gd`의 기존 camera refresh에서 기본 풍경 bit 2, 감상 풍경 bit 4를 설정한다. 둘러보기는 둘 다 제외한다. 공통 bit 1과 나머지 mask는 유지한다.
- `SeasonalIslandLayer`와 `AmbientSceneryPass` 모두 대상으로 한다. scene/resource/image/save 변경은 없다.
- 기존 세계 공간 진단 probe의 복제에는 공통 bit 1을 명시한다. 전용 layer 상속 때문에 세계 공간 실험이 가짜로 사라지는 것을 막는다.
- 원복은 이 논리 변경의 revert이며 저장 migration은 없다.

## 검증 증거

- 신규 isolation 검사 RED. 기존 구현에서 다른 시점 풍경 노출 8개 실패, exit 1.
- 수정 후 seasonal contract GREEN. 시점 네 번 왕복과 둘러보기 진입/복귀 시 필터와 섬 위치/visible 보존 검사도 통과했다.
- 전체 Godot headless 60개, 실패 0. 이후 강화한 시점 전환 검사도 별도 재실행 통과.
- Python unittest 20개 통과.
- GPU overlay continuity 검사 `OVERLAY_CONTINUITY_FAILURES=0`으로 실제 viewport/사진/복귀 경로도 회귀 통과했다.
- Godot 4.7.2 / NVIDIA RTX 3050 Compatibility renderer probe exit 0. `runtime/baseline-appreciation.png`는 수정된 production scene 캡처다. 이전 `2026-09-13-world-space-probe/verified-runtime/baseline-appreciation.png`와 비교해 좌하단의 타 카메라 섬 조각 제거를 확인했다. 같은 probe의 trial 이미지는 여전히 진단용이며 production이 아니다.
- 이 캡처는 정지된 지정 위상이다. 새로운 시간 연속 영상이나 Human 전진감 평가로 보고하지 않는다.

## 자동화와 남은 작업

## 실제 전체범위 검토 5회

독립 read-only reviewer가 최종 소스 SHA(verification.json) 기준으로 다섯 번 새로 읽었다. 공통 HEAD는 d37b8e3이며 각 회차 owner(AGENTS/GDD/adapter/handoff), 전체 변경 3파일, game/scene/director/GameState/fixture와 미변경 consumer를 재독하고 hash·diff·diff check를 확인했다. reviewer는 root와 겹치는 Godot suite를 실행하지 않았으며 root 실행 결과를 최종 readback했다. 각 회차 MUST_FIX 0, 적용 교정 없음, 코드 회귀 증거는 위 root RED/GREEN·전체 suite·GPU 실행과 결속된다.

| 회차 KST | 실제 추가 검토 | 결과·대안·장기 적합성 |
|---|---|---|
| 1 00:25:46 | 초기화·세 camera 전환 호출, 전체 scope/hash | 동일 refresh 경로 확인. visible 토글보다 lifecycle 결합이 작음. |
| 2 00:26:14 | baseline 두 PNG·projection·scene 배치, 전체 scope/hash | 누출 제거·자기 섬 유지 확인. 공통 공간 완료와 구분. |
| 3 00:26:34 | 강화된 전환 검사·생성/progress/clear·Timer/Tween·focus/overlay, 전체 scope/hash | 상태 갱신을 건드리지 않음. world 재구축을 섞을 필요 없음. |
| 4 00:26:50 | mask 12조합 보존/멱등성·probe clone·저장 종료, 전체 scope/hash | 모두 true. trial 공통 layer가 실험 왜곡 방지. |
| 5 00:27:38–40 | 최종 REVIEW/verification/handoff·source 4개/capture 1개 hash, 전체 scope/diff check | 일치. 근거리 모델·회전·Human 미완료 경계 정확. |

최종 root는 같은 source hash를 독립 재검사했고 Base v9.4.4 compatibility checker PASS, Base origin/main d830c0f drift 조회를 완료했다. 채택 lock은 그대로다. 테스트 전용 `test_world_probe_*`, `test_overlay_*`의 정확한 앱 저장 폴더에는 teardown 후 잔여물이 없었다. 다른 worktree·PR #19·Base-worktrees는 건드리지 않았다.

## 다음 작업과 증거 한계

기존 계절 계약에 카메라×풍경 consumer 노출 행렬을 추가해 같은 문제가 자동 검사에서 드러나게 했다. 공용 교훈은 '카메라 자식은 카메라 전용 렌더링이 아니다'이며 Base 승격 후보이지 Base를 이번에 변경한 것은 아니다. 채택 v9.4.4는 유지했다. 타 프로젝트 Hera editor는 사용하지 않았다.

공통 world 좌표, 연속 각도 전환, 실제 근거리 모델/리그, 전체 시간대와 외형 상태군은 남는다. Human/모바일/Release는 NOT_RUN. 새 이미지나 불필요한 임시 파일을 만들거나 기존 파일을 삭제하지 않았다. 이 폴더는 유지할 검증 증거다.
