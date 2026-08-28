# Resting Experience Bible

`my little boat`의 최상위 감정 목표는 **플레이어가 무언가를 달성해서 만족하는 것보다, 작은 보트에서 내 캐릭터와 펫이 함께 머무는 것만으로 쉬었다고 느끼게 하는 것**입니다.

## Authority

이 파일은 **GitHub 구현용 structured mirror / acceptance contract**입니다.

- 사람용 프로젝트 개요·경험 방향·시각 방향·에셋 판단의 정본은 Notion Human Home, Core Emotion, Visual Bible, Asset Library입니다.
- 이 파일은 승인된 Notion 방향을 Godot/코드/테스트/자산 제작이 소비할 수 있는 구조로 옮깁니다.
- 더 최신의 승인된 Notion 방향과 이 파일이 충돌하면 GitHub 문서를 임의로 우선하지 않습니다. 먼저 승인된 방향을 확인해 동기화한 뒤 구현합니다.
- 실제 런타임 사실은 코드·Scene·Resource·Test와 실행 증거가 우선합니다.

따라서 이 문서는 사운드·바다 시각·보이는 플레이어·펫/동반자·개인 보트 공간·UI·상호작용을 구현할 때 사용하는 보호선이며, 사람용 디자인 정본을 대체하지 않습니다.

## 1. North Star

### 한 문장

**본디에서 참고한 작고 둥근 보트 디오라마에서 내 캐릭터와 펫이 잔잔한 바다·파도소리와 함께 아무것도 하지 않아도 편안한 시간을 보내는 게임.**

### 플레이어에게 남겨야 하는 감정

우선순위는 아래 순서를 따릅니다.

1. 편안함
2. 안정감
3. 잔잔함
4. 내 캐릭터·펫·보트에 대한 애착
5. 혼자 있지만 외롭지 않음
6. 작은 발견과 사람의 온기
7. 개인적인 기억이 공간에 쌓이는 느낌

`재미있는 할 일의 양`, `보상 빈도`, `성장 속도`, `수집 효율`, `소셜 반응 속도`는 위 감정보다 우선하지 않습니다.

## 2. 휴식 경험의 4축

### A. Audio-first Resting Sanctuary — PRIMARY

파도와 자연음은 배경 효과가 아니라 핵심 콘텐츠입니다.

플레이어가 화면을 적극적으로 보지 않아도 다음이 성립해야 합니다.

- 파도소리만 들어도 현재 공간이 안전하고 느리게 느껴진다.
- 동일한 짧은 루프가 반복된다는 느낌보다 자연스럽게 계속 흐르는 느낌이 난다.
- 큰 피크·날카로운 효과음·잦은 성공 알림이 휴식을 깨지 않는다.
- BGM이 없어도 경험이 성립한다.

### B. Soft Sea + Diorama Visuals — PRIMARY SUPPORT

바다는 `예쁜 배경`이 아니라 눈을 쉬게 하는 공간이고, 디오라마는 **내 캐릭터·펫·보트를 함께 바라보며 애착을 만드는 공간**입니다.

- normal play는 Avatar + Pet + Boat + Sea가 함께 보이는 안정적인 3/4 구도를 사용한다.
- 수평선과 화면의 큰 형태는 안정적이어야 한다.
- 움직임은 작고 연속적이며 예측 가능해야 한다.
- 강한 환경 대비·빠른 깜빡임·과도한 반사광·과한 카메라 흔들림을 피한다.
- Avatar/Pet/Decor가 수평선과 바다를 계속 가리지 않는다.
- **환경을 부드럽게 만드는 것과 UI 가독성을 낮추는 것은 다릅니다.** 텍스트·버튼·포커스/상태 표시는 충분히 읽히는 대비를 유지합니다.
- `Appreciation Camera`는 캐릭터 생활 화면을 대체하지 않고, 원할 때 바다·수평선에 집중하는 별도 휴식 모드로 작동한다.

### C. Resting Pets — SUPPORTIVE PRESENCE

