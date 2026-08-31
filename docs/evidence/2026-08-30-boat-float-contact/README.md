# 보트 부유·수면 접점 최신 GPU 재검증

## 범위

이 디렉터리는 기존 보트 부유 증거의 owner를 유지하면서, 2026-08-31 하단 20% 프레이밍과 user-approved `MLB-BOAT-FLT-006` narrow waterline contact가 적용된 current branch에서 두 실제 GPU frame을 다시 생성한 결과를 보관합니다.

## 실행 환경

- Godot `4.7.2.stable.official.ed1daf0bf`
- Windows OpenGL Compatibility renderer
- NVIDIA GeForce RTX 3050, OpenGL `3.3.0 NVIDIA 572.16`
- `GameScene` bright normal voyage, 540×960
- `tests/capture_boat_float_contact.gd`가 initial frame 뒤 `_apply_drift_motion(1.45)`를 적용해 crest frame을 저장

## 보존 파일

| 파일 | SHA-256 | 관찰 가능한 사실 |
| --- | --- | --- |
| `bright_boat_float_start_verified_v5_540x960.png` | `25D1A768692B3F7883EFD8350EEC0406D038DCA4D422D92AD5AA0AB1444C8C3B` | 하단 20% 근처의 primary boat, player·companion, 넓은 ripple과 좁은 waterline contact가 함께 보입니다. |
| `bright_boat_float_crest_verified_v5_540x960.png` | `8A8531712E394EF946A7F72AA270D281CC02591868318CE3E2B2439E94D0F1C8` | 같은 consumer가 다음 부유 위상에서 미세하게 이동하고, 수면 접점과 `쉬는 메뉴`가 분리된 상태를 보입니다. |

이 두 이미지는 renderer 통합 증거입니다. 실제 모바일 기기에서의 장시간 휴식감, 모션 민감성, 터치 도달성은 별도 Human 검증 전까지 `NOT_RUN`입니다.
