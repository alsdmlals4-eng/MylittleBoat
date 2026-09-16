# 마이 리틀 보트 문서 지도

이 지도는 질문을 현재 owner로 연결합니다. mutable implementation state를 복제하지 않으며, 실제 상태는 각 owner와 repository source/evidence를 fresh-read합니다.

## Current owner route

**2026-09-16 우선 경로.** 작은 섬 농장·바다 감상으로 방향이 변경됐다. GDD 첫 결정이 새 방향을 소유하고 기존 R01–R12는 중단된 역사적 계획이다. 기존 handoff의 날짜별 누적 작업일지를 갱신하며 PDF는 같은 월간 파일에 추가하는 파생 보고서다. 아래 9월14일 설명은 당시 경로로만 읽는다.

2026-09-14 현재 요청은 남은 작업의 설계·구현 명세 준비다. 제품·설계 owner는 `PROJECT_GDD.md`의 **R01–R12**, 작업 순서·파일·테스트 절차는 [남은 작업 구현 계획](superpowers/plans/2026-09-14-remaining-implementation.md)이다. 실제 구현 상태는 handoff와 코드/evidence로 확인한다. 문서 작성이 runtime 구현/최종 아트 승인/출시 승인을 뜻하지 않는다. 아래 과거 PDF의 current 표기는 당시 publication receipt에 한정한다.

| 질문 | current owner |
| --- | --- |
| 사람용 프로젝트 경험·결정·layered Blueprint | `docs/design/PROJECT_GDD.md` — `CURRENT_HUMAN_FACING_GDD` |
| 이전 AI specification 안내 | `docs/design/PROJECT_AI_PRODUCTION_SPEC.md` — `SUPERSEDED_POINTER_NOT_EDITING_MASTER` |
| 실제 Godot 구현·test·runtime evidence ceiling | `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md` + actual code/Scene/tests/evidence |
| visual consumer·provenance·capture/Human boundary | `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md` |
| Base 적용 순서·project-local 변형·release identity | `docs/operations/MY_LITTLE_BOAT_BASE_ADAPTER.json` |
| 실제 Base reusable module 선택 상태 | `docs/base-reuse-adoption.json` + actual consumer/lock/read-only Base check |

`HUMAN_GAME_BLUEPRINT_GDD_LAYERED_PROFILE`

`NO_SEPARATE_BLUEPRINT_ARTIFACT`

Blueprint는 별도 artifact가 아니라 current `PROJECT_GDD.md`의 reading/composition profile입니다.

| layer | route |
| --- | --- |
| `PROJECT_PLAYER_LAYER` | GDD §1–§3 |
| `SYSTEM_LAYER` | GDD §4–§5 |
| `CONTENT_UX_PRESENTATION_LAYER` | GDD §5–§6 |
| `PRODUCTION_EVIDENCE_LAYER` | GDD §7–§8 + current handoff/visual inventory/runtime truth |

```text
3-MINUTE PROJECT / PLAYER READ
-> 10-MINUTE SYSTEM + CONTENT / UX / PRESENTATION READ
-> DETAIL READ
-> IMPLEMENTATION READ
-> VERIFICATION READ
```

## Publication boundary

| artifact | route status |
| --- | --- |
| `output/pdf/MY_LITTLE_BOAT_HUMAN_GAME_BLUEPRINT_20260902.pdf` | `HISTORICAL_SOURCE_BOUND_PUBLICATION`; 당시 GDD를 읽는 보존 PDF, 새 재기획 내용 미포함 |
| `output/pdf/MY_LITTLE_BOAT_HUMAN_GAME_BLUEPRINT_20260902.receipt.json` | `HISTORICAL_PUBLICATION_SOURCE_AND_ASSET_RECEIPT`; 당시 source·generator·image·PDF hash를 변경하지 않음 |
| `output/pdf/MY_LITTLE_BOAT_HUMAN_GAME_BLUEPRINT_20260902.source.md` | `IMMUTABLE_PUBLICATION_SOURCE_SNAPSHOT`; receipt의 GDD hash와 일치하는 원문, 새 정본/편집 owner 아님 |
| `exports/my-little-boat_MASTER_PRODUCTION_GDD_20260829.pdf` | `HISTORICAL_STALE_PUBLICATION_NOT_CURRENT_SOURCE`; 이전 그림체·구현 전 상태·이전 시작 흐름을 current 안내로 쓰지 않음 |
| `exports/my-little-boat_MASTER_PRODUCTION_GDD_20260828.pdf` | `HISTORICAL_DERIVED_NOT_CURRENT_SOURCE` |