펫은 `관리해야 하는 콘텐츠`가 아니라 **같이 쉬는 존재**입니다.

- 플레이어가 아무 행동을 하지 않아도 스스로 편안한 idle 행동을 한다.
- 자주 요구하거나 울어서 플레이어를 호출하지 않는다.
- 배고픔·피로·청소·체력 같은 의무 관리가 없다.
- 애정은 효율적으로 파밍하는 숫자보다 함께 보낸 기억과 시간의 표현이다.

### D. Personal Boat + Gentle Interaction — SUPPORTIVE ATTACHMENT

꾸미기와 상호작용은 휴식을 대체하는 성장 시스템이 아니라 **보트가 점점 내 작은 공간처럼 느껴지게 하는 수단**입니다.

- 첫 꾸미기 구현은 모바일 조작과 차분한 구도를 위해 제한된 slot-zone을 사용한다.
- Decor에는 능력치·전투 효율·필수 세트 보너스를 붙이지 않는다.
- 펫/난간/컵/랜턴 같은 상호작용은 짧고 선택적이며 무시해도 손해가 없다.
- 반복 탭이나 모든 슬롯 채우기가 최적 진행 루프가 되지 않는다.
- 꾸민 결과는 `성과 점수`보다 플레이어의 취향과 항해 기억을 보여줘야 한다.

## 3. 방향 비교와 결정

### A. 사운드 중심 휴식 공간

**장점**
- 화면을 보지 않을 때도 프로젝트의 가치가 유지된다.
- 1인 개발에서 콘텐츠 수를 무작정 늘리지 않고 체감 품질에 집중할 수 있다.
- 5분 항해와 가장 직접적으로 맞는다.

**위험**
- 루프가 짧거나 음질이 낮으면 반복 피로가 매우 빨리 드러난다.

**판정: SELECTED PRIMARY**

### B. 펫 중심 교감 게임

**장점**
- `혼자 있지만 외롭지 않음`을 강하게 만든다.
- 시각적으로 기억에 남는 판매 포인트가 된다.

**위험**
- 먹이·육성·상태 관리가 붙으면 즉시 할 일/의무가 된다.

**판정: ADAPT AS SUPPORT**

### C. 수집·꾸미기·성장 중심 코지 게임

**장점**
- 장기 애착과 개인 공간 표현이 가능하다.

**위험**
- 체크리스트, 최적화, 재화 파밍이 `쉬는 게임`의 중심을 대체할 수 있다.

**판정: REJECT AS CORE / ADAPT DECORATION AS SUPPORT**

즉 `꾸미기 자체가 게임의 목적`이 되는 구조는 거부하지만, **나의 보트가 기억과 취향을 보여주는 개인 공간이 되는 꾸미기**는 적극 흡수합니다.

## 4. 사운드 정본

### 기본 레이어

우선순위와 존재감은 다음 순서를 따른다.

1. **넓은 잔잔한 파도 bed** — 항상 공간의 중심
2. **보트 가까이 닿는 잔물결** — 가까운 공간감
3. **부드러운 바람** — 저밀도
4. **목재/선체의 아주 작은 삐걱임** — 드물게
5. **멀리 있는 새/생명체** — 매우 드물게
6. **펫 숨소리·기지개·작은 움직임** — 가까우나 낮은 빈도
7. **음악** — 선택 사항, 기본 경험을 대체하지 않음

### 믹스 원칙

- `파도 > 가까운 물결 > 바람 > 보트 > 생명체/펫 > UI 효과음`의 존재감 순서를 기본값으로 삼는다.
- 잦은 UI 효과음과 보상 징글을 사용하지 않는다.
- 낚시 입질도 놀라게 하는 알람이 아니라 작은 물소리/줄 움직임 수준으로 설계한다.
- 날씨가 바뀌어도 갑자기 큰 음량으로 전환하지 않고 부드럽게 crossfade한다.
- 반복을 감추기 위해 음량을 무작위로 크게 바꾸지 않는다. 자연스러운 미세 variation만 허용한다.
- 음악 OFF 상태에서도 5분을 견딜 수 있어야 한다.

