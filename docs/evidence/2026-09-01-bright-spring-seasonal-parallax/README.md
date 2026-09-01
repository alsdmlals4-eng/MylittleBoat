# Bright/spring seasonal parallax runtime evidence

## Scope

`bright + spring` injected visual context에서만 actual `SeasonalCloudLayer`와 `SeasonalIslandLayer`를 표시한 Windows OpenGL renderer evidence다. 정적 하늘, flowing sea, 하단 보트 foreground와 별도 depth를 확인하며, 계절 UI·저장·보상·목적지는 검증하거나 만들지 않는다.

## Capture route

`tests/capture_bright_spring_seasonal_parallax.gd`가 local `GameState` 항해를 시작하고, `apply_real_time_visual_context_for_tests(12, 4)`와 deterministic 꽃섬 event를 사용한다. normal frame을 저장한 뒤 Appreciation으로 전환해 두 번째 frame을 저장한다. capture는 actual cloud/island texture와 runtime-local chroma material을 먼저 assert하고, normal image 상단 40%에 밝은 cloud mark가 남았는지도 검사한다.

| file | surface | resolution | SHA-256 |
| --- | --- | --- | --- |
| `bright_spring_normal_540x960.png` | normal 3/4 diorama | `540×960` | `05620478B85A1C86D5E3D4EC7735C69B21C2DF43F7EB21918FD9EC655D6B3AE7` |
| `bright_spring_appreciation_540x960.png` | Appreciation Camera | `540×960` | `6DDC2C5C882EB95F435140C2E72C0D100585AEA378DAF72A9B1FA528C58F1235` |

## Machine boundary

Windows NVIDIA RTX 3050 OpenGL 3.3 compatibility renderer에서 capture script는 exit `0`으로 종료했다. 실제 display process는 `RestingSoundscape` generated WAV와 관련한 두 ObjectDB shutdown line을 남긴다. 프로젝트의 minimal display reproduction도 explicit stream release 뒤 같은 line을 재현하므로, 이 receipt는 해당 warning을 seasonal parallax source regression이나 Human audio/device PASS로 해석하지 않는다.

이 evidence는 renderer frame proof다. 실제 기기 색감·터치·5분 휴식감·모션·오디오 편안함·release acceptance는 `NOT_RUN`이다.
