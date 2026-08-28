# 바로 보트 시작과 사람용 GDD 정본화 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use `superpowers:executing-plans` to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**목표:** 승인된 `실행 → 바로 물 위 보트` 흐름과 사람 중심 기획서를 저장소의 현재 정본으로 만들되, Godot 구현은 시작하지 않는다.

**구조:** 사람용 정본은 `docs/design/PROJECT_GDD.md` 한 곳이 소유한다. 구현 파일·테스트·캡처·해시·이전 계약은 각자의 handoff/evidence/spec owner에 남기고, GDD에는 플레이어 경험과 실제 상태만 짧고 분명하게 적는다. 현재 선택형 메인 화면은 삭제하거나 고치지 않고 다음 Phase 2 구현 계약의 `PRODUCT_SUPERSEDED_IMPLEMENTATION`으로 기록한다.

**기술 기반:** Markdown, GitHub, Godot 4.7 GDScript 프로젝트의 기존 Scene/Resource/test evidence, Godot 공식 안정판 문서, PDF 출력 및 렌더 검수.

**설계 명세:** `docs/superpowers/specs/2026-08-28-direct-boat-entry-human-gdd-design.md`

## 전역 제약

- 기준 원격 main은 `4fa64b9772225b0cb108f8b0aa5cc16a374f253a`이며, 실행 전 항상 최신 `origin/main`을 다시 읽는다.
- 현재 작업 브랜치는 `codex/issue-99-direct-boat-entry-gdd`, Draft PR은 #100이다.
- 모든 새 프로젝트 문서는 한국어로 작성한다. 파일명·Godot 경로·상태 코드·API 이름은 필요할 때만 원문을 유지한다.
- Notion은 이관 완료된 historical discovery archive다. 새 Notion write, Notion을 현재 정본으로 부르는 문구, Notion 링크를 현재 owner로 쓰지 않는다.
- PR #19 `feat/social-fake-backend-20260824`는 `READ_ONLY_NO_ABSORPTION`이다.
- Godot Scene, GDScript, Resource, asset binary, test, package, visual generation은 이 계획의 수정 범위가 아니다.
- `오늘의 마음`과 시작 전 identity/pet/time 선택은 제품 정본에서 제거한다. 현재 코드에 남아 있어도 구현 완료 주장으로 바꾸지 않는다.
- 새 저장의 분위기는 `bright`, 이후 진입은 마지막 저장 분위기를 사용한다. 이 계획은 분위기를 바꾸는 새 UI를 발명하지 않는다.
- 사용자 제공 구형 메인 구성은 `REJECTED_FOR_MAIN_ENTRY_RUNTIME_USE`이다. 개별 보트·바다 이미지의 삭제/교체 여부는 별도 consumer audit 전까지 결정하지 않는다.
- 모든 핵심 결정 전후로 `현재 정본 → 실제 코드/데이터 → 공식 최신 자료 → 적대적 검토` 순서를 따른다. 발견 사항은 원래 owner에만 기록한다.
- 완료 판단은 `문서 readback + 링크/형식 검사 + PDF 렌더 확인 + 적대적 검토 clean loop`가 모두 있을 때만 한다. 문서 변경은 Human usability 또는 runtime PASS를 뜻하지 않는다.

## 파일 및 책임 지도

| 파일 | 이 작업에서의 책임 |
| --- | --- |
| `AGENTS.md` | 현재 authority 순서, 저장소 중심 정본, direct-entry core loop, 한국어/적대적 검토/조사 원칙 |
| `README.md` | 프로젝트의 짧은 사람용 소개와 실제 현재 상태 |
| `docs/CONCEPT.md` | 플레이어 약속과 제품 정체성의 짧은 구조화 mirror |
| `docs/RESTING_EXPERIENCE_BIBLE.md` | 휴식 경험과 시스템의 사람용 설명 |
| `docs/design/PROJECT_GDD.md` | 유일한 현재 사람용 GDD |
| `docs/design/PROJECT_AI_PRODUCTION_SPEC.md` | 새 GDD와 기술 owner로 향하는 짧은 supersession pointer |
| `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md` | 실제 구현 gap와 다음 Phase 2 runtime router |
| `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md` | screen/asset consumer 현황과 `VIS-ENTRY-001` disposition |
| `exports/my-little-boat_MASTER_PRODUCTION_GDD_20260828.pdf` | 사람이 읽을 수 있는 현재 GDD PDF 출력 |
| `docs/superpowers/specs/2026-08-28-direct-boat-entry-human-gdd-design.md` | 승인된 설계 명세 |
| `docs/superpowers/plans/2026-08-28-direct-boat-entry-human-gdd-reconciliation.md` | 이 실행 계획 |

