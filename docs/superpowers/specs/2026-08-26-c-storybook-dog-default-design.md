# C 니트 주인공 + 강아지 스토리북 디오라마 설계

## 목표

승인된 `HANDPAINTED_STORYBOOK_3D_DIORAMA` 방향을 현재 Godot 3/4 보트 화면에 실제로 읽히게 한다. 기본 주인공은 **C 니트·긴 머리**, 기본 동반자는 **강아지**로 정한다. 두 존재와 보트, 바다·수평선이 540×960 세로 화면에서 함께 읽혀야 한다.

기준 시안은 실루엣, 색, 재질, 생활감의 참조 정본이다. 시안 원본을 2D 판넬로 붙이거나 새 최종 이미지 asset으로 승격하지 않는다.

## 사용자 경험

- 일반 화면에서 플레이어는 긴 갈색 머리·크림 니트·푸른 치마·갈색 부츠의 주인공과 옆에서 쉬는 강아지, 나무 보트, 잔잔한 바다를 한 번에 알아본다.
- 감상 화면에서는 보트와 동반자가 장면의 작은 일부가 되고 바다와 수평선이 우선한다.
- 장식은 승인된 방석과 Bright Boat 엽서를 포함해 개인 공간의 생활감만 더하며, 인물·동반자·수평선을 가리지 않는다.
- 어떤 외형도 능력치, 희귀도, 비용, 보상, 돌봄 의무, 시간 흐름, 소셜 자격을 바꾸지 않는다.

## 구현 경계

### 포함

- `scenes/boat_space.tscn`의 기존 placeholder 시각 계층을 C 주인공 및 강아지 실루엣으로 바꾼다.
- 기존 primitive mesh와 opaque matte `StandardMaterial3D`만 사용한다.
- C 주인공은 머리카락, 니트 상의, 치마, 부츠, 작은 펜던트가 540×960에서 구별되는 큰 형태를 가진다.
- 강아지는 낮게 쉰 몸, 머리, 처진 귀, 따뜻한 베이지·갈색 대비를 가진다.
- 보트는 갑판·난간·선체의 따뜻한 목재 대비가 읽히도록 현재 bounded visual study를 다듬는다.
- `scenes/game.tscn`의 Normal/Appreciation 카메라 구도와 UI 높이만 필요한 범위에서 조정한다.
- 기존 승인 방석 3종과 Bright Boat 엽서 face의 runtime consumer를 보존한다.
- 구조 계약, 기존 행동 계약, 540×960 Normal/Appreciation 캡처, Godot import와 scene smoke로 확인한다.

### 제외

- A/B/C 선택 UI, 다른 펫 종 선택 UI, 저장된 커스터마이즈 상태, 별도 progression.
- 최종 UV texture sheet, 새 AI 이미지 생성, 외부 model/asset, shader, Blender pipeline.
- 새벽·밝음·해질녘·밤 4시간대, 날씨 시스템, 보상/경제/돌봄/소셜 변경.
- PR #19 수정, rebase, merge, 흡수.

## 구조

기존 동작 owner와 데이터 계약은 유지한다.

```text
BoatSpace
├─ PlayerAvatarPlaceholder
│  └─ VisualStudy
│     └─ StorybookCDefault
├─ RestingPetPlaceholder
│  └─ VisualStudy
│     └─ StorybookDogDefault
└─ BoatBow
   └─ VisualStudy
      └─ StorybookHullPass
```

- `PlayerAvatarPlaceholder`는 계속 `is_technical_placeholder() == true`를 반환한다. 이번 기본 외형은 visual default이며 장래의 선택 기능을 미리 구현하지 않는다.
- `RestingPetPlaceholder`는 계속 `has_care_obligation() == false`를 반환한다.
- shared BoatSpace bob, 8개 decor slot ID, 현재 item ID와 interaction API는 바꾸지 않는다.
- dynamic decor는 `BoatDecorSlot`이 계속 소유한다. 이 작업은 texture path나 appearance state를 새로 만들지 않는다.

## 시각 규칙

- 모든 새 material은 opaque, `metallic = 0.0`, `roughness >= 0.8`이다.
- 피부·니트·치마·털·목재는 큰 색면과 낮은 반사로 구분한다. 작은 얼굴, 눈, 종별 무늬, 장식 과밀은 넣지 않는다.
- C 주인공의 핵심 구분은 긴 갈색 머리 질량, 크림 니트 상체, muted blue skirt, brown boots다.
- 강아지의 핵심 구분은 낮은 몸통, 처진 양쪽 귀, 베이지 털과 갈색 귀/등의 단순 대비다.
- 보트는 보트형으로 읽히는 따뜻한 목재 선체·갑판·난간을 우선한다. 실제 최종 보트 자산을 확정하는 작업은 아니다.
- 일반 카메라는 avatar + dog + boat + sea의 3/4 위계를 지키고, Appreciation Camera는 UI를 작은 종료 행동만 남긴 채 수평선에 시선을 옮긴다.

## 검증

자동:

1. 기존 `test_handpainted_visual_slice_contract.gd`를 C 기본/강아지 형태, opaque matte 재질, compact Appreciation UI를 검증하도록 확장한다.
2. `test_diorama_avatar_camera_contract.gd`, `test_runtime_image_asset_contract.gd`, decoration/interaction 계약을 회귀 검증한다.
3. Godot editor headless import, 모든 focused contract, main menu/game/album scene smoke를 실행한다.
4. Godot을 자동으로 열어 Compatibility renderer에서 540×960 Normal/Appreciation 이미지를 다시 캡처한다.

사람 검토:

- 일반 화면에서 C 주인공·강아지·보트·바다의 읽기 순서가 자연스러운가.
- 감상 화면이 빈 화면이나 과밀한 UI가 아니라 바다 중심의 휴식으로 느껴지는가.
- 실제 기기 터치 검증은 사용자 결정에 따라 별도 단계로 남긴다.

## 완료 기준

- C 니트·긴 머리 기본 주인공과 강아지가 runtime 540×960 Normal 캡처에서 명확하게 구분된다.
- 이미지 기반 방석과 엽서의 기존 runtime 계약이 계속 통과한다.
- Normal/Appreciation 카메라, shared bob, 항해 상태, 보상 격리, care-free pet semantics가 회귀하지 않는다.
- PR #19는 변경 없이 독립 상태를 유지한다.
- 자동 검증과 runtime capture 후 사용자가 시각 결과를 승인한다.
