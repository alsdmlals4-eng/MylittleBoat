# 마이 리틀 보트 기획서

**현재 상태:** `CURRENT_HUMAN_FACING_GDD`
**갱신일:** 2026-08-29
**읽는 법:** 이 문서는 사람이 게임의 경험과 결정 상태를 이해하기 위한 정본입니다. 실제 코드·Scene·테스트·캡처는 [현재 Godot handoff](../handoffs/CURRENT_GODOT_IMPLEMENTATION.md)가, visual consumer와 provenance는 [visual inventory](../visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md)가 소유합니다.

## 1. 이 게임은 무엇인가

`마이 리틀 보트`는 내 캐릭터와 동반자가 바다 위 작은 보트에서 함께 쉬는 휴식 우선 게임입니다. 플레이어는 목표를 해내기 위해 보트에 오르는 것이 아니라, 게임을 여는 순간 이미 그곳에 있습니다.

### 플레이어 약속

> “게임을 열자마자 내 작은 보트가 바다 위에 떠 있고, 나는 아무것도 하지 않아도 잠시 쉬어 갈 수 있다.”

정상 화면은 캐릭터, 동반자, 보트, 장식, 바다와 수평선이 함께 보이는 calm 3/4 diorama입니다. `Appreciation Camera`는 같은 세계에서 UI를 줄이고 바다·수평선을 더 오래 바라보는 선택적 감상 모드입니다.

### 이 게임이 남기려는 감정

- 편안함과 안정감
- 내 캐릭터·동반자·보트가 만드는 작은 애착
- 혼자 있지만 외롭지 않은 느낌
- 성과보다 개인적인 기억이 남는 느낌

전투, 실패, 경쟁, 등급, 효율, 숙제, 실시간 소셜 압박은 위 감정과 충돌하므로 넣지 않습니다.

## 2. 첫 30초와 시작 흐름

### 확정된 첫 경험

```text
실행
→ 이미 물 위에 떠 있는 보트와 바다를 봄
→ 캐릭터와 동반자가 함께 있는 모습을 봄
→ 그냥 머무르거나, 원할 때만 작은 행동을 선택함
→ 계속 쉬거나 나만의 기억을 남김
```

시작할 때 `오늘의 마음`, 시간대, 외형, 동반자, 장식 중 무엇도 고르게 하지 않습니다. 기기의 **현지 현실 시간**이 새벽·밝음·해질녘·밤 분위기를 자동으로 정합니다. 수동 분위기 control과 마지막 분위기 저장은 없습니다. 기기 시계는 시각 표현에만 쓰며 보상, 항해 진행, 기억 저장, 호감도에는 영향을 주지 않습니다.

외형·동반자·보트 장식은 바다를 본 뒤에만, 원할 때 `꾸미기`에서 바꿉니다. 모든 꾸미기 선택은 cosmetic이며 능력치, 희귀도, 보상, 최적 조합을 만들지 않습니다.

### 첫인상 수용 기준

- 보트 hull과 물의 접점이 읽힌다.
- 느린 bob, 잔물결 또는 wake, 반사·가림이 보트와 바다를 하나의 공간으로 묶는다.
- 캐릭터·동반자·보트는 보이되 수평선과 넓은 바다를 가리지 않는다.
- 큰 선택 panel이 first view를 덮지 않는다.
- 540 x 960 실제 gameplay 크기에서 위 관계가 읽힌다.

현재 제공된 구형 main-entry 구성은 이 기준을 충족하지 않아 `REJECTED_FOR_MAIN_ENTRY_RUNTIME_USE`입니다. 현재 기본 route는 `game.tscn`의 direct boat entry이며, `main_menu.tscn`은 오래된 링크를 이 화면으로 넘기는 호환 경로만 유지합니다. 이 결정은 보트·바다 source binary를 일괄 폐기한다는 뜻이 아닙니다.

## 3. 플레이는 어떻게 이어지는가

### 핵심 반복

```text
바다 위 보트에 머문다
→ 바다와 동반자를 바라본다
→ 원하면 사진·낚시·감상·작은 상호작용·꾸미기를 한다
→ 작은 반응이나 개인적인 기억을 남긴다
→ 계속 머물거나 자연스럽게 떠난다
```

핵심 행동은 “머무르기”입니다. 선택 행동은 정적 화면의 빈틈을 메우는 과제가 아니라, 지금 하고 싶은 만큼만 사용하는 생활감입니다.

