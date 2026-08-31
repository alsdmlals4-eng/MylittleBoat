# Look Around Camera Design

## Status

```text
DECISION = USER_APPROVED_RECOMMENDED_DIRECTION_2026-08-30
SCOPE = LOCAL_FIRST_LOOK_AROUND_PRESENTATION
ANGLE_ART = USER_APPROVED_CANON_REGISTERED_IMPLEMENTED_RUNTIME_CAPTURE_VERIFIED_2026-08-30
HUMAN_PLAYER_EXPERIENCE_VALIDATION = NOT_RUN
```

## 1. Goal

보트 위의 플레이어와 동반자가 바다를 함께 지나가는 현재 Normal Diorama에서, 플레이어가 손가락 드래그 또는 PC 드래그로 주변을 천천히 둘러볼 수 있게 한다. 뒤·좌우·위에서 본 장면은 사용자가 제공한 참고 이미지의 잔잔한 물결, 낮은 속도의 항해, 푸른 생물발광 분위기를 참고하되 특정 서비스의 캐릭터·UI·브랜드를 복제하지 않는다.

이 기능에서 멈춰 서서 바라보는 것 자체가 완전한 플레이이다. 카메라를 돌린다는 행위는 목적지, 수집, 보상, 진행도, 속도, 항해 시간, 저장 데이터, 사운드스케이프를 바꾸지 않는다.

## 2. Current problem

현재 `game.tscn`에는 Normal Diorama와 Appreciation Camera만 있으며, `DioramaCamera3D`의 배경과 `BoatSpace`의 최종 보트는 정면용 평면 합성 소비자다. 기존 `boat_camera_controller.gd`는 Appreciation Camera가 현재일 때만 화면 드래그를 회전으로 처리한다.

따라서 평면 이미지를 단순히 3D로 공전시키면 다음 문제가 생긴다.

- 배와 배경이 실제로 옆·뒤·위에서 보인다는 인상을 주지 못한다.
- 카메라에 붙은 배경 카드가 시점과 함께 움직여, 회전의 공간감을 잃는다.
- 기술용 primitive 보트가 다시 보이면 이미 승인된 최종 보트 원화와 충돌한다.

이 문제를 카메라 수치만 바꿔 해결했다고 주장하지 않는다. 실제 각도에 맞는 보트·바다 원화와, 그 원화를 입력에 연결하는 가벼운 2.5D presentation router를 함께 사용한다.

## 3. Binding behaviour

### 3.1 Camera modes

| Mode | Entry | View | Exit |
| --- | --- | --- | --- |
| `diorama` | 게임 시작 | 현재 승인된 3/4 보트·동반자·바다 | `둘러보기`, `감상모드` |
| `look_around` | `둘러보기` 버튼 | 드래그가 선택한 앞·좌·우·뒤·위 시점의 조용한 보트 장면 | `기본 시점`, `감상모드`, Album/꾸미기 진입 |
| `appreciation` | 기존 `감상모드` 버튼 | 기존 수평선 중심 감상 카메라 | 기존 `감상 끝내기` |

- `look_around`는 scene-local presentation 상태다. `GameState`에 저장하지 않으며, 앱 재시작이나 새 항해는 항상 `diorama`에서 시작한다.
- `Appreciation Camera`는 그대로 보존한다. Appreciation이 켜지면 Look Around는 종료되고, Appreciation을 끝내면 기본 3/4 시점으로 돌아온다.
- 꾸미기·Album·사진·낚시·상호작용을 열면 Look Around를 안전하게 종료한다. 이들은 각자의 기존 입력을 우선한다.
- 동작 중 선택된 각도는 그대로 유지한다. 관성 자동 회전, 카메라 흔들림, 줌, 번쩍임, 보상 효과, 자동 재설정은 추가하지 않는다.

### 3.2 Input and comfort

- PC에서는 왼쪽 버튼을 누른 채 드래그, 모바일에서는 `InputEventScreenDrag`로만 회전한다.
- UI Control이 처리한 입력은 빼앗지 않는다. 카메라는 `_unhandled_input`에서만 동작한다.
- yaw는 `-135°`에서 `135°`, pitch는 `-16°`에서 `38°`로 제한한다. 수평선은 항상 수평을 유지한다.
- 각도 버킷은 `front`, `port`, `starboard`, `aft`, `overhead`다. `front`는 기존 승인 Normal Diorama를 계속 사용한다.
- 화면 폭이 좁은 세로 모바일을 기준으로 한다. 회전 안내 문구는 하나의 짧은 정적 문장만 사용하며, HUD를 늘리지 않는다.