### Human Audio Gate

실제 음원이 들어오면 헤드폰/일반 스피커/모바일 스피커에서 각각 확인합니다.

- 30초 동안 눈을 감고 들어도 긴장이 올라가지 않는가?
- 5분 동안 반복 루프의 경계가 거슬리는가?
- 파도보다 효과음이나 음악이 전면으로 튀어나오는가?
- 갑작스러운 고역/큰 소리가 있는가?
- 동일한 테스트 환경에서 무음과 비교했을 때 이 soundscape가 개인적으로 더 편안하게 느껴지는가?

`편안함`은 자동 테스트로 PASS할 수 없으며 실제 청취 전까지 `NOT_RUN`입니다. 이 프로젝트는 사운드의 **의학적 치료·스트레스 감소 효과를 주장하지 않습니다.**

## 5. 바다·디오라마 비주얼 정본

### Normal Play 화면 구조

- 주요 시야: 보이는 플레이어 Avatar + 펫 + 보트의 생활 공간 + 넓은 바다 + 안정적인 수평선 + 하늘.
- normal play에서 플레이어 캐릭터는 **보입니다.** 기본 C knit/long-hair + dog 조합은 승인된 최종 2.5D runtime route로 표시하며, 다른 승인 조합은 local cosmetic selection route로 표시합니다. 기존 placeholder node는 이 구조를 지지하는 기술 shell로만 남습니다.
- 플레이어와 펫은 보트 bob에 함께 움직여 deck과 상대 위치가 깨지지 않아야 합니다.
- Avatar와 펫은 화면 중앙/수평선을 계속 가리지 않고 보트 안의 안정적인 위치에서 존재감을 만듭니다.
- 향후 Decor를 추가해도 Avatar/Pet/Sea가 함께 읽히는 여백을 유지합니다.

### Appreciation Camera

- 기존 바다 중심 드래그 view를 별도 `Appreciation Camera`로 보존합니다.
- 감상모드에서 대부분의 비필수 UI를 숨기고 바다·수평선에 집중합니다.
- Avatar/Pet는 가장자리로 밀리거나 프레임 밖에 있어도 됩니다.
- 감상모드 전환이 항해 시간·보상·사운드스케이프를 바꾸지 않습니다.
- Appreciation Camera가 inactive일 때는 mouse/touch drag를 소비하지 않아 normal diorama interaction 입력을 가로채지 않습니다.

### 시각 톤

- **환경**은 저~중간 대비를 기본으로 한다.
- 텍스트·버튼·상태 표시는 환경 톤과 별개로 충분한 식별성과 가독성을 유지한다.
- 지나치게 순수한 흰색/검정의 넓은 면적 사용을 최소화한다.
- 채도는 `맑고 부드러운 색` 범위에서 유지한다.
- 햇빛 반짝임은 넓고 부드럽게, 작은 고휘도 점멸은 억제한다.
- 바다 표면 변화는 느리고 큰 흐름 + 작은 잔물결 조합으로 만든다.
- 카메라/보트 bob은 멀미를 유발하지 않을 만큼 작게 유지한다.
- Human QA에서 불편이 확인되면 bob/환경 motion을 더 낮추거나 끌 수 있는 경로를 우선 고려한다.
- 날씨 변화는 위협보다 분위기 변화로 읽혀야 한다.
- 현재 승인된 `night` 시각 세부 기준은 `INDIGO_RAIN_REFLECTION`이다. 가는 비와 억제된 인디고 반사는 바다를 조금 더 살아 있게 보이게 하는 분위기 표현일 뿐, 우천 위험·미션·보상·사운드 이벤트·별도 날씨 선택을 뜻하지 않는다. `dawn / bright / sunset`도 넓은 하늘 여백·안정된 수평선·저대비 수면이라는 같은 문법을 유지한다.

### 상세 그림체 정본 · `HANDPAINTED_STORYBOOK_3D_DIORAMA`