### 한 번의 휴식

명목상 한 항해는 약 5분입니다. 기록이 남은 뒤에도 플레이어는 더 머물 수 있습니다. 시간을 끝까지 채우거나 모든 행동을 해야만 완성되는 세션은 아닙니다.

### 남는 기억

사진, 풍경, 낚시 기억, 보트 장식, future 함께 보낸 시간, ambient memory는 개인적인 앨범과 보트의 흔적으로 돌아옵니다. 이들은 power, currency, social qualification, collection completion을 위한 재료가 아닙니다.

### 선택과 결과

| 선택 | 플레이어가 고민하는 것 | 관찰 가능한 결과 | 손해가 아닌 것 |
| --- | --- | --- | --- |
| 그냥 머무르기 | 지금은 아무것도 하지 않고 쉬고 싶은가 | 바다·동반자·보트의 조용한 움직임 | 아무 행동도 하지 않는 것 |
| 사진 | 이 순간을 기록하고 싶은가 | 개인 album의 사진 기억 | 사진을 찍지 않는 것 |
| 낚시 | 잠시 기다리는 행동이 어울리는가 | 기다림, catch 또는 취소의 작은 기억 | catch가 없거나 중단하는 것 |
| Appreciation Camera | 화면을 덜 보고 바다를 더 볼 것인가 | 낮은 UI의 수평선 감상 | normal view를 유지하는 것 |
| 꾸미기 | 내 공간을 어떤 모습으로 두고 싶은가 | cosmetic appearance 변화 | 장식을 바꾸지 않는 것 |

## 4. 시스템 카드

### 떠 있는 휴식

**플레이어가 보고 하는 일.** 캐릭터와 동반자가 보트에서 바다를 바라보는 모습을 보고, 원하면 아무 입력 없이 머뭅니다.

**필요한 이유.** 이 게임의 핵심 재미는 보상 전 대기 시간이 아니라 함께 존재하는 장소를 보는 데 있습니다.

**피드백.** 보트의 느린 움직임, 바다·하늘의 변화, 동반자의 낮은 빈도 idle, 파도 중심 soundscape가 “여기에 있다”는 감각을 줍니다.

현지 시간이 바뀌면 하늘·빛·바다의 색과 반사가 천천히 이어집니다. active foreground로 머문 시간이 쌓이면 수평선의 구조물과 주변 풍경도 낮은 밀도로 흘러갑니다. 둘 다 해야 할 일이나 보상이 아니라, 같은 장소가 살아 있다는 배경 감각입니다.

**피해야 할 압박.** 방치 벌, timer 실패, idle 보상, 매분 확인 요구.

**상태.** `IMPLEMENTED_AND_GPU_CAPTURED`입니다. 실제 기기에서의 첫 30초와 5분 휴식 판단은 `NOT_RUN`입니다.

### 감상 카메라

**플레이어가 보고 하는 일.** 필요할 때 UI를 줄이고 바다와 수평선에 집중합니다.

**필요한 이유.** 캐릭터와 보트를 보는 휴식과 바다만 보는 휴식은 서로 다른 순간에 필요합니다.

**피드백.** 같은 항해 시간과 soundscape 안에서 시야만 조용해집니다.

**피해야 할 압박.** 보상, timer, 동반자 관계, ambient discovery 확률을 바꾸는 별도 게임 모드.

**상태.** earlier runtime slice에 존재합니다. 실제 기기에서의 편안함은 `NOT_RUN`입니다.

### 꾸미기

**플레이어가 보고 하는 일.** 도착 뒤 원할 때 외형, 동반자 species, 보트 장식을 바꿉니다.

**필요한 이유.** 공간이 “게임의 배경”이 아니라 “내 작은 장소”로 느껴지게 합니다.

**피드백.** 보트의 모습과 함께 있는 동반자가 달라집니다.

**피해야 할 압박.** stats, rarity, gacha, price, daily shop, 모든 slot 채우기, 최적 배치.

**상태.** `IMPLEMENTED`입니다. 첫 화면에는 보이지 않고 `메뉴 → 꾸미기`에서만 접근합니다. 실제 기기 터치 편안함은 `NOT_RUN`입니다.

### 사진·조용한 낚시·작은 상호작용

**플레이어가 보고 하는 일.** 지금의 풍경을 찍고, 조용히 기다리거나, 보트의 작은 물건·동반자와 가볍게 반응합니다.

