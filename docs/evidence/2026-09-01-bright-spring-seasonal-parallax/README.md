# Bright/spring seasonal parallax runtime evidence

## Scope

`bright + spring` injected visual context에서만 actual `SeasonalCloudLayer`와 `SeasonalIslandLayer`를 표시한 Windows OpenGL renderer evidence다. 꽃섬은 source PNG를 바꾸거나 복제하지 않고 `Sprite3D.region_enabled`의 `Rect2(632, 350, 1028, 350)`만 사용해 수평선의 원거리 landmark로 표시한다. 정적 하늘, flowing sea, 하단 보트 foreground와 별도 depth뿐 아니라, 하나의 island transit 안에서의 실제 좌우 이동도 확인한다. 계절 UI·저장·보상·목적지는 검증하거나 만들지 않는다.

## Capture route

`tests/capture_bright_spring_seasonal_parallax.gd`가 local `GameState` 항해를 시작하고, `apply_real_time_visual_context_for_tests(12, 4)`와 deterministic 꽃섬 event를 사용한다. event route를 즉시 assert한 뒤 같은 14초 transit의 `6.5초`, `7.0초`, `7.5초` normal frame과 Appreciation frame을 저장한다. capture는 actual cloud/island texture와 runtime-local chroma material을 먼저 assert하고, 모든 normal image의 상단 cloud mark, 중간 수평선 band의 꽃섬 mark, 하단 64% boat lane에서 fixed boat silhouette 밖의 섬 색상 부재를 검사한다. early/late island silhouette center는 최소 `80px` 달라야 하며, 이 receipt의 실제 측정값은 `213px`다.

| file | surface | resolution | SHA-256 |
| --- | --- | --- | --- |
| `bright_spring_normal_motion_early_540x960.png` | normal 3/4 diorama, transit `6.5초` | `540×960` | `8835313FA37A34C71515AD209C8840605154B0D4F8AEE01B3BE261CBA8BDF807` |
| `bright_spring_normal_540x960.png` | normal 3/4 diorama, transit `7.0초` | `540×960` | `5A48536CDBEDAE201C44FB17197DAB472B5319D8F1857D88EA5AC28209CB0612` |
| `bright_spring_normal_motion_late_540x960.png` | normal 3/4 diorama, transit `7.5초` | `540×960` | `3D24220D963CD9FEAAA01771C2FD5E7BF555709FFF6E4458C8B342E17AC6D5C8` |
| `bright_spring_appreciation_540x960.png` | Appreciation Camera | `540×960` | `CDAD65F80E3D5BA6BCDEE3E14D4E0DC62C8F883E1528AC2CA41A674EDFB25B6C` |

## Machine boundary

Windows NVIDIA RTX 3050 OpenGL 3.3 compatibility renderer에서 capture script는 exit `0`으로 종료했고, early/late island center displacement는 `213px`였다. 실제 display process는 `RestingSoundscape` generated WAV와 관련한 두 ObjectDB shutdown line을 남긴다. 프로젝트의 minimal display reproduction도 explicit stream release 뒤 같은 line을 재현하므로, 이 receipt는 해당 warning을 seasonal parallax source regression이나 Human audio/device PASS로 해석하지 않는다.

이 evidence는 renderer frame proof다. 실제 기기 색감·터치·5분 휴식감·모션·오디오 편안함·release acceptance는 `NOT_RUN`이다.