`SOFT_STORYBOOK_3D_DIORAMA`는 상위 Visual 철학으로 유지하고, 실제 제작의 현재 상세 방향은 `HANDPAINTED_STORYBOOK_3D_DIORAMA`를 사용합니다. **3D geometry와 현재 카메라/보트 구조는 유지하되 최종 프레임이 glossy CG보다 움직이는 그림책처럼 읽히는 것**이 목표입니다.

`SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT`은 이 방향 안에서 플레이어와 펫에만 적용하는 현재 승인 세부 기준입니다. 배경의 넓고 손그림 같은 바다·하늘은 유지하되, 캐릭터는 더 둥글고 애니메이션처럼 읽히는 비율·얼굴·머리 덩어리·따뜻한 윤곽선·절제된 셀 명암을 사용합니다. 이는 새 runtime asset이나 캐릭터 나이/시스템 변경 승인이 아닙니다.

#### Character

- 실루엣·자세·큰 옷/머리 덩어리가 얼굴보다 먼저 읽혀야 합니다.
- 기본 C knit/long-hair 캐릭터는 약 3.25-head의 부드러운 치비 비율, 큰 wavy hair mass, 작은 따뜻한 눈·코·입, 옅은 볼색, cream knit와 muted teal-blue 계열의 간결한 큰 의상 덩어리로 읽혀야 합니다. 큰 유리눈, fashion-glamour, 실제 유아화는 피합니다.
- 얼굴은 모바일 거리에서 필요한 만큼만 단순하게 표현하고 큰 유리눈·매끈한 beauty skin·과도한 속눈썹/블러시를 피합니다.
- 머리카락은 수많은 가닥보다 2~4개의 큰 painted mass를 우선합니다.
- 최종 성별·나이·머리·복장은 비교 시안 B가 결정하지 않습니다.

#### Pet

- 펫은 수집 마스코트가 아니라 같이 쉬는 존재입니다.
- 기본 강아지는 플레이어와 같은 soft-manga chibi 선·명암 언어를 사용하며, 둥근 귀·짧은 주둥이·낮은 긴장도의 표정으로 동반자임을 먼저 읽혀야 합니다.
- 기본 동반자는 사용자 승인 C knit/long-hair + 강아지 조합이며, 고양이·토끼·수달은 local cosmetic selection으로도 사용할 수 있습니다. 어떤 종도 stats, rarity, care obligation을 갖지 않습니다.
- 눕기·바다 보기·졸기·기지개 같은 큰 resting pose와 낮은 빈도의 idle을 우선합니다.

#### Boat / Props

- 현재 BoatSpace와 slot-zone decoration 구조를 유지합니다.
- photoreal wood grain보다 hand-painted value variation, broad brush breakup, worn-soft edge를 우선합니다.
- 랜턴·컵·쿠션·식물·엽서·펫 쿠션은 생활 흔적으로 읽히되 바다를 가릴 만큼 쌓지 않습니다.

#### Sea / Sky

- 안정적인 수평선과 넓은 painted sky/water shape를 우선합니다.
- 반사는 낮은 빈도로 제한하고, photoreal water simulation보다 deliberate color/value grouping을 우선합니다.
- 날씨와 시간 변화는 위협적 spectacle보다 부드러운 분위기 변화로 읽혀야 합니다.

#### Materials

- matte-biased material과 reduced specular response를 기본으로 합니다.
- painted albedo가 시각 identity를 주도하고 PBR micro-detail은 보조로 제한합니다.
- 값과 색의 작은 불균일성은 authored brush decision처럼 보여야 하며 생성 노이즈처럼 랜덤하지 않아야 합니다.

#### Lighting

- 한 방향의 넓고 부드러운 key light와 soft fill을 우선합니다.
- 캐릭터만 강한 spotlight/rim-light로 강조하지 않고 sea/horizon을 큰 value mass로 유지합니다.
- 과도한 bloom/glow는 모바일 판독성을 해치면 제거합니다.

#### Motion

