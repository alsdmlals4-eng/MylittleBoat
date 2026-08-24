# AI Collaboration Guide

이 저장소는 사람, GPT, Codex가 GitHub를 경유해 함께 작업하는 방식을 기준으로 운영합니다.

## 고정 기준

- 프로젝트명: `my little boat`
- 엔진: Godot 4.7 stable
- 언어: GDScript
- 장르: rest-first cozy boat diorama / healing voyage game
- normal presentation: 보이는 플레이어 Avatar + Pet + Boat + Sea의 3/4 Diorama
- optional presentation: sea-focused `Appreciation Camera`
- 우선 플랫폼: 모바일 세로 화면, PC 지원
- core game: local-first
- 온라인 허용 범위: 승인된 delayed FriendBottle / DriftBottle + identity/safety 운영만
- 금지: 전투, 실패 조건, 경쟁/랭킹, 결제, 광고, realtime/global/public chat, 공개 feed/follower 경쟁

## 역할

### 사람

- 최종 방향과 우선순위를 정합니다.
- 기능 추가, 버그 수정, 기획 변경을 승인합니다.
- 실제 Godot/기기/Human 품질 검증을 최종 판단합니다.

### GPT

- 기획, UX, 구조, 벤치마킹, 안전, 문서, 테스트 관점에서 제안합니다.
- Issue를 만들 때 목적, 완료 기준, 사용자 경험, evidence ceiling을 명확히 정리합니다.
- Pull Request를 리뷰할 때 코드뿐 아니라 게임 콘셉트와 플레이 감정도 함께 봅니다.
- Notion 사람용 정본과 repository implementation mirror가 어긋나지 않는지 확인합니다.

### Codex

- Issue 또는 명확한 요청을 기준으로 Godot 프로젝트를 수정합니다.
- GDScript, Scene, 문서, 계약 테스트를 함께 갱신합니다.
- 승인된 Slice 범위를 넘어서 기능/백엔드/소셜을 임의 확장하지 않습니다.

## 작업 흐름

1. 사람용 방향을 Notion에서 확인/승인합니다.
2. L1+ 변경은 설계/spec과 대안을 정리합니다.
3. 작은 구현 Slice의 Issue/Plan을 만듭니다.
4. RED 계약을 먼저 만들고 실제 실패 이유를 확인합니다.
5. 최소 GREEN 구현을 진행합니다.
6. exact-head Godot CI와 Scene smoke를 확인합니다.
7. whole-state 적대적 검토를 반복합니다.
8. PR을 병합하고 main을 readback합니다.
9. Notion을 최종 main SHA와 evidence boundary로 동기화합니다.
10. Human/실기기 검증 전에는 시각·감정 품질 PASS를 주장하지 않습니다.

## Issue 작성 원칙

- 한 Issue에는 하나의 독립 검증 가능한 목표를 둡니다.
- 결과를 구체화합니다. 예: `Appreciation Camera가 inactive일 때 normal diorama ScreenDrag를 소비하지 않는다.`
- 자동 검증과 Human 검증을 구분합니다.
- 제외할 것도 적습니다. 예: 해당 Slice에서 Supabase/Decoration runtime/Final Art 제외.

## Pull Request 작성 원칙

- 변경한 기능과 제외 범위를 짧게 요약합니다.
- exact reviewed head SHA와 Godot CI run을 적습니다.
- 아직 확인하지 못한 Human/실기기/production 위험을 숨기지 않습니다.
- 다른 진행 중 PR을 임의로 수정하거나 흡수하지 않습니다.

## 병편지 작업 경계

병편지 관련 요청은 `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md`를 우선 확인합니다.

- 모든 MVP online social은 16+.
- FriendBottle/DriftBottle은 delayed correspondence이며 instant messenger가 아닙니다.
- public user directory / presence / typing / read receipt / public feed / follower/ranking 없음.
- DriftBottle은 production moderation + Terms + report/block + 운영 evidence 전에는 public feature flag OFF입니다.
- provider/service-role secret을 Godot 클라이언트에 넣지 않습니다.

## Codex에게 줄 수 있는 요청 예시

```text
Issue #N을 승인된 implementation plan 범위 안에서 구현해줘.
Godot 4.7 stable, TDD RED/GREEN, exact-head CI를 지키고
아직 구현하지 않은 Decor/Social/Final Art는 완료처럼 표시하지 마.
```

```text
game.tscn의 3/4 Boat Diorama를 개선해줘.
Avatar + Pet + Boat + Sea가 모바일 세로에서 같이 읽혀야 하고,
Appreciation Camera의 기존 sea-focused drag 경험을 회귀시키지 마.
```
