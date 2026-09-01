# 마이 리틀 보트 콘셉트

## 한 문장

작은 보트에서 내 캐릭터와 동반자가 목적지 없이 잔잔한 바다를 천천히 지나며 함께 쉬는, 아무것도 하지 않아도 완성되는 휴식 게임입니다.

## Player Promise

플레이어는 게임을 여는 즉시 물 위에 잔잔히 떠 있는 보트, 캐릭터, 동반자, 바다와 수평선을 봅니다. 첫 화면은 로고와 `항해 시작`만 보이는 타이틀 대기이며, 누른 뒤에만 항해 시간과 개인 기록이 시작됩니다. 목적지나 도착 보상은 없으며, 더 하고 싶을 때만 사진을 찍고, 낚시하거나, 감상 모드로 바다를 보거나, 보트를 꾸밉니다.

보상은 점수나 승리가 아니라 “내 작은 장소에서 잠시 쉬었다”는 개인적인 기억과 애착입니다.

## 첫 경험

```text
실행
→ 실제 보트·동반자·바다가 보이는 타이틀 대기
→ `항해 시작`
→ Normal 3/4 보트 디오라마에서 그냥 머무르기
↔ 사진 / 조용한 낚시 / 감상 모드 / 작은 상호작용
↔ 원할 때만 꾸미기
→ 앨범에 개인적인 흔적을 남기거나 계속 쉬기
```

`오늘의 마음`과 시작 전 선택은 제품에서 제거되었습니다. 기기의 현지 현실 시간이 새벽·밝음·해질녘·밤을 자동으로 정하며, 플레이어가 바꾸는 UI나 저장된 분위기 선택은 없습니다. 게임을 켜 둔 active foreground 시간은 먼 구조물과 풍경이 천천히 흘러가는 시각 연출에만 쓰이며, 목적지·진행도·도착 보상으로 바뀌지 않습니다.

## 핵심 시스템의 의미

| 시스템 | 플레이어에게 주는 것 | 피해야 할 것 | 제품 상태 |
| --- | --- | --- | --- |
| Floating Rest | 보트·캐릭터·동반자와 목적지 없이 잔잔한 바다를 함께 지나가는 휴식 | 기다려야만 보상이 나오는 구조와 도착 목표 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human calm `NOT_RUN` |
| Appreciation Camera | UI를 줄이고 수평선에 집중하는 감상 | 시간·보상을 바꾸는 별도 모드 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human comfort `NOT_RUN` |
| 꾸미기 | 내 공간을 조금씩 내 취향으로 만드는 선택 | stats, rarity, gacha, 숙제 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human readability/touch `NOT_RUN` |
| 사진·낚시·작은 상호작용 | 원하는 순간에만 사용하는 가벼운 행동 | 반복 파밍·실패 패널티 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human readability `NOT_RUN` |
| 함께 보낸 시간 | foreground 항해에서 함께 머문 시간을 앨범의 조용한 관계 기억으로 남김 | live level, progress bar, 행동 보상 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; Human readability `NOT_RUN` |
| Ambient Discovery | 드물게 바다가 남기는 작은 자동 기억 | 첫 발견 보장, 버튼 요구, 보상·과제 | `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; local auto-save와 no-guarantee cadence 완료, Human five-minute observation `NOT_RUN` |
| Album | 진짜 항해 흔적을 돌아보는 개인 기록 | completion checklist | local postcard·풍경·물고기·항해 기록은 `IMPLEMENTED / RUNTIME_CAPTURE_VERIFIED`; delayed bottle letter와 전체 memory save는 별도 범위라 `PARTIAL_IMPLEMENTED` |

## 시각 원칙

- `HANDPAINTED_STORYBOOK_3D_DIORAMA`의 넓고 부드러운 바다·하늘과 `SOFT_MANGA_CHIBI_CHARACTER_REFINEMENT`의 둥근 캐릭터·동반자를 함께 사용합니다.
- 기본 identity anchor는 C 니트·긴 머리와 강아지입니다.
- 보트·물·반사·잔물결은 하나의 공간으로 읽혀야 합니다. 물과 떨어져 보이는 보트 합성은 메인 진입 구성으로 사용하지 않습니다.
- `INDIGO_RAIN_REFLECTION`의 밤은 분위기 표현이며, 위협·날씨 미션·보상을 뜻하지 않습니다.
- 생성 이미지, 방향 lock, runtime asset, 실제 540 x 960 capture, Human comfort 검증은 서로 다른 증거입니다.

## 보호선

전투, 체력, 피해, 사망, 실패 상태, 경쟁, 랭킹, 광고, 결제, 관리 의무, 실시간 채팅, 공개 피드, follower/popularity 시스템은 이 프로젝트의 방향에 맞지 않습니다.

`FriendBottle`과 `DriftBottle`은 local-first 휴식 경험을 대체하지 않는 delayed correspondence입니다. 안전·신고·차단·운영·연령·약관 gate가 실제로 충족되기 전에는 public enablement를 하지 않습니다.

## 구현 상태를 읽는 법

사람용 제품 정본은 [프로젝트 GDD](design/PROJECT_GDD.md)입니다. 실제 Scene·GDScript·테스트·capture의 상태는 [현재 Godot handoff](handoffs/CURRENT_GODOT_IMPLEMENTATION.md)를 따릅니다. 코드에 남은 이전 mood-first route는 현 제품 방향이 아니라 `PRODUCT_SUPERSEDED_IMPLEMENTATION`입니다.
