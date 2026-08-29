# 마이 리틀 보트 문서 지도

이 지도는 질문을 현재 owner로 연결합니다. mutable implementation state를 복제하지 않으며, 실제 상태는 각 owner와 repository source/evidence를 fresh-read합니다.

## Current owner route

| 질문 | current owner |
| --- | --- |
| 사람용 프로젝트 경험·결정·layered Blueprint | `docs/design/PROJECT_GDD.md` — `CURRENT_HUMAN_FACING_GDD` |
| 이전 AI specification 안내 | `docs/design/PROJECT_AI_PRODUCTION_SPEC.md` — `SUPERSEDED_POINTER_NOT_EDITING_MASTER` |
| 실제 Godot 구현·test·runtime evidence ceiling | `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md` + actual code/Scene/tests/evidence |
| visual consumer·provenance·capture/Human boundary | `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md` |

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
| `exports/my-little-boat_MASTER_PRODUCTION_GDD_20260829.pdf` | `TRACKED_LATEST_PUBLICATION_SOURCE_BINDING_UNVERIFIED`; generator/source-SHA receipt 없음; reissue deferred |
| `exports/my-little-boat_MASTER_PRODUCTION_GDD_20260828.pdf` | `HISTORICAL_DERIVED_NOT_CURRENT_SOURCE` |

PDF binary는 source owner가 아니며 이번 profile adoption에서 수정하지 않습니다.

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
