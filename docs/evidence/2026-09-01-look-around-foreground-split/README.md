# Look Around foreground split GPU evidence · 2026-09-01

**상태:** `RUNTIME_CAPTURE_VERIFIED`이며 Human/device UX 검증은 `NOT_RUN`이다.

## 목적

`port`·`starboard`·`aft`·`overhead`의 `MLB-LOOK-FG-001..004` foreground가 static `SkyBackdrop`와 separate flowing `SeaBackdrop` 위에 실제로 합성되는지 확인한다. 이는 user-locked board의 runtime evidence이지, 사람의 장시간 편안함·터치 reachability·최종 시각 승인 증거는 아니다.

## 실행 증거

- Surface: `tests/capture_look_around_chibi_views.gd`
- Renderer: Windows display driver, OpenGL 3.3.0 NVIDIA 572.16, NVIDIA GeForce RTX 3050
- Resolution: `540 × 960`
- Saved captures: `normal_540x960.png`, `port_540x960.png`, `starboard_540x960.png`, `aft_540x960.png`, `overhead_540x960.png`, `appreciation_540x960.png`
- The capture script asserts exact foreground paths, visible sky, visible sea, and a `ShaderMaterial` on the sea before every angle save.

## Port flow frame pair

`port_540x960.png`와 `port_flow_1800ms_540x960.png`은 같은 non-front Look Around angle을 1.8초 간격으로 저장한 pair다. sampled static-sky region change는 `0.00%`, sampled open-sea region change는 `58.44%`와 mean RGB delta `13.487`이었다. 따라서 이 receipt에서 확인한 범위에서는 foreground route가 흐르는 바다를 static composite로 대체하지 않는다.

## 경계

- The source sprites use a production chroma matte because the host image model did not emit direct RGBA alpha. `assets/shaders/look_around_foreground_chroma_key.gdshader` removes only that matte at runtime.
- This GPU receipt does not prove a physical device, Human review, accessibility, 5-minute comfort, or release readiness.