- idle·hair/cloth·boat bob·water motion은 느리고 낮은 진폭으로 유지합니다.
- high-frequency squash/stretch, procedural jiggle, 지속적인 attention-call 움직임을 피합니다.
- 그림책 같은 정지 프레임 인상이 normal play와 Appreciation Camera 전환 중에도 유지되어야 합니다.

#### Implementation preservation

다음 현재 구조를 시각 스타일 변경 때문에 교체하지 않습니다.

- normal 3/4 diorama camera
- Appreciation Camera
- BoatSpace hierarchy
- slot-zone decoration
- low-pressure interaction surfaces
- avatar + pet + boat shared-space/bob relationship
- mobile portrait presentation
- local-first core gameplay

#### First production validation slice · Complete

전체 자산을 교체하기 전에 아래 최소 slice만 먼저 검증합니다.

```text
1 neutral handpainted 3D test player
+ 1 temporary resting-pet style treatment without species canonization
+ existing boat material pass
+ sea/sky color treatment
+ 1 small decor cluster
+ Normal / Appreciation Camera comparison
```

이 slice는 구현·자동 계약·540×960 Normal/Appreciation runtime capture를 마쳤고, 이후 승인된 C+dog 기본 route, local identity selection, cushion/postcard surfaces, four-time atmosphere, final-composite decor correction이 `main`에 통합되었습니다. 아래 질문 중 실제 mobile/human comfort 항목은 아직 보류 상태이며, 그 상태를 PASS로 바꾸지 않습니다.

1. 캐릭터가 generic AI 3D처럼 보이지 않는가?
2. 실제 540×960 gameplay 거리에서 hand-authored 인상이 남는가?
3. 캐릭터 얼굴보다 sea/horizon과 `내 작은 장소`가 먼저 읽히는가?
4. idle/bob 중에도 illustrated feel이 유지되는가?
5. 현재 Godot 4.7 mobile renderer와 1인 개발 비용에 맞는가?

#### Evidence Gate

```text
HANDPAINTED_3D_RUNTIME_SLICE = USER_APPROVED_MERGED_MAIN
C_DOG_DEFAULT_RUNTIME_CAPTURE = PASS
COSMETIC_IDENTITY_SELECTION = IMPLEMENTED_LOCAL_FIRST
FOUR_TIME_ATMOSPHERE = MERGED_MAIN
FINAL_COMPOSITE_DECOR = MERGED_MAIN
MOBILE_30S_VISUAL_REVIEW = NOT_RUN
MOBILE_5M_VISUAL_REVIEW = NOT_RUN
HANDPAINTED_MOTION_REVIEW = NOT_RUN
HANDPAINTED_PERFORMANCE_REVIEW = NOT_RUN
HUMAN_STYLE_APPROVAL = NOT_RUN
```

비교 시안 B는 `USER_PREFERRED_REFERENCE`이며 최종 캐릭터·펫·UI·보트·팔레트 정본이나 승인 production asset이 아닙니다.

### EMPTY 방지

`잔잔함`을 `아무것도 없음`으로 만들지 않습니다.

- Avatar의 낮은 빈도 생활 행동
- 구름의 느린 이동
- 수면의 작은 반짝임
- 멀리 지나가는 새/고래/부유물
- 펫의 작은 idle
- 매우 낮은 빈도의 Ambient Discovery
- 취향이 보이는 작은 Decor 흔적

이 중 여러 요소가 동시에 플레이어의 주의를 요구해서는 안 됩니다.

### Ambient Discovery · 배경이 남기는 작은 기억

Ambient Discovery는 플레이어가 보상을 얻기 위해 고르는 이벤트가 아니라, 낮은 빈도로 바다·하늘·먼 거리에서 스스로 지나가는 확률형 배경 연출입니다. 발견 순간에는 작은 비차단 알림만 잠시 보이고 자동으로 사라지며, 그 장면은 버튼이나 확인 없이 local ambient memory로 즉시 저장됩니다.

