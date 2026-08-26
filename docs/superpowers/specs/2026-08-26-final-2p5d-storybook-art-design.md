# 최종 2.5D 스토리북 아트 패스 설계

## 목표

승인된 C 니트·긴 머리 주인공, 강아지, 작은 나무 보트의 인상을 실제 Godot 3/4 디오라마에 적용한다. 기존 primitive mesh 기반의 기술 증명은 보존 가능한 fallback으로 남기되, Normal과 Appreciation 카메라에서 시안의 손그림 스토리북 분위기가 읽히는 투명 PNG 기반 2.5D 아트 레이어로 교체한다.

## 사용자 경험

- Normal 화면에서 C 주인공, 옆에서 쉬는 강아지, 나무 보트, 바다와 수평선이 한 번에 읽힌다.
- Appreciation 화면에서는 두 존재와 보트가 장면의 작은 일부가 되고 바다와 수평선이 우선한다.
- 새 아트는 UI 초상화가 아니라 3D 보트 공간에 놓이는 카메라 대응 투명 스프라이트다.
- 선택, 능력치, 보상, 돌봄 의무, 저장 데이터, 항해 시간, 소셜 기능은 바꾸지 않는다.

## 아트 패키지

다음 세 파일만 새 정본 후보로 제작한다. 모두 PNG, sRGB, 투명 배경, 알파 가장자리가 깨끗해야 하며 외부 캔버스, 프레임, 문자, 로고, 워터마크를 포함하지 않는다.

| 파일 | 크기 | 내용 | 런타임 위치 |
| --- | --- | --- | --- |
| `assets/images/runtime/storybook/c_default_storybook.png` | 1024×1024 | 긴 갈색 머리, 크림 니트, muted blue 치마, 갈색 부츠, 작은 펜던트의 C 주인공. 앉아 쉬는 3/4 후면/측면 실루엣 | `PlayerAvatarPlaceholder/VisualStudy/StorybookCDefault/ArtCard` |
| `assets/images/runtime/storybook/dog_default_storybook.png` | 1024×1024 | 보트에서 낮게 쉬는 따뜻한 베이지 털과 갈색 처진 귀의 강아지 | `RestingPetPlaceholder/VisualStudy/StorybookDogDefault/ArtCard` |
| `assets/images/runtime/storybook/boat_default_storybook.png` | 1536×1024 | 따뜻한 나무 선체·갑판·난간, 무채색 그림자만 가진 작은 보트 3/4 상부 시점 | `BoatBow/VisualStudy/StorybookHullPass/ArtCard` |

각 이미지는 현재 사용자 제공 Image A/B/기타 보드의 인물·색감·보트 구성에서 실루엣과 생활감만 참조한다. 해당 시안을 재현·복제하거나 텍스트·테두리·presentation canvas를 런타임에 가져오지 않는다.

## 런타임 구조

```text
BoatSpace
├─ BoatBow
│  └─ VisualStudy/StorybookHullPass
│     ├─ 기존 MeshInstance3D fallback (숨김)
│     └─ ArtCard: Sprite3D
├─ PlayerAvatarPlaceholder
│  └─ VisualStudy/StorybookCDefault
│     ├─ 기존 MeshInstance3D fallback (숨김)
│     └─ ArtCard: Sprite3D
└─ RestingPetPlaceholder
   └─ VisualStudy/StorybookDogDefault
      ├─ 기존 MeshInstance3D fallback (숨김)
      └─ ArtCard: Sprite3D
```

- `ArtCard`는 `Sprite3D`이고 투명 PNG를 사용하며, normal/appeciation 양쪽 카메라에서 정면이 읽히도록 billboard를 사용한다.
- 각 카드는 원래 owner의 위치와 shared bob을 상속한다. 카드를 새 gameplay owner로 만들지 않는다.
- 기존 mesh는 `ArtCard.texture`가 없거나 로드에 실패할 때에만 보이는 fallback으로 만든다. 유효한 정본 PNG가 있으면 fallback mesh는 숨긴다.
- 보트 장식 슬롯, 승인된 방석 3종, Bright Boat postcard, `is_technical_placeholder()`, `has_care_obligation()`, camera mode와 상태 API를 그대로 유지한다.
- 기존 scene node를 대량 교체하지 않는다. 새 스크립트는 필요한 경우에만 하나를 만들며 첫 줄에 한국어 역할 주석을 넣는다.

## 생성·정규화 규칙

- 이미지 생성은 투명 배경을 보존하는 built-in 이미지 생성 도구를 사용한다.
- 선택한 출력만 프로젝트 경로에 복사하고, 기존 파일을 덮어쓰지 않는다.
- Godot import 뒤 `Image` 기반 계약 검증으로 정확한 dimensions, alpha, 경로와 세 `Sprite3D` consumer를 확인한다.
- 출력이 불투명 배경, 문자, 프레임, 광범위한 외부 그림자를 포함하면 정본으로 사용하지 않고 한 번의 목표 지향 재생성을 한다.

## 검증과 승인

자동 검증은 이미지 규격/alpha/경로, `Sprite3D` consumer, C/강아지/보트의 기존 care-free와 decor 계약, headless Godot import, 전체 contract suite 및 main menu/game/album smoke를 포함한다. Compatibility renderer로 540×960 Normal/Appreciation runtime 캡처를 다시 만든다.

사용자가 두 캡처의 실제 아트 표현을 승인한 뒤에만, 세 새 파일을 Notion Asset Library에 정본으로 등록하고 SHA-256·provenance·durable binary locator를 기록한다. 승인 전에는 `FINAL_AVATAR_ART`, `FINAL_PET_ART`, `FINAL_BOAT_SEA_ART`를 완료로 올리지 않는다. 실기기 모바일 QA는 별도 보류 상태로 남긴다.

## 제외

- 다른 주인공/펫 선택 UI, 시간대·날씨·애니메이션 세트, UI icon pack, 메인 메뉴 배경, 경제·보상·돌봄·소셜 변경.
- 캐릭터/펫/보트 UV texture sheet, Blender/외부 3D model pipeline, shader 시스템.
- PR #19의 수정, rebase, 흡수, 병합.

## 완료 기준

1. 세 투명 PNG가 프로젝트의 고정 경로에 존재하고 정규화 계약을 통과한다.
2. C, 강아지, 보트 아트 카드가 Normal/Appreciation 캡처에서 기존 mesh fallback 대신 읽힌다.
3. 기존 decor, camera, voyage, care-free 및 social 경계 검사가 회귀하지 않는다.
4. 런타임 캡처가 생성되고 사람이 시각 결과를 승인한다.
5. 승인 후에만 Notion 정본·SHA-256·provenance·durable binary locator와 문서 상태를 확정한다.