## Task 1: 최신 authority와 구현 가능성 근거를 다시 읽는다

**파일:** 수정 없음.

**생산물:** 이 작업에 사용할 fresh source ledger와 공식 구현 가능성 근거.

- [ ] `git fetch origin --prune` 후 `origin/main`, 현재 브랜치, PR #19, Draft PR #100의 head/base를 읽는다. 새 main이 기준 SHA보다 앞서면 변경 파일을 비교하고 이 계획과 충돌하는 경우에만 작업을 멈춘다.
- [ ] 현재 product owner인 `AGENTS.md`, `README.md`, `docs/CONCEPT.md`, `docs/RESTING_EXPERIENCE_BIBLE.md`, `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`, current handoff, current visual inventory를 완독한다.
- [ ] 실제 owner를 읽는다. `scenes/main_menu.tscn`, `scripts/ui/main_menu.gd`, `scripts/core/game_state.gd`, `scripts/voyage/game_scene.gd`, 관련 main-menu/mood/time test와 540 x 960 capture 경로를 대조한다.
- [ ] 최신 공식 Godot 안정판 문서만 다시 조사하고, 아래 판단을 GDD의 “구현 가능성” 문단에 한 문장씩 반영한다.

  | 검증 항목 | 공식 근거 | 이 작업의 결론 |
  | --- | --- | --- |
  | Scene 간 상태 | `Singletons (Autoload)` | 현재 `GameState` autoload는 scene 전환을 넘어 local state를 소유할 수 있으므로, mood 제거와 direct start는 별도 data migration으로 구현 가능하다. |
  | local 설정 | `ConfigFile`, `user://` filesystem | 마지막 분위기와 cosmetic 선택은 로컬 저장으로 구현 가능하다. 저장 위치와 migration은 Phase 2 계약이 결정한다. |
  | 시작 Scene/route | `SceneTree` scene switching | main scene을 direct boat route로 바꾸고 optional customization surface를 연결하는 것은 Godot 표준 Scene 전환 범위다. |

- [ ] 공식 문서 URL, 확인 날짜, 위의 한계는 `PROJECT_GDD.md`의 간결한 “구현 가능성” 문단과 technical handoff의 evidence link에만 기록한다. 최신/unstable 문서를 4.7 구현 근거로 쓰지 않는다.
- [ ] Task 1 adversarial check를 실행한다.

  ```text
  A1. 공식 문서가 실제로 stable인지 확인한다.
  A2. Autoload가 state lifetime을 제공한다는 사실과 persistence migration 완료를 혼동하지 않는다.
  A3. Scene route 변경 가능성을 현재 runtime이 이미 변경됐다는 주장으로 바꾸지 않는다.
  A4. 조사 결과가 새 분위기 UI, 새 asset, social scope를 발명하지 않는지 확인한다.
  ```

## Task 2: 현재 정본의 front door를 고친다

**파일:**

- 수정: `AGENTS.md`
- 수정: `README.md`
- 수정: `docs/CONCEPT.md`
- 수정: `docs/RESTING_EXPERIENCE_BIBLE.md`

**생산물:** 사람이 어디서 시작하고 무엇을 하는지 네 문서가 같은 말로 설명한다.

- [ ] `AGENTS.md` authority bootstrap에서 current Notion owner 문구를 repository human-facing canon으로 교체한다. Notion은 migration-complete historical archive라고 한 줄로 남긴다.
- [ ] `AGENTS.md`의 Core Game Direction을 다음 의미로 바꾼다.

  ```text
  앱 실행 → 곧바로 Normal 3/4 boat diorama
  → 그냥 머무르기 또는 선택형 활동
  → 꾸미기에서만 외형·동반자·보트 장식 변경
  → 계속 쉬기 또는 개인 기록을 남기기
  ```

