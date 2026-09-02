# MY LITTLE BOAT

> 파도 위에서, 함께 쉬는 시간

`MY LITTLE BOAT`는 내 캐릭터와 동반자가 작은 보트 위에서 바다를 바라보며 쉬는, 휴식 우선의 Godot 4.7 게임입니다. 이 게임에서 아무것도 하지 않고 머무르는 일은 비어 있는 시간이 아니라 완전한 플레이입니다.

## 먼저 알아둘 것

- 현재 사람용 정본은 [프로젝트 GDD](docs/design/PROJECT_GDD.md)입니다.
- 현재 사람용 빠른 읽기본은 [Human Game Blueprint PDF](output/pdf/MY_LITTLE_BOAT_HUMAN_GAME_BLUEPRINT_20260902.pdf)입니다. 이 파일은 [프로젝트 GDD](docs/design/PROJECT_GDD.md)에서 파생되며, source·generator·사용 이미지 hash는 같은 위치의 receipt로 검증합니다. PDF 자체는 정본이 아니므로, 바뀐 결정은 언제나 GDD와 [문서 지도](docs/DOCUMENTATION_MAP.md)를 우선합니다.
- 실제 코드·Scene·테스트·캡처의 사실은 [현재 Godot handoff](docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md)가 소유합니다.
- Base를 적용한 작업 순서, 프로젝트 전용 변형, v9.4.4 identity와 재사용 module 상태는 [My Little Boat Base adapter](docs/operations/MY_LITTLE_BOAT_BASE_ADAPTER.json)가 소유합니다. Base template·open PR·optional tool은 자동으로 프로젝트 정본이나 runtime dependency가 되지 않습니다.
- 이전 Notion은 이관이 끝난 historical archive이며 새 작업의 정본이나 동기화 대상이 아닙니다.
- 실행은 `scenes/game.tscn`의 **타이틀 대기**로 바로 들어갑니다. 실제 보트·동반자·바다가 잔잔히 움직이는 상태에서 확정 로고와 `항해 시작`만 보이며, 누르기 전에는 항해 시간·기억·보상이 시작되지 않습니다. 이전 `main_menu.tscn`은 시작 경로가 아닌 legacy 자료입니다.
- `MLB-BRAND-TITLE-001`은 “MY LITTLE BOAT / 파도 위에서, 함께 쉬는 시간”의 확정 브랜드 자산입니다. store·splash·GDD 표지와 `GameScene/TitleOverlay/BrandLogo`에만 쓰며, 첫 보트 장면의 플레이어 외형·동반자 선택·save·reward를 고정하거나 가리지 않습니다.

## 플레이 경험

```text
실행
→ 로고와 실제 보트가 잔잔히 떠 있는 타이틀 대기
→ `항해 시작`을 눌러 실제 항해 시간과 쉬는 메뉴 열기
→ 그냥 쉬기 또는 사진·낚시·감상·작은 상호작용
→ 원할 때만 꾸미기에서 외형·동반자·보트 장식을 미리 보며 변경
→ 개인적인 기억을 남기거나 계속 머무르기
```

시작하면 기기의 **현지 현실 시간**에 맞춰 새벽·밝음·해질녘·밤 분위기가 자동으로 보입니다. 수동 분위기 선택은 없고, 기기 시계는 보상·진행·저장에 영향을 주지 않습니다. 타이틀 대기와 항해 중에는 시간대별 고정 하늘과 독립 바다가 함께 보이며, 하늘·수평선은 안정적으로 머물고 바다만 계속 미세하게 흐릅니다. 항해가 시작된 뒤 active foreground 시간에 따라 새벽 바다 아치, 밝은 낮의 해초 또는 흰 절벽, 해질녘의 사암 코브 또는 갈대섬, 밤의 생물발광처럼 승인된 자연 명소가 낮은 빈도로 지나갑니다.

## 핵심 보호선

- 전투, 실패 상태, 경쟁, 랭킹, 광고, 결제, 일일 과제, 펫 관리 의무를 넣지 않습니다.
- 꾸미기와 동반자는 능력치·희귀도·최적화가 아닌 자기표현과 함께 보낸 시간입니다.
- 함께한 시간은 active foreground 항해의 실제 경과만 로컬에 남고, 앨범에서만 조용히 돌아봅니다. 사진·낚시·상호작용·저밀도 풍경은 선택형이며 이 시간을 늘리지 않습니다.
- 자동으로 기록된 저밀도 풍경은 `user://ambient_memory_v1.cfg`에, 물고기와 완료된 항해 기록은 `user://memory_ledger_v1.cfg`에만 로컬 저장되어 다음 실행의 앨범 행으로 돌아옵니다. delayed bottle 편지 내용은 이 저장 범위에 넣지 않습니다.
- 사진을 누르면 현재 항해의 UI 없는 실제 렌더 프레임이 `user://voyage_postcards_v1.cfg`와 로컬 PNG로 저장되고, 앨범의 최근 포스트카드 세 장으로 돌아옵니다. 점수·보상·공유·자동 삭제는 없습니다.
- `FriendBottle`과 `DriftBottle`은 실시간 채팅이나 공개 소셜이 아닌, 안전 조건을 충족한 뒤에만 가능한 느린 편지입니다.