Godot `Camera3D.current`는 Viewport의 현재 카메라를 결정하며, 한 Viewport 안에서 하나만 현재가 된다. 따라서 이 기능은 camera state 전환을 명시적으로 한 곳에서 관리한다. [Godot Camera3D](https://docs.godotengine.org/en/4.7/classes/class_camera3d.html) `InputEventScreenDrag.relative`는 모바일 드래그 델타를 제공하므로, PC와 터치에서 동일한 회전 계약을 만들 수 있다. [Godot InputEventScreenDrag](https://docs.godotengine.org/en/4.7/classes/class_inputeventscreendrag.html)

### 3.3 Approved angle-art registry and boundary

다음 네 장은 사용자가 승인한 `MLB-LOOK-STYLE-006` family의 canonical runtime asset이다. `LookAroundPresentationRouter`는 이 exact paths만 선택하며, `front` 또는 unknown request는 기존 Normal Diorama로 fallback한다.

| Angle id | Player view | Required visual content |
| --- | --- | --- |
| `port` | 왼쪽 옆면 | 낮은 선체, 잔물결, 동반자가 보이는 편안한 좌현 |
| `starboard` | 오른쪽 옆면 | 좌현과 혼동되지 않는 우현, 같은 시간대의 물결과 빛 |
| `aft` | 뒤쪽 | 보트가 잔잔히 나아가며 남기는 낮은 물결과 먼 수평선 |
| `overhead` | 위쪽 | 배·플레이어·동반자와 물 위 생물발광을 한 번에 읽는 조감 |

- 네 asset은 2.25등신 chibi player, round butter-cream dog, matte ivory + deep-teal rounded dinghy, soft cocoa outline, transparent aquamarine-to-indigo water라는 승인된 공통 언어를 쓴다. UI·문자·로고·브랜드 요소·전투·위협적인 생물은 넣지 않는다.
- 바다 생물발광은 낮은 밀도의 부드러운 관찰 요소다. 수집물, 점수, 위험 신호, 타이머, 목표표식이 아니다.
- `port`, `starboard`, `aft`, `overhead`는 각각 canonical registration, router mapping, GameScene consumer, 540×960 GPU capture까지 완료했다. human/device comfort, touch reachability, long-run calm은 여전히 `NOT_RUN`이다.
- 기존 `lantern_off` family와 generated historical candidates는 보존하지만 현재 router가 소비하지 않는다.
- 향후 추가 각도 또는 기본 Normal Diorama replacement는 별도 candidate → user approval → canonical registration gate를 다시 따른다.

## 4. Alternatives reviewed

| Alternative | Decision | Reason |
| --- | --- | --- |
| A. angle-specific approved images + local input router | **ADOPT** | 현재 승인된 2D 최종 합성을 존중하면서 실제로 다른 각도라는 시각적 결과를 만든다. |
| B. existing flat card를 360° 공전 | REJECT | 보트와 배경이 회전해 보이지 않아 사용자 요구를 충족하지 못한다. |
| C. technical meshes/primitives를 final boat로 재활성화 | REJECT | 초기 기술 시안을 최종 화면으로 되돌리고 승인된 원화의 품질·일관성을 훼손한다. |
| D. full realtime 3D boat/ocean rebuild | DEFER | 장기적으로 가능하지만 현존 2D consumer와 이미 승인된 자산을 광범위하게 교체해야 하며, 지금 필요한 휴식 화면 품질을 더 빨리 높이는 최소 변경이 아니다. |

## 5. Data and scene flow

```text
LookAroundButton
  -> GameScene._toggle_look_around_mode()
  -> GameScene explicit camera state routing
  -> LookAroundCameraController accepts only active unhandled drag
  -> angle bucket signal (front / port / starboard / aft / overhead)
  -> LookAroundPresentationRouter chooses approved angle art

GameState voyage timer / together time / speed / local save
  -> unchanged
```

## 6. Acceptance criteria

1. 게임은 기존 Normal Diorama로 직접 시작하고 `둘러보기`를 누를 때만 Look Around로 들어간다.
2. Look Around가 활성일 때만 PC와 터치 드래그가 회전한다. 비활성 Normal Diorama와 Appreciation Camera는 해당 입력을 소비하지 않는다.
3. yaw·pitch clamp와 0 roll 계약이 자동 테스트로 검증된다.
4. `front`, `port`, `starboard`, `aft`, `overhead` 버킷 선택은 결정적이다. 네 승인 angle은 exact canonical texture를 쓰며 `front`와 unknown request는 기존 승인 정면 화면으로 안전하게 fallback한다.
5. 감상모드·꾸미기·Album 진입은 Look Around를 종료하고 다른 camera state와 동시에 활성화되지 않는다.
6. Look Around 진입·드래그·복귀는 항해 남은 시간, speed, together time, photo/scenery/fish/letter/ambient-memory, boat decor, identity와 local save를 바꾸지 않는다.
7. 현재 네 approved angle art는 canonical runtime asset, router consumer, focused contracts, 540×960 GPU capture까지 완료했다. 이 상태는 Human UX approval이 아니다.
8. 향후 art replacement 또는 camera behavior 변경 뒤에는 Godot headless checks, focused contracts, 540×960 GPU capture, `git diff --check`를 다시 수행한다. 사람의 motion comfort, touch reachability, 실제 기기 readability는 `NOT_RUN`으로 남긴다.

## 7. Evidence boundary and adversarial review

- 첨부 이미지는 사용자의 분위기·각도 참고이며, 그 안의 앱·캐릭터·UI는 이 프로젝트의 정본이나 구현 지시가 아니다.
- 자동 계약은 카메라 상태, 입력 분리, clamp, 데이터 불변만 증명한다. 실제 휴식감·멀미·미적 완성·유사성 위험은 증명하지 않는다.
- 이 기능은 local-first이고 backend, bottle, public social, 랭킹, 광고, 결제, 전투, 실패 상태를 추가하지 않는다.
- 사용자 승인 전 새 이미지는 후보로만 보관한다. candidate 상태를 runtime production evidence로 넘기지 않는다.
