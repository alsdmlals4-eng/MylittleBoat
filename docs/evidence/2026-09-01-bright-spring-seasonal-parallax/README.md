# Bright/spring seasonal parallax runtime evidence

## Scope

`bright + spring` injected visual context에서만 actual `SeasonalCloudLayer`와 `SeasonalIslandLayer`를 표시한 Windows OpenGL renderer evidence다. 꽃섬은 source PNG를 바꾸거나 복제하지 않고 `Sprite3D.region_enabled`의 `Rect2(632, 350, 1028, 350)`만 사용해 수평선의 원거리 landmark로 표시한다. 정적 하늘, flowing sea, 하단 보트 foreground와 별도 depth를 확인하며, 계절 UI·저장·보상·목적지는 검증하거나 만들지 않는다.

## Capture route

`tests/capture_bright_spring_seasonal_parallax.gd`가 local `GameState` 항해를 시작하고, `apply_real_time_visual_context_for_tests(12, 4)`와 deterministic 꽃섬 event를 사용한다. 실제 7초 drift 뒤에도 injected `bright + spring` context가 유지되는지를 다시 확인하고, normal frame을 저장한 뒤 Appreciation으로 전환해 두 번째 frame을 저장한다. capture는 actual cloud/island texture와 runtime-local chroma material을 먼저 assert하고, normal image의 상단 cloud mark, 중간 수평선 band의 꽃섬 mark, 하단 64% boat lane에서 fixed boat silhouette 밖의 섬 색상 부재를 검사한다.

| file | surface | resolution | SHA-256 |
| --- | --- | --- | --- |
| `bright_spring_normal_540x960.png` | normal 3/4 diorama | `540×960` | `C6B652B85D83E30C54406EFA0646248A52761F81DA059D807920B2638E330E7C` |
| `bright_spring_appreciation_540x960.png` | Appreciation Camera | `540×960` | `291E141B8021E46A20A613AA91E3238D59227A9E0891C58A08F8B8F3C9B010F0` |

## Machine boundary

Windows NVIDIA RTX 3050 OpenGL 3.3 compatibility renderer에서 capture script는 exit `0`으로 종료했다. 실제 display process는 `RestingSoundscape` generated WAV와 관련한 두 ObjectDB shutdown line을 남긴다. 프로젝트의 minimal display reproduction도 explicit stream release 뒤 같은 line을 재현하므로, 이 receipt는 해당 warning을 seasonal parallax source regression이나 Human audio/device PASS로 해석하지 않는다.

이 evidence는 renderer frame proof다. 실제 기기 색감·터치·5분 휴식감·모션·오디오 편안함·release acceptance는 `NOT_RUN`이다.
