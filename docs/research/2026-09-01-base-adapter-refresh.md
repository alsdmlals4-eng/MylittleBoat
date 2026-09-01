# 2026-09-01 Base adapter fresh-read and project adaptation receipt

## 범위와 판정

- 요청 범위는 Base의 최신 계약을 상세 fresh-read하고 My Little Boat의 작업 순서, 구조, 계약에 맞게 갱신하는 일입니다.
- 판정은 `FEASIBLE / IMPLEMENTED_DOCUMENT_AND_CONTRACT_LAYER / RUNTIME_NOT_APPLICABLE`입니다.
- 이 receipt는 제품 기능, Scene, GDScript, save schema, 승인 asset, Human/device evidence를 변경하지 않습니다.

## 현재 상태와 확인한 owner

| 구분 | current source | readback | 적용 방식 |
| --- | --- | --- | --- |
| 프로젝트 방향 | `AGENTS.md`, `docs/design/PROJECT_GDD.md` | rest-first, local-first, normal 3/4 diorama와 Appreciation Camera의 경계 유지 | `ADOPT` |
| 구현·evidence | `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`, visual inventory, Scene/GDScript/tests/evidence | 2026-09-01 Look Around foreground split까지 구현·machine/runtime evidence가 분리되어 있음 | `ADAPT` — Base가 이 owner를 대체하지 않음 |
| Base release | `Base/docs/BASE_RULES_VERSION.md`, `base-v9.4.4.lock.json`, `tools/base_release_index.py` | v9.4.4 payload `210ec782`, evidence `bb61e68d`, finalization `5adc196c` 확인 | `ADOPT` |
| Base current main | `alsdmlals4-eng/Base` local `main`/`origin/main` | `19355b7e`; Base tracked diff는 없고 `Base-worktrees/`는 pre-existing untracked로 보존 | `REFERENCE_ONLY` |
| Base reuse profile | Base `profiles/MY_LITTLE_BOAT.json`, adoption README, project `docs/base-reuse-adoption.json` | 프로젝트 manifest의 RM-VIS-001/002가 실제 destination 없이 `enabled`로 남아 있음 | `CORRECT` |
| 열린 PR | project PR #19, Base open PR list | 서로 다른 workstream이며 read-only | `ADOPT_OPEN_PR_READ_ONLY` |

Base v9.4.4의 필수 순서는 project implementation/assets/tests → approved project reference → Base reuse/current knowledge → targeted cross-project evidence → 필요한 외부 조사입니다. 이 작업은 운영 adapter와 실제 manifest를 대상으로 하므로 Base release·current project·Base profile이 직접 비교 대상이며, 새 게임 기능이나 엔진/플랫폼 동작을 도입하지 않아 별도 외부 기술 source는 `NOT_APPLICABLE`입니다.

## 대안 비교

| 대안 | 판정 | 이유 | 결과 |
| --- | --- | --- | --- |
| A. Base V4 template, directory, optional tool을 그대로 프로젝트에 이식 | `REJECT` | 현재 GDD/handoff/visual inventory/Godot test owner를 중복시키고, stable path와 local-first 경계를 불필요하게 바꿉니다. | 새 정본·새 dependency를 만들지 않음 |
| B. 기존 manifest만 고치고 작업 순서는 새 문서로 정의하지 않음 | `REJECT` | `enabled` false claim은 해결하지만 release payload/evidence/finalization identity와 프로젝트 변형·보호면을 다음 작업자가 다시 추측하게 합니다. | drift 재발 위험 유지 |
| C. Base v9.4.4 identity를 pin한 project-local adapter + 기존 manifest 정정 + 현재 owner route 전파 | `ADOPT` | Base의 재사용 우선·증거 분리·5회 review를 흡수하면서 실제 GDD·handoff·visual/runtime owner와 게임 고유 의미를 보존합니다. | 최소 변경으로 future fresh-read를 재현 가능하게 함 |

## 채택 구조

