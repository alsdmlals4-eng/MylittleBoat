# 분리 하늘·흐르는 바다 런타임 증거 · 2026-08-31

**상태:** `MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`

이 디렉터리는 `GameScene`의 세 카메라가 한 장의 합성 배경을 공유하던 이전 구조를, 고정 `SkyBackdrop`과 전용 셰이더를 쓰는 `SeaBackdrop`으로 나눈 뒤의 Windows OpenGL capture 증거다. 이 결과는 실제 renderer에서 네 시간대의 두 화면이 로드·합성됐다는 증거이며, 사람의 색감 선호·5분 휴식감·멀미·기기별 가독성은 여전히 `NOT_RUN`이다.

## Renderer

- Engine: Godot `4.7.2.stable.official.ed1daf0bf`
- Renderer: OpenGL 3.3 Compatibility, NVIDIA GeForce RTX 3050, driver `572.16`
- Command surface: `tests/capture_four_time_atmosphere.gd`
- Output: 540 × 960, Normal + Appreciation for `dawn / bright / sunset / night`

## Captured frames

| file | SHA-256 | meaning |
| --- | --- | --- |
| `dawn_normal_540x960.png` | `8140BD259B9ACE031D684EE831F755B6A3D97EC47CBC85E3BF377227FC6257BD` | Dawn Normal diorama |
| `dawn_appreciation_540x960.png` | `3640E7F707CD2DFB06F01B4E857F711322A1CB7F82007CEF94AD8A082DB41B07` | Dawn sea-first Appreciation |
| `bright_normal_540x960.png` | `F5CE71B0743152EA3B9BE43042AEDA17F2136D45A62F0A73D0BCB19A4C9B16A6` | Bright Normal diorama |
| `bright_normal_flow_1p8s_540x960.png` | `8674F7BC2CB2BD40FB4B46D14F273F9798F8D1AEA67326E4ED0BFC709EAC22EA` | Bright Normal after 1.8 s visual flow |
| `bright_appreciation_540x960.png` | `37CC2F0B98A6B03F1262D937374153A918FD30DC47B4662646D386A185196466` | Bright sea-first Appreciation |
| `sunset_normal_540x960.png` | `5A97B99C9475A55353A4D5C80B0A526B1E1DD24E4F9A2533EF8E50AB4B55C796` | Corrected dusty-lilac Sunset Normal |
| `sunset_appreciation_540x960.png` | `F69FB8D8D4C3B890220C1FF4EC8363FD281DDEEF390D7EE182C976C31AC03D0B` | Corrected dusty-lilac Sunset Appreciation |
| `night_normal_540x960.png` | `DCA2A7898157DF25BFA8990821A53A369706B9B4B4F82B4E1F0074344D0B1816` | Indigo-rain Night Normal |
| `night_appreciation_540x960.png` | `E10749A000874F42484E9BEB8E5551B1790DD7E4CEA18CEF69952B6E1AB4C869` | Indigo-rain Night Appreciation |

## Frame-pair measurement

`bright_normal_540x960.png` and `bright_normal_flow_1p8s_540x960.png` were sampled at every other pixel after the flow offset advanced.

| sample region | mean absolute RGB delta | pixels above delta 12 | result |
| --- | ---: | ---: | --- |
| upper sky, `x=0..539`, `y=0..349` | `0.000` | `0.00%` | fixed |
| open sea, `x=0..539`, `y=410..589` | `9.932` | `27.70%` | flowing |
| boat-free lower sea, `x=0..149`, `y=760..869` | `13.612` | `44.90%` | flowing |

The measurement excludes the boat from the primary sea samples. The sea shader is time-driven, so successive valid capture runs may produce different exact sea-frame hashes and changed-pixel percentages. The invariant acceptance condition is a zero-delta static sky alongside a visibly and numerically changing boat-free sea, not an identical sea-frame hash. This is not a Human comfort result.

## Superseded evidence cleanup

The prior composite-water capture folder `docs/evidence/2026-08-30-water-only-atmosphere-v2/` had no remaining Scene, script, test, or documentation consumer after this exact capture set replaced it. Its eight old PNG frames and generated `.import` sidecars were removed during closeout, so this folder is the sole current machine-capture owner for split sky/sea verification.
