# 현재 Godot 구현 handoff

**프로젝트:** `MY_LITTLE_BOAT`
**역할:** 실제 코드·Scene·test·runtime evidence와 현재 제품 정본의 차이를 기록하는 기술 router
**현재 사람용 정본:** [프로젝트 GDD](../design/PROJECT_GDD.md)

### 2026-09-14 R07a 저장 보호·첫 comfort consumer

후속 R07b1은 `b07f8b8`과 `6f6f716`에서 다섯 단순 owner까지 연결했고 `02e5a256`에서 공통 읽기 정책 중복을 해소했다. 격리 저장 환경의 64 headless 계약, 마지막 focused 8개와 game Scene smoke 및 독립 재검토 PASS가 있으며 exact 증거 범위는 아래 evidence owner를 따른다. 사진·GameState/UI 전체 연결 전이므로 R07 완료는 아니다. 현재 계획 실행은 [R01–R12 실행 계획](../superpowers/plans/2026-09-14-remaining-implementation.md)을 따른다.

명세 준비 후 같은 날 사용자 실행 승인으로 `RecoverableConfigStore`와 기존 `ComfortPreferences`를 연결했다. `6e50ad0`의 기본 구현, `3724c67`의 읽기 무변경 교정, `4773c68`의 최초 staging 이전 원본 의도 기록을 포함한다. `COMMITTED / NOT_COMMITTED / RECOVERY_REQUIRED`, 검증된 rolling last_good, 중단 후 원본 hash 기반 복구, 명시 복구 전 쓰기 차단이 실제 코드에 있다. 기존 음소거·움직임 저감의 session-only 의미를 유지한다.

이는 R07a의 helper+첫 owner 범위다. 나머지 persistence owner·GameState 성공 확정·플레이어용 복구 UI·사진 경로 검증은 아직 남았다. 수면/카메라/모델 화면은 변경하지 않았다. [저장 보호 증거와 남은 작업](../evidence/2026-09-14-recoverable-save/REVIEW.md)이 검증 ceiling을 소유한다. 재사용 검증 코드와 테스트 파일 정리는 실제 consumer에 연결했고 Base에 아직 승격하지 않았다.

### 2026-09-14 남은 작업·설계/구현 명세 준비

이번 요청은 구현이 아니라 남은 작업 명세 준비다. 기준 branch `6b7949a563150bd93e08d5d5eb1e028eab7336ef`, origin/main `7181d5e6845e75107eade8c4d2e62e10334ab54b`를 대조했다. GDD R01–R12가 제품별 설계·인터페이스·자산/저장/실패/완료 기준을 소유하며, [실행 계획](../superpowers/plans/2026-09-14-remaining-implementation.md)이 파일 경계·선행 관계·테스트 본문·작은 실행 단계를 소유한다. 새 별도 AI/GDD master는 없다.

현재 code read에서 추가로 확인한 차이는 style/pet 선택의 즉시 저장과 UI-05 draft 계약 불일치, 사진 pagination만 있고 UI-06 상세 입력이 없는 점이다. R06/R08로 명세했다. 모델·새 수면/sky 후보 lock·실제 모바일·Human·공개 social/Release는 미준비 gate를 유지한다. 기존 route/overlay/음량/사진 보호를 다시 미구현으로 분류하지 않았다. 이 문서 작업은 runtime source·Scene·자산·저장 파일을 바꾸지 않는다.

문서 검토에서 orbit pivot/시선 목표 분리, 두 family를 유지하는 latest-ID 전환, 저장 복원 실패의 RECOVERY_REQUIRED/owner 쓰기 잠금을 교정했다. 검토 기록은 실행 계획 말미가 소유한다. `git diff --check`, 기존 Python 20 tests 통과 및 runtime 파일 무변경을 확인했다. 새 Godot 계약·GPU·기기·Human 검증은 이번 명세 작성에서 NOT_RUN이다.

### 2026-09-13 수면의 세계 항로 방향 연결

기본 3/4 카메라에서 물이 항상 화면 아래로만 흐르던 방향 불일치를 교정한다. `game_scene.gd::_apply_background_flow_to_backdrop()`는 input-relative yaw 대신 실제 Camera3D의 수평 세계 right/forward와 현재 직선 `VoyageRoute`의 세계 +Z를 비교한다. 현재 기본 heading -2.66 rad에서 수면 방향은 약 (-0.463191, 0.886258)이며, 세 카메라가 같은 방향 기준을 소비한다. 기존 위상/속도/foreground/comfort/저장/원화 byte와 shader 원근은 변경하지 않는다.

대안은 상대 입력 yaw 유지 `REJECT`(기본 관찰각 누락), 실제 수평 축을 기존 shader에 연결 `ADAPT`, 실제 world 수면/sky/모델 전환 `DEFER_NEXT_PACKAGE`다. 마지막 안은 최종 P5 목표로 유지하며 이번 수평 방향 수정의 완료와 구분한다. root cause RED 14건 뒤 GREEN, GPU 반복 경계, 실제 30초 항해와 전체 회귀를 [수면 방향 검증](../evidence/2026-09-13-water-heading/REVIEW.md)에 연결한다. 이전 관찰축 항목의 relative-yaw 수면 설명은 당시 구현 기록이며 최신 consumer는 이 항목이다.

### 2026-09-13 바다 소리 조절 구현

전체 완성 queue의 P7에서 독립적으로 구현 가능한 기존 OceanBed 음량/음소거를 연결했다. camera/world fresh-read는 현재 모델/리그 미준비를 재확인했고 회전 완료로 승격하지 않았다. `ComfortPreferences`의 기존 파일/section에 ocean_volume 키를 추가하고 기존 motion/unknown key를 보존한다. GameState는 유효한 음량을 먼저 live 적용하고 저장 성공 여부를 반환하며, 실제 OceanBed는 stream을 교체하지 않고 gain만 전환한다. `OceanVolumeOption`은 쉬는 메뉴에서만 노출되고 감상에서는 숨긴다. 영구 저장 실패는 기존 StatusLabel에 알려주며 이번 실행의 mute는 막지 않는다.

