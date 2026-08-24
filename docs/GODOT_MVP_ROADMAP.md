# Godot MVP Roadmap

`my little boat` Godot MVP를 **핵심 감정이 실제 플레이에서 작동하는지 검증하는 순서**로 진행합니다.

> **Authority:** 사람용 기획·경험·시각 방향은 Notion 정본에서 승인합니다. 이 로드맵은 승인된 방향을 repository 구현·검증 단계로 옮기는 execution mirror입니다.

## 1단계: 프로젝트 골격 — 완료

완료 기준:
- `project.godot`이 존재한다.
- `scenes/main_menu.tscn`, `scenes/game.tscn`, `scenes/album.tscn`이 존재한다.
- `scripts/core/`, `scripts/ui/`, `scripts/voyage/` 구조가 있다.
- README와 협업 문서가 Godot 기준으로 정리되어 있다.

## 2단계: 마음 선택 — 완료

완료 기준:
- 평온, 지침, 외로움, 설렘 버튼이 보인다.
- 선택한 마음이 `GameState`에 저장된다.
- 선택 후 게임 화면으로 이동한다.
- 마음이 좋고/나쁜 날씨로 단정되지 않고 하늘 톤에 미세한 차이를 만든다.
- 새 항해를 시작해도 이전 앨범 기억은 지우지 않는다.

## 3단계: 항해 화면 — 기술 골격 완료 / 실기기·시각 품질 검증 전

완료 기준:
- 플레이어 몸은 보이지 않는다.
- 보트 앞부분, 바다, 하늘을 감상하는 구도가 있다.
- 모바일 세로 화면 우선 구조가 있다.
- PC 마우스 드래그 시야 회전이 있다.
- `InputEventScreenDrag` 기반 모바일 화면 드래그 시야 회전이 있고 기존 pitch clamp와 수평 유지 규칙을 공유한다.

남은 증거:
- 제작 아트/환경음이 들어간 상태의 Human 시각·감정 검증.
- 실제 모바일 기기의 손감각, 터치 충돌, 버튼 크기, 텍스트 가독성 검증.

## 4단계: 핵심 조작 — Vertical Slice 구현 완료

완료 기준:
- 사진찍기가 기록을 남긴다.
- 감상모드가 실제로 비필수 UI를 숨기고 다시 돌아올 수 있다.
- 속도조절이 느림 / 보통 / 빠름으로 순환하면서 보트·카메라의 미세 표류 리듬을 바꾼다.
- 세 기능이 보상량이나 실패 조건을 바꾸지 않는다.

## 5단계: 5분 항해 루프 — Vertical Slice 구현 완료

완료 기준:
- 5분 타이머 상태를 `GameState`가 소유한다.
- 앨범을 열었다 돌아와도 현재 항해 시간이 이어진다.
- 활성 항해가 아닐 때 고아 항해 기록을 만들지 않는다.
- 5분 종료 후 완료된 항해당 정확히 1개의 오늘의 항해 기록이 생성된다.
- 종료 후에도 바다에 계속 머무를 수 있다.
- 기록 후 `다음 항해`를 선택하면 누적 기억을 보존한 채 마음 선택 화면으로 돌아간다.

## 6단계: Ambient Discovery — Vertical Slice 구현 완료

완료 기준:
- 병 속 편지 / 풍경은 상시 보상 버튼이 아니다.
- 항해 중 기다린 뒤 하나의 작은 발견으로 나타난다.
- 플레이어는 기록하거나 그냥 지나가게 둘 수 있다.
- 놓쳐도 실패/손해가 없다.
- 기록하면 앨범과 동반자 진행에 누적된다.

## 7단계: 선택형 조용한 낚시 — Vertical Slice 구현 완료

완료 기준:
- `캐스팅 → 기다림 → 입질 → 낚기`가 동작한다.
- 기다리는 중 줄을 거두어도 실패 패널티가 없다.
- 낚은 물고기는 앨범 기억으로 남는다.
- 반복 낚시만으로 동반자 호감도를 가장 빠르게 올릴 수 없도록 호감도 파밍과 분리한다.
- 낚시는 5분 항해와 바다 감상을 대체하지 않는 선택형 보조 콘텐츠다.

현재 제외:
- 어종 대량화
- 미끼 / 낚싯대 장비 / 줄 내구도
- 힘겨루기·텐션 미니게임
- 판매 / 요리 / 가격 / 낚시 경제
- 경쟁 점수 / 실패 패널티

## 8단계: 앨범·동반자 기억 — Vertical Slice 구현 완료

완료 기준:
- 사진 / 풍경 / 편지 / 물고기 / 항해 기록 수가 보인다.
- 각 유형의 최근 기록이 보인다.
- 새 항해가 이전 기록을 삭제하지 않는다.
- 여러 항해를 반복해도 같은 실행 세션 동안 기록이 누적된다.
- 사진·풍경·편지 기억이 동반자 호감도 Lv 1~3에 반영된다.
- 물고기는 개인적 기억으로 남되 낚시 반복이 관계 성장의 최적화 루프가 되지 않는다.

현재 경계:
- 앱 종료 후 재실행까지 유지하는 save file persistence는 아직 없다.

## 9단계: 기술 검증 — PR 자동화 도입 완료

완료 기준:
- GitHub Actions에서 Godot 4.7 stable을 사용한다.
- 현행 Node 24 기반 `actions/checkout@v7`을 사용한다.
- headless project import가 성공한다.
- 항해 상태 / 낚시 / game scene / album memory / camera input 계약 테스트가 성공한다.
- main menu / game / album Scene smoke가 성공한다.

기술 GREEN은 Human/player experience PASS가 아니다.