## 시각 방향

기본 방향은 `HANDPAINTED_STORYBOOK_3D_DIORAMA`이며, 둘러보기는 `MLB-LOOK-STYLE-006`의 soft-matte chibi player·round dog·matte ivory/deep-teal dinghy·투명한 청록 수면을 사용합니다. 기본 C+강아지 Normal Diorama는 사용자가 승인한 후면 3/4 source `MLB-LOOK-CHIBI-NORMAL-REAR-001`을 사용합니다. 플레이어는 보트 뒤쪽 난간에 기대어 뒷모습으로, 강아지는 바로 옆에서 함께 쉬는 모습으로 읽힙니다. `FinalDioramaCard`는 그 source에서 만든 기술용 foreground matte `MLB-LOOK-CHIBI-NORMAL-REAR-MATTE-001`와 `chibi_normal_chroma_key.gdshader`를 실제로 소비합니다. 재질의 명시적 `matte_texture` uniform이 녹색 기술 배경만 alpha로 바꾸므로, 시간대별 하늘·수면 backdrop과 보트 부유는 그대로 유지됩니다. 밤은 `INDIGO_RAIN_REFLECTION` 분위기를 사용합니다.

승인된 자연 경관은 시간대별 고정 `SkyBackdrop`과 별도 흐름 `SeaBackdrop`을 바꾸지 않고, foreground 시간의 낮은 밀도 `AmbientSceneryPass`로 normal·Appreciation 화면의 수평선을 약 14초 동안 천천히 가로지릅니다. `SeaBackdrop`은 `voyage_split_sea_flow.gdshader`에서 수평선 아래에만 alpha를 내고 shared `flow_offset`을 적용하므로, 하늘·구름·원거리 landmark는 정지하고 바다만 흐릅니다. `항해 시작` 뒤에는 가까운 수면에만 별도 `forward_flow_offset`을 적용해 물결이 수평선에서 화면 하단으로 흘러오며, 타이틀 대기는 이 전진 phase 없이 보트가 잔잔히 떠 있는 장면으로 유지됩니다. [`docs/evidence/2026-09-02-forward-voyage-flow`](docs/evidence/2026-09-02-forward-voyage-flow/README.md)는 2초 normal voyage pair에서 lower sea `79.29%`, upper sky `0.00%` changed-pixel을 기록합니다. 네 시간대·두 카메라 OpenGL capture와 1.8초 frame pair는 [`docs/evidence/2026-08-31-split-sky-sea-background`](docs/evidence/2026-08-31-split-sky-sea-background/README.md)에 남깁니다. image는 화면 위아래로 overscan하고 좌우에서만 fade-in/out하므로, 보트 주변에 수평 카드 경계가 남지 않습니다. Look Around의 정면과 좌·우·뒤·위는 같은 분리 배경을 공유합니다. non-front 네 방향은 `MLB-LOOK-FG-001..004` foreground와 `look_around_foreground_chroma_key.gdshader`만 교체하므로, 보트·캐릭터·동반자는 각도별로 바뀌고 하늘은 고정, 바다는 계속 흐릅니다. 1.8초 port GPU pair는 [`docs/evidence/2026-09-01-look-around-foreground-split`](docs/evidence/2026-09-01-look-around-foreground-split/README.md)에 남깁니다. 후방 보트 구도·항해 시간·저장·보상도 바꾸지 않습니다. 첫 화면에는 하나의 primary `BoatSpace`만 보이며, 보트는 540×960 세로 화면의 하단 20% 부근에 머뭅니다. 치비 player·강아지·보트와 기존 확산 ripple, user-approved `MLB-BOAT-FLT-006`의 좁은 waterline contact는 같은 전후·측면·상하 drift를 따라 잔잔히 움직입니다. 감상모드에서는 이 normal foreground를 함께 숨겨 하단 조작과 겹치지 않는 바다·수평선 중심 장면으로 전환합니다. 기본 C+강아지 route에서 저장된 `꽃` 펫 쿠션만 같은 치비 family의 작은 bow-side overlay로 보입니다. `엽서`는 메인 휴식 장면에 합성하지 않고, 꾸미기 preview의 실제 난간 장식과 사진을 남긴 뒤 Album에서 보는 항해 포스트카드로 소비합니다. 꾸미기용 보트 미리보기는 메뉴를 열 때만 별도 renderer·camera·보트 instance를 활성화하므로, 첫 화면에 중복 보트나 임시 장식이 섞이지 않습니다. `MLB-BOAT-FLT-006`은 `BoatWaterlineContact`가 depth test를 유지한 채 선체 하단만 읽히게 하는 transparent 2172×724 runtime texture입니다.