조사/선택은 OS 음량만 사용 `REJECT`, 기존 메뉴의 실제 ocean consumer 조절 `ADAPT`, 새 다채널 설정 시스템 `DEFER`다. [Lake 공식 접근성 목록](https://whitethorngames.com/lake/accessibility)의 개별 음량/라디오 선택과 [XAG 105](https://learn.microsoft.com/en-us/xbox/accessibility/xbox-accessibility-guidelines/105)의 사용자 제어를 참고하되 아직 없는 음악·효과음/음성 슬라이더는 만들지 않는다. `AudioStreamPlayer.volume_linear`를 기존 -18 dB 믹스에 곱하고, preference를 sound startup보다 먼저 읽는다. 초기 파일 없는 상태는 기존 소리와 동일하다.

이번 headless CI 집합은 총 63개 중 62개다. `test_chibi_normal_chroma_material_proof.gd`의 display-only 경계는 유지하며 새 audio 계약의 실제 stream/입력/캡처는 GPU에서도 별도로 실행한다. exact 결과·다섯 검토·실행 화면·미검증 경계는 [음량 구현 검증](../evidence/2026-09-13-ocean-volume/REVIEW.md)이 소유한다. 150ms 검사는 누적 delta의 gain 계산이며 OS 오디오 지연/프레임 지연 상한 인증이 아니다.

### 2026-09-13 전체 완성 목표와 사진 원본 보존 후속

최신 사용자는 게임 전체 구현·완성을 목표로 계속 진행하도록 명시했다. GDD의 현재 실행 목표/P9를 기준으로 미구현 consumer를 지속 대조하며, 과거 planning-only 문장을 현재 안전한 구현의 차단으로 쓰지 않는다. 최종 아트·공개 social·Human/Device/Release와 고위험 경계는 유지한다. 공통 봄섬 단위는 `3e1961eecff4725876b1cf6527ad72a98b625175`로 local/remote branch equality까지 확인했고 main/PR #19는 그대로다.

다음 P8/IMP-05는 사진 저장 전 원본 목록 읽기 실패 보호다. 기존 `load_entries()`의 []는 파일 없음/잘못된 형식을 구분하지 못해 새 사진으로 복구 가능한 원본을 덮었다. 실제 tests에서 wrong-type/missing-section RED 6건과 partial-row RED 3건을 재현했다. 현재 `PhotoMemoryPersistence.save_photo()`는 기존 목록의 파싱·section/key·Array·유효 행 보존을 먼저 확인한 뒤 PNG를 쓴다. 읽은 목록을 ID 예약에도 재사용한다. null/빈 image도 저장하지 않는다. 누락 PNG의 정상 메타데이터는 여전히 유지하며 자동 사진 삭제·새 schema·정상 저장 ID 변경은 없다.

대안은 조용한 초기화 `REJECT`, 손상 원본 보존+명시 실패 `ADOPT`, 검증된 backup/transaction 복구 `DEFER_NEXT_PACKAGE`다. [Godot ConfigFile](https://docs.godotengine.org/en/stable/classes/class_configfile.html)의 load/save 오류와 overwrite 의미를 확인했다. 단순 rename을 atomic이라고 부를 수 없으며 현재 공식 master Windows 구현은 기존 목적 파일을 remove 후 MoveFile한다. 이 master 조회는 실행 엔진의 exact implementation 증거가 아니고, 이번 변경에서는 rename/backup을 도입하지 않는다. power-loss 안전 저장과 자동 복구는 별도 실제 장애 시험이 필요하다.

GameState는 실패 시 배열을 추가하지 않고 실제 GPU 촬영도 기존 조용한 실패 문구를 사용한다. 검증은 persistence → 실제 GameState → GPU 사진/앨범/overlay → 전체 회귀 순서다. 원본 bytes·기존 PNG 목록·사진 개수·실패 문구를 함께 확인한다. 독립 검토에서 숫자 필드가 문자열로 변환되어 원본이 바뀌는 RED 12건을 추가로 확인하고 저장 전 필수 4필드의 실제 String 타입 검사로 교정했다. 실제 파서 실패도 원본 보존을 확인한다. GPU 검사는 내부 촬영 직접 호출 대신 쉬는 메뉴 → 사진 버튼의 실제 신호 경로와 실패 문구의 화면 표시를 확인한다. 새 알림 UI나 그림은 추가하지 않았다. [사진 저장 보호 검토](../evidence/2026-09-13-photo-ledger-guard/REVIEW.md)가 최종 evidence를 소유한다.

### 2026-09-13 진행 — 공통 세계 원경의 실제 통과

기존 승인 봄섬 두 camera-local 복제를 `VoyageWorld/SeasonalIslandLayer` 한 개로 대체한다. 직선 항로 기준 좌우 x ±4, y -2.3, 현재 route z +3.5에 배치하며 billboard 대각 반경과 중앙 통행 여유 1.25를 확보한다. 이는 원경용 승인 PNG의 공간 consumer 전환이며 새 3D 지형/아트 승격이 아니다. side 입력은 이제 화면 좌우가 아닌 world 항로의 좌우다. 기본 3/4 시선 때문에 반대쪽 섬은 주변부에 보이고 사용자가 돌려볼 수 있다. 카메라를 강제로 섬으로 돌리지 않는다.

선택 비교는 camera-local 복제 유지 `REJECT`(서로 다른 공간), 단일 world billboard `ADAPT`(현재 승인 원경과 실제 경로 재사용), 모델 지형 `DEFER`(근거리 최종 방향이나 모델/리그·수면 미준비)다. [Godot SpriteBase3D](https://docs.godotengine.org/en/stable/classes/class_spritebase3d.html)의 거리 투영·billboard·depth 제약과 [DREDGE 제작진 사례](https://www.gamedeveloper.com/design/trawling-in-the-deep-how-black-salt-games-made-spooky-fishing-rpg-i-dredge-i-)의 시각 파도/진행 분리를 참고했다. 엔진·제작 사례가 우리 runtime 성공의 증거는 아니다.

실행 순서는 공통 앵커 부재 RED → Scene/route consumer 연결 → 실제 촬영의 거의 보이지 않는 초기 배치 교정 → 시점/정지/통과/장거리 회귀 → 전체 검사·독립 검토·증거 readback이다. scope owner는 game scene, 기존 계절/overlay/route tests, 현재 capture 도구다. 저장 schema·보상·발견 확률·일반 풍경·승인 PNG bytes는 보존한다. 실패 시 이번 논리 변경만 되돌리고 이전 증거/다른 workstream은 유지한다.

통과의 진행도는 실제 route 이동거리/6.5이며, standard speed 1에서 약 20.31초다. 14초는 일반 풍경의 기존 시간으로 유지한다. 섬은 anchor를 지난 뒤 3 units에서 정리하고 title/still/background/full overlay에서는 진행하지 않는다. 세 camera가 shared layer 1의 같은 앵커를 본다. 하늘·수면·구름과 일반 motif의 완전한 world 전환, 근거리 모델, 자유 회전 가림은 미완료다.

기존 `capture_bright_spring_seasonal_parallax.gd`는 현재 공통 촬영기의 호환 진입점이다. display renderer와 **새 절대 출력 폴더**가 필요하며 과거 9/1 증거를 덮어쓰지 않는다. 수동 delta GPU 표본과 실제 30초 촬영을 구분한다. [현재 검증 기록](../evidence/2026-09-13-world-island/REVIEW.md)에서 최종 상태를 확인한다.

### 2026-09-13 진행 계획 — 실제 항해 경로와 구간 연속성

후속 관찰축 단위는 기존 기본 카메라를 보존하고 LookAround/Appreciation의 초기 x/z 위치·세계 yaw를 맞춘다. LookAround는 `reference_yaw_degrees`·`reference_pitch_degrees`와 사용자 상대 각도를 분리해 yaw ±135°와 pitch -16°..38°의 상대 입력 제한·front/port/starboard/aft 분류를 유지한다. 생산 기준 pitch는 -29.793805°여서 실제 pitch 범위는 -45.793805°..8.206195°다. 수면 consumer도 두 조작 카메라의 상대 yaw를 사용한다. 테스트는 초기 heading 불일치 RED → 정렬 GREEN, 중립/좌우 수면 방향·입력·구도·overlay 회귀, 실제 세 시점 캡처 순서다. 이는 공통 기준축 준비이지 아직 단일 world 섬이나 실제 3D 모델 회전의 완성이 아니다.

사용자가 승인한 실제 3D 항해 권장안의 첫 단위다. `game_scene.gd`의 512-unit modulo 이동은 공통 world 물체 도입 시 뒤로 튀므로 `VoyageRoute` Path3D와 BoatProgress가 이동 위치를 소유하게 한다. 초기 해역은 기존 +Z 직선 방향을 보존하며 128-unit 구간의 초과 거리를 다음 구간으로 전달한다. 카메라·보트·접점은 같은 경로 위치를 소비하고 title/still/background/overlay·저장·보상은 유지한다. curved route·단일 world 섬·수면·모델 제작 완료를 이 단위로 주장하지 않는다.

- [x] `test_voyage_route_continuity.gd`에서 512 경계 역이동과 Path3D 부재를 RED로 확인.
- [x] `scripts/voyage/voyage_route.gd`, `scenes/game.tscn`, `game_scene.gd`에 경로 consumer 구현. 128-unit 경계 carry와 512 경계 회귀 GREEN 확인.
- [x] 61 headless·Python20·Mobile30초/overlay 실행, 5회 read-only scope 검토. [증거와 검토 한계](../evidence/2026-09-13-voyage-route/REVIEW.md)를 따른다. 원격 동기화는 commit 뒤 별도 readback한다.

기술 근거는 [Godot PathFollow3D](https://docs.godotengine.org/en/stable/classes/class_pathfollow3d.html)와 [DREDGE 제작진의 파도/이동 분리 사례](https://www.gamedeveloper.com/design/trawling-in-the-deep-how-black-salt-games-made-spooky-fishing-rpg-i-dredge-i-)다. 기존 modulo는 REJECT, 실제 경로 ADOPT, 매 프레임 전체 world 역이동은 DEFER. 새 Base module·save schema·art는 필요 없다. 실패 시 이 단위만 rollback하고 기존 승인 자산과 다른 작업은 보존한다.

### 2026-09-13 구현 — 개인 사진 기억의 탐색 연결

유사 장르 조사와 GDD B5/P4/IMP-05를 연결해 앨범을 3장 단위로 탐색하도록 구현했다. `album_view.gd`는 이전/최근 버튼·page clamp·누락 이미지 안내·전체 사진 비율, `album.tscn`은 스크롤 내용과 고정 Back을 소유한다. `photo_memory_persistence.gd`는 파일 누락을 메타데이터 삭제로 취급하지 않으며 기존 ID를 예약해 재사용하지 않는다. schema/보상/아트는 그대로다. [제품 개선 루프 기록](../evidence/2026-09-13-album-history/REVIEW.md)을 따른다. 검사 5회만을 개선 루프라고 보고하지 않는다. 다음은 공통 공간·카메라 정렬의 연속 이동 slice이며 모델/리그 부족을 사진 기능 완료로 덮지 않는다.

### 2026-09-13 구현 — 카메라 간 풍경 누출 차단

기본/감상 전용 섬과 일반 풍경을 서로 다른 render layer로 분리하고 세 카메라의 cull mask에서 다른 시점의 풍경을 제외했다. visibility·Tween·Timer·진행 상태는 유지하며 공통 보트/수면 layer도 보존한다. 감상 화면 좌하단의 타 카메라 섬 조각이 실제 GPU 캡처에서 제거됐다. [수정 계획·비교·검증](../evidence/2026-09-13-camera-scenery-isolation/REVIEW.md)을 따른다. 이는 누출 수정이지 공통 world-space 전환이나 연속 3D 회전 완성이 아니다.

### 2026-09-13 진단 — world-space 단순 전환의 제약

사용자의 계획 후 실행 요청에 따라 기존 낮/봄섬의 카메라별 세계 좌표를 실제 Godot에서 비교했다. 같은 섬의 기본/감상 global 중심은 11.0099 engine units 떨어져 있고 둘러보기에는 같은 섬 레이어가 없다. 단일 world 복제를 유지하면 현재 감상/둘러보기의 투영이 화면 밖으로 크게 벗어난다. 단순 reparent는 production에 적용하지 않았다. [실행 전 계획·측정·다음 선행 조건](../evidence/2026-09-13-world-space-probe/REVIEW.md)을 따른다. 모델 파일·로컬 Blender·연결 rigging 도구는 제한된 조회에서 확인되지 않아 C 제작은 BLOCKED_UNVERIFIED다. 이번은 진단 도구/캡처이며 새 공간 구조·연속 3D 회전·전진감 완성은 아니다.

### 2026-09-12 후속 구현 — 풍경 이동 시간 일치

일반 풍경 Tween은 보트의 speed/comfort 배율을 따르며 still에서 멈춘다. 일반·계절 풍경은 벽시계 Timer가 아니라 실제 시각 진행 완료 시 정리한다. 느린 풍경의 조기 만료와 still 중 후속 이벤트에 의한 갑작스러운 교체를 수정했다. 발견/저장/보상 시간은 변경하지 않았고 이동 큐도 없다. [조사·구현·검증 경계](../evidence/2026-09-12-scenery-clock/REVIEW.md)를 따른다. Base remote는 다시 조사했지만 v9.4.4 lock은 유지했다. 자동 회귀 5회는 전체 적대적 검토 5회의 대체 증거가 아니다.

### 2026-09-12 후속 구현 — 같은 쪽 섬 통과와 제한된 깊이

`game_scene.gd`의 승인 봄섬 전용 경로가 중앙을 가로지르는 좌우 슬라이드에서 같은 쪽 접근으로 바뀌었다. normal/Appreciation의 기존 Sprite3D를 유지하며 camera-relative 깊이 변화로 크기·바깥 방향 투영을 만든다. 0 offset은 오른쪽으로 처리하고 진행은 기존 speed/comfort 위상을 사용한다. 실제 world-space 섬·Look Around 연속 투영·전체 시간대 적용은 아직 아니다. 새 이미지·씬·저장·보상 변경은 없다.

검증은 [같은 쪽 깊이 기록](../evidence/2026-09-12-same-side-depth/REVIEW.md)과 verified-runtime의 실제 30초 재생/수치가 소유한다. headless 60개, Python 20개, GPU 수면 반복 경계 검사가 통과했다. 촬영 전용 clock 상속 fixture는 timer/focus가 지정한 낮·봄을 덮지 않게 하고 원래 lifecycle 함수를 유지한다. 생산 시계는 변경하지 않았다. 이전 분석기의 0 anchor는 후면 보트의 -2.25 배치를 오류로 계산했으므로 명시적 anchor 인자를 추가하고 실제 이탈·잘못된 anchor를 실패시키는 회귀를 남겼다. Human/Device/Release는 NOT_RUN이다.

### 2026-09-12 최신 구현 — IMP-01 앨범·전체 꾸미기 연속성

`game_scene.gd`의 앨범 진입은 Scene 교체 대신 기존 AlbumView를 자식 overlay로 유지한다. AlbumView의 복귀 signal이 있으면 감추고, 독립 album scene으로 연 경우의 기존 복귀는 보존한다. full overlay/비활성에서는 game process domain을 DISABLED로 두어 자식 Timer·카메라·bound Tween까지 동결한다. 두 overlay UI는 ALWAYS, soundscape는 기존 autoload다. 같은 시간대 재진입은 풍경을 지우지 않지만 최초 tone 설정은 강제한다. 사진 중 요청한 overlay는 UI 복원 후 한 번 열고, P2에 따라 낚시는 무손실 취소/버튼 복구한다. 두 camera controller는 pause 시 drag latch를 취소한다.

검증 owner는 [IMP-01 REVIEW](../evidence/2026-09-12-overlay-continuity/REVIEW.md)와 같은 폴더의 verification.json이며, 새 `test_voyage_overlay_continuity.gd`가 20회 왕복·위상/Timer/Tween·비활성·같은 시각 context·최초 초기화·낚시·실제 viewport 입력·GPU 사진을 검사한다. CI 집합은 61개/60 headless로 갱신했다. actual OS focus 전달·모바일 suspend·사용자 청취/편안함·Release는 별도다. 새 3D/세계 깊이/전체 아트는 아직 남았으며 이 작업에서 건드리지 않았다. 검증 전 실패를 숨기거나 기존 9/11 증거를 새 소스 검증으로 재사용하지 않는다.

### 2026-09-12 사용자 수동 삭제 대기 정리

최신 사용자는 삭제 가능한 파일을 별도 폴더에 모으고 직접 삭제하도록 요청했다. 기존 차단된 자동 삭제를 재시도하지 않고 새로 승인된 가역 이동을 수행했다. 위치는 `C:/Users/user/Desktop/MyLittleBoat_삭제대기_20260912`이며 `삭제안내.md`와 `이동목록.json`에 원래/이동 경로와 검증 정보가 있다. 최근 후면 촬영 8개, 이전 수면 촬영·분석 7개, matte probe 1개, 과거 격리 촬영 캐시 1개, Aseprite 작업용 사본 1개, Python 캐시 3개로 총 21개 폴더·1,764개 파일·852,829,063 bytes다. 파일은 삭제하지 않았다. 이동 전후 모든 파일의 상대 경로/SHA-256 집계·개수·용량과 원래 위치 부재를 확인했다.

승인/후보 원본·runtime 자산·repository 검증 증거·PDF·save·`.asset-vault`·Godot import cache·다른 worktree는 그대로다. 과거 기록의 cleanup-blocked 15개 촬영 폴더 및 Aseprite/matte staging은 이제 위 사용자 수동 삭제 대기 위치를 따른다. 다른 프로젝트나 PC 전체의 모든 미사용 파일을 판정한 것이 아니다. AGENTS의 정리 방침도 같은 요청에 맞춰 갱신했다. 게임 코드/씬 변경이 없어 새 gameplay 검증은 수행하지 않는다.

### 2026-09-11 최신 실행 결과 — 승인 후면 자산·연동 모션

사용자 `확정하고 진행해`에 따라 승인된 분리 RGBA를 기본 player/dog 조합에 실제 연결했다. `FinalDioramaCard → PartsViewport`에서 선체·인물·강아지·쿠션·앞 난간을 조립하고, 기존 항해 위상으로 선체/접점/탑승자 반응을 연결했다. 카메라와 선체의 공통 진행 좌표는 512 단위로 제한한다. 이 좌표 변화 자체는 전진감 증명이 아니며 실제 깊이를 가진 새 풍경이나 연속 회전 구현도 아니다. 후면 slice는 `IMPLEMENTED / MACHINE_VERIFIED / RUNTIME_VERIFIED_BOUNDED`, 전체 사용자 이동 경험은 `PARTIAL / HUMAN_NOT_RUN`이다.

[현재 실제 재생](../evidence/2026-09-11-voyage-motion/stern-runtime/voyage-30s.webp), [검증·소스 결속](../evidence/2026-09-11-voyage-motion/stern-runtime/verification.json), [발견·교정 기록](../evidence/2026-09-11-voyage-motion/REVIEW.md)을 우선한다. 아래 옛 runtime 링크는 이전 그림 증거다. 최신 전체 headless 계약은 **59/59**, Python은 **18/18**, 새 GPU 통합 검사는 **실패 0**이다. 촬영은 실제 process 시간·명시 foreground·입력 차단·격리 저장 fixture이며 사람 입력/OS focus/Human/device 검증이 아니다.

적용 중 색 보정의 이중 곱셈, 분리된 옛 쿠션, 미리보기 구도, 카메라 갱신의 기본 개 카드 강제 표시를 실패 테스트로 찾고 교정했다. 다른 외형·동반자와 기존 시점은 보존하며 새 외형으로 모두 바뀌었다고 보고하지 않는다. 보상·save schema·병 편지·앨범 의미는 변경하지 않았다. Base adapter v9.4.4와 다른 PR #19도 유지한다. 다음 남은 패키지는 P5 실제 근거리 모델/리그와 세계 깊이, 전체 각도/시간대/상태 family이며 기존 PDF는 구현 전 review snapshot으로 보존한다.

### 2026-09-11 후속 current authority — 전진 이동 연출 구현

**후속 사용자 피드백 반영 — OPEN / EXPERIENCE_ACCEPTANCE_NOT_MET.** `b2b0e427c9c33a867281bea3e3abdaf1a021aa08`의 수면 연속성 개선은 기술적 부분 구현이다. 수정된 v3 그림은 production consumer에 연결되지 않았고 카메라/탑승자 연동 이동도 완료되지 않았다. 현재 새 작업은 올바른 아트 연결과 통합 이동 연출이다. v3는 합성 RGB 한 장이며 기존 독립 player/hull/dog는 이전 구도다. 실제 3D 모델·리그 파일은 확인되지 않았다. 카메라 미세 진동이나 수면 추적 수치만으로 이 피드백을 해결 처리하지 않는다. 최종 선택 구조는 GDD P5의 실제 3D 근거리 원칙을 유지하며, 2D 분리 후보는 후면 모션 준비/비교 자료이지 연속 회전의 대체 구현이 아니다.

최신 사용자 지시가 이동 연출의 조사 후 실제 구현을 승인했다. 아래 Blueprint 전체 production 보류는 새 모델/아트/전체 계획에는 유효하지만, 이번 기존 수면·부유·비활성 시간 개선은 명시적 예외다. 기준 HEAD `590b5dacfefefd529f29527f8c43df38176578cd`, main `7181d5e6845e75107eade8c4d2e62e10334ab54b`. 다른 PR #19와 Base adapter v9.4.4는 그대로 유지했다.

구현은 기존 SeaBackdrop material의 원근·시선 상대 방향·두 위상 연속 흐름, still 정지, 선체 접점 유지, inactive process 정지다. [실무 조사·5회 검토·검증 경계](../evidence/2026-09-11-voyage-motion/REVIEW.md), [실제 30초 재생](../evidence/2026-09-11-voyage-motion/runtime/voyage-30s.webp), [측정/소스 hash](../evidence/2026-09-11-voyage-motion/runtime/motion-analysis.json)를 함께 읽는다. runtime art는 기존 승인 family를 재사용했으며 새 모델·rig·후보를 적용하지 않았다.

전체 58개 headless 계약 재실행 실패 0, Python 18 tests PASS. 새 GPU 연속성 계약은 OpenGL와 Forward Mobile Vulkan 모두 통과했다. 최종 Vulkan 실제 process 촬영은 152프레임/30.203초, 근수면 6.924px/s·원수면 1.003px/s 중앙값이다. 명시적 foreground fixture이므로 OS focus 전달 검증은 아니다. 원본 캡처를 생성 이미지/보간으로 교체하지 않았다.

첫 Vulkan 촬영 종료의 ObjectDB 2개 경고는 verbose 재촬영에서 재현되지 않았다. RGB8→RGBA8 하드웨어 변환 경고와 격리 candidate project 발견 경고는 남은 진단 정보로 기록하며 무경고 PASS를 주장하지 않는다. Blueprint PDF는 구현 전 보존 snapshot으로 유지한다. 전체 3D 공간의 전진·island depth, 별도 Tween/Timer/album continuity, Human/device 검증은 남아 있다.

### 2026-09-11 current authority — 사람용 Blueprint·필수 후보 제작

최신 사용자는 십보강호 PDF를 구조 참고로만 사용하고 상세 SWOT·시스템·데이터·화면/자산 아틀라스·실제 사용 규격 이미지를 준비하도록 승인했다. 이미지 제작 보류는 해제됐다. 아래 2026-09-10 active context의 제작 중단 문구는 역사적 상태다. 새 계획 상세 owner는 GDD B1–B12, 기존 경험 계약은 P1–P10이다. 이번에는 문서·후보·후보 검수/출판 도구만 변경하며 production 게임 적용은 전체 Blueprint 최종 승인 후다.

현재 main은 `7181d5e6845e75107eade8c4d2e62e10334ab54b`, 작업 기준은 `7b2c8f2f4e4a146a28f5aa862d78910bc2ab3e52`다. 다른 social workstream PR #19는 read-only로 보존했다. Base remote `2f93e872d9ed4fa18018ac759b01acd7d34e9b58`의 조건부 Aseprite 지침을 읽었고 adapter v9.4.4는 변경하지 않았다.

최종 준비 blocker는 승인 외형의 실제 근거리 3D 모델·리그·3상태 clip이다. 새 PNG·Aseprite export·격리 alpha 렌더로 이 항목을 완료 처리하지 않는다. IMP-01 연속성은 기획 승인 후 별도 이미지 없이 착수 가능하지만, 이번에는 실행하지 않는다. Blueprint는 `REVIEW_DRAFT_NOT_FULL_ASSET_READY`, Human/신규 game runtime/출시는 NOT_RUN이다.

#### Blueprint 준비 검토·readback

기준 HEAD는 위 `7b2c8f2`이며 전체 요청은 문서·실사용 자산·구현 인계 준비다. 다음은 실제 준비/교정 checkpoint이지 전체 요청의 five-loop clean exit 또는 전체 자산 납품 PASS가 아니다. 모델·리그·모션·새 화면별 시각 시안·전체 시간대 family가 남아 있어 전체 범위는 열려 있다.

| checkpoint | 실제 읽기·검사 | 발견·교정·대안 | 결과·남은 경계 |
| --- | --- | --- | --- |
| 1 · 정본/범위 | AGENTS·adapter·GDD·handoff·inventory·main/PR·실제 catalog/resolver/persistence, 예시 PDF 92쪽의 구조와 대표 페이지 | 이미지 보류가 최신 지시와 충돌 → 세 owner에 명시적 최신 override. 예시 게임 규칙 복사 대신 B1–B12 보완 | Base lock·PR #19·production 보존. SWOT와 제작 세부의 GDD owner 유지 |
| 2 · 실제 이미지/패키징 | imagegen 결과의 RGB/RGBA·corner alpha·bounds, 기존 matte renderer/shader, Aseprite native calls | 직접 투명 편집이 RGB checkerboard로 실패 → 이미지 모델의 magenta 원본 + 기존 GPU matte 추출. 새 pixel drawing/bridge는 배제 | alpha PASS, Aseprite 1frame·100ms·no tags·RGBA pixel identical. 얇은 edge tint와 게임 적용은 미검증 |
| 3 · 전체 문서/회귀 | GDD 전체 신규 절과 실제 기존 P 계약, PDF 36쪽 텍스트·렌더, 기존 Blueprint/Base/CI 계약 12 tests | 꼬리 한 행·문단만 다음 쪽에 남음 → 행 여백과 제한된 본문 fitting 조정. 더 작은 글자 일괄 강제 대신 읽기 단위 분리 | 33→29쪽, 새 publication 검사 5 PASS. 원본 PDF 무변경 |
| 4 · 관계/레이아웃 | PDF 전체 30쪽 렌더 contact sheets, 필수 B/P 항목·21개 링크·30개 책갈피, 전체 Python 18 tests | flow map 복귀 선이 Start로 읽힐 수 있음 → Rest 공통 분기로 교정. P2/B7 이어진 장에 별도 제목 부여 | 변경된 11/14/15쪽 full-size 재검토, 겹침·잘림 검출 없음. 화면 아틀라스는 구조도이며 완성 화면 시안 아님 |
| 5 · 원본/도구 호환 | GDD·manifest·PDF·snapshot hash, 전체 Python 18 tests, green matte GPU 재실행, untouched consumer diff·worktree 목록 | magenta 지원이 기존 green sampler와 충돌하지 않는지 검증. 넓은 worktree 삭제·자동 canon 승격 배제 | 기존 green 1774×887 alpha PASS, source/render output 보호. 최종 준비 blocker는 유지 |

최종 PDF는 `output/pdf/MY_LITTLE_BOAT_HUMAN_BLUEPRINT_20260911_REVIEW.pdf`, 30쪽/이미지 7개/책갈피 30개/링크 21개다. 원문 snapshot·manifest·generator·PDF hash는 같은 이름의 receipt가 소유한다. `python -m unittest discover -s tests -p 'test_*.py' -q`에서 **18 tests PASS**를 확인했다. 이 중 기존 분리 배치 테스트는 display renderer이며 game runtime 통합 검사가 아니다. `git diff --check` 오류 없음, scenes/scripts/assets/project.godot·기존 20260902 PDF diff 없음이다.

재사용 교훈은 ‘투명 배경 생성 요청과 실제 alpha는 다르며 export 왕복도 motion 증거는 아니다’, ‘짧은 꼬리 문단은 내용 삭제가 아니라 장별 레이아웃으로 해결’이다. 기존 renderer와 Aseprite를 재사용했고 별도 유료 도구·새 bridge·Base 공용 skill은 추가하지 않았다. PDF 검사에 로컬 PyMuPDF를 추가했다. 공용 승격은 다른 프로젝트 consumer 검증 전 후보로만 둔다.

추가 readback에서 Aseprite JSON의 CRLF(22개)와 Git 자동 정규화가 hash 결속을 깨뜨릴 수 있음을 확인했다. 새 native sheet JSON만 원본 byte 보존, GDD·신규 manifest·generator·snapshot은 LF로 지정했다. publication 테스트에 manifest의 모든 보존 파일 hash 검사를 추가하고 전체 18 tests를 재실행했다. 의미 있는 문서/자산 버전을 보존하되 이번 task staging과 PDF QA 임시는 검수 후 정리한다. 다른 worktree와 과거 cleanup-blocked 경로는 건드리지 않는다.

### 2026-09-10 active context — 코어 유지, 화면·아트·모션 재기획

**현재 작업 지시 — 전체 제작 기획 우선.** 사용자는 부분 검토 뒤 반복 질문하는 대신 게임 제작에 필요한 기획 전체를 조사·권장안으로 구체화하도록 지시했다. [GDD의 통합 제작 기획 P1–P10](../design/PROJECT_GDD.md#통합-제작-기획--전체-경험시스템제작-계약)이 최신 계획 owner다. 이미지·모델 제작과 production 구현은 보류이며 아래 ‘후속 제작’ 문장은 자동 실행 queue가 아니다. 기존 미커밋 배치 도구·이미지 증거는 보존하고 이번 기획 변경과 별도 취급한다.

계획은 `RECOMMENDED_PRODUCTION_BASELINE`, C안은 엔진 경로 `PARTIAL` / 승인 외형 모델·리그 제작 `BLOCKED_UNVERIFIED`다. 전체 기획을 수행하라는 승인은 연구·명세화를 포함하지만, 실제 없는 모델·리그를 ASSET_READY로 올리거나 Human/Blueprint final approval을 추정하는 권한은 아니다. 기술 선택은 계속 구체화하되 새 자산 생산 gate는 유지한다.

| bounded package | 기존 consumer / 재사용 검증 | 새 작업에서 증명할 차이 |
| --- | --- | --- |
| continuity | `scripts/voyage/game_scene.gd`, `scripts/ui/album_view.gd`, `scripts/core/game_state.gd`; `tests/test_together_time_game_scene_contract.gd` | full overlay·focus 동결, 같은 시각 위상 복귀, 사진 저장 중 입력 중복, 300초 1회 기록과 무한 휴식. 현재 state-only 보존을 전체 연속성 PASS로 해석하지 않음 |
| camera/art/sea | `scenes/boat_space.tscn`, `scenes/game.tscn`, `scripts/voyage/look_around_camera_controller.gd`; `tests/test_voyage_forward_drift_contract.gd` | 실제 3D family 왕복, world-space 흐름, 전체 각도/부유 주기 접점, 낮 한 family 후 시간대 확대. 기존 direction card와 primitive는 새 asset proof가 아님 |
| cosmetic/content | `scripts/identity/identity_visual_catalog.gd`, `scripts/decor/boat_decor_catalog.gd`, `scripts/voyage/drift_scenery_director.gd` | 기존 3 style/4 species/8 slot/6 item ID 보존과 점유 가림, 6 motif/봄 layer의 항로 비침범. 실제 존재한 consumer를 무단 삭제하지 않음 |
| memory/actions/audio | `scripts/core/photo_memory_persistence.gd`, `scripts/core/memory_ledger_persistence.gd`, `scripts/voyage/fishing_session.gd`, `scripts/audio/resting_soundscape.gd` | write failure/누락/손상/취소/중복 저장, 음량·음소거·복귀·loop 경계. 실제 청취와 device comfort는 NOT_RUN |
| production/release | 기존 export/test/publication owner | 대표 기기 성능·export·권리·Human·social gate 분리. 새 PDF·이미지 생성 또는 출시를 이번 문서 작업의 PASS로 만들지 않음 |

소리의 실제 구현은 autoload ocean bed이고 다른 layer는 우선순위 선언이다. API·상수·파일명만 보고 전체 authored sound library가 준비됐다고 주장하지 않는다. 현 배치 PNG 원본·기존 PDF·save·production code는 이번 통합 기획에서 무변경이다.

#### 통합 기획 검토 기록

대상은 `7ba087ead251b99ac8cd01f414550f6d4f461f5b` 위의 P1–P10 통합 문서 변경이며 게임 구현의 clean exit가 아니다. 아래 회차마다 전체 권장 범위·금지 범위와 기존 consumer 보존을 재대조했다. 이미지 중단 전 미커밋 렌더 증거는 이 검토의 변경 범위에서 제외한다.

| 회차 | 전체 범위 대조와 실제 검사 | finding / 교정 / 더 나은 대안 | 회귀·장기 적합성 |
| --- | --- | --- | --- |
| 1 | AGENTS·GDD·handoff·adapter·code/catalog/persistence/audio·원격 PR, 10개 공식 benchmark와 엔진 문서 | 카메라만 검토하는 불완전 범위 → P1–P10 전체 경험·시스템·제작 명세. 새 문서 정본 대신 GDD 통합 | Blueprint 7 + Base 3 + CI coverage 2 tests PASS. 원본 scene/script/save/asset/PDF 무변경 |
| 2 | P1–P10 본문 전체 읽기·실제 save 경로/기록 로직 대조·15개 consumer path 검사 | 속도 메뉴 누락과 production 전 Blueprint gate의 순서 혼동 → 메뉴 복원, P9의 1a gate 추가. 보상/새 save 대신 표현·overlay 개선 | consumer 누락 0, fenced block 검사, Blueprint 7 PASS. GDD readback SHA ad52f0788b4fcdf464be9fb93b4e5e53e8099f5f2d914176f2d48ddb05d80c4d 당시 상태 |
| 3 | 전체 P1–P10의 진입/취소/복귀/저장/자산/성능/Human 경계, 실제 scenery Tween/Timer·comfort source와 공식 pause 문서 | delta만 차단하면 Tween·Timer가 따로 움직일 수 있음 → pause domain과 UI/audio 분리, still 큐 규칙 명시. 전역 pause 대안 제외 | Base 3 PASS, production 무변경, full section check. 로컬 검사 명령의 PowerShell backtick 손실은 chr(96)로 교정해 재실행 성공; 제품 결함으로 오기하지 않음 |
| 4 | 전체 계획과 visual inventory의 standing authorization·구형 GDD 준비 순서·기존 3 style/4 species 재대조 | 과거 이미지 자동 제작 안내가 최신 중단과 충돌 → inventory override와 구형 준비 queue 라벨. 자산 삭제 대신 승인 이력 보존 | 3 owner 경계 검사, Blueprint 7 + CI coverage 2 PASS, production 무변경. P1–P10 normalized section SHA 810ce6c71eb6d9b2d1a8f62daa6a6462e2dff295e8d0bd978e5fc0fff7c9d5a5 |
| 5 | 최종 전체 계획·handoff·AGENTS·실제 title/start 코드·소스 경로·저장 보호·남은 C안 위험·diff 재대조 | AGENTS direct-entry 문장의 title/start 경계가 불명확 → 기존 승인·실제 코드에 맞춰 명료화. C안은 PARTIAL 유지, 제작 불가능성을 2D 카드 성공으로 대체하지 않음 | 최종 검사 결과는 아래 delivery readback으로 남김. 추가 기능/서비스/데이터 migration 없이 현 기획 범위를 유지 |

남은 것은 C안의 승인 외형 제작·변형/기기 증거와 각 production package의 구현/검증이다. 이는 문서 검사로 닫히지 않는다. Base 공용 승격은 연속성 검증의 후보만 기록하고 공용 코드·skill은 만들지 않았다.

최종 문서 검사 readback은 P1–P10 존재·필수 경계·15개 실제 consumer 경로 확인, Blueprint 7 + Base adapter 3 + CI coverage 2 = **12 tests PASS**, `git diff --check` 오류 없음, scripts/scenes/assets/project.godot/기존 PDF diff 없음이다. 후보 이미지 렌더 테스트는 이미지 작업 보류에 맞춰 이번에 실행하지 않았다. 이 결과는 문서·기존 계약 회귀 검사이지 새 gameplay/runtime/Human PASS가 아니다. 이전 이미지 검토의 미커밋 파일/문서 hunk는 별도로 보존하고 통합 기획 delivery에 포함하지 않는다.

**최신 실행 증거.** `tools/render_candidate_layout.gd`로 기존 분리 PNG 7종을 540×960 격리 viewport에 실제 렌더했다. 첫 배치에서 옷이 난간을 덮는 문제를 확인하고 source hull region overlay로 교정했다. `exact-layer-layout-v2.png`는 `ISOLATED_STATIC_LAYER_RENDER / REVIEWED_WITH_FINDINGS`이며 게임 통합·모션/Human PASS가 아니다. 선체 중심 80.05%를 확인했고 player 기대기 자세·쿠션·접점은 아직 미완료다. `tests/test_candidate_layout_render.py`는 실제 렌더/덮어쓰기 거부를 검증한다. source PNG와 production scene/script/save는 무변경이다. 아래 이전 합성 후보/alpha 준비 기록은 역사적 단계로 읽는다.

**최신 결정.** 사용자가 `MLB-REDESIGN-STAGING-002`의 구도를 확정하고 노를 제외했다. 구도는 `USER_LOCKED_STAGING`; 새 기본 장면의 oars/rowing/paddle-tip splash는 제작 범위에서 제외한다. 노 제거 파생본 `stern-staging-no-oars-v3.png`를 이미지 모델로 준비했으며 기존 분리 자산의 exact 합성이나 게임 연결은 아니다. 아래 이전 후보 상태는 당시 기록이다. 후속은 player·쿠션·front rail·접점 정렬과 바다 흐름이며 노 준비는 더 이상 잔여 작업이 아니다.

최신 추가 준비는 `MLB-REDESIGN-STAGING-002 / GENERATED_CANDIDATE / NOT_USER_LOCKED`다. 독립 선체/player/pet을 참조해 좌석·난간 가림을 교정한 후 배 크기·하단 위치를 한 번 더 수정했다. 저장소의 `stern-staging-review-v2.png`는 이미지 모델 합성 후보이며 exact-layer composite/540×960 runtime 검증이 아니다. 기존 독립 PNG의 fringe, front rail/쿠션/노/접점 제작, 정확한 좌석 pivot·전진 흐름은 아직 남아 있다. 기존 consumer와 13개 source/derived 파일은 무변경이다.

임시 정리 상태는 `BLOCKED_BY_EXECUTION_POLICY`다. 왕복 검증 후 `C:/Users/user/.local/share/aseprite-local/candidates/mlb-separated-74a89c2`의 3개 staging 파일과 `C:/Users/user/AppData/Local/Temp/mlb-matte-probe-74a89c2/project.godot`의 exact-path 삭제를 요청했으나 실행 전에 정책 차단됐다. 우회·재시도하지 않았고 삭제 완료로 기록하지 않는다. 원본 PNG·Aseprite 후보·receipt는 저장소에 보존했다.

최신 준비 상태는 `SEPARATED_LAYER_CANDIDATES / ALPHA_RECOVERED / NOT_GAME_IMPLEMENTED`다. 2026-09-10 후속 작업에서 이미지 모델의 단색 녹색 원본과 기존 `chibi_normal_chroma_key.gdshader`의 격리 렌더를 조합하여 선체·돌산·구름·player·companion의 RGBA를 확보했다. 하늘·바다도 별도 원본으로 생성했다. 선체 Aseprite 저장/재export는 RGBA 픽셀 동일성 확인까지 완료했다. 이전 `BLOCKED_ALPHA` checkerboard 파일은 실패 검증 기준선으로 보존하며 현재 성공 후보와 혼동하지 않는다. 소품·가림용 난간·수면 접점, 좌석/pivot 맞춤·녹색 fringe·전체 합성·모션 검증은 남아 있다. production code/save/기존 assets는 무변경이며 Human 검증도 미실행이다.

후속 상태는 승인 방향 이미지 `MLB-REDESIGN-VOYAGE-CANDIDATE-001`을 기준으로 `MLB-REDESIGN-POSE-001` 정적 키포즈 후보를 준비한 단계다. 사용자가 바다·돌산·하늘 등의 독립 제작을 재확인하여 GDD에 필수 납품 layer 계약을 명시했다. 키포즈 보드는 분리 production asset/animation/runtime이 아니다. 다음 자산 제작은 별도 하늘·바다·투명 오브젝트·선체·player/pet·접점으로 이어져야 하며 합성 보드를 잘라 production으로 올리지 않는다. 자세한 승인·후보·시각 findings와 prompt는 visual inventory가 소유한다.

현재 사용자 승인은 GDD 첫 절의 **떠다니는 친밀 디오라마** 방향 구체화와 후보 준비다. 새 시각·모션은 `DESIGN_IN_REVIEW`, 새 runtime은 `NOT_IMPLEMENTED`다. 아래 기존 작업 기록은 구현 기준선으로 보존한다. 기존 asset은 새 제작에서 reference-only지만 실제 consumer가 있으므로 삭제·교체하지 않았다. 새 영구 데이터나 social 기능을 추가하지 않았다.

다음 검증 패키지는 title→start→rest→감상→복귀를 실제 시간·실제 입력 흐름으로 캡처한다. `tests/capture_voyage_forward_flow.gd`의 기존 2초 비교는 `set_process(false)` 뒤 `_apply_drift_motion(2.0)`을 호출하는 staged renderer evidence이므로 연속 실제 플레이·이동 방향 지각·Human comfort의 PASS로 올리지 않는다. 이번 문서/후보 준비에서는 해당 캡처를 다시 실행하거나 과거 PNG를 덮어쓰지 않았다.

현재 변경은 GDD·문서 router·visual 후보/receipt 및 기존 PDF 원문 보존·관련 검증에 한정한다. Base v9.4.4 lock, production code/scene/save/기존 assets, PR #19는 변경하지 않는다. 새 그림의 최종 확정과 Blueprint 검토 이후 exact 시각 패키지를 구현한다.

검토·교정 기록은 코드 기준 `08637e3f59a9e50b19582eff62080715f8d9ea47` 위의 이번 documentation/candidate patch를 대상으로 한다. 새 게임 구현의 five-loop clean exit가 아니라 **준비물 검토 기록**이다.

| 검토 | 실제 확인·발견 | 교정·증거 한계 |
| --- | --- | --- |
| authority/범위 | AGENTS·GDD·handoff·inventory·adapter·실제 scene/script·open PR 조회, Base remote `2f93e872d9ed4fa18018ac759b01acd7d34e9b58`의 Aseprite 절 | 기존 이미지의 과거 승인과 새 재기획을 분리. lock·다른 PR 유지 |
| 조사/실현성 | 공식 10개 게임 소개·제작자 회고·Godot/Aseprite 문서, 세 제작 방식과 실제 Sprite3D 소비처 대조 | 2D가 연속 회전을 해결한다는 과장 배제. 각도 연속성 `PARTIAL` |
| publication 회귀 | 관련 unittest 10개 실행 중 old receipt와 새 GDD hash 비교 1개 실패 | 원래 GDD를 62,180-byte immutable source snapshot으로 보존. receipt hash `0023018190c4f41fcd5ee88c25d3f05f948af1a17d4bcf05a4cf5a3e0c7a6a10` 일치 확인, snapshot LF 고정. PDF/receipt byte 변경 없음. 10개 재실행 PASS |
| 후보/증거 | 생성 이미지 직접 시각 확인·규격·SHA readback, 기존 capture source의 직접 delta 호출 재확인 | 수면 과밀·최종 배치 재검증 findings 기록. 정적 후보·staged capture를 motion/Human PASS로 올리지 않음 |
| 회귀/장기 적합성 | 전체 Python suite `python -m unittest discover -s tests -p 'test_*.py' -q` 12개 PASS, diff whitespace 검사, production/scenes/assets/old evidence/adapter/PDF/receipt의 무변경 readback | 공용 신규 도구·bridge·대량 변형·새 저장 체계를 만들지 않음. 새 게임 실행·모션·모바일/Human 검증은 NOT_RUN |

자동화 교훈은 기존 publication 테스트에 반영했다. **새 기획을 쓰기 위해 과거 승인 PDF를 덮어쓰지 않고, 그 PDF의 정확한 source snapshot을 검증한다.** Base 승격은 공용 후보이며 이번 턴 Base 파일 변경·채택 lock 교체는 하지 않았다. 임시 branch/worktree는 만들지 않았고 기존 타 작업 worktree는 보존했다.

**현재 작업:** 2026-08-31 user direction에 따른 title boat waiting, explicit voyage start boundary, time-paired static sky + independently flowing sea, 하단 boat framing과 승인된 narrow waterline contact motion reconciliation을 구현하고 current machine/runtime verification을 완료했다. 2026-09-01 Look Around는 whole-composite art 대신 angle-specific foreground를 shared static sky + flowing sea 위에 합성하도록 교정했고, Bright/spring에는 기존 정적 하늘과 흐르는 바다를 유지한 별도 구름·꽃섬 parallax slice를 연결했다. Base 적용 순서와 운영 contract는 `docs/operations/MY_LITTLE_BOAT_BASE_ADAPTER.json`이 project-local로 소유한다. 기존 사용자 승인 후면 3/4 normal foreground, local motion comfort, actual voyage postcard와 fish/completed-voyage local ledger, saved floral cushion/main-postcard-omission evidence는 유지한다. Human/device comfort는 별도 요청 전까지 `NOT_RUN`이다.

### 2026-09-02 Blueprint publication recovery receipt

`BLUEPRINT_PUBLICATION_RECOVERY_20260902`는 사용자 보고인 “블루프린트가 이전 버전보다 퇴행”을 정본·실제 화면·기존 PDF까지 다시 대조해 복구한 기록이다. 이 기록은 **five complete review loops**를 보존한다. 새 PDF는 사람이 빠르게 읽는 current derived publication일 뿐이며, 의미·승인·증거의 원본은 계속 `docs/design/PROJECT_GDD.md`다.

| Loop | 실제 재확인 | 검증된 finding | 적용 또는 보존한 경계 | 재검증 |
| --- | --- | --- | --- | --- |
| 1 | 최신 user direction, `AGENTS.md`, GDD, 문서 map, runtime capture, 구형 20260828/20260829 PDF와 미발행 20260830 visual PDF를 대조 | 구형 PDF는 현 치비·타이틀 대기·항해 시작·분리된 하늘/바다 흐름과 다르거나 `구현 전` 흐름을 말해 current publication이 될 수 없었다 | GDD를 유일 human-facing canon으로 유지하고, 구형 PDF는 historical로 명시했다 | stale/current source 경계와 실제 title/voyage capture를 다시 읽었다 |
| 2 | GDD-only로 유지, 구형 visual PDF 재사용, source-bound 새 derived PDF의 세 대안을 비교하고 ReportLab font guidance와 현재 한글 font availability를 확인 | GDD-only는 사람이 보는 발행물 공백을 남기고, 구형 재사용은 퇴행을 되살린다 | current GDD·실제 capture·정확 SHA-256 receipt를 묶는 10쪽 derived PDF를 `ADOPT`했다 | PDF가 technical receipt detail 대신 player/system/screen route만 선택하도록 GDD publication boundary를 읽었다 |
| 3 | source-bound publication contract를 먼저 추가한 뒤 builder·receipt·문서 map을 생성 | 첫 builder 호출은 wrapped-text font positional argument 오류로 실패해 출력이 만들어지지 않았다 | font argument를 명시 호출로 교정하고, GDD/builder/이미지/output hash와 content-bound revision을 receipt에 기록했다 | profile contract가 current file 존재·hash binding·current route를 검사하도록 확장했다 |
| 4 | Poppler로 10쪽 전체를 render하고 cover, title, normal, camera, time, scenery, action, rest, evidence page를 실제 열어 비교 | cover 인용문이 잘렸고 portrait capture의 crop이 의도를 잃었다 | GDD 인용 regex와 containment layout을 교정했다 | 재렌더 뒤 title wait·항해 시작·current chibi image가 잘리지 않음을 확인했다 |
| 5 | 재렌더한 dense rest page, PDF text extraction, focused/profile suite, Godot import·game smoke, diff check, remote exact-head를 다시 비교 | rest page의 중복 인용문이 card와 겹쳤다. runtime source는 이 publication change로 변하지 않았다 | 중복 인용문을 제거했다. runtime 구현·기존 evidence·Human/device `NOT_RUN` 경계는 보존했다 | 10쪽 visual readback, current-route structural check, Python 12 tests, headless import/game smoke, binary-aware diff check와 push readback을 통과했다 |

현재 output은 `output/pdf/MY_LITTLE_BOAT_HUMAN_GAME_BLUEPRINT_20260902.pdf`이고 source/asset receipt는 같은 경로의 `.receipt.json`이다. 사용자·기기·접근성·오디오·출시 판정은 이 기계적 publication recovery의 범위가 아니며 계속 `NOT_RUN`이다.

## 0. 2026-08-30 현재 runtime receipt

아래 표가 현재 runtime truth다. 이후의 `Issue #99`/`Phase 2` 절은 구현 전 기록이므로 historical context로만 읽고, 이 receipt를 덮어쓰지 않는다.

| 주제 | 현재 구현 | 검증 상태 |
| --- | --- | --- |
| 게임명과 브랜드 표지 | `project.godot` display name은 `MY LITTLE BOAT`다. `MLB-BRAND-TITLE-001`은 user-locked asset이며 `GameScene/TitleOverlay/TitleLayout/BrandLogo`의 identity-neutral consumer에 연결됐다. | title-brand contract `PASS`; `2026-08-31-title-boat-flow` OpenGL capture `PASS`; Human brand/readability `NOT_RUN` |
| 시작 경로 | `project.godot`이 `res://scenes/game.tscn`으로 곧바로 진입한다. 첫 프레임은 실제 보트·동반자·바다와 로고·`항해 시작`만 보이는 타이틀 대기다. `start_voyage_from_title()`만 `GameState.begin_voyage()`를 호출하고, 그 뒤 compact `쉬는 메뉴`가 열린다. | title-entry contract `PASS`, headless game smoke `PASS`, 540×960 GPU capture `PASS`; Human calm `NOT_RUN` |
| 기분과 저장 시간대 | `GameState`에서 `selected_mood`와 saved time selector를 제거했다. 항해 기록은 `오늘의 항해`로 중립화했다. | state/album contracts `PASS` |
| 현지 시간대 | `RealTimeAtmosphereResolver`가 `05–08=dawn`, `09–16=bright`, `17–20=sunset`, `21–04=night`를 visual-only로 결정한다. 30초 갱신과 focus/resume 갱신이 있다. | injected-hour contract `PASS`, 네 시간대·두 카메라 capture `PASS` |
| 승인 풍경 asset | `MLB-BG-SPLIT-001..008`은 `dawn / bright / sunset / night`의 static `SkyBackdrop`와 flowing `SeaBackdrop` current pair다. `MLB-BOAT-FLT-005`는 `BoatWaterContact`, user-approved `MLB-BOAT-FLT-006`은 `BoatWaterlineContact`다. `MLB-AMB-MOTIF-001..006`은 active foreground의 dedicated normal·Appreciation `AmbientSceneryPass` consumer다. 이전 `MLB-BOAT-FLT-001/002/003/004` combined source와 `MLB-BP-VIS-001/002/003/004/005`는 historical/legacy consumer를 위해 보존하되 current split route에서는 superseded다. `006`은 Human Blueprint flow-map으로 runtime 미소비다. | split-background contract, time/ambient/look-around/capture guard contracts `PASS`; `2026-08-31-split-sky-sea-background` OpenGL 9장 captured; Human motion/color comfort `NOT_RUN` |
| 저밀도 풍경 | `DriftSceneryDirector`는 foreground delta만 누적해 첫 **기회**를 90–150초에 예약하고, 기회마다 65% 확률로 현재 local-time의 `MLB-AMB-MOTIF-001..006` 중 하나를 표시한다. 표시 여부와 무관하게 이후 기회는 120–180초 뒤에 다시 예약된다. bright·sunset은 즉시 같은 motif를 반복하지 않는다. `GameScene`은 static `SkyBackdrop` + flowing `SeaBackdrop`을 유지한 채 chosen exact texture를 normal·Appreciation `AmbientSceneryPass`에 넣고, authored side hint `backdrop_offset_x`를 ±21 world-unit transit로 넓혀 약 14초간 좌우 이동·입퇴장 fade한다. pass는 세로 화면 높이를 overscan하므로 수평 image edge가 보트 화면을 가르지 않는다. Look Around art는 건드리지 않는다. 버튼·목적지·만료·보상 track은 없고, `save_memory=true`만 `GameState.record_ambient_memory`를 거쳐 `user://ambient_memory_v1.cfg`에 즉시 저장한다. 0회 항해는 정상이며 UI에 확률·대기 시간·missed state는 없다. | director/scene + ambient persistence/state/game-scene + motif asset contracts `PASS`; six 540×960 OpenGL pass captures `PASS`; Human long-run observation `NOT_RUN` |
| 밝은 봄 분리 parallax | `RealTimeAtmosphereResolver`가 현지 월 `3..5`를 visual-only `spring`으로만 해석한다. `bright + spring`일 때 세 `SeasonalCloudLayer`가 각 camera path에서 runtime-local chroma-key material로 느리게 지나가고, exact `MLB-AMB-SEASONAL-ISLAND-001`은 existing 90–150초/120–180초 foreground 기회·65% chance 내부에서 normal·Appreciation에만 꽃섬 transit으로 선택된다. 꽃섬은 source canvas를 복제하지 않고 `region_enabled`, `Rect2(632, 350, 1028, 350)`, `pixel_size=0.005`로 수평선의 작은 landmark만 표시하므로 하단 보트 항로로 들어오지 않는다. 기존 static sky, flowing sea, Look Around island 부재, cadence, chance, ambient memory/save, reward와 time 의미는 유지한다. `standard/gentle/still`은 구름·섬 motion을 `1.0/0.5/0.0`으로만 조절한다. | seasonal/director/ambient/split/forward-drift/comfort contracts `PASS`; 57 headless bounded batch `PASS`; 540×960 Windows OpenGL normal·Appreciation capture `PASS`. Display shutdown의 generated-WAV two-instance warning은 existing engine baseline이며 Human/device motion·audio comfort `NOT_RUN` |
| 꾸미기 consumer | `DecorPanel`이 player/pet local selector와 boat decor controls를 제공하고, `DecorPreview`의 독립 `BoatSpace` instance가 그 state를 즉시 표시한다. 기본 C+강아지 final composite에서는 저장된 `pet_corner=pet_cushion, appearance=floral`만 bow-side overlay로 소비한다. 기존 save ID의 alternate A/B player, cat/rabbit/otter, `stripe`·`moon`은 user-approved canonical chibi paths로 layered card/decor texture에 연결된다. `rail_accent=postcard`는 main rest composite에 합성하지 않고 independent preview의 actual rail face로만 소비하며, 실제 voyage photo postcard는 Album에서 본다. 숨김 상태에서는 SubViewport 3D, render target, camera, preview BoatSpace를 모두 비활성화하고, 열 때만 함께 활성화한다. | identity/runtime-image/capture-guard/final-composite/decor-preview contracts `PASS`; alternate 540×960 GPU capture inspected; Human readability `NOT_RUN` |
| 함께한 시간 consumer | `GameScene`은 foreground active-voyage delta만 `GameState.together_time_seconds`에 더하고, `TogetherTimePersistence`가 `user://together_time_v1.cfg`에 local-only로 저장한다. `AlbumView`만 duration·관계 문구를 표시한다. | persistence/state/game-scene/Album contracts `PASS`, 540×960 Album GPU capture inspected; Human readability `NOT_RUN` |
| 모션 편안함과 기본 하늘·바다 흐름 | `ComfortPreferences`가 `user://comfort_preferences_v1.cfg`의 normalized `standard/gentle/still`만 저장한다. `GameScene`은 camera y bob, 하단 20% 기준의 `BoatSpace` y bob/roll, 목적지 없는 순환형 전후 surge와 미세한 측면 current, `BoatWaterContact`와 `BoatWaterlineContact`의 breath/offset/scale을 각각 `1.0 / 0.5 / 0.0`으로 곱한다. title waiting도 visual-only 저진폭 bob과 lateral sea-only flow를 보이지만 voyage timer·together time·ambient director는 전진하지 않는다. static `SkyBackdrop`는 material override가 없고, `SeaBackdrop`만 shared lateral `flow_offset`을 받는다. 항해 시작 뒤에는 near-water만 `forward_flow_offset`을 받아 수평선에서 하단으로 진행하며 speed tier와 comfort scale을 함께 쓴다. 두 contact는 same x/z와 거의 같은 y bob을 따르고, legacy ripple은 기존 surge에 맞춰 아주 작은 wake emphasis를 더한다. `MLB-BOAT-FLT-006`은 depth test를 유지한 앞쪽의 얇은 선체 접점으로 runtime 소비되고, sea-focused Appreciation mode에서는 `BoatSpace`와 두 contact를 함께 숨겨 하단 UI와 겹치지 않는다. | split/background/time/ambient/look-around/capture guard contracts `PASS`; 2026-09-02 OpenGL normal 2-second pair upper sky `0.00%`, lower sea `79.29%` change; Human motion/color comfort `NOT_RUN` |
| 항해 포스트카드 | `PhotoMemoryPersistence`가 `user://voyage_postcards_v1.cfg`와 local PNG directory를 함께 소유한다. `GameScene._capture_voyage_postcard()`는 public `TakePhotoButton` 흐름에서 selection UI만 잠시 숨기고 post-draw `ViewportTexture.get_image()`를 저장한 뒤 가시성을 원상 복구한다. `AlbumView`는 유효 PNG만 newest-first 세 장으로 표시하며 score/reward/share를 만들지 않는다. | persistence/state/game-scene/Album contracts와 isolated bright/Album GPU capture `PASS`; Human readability `NOT_RUN` |
| 물고기와 완료 항해 기록 | `MemoryLedgerPersistence`가 `user://memory_ledger_v1.cfg`의 `fish`와 `voyage_records` string 목록만 즉시 local save·restore한다. `GameState.add_fish()`와 post-zero `complete_voyage()`가 각각 저장하고, Album은 복원된 최신 항목을 요약·recent memory로 소비한다. delayed bottle letter는 읽거나 쓰지 않는다. | persistence/state/Album contracts `PASS`; restored Album 540×960 OpenGL capture `PASS`; Human readability `NOT_RUN` |
| 조용한 낚시와 작은 상호작용 | `CalmFishingSession`은 catch·quiet no-catch·cancel을 별도 state로 처리한다. catch만 기존 `GameState.add_fish()`를 호출하며, quiet/cancel은 저장·점수·연속 보상·손해 없이 action label을 reset한다. 동반자 `나란히 쉬기`는 existing `rest` pose와 private `moment_id`를, 난간 `파도 소리 듣기`는 text-only `moment_id`를 반환한다. | focused fishing/interaction contracts `PASS`; game-scene OpenGL contract `PASS`; quiet-fishing·pet-rest 540×960 OpenGL captures `PASS`; Human readability `NOT_RUN` |
| 부유 보트와 기본 normal foreground | 보트가 없는 backdrop 위에 primary `BoatSpace` 한 개와 `BoatWaterContact` legacy ripple, `BoatWaterlineContact` narrow contact를 표시한다. 보트의 base y는 `-2.7`로 540×960 세로 화면 하단 20% 근처에 두며, 0.052 unit 상하 bob과 최대 1.15° roll, 목적지·경계·저장 없이 반복되는 최대 0.16 unit 전후 surge와 0.022 unit 측면 current를 갖는다. 두 수면 접점은 같은 전후·측면 offset을 따라가며, legacy ripple만 surge 때 미세하게 넓어진다. 기본 C+강아지 route의 `FinalDioramaCard`는 `chibi-normal-rear-chroma-key.png`와 `chibi_normal_chroma_key.gdshader`의 explicit `matte_texture` uniform을 소비해, 녹색 기술 배경만 alpha 처리한 stern-side chibi player·dog·boat foreground를 표시한다. player는 stern rail에 기대어 뒷모습으로, dog는 옆에서 함께 보인다. `DioramaCameraRig`만 보트 뒤쪽 위로 옮겼고 Look Around rig는 보존했다. Appreciation은 sea-first 화면을 위해 `BoatSpace`와 두 contact를 숨긴다. card `pixel_size`는 `0.0037`이며, time backdrop·water contact·bob과 분리된다. 숨긴 `DecorPreview`의 renderer, camera, BoatSpace도 함께 비활성화해 미리보기의 `CylinderMesh`가 normal capture 경로에 새지 않게 했다. | rear-normal/material/final-card/direct-entry/diorama/decor/forward-drift/waterline/appreciation contracts `PASS`; 540×960 Windows OpenGL lower-frame title/voyage/Appreciation capture `PASS`; Human motion comfort `NOT_RUN` |
| Look Around | `LookAroundCameraRig/LookAroundCamera3D`, `LookAroundButton`, `LookAroundCameraController`, local `_look_around_mode`와 explicit three-camera routing을 사용한다. active `InputEventScreenDrag`/PC drag만 yaw `±135°`, pitch `-16°..38°`, zero roll로 처리한다. Appreciation·decor·Album은 Look Around를 종료하며, gameplay state를 바꾸지 않는다. `LookAroundPresentationRouter`는 user-locked `MLB-LOOK-FG-001..004` exact foreground를 `port`·`starboard`·`aft`·`overhead`에 연결한다. `LookAroundForeground`는 opaque magenta technical matte를 `look_around_foreground_chroma_key.gdshader`로만 alpha 처리하고, non-front에서도 current static `SkyBackdrop`와 flowing `SeaBackdrop`을 함께 유지한다. non-front에서는 중복 normal card만 숨기고 primary `BoatSpace`와 `BoatWaterContact` state·motion은 유지한다. | foreground/router/input/game-scene/runtime-asset-guard contracts `PASS`; `2026-09-01-look-around-foreground-split` normal·네 각도·Appreciation 540×960 OpenGL capture `PASS`; 1.8초 port pair sky `0.00%` / open sea `58.44%` change; Human motion comfort, touch reachability, long-run calm `NOT_RUN` |

### 2026-08-31 승인 narrow waterline v2와 하단 boat framing delivery receipt

**판정:** `FEASIBLE → IMPLEMENTED → MACHINE_VERIFIED → RUNTIME_CAPTURE_VERIFIED`. 이 판정은 user-approved image의 repository copy, actual `Sprite3D` consumer, machine contracts와 Windows OpenGL capture에만 적용합니다. 사람의 실제 모바일 휴식감·색감·터치·장시간 motion comfort는 `NOT_RUN`입니다.

| Loop | 실제 확인 | 검증된 finding | 적용 또는 상태 | 회귀 증거 |
| --- | --- | --- | --- | --- |
| 1 | current `AGENTS.md`, GDD, visual inventory, `game.tscn`, `game_scene.gd`, legacy ripple consumer, approved generator candidate를 fresh-read | 선체 하단의 얇은 별도 접점은 actual runtime consumer가 필요했고, 기존 ripple은 확산 수면으로 유지하는 편이 범위·시각 역할에 맞음 | `MLB-BOAT-FLT-006`을 v2 좁은 contact 전용 asset ID로 선택 | existing boat/contact drift와 save/reward 경계는 유지 |
| 2 | `test_waterline_contact_v2_contract.gd`를 code보다 먼저 실행 | canonical PNG와 `BoatWaterlineContact`가 없어서 예상한 두 assertion이 실패 | source와 canonical copy의 SHA-256을 대조한 뒤 Scene consumer와 drift owner를 추가 | focused contract `PASS` |
| 3 | Windows OpenGL 540×960 title capture에서 깊이·높이 대안을 비교 | 초기 `y=0.20, z=-0.04`는 너무 낮고 camera-side라 waterline이 거의 읽히지 않음 | depth test를 유지한 `y=0.30, z=0.38`, bright alpha `0.42`로 보정 | title/voyage capture에서 캐릭터·동반자를 가리지 않는 얇은 양옆 접점 확인 |
| 4 | user가 요구한 더 낮은 framing을 contract와 GPU frame으로 재확인 | 첫 낮춤은 보트가 화면 중앙 아래에 남아 요청한 하단 20% 근처에 미달 | `BoatSpace=-2.7`, legacy ripple=-2.7, narrow contact=-2.4로 같은 기준을 이동 | lower-frame title/voyage capture에서 `쉬는 메뉴`와 비중첩 |
| 5 | Godot import, sorted 53 headless contracts, Windows GL display-only chroma proof, main/game/album/project smoke, Python profile·CI checks, exact capture hash readback | 기존 forward-drift test가 절대 world-y=0 가정을 갖고 있어 하단 배치를 잘못 실패로 판정 | test를 lowered `BoatSpace` 대비 상대 water-contact base 검증으로 교정하고 재실행 | all=54, headless=53, display-only=1, failures=0; Python `7 passed`; OpenGL evidence hashes are recorded in `docs/evidence/2026-08-31-waterline-contact-v2/` |
| 6 | same lower-frame OpenGL capture에서 Appreciation surface를 확인 | 낮아진 normal BoatSpace가 `감상 끝내기`와 겹침 | Appreciation enter/leave마다 `BoatSpace`와 두 contact를 함께 토글하도록 보정 | diorama avatar-camera contract `PASS`; 540×960 Appreciation capture shows sea/horizon and the non-overlapping exit control |

선정 구조는 `ADOPT`입니다. `BoatWaterContact`는 뒤쪽의 넓은 확산 ripple로 유지하고, user-approved transparent `MLB-BOAT-FLT-006`은 선체 하단의 좁은 contact로 분리합니다. `REJECT`한 대안은 v1처럼 보트·승객을 넓게 덮는 front puddle과, 보트만 움직이고 수면 접점을 world height에 고정하는 방식입니다. Godot `Sprite3D`는 3D world에서 texture를 표시하고, `Camera3D`는 viewport의 active camera로 scene projection을 제공하므로, 실제 renderer capture로 최종 depth·height를 검증했습니다. [Godot Sprite3D 공식 문서](https://docs.godotengine.org/en/stable/classes/class_sprite3d.html), [Godot Camera3D 공식 문서](https://docs.godotengine.org/en/stable/classes/class_camera3d.html)

### 2026-08-31 타이틀 보트·연속 수면 흐름 delivery receipt

이 receipt의 current exact base는 `7181d5e`이며, implementation은 shared dirty worktree에서 아직 commit·push 전이다. `git fetch origin --prune` 후 `HEAD=7181d5e`, `origin/main=7181d5e`, ahead/behind=`0/0`을 확인했다. 다른 owner의 uncommitted 변경이 넓게 남아 있으므로, 이 상태에서 direct `main` pull/push나 unrelated staging은 금지한다.

| Loop | 실제 확인 | 검증된 finding | 적용 또는 상태 | 회귀 증거 |
| --- | --- | --- | --- | --- |
| 1 | latest user direction, `AGENTS.md`, GDD, visual inventory, `game.tscn`, `game_scene.gd`, `GameState`, existing contact capture를 fresh-read | startup은 `_ready()`에서 즉시 `begin_voyage()`를 호출했고, `SeaBackdrop`은 camera-local fixed card이며, contact origin은 `y=-0.06`이었다 | title wait boundary와 below-horizon continuous flow를 approved bounded package로 채택 | old direct-entry contract를 새 acceptance로 rewrite할 준비 완료 |
| 2 | `test_direct_boat_entry_contract.gd`, identity/title/forward-drift contract를 code보다 먼저 실행 | title overlay, explicit start boundary, water-flow shader, contact placement가 없어서 expected 15 assertions가 실패 | failure-first receipt를 유지하고 source/Scene 구현 시작 | failure output preserved in session tooling; no false PASS claim |
| 3 | `game.tscn`, `game_scene.gd`, 초기 합성 수면 흐름 셰이더를 구현하고 focused 4 contracts와 game scene smoke를 실행 | title wait에서 `_apply_appreciation_mode()`가 rest button을 다시 노출함 | title presentation을 final UI pass 뒤 다시 적용해 title 동안 menu를 숨김. 합성 수면 셰이더는 2026-08-31 분리 하늘·바다 구조로 교체됐다 | direct-entry, identity, title-brand, forward-drift contracts와 headless scene smoke `PASS` |
| 4 | Windows OpenGL 540×960 title/voyage 0s·2s capture와 height/depth contact probes를 실제로 비교 | wide legacy ripple은 보트 하단 waterline을 충분히 읽히게 하지 못했다. procedural shadow probe도 밝은 바다에서 효과가 불충분했다 | ineffective shadow source/node/test를 제거했다. one dedicated waterline raster를 built-in image model로 생성했지만 `GENERATED_CANDIDATE`로만 유지한다 | current flow capture persists at `docs/evidence/2026-08-31-title-boat-flow`; candidate has no repo path, no consumer, no canon registration |
| 5 | Godot import, sorted 52 headless contracts, display-only chroma proof, two Python profile checks, project/scene smoke, persisted frame region delta를 rerun | no new code/test regression. lower-water `y=650..850` region changed `93.17%` in title 2s pair and `95.98%` in voyage 2s pair | title entry and continuous flow retained. waterline contact remains explicitly `PARTIAL_IMPLEMENTED` pending user `LOCK` | 52/52 headless `PASS`; OpenGL chroma proof `PASS`; Python `7 passed`; project and game scene smoke `PASS` |

이전 broad v1 waterline candidate는 historical rejected exploration이다. 이는 repository canonical asset·Scene consumer·test reference·release evidence가 아니다. 현재 승인·구현 asset은 `MLB-BOAT-FLT-006` v2이며 위 receipt와 `docs/evidence/2026-08-31-waterline-contact-v2/`가 owner다.

이전 direct-entry 보강은 Godot `4.7.1.stable.official.a13da4feb`에서 `tests/test_*.gd` 36/36 `PASS`를 기록했다. 현재 설치된 Godot `4.7.2.stable.official.ed1daf0bf`에서 natural-motif, main-postcard-omission, fish/completed-voyage ledger, quiet-action, alternate chibi canonical rebind 뒤 focused 계약을 다시 실행했다. `tests/capture_approved_alternate_chibi_family.gd`는 NVIDIA RTX 3050 OpenGL 3.3에서 A+cat+stripe, B+rabbit+moon, A+otter+stripe의 540×960 frame을 기록했다. `RestingSoundscape`는 headless에서 출력 없는 generated audio를 시작하지 않고, real-display lifecycle에서는 stop·stream release를 수행한다. Human/device visual and audio comfort는 `NOT_RUN`이다.

### 2026-08-31 malformed-merge recovery machine-verification addendum

- `7181d5e`의 literal VCS conflict block 100개를 제거하고, current runtime에 맞는 첫 번째 부모 `4cf09d9`의 exact blob 35개를 복구했다. 복구 뒤 `git diff --check`, marker scan, `godot --headless --path . --quit`, main/game/album scene smoke가 모두 통과했다.
- malformed-merge recovery 당시 Godot 계약 52개 중 headless-safe 51개를 정렬된 CI discovery와 같은 inclusion/exclusion 경계로 실제 다시 실행했다. 이 경로의 postcard `ViewportTexture` assertion은 명시적으로 `SKIP`이며, skip은 renderer PASS가 아니다.
- `test_chibi_normal_chroma_material_proof.gd`는 Windows display driver + `gl_compatibility`에서 NVIDIA GeForce RTX 3050, OpenGL 3.3.0 NVIDIA 572.16으로 실제 실행해 `PASS`했다. 생성된 `user://machine-test-evidence/chibi-normal-material-proof/chibi_normal_chroma_material_proof_540x960.png`은 SHA-256 `0198EDCD08C2F682C36D94ABA0FAC478277D9F2B6D121AEEFC1A8FFE7936878D`이며, shader가 녹색 technical matte를 남기지 않고 warm boat/player/dog foreground를 유지하는 machine renderer evidence다. 이전 GPU receipt는 historical evidence이며, 실제 기기 종료 동작과 Human audio comfort도 여전히 `NOT_RUN`이다.
- 이후 `godot-validation.yml`의 headless CI는 수동 명령 목록이 아니라 정렬된 `tests/test_*.gd` discovery를 사용한다. initial recovery receipt는 `all=52, headless=51, display_only=1`이었고, user-locked title brand contract가 추가된 current set은 `all=53, headless=52, display_only=1`이다. 새 52개 headless 집합은 local Godot 4.7.2에서 다시 exit 0으로 종료했다. 이 workflow 구성은 원격 CI PASS가 아니며, 예외 계약은 위 Windows GL Compatibility machine evidence로만 확인한다.

- **Current 2026-09-01 Look Around foreground receipt:** `all=57, headless=56, display_only=1`이다. `test_look_around_foreground_split_contract.gd`는 네 non-front foreground exact path, visible static sky, flowing sea ShaderMaterial, duplicate normal-card hiding을 확인한다. 56개 current headless 계약은 로컬 Godot 4.7.2에서 네 bounded batch로 aggregate success를 기록했고, import도 exit 0으로 끝났다. Windows OpenGL capture와 1.8초 port frame-pair 증거는 `docs/evidence/2026-09-01-look-around-foreground-split/`가 current owner다. 원격 CI와 Human/device comfort는 각각 `NOT_RUN`이다.

- **Current 2026-09-02 Bright/spring seasonal-parallax receipt:** `all=58, headless=57, display_only=1`이다. `test_seasonal_parallax_contract.gd`는 injected `bright + 3..5` only context, empty-month fallback, exact asset paths, three cloud/two island consumers, Look Around island absence, per-node material isolation, standard/gentle/still motion scale, no gameplay-ledger mutation을 확인한다. 원거리 꽃섬 보정은 두 island consumer의 `region_enabled`, non-edge `Rect2(632, 350, 1028, 350)`, projected distant scale을 추가로 고정한다. exact paths are additionally owned by runtime capture guard. Windows OpenGL capture는 같은 active transit의 normal early/mid/late와 Appreciation `540×960` frame을 저장하고, normal upper-sky cloud mark, horizon island mark, fixed boat silhouette 밖 하단 boat lane의 island-colour 부재, early/late center displacement `≥80px`를 확인한다. Current renderer output is `213px`. 실제 display capture는 exit `0`이지만 RestingSoundscape generated-WAV two-instance ObjectDB warning을 동일하게 보이며, minimal display reproduction과 일치하는 engine/lifecycle baseline으로 보존한다. 원격 CI와 Human/device motion·audio comfort는 각각 `NOT_RUN`이다.

- **Current 2026-09-02 forward-voyage-flow receipt:** `all=58, headless=57, display_only=1`이다. `GameScene`은 title waiting에서 `forward_flow_offset`을 소비하지 않고, active voyage에서만 `standard/gentle/still = 1.0/0.5/0.0`과 speed tier를 곱해 near-water UV travel을 누적한다. 세 `SeaBackdrop` material은 같은 phase를 받아 수평선은 고정하고 가까운 수면만 아래로 흐르게 한다. `test_voyage_forward_drift_contract.gd`는 title/still stop, normal speed minimum, tier ordering, three-camera uniform, boat/contact attachment와 no-save/no-duration/no-camera-mode boundary를 확인한다. 57 headless contracts는 `27 + 15 + 15` bounded batch로 passed했고, display-only material proof도 passed했다. Windows OpenGL bright normal 2-second pair는 lower sea `79.29%`, upper sky `0.00%` changed fraction을 기록했다. generated-WAV two-instance ObjectDB warning은 existing display lifecycle baseline이며, Human/device motion·audio comfort와 remote CI는 `NOT_RUN`이다.

**Human evidence ceiling:** 실제 기기의 첫 30초·5분 휴식감, 터치 target, 모션 민감성, 텍스트 가독성, 사운드 편안함은 `NOT_RUN`이다. 기계 계약과 capture가 이를 대체하지 않는다.

## 1. 먼저 읽을 것

1. `AGENTS.md`
2. `docs/design/PROJECT_GDD.md`
3. 이 handoff
4. `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md`
5. 실제 Scene, GDScript, 테스트, capture

이 repository는 Notion을 현재 정본으로 사용하지 않습니다. 이전 Notion은 historical discovery archive이며, active implementation 판단은 repository source와 runtime evidence를 우선합니다.

## 2. Issue #99 당시 제품 방향과 runtime gap

| 주제 | 현재 제품 정본 | 현재 main code | disposition |
| --- | --- | --- | --- |
| 시작 | 실행 즉시 normal 3/4 boat diorama | `scenes/main_menu.tscn`의 선택형 panel 뒤 `game.tscn` 진입 | `PRODUCT_SUPERSEDED_IMPLEMENTATION` |
| 오늘의 마음 | 제품에서 제거 | `selected_mood`, mood button, mood tone, record wording, 관련 test가 존재 | `PRODUCT_SUPERSEDED_IMPLEMENTATION` |
| 꾸미기 entry | 바다를 본 뒤 optional `꾸미기` | identity/pet/time 선택이 menu에 있고 decor는 game panel에 존재 | `PRODUCT_SUPERSEDED_IMPLEMENTATION` |
| 시간 기반 분위기 | 기기의 현지 현실 시간이 자동 적용, selector·saved preference 없음 | process-lifetime selection만 존재하고 menu OptionButton이 소비 | `PRODUCT_SUPERSEDED_IMPLEMENTATION` |
| 흘러가는 풍경 | active foreground 시간에만 low-density distant scenery와 durable ambient memory | `GameScene` foreground director → `GameState.record_ambient_memory` → `ambient_memory_v1.cfg` | `IMPLEMENTED / MACHINE_VERIFIED`; Human long-run observation `NOT_RUN` |
| 함께 보낸 시간 | active foreground voyage time만 Album에 조용히 표시 | `GameScene` foreground delta → `GameState` local total → `AlbumView` duration/relation copy | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human readability `NOT_RUN` |
| Ambient Discovery | low-density passive presentation + 작은 알림 + local auto-save | `DriftSceneryDirector` + non-interactive label + named local persistence owner | `IMPLEMENTED / MACHINE_VERIFIED`; Human long-run observation `NOT_RUN` |

현재 code가 존재한다는 사실은 해당 제품 방향이 여전히 승인되었다는 뜻이 아닙니다. 반대로 GDD 결정은 code/test/capture가 바뀌기 전까지 runtime PASS를 뜻하지 않습니다.

## 3. Issue #99 당시 구현 금지선

이 문서 정본화 PR에서는 아래 runtime owner를 수정하지 않습니다.

```text
scenes/main_menu.tscn
scripts/ui/main_menu.gd
scripts/core/game_state.gd
scripts/voyage/game_scene.gd
tests/test_calm_voyage_state.gd
tests/test_game_scene_contract.gd
tests/test_game_scene_time_of_day_contract.gd
tests/test_main_menu_identity_contract.gd
tests/test_main_menu_time_of_day_contract.gd
tests/test_main_menu_atmosphere_background_contract.gd
tests/capture_main_menu_atmospheres.gd
assets/
```

PR #19 `feat/social-fake-backend-20260824`도 `READ_ONLY_NO_ABSORPTION`입니다.

## 4. Issue #99 당시 Phase 2 implementation contract

다음 구현은 위 gap을 따로 쪼개서 부분적으로 고치지 않습니다. 아래를 한 contract로 묶어 설계·테스트·runtime capture·Human validation까지 검증합니다.

1. `project.godot`의 startup route가 새 local state에서 곧바로 normal boat diorama를 연다.
2. `GameState`가 mood를 retire하고, 현지 현실 시간을 순수 visual atmosphere로 resolve한다. selector·saved atmosphere를 만들지 않는다.
3. active foreground 시간만 쓰는 drifting scenery director가 distant scenery와 low-density ambient memory를 관리한다.
4. player appearance, pet species, boat decor가 in-voyage optional `꾸미기`에서만 접근 가능하다.
5. mood-facing UI, wording, color rule, test/capture dependency가 제거되거나 direct-entry contract로 대체된다.
6. 540 x 960 capture에서 boat-water contact, bob/wave/wake/reflection, avatar/pet/boat/sea/horizon hierarchy가 검증된다.
7. direct entry, local-time mapping, foreground-only scenery progress, no-mood migration, customization entry, camera parity를 test한다.
8. 사람의 첫 30초와 5분 휴식, mobile touch, sound comfort를 별도 Human evidence로 기록한다.

Godot 구현 가능성의 근거는 다음 공식 안정판 문서에 있다. Autoload는 Scene 사이 state를, `ConfigFile`과 `user://`는 local persistence를, SceneTree route는 main scene transition을 지원한다. 구현 세부와 error handling은 해당 Phase 2 contract에서 source/test를 읽고 결정한다.

- https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html
- https://docs.godotengine.org/en/stable/classes/class_configfile.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/filesystem.html
- https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html

## 5. Issue #99 당시 시각 consumer와 evidence ceiling

- `VIS-ENTRY-001`은 구형 main-entry full composition입니다. 보트가 물에 뜬다는 물리적 관계가 약하고 large selection panel이 sea-first first impression을 가리므로 `REJECTED_FOR_MAIN_ENTRY_RUNTIME_USE`입니다.
- `MLB-LOOK-CHIBI-NORMAL-REAR-001`의 opaque rear 3/4 source는 2026-08-30 사용자 승인 뒤 repository canonical path에 등록됐다. 이 source의 sky/water를 기술용 green matte로 분리한 `MLB-LOOK-CHIBI-NORMAL-REAR-MATTE-001`은 user-approved derived runtime asset이며, `BoatSpace/FinalDioramaCard`의 `ShaderMaterial_chibi_normal_chroma`와 explicit `matte_texture` uniform에 연결됐다. `ALPHA` chroma key는 technical green background만 투명하게 만들어 time backdrop·bob·water contact를 보존한다. stern-side rig, GPU material proof와 bright/night capture는 `ASSET_READY → IMPLEMENTED → RUNTIME_CAPTURE_VERIFIED`까지의 증거이며 Human/device comfort는 아니다. 기존 `MLB-LOOK-CHIBI-NORMAL-001`과 matte는 provenance만 유지하는 superseded default-normal asset이다.
- 현재 `main_menu` atmosphere background와 legacy C+dog diorama binary는 여전히 legacy menu surface에서 소비될 수 있다. 기본 game entry는 새 치비 normal consumer를 사용한다. user-approved saved `postcard`와 `pet_cushion=floral`은 새 chibi decor assets로 정본 등록·runtime 연결됐고, surface가 player/dog focal zone을 가리지 않는 540×960 GPU capture가 있다. user-approved alternate A/B identity, cat/rabbit/otter, `stripe`·`moon` decor variant도 non-destructive canonical copies로 current runtime family에 연결됐으며 saved IDs는 보존한다.
- `HANDPAINTED_STORYBOOK_3D_DIORAMA`, `SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT`, `INDIGO_RAIN_REFLECTION`은 `APPROVED_DIRECTION`입니다. generated exploration, source binary, runtime capture, Human approval은 서로 다른 evidence입니다.
- real-device touch, five-minute calm, visual fatigue, audio comfort는 모두 `NOT_RUN`입니다. direct-entry와 Album runtime capture는 존재하지만 Human/device evidence가 아닙니다.

## 6. Issue #99 적대적 검토 receipt

| Loop | 공격 질문 | finding | correction owner | 상태 |
| --- | --- | --- | --- | --- |
| 1 | 사용자 승인, human GDD, current code가 mood/start flow에서 충돌하는가 | 기존 docs가 mood selector를 current product로 설명 | GDD, README, Concept, Experience Bible, handoff, visual inventory | `CORRECTED` |
| 2 | 사람이 시스템의 행동·이유·피드백·압박 회피를 이해하는가 | 이전 master GDD가 AI/evidence 구조를 앞세움 | `PROJECT_GDD.md` | `CORRECTED` |
| 3 | 직접 시작·local persistence가 Godot 4.7 구조에서 가능한가 | 구현 가능성 근거가 사람용 문서에 없음 | GDD와 이 handoff의 official stable links | `CORRECTED` |
| 4 | 구형 composition rejection이 source binary 전체 폐기로 과장되는가 | old visual inventory가 menu asset을 current product approval으로 표현 | visual inventory | `CORRECTED` |
| 5 | 문서가 runtime/Human PASS, social 확대, asset batch를 암시하는가 | source/status 문구의 overclaim 위험 | GDD/handoff evidence ceiling | `CORRECTED` |
| clean recheck | 문서 owner·stale allowlist·GDD 구조·PDF text/visual·staged diff를 correction 뒤 다시 실행 | material conflict 없음 | 이 handoff | `CLEAN` |

이 clean recheck는 8-section GDD, 7-page PDF text/visual readback, active-current stale allowlist, staged diff scope까지 확인한 상태입니다. PR exact-head readback은 push 뒤 다시 기록합니다.

발견한 정본 충돌의 Incident / Solution / Lesson과 Base 승격 판정은 [2026-08-28 direct boat entry 정본 충돌 기록](../learning/2026-08-28-direct-boat-entry-canon-reconciliation.md)에 남깁니다.