## 10단계: Rest-first Direction → Repository Contract Sync — 완료

목표:
- Notion에서 승인된 `아무것도 하지 않아도 쉬는 5분 공간` 방향을 repository 구현 계약으로 명확히 동기화한다.

완료 기준:
- `docs/RESTING_EXPERIENCE_BIBLE.md`가 Notion 방향의 implementation mirror/acceptance contract로 사운드·바다·펫·UI·기능 보호선을 정의한다.
- 파도/자연음을 BGM보다 우선하는 Audio North Star가 있다.
- 펫을 관리 의무 없는 `resting companion`으로 정의한다.
- 시각적으로 안정적인 수평선·부드러운 환경·느린 움직임을 보호하면서 UI 가독성은 유지한다.
- `CHORES / FARMING / FOMO`를 만드는 기능을 명시적으로 차단한다.

이 단계는 **repository 계약 동기화**이며 실제 production audio/pet art가 구현됐다는 뜻이 아니다.

## 11단계: Resting Core Technical Prototype — 구현 완료 / Human 품질 검증 전

최종 자산을 기다리지 않고 구조·회귀를 먼저 검증하는 단계입니다.

### 구현된 기술 구조

- `RestingSoundscape`를 AutoLoad로 등록해 메뉴/항해/앨범 Scene 전환에도 같은 인스턴스를 유지한다.
- `scripts/audio/resting_soundscape.gd`가 4초 합성 `AudioStreamWAV` OceanBed를 한 번 생성하고 `-16 dB`에서 loop한다.
- 합성 OceanBed는 `TECHNICAL_PROTOTYPE=true`이며 production 자연 파도 자산이 아니다.
- 바다 material roughness/밝기, DirectionalLight, 마음별 하늘 톤을 더 부드러운 기술 범위로 조정한다.
- `RestingPetPlaceholder` 1종을 둥근 기술 mesh로 배치하고, 12~24초 저밀도 idle + 아주 작은 호흡을 사용한다.
- 펫 placeholder에는 배고픔·청소·피로·방치 의무가 없다.
- `test_resting_core_contract.gd`가 persistent soundscape, loop/evidence class, pet care boundary, soft ocean/sky 범위를 검증한다.

### 이 단계에서 주장할 수 없는 것

- 합성 OceanBed가 실제로 편안한 파도소리다.
- 현재 둥근 펫이 최종 캐릭터 디자인이다.
- 현재 placeholder 바다/하늘이 최종 Visual PASS다.
- 실제 모바일에서 시각/청취/조작이 편안하다.

따라서 상태는:

`TECH_RESTING_CORE = PASS / AUDIO_REST_PASS = NOT_RUN / VISUAL_REST_PASS = NOT_RUN / PET_REST_PASS = NOT_RUN`

## 12단계: Production Resting Asset A/B — 다음 제작 단계

기능을 더 늘리기 전에 실제 자산으로 기술 placeholder를 교체합니다.

### Audio

1. `OceanBed A/B` 실제 자연 파도 후보를 청취한다.
2. source URL / creator / license / original hash / runtime hash를 readback한다.
3. 선택된 OceanBed를 persistent `RestingSoundscape`에 교체한다.
4. `NearWater` 한 레이어만 추가한 뒤 다시 청취한다.
5. 필요성이 확인되기 전에는 Wind / BoatCreak / PetFoley를 한꺼번에 추가하지 않는다.

### Visual

- 편안한 바다/하늘 production color study
- 과하지 않은 수면 반사
- 안정적인 수평선
- 최소 보트 재질
- 실제 펫 이미지/모델은 Visual 정책에 따라 `텍스트 brief → 명시 승인 → 1건 제작` 순서를 지킨다.

### Pet

첫 펫 1종으로 아래 존재감을 검증한다.

- 바다 보기
- 앉기 / 눕기
- 졸기
- 하품/기지개
- 작은 귀/꼬리 반응
- 가끔 플레이어 보기
- 낚시 지켜보기

**펫 수를 늘리기 전에 1종의 존재감이 실제로 편안한지 확인합니다.**

## 13단계: Resting Core Human Validation

제작 자산이 들어간 뒤 아래를 사람 눈/귀/손으로 검증합니다.

1. 첫 30초에 조작 없이도 머물고 싶은가.
2. 음악 OFF + 실제 파도소리만으로 공간이 성립하는가.
3. 5분이 `CALM`인가 `EMPTY`인가.
4. 마음별 미세한 하늘 톤 차이가 감정을 강요하지 않고 자연스럽게 느껴지는가.
5. 음원 loop seam/날카로운 고역/갑작스러운 큰 소리가 거슬리지 않는가.
6. 바다의 대비·반사·bob이 눈/멀미에 부담을 주지 않는가.
7. 환경은 부드럽지만 핵심 UI는 충분히 읽히는가.
8. 펫이 `관리해야 할 존재`가 아니라 `같이 쉬는 존재`로 느껴지는가.
9. Ambient Discovery와 낚시가 체크리스트가 아니라 작은 발견으로 느껴지는가.
10. 감상모드와 조작 UI가 바다 감상을 방해하지 않는가.
11. 앨범/동반자와 `다음 항해` 흐름이 반복 플레이의 이유가 되는가.
12. 모바일 세로 화면에서 손가락 입력과 텍스트 가독성이 충분한가.

### 검증 환경

- 헤드폰
- 일반 PC/노트북 스피커
- 모바일 스피커
- 실제 모바일 세로 화면

이 Human evidence 전에는 풍경·편지·어종·펫 종류·동반자 반응의 대량 콘텐츠 생산을 진행하지 않는다.
