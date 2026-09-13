# 공통 세계 봄섬 통과 구현과 검증

## 범위와 정본

기준 HEAD `27cc4a9f32c02dd0ee56c59a37b994c361c6edc0`, branch `codex/title-boat-flow-20260831`. main `7181d5e6845e75107eade8c4d2e62e10334ab54b`, Base remote `d830c0f6967678eed3c208ac6b24f9cd1b262ec3`. 작업 시작 fetch와 열린 PR 확인 결과 다른 PR #19만 OPEN이며 수정하지 않았다. 프로젝트 adapter v9.4.4와 Base 검증기는 그대로 통과했다. 최신 Base template의 2회 검토 드리프트는 조사 입력이고 프로젝트의 5회 계약을 자동 교체하지 않았다. AgentMemory MCP 도구는 현재 목록에 없어 과거 세션을 조회했다고 주장하지 않으며 실제 파일을 사용했다. Hera status는 다른 프로젝트 Switchy Express를 가리켜 조작하지 않고 프로젝트가 허용한 CLI fallback을 사용했다.

## 문제 → 비교 → 선택

카메라마다 별도 섬이 존재해 시점 전환이 동일 장소의 관찰이 아니었다. [Godot SpriteBase3D](https://docs.godotengine.org/en/stable/classes/class_spritebase3d.html)의 world 투영·billboard·깊이 검사와 [3D 최적화 문서](https://docs.godotengine.org/en/stable/tutorials/performance/optimizing_3d_performance.html)의 원경 표현/투명 겹침 비용을 확인했다. [DREDGE 개발자 인터뷰](https://www.gamedeveloper.com/design/trawling-in-the-deep-how-black-salt-games-made-spooky-fishing-rpg-i-dredge-i-)에서는 표현용 파도와 게임 이동을 분리한 제작 결정을 참고한다. 해당 작품의 전투·공포·실패·목표는 가져오지 않았다.

| 대안 | 판정 | 이유 |
| --- | --- | --- |
| 카메라별 2D 복제·독립 통과 | REJECT | 현재 자산으로 가능하지만 시점마다 다른 세계 위치와 lifecycle 중복이 남음 |
| 세계 앵커 하나와 원경 billboard | ADAPT | 승인 PNG·실제 route 재사용, 한 lifecycle, 상대 투영으로 통과. 근거리 입체 지형은 아님 |
| 실제 모델 지형 전체 | DEFER | 근거리 품질에는 적합하지만 현재 모델/리그와 새 수면 준비 없이 이번 단위의 성공으로 주장할 수 없음 |

`scenes/game.tscn`에 world Sprite3D 하나를 두고 `game_scene.gd`가 앵커를 ±4 x, -2.3 y, route z+3.5에 배치한다. 대각 반경+1.25 여유를 보장한다. 보트의 +Z 이동만 진행도를 변화시키며, 6.5 units 뒤 정리한다. standard speed 1에서는 약 20.31초다. 세 camera shared layer 1은 같은 위치를 관찰하며 일반 motif의 camera 전용 layer는 그대로다. 저장·보상·발견 확률·아트 bytes·소리는 production에서 변경하지 않았다.

## 실제 교정

- world 노드가 없는 기존 구현에서 신규 검사 RED를 확인하고 연결 후 GREEN을 확인했다. 초기 테스트의 GameState 오염은 여섯 격리 저장 경로와 테스트 순서로 교정했다.
- 첫 카메라 유도 앵커는 기본 화면에 거의 안 보여 실제 GPU 이미지 확인 뒤 고정 항로 배치로 교정했다. 이것을 자연스러운 전체 3D 경험 완료로 확대하지 않는다.
- 독립 read-only 검토는 world 처리의 코드 MUST_FIX를 찾지 못했지만, 기존 촬영기의 foreground=false·과거 폴더 덮어쓰기와 headless에서 GPU 성공처럼 끝나는 문제를 확인했다. 촬영기는 새 절대 폴더/격리 저장을 쓰는 공통 probe로 통합했다. 실제 headless 재현에서 PNG 0개/exit 0이었던 RED를 확인했고, 교정 후 새 폴더를 만들지 않고 exit 2로 거부했다.
- 존재하는 문자열만 보던 촬영 검사는 제거하고 실제 GPU 이미지의 grass pixel 표본·앵커·카메라·퇴장을 검사한다. 이 색 표본은 범용 이미지 인식/최종 UX 인증이 아니다.
- GPU 수면 테스트에서 AudioStreamWAV/AudioStreamPlaybackWAV 2개가 종료 시 남는 현상을 verbose로 재현했다. 테스트 teardown에서 기존 autoload shutdown을 먼저 호출하고 처리 프레임을 기다리도록 수정했다. production soundscape나 실제 플레이 소리는 바꾸지 않았다.

## 검증

- 전체 headless 61/61, Python 20/20. 이때의 source identity는 `verification.json`에 기록한다. 이후 테스트 teardown만 바꾼 항목은 별도 재실행한다.
- 실제 Mobile/Vulkan, RTX 3050, Godot 4.7.2. 물리 모바일 기기 검증이 아니다.
- [GPU 시점 표본](projection/projection.json). normal/Appreciation/LookAround 중립·좌측·반대편 관찰의 필수 5개 표본에서 섬 색상 표본 각각 1440/1227/1419/1985/3006, capture_errors 0. 같은 앵커가 이동하지 않으며 실제 배가 지난 뒤 퇴장했다. 수동 delta 표본이다.
- [실제 30초 재생](verified-runtime/voyage-30s.webp), [분석](verified-runtime/motion-analysis.json). 실제 process 30.211초/152frame, foreground fixture, contact 최대 상대오차 0.00415945, 하늘 오차 1/255, 전진 음수 step 없음. 픽셀 유속 추정은 지나가는 섬의 영향을 받을 수 있으므로 수면 유속 측정/물리 성능 인증으로 해석하지 않는다.
- [10초 실제 화면](verified-runtime/voyage-10s.png). 승인 기존 보트·동반자와 원경 통과를 확인했다. 새 art/model이 아니다.

## 다섯 범위 검토 기록

동일 product source `game_scene.gd=C9879595…`, `game.tscn=3C14B406…`를 기준으로 각 회에 현재 범위·실제 consumer·보호 경계·대안을 다시 읽고 계절/route/overlay/motion의 네 계약을 재실행한다. 이것은 게임 전체의 다섯 제품 개선을 뜻하지 않는다. 시간은 KST다.

| 회차 | 읽기·공격 관점 / 교정 | 회귀·재확인 |
| --- | --- | --- |
| 1, 09:02:29–09:02:43 | 현재 diff·route·계절 계약 전체, 앵커/중앙 항로/장거리/의도치 않은 저장 쓰기. 새 finding 없음 | 네 headless 계약 통과, GPU 부분 명시 skip. 별도 전체 61/Python20 통과. 카메라 복제보다 공통 앵커가 작은 구조 |
| 2, 09:03:16–09:03:24 | route 소비 순서·show/fade/clear·일반 풍경·보호 디렉터리 diff·P5/P8/P9. 새 finding 없음 | 네 headless 계약 통과, PNG/보상/저장/소리 production diff 없음. 현재 원경에는 모델 서비스 도입 불필요 |
| 3, 09:03:41–09:03:55 | capture 전체·호환 진입점·handoff·exact source 재독. GPU 종료 AudioStream 자원 경고 발견 | 계절/route headless와 overlay/motion GPU 기능 검사는 통과했으나 경고는 해결 완료로 처리하지 않고 다음 회차 조사 |
| 4, 09:04:17–09:06:46 | verbose에서 AudioStreamWAV/PlaybackWAV 확인, pause/overlay/공통 범위 재독. 테스트 종료 순서만 교정 | GPU verbose 3회 leak 0, shader 오류 0. 네 scope 계약 재실행 통과. production 소리 변경 대신 teardown 재사용 |
| 5, 09:07:52–09:08:00 | 최종 diff/owner/자산/도구/변경하지 않은 director 및 보호 consumer 재검토. 새 finding 없음 | 네 scope 계약 통과, source/승인 PNG hash 동일. 단일 원경 billboard보다 더 작은 올바른 대안 없음. 공통 물/모델 미완료는 다음 제품 범위로 유지 |

중간 촬영과 압축 완료한 raw frame 172개, 84,506,173 bytes는 프로젝트 밖 `C:/Users/user/Desktop/MyLittleBoat_삭제대기_20260913/world-island-intermediate`로 이동했다. 이동 전후 SHA-256을 검증했으며 sibling `world-island-intermediate-manifest.json`에 원래/현재 위치·사유·파일별 hash를 기록했다. 직접 삭제하지 않았다. 최종 projection·재생·source-bound 분석은 이 evidence 폴더에 남겼다. source/정본 검토와 별도로 remote branch readback을 수행하며 main/다른 PR은 변경하지 않는다.

## 재사용·잔여 작업

기존 승인 PNG·route·계절 director·overlay·capture clock을 재사용했다. 하나의 GPU 촬영 진입점에 새 출력 폴더와 capability 거부를 모아 반복 오류를 줄였다. Base evidence ceiling과 capture capability 원칙을 보강하는 프로젝트 사례이며 새 Base module/skill 또는 vendor 설치는 하지 않았다. 실패 시 이 논리 commit만 되돌리고 승인 이미지/과거 증거/다른 PR은 보존한다.

현재 상태는 **원경 봄섬 통과 IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_VERIFIED_BOUNDED**다. 일반 motif·수면·하늘의 전체 세계 공간화, 실제 모델/리그/가림·전체 시간대/외형 family, 저장 실패 복구, 배포 빌드와 긴 soak는 남아 있다. Human/Device/Release는 NOT_RUN이다. 후면 정적 카드가 회전에서 화면을 벗어나는 기존 한계를 이 원경 작업으로 해결했다고 하지 않는다. 전체 게임 완료는 아니다.
