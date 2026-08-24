# Godot Direction

이 저장소는 Godot 전용 프로젝트입니다.

## 결정

- 엔진은 Godot 4.7 stable을 사용합니다.
- 언어는 GDScript를 우선 사용합니다.
- 루트의 `project.godot`이 실제 작업 기준입니다.
- 모든 씬은 `scenes/` 아래에 둡니다.
- 모든 스크립트는 `scripts/` 아래에 둡니다.
- normal play presentation은 보이는 플레이어 Avatar + Pet + Boat + Sea가 함께 보이는 **3/4 Boat Diorama**입니다.
- 기존 sea-focused draggable view는 **Appreciation Camera**로 보존합니다.

## 작업 기준

- 모바일 세로 화면을 먼저 고려합니다.
- PC 마우스 입력도 함께 지원합니다.
- core voyage/rest/pet/decor/album/fishing/soundscape는 local-first로 유지합니다.
- 온라인은 승인된 delayed `FriendBottle` / `DriftBottle`과 필수 identity/safety 운영에만 한정합니다.
- realtime/global/public chat, public feed, follower/ranking, 위치 기반 매칭은 추가하지 않습니다.
- `DriftBottle`은 production moderation + Terms + 16+ age gate + report/block + 운영 evidence 전에는 공개 활성화하지 않습니다.
- 결제, 광고, 유료 에셋 의존은 추가하지 않습니다.
- 복잡한 프레임워크보다 작은 기능 Slice와 검증 가능한 인터페이스를 우선합니다.

## 현재 구현/미구현 경계

```text
TECH_DIORAMA_SHELL = implemented
VISIBLE_AVATAR_PLACEHOLDER = implemented
APPRECIATION_CAMERA = preserved
BOAT_DECORATION = not implemented
INTERACTABLE_RUNTIME = not implemented
FRIEND_BOTTLE = not implemented
DRIFT_BOTTLE = not implemented
SOCIAL_BACKEND = not implemented
```

서버/소셜 설계는 `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md`를 따릅니다.

## GitHub Desktop 사용 흐름

```text
작업 전 Pull
→ Godot에서 수정
→ GitHub Desktop에서 변경사항 확인
→ Commit
→ Push
→ Codex/GPT가 GitHub 기준으로 검토 또는 수정
```
