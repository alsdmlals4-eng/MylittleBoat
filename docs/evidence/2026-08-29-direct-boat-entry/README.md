# Direct boat entry runtime evidence · 2026-08-29

## 실행 조건

- Godot `4.7.2.stable.official.ed1daf0bf`
- Windows OpenGL Compatibility renderer
- NVIDIA GeForce RTX 3050
- target viewport `540 x 960`
- runner `tests/capture_direct_boat_entry_atmospheres.gd`

## 파일과 확인 범위

| file | confirms |
| --- | --- |
| `dawn_normal_540x960.png` | direct-entry normal diorama가 dawn tone으로 렌더된다. |
| `bright_normal_540x960.png` | compact `메뉴`만 보이는 first view와 boat-water wake consumer가 렌더된다. |
| `sunset_normal_540x960.png` | 같은 composition에 sunset tone이 적용된다. |
| `night_normal_540x960.png` | 전용 indigo-rain night sea art와 warm boat light가 렌더된다. |
| `bright_distant_islet_540x960.png` | `DistantSceneryLayer`의 islet consumer가 horizon에 렌더된다. |

## 재현 방법

```powershell
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --rendering-method gl_compatibility --path . --script res://tests/capture_direct_boat_entry_atmospheres.gd
```

islet capture는 prop의 보임을 검증하려고 runner가 같은 runtime prop을 frame 안 `x=24`에 잠시 둔다. 정상 play에서는 prop이 screen 밖 horizon에서 생성돼 foreground-only drift rate로 들어온다.

## evidence ceiling

이 파일들은 renderer가 위 장면을 실제로 그렸다는 증거다. 실제 기기에서의 first 30 seconds, five-minute calm, touch reachability, time-boundary transition의 지각, scenery density, notification quietness, audio comfort, performance는 아직 `NOT_RUN`이다.