Normal Diorama와 Appreciation Camera 모두에서 같은 의미로 나타나되, 감상 화면의 바다·수평선을 가리지 않아야 합니다. 병편지·외부 메시지·소셜 알림과 구분하며, 호감도·보상·점수·희귀도·timer·camera·FOMO를 만들지 않습니다. 정확한 발생률, motif, persistence와 runtime UI는 별도 Phase 2 계약 전까지 미확정입니다.

## 6. 펫/동반자 정본

### 역할

펫은 플레이어를 계속 즐겁게 해주는 entertainer보다 **같은 공간을 편안하게 공유하는 companion**입니다.

### 함께 보낸 시간과 호감도

동반자 호감도는 활성 foreground 항해의 경과 시간만으로 쌓입니다. Normal Diorama와 Appreciation Camera, 그리고 항해 기록 뒤에 더 머무는 시간은 같은 동행 시간으로 인정합니다. 입력·사진·풍경·편지·물고기·낚시·발견·꾸미기·상호작용·시간대·속도는 수치의 원천이나 배율이 아닙니다.

메인 메뉴·앨범·백그라운드/일시정지는 누적하지 않습니다. 호감도는 관리, 방치 벌, streak, 능력치, 경제, 경쟁, 소셜 자격을 만들지 않으며, 현행 action-based `companion_affection`은 product-superseded implementation입니다. 정확한 rate, threshold, 저장 migration, UI 표현은 별도 Phase 2 계약과 실제 5분 Human validation 전까지 확정하지 않습니다.

고양이·토끼·강아지·수달은 순수 local cosmetic 선택이므로, 호감도는 pet type별 ledger가 아닌 전역 `함께 보낸 시간`입니다. 외형을 바꿔도 호감도는 잃거나 초기화되지 않고 종별 보정도 없습니다.

### 기본 Idle Pool

초기 제작 우선순위:

1. 바다 바라보기
2. 편하게 앉기
3. 눕기
4. 졸기 / 눈 감기
5. 하품 / 기지개
6. 귀 또는 꼬리의 작은 반응
7. 가끔 플레이어 쪽 바라보기
8. 낚시 중 줄/물결 바라보기

Idle은 계속 바쁘게 바뀌지 않습니다. **긴 정지/호흡 구간 사이에 작은 행동이 드물게 나오는 것**을 기본 템포로 합니다.

### 상호작용

허용:
- 쓰다듬기
- 같이 앉기/바다 보기
- 이름 부르기/바라보기 정도의 낮은 압력 교감
- 사진에 자연스럽게 함께 남기
- 항해 기억에 따라 새로운 편안한 idle/자리 변화 해금

금지/보류:
- 배고픔 게이지
- 청소 의무
- 방치 패널티
- 컨디션 하락
- 치료/회복 의무
- 반복 터치 파밍
- 희귀 펫 가챠 구조
- 펫을 놓칠까 불안하게 만드는 시간 제한

## 7. Delayed Bottle Social 휴식 보호선

병편지는 **휴식 게임 안의 작은 사람의 온기**이며 소셜 앱의 메인 피드가 아닙니다.

- FriendBottle/DriftBottle은 즉시 채팅이 아니라 의도적 지연 전달을 사용한다.
- 온라인 상태·타이핑·읽음 표시·공개 피드·팔로워·인기 점수를 만들지 않는다.
- 병편지가 도착해도 `지금 답장`을 요구하는 countdown/streak/reward를 만들지 않는다.
- 백엔드가 없거나 장애가 나도 local rest/voyage/decor/pet이 정상 플레이 가능해야 한다.
- DriftBottle은 production moderation + Terms + 16+ gate + report/block + 운영 경로가 검증되기 전 공개하지 않는다.

세부 온라인 계약은 `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md`가 담당합니다.

## 8. 기능 평가 Gate

새 기능은 아래 질문 중 하나라도 `아니오`이면 기본적으로 보류합니다.