- [ ] `AGENTS.md`에 다음 지속 작업 원칙을 추가한다.

  ```text
  Material한 기획·구현·시각 작업마다 최신 관련 공식 자료와 실제 저장소 owner를 다시 읽는다.
  변경 전후에는 authority, player value, scope, implementation feasibility, runtime evidence, style/right drift를 공격적으로 검토한다.
  한국어 프로젝트 문서가 기본이며, 코드/API/경로는 정확성을 위해 원문 표기를 허용한다.
  ```

- [ ] `README.md`와 `docs/CONCEPT.md`에서 mood를 시작 선택 또는 핵심 정체성으로 설명하는 문장을 direct-entry promise로 바꾼다. `mood`가 과거 구현 용어로 필요한 경우에는 current product truth가 아닌 gap owner에만 남긴다.
- [ ] `docs/RESTING_EXPERIENCE_BIBLE.md`의 첫 세션 순서를 `실행 → 이미 떠 있는 보트 → 휴식/선택 활동 → 기억/계속 머물기`로 고치고, customization이 arrival 뒤의 선택 행동임을 명시한다.
- [ ] 밝음 first launch와 local last-atmosphere restore를 적되, 분위기 변경 UI의 위치는 `UNDECIDED_SEPARATE_SCOPE`로 표시한다.
- [ ] 파일별 readback을 실행한다. active-current sections에서 `오늘의 마음 선택`, `mood 선택 후 입장`, `Notion current owner`가 0건인지 확인한다. 역사·구현 gap 문맥은 삭제하지 않고 `PRODUCT_SUPERSEDED_IMPLEMENTATION`로 재분류한다.

## Task 3: 사람용 GDD 하나를 만들고 AI-heavy GDD를 retire한다

**파일:**

- 생성: `docs/design/PROJECT_GDD.md`
- 수정: `docs/design/PROJECT_AI_PRODUCTION_SPEC.md`
- 수정: `exports/my-little-boat_MASTER_PRODUCTION_GDD_20260828.pdf`

**생산물:** 사람이 처음부터 끝까지 읽을 수 있는 한국어 GDD와 그에 정확히 대응하는 PDF.

- [ ] `PROJECT_GDD.md`는 다음 8개 섹션만 사용한다.

  1. 게임 한눈에 보기와 Player Promise.
  2. 첫 30초와 `실행 → 바로 보트` 흐름.
  3. core/session/meta loop와 complete play의 의미.
  4. 시스템 카드: Floating Rest, Appreciation Camera, 꾸미기, 조용한 활동, 함께 보낸 시간, Ambient Discovery, Album.
  5. 화면 흐름과 optional customization.
  6. 확정 visual direction, `VIS-ENTRY-001` rejection, float-contact acceptance.
  7. 현재 제품 상태, 근거 ceiling, 공식 자료 기반 구현 가능성, 다음 Phase 2 contract.
  8. 금지 범위와 열린 결정.

- [ ] 각 시스템 카드는 정확히 다음 질문에 답한다: `플레이어가 무엇을 보고/하는가`, `왜 이 게임에 필요한가`, `어떤 피드백을 받는가`, `무슨 압박을 피하는가`, `실제 상태는 무엇인가`.
- [ ] GDD 본문에는 Scene path, script method, test name, SHA, PR number, raw data shape, hash table, Notion URL을 넣지 않는다. 독자가 runtime evidence가 필요할 때에만 handoff/evidence owner로 이동시킨다.
- [ ] `VIS-ENTRY-001`은 “보트가 바다 위에 합성된 것처럼 보여 사용하지 않는다”가 아니라, waterline/wave/wake/reflection의 구체적인 수용 기준까지 적는다. 개별 binary 전체 폐기라는 오해를 막는다.
- [ ] `PROJECT_AI_PRODUCTION_SPEC.md`의 본문은 GDD 대체 문서가 아니라 아래 상태를 명확히 하는 짧은 pointer로 바꾼다.

  ```text
  상태: SUPERSEDED_AS_CURRENT_GDD
  현재 사람용 정본: docs/design/PROJECT_GDD.md
  실제 코드·Scene·Resource·test·runtime evidence: docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md 및 docs/evidence/
  visual consumer/provenance: docs/visual/
  historical contracts: docs/superpowers/specs/ 및 docs/superpowers/plans/
  이 문서는 Player Experience PASS 또는 runtime alignment를 주장하지 않는다.
  ```

