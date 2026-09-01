# 항해 전진 수면 흐름 renderer evidence

## Scope

이 evidence는 `항해 시작` 뒤 normal 3/4 diorama에서 가까운 바다가 수평선에서 화면 하단으로 흘러, 목적지나 보상 없이도 보트가 조용히 앞으로 나아가는 감각을 주는지를 확인한다. 타이틀 대기는 보트가 떠 있는 장면으로 유지하므로 voyage-only forward-water phase를 소비하지 않는다. 하늘, 수평선, 보트·동반자·선체 수면 접점의 ownership은 바꾸지 않는다.

## Capture route

`tests/capture_voyage_forward_flow.gd`는 local `GameState`에서 normal speed와 `standard` comfort를 설정한 뒤, bright normal voyage의 시작 프레임과 동일 scene에서 `2.0초` forward-water step 뒤 프레임을 Windows OpenGL Compatibility renderer로 저장한다. pixel readback은 보트 실루엣을 제외한 하단 `62–100%`의 색상 변화율이 최소 `8%`인지, 상단 `0–38%` 하늘의 변화율이 최대 `1%`인지 검사한다.

| file | surface | SHA-256 |
| --- | --- | --- |
| `bright_voyage_forward_flow_start_540x960.png` | bright normal voyage 시작 | `EFAA3450C098A0DECB8015443DE4D35A9F62D6D6FEEA1B4E89F065F66E756151` |
| `bright_voyage_forward_flow_after_540x960.png` | 같은 voyage의 `2.0초` forward-water step 뒤 | `F22D51EAA45EF76C1D2942F8F74A39EFC0504F0E6F98A612C7ABF65500DD78E4` |

## Machine boundary

NVIDIA RTX 3050 OpenGL 3.3 compatibility renderer에서 capture script는 exit `0`으로 종료했다. 실제 lower-sea changed fraction은 `0.7929`, upper-sky changed fraction은 `0.0000`이었다. 종료 시 `RestingSoundscape` generated-WAV related ObjectDB warning 두 줄은 기존 display lifecycle baseline이며, 이 receipt는 이를 forward-flow regression 또는 Human audio/device PASS로 해석하지 않는다.

이 evidence는 renderer frame proof다. 실제 기기에서의 30초·5분 휴식감, 터치, 멀미 민감성, 오디오 편안함과 release acceptance는 `NOT_RUN`이다.