1. 아무것도 하지 않는 플레이어도 여전히 편안한가?
2. 이 기능을 무시해도 손해가 없는가?
3. 파도·바다·Avatar·펫보다 UI와 보상을 더 신경 쓰게 만들지 않는가?
4. 반복 최적화/파밍이 최선의 플레이가 되지 않는가?
5. 꾸미기가 자기표현보다 체크리스트가 되지 않는가?
6. 소셜이 즉답 압박이나 인기 경쟁을 만들지 않는가?
7. 1인 개발 유지비가 핵심 휴식 품질 개선보다 커지지 않는가?

## 9. Benchmark ADOPT / ADAPT / REJECT

### Bondee

**ADOPT / ADAPT**
- 작고 둥근 3D 디오라마와 `내 공간` 애착
- 보이는 Avatar와 작은 생활 행동
- 공간 꾸미기에서 오는 자기표현
- 바다에 떠다니는 병편지의 우연한 사람 연결

**REJECT / MODIFY**
- 마이리틀보트를 실시간 메신저/SNS로 바꾸는 것
- 공개 인기 경쟁이나 응답 압박
- 휴식보다 소셜 반응을 앞세우는 구조

### Spirit City: Lofi Sessions

**ADOPT**
- 사운드스케이프를 공간 경험의 핵심으로 취급
- 동반자가 `혼자 있지 않은 느낌`을 만드는 구조

**REJECT**
- 생산성 XP, 할 일/습관 완료를 프로젝트의 핵심 보상으로 사용

### NAIAD

**ADOPT**
- 물·동물·자연의 작은 움직임 자체를 콘텐츠로 사용
- 부드러운 시각과 사운드를 같은 분위기로 묶기

**ADAPT**
- 탐색 목표보다 정적인 체류 경험에 맞게 활동 밀도를 더 낮춘다.

### A Short Hike

**ADOPT**
- 서두를 필요가 없는 pacing
- 낚시를 필수가 아닌 쉬어가는 선택으로 두는 원리

**REJECT**
- 이동/도달/수집 진행을 이 프로젝트의 감정 중심으로 삼는 것

## 10. Evidence Boundary

현재 자동/구조 evidence로 확정 가능한 것:

- 프로젝트의 최상위 경험 목표는 `rest-first`다.
- 파도/자연음은 핵심 콘텐츠다.
- normal play용 기술 `DioramaCamera3D`와 visible `PlayerAvatarPlaceholder`가 있다.
- `AppreciationCamera3D`가 보존되고 inactive 상태에서는 drag input을 소비하지 않는다.
- 기술 Avatar/Pet는 보트 bob과 상대 위치를 유지한다.
- 펫은 관리 의무 없는 동반자다.
- 수집/낚시는 휴식을 대체하지 않는 선택형 보조 콘텐츠다.
- Boat Decoration과 reusable Low-pressure Interactable은 current main에 구현되어 있고, 승인된 cushion/postcard surface와 final-composite decor route도 runtime-verified다. Human mobile usability와 주관적 final-art quality는 아직 `NOT_RUN / DEFERRED`다.
- FriendBottle / DriftBottle 제품·안전 설계는 승인됐지만 **real network/auth/moderation/public social runtime은 current main에 구현되지 않았다.** PR #19의 local fake backend는 이 문서 정본 rollout과 독립된 open workstream이다.

아직 확정할 수 없는 것:

- 현재 3/4 구도가 실제 모바일 portrait에서 편안하고 예쁘다.
- 승인된 2.5D Avatar/Pet/Boat/Sea route가 실제 모바일에서 장시간 편안하다.
- 현재 바다가 실제로 시각적으로 편안하다.
- 코드 생성 OceanBed 후보가 실제 자연 파도처럼 충분히 편안하다.
- 실제 Decor/상호작용이 `CHORES` 없이 재미있다.
- 실제 FriendBottle/DriftBottle이 안전하고 편안한 소셜 경험이다.
- 실제 모바일 기기에서 5분이 편안하다.
- 자연음이 모든 플레이어의 스트레스를 줄인다.

위 품질 항목은 제작 자산과 해당 시스템이 들어오고 Human listening/viewing/playtest를 수행하기 전까지 `NOT_RUN` 또는 `NOT_IMPLEMENTED`입니다.
