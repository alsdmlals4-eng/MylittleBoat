# 실제 항해 경로의 첫 생산 연결

기준 HEAD는 `31aa8339a62be2a0e0f37619fd31771baa0eb103`이다. 사용자가 실제 3D 항해 권장안을 승인했으며 이번 단위는 직선 Path3D 구간 carry와 기존 배·카메라·접점 연결이다. 원격 main `7181d5e6845e75107eade8c4d2e62e10334ab54b`, Base remote `d830c0f6967678eed3c208ac6b24f9cd1b262ec3`를 읽었고 v9.4.4 채택은 유지했다. 다른 PR #19는 읽기만 했다.

## 문제·선택·실제 구현

이전 512-unit modulo는 배와 카메라가 함께 되돌아가 배경 카드만으로는 감춰졌지만, 실제 세계 물체를 놓으면 불연속을 만든다. [Godot PathFollow3D](https://docs.godotengine.org/en/stable/classes/class_pathfollow3d.html) 경로를 ADOPT, 기존 modulo는 REJECT, 전체 세계를 매 프레임 역이동하는 안은 DEFER했다. [DREDGE 제작자 인터뷰](https://www.gamedeveloper.com/design/trawling-in-the-deep-how-black-salt-games-made-spooky-fishing-rpg-i-dredge-i-)의 통제 가능한 이동/파도 분리는 참고 원칙이며 그 게임 코드를 복제한 것이 아니다.

`VoyageRoute`는 128-unit +Z 직선 Curve3D와 BoatProgress를 소유한다. 초과 구간 수만큼 경로 원점을 옮기고 구간 내 진행을 보존해 실제 world position이 연속적이다. 현재는 직선만 지원하며 곡선 항로와 world 재중심화는 구현하지 않았다. game consumer는 경로 위치를 배·세 카메라·두 접점에 전달한다. title/still/foreground와 기존 overlay process 동결, 저장/보상은 유지한다.

## 검증·교정

- RED는 기존 구현에서 512 경계 역이동, 누적 거리, Path3D 부재를 실제 game 실행으로 검출했다. 초기 background assertion은 comfort 복원에 따른 y bob까지 비교해 거짓 실패하므로 항해 z 위치로 좁혔다.
- 최초 PathFollow3D 구현에서 직선의 cubic sampling이 예상 거리와 미세하게 달라졌다. 실제 before/after 좌표로 원인을 확인하고 선형 sampling을 사용했다.
- GREEN의 1599초→1601초 직접 전진 검사에서 카메라 z는 504.979980→505.619995, 시작 -6.7이며 0.64 이동을 유지했다. 이는 가속된 수치 검사이지 1601초 실제 재생이 아니다.
- 128 경계의 0.01 단위 20회 이동, 음수/0/NAN/INF 입력 보존 검사도 통과했다.
- 전체 61 headless 계약 PASS, Python 20 PASS. 최초 Python 실패는 reusable receipt의 검사 수 60과 신규 집합 61의 불일치였으며 workflow/README/receipt를 62 total·61 headless로 동기화 후 재실행했다.
- 실제 Mobile/Vulkan, RTX 3050, 540×960에서 30.2초/152프레임을 촬영했다. `verified-runtime/motion-analysis.json` accepted=true, 수면 추적의 정방향 비율 1.0, 근경 중앙 이동 약 7 px/s·원경 약 1 px/s, 접점 오차 0.004159였다. 기존 카메라 부착 수면의 회귀 증거이지 world-space 수면 완성이 아니다.
- Mobile/Vulkan 실제 overlay 왕복 검사는 `OVERLAY_CONTINUITY_FAILURES=0`이다. 다른 프로젝트 GRIMOIRE의 Hera editor에는 연결하지 않았다.

## 검토 영수증과 한계

독립 read-only reviewer는 01:02:11, 01:02:32, 01:02:45, 01:03:00, 01:03:12 KST의 다섯 checkpoint에서 HEAD/hash/diff와 해당 전체 scope를 재독했다. AGENTS/adapter/GDD/handoff, route/test, Scene·motion·camera·pause·save·CI consumer를 읽고 대안과 미변경 소비처를 재확인했다. 첫 회차는 경로 owner, 둘째는 title/pause와 CI, 셋째는 공통 translation과 보존 자산, 넷째는 재시작/저장·재사용, 다섯째는 전체 재독과 장기 적합성을 검토했다. 01:03:25 문서 추가 readback에서 62/61 동기화를 확인했다. production 핵심 세 파일 hash는 아래와 같다.

- route `70942EB8B36B3FC997C236C9508E29EB15254824CD219169202B34EDDCAFAE5C`
- game `E6BD04D2EBAB59E1D65837DDFB32F5BB4EA0648004B3AF75611DE4B08449963D`
- scene `4FC795845BC9DA39E401F01E0D78843F202AE61661EC3604E2915561D092E541`

reviewer는 Godot를 실행하지 않았다. root의 실제 검사/교정/재검증과 구분하며 다섯 번 runtime 시험 또는 전체 제품 clean exit로 확대하지 않는다. 이후 128 경계/입력 검사 보강은 root가 실행했고 production은 바뀌지 않았다.

## 다음 개선·학습

다음은 공통 관찰축, world 섬, 수면 높이, 모델 제작 경로다. 이번은 3D 해역 통과·연속 회전·새 모델·기기 성능/Human/Release 완료가 아니다. 좌표 장기 정밀도와 구간 시각 연결은 후속 실측 대상이다. renderer 캡처는 GPU profiler/FPS benchmark가 아니다.

project lesson은 카메라와 배가 함께 점프하면 화면만으로 세계 이동 결함을 놓칠 수 있으므로 고정 landmark와 세계 위치 검사를 함께 해야 한다는 것이다. Base에는 승격 후보로만 남기며 새 module이나 Base 파일은 만들지 않았다. rollback은 이 경로 단위만 되돌리는 것으로 충분하며 save migration은 없다. 분석·인코딩 후 raw capture 155파일/75,852,098 bytes를 `C:/Users/user/Desktop/MyLittleBoat_삭제대기_20260913/voyage-route-raw`로 이동했다. 같은 상위 폴더의 `voyage-route-raw-manifest.json`에 source/destination/이유/용량/파일별 SHA를 보존했고 이동 전후 전체 hash 일치와 원본 경로 부재를 확인했다. 직접 삭제하지 않았다. 현재 motion-analysis·telemetry·실제 재생 WebP·대표 PNG는 verified-runtime에 유지하며 승인 자산·다른 worktree는 건드리지 않았다.