**필요한 이유.** 가만히 쉬기와 별개로 손을 조금 쓰고 싶은 플레이어에게 낮은 밀도의 생활감을 줍니다.

**피드백.** 사진·catch·짧은 pose/message 같은 개인적인 흔적과 반응이 남습니다.

**피해야 할 압박.** 반복 탭, 확률 보상 farming, 실패 패널티, 행동 횟수에 따른 동반자 보상.

**상태.** `PARTIAL_IMPLEMENTED`입니다. future product alignment는 별도 구현 계약이 필요합니다.

### 함께 보낸 시간

**플레이어가 보고 하는 일.** 동반자와 active foreground 항해에서 함께 보낸 시간이 앨범에 조용히 쌓이는 것을 봅니다.

**필요한 이유.** 동반자를 행동 보상으로 바꾸지 않고도 함께 머문 시간이 의미 있게 느껴지게 합니다.

**피드백.** 앨범의 시간과 짧은 관계 문구.

**피해야 할 압박.** live level, progress bar, growth popup, species bonus, action multiplier.

**상태.** 제품 방향은 `CONFIRMED_NOT_IMPLEMENTED`입니다. 행동 보상형 호감도는 ambient memory에서 분리됐지만, 함께 켜 둔 foreground 시간 기반의 조용한 관계 표현은 아직 구현하지 않았습니다.

### 흘러가는 풍경과 배경 발견 연출

**플레이어가 보고 하는 일.** active foreground로 머무는 동안 먼 부표·섬·등대처럼 바다의 구조물과 주변 풍경이 천천히 지나가는 것을 봅니다. 일부 낮은 빈도의 장면은 짧은 알림과 함께 개인 memory로 자동 저장됩니다.

**필요한 이유.** 바다가 정지한 배경이 아니라 천천히 흘러가는 장소처럼 느껴지되, 휴식을 끊지 않게 합니다.

**피드백.** 수평선에서 자연스럽게 이동하는 작은 실루엣, 짧고 사라지는 notification, local ambient memory.

**피해야 할 압박.** 발견을 보기 위한 기다림, button 요구, reward claim, task, social message, missed-event penalty, 구조물을 탭해야 하는 상호작용.

**상태.** `IMPLEMENTED_AND_GPU_CAPTURED`입니다. active foreground 시간만 쓰는 director와 부표·작은 섬·등대 consumer가 있으며, memory 저장은 확률형 local auto-save이고 zero도 정상입니다. 실제 5분의 빈도·noticeability는 `NOT_RUN`입니다.

### Album

**플레이어가 보고 하는 일.** 실제 사진, 기록, catch와 future quiet-time memory를 돌아봅니다.

**필요한 이유.** 효율표가 아닌 개인적 기억이 시간이 남는 방식입니다.

**피드백.** 내가 실제로 남긴 기록과 조용한 관계 문구.

**피해야 할 압박.** completion checklist, 가짜 illustrative photo, collection score.

**상태.** album surface는 `PARTIAL_IMPLEMENTED`이며 together-time 표현은 별도 구현 전입니다.

## 5. 화면과 정보의 흐름

| 화면 또는 상태 | 플레이어 목표 | 주요 행동 | 다음 연결 | 제품 상태 |
| --- | --- | --- | --- | --- |
| Direct boat entry | “여기는 어떤 장소인가”를 즉시 느낌 | 보기, 머무르기 | normal voyage | `IMPLEMENTED_AND_GPU_CAPTURED`; Human `NOT_RUN` |
| Normal voyage diorama | 캐릭터·동반자·보트·바다와 시간에 따라 바뀌는 풍경을 함께 보기 | 쉬기, 사진, 낚시, 감상, 꾸미기 | album 또는 계속 머무르기 | `IMPLEMENTED_AND_GPU_CAPTURED`; Human `NOT_RUN` |
| Appreciation Camera | 수평선과 바다에 집중 | 감상 시작·종료 | 같은 normal voyage | earlier slice `IMPLEMENTED` |
| 꾸미기 | 공간을 내 취향으로 두기 | 외형·동반자·장식 변경 | 같은 normal voyage | cosmetic slice `PARTIAL_IMPLEMENTED` |
| Album | 남은 개인 기록 보기 | 기록 읽기, 바다로 돌아가기 | normal voyage | `PARTIAL_IMPLEMENTED` |