- [ ] PDF authoring 전 `pdf` skill의 artifact operation marker를 정확히 한 번 실행한다. `PROJECT_GDD.md`만 source로 사용해 기존 tracked PDF를 edit하고, 생성 중간물은 `tmp/pdfs/`에 둔다.
- [ ] PDF의 모든 페이지를 PNG로 render하여 제목 계층, 표 줄바꿈, 한글 glyph, footer/page number, `VIS-ENTRY-001` 섹션, final page를 시각 점검한다. PDF text extraction은 link/heading 보조 확인으로만 사용한다.
- [ ] PDF readback에서 GDD의 8개 섹션, `실행 → 바로 보트`, `오늘의 마음` 제거, `꾸미기` optional entry, `PRODUCT_SUPERSEDED_IMPLEMENTATION`, `NOT_RUN`의 의미를 확인한다.

## Task 4: 구현/visual owner에 실제 gap만 기록한다

**파일:**

- 수정: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`
- 수정: `docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md`

**생산물:** 사람용 GDD가 주장하는 제품과 실제 Godot slice가 다르다는 사실을 engineering owner에서 숨기지 않는다.

- [ ] current handoff의 main entry를 `PRODUCT_SUPERSEDED_IMPLEMENTATION`으로 바꾼다. 다음 Phase 2가 읽을 정확한 affected owners를 기록한다.

  ```text
  scenes/main_menu.tscn
  scripts/ui/main_menu.gd
  scripts/core/game_state.gd
  scripts/voyage/game_scene.gd
  tests/test_calm_voyage_state.gd
  tests/test_game_scene_contract.gd
  tests/test_game_scene_time_of_day_contract.gd
  tests/test_main_menu_identity_contract.gd
  tests/test_main_menu_time_of_day_contract.gd
  tests/test_main_menu_atmosphere_background_contract.gd
  tests/capture_main_menu_atmospheres.gd
  ```

- [ ] handoff에 phase separation을 명시한다: 이 PR은 문서 정본화만 수행하며, 위 code/tests/assets/captures는 수정하지 않는다. Next Phase 2는 direct start, mood data retirement/migration, optional customization entry, direct-entry visual acceptance, targeted tests/capture, Human validation을 하나의 구현 계약으로 다룬다.
- [ ] visual inventory의 old main-entry screen을 current target screen이 아닌 `SUPERSEDED_RUNTIME_SLICE`로 표시한다. Startup identity/time selection surface 역시 retire한다.
- [ ] `VIS-ENTRY-001`의 status, rejection reason, narrow consumer scope, provenance preservation, future 540 x 960 acceptance evidence를 visual inventory에 넣는다.
- [ ] `main_menu` atmosphere asset family와 C+dog binary의 status는 `CURRENT_RUNTIME_CONSUMED_BUT_NOT_APPROVED_FOR_NEW_DIRECT_ENTRY_COMPOSITION`으로 나눈다. 소비처 audit 전 source asset을 “사용 금지” 또는 “final art”로 오인하지 않는다.
- [ ] Notion ownership, mood-first player flow, existing main-menu capture를 current product approval처럼 부르는 문구를 이 두 owner에서 제거한다. historical receipt 자체는 그대로 보존한다.

## Task 5: 전체 candidate를 적대적으로 재검토한다

**파일:** Task 2-4의 변경 파일 전체.

**생산물:** correction 후 one clean loop가 남은 문서 candidate.

- [ ] Loop 1 - authority attack. 최신 사용자 결정, `AGENTS.md`, human GDD, concept, experience bible, handoff, visual inventory 사이의 direct-entry/mood/Notion/status drift를 전수 검색한다.
- [ ] Loop 2 - player-experience attack. “휴식이 core play인가”, “첫 30초가 menu인가”, “꾸미기가 선택 행동인가”, “각 시스템 설명이 기능 목록을 넘어 player value를 말하는가”를 공격적으로 대조한다.
- [ ] Loop 3 - implementation-feasibility attack. official Godot stable references와 current `GameState` autoload/ConfigFile pattern/scene route를 비교한다. persistence, migration, consumer, testing이 공식 근거보다 앞서 PASS로 쓰이지 않았는지 확인한다.
- [ ] Loop 4 - visual/rights attack. rejected composition이 source asset 전체 rejection으로 확대되지 않았는지, approved visual lock 외 그림체가 발명되지 않았는지, generation/planning image/runtime asset/Human evidence가 혼동되지 않았는지 확인한다.
- [ ] Loop 5 - evidence/scope attack. 문서 변경이 Godot code 변경, runtime pass, player comfort, package pass를 주장하지 않는지 확인한다. PR #19, bottle/social, asset batch, new ambience UI가 scope에 들어오지 않았는지 확인한다.
- [ ] 각 Loop의 finding을 “finding → owner → correction → recheck” 형식으로 `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`의 Issue #99 receipt에 기록한다. 사람이 읽는 GDD에는 review ledger를 넣지 않는다.
- [ ] finding이 하나라도 있으면 해당 owner만 교정하고 Loop 1-5 전체를 다시 실행한다. 다음 clean exit가 나올 때까지 반복한다.

  ```text
  new_blocking_findings = 0
  current_product_canon_conflicts = 0
  unsupported_runtime_claims = 0
  out_of_scope_mutations = 0
  ```

## Task 6: 문서/PDF 검증과 GitHub readback을 끝낸다

**파일:** Task 2-5의 변경 파일 전체.

**생산물:** exact-head 검증된 PR candidate.

- [ ] `git diff --check`를 실행한다.
- [ ] Markdown 검사로 모든 current human document에 한국어 heading이 있고, `PROJECT_GDD.md`에는 정확히 8개 top-level GDD section이 있으며, pointer는 기술 owner로 이동하는지 확인한다.
- [ ] stale scan을 실행한다. active-current document에서 `오늘의 마음 선택`, `choose mood`, `Main Menu -> choose`, `Notion Home` current owner, `runtime verified` current direct-entry claim의 material finding은 0이어야 한다. historical receipts와 explicit gap lines은 allowlist로 분리한다.
- [ ] Godot runtime file이 stage에 없는지 확인한다.

  ```powershell
  git diff --cached --name-only
  git diff origin/main...HEAD -- scenes scripts assets tests project.godot
  ```

- [ ] 문서만 변경했으므로 direct-entry runtime test를 PASS라고 부르지 않는다. Baseline Godot headless open은 필요할 때만 environment readiness evidence로 분리해 기록한다.
- [ ] staged diff, PDF hash, PDF page count, rendered PDF page images, exact changed-file list를 읽고 commit한다.
- [ ] branch를 push하고 remote SHA가 local HEAD와 일치하는지 `git ls-remote`로 확인한다.
- [ ] Draft PR #100의 exact head, changed-file list, issue link, title/body, required checks를 readback한다. 타 작업 PR #19는 read-only 상태였음을 다시 기록한다.
- [ ] user approval 전에는 PR을 ready/merge로 바꾸지 않는다.

## Plan self-review

- 기획서 정본화와 Phase 2 runtime 구현을 분리했다.
- user-confirmed decisions은 current GDD로 이동하고, current code conflict는 handoff에서만 다룬다.
- `오늘의 마음` 삭제가 time-of-day UI 또는 asset deletion을 자동 승인하지 않도록 제한했다.
- system cards는 사람의 행동·감정·압박 회피·actual status를 모두 설명한다.
- official research는 latest but stable primary docs로 한정하고, current code reading 및 evidence ceiling과 분리한다.
- 적대적 검토는 한 번의 문구 점검이 아니라 correction 뒤 전체 loop 재실행을 요구한다.
- 코드·테스트·scene·asset을 수정하지 않는다는 파일-level guard와 PDF visual inspection이 포함되어 있다.
