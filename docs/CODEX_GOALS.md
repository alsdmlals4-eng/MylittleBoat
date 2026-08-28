# Godot 구현 작업 기준

이 문서는 사람용 기획서가 아닙니다. 다음 Godot 작업을 작고 검증 가능하게 만들기 위한 구현 기준입니다. 제품의 현재 정본은 [프로젝트 GDD](design/PROJECT_GDD.md)이며, 실제 코드·Scene·테스트의 사실은 [현재 Godot handoff](handoffs/CURRENT_GODOT_IMPLEMENTATION.md)에서 확인합니다.

## 다음 구현의 출발점

다음 product 변경은 **direct boat entry**입니다.

- 현실 시간에 맞는 새벽·밝음·해질녘·밤 보트 디오라마로 바로 시작합니다. 수동 또는 saved atmosphere는 없습니다.
- 시작 전에 `오늘의 마음`, 외형, 동반자, 시간대, 장식을 묻지 않습니다.
- 외형·동반자·장식은 항해 안의 선택형 `꾸미기`에서만 바꿉니다.
- active foreground 시간에만 낮은 밀도의 drifting scenery가 진행하며, 이는 보상·경제·호감도·놓친 이벤트 패널을 만들지 않습니다.
- 구형 `main_menu.tscn` 선택 UI와 mood data는 `PRODUCT_SUPERSEDED_IMPLEMENTATION`입니다. migration 없이 부분적으로 지우지 않습니다.
- 보트가 바다에 붙여진 이미지처럼 보이지 않게, 물과의 접점·느린 bob·잔물결 또는 wake·반사/가림을 runtime capture로 확인합니다.

이 작업은 아직 **구현 시작 전**입니다. 새 asset batch, social, economy, unrelated refactor는 포함하지 않습니다.

## 작업 요청에 꼭 들어갈 것

1. 현재 `main`, `AGENTS.md`, GDD, handoff, 관련 Scene·script·test를 다시 읽습니다.
2. 변경하려는 player experience와 제외 범위를 한 문단으로 적습니다.
3. Godot 4.7·GDScript에서 필요한 Scene route, Autoload/local save migration, UI consumer를 구체적으로 적습니다.
4. 자동 test, headless scene smoke, 540 x 960 runtime capture, 사람이 하는 30초·5분 검증을 구분합니다.
5. 새로운 인간용 문서는 한국어로 작성합니다. 상태 code·path·API 이름은 혼동을 막기 위해 원문을 유지합니다.
6. material decision마다 관련 current owner와 공식 primary source를 다시 확인하고, authority drift·scope creep·실현성·증거 과장·visual drift를 공격적으로 재검토합니다.

## 공통 금지

- 전투, 실패, 경쟁, 등급, 숙제, 반복 파밍, 펫 관리 의무.
- realtime/global/public chat, public feed, follower/ranking, 안전 gate 전 DriftBottle 공개.
- ads, payments, gacha, rarity power, economy farming.
- Human 테스트나 runtime capture가 없는 품질 PASS 주장.
- 현재 open PR #19의 변경을 흡수·수정·병합하는 일.
