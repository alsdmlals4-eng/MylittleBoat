# 마이 리틀 보트

`my little boat`의 현재 방향은 작은 섬에서 농장을 돌보고 바다를 보며 쉬는 휴식 우선 게임이며, 아트 목표는 일본 청춘 애니메이션풍입니다. Godot 4.7 / GDScript를 유지합니다. **섬 농장은 아직 구현되지 않았습니다.** 아래 조작·시각 설명은 복구된 구형 보트 실행 버전의 안내입니다. 기존 보트 추가 개발은 중단하고 코드·자산·저장은 보존합니다.

## 먼저 알아둘 것

2026-09-20 **P1 농사 상태·시간·저장 기술 기반**을 추가했습니다. 현재 소비자는 자동 검사이며 새 섬 화면/조작은 아직 연결하지 않았습니다. 실행 첫 화면은 여전히 구형 보트입니다. 배를 타고 섬 밖을 구경하는 기능은 후속 방향으로 남아 있습니다.

**현재 검증 중단.** 기존 보트 회귀 테스트 일부가 실사용 저장을 변경하는 문제가 발견됐습니다. 아래 P1 명령은 신규 검사 경로 설명이며, 전체 기존 테스트/실제 장면 검사는 [handoff의 저장 보호 사고](docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md)를 해결하고 사용자 데이터 격리를 확인하기 전 실행하지 마세요. 현재 브랜치는 main 병합 완료가 아닙니다.

P1을 직접 확인하려면 이 checkout에서 아래를 실행합니다. 테스트는 실행별 임시 경로만 사용하고 종료 시 자신이 만든 파일을 정리합니다. 실제 농장 저장 경로는 후속 Scene에서 `user://island_farm_v1.cfg`를 주입하며, 이 검사로 production 농장을 생성하지 않습니다.

```powershell
$godotExe = 'C:/Users/user/Downloads/Godot_v4.7.2-stable_win64.exe/Godot_v4.7.2-stable_win64_console.exe'
& $godotExe --headless --path . --import
foreach ($name in @('test_recoverable_config_store','test_island_farm_state','test_island_save_contract','test_island_session_contract')) {
    & $godotExe --headless --path . --script ('res://tests/' + $name + '.gd')
    if ($LASTEXITCODE -ne 0) { throw ('검사 실패: ' + $name) }
}
```

농사 상태 검사는 심기/선택적 돌보기/성장/수확·중복 입력, 저장 검사는 실제 파일과 중단 복구·미래 버전 보호, 세션 검사는 종료/복귀·시계 이상·확정 뒤 이벤트와 실제 저장 재실행을 확인합니다. 통과는 새 화면·모션·재미·실기기 검증이 아닙니다. [상세 구현 계획](docs/superpowers/plans/2026-09-20-island-p1-state-save.md)과 [현재 검증 기록](docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md)을 함께 읽습니다.