## 프로젝트 열기

1. Godot 4.7 stable 계열로 `project.godot`을 Import합니다.
2. 기본 main scene을 실행하면 실제 보트·동반자·바다·수평선과 브랜드 로고, `항해 시작`이 보입니다. 이 대기 상태에서는 항해 시간이 흐르지 않습니다. `항해 시작` 뒤에만 큰 조작 패널 대신 `쉬는 메뉴`가 표시됩니다.
3. 기기 현지 시각은 시각만 바꿉니다. `05–08` 새벽, `09–16` 밝음, `17–20` 해질녘, `21–04` 밤이며 보상·진행·저장에는 영향을 주지 않습니다. 밝은 시간의 현지 월이 3–5월이면 작은 구름과 수평선 쪽의 먼 꽃섬이 시각적으로만 더해질 수 있지만, 계절명·날짜·설정·보상은 표시하거나 저장하지 않습니다.
4. 메뉴를 열면 사진, 감상모드, 둘러보기, 속도, `파도: 기본/잔잔/고요`, 낚시, 꾸미기, 상호작용, 앨범을 선택할 수 있습니다. `파도`는 보트·카메라·수면 접점의 자동 움직임 진폭만 `1.0 / 0.5 / 0.0`으로 바꾸는 기기 로컬 선택이며, 항해 시간·속도·보상·저장·시간대에는 영향을 주지 않습니다. `사진`은 선택 UI를 잠시 숨긴 실제 항해 프레임을 포스트카드로 저장합니다. `낚시`는 기다린 뒤 물고기를 남기거나, 입질 없이 조용히 거두거나, 기다리는 중 언제든 줄을 거둘 수 있으며 어느 경우에도 손해·점수·연속 보상은 없습니다. `상호작용`에서는 동반자와 나란히 쉬기, 난간에서 파도 소리 듣기처럼 짧은 문구와 작은 pose만 보입니다. `둘러보기`는 마우스·터치 드래그로 시점을 바꾸며, 승인된 좌·우·뒤·위 치비 원화를 실제로 전환합니다. 기본 시점·감상모드·꾸미기·앨범과는 독립적으로 전환되고, 항해 시간·속도·저장에는 영향을 주지 않습니다. `꾸미기`는 독립 보트 미리보기에서 외형·동반자·장식을 즉시 보여 주며, 기본 바다 화면은 바꾸지 않습니다. `감상모드`에서는 대부분의 UI가 숨겨집니다.
5. 현재 구현은 포그라운드에 실제로 머문 90–150초 뒤 첫 자연 풍경 **기회**를 예약합니다. 각 기회는 65% 확률로만 현재 시간대의 승인 명소를 보이며, 표시되지 않아도 다음 기회는 120–180초 뒤 조용히 예약됩니다. bright와 sunset은 같은 명소가 바로 다시 나오지 않습니다. 밝은 봄에는 기존 bright 명소와 함께 작은 꽃섬 하나가 같은 기회 풀에서 지나갈 수 있고, 구름은 그보다 느린 시각 전용 parallax로 움직입니다. 꽃섬은 원본의 투명 여백을 제외한 수평선용 영역만 사용하므로 하단 보트 항로와 겹치지 않습니다. 배경에 있던 시간은 누적되지 않으며, 5분 항해에 풍경이 0회인 것도 정상입니다. 이 확률과 다음 기회 시간은 화면에 표시되지 않습니다.

recovery revision 당시에는 Godot 계약 52개 중 headless-safe 51개를 다시 실행했고, `test_chibi_normal_chroma_material_proof.gd`는 Windows OpenGL Compatibility renderer에서 별도로 통과했습니다. 이후 title brand, user-approved waterline v2, 분리 하늘·바다, headless editor-plugin guard, Look Around foreground split, Bright/spring seasonal parallax, 항해 전진 수면 계약이 추가되어, 현재 GitHub CI는 정렬된 `tests/test_*.gd` discovery로 **58개 전체 수**, display 전용 예외 1개, **57개 headless 계약**을 fail-closed로 확인합니다. 현재 57개 headless 집합은 forward-flow 변경 뒤 로컬 Godot 4.7.2에서 다시 실행해 통과했습니다. 이 구성은 remote CI 실행 PASS가 아니며, display material proof를 headless `SKIP` PASS로 바꾸지 않습니다. Bright/spring은 같은 14초 transit의 normal early/mid/late와 Appreciation Windows OpenGL capture로 별도 renderer evidence를 남기며, early/late 꽃섬 중심의 최소 `80px` 이동을 검사합니다. 실제 기기에서의 첫 30초, 5분 휴식감, 터치, 모션, 텍스트와 오디오 편안함은 아직 사람 검증이 필요합니다. 각 상태와 근거 ceiling은 프로젝트 GDD와 handoff에서 확인합니다.
