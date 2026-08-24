# Contributing

`my little boat`는 **보이는 플레이어 Avatar + Pet + Boat + Sea가 함께 보이는 3/4 디오라마**를 기본 화면으로 사용하는 Godot 기반 rest-first 힐링 항해 게임입니다. 기존 바다 중심 드래그 view는 `Appreciation Camera`로 보존합니다. 모든 기여는 편안함·개인 공간 애착·낮은 압력의 상호작용을 해치지 않는 방향이어야 합니다.

## 작업 전 확인

1. 관련 Issue와 최신 `AGENTS.md`가 있는지 확인합니다.
2. L1+ 구조 변경이면 승인된 Spec/Plan을 먼저 확인합니다.
3. 변경 범위를 독립 검증 가능한 작은 Slice로 잡습니다.
4. Godot에서 열 수 있는 프로젝트 구조를 유지합니다.
5. 모바일 세로 화면을 먼저 고려합니다.
6. 자동 PASS와 Human/실기기 PASS를 구분합니다.

## 코드 원칙

- Godot 4.7 stable과 GDScript를 사용합니다.
- 초보자가 읽을 수 있는 명확한 이름을 사용합니다.
- 씬과 스크립트는 가능한 한 한 가지 책임만 갖게 합니다.
- 노드 이름은 역할을 알 수 있게 짓습니다.
- 중요한 함수에는 짧은 주석을 둡니다.
- core voyage/rest/pet/decor/album/fishing/soundscape는 local-first로 유지합니다.
- 온라인은 승인된 delayed `FriendBottle` / `DriftBottle`과 필수 identity/safety 운영에만 한정합니다.
- provider/service-role secret을 Godot 클라이언트에 넣지 않습니다.
- 결제, 광고, 유료 에셋 의존을 추가하지 않습니다.

## 게임 방향

추가/개선해도 좋은 것:

- 마음 선택에 따른 부드러운 색감, 소리, 이벤트 변화
- visible Avatar + Pet + Boat + Sea가 함께 읽히는 3/4 디오라마
- `Appreciation Camera`와 방치형 바다 감상 경험
- 사진, authored 편지, 풍경, 동반자 반응, 앨범 기억
- 능력치 없는 보트 꾸미기와 낮은 압력의 생활 상호작용
- 조용한 자연음과 production OceanBed
- 승인된 delayed bottle social을 Spec/안전 Gate 범위에서 구현하는 것
- 모바일 세로 화면 UI/터치 개선

추가하지 말아야 할 것:

- 전투
- 실패 조건
- 경쟁 점수 / 랭킹
- 펫 배고픔·청소·피로·방치 패널티
- 반복 파밍을 만드는 상호작용/꾸미기
- realtime/global/public chat
- 공개 feed / follower / popularity 경쟁
- 위치 기반 매칭 / 데이팅
- 안전 Gate를 건너뛴 public DriftBottle
- 결제
- 광고
- 복잡한 상점

## 병편지 기여 규칙

관련 구현 전 `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md`를 읽습니다.

- 모든 MVP online social은 16+입니다.
- FriendBottle/DriftBottle은 delayed correspondence입니다.
- accepted bottle은 healthy backend/network에서 server-receivable 5분 이내를 목표로 합니다.
- no-recipient DriftBottle은 sent로 수락하지 않습니다.
- stranger thread는 최대 6통 후 mutual friendship gate로 이동합니다.
- public user directory / presence / typing / read receipt / public feed 없음.
- `DriftBottle`은 production moderation + Terms + report/block + 운영 evidence가 실제 PASS하기 전 feature flag OFF입니다.

## 테스트

Pull Request 또는 커밋 전 변경 범위에 맞는 최소 유효 검증을 수행합니다.

현재 기본 자동 검증:

- Godot 4.7 headless import
- calm voyage state
- fishing state
- game scene behavior
- album memory
- Appreciation Camera input/isolation
- Resting Core technical contract
- Diorama Avatar/Camera contract
- `main_menu.tscn`, `game.tscn`, `album.tscn` scene smoke

Human/실기기에서 별도로 확인할 것:

- 3/4 모바일 세로 구도에서 Avatar + Pet + Boat + Sea가 편안하게 보이는가
- normal diorama touch와 Appreciation Camera drag가 충돌하지 않는가
- 카메라/보트 bob이 멀미를 만들지 않는가
- 실제 자연 파도와 최종 visual이 30초/5분 휴식 경험을 만드는가

Human 검증을 하지 않았다면 `NOT_RUN`으로 남깁니다.