첫 화면은 메뉴가 아니라 direct boat entry입니다. `main_menu.tscn`은 오래된 링크를 넘기는 compatibility route이며, 그 identity/time/mood capture runner는 `HISTORICAL_RETIRED`입니다. 현재 디자인 정본이나 visual approval, current runtime evidence로 사용하지 않습니다.

## 6. 확정된 시각 방향

### 시각 방향 고정

- 전체: `HANDPAINTED_STORYBOOK_3D_DIORAMA`
- 캐릭터와 동반자: `SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT`
- 기본 anchor: C loose-knit/long hair + dog
- 밤: `INDIGO_RAIN_REFLECTION`

### 유지할 것

- 넓은 바다·하늘, 안정된 수평선, 낮거나 중간인 환경 대비.
- 부드러운 matte/painterly 재질과 큰 painted mass.
- 3/4 diorama 안에서 함께 읽히는 캐릭터·동반자·보트.
- 둥글고 애니메이션적인 치비 캐릭터 silhouette, 큰 머리카락 mass, 절제된 셀 명암.
- 느리고 예측 가능한 bob, 물결, idle.

### 피할 것 / 흔들리지 말 것

- glossy photoreal CG, 과한 PBR micro-detail, random AI noise.
- 큰 유리눈, glamour fashion, 실제 유아화, character만 과도하게 강조하는 rim light.
- 빠른 깜빡임, 과한 bob, attention call, 넓은 고휘도 반사.
- 보트와 물이 분리되어 보이는 합성, 바다를 가리는 거대한 UI panel.
- 다른 게임의 character proportion, UI, branding, trade dress를 닮게 복제하는 것.

### 증거를 구분하는 법

`APPROVED_DIRECTION`은 그림체의 선택입니다. 생성 exploration은 runtime asset이 아니며, source binary가 있다고 runtime alignment가 증명되는 것도 아닙니다. 실제 540 x 960 capture는 화면이 실행됐다는 증거이고, Human comfort는 사람이 확인하기 전까지 `NOT_RUN`입니다.

## 7. 현재 제품 상태와 구현 가능성

### 현재 상태

| 항목 | 상태 | 의미 |
| --- | --- | --- |
| Rest-first direction | `CONFIRMED` | 머무르기가 complete play라는 제품 방향 |
| Direct boat entry | `IMPLEMENTED_AND_GPU_CAPTURED` | `project.godot`이 `game.tscn`을 열고 첫 화면은 메뉴를 닫은 보트 장면 |
| 오늘의 마음 제거 | `IMPLEMENTED_AND_TESTED` | mood state, 시작 선택, 색 규칙, 항해 문구 의존을 retire함 |
| 현실 시간 분위기 | `IMPLEMENTED_AND_TESTED` | 현지 시간은 시각만 바꾸고, startup selector·saved preference는 없음 |
| foreground session | `IMPLEMENTED_AND_TESTED` | 앱이 foreground일 때만 항해 timer·낚시 대기·풍경 drift·자동 알림이 진행되며 background 경과는 기록을 만들지 않음 |
| 흘러가는 풍경 | `IMPLEMENTED_AND_GPU_CAPTURED` | active foreground 시간만 쓰는 low-density director와 duplicate-safe local ambient memory |
| cosmetic 꾸미기 | `PARTIAL_IMPLEMENTED` | local slice는 optional `메뉴 → 꾸미기`에서 현재 항해 화면에 live 적용됨 |
| 함께 보낸 시간 | `CONFIRMED_NOT_IMPLEMENTED` | active foreground time 기반의 관계 문구·album 표현은 별도 구현 필요 |
| Ambient Discovery | `IMPLEMENTED_AND_TESTED` | passive scenery event, 작은 auto-fade 알림, local auto-save이며 Human 빈도 평가는 미실시 |
| Visual direction | `APPROVED_DIRECTION` | production asset batch와 runtime alignment는 별도 |
| Human usability / Player Experience | `NOT_RUN` | 실제 30초·5분 기기 경험 검증 전 |

### 구현 가능성 확인

