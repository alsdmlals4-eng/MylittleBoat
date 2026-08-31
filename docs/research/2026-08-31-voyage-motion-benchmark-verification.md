# 목적지 없는 항해 모션 벤치마크와 런타임 역검증

관찰일. 2026-08-31.

대상. `MY LITTLE BOAT`의 normal voyage에서 보트가 수면 위에 자연스럽게 놓이고, 목적지·보상 압박 없이도 바다를 지나가는 느낌이 실제 renderer에서 읽히는지 확인한다.

현재 revision. `dcb7a2f Add lower boat waterline contact v2`.

## 외부 참고와 적용 경계

| 참고 | 관찰된 원리 | 프로젝트 판단 |
| --- | --- | --- |
| [Bondee sailing guide](https://thehoneycombers.com/singapore/bondee-app-guide/) | 작은 보트 위 avatar와 시간이 지난 뒤의 산·물고기·발광 해파리·꽃 같은 풍경 조우를 한 흐름으로 보여 준다. | `ADAPT`. 보트·동반자·저밀도 자연 경관 통과만 채택한다. 장시간 대기 보상, 희귀 아이템, 낯선 사람 연결은 rest-first 정본과 충돌하므로 `REJECT`다. |
| [Tangerine Development water study](https://tangerinedev.com/play/clouds-and-water) | 서로 위상이 다른 잔물결, 가까운 수면을 더 많이 움직이는 parallax, 보트의 상하 bob을 분리한다. | `ADOPT`. `voyage_split_sea_flow.gdshader`의 sea-only 흐름, camera/boat의 저진폭 bob, 수면 접점 동기화를 유지한다. |
| [Chromosphere ocean case study](https://chromosphere-la.com/case-study/yuki7study6/) | 비슷하지만 다른 속도의 수면 레이어, 한 방향 wave, 보트·camera 주변에 국한한 추가 효과가 큰 전역 시뮬레이션보다 충분할 수 있다. | `ADAPT`. broad ripple과 narrow waterline을 선체 주변에만 두고, 전역 Gerstner mesh·고대비 sparkle·추가 procedural asset은 현재 범위에서 `DEFER`한다. |
| [Godot spatial shader guide](https://docs.godotengine.org/en/stable/tutorials/shaders/your_first_shader/your_first_3d_shader.html) | spatial shader uniform은 GDScript에서 frame마다 갱신할 수 있고, texture sampling·vertex deformation은 필요한 수준에 맞춰 분리할 수 있다. | `ADOPT`. `flow_offset` uniform만 frame마다 갱신하고, 승인한 water-only 배경 원화와 simple fragment flow를 유지한다. |

이 문서는 원리 참고만 기록한다. 특정 작품의 캐릭터 비율, UI, 보상 구조, 소셜 연결, trade dress를 복제하지 않는다.

## 현재 구현 역공학

`GameScene._process(delta)`는 매 frame `_apply_drift_motion(delta)`를 호출한다.

1. `background_flow_offset`은 speed tier에 따라 누적되고 `voyage_split_sea_flow.gdshader`의 `flow_offset` uniform으로 세 개 camera-local `SeaBackdrop`에 전달된다. static `SkyBackdrop`은 material override 없이 고정되고, shader는 sea layer에서만 horizon 아래 alpha와 느린 UV 흐름을 적용한다.
2. `BoatSpace`는 low-amplitude y bob, roll, 반복형 forward surge, lateral current를 사용한다. 이는 목적지·world traversal·save를 만들지 않는 visual context다.
3. `BoatWaterContact`와 `BoatWaterlineContact`는 BoatSpace와 같은 x/z offset과 거의 같은 y bob을 사용한다. 한쪽은 넓은 반사, 다른 한쪽은 좁은 선체 수면선이라는 역할을 가진다.
4. `standard/gentle/still`은 보트·camera·접점의 motion amplitude를 `1.0/0.5/0.0`으로 조절한다. `still`은 정지 화면이 아니라 보트 안정화이며, background water flow는 계속된다.
5. `DriftSceneryDirector`의 자연 경관 통과는 90–150초 뒤 첫 기회, 이후 120–180초의 low-density pass로 분리돼 있다. 이 경관은 보상 트랙이나 목적지가 아니다.

## 실제 renderer 확인

Windows OpenGL Compatibility renderer와 NVIDIA GeForce RTX 3050에서 별도 진단을 실행했다. normal voyage를 시작한 뒤 540×960 frame을 GPU에서 직접 읽고, 보트가 없는 열린 수면 영역 `x=20..519, y=290..679`을 4px 간격으로 비교했다.

| 항목 | 실제 결과 | 판정 |
| --- | --- | --- |
| standard 0.0→1.8초 수면 샘플 변화율 | `43.28%` | `PASS` |
| standard 1.8→3.6초 수면 샘플 변화율 | `42.86%` | `PASS` |
| still 0.0→1.8초 수면 샘플 변화율 | `41.49%` | `PASS` |
| 표준 항해 flow offset | `0.0666`까지 단조 증가 | `PASS` |
| wide/narrow contact의 보트 상대 위치 | 실제 `Sprite3D` transform이 boat drift delta에 잠김 | `PASS` |
| still에서 보트 | base position으로 복귀 | `PASS` |

두 renderer capture도 최신으로 다시 생성했다. [초기 frame](../evidence/2026-08-30-boat-float-contact/bright_boat_float_start_verified_v5_540x960.png)과 [다음 부유 frame](../evidence/2026-08-30-boat-float-contact/bright_boat_float_crest_verified_v5_540x960.png)은 보트·player·companion·두 수면 접점·열린 수면의 관계를 보존한다.

## 결론과 한계

현재 구조는 `FEASIBLE / IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_CAPTURE_VERIFIED`다. 실제 흐름은 단순 변수 변경이 아니라 GPU frame의 열린 수면 변화로, 접점 부착은 Scene transform으로, visual output은 두 renderer capture로 각각 대조했다. 따라서 이번 확인 범위에서는 추가 물리 시뮬레이션, 보상성 목적지, 새 수면 자산을 도입할 필요가 없다.

단, 이 결과는 한 Windows GPU/renderer의 기계 증거다. 실제 모바일 기기 성능, 색감, 터치, 5분 시청 중 시각 피로와 힐링감은 사용자가 Human 검증을 선언할 때까지 `NOT_RUN`이다. Godot 종료 시 `2 ObjectDB instances` warning도 발생했으므로, 이 warning은 성공 판정에 포함하지 않고 별도 engine/plugin baseline 진단 항목으로 유지한다.
