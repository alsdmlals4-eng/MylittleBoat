# 승인된 waterline contact v2 GPU 증거

## 범위

사용자가 2026-08-31에 승인한 `MLB-BOAT-FLT-006` 수면 접점 원화를 실제 `GameScene/VoyageWorld/BoatWaterlineContact`가 소비하는지, 그리고 보트가 540×960 세로 화면의 하단 20% 부근에 배치된 상태에서도 캐릭터·동반자·`쉬는 메뉴`를 가리지 않는지 확인한 기계 렌더 증거입니다.

## 실행 환경

- Godot `4.7.2.stable.official.ed1daf0bf`
- Windows OpenGL Compatibility renderer
- NVIDIA GeForce RTX 3050, OpenGL `3.3.0 NVIDIA 572.16`
- 시각 시간대. `bright`
- `GameScene.apply_real_time_atmosphere_for_hour(12)` 뒤 title waiting과 `start_voyage_from_title()`을 각각 캡처

## 보존 파일

| 파일 | SHA-256 | 관찰 가능한 사실 |
| --- | --- | --- |
| `bright_title_waterline_540x960.png` | `74900E525ABE6A5496C63A2F8C7526BAB84B803FEBB4F26A54A9716FBDC9C4F2` | 타이틀 대기에서 하단 보트, 얇은 양옆 waterline, 로고·시작 버튼의 분리 |
| `bright_voyage_waterline_540x960.png` | `5AD5D0629F91AE76812F80282F10144ADB9296CAE07A6CC2F0D3EC71C2E3B00A` | 항해 시작 뒤 같은 하단 보트, waterline, `쉬는 메뉴`의 비중첩 |
| `bright_appreciation_after_lower_frame_540x960.png` | `240F604AE65C6F36D133EF4F18E59FD9B9CFAE8117699A47FD5DA8167448E087` | 감상 전환 뒤 normal 보트·두 접점이 숨겨진 바다·수평선과 비중첩 `감상 끝내기` |

이 capture는 named texture·Scene node·OpenGL renderer가 통합됐다는 기계 증거입니다. 실제 모바일 기기 색감, 터치, 장시간 모션·시각 피로와 휴식감은 사람 검증 전까지 `NOT_RUN`입니다.