현재 Godot 구조에서 direct boat entry는 구현 가능한 범위입니다. `GameState`처럼 Autoload된 Node는 Scene 전환을 넘어 state를 유지할 수 있고, 이는 mood를 retire한 뒤 local cosmetic state와 active foreground session state를 owner로 유지하는 데 맞습니다. [Godot Autoload 공식 문서](https://docs.godotengine.org/en/stable/tutorials/scripting/singletons_autoload.html)

Godot `Time`은 현지 시스템 시간을 읽을 수 있으므로 현실 시간 기반의 순수 시각 분위기에 맞습니다. 다만 시스템 시계는 사용자가 바꿀 수 있으므로 precise progress에는 쓰지 말아야 합니다. active foreground scenery는 monotonic tick 또는 scene delta로 계산합니다. [Godot Time 공식 문서](https://docs.godotengine.org/en/stable/classes/class_time.html)

작은 local cosmetic과 ambient memory는 `user://`와 `ConfigFile`로 저장·복원할 수 있습니다. 이 저장은 시간대 자체를 저장하지 않으며, 기존 mood data migration과 save 실패 처리는 구현 계약에서 정합니다. [Godot ConfigFile 공식 문서](https://docs.godotengine.org/en/stable/classes/class_configfile.html), [Godot user data filesystem 공식 문서](https://docs.godotengine.org/en/stable/tutorials/scripting/filesystem.html)

main scene을 direct boat route로 바꾸고 optional customization을 같은 게임 내 surface로 연결하는 것은 Godot 표준 SceneTree 전환의 범위입니다. 이 가능성은 아직 전환 구현이나 mobile performance 검증을 뜻하지 않습니다. [Godot Scene 전환 공식 문서](https://docs.godotengine.org/en/stable/tutorials/scripting/change_scenes_manually.html)

### 구현 receipt와 남은 검증

아래 기능은 current runtime에 반영됐습니다.

1. `project.godot`은 `game.tscn`을 시작 route로 사용하며, 첫 화면은 메뉴를 닫은 normal boat diorama입니다.
2. 새벽 `05:00–08:59`, 밝음 `09:00–16:59`, 해질녘 `17:00–20:59`, 밤 `21:00–04:59`가 기기의 현지 시각으로 자동 적용됩니다. selector와 saved atmosphere는 없습니다.
3. mood data와 시작 선택 UI를 retire하고 항해 기록을 중립 문구로 바꿨습니다.
4. foreground 전용 session clock이 항해 timer·낚시 대기·풍경 drift·자동 알림을 함께 멈추며, drifting scenery director는 부표·작은 섬·등대를 낮은 밀도로 흘리고 일부를 local ambient memory로 자동 저장합니다.
5. 외형·동반자·장식은 optional `메뉴 → 꾸미기`에만 있습니다.
6. 540 x 960 GPU capture에서 boat-water contact, 시간대, 원거리 작은 섬을 확인했습니다.

남은 것은 사람 검증입니다. 실제 기기 첫 30초, 5분 휴식, 터치, 알림 noticeability, 오디오 편안함은 `NOT_RUN`이며, 함께 보낸 foreground 시간의 조용한 호감도 표현도 아직 구현하지 않았습니다.

## 8. 금지 범위와 열린 결정

### 금지 범위

- 전투, 체력, 피해, 적, 죽음, 실패 조건, retry pressure.
- 경쟁, rank, follower, popularity, public feed, realtime chat.
- ads, payments, gacha, rare power, stats, economy farming, daily FOMO.
- 펫의 배고픔·청소·피로·방치 벌.
- direct-entry 변경을 핑계로 하는 asset batch, social expansion, unrelated refactor.

### 열린 결정

| 항목 | 현재 결정 | 나중에 정할 것 |
| --- | --- | --- |
| 현실 시간 분위기 | 현지 현실 시간이 자동 적용 | 계절·지역 일몰까지 반영할지 여부. 첫 구현에는 포함하지 않음 |
| direct-entry visual production | 구형 composition reject | source asset reuse/replacement와 정확한 runtime consumer |
| 함께 보낸 시간 | active foreground 시간만 누적 | rate, threshold, persistence migration, album copy |
| 흘러가는 풍경 / Ambient Discovery | active foreground, passive, auto-save, low-density | motif의 구체 asset, cooldown과 notification copy |
| Human validation | 아직 `NOT_RUN` | 실제 기기에서 first 30 seconds와 5 minutes가 calm인지 |

새 결정은 current owner와 공식 근거를 대조한 뒤에만 정본으로 올립니다. 충돌은 해당 owner만 교정한 뒤 적대적 검토를 다시 통과합니다.