`CURRENT_BLUEPRINT_PLAYER_FACING_SELECTION`은 current GDD의 §1–§6과 concise §7, 실제 runtime capture만 선택합니다. GDD §8의 기술 receipt는 evidence layer에 보존하되 player-facing PDF에 반복하지 않습니다. PDF binary는 source owner가 아닙니다.

## Prospective future-package route

`PLAN -> REQUIRED_IMAGE_AND_MATERIAL_PREPARATION -> BLUEPRINT_REVIEW_PUBLICATION -> USER_FINAL_REVIEW_APPROVAL -> IMPLEMENTATION`

- `NO_IMPLEMENTATION_BEFORE_USER_FINAL_APPROVAL`: profile 채택 뒤 새 package는 exact reviewed revision의 명시적 final approval 전 시작하지 않습니다.
- `PROSPECTIVE_ONLY_EXISTING_IMPLEMENTATION_EVIDENCE_PRESERVED`: 기존 merged code/data/Scene/test와 runtime/GPU evidence는 소급 취소하지 않습니다.
- `PROSPECTIVE_ONLY_PREEXISTING_EXACT_USER_APPROVED_IMPLEMENTATION_AUTHORITY_PRESERVED`: pre-adoption exact package approval은 그 기록된 범위에 한해 유지합니다.
- `EXACT_APPROVED_SCOPE_AND_REVISION_ONLY`: grandfathering은 같은 package·scope·revision에만 적용합니다.
- `SCOPE_EXPANSION | SUCCESSOR_PACKAGE | INFERRED_BLANKET_APPROVAL`: scope 확대, successor, inferred blanket approval은 금지되며 새 lifecycle이 필요합니다.
- 새 image deliverable은 current conversation approval과 `IMAGE_MODEL_REQUIRED_FOR_IMAGE_CREATION_OR_EDITING`을 따릅니다.
- exact diagram은 `TEXT_NATIVE_EXACT_DIAGRAMS` 및 `STRUCTURED_INFORMATION_ARTIFACTS_REMAIN_TEXT_NATIVE`에 따라 Mermaid/Flow/table로 유지합니다.

PR #19의 README/workflow/social paths는 `READ_ONLY_NO_ABSORPTION`이며 이 profile이 authority를 추가하지 않습니다.

## Base adaptation route

`docs/operations/MY_LITTLE_BOAT_BASE_ADAPTER.json`은 Base v9.4.4의 공용 preflight·증거·검토 원칙을 프로젝트에 맞춰 적용하는 정본입니다. 기존 GDD, Godot handoff, visual inventory, asset provenance, Scene, script, save, test, runtime evidence를 새 Base template로 옮기지 않습니다.

```text
latest user direction
-> project AGENTS / GDD / handoff / visual inventory / actual consumer
-> MY_LITTLE_BOAT_BASE_ADAPTER
-> current Base release and targeted reuse evidence
-> reuse and three-alternative decision
-> bounded project owner change
-> machine/runtime evidence as applicable
-> five-loop review, handoff, remaining-work recalculation
```

`docs/base-reuse-adoption.json`은 모듈 vendoring manifest이며 운영 adapter가 아닙니다. 실제 destination과 adoption lock이 없는 module을 `enabled`로 표시하지 않습니다. Base open PR, current main, optional directory scaffold, Notion, HiGodot, GUT, Hera, and shared helper code are automatic adoption targets가 아닙니다.