```text
Latest user direction
-> AGENTS.md + project GDD/handoff/visual inventory + actual consumer
-> MY_LITTLE_BOAT_BASE_ADAPTER.json
-> Base v9.4.4 identity + targeted reuse profile/current Base drift
-> REUSE / ADAPT / REJECT decision
-> bounded owner change
-> static/machine/runtime evidence as applicable
-> five-loop review + PROJECT_WORK_REUSE_HANDOFF update
```

`docs/operations/MY_LITTLE_BOAT_BASE_ADAPTER.json`은 Base release identity, 적용/변형/미채택 규칙, 실제 owner, 단계별 acceptance, rollback을 소유합니다. `docs/base-reuse-adoption.json`은 오직 reusable-module vendoring manifest입니다. 두 문서를 같은 정본으로 합치지 않습니다.

## 실제 교정

1. 기존 `RM-VIS-001`과 `RM-VIS-002`는 consumer destination과 adoption lock이 없음을 실제 Base `reuse_adoption.py check` failure로 재현했습니다.
2. 두 module은 `deferred`로 변경하고 Base v9.4.4 payload commit을 pin했습니다. 새로운 vendored source나 lock은 만들지 않았습니다.
3. project-local adapter에 Base release triplet, project owner route, six-step work sequence, non-adoption list, protected scope와 rollback을 기록했습니다.
4. root `AGENTS.md`, documentation map, README, current Godot handoff에 adapter를 연결했습니다.
5. GDD의 이미 구현된 Direct Boat Entry package를 “다음 Phase 2”로 보이던 historical wording에서 현재 queue와 구분했습니다.

## 검증과 evidence ceiling

| 검증 | 결과 | ceiling |
| --- | --- | --- |
| Base v9.4.4 release checker | `PASS` | Base release identity만 확인 |
| old Base reuse manifest check | `FAIL` with two `DESTINATION_MISSING` findings | 기존 drift 재현 |
| project adapter contract test + full Python suite | `PASS` after correction, 10 tests `OK` | project routing/configuration machine evidence |
| corrected Base reuse check | `PASS`, `checked_modules=[]` | no module is claimed vendored |
| Godot runtime test/capture | `NOT_RUN_NOT_APPLICABLE` | runtime file/asset/scene change 없음 |
| remote CI, device/Human UX, release | `NOT_RUN` | 별도 gate 유지 |

## Adversarial review loops

| Loop | attack | validated finding / result | correction or readback |
| --- | --- | --- | --- |
| 1 | Base newest main이 project canon을 자동 교체하는가 | 아닙니다. Base v9.4.4도 project adoption은 별도 pin/adapter를 요구합니다. | project-local adapter로 분리 |
| 2 | 기존 reuse manifest가 실제 installation을 정직하게 나타내는가 | 아닙니다. 두 `enabled` destination이 없습니다. | Base read-only checker의 fail receipt 확보 |
| 3 | 교정이 module을 몰래 vendoring하거나 새 runtime dependency를 추가하는가 | 아닙니다. deferred manifest는 check 대상이 없고 project tree에 vendor file/lock이 없습니다. | corrected checker `ok=true` |
| 4 | adapter가 기존 owner를 중복하거나 historical queue를 current queue로 오인하는가 | GDD의 direct-entry Phase wording이 현재 상태와 혼동될 수 있었습니다. | historical contract로 relabel, handoff/README/map route 추가 |
| 5 | 문서 link·release pin·project path가 빠져 새 작업자가 다시 추측하는가 | project adapter contract test와 full Python suite로 확인했습니다. | route/path/release assertions and full Python suite recheck `PASS` |

## 롤백과 Base 환류

- Rollback은 이 task의 project commit만 되돌립니다. Base, Scene, script, Resource, asset, save, other PR은 변경하지 않습니다.
- `NO_NEW_BASE_PROMOTION`: 이번 발견은 기존 Base의 reuse-manifest semantics와 project adapter boundary를 적용한 사례입니다. 단일 프로젝트의 stale manifest 정정만으로 Base 규칙을 새로 승격하지 않습니다.