- 현재 사람용 정본은 [프로젝트 GDD](docs/design/PROJECT_GDD.md)입니다.
- PDF는 기획 정본이 아닙니다. 역사적 발행본과 source-binding 한계는 [문서 지도](docs/DOCUMENTATION_MAP.md)에서 확인합니다.
- 작업 순서·선택 Base #883/#885·조건부 skill 경로는 [프로젝트 adapter](docs/operations/MY_LITTLE_BOAT_BASE_ADAPTER.json), 현재 진행 상태는 handoff의 최신 절이 소유합니다.
- [재미·표현 검증 기준](docs/design/PROJECT_GDD.md#재미표현-검증-기준)은 경험 가설과 실제 구현/화면/사람 검증을 연결합니다. 자동 PASS를 재미 PASS로 바꾸지 않습니다.
- 실제 코드·Scene·테스트·캡처의 사실은 [현재 Godot handoff](docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md)가 소유합니다.
- 이전 Notion은 이관이 끝난 historical archive이며 새 작업의 정본이나 동기화 대상이 아닙니다.
- 실행은 `scenes/game.tscn`으로 바로 들어갑니다. 이전 `main_menu.tscn`은 시작 경로가 아닌 legacy 자료이며, 제품 흐름을 결정하지 않습니다.

## 구형 보트 실행 경험

```text
실행
→ 이미 바다 위에 떠 있는 보트, 캐릭터, 동반자, 수평선
→ 그냥 쉬기 또는 사진·낚시·감상·작은 상호작용
→ 원할 때만 꾸미기에서 외형·동반자·보트 장식을 미리 보며 변경
→ 개인적인 기억을 남기거나 계속 머무르기
```

시작하면 기기의 **현지 현실 시간**에 맞춰 새벽·밝음·해질녘·밤 분위기가 자동으로 보입니다. 시작 화면이나 수동 분위기 선택은 없고, 기기 시계는 보상·진행·저장에 영향을 주지 않습니다. 게임을 켜 둔 active foreground 시간에 따라 새벽 바다 아치, 밝은 낮의 해초 또는 흰 절벽, 해질녘의 사암 코브 또는 갈대섬, 밤의 생물발광처럼 승인된 자연 명소가 낮은 빈도로 지나갑니다.

## 핵심 보호선

- 전투, 실패 상태, 경쟁, 랭킹, 광고, 결제, 일일 과제, 펫 관리 의무를 넣지 않습니다.
- 꾸미기와 동반자는 능력치·희귀도·최적화가 아닌 자기표현과 함께 보낸 시간입니다.
- 함께한 시간은 active foreground 항해의 실제 경과만 로컬에 남고, 앨범에서만 조용히 돌아봅니다. 사진·낚시·상호작용·저밀도 풍경은 선택형이며 이 시간을 늘리지 않습니다.
- 자동으로 기록된 저밀도 풍경은 `user://ambient_memory_v1.cfg`에, 물고기와 완료된 항해 기록은 `user://memory_ledger_v1.cfg`에만 로컬 저장되어 다음 실행의 앨범 행으로 돌아옵니다. delayed bottle 편지 내용은 이 저장 범위에 넣지 않습니다.
- 사진을 누르면 현재 항해의 UI 없는 실제 렌더 프레임이 `user://voyage_postcards_v1.cfg`와 로컬 PNG로 저장되고, 앨범의 최근 포스트카드 세 장으로 돌아옵니다. 점수·보상·공유·자동 삭제는 없습니다.
- `FriendBottle`과 `DriftBottle`은 실시간 채팅이나 공개 소셜이 아닌, 안전 조건을 충족한 뒤에만 가능한 느린 편지입니다.

## 구형 보트 시각 방향

기본 방향은 `HANDPAINTED_STORYBOOK_3D_DIORAMA`이며, 둘러보기는 `MLB-LOOK-STYLE-006`의 soft-matte chibi player·round dog·matte ivory/deep-teal dinghy·투명한 청록 수면을 사용합니다. 기본 C+강아지 Normal Diorama는 사용자가 승인한 후면 3/4 source `MLB-LOOK-CHIBI-NORMAL-REAR-001`을 사용합니다. 플레이어는 보트 뒤쪽 난간에 기대어 뒷모습으로, 강아지는 바로 옆에서 함께 쉬는 모습으로 읽힙니다. `FinalDioramaCard`는 그 source에서 만든 기술용 foreground matte `MLB-LOOK-CHIBI-NORMAL-REAR-MATTE-001`와 `chibi_normal_chroma_key.gdshader`를 실제로 소비합니다. 재질의 명시적 `matte_texture` uniform이 녹색 기술 배경만 alpha로 바꾸므로, 시간대별 하늘·수면 backdrop과 보트 부유는 그대로 유지됩니다. 밤은 `INDIGO_RAIN_REFLECTION` 분위기를 사용합니다.

승인된 자연 경관은 보트가 없는 water-only runtime backdrop 위에, foreground 시간의 낮은 밀도 temporary scene으로 연결되어 있습니다. 각 명소는 normal·Appreciation `SeaBackdrop`에만 10초간 적용되며 Look Around의 승인 각도 원화는 바꾸지 않습니다. 세로 화면에서 landmark가 사라지지 않도록 명소마다 배경만 좌우 보정하고, 후방 보트 구도·항해 시간·저장·보상은 바꾸지 않습니다. 첫 화면에는 하나의 primary `BoatSpace`만 보이며, 치비 player·강아지·보트와 수면 접점 리플이 함께 잔잔히 상하로 움직입니다. 기본 C+강아지 route에서 저장된 `꽃` 펫 쿠션만 같은 치비 family의 작은 bow-side overlay로 보입니다. `엽서`는 메인 휴식 장면에 합성하지 않고, 꾸미기 preview의 실제 난간 장식과 사진을 남긴 뒤 Album에서 보는 항해 포스트카드로 소비합니다. 꾸미기용 보트 미리보기는 메뉴를 열 때만 별도 renderer·camera·보트 instance를 활성화하므로, 첫 화면에 중복 보트나 임시 장식이 섞이지 않습니다. 이전 보트 포함 source binary는 역사·참조 자산으로 보존하며, normal runtime에는 소비하지 않습니다.

## 프로젝트 열기

1. Godot 4.7 stable 계열로 `project.godot`을 Import합니다.
2. 기본 main scene을 실행하면 보트·동반자·바다·수평선이 바로 보입니다. 첫 프레임에는 큰 조작 패널 대신 `쉬는 메뉴`만 표시됩니다.
3. 기기 현지 시각은 시각만 바꿉니다. `05–08` 새벽, `09–16` 밝음, `17–20` 해질녘, `21–04` 밤이며 보상·진행·저장에는 영향을 주지 않습니다.
4. 메뉴를 열면 사진, 감상모드, 둘러보기, 속도, `파도: 기본/잔잔/고요`, 낚시, 꾸미기, 상호작용, 앨범을 선택할 수 있습니다. `파도`는 보트·카메라·수면 접점의 자동 움직임 진폭만 `1.0 / 0.5 / 0.0`으로 바꾸는 기기 로컬 선택이며, 항해 시간·속도·보상·저장·시간대에는 영향을 주지 않습니다. `사진`은 선택 UI를 잠시 숨긴 실제 항해 프레임을 포스트카드로 저장합니다. `낚시`는 기다린 뒤 물고기를 남기거나, 입질 없이 조용히 거두거나, 기다리는 중 언제든 줄을 거둘 수 있으며 어느 경우에도 손해·점수·연속 보상은 없습니다. `상호작용`에서는 동반자와 나란히 쉬기, 난간에서 파도 소리 듣기처럼 짧은 문구와 작은 pose만 보입니다. `둘러보기`는 마우스·터치 드래그로 시점을 바꾸며, 승인된 좌·우·뒤·위 치비 원화를 실제로 전환합니다. 기본 시점·감상모드·꾸미기·앨범과는 독립적으로 전환되고, 항해 시간·속도·저장에는 영향을 주지 않습니다. `꾸미기`는 독립 보트 미리보기에서 외형·동반자·장식을 즉시 보여 주며, 기본 바다 화면은 바꾸지 않습니다. `감상모드`에서는 대부분의 UI가 숨겨집니다.
5. 현재 구현은 포그라운드에 실제로 머문 90–150초 뒤 첫 자연 풍경 **기회**를 예약합니다. 각 기회는 65% 확률로만 현재 시간대의 승인 명소를 보이며, 표시되지 않아도 다음 기회는 120–180초 뒤 조용히 예약됩니다. bright와 sunset은 같은 명소가 바로 다시 나오지 않습니다. 배경에 있던 시간은 누적되지 않으며, 5분 항해에 풍경이 0회인 것도 정상입니다. 이 확률과 다음 기회 시간은 화면에 표시되지 않습니다.

49개 계약 테스트와 540×960 runtime capture는 현재 Godot handoff에 기록합니다. 후면 기본 구도, 녹색 매트 제거, `파도` 세 단계, 실제 포스트카드 저장과 앨범 최근 세 장, 복원된 물고기·완료 항해 기록, 그리고 여섯 자연 명소는 기계 계약과 GPU capture로 확인했습니다. 다만 실제 기기에서의 첫 30초, 5분 휴식감, 터치, 모션, 텍스트와 오디오 편안함은 아직 사람 검증이 필요합니다. 각 상태와 근거 ceiling은 프로젝트 GDD와 handoff에서 확인합니다.

## 작업 규칙 검사와 Blender

프로젝트 운영 경로 검사는 `python -B -m unittest discover -s tests -p 'test_*.py' -v`로 실행합니다. 링크/계약 검사이며 게임 재미·Human 검증을 대신하지 않습니다. 현재 main과 보존된 continuation branch는 서로 다른 내용이므로 handoff의 브랜치 경계를 먼저 확인합니다.

Blender는 전역 설치/플러그인 변경 없는 portable CLI 경로를 별도 시험했습니다. 실행 파일·재실행 방법·Godot GLB 왕복 결과는 handoff의 2026-09-20 기록을 따릅니다. 라이브 MCP 제어 또는 완성된 게임 모델을 의미하지 않습니다.
