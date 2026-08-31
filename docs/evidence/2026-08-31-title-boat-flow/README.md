# 2026-08-31 타이틀 보트와 기본 바다 흐름 GPU 증거

이 폴더는 `Godot 4.7.2.stable`, Windows NVIDIA RTX 3050, OpenGL Compatibility renderer에서 실제 `scenes/game.tscn`을 `540×960`으로 렌더한 기계 캡처다.

- `bright_title_idle_00_540x960.png`는 밝은 시간대 타이틀 대기 첫 프레임이다. `MLB-BRAND-TITLE-001`과 실제 `BoatSpace`가 함께 보이고, 항해는 아직 시작하지 않는다.
- `bright_title_idle_02_540x960.png`는 같은 타이틀 대기에서 2초 뒤 프레임이다. 수평선 아래 water-only texture flow와 low-amplitude boat/contact motion의 시간차 확인용이다.
- `bright_voyage_started_00_540x960.png`는 `start_voyage_from_title()` 직후 프레임이다. 타이틀 overlay가 사라지고 `쉬는 메뉴`가 열리는 것을 확인한다.
- `bright_voyage_started_02_540x960.png`는 항해 시작 2초 뒤 프레임이다. speed-tier 기반 background flow와 boat/contact drift의 시간차 확인용이다.

두 2초 frame pair의 boat와 UI를 피해 아래 수면 영역 `y=650..850`만 비교했다. title idle pair는 `108,540` pixel 중 `101,132` pixel, 즉 `93.17%`가 RGB absolute delta `>3`으로 바뀌었고 mean RGB absolute delta는 `7.901`이었다. voyage pair는 `104,173` pixel, 즉 `95.98%`가 바뀌었고 mean delta는 `9.674`였다. 따라서 명소 event와 항해 progress와 무관하게 아래 수면 texture가 실제 renderer frame에서 연속 이동했다는 machine evidence가 된다.

이 이미지들은 renderer가 실제 장면을 그렸다는 증거다. 보트가 물 위에 충분히 자연스럽게 느껴지는지, 타이틀·버튼·텍스트가 실제 기기에서 편안한지는 Human 검증 전까지 `NOT_RUN`이다. 기존 큰 ring asset의 선체 하단 접점 한계는 별도 `GENERATED_CANDIDATE` waterline raster의 user `LOCK` 여부가 결정되기 전까지 해결 완료로 표시하지 않는다.
