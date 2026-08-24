# Codex Goals

Codex에게 작업을 맡길 때는 **현재 Notion/AGENTS 정본과 실제 런타임 증거를 먼저 확인하고, 한 번에 작은 검증 가능한 Slice**를 구현하도록 요청합니다.

## 예시 1: 마음 선택 개선

```text
Godot 프로젝트에서 main_menu.tscn의 마음 선택 UI를 개선해줘.
모바일 세로 화면 기준으로 버튼 간격이 안정적이어야 하고,
선택 후 game.tscn의 3/4 Boat Diorama로 이동해야 해.
기존 항해 상태/앨범 기억을 회귀시키지 말고 관련 계약 테스트도 갱신해줘.
```

## 예시 2: 디오라마/감상 카메라 개선

```text
game.tscn의 Bondee-inspired 3/4 Boat Diorama 구도를 개선해줘.
보이는 Avatar + Pet + Boat + Sea가 함께 읽혀야 하고,
환경은 둥글고 matte한 storybook 3D 방향을 따른다.
Appreciation Camera는 바다 중심 low-UI 감상 모드로 유지하고,
normal diorama touch 입력을 가로채지 않게 해.
최종 아트가 아닌 기술 placeholder라면 evidence boundary를 명시해.
```

## 예시 3: 앨범 구조 개선

```text
album.tscn을 사진, 풍경, authored 편지, 물고기, 항해 기록이 이해되게 정리해줘.
현재 실제 PNG 저장과 app-restart persistence는 미구현이므로 구현한 범위만 표시해.
Godot 4.7 stable에서 관련 계약과 Scene smoke를 유지해.
```

## 예시 4: 보트 꾸미기 Slice

```text
승인된 8개 Boat Decoration slot-zone 중 대표 몇 개만 local-first로 구현해줘.
능력치, 희귀도 점수, 가챠, 슬롯 완성 보너스는 넣지 마.
Bondee처럼 내 공간을 꾸미는 애착은 살리되 rest-first 경험을 방해하지 않게 해.
먼저 RED 계약을 만들고 exact-head CI로 검증해.
```

## 예시 5: 병편지 작업

```text
병편지 기능은 docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md를 먼저 읽어.
FriendBottle/DriftBottle은 realtime chat이 아니고, social runtime은 16+ / delayed / report-block-moderation gate를 따라야 해.
이번 요청 범위를 넘어서 Supabase나 public DriftBottle을 임의 활성화하지 마.
DriftBottle 공개 플래그는 safety release gate가 실제 PASS하기 전 항상 OFF로 유지해.
```

## 공통 금지

- 전투 / 실패 / 경쟁 / 랭킹
- 펫 관리 의무
- 반복 파밍 압박
- realtime/global/public chat
- 공개 feed / follower 경쟁
- 결제 / 광고
- 검증하지 않은 Human/production 품질 PASS 주장
