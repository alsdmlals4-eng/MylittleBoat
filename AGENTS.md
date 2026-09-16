# AGENTS.md

Codex and other coding agents should follow this file when working in this repository.

## Project

Project name: `my little boat`
Engine: Godot 4.7 stable
Language: GDScript
Genre: rest-first small-island farming / sea-view healing game (user direction, 2026-09-16)

Current direction overrides the historical voyage plan. The player cares for a small island farm and rests while looking at the sea. Art targets Japanese youth-animation atmosphere; exact character proportions and final assets are not locked. Stop additional boat-forward-motion work. Preserve existing boat implementation, assets, save IDs and evidence as legacy/reference, not as proof of the new island game. New island mechanics require research and a bounded plan before implementation. Project name remains unchanged pending a naming decision.

The current executable still shows the legacy boat diorama. The island farm is NOT_IMPLEMENTED. The existing sea-focused low-UI view may be evaluated for reuse; reuse is not automatic approval of the new camera.

Do not add combat, failure states, competitive systems, ads, payments, realtime/global/public chat, follower/ranking systems, or social pressure mechanics.

Online scope is allowed only for the approved delayed `FriendBottle` / `DriftBottle` subsystem and its required identity, moderation, report, block, consent, and safety operations. Voyage, rest, pet, decoration, album, fishing, and soundscape remain local-first and playable without the backend.

`DriftBottle` public enablement is forbidden until the approved release gate has production server-side moderation, Terms/Community Guidelines, 16+ age gating, in-app report/block, moderation operations, support contact, and verification evidence. See `docs/superpowers/specs/2026-08-24-bondee-diorama-delayed-bottle-design.md`.

## Authority bootstrap

Do not infer current project status from memory or past chats. Resolve current authority in this order:

1. Latest user instruction.
2. This `AGENTS.md` and project engine/data/safety constraints.
3. Current repository human-facing GDD, approved decisions, handoffs, planning/data/code/scenes/resources/tests, and actual runtime evidence.
4. [My Little Boat Base adapter](docs/operations/MY_LITTLE_BOAT_BASE_ADAPTER.json) and only the selected Base contract/routing needed for the task.
5. External references, past conversations, and inference.

### DOMAIN_SPLIT_CANON

- `REPOSITORY_HUMAN_FACING_CANON`: 사람이 읽고 비교·수정하는 Master GDD, Concept, Experience Bible, approved decision, visual lock, asset/provenance, Flow/Storyboard를 책임진다.
- `REPOSITORY_STRUCTURED_CANON`: Markdown·JSON·게임 데이터·GDScript·Scene·Resource·config·tests를 책임진다.
- `REPOSITORY_RUNTIME_TRUTH`: 실제 Godot 실행·test·log·screenshot/video evidence를 책임진다.
- `NOTION_LEGACY_DISCOVERY_ONLY`: 2026-08-28의 마지막 user-authorized migration receipt 뒤 이전 Notion page/database/attachment는 historical archive일 뿐, current truth, approval owner, read/write target, or completion gate가 아니다. 새 Notion read/write/sync를 시작하지 않는다. 예외적으로 사용자가 새 일회성 archive migration을 명시 요청한 경우에만 read-only로 대조하고 repository receipt로 닫는다.
- Google Sheets가 과거 자료로 남아 있더라도 unique 미이관 자료용 `MIGRATION_ONLY_UNTIL_REMOVAL` compatibility source일 뿐 신규 기본 작업공간이나 runtime 증거가 아니다.

Repository 문서 승인이나 정적 이미지가 runtime 구현 성공을 의미하지 않는다. 사람용 결정이 구조화 데이터나 구현 의미를 바꾸면 repository owner에 동기화한 뒤 구현·완료를 주장한다.

현재 `open/draft/ready` PR은 작업 시작 시 실제 GitHub 상태를 조회한다. 다른 workstream의 PR을 명시적 권한 없이 수정·흡수·종료·병합하지 않는다.

### Base adaptation boundary

- Base는 공용 작업 순서·재사용 preflight·증거 분리·review/rollback 원칙을 제공하고, 이 프로젝트의 player meaning, GDD, scene, save, asset, runtime evidence owner를 대체하지 않는다.
- `docs/operations/MY_LITTLE_BOAT_BASE_ADAPTER.json`은 v9.4.4 release payload/evidence/finalization identity, project-local work sequence, adopted/changed/rejected Base rules를 하나의 project adapter로 소유한다.
- `docs/base-reuse-adoption.json`은 Base reusable-module manifest만 소유한다. `enabled`는 실제 project destination, adoption lock, named consumer와 verification이 함께 존재할 때만 허용하며, 후보·미사용 module은 `planned`, `deferred`, 또는 `not_applicable`으로 유지한다.
- Base의 newest main, open Base PR, template, optional editor/test tool은 drift·reuse 조사 입력일 뿐 automatic project adoption, vendor sync, runtime proof, or canon replacement 권한이 아니다.

## Core Game Direction

**2026-09-16 current authority.** Small-island farm care + sea-view rest; Japanese youth-animation art direction. No compulsory daily chores, withering punishment, combat or competitive pressure is newly authorized. Crop loops, movement/camera, progression, tools, and art production must be specified next. The following voyage presentation/controls/loop are historical implementation context, not the current product target. See the opening decision in `docs/design/PROJECT_GDD.md`.

Normal presentation:
- Visible player avatar + pet + boat + sea in a calm 3/4 diorama.
- `Appreciation Camera` shifts focus toward the sea/horizon and hides most nonessential UI.
- Camera mode changes must not alter voyage duration, rewards, or the persistent soundscape.

Core controls:
- Take Photo
- Appreciation Mode / Appreciation Camera
- Speed Control

Core loop:
- Launch directly into the 3/4 boat diorama in title-waiting state with the logo and Start button. Only Start begins voyage progression. The device's local clock automatically chooses dawn, bright, sunset, or night; there is no startup selector and no saved atmosphere preference.
- Rest with the visible avatar and pet. Simply staying is complete play.
- Let low-density scenery pass naturally as active foreground time progresses. It is visual context, not a reward track or a task.
- Optionally use low-pressure interactions, photography, decoration, fishing, ambient discoveries, and delayed bottle letters as each slice is implemented.
- Open `꾸미기` only when desired to change cosmetic player appearance, companion species, or boat decoration.
- Drift for about 5 minutes, leave a personal voyage record if one is created, or continue resting.
- Do not present today’s mood, identity, pet, decor, light, or atmosphere as a requirement before the first boat view. Device-clock time affects visuals only and must not change rewards, progress, or saves.

Supporting direction:
- Boat decoration is self-expression/memory, not stats or optimization.
- Object/pet interaction is optional and must not create chores or repeat-farming pressure.
- `FriendBottle` and `DriftBottle` are delayed correspondence, not instant messaging.
- Stranger bottle communication has no public directory, presence, typing indicator, read receipt, public feed, or popularity system.

Rewards:
- Companion affection.
- Scenery collection.
- Album-style collection.
- Personal boat memories/decor as implemented.

## Autonomous Quality Overlay (2026-08-29)

```text
CURRENT_RESEARCH_AND_IMPLEMENTATION_FEASIBILITY_REQUIRED
MINIMUM_MATERIALLY_DISTINCT_ALTERNATIVES: 3
ACTUAL_PROJECT_BOUNDARY_MAPPING_REQUIRED
RESEARCH_SUMMARY_IS_NOT_IMPLEMENTATION_PROOF
LONG_TERM_EFFICIENCY_AND_COMPLETENESS_FIRST
QUALITY_OVER_RESPONSE_SPEED
TOTAL_LIFECYCLE_COST
NO_UNSUPPORTED_OVERENGINEERING
MINIMUM_NECESSARY_COMPLEXITY
LOW_INTERVENTION_AUTOMATION_AND_LEARNING_LOOP
NEED_DRIVEN_GENERATE_THEN_LOCK
CLAIM_ONLY_ADVERSARIAL_REVIEW_INVALID
MINIMUM_FULL_LOOPS_BEFORE_CLEAN_EXIT: 5
```

### Research and implementation feasibility

For every material design, visual, data, Scene/Resource, backend-safety, UI/UX, production-pipeline, or implementation-structure decision:

1. Re-read the exact repository owner and actual implementation/consumer.
2. Search the current project and adopted Base for an existing solution before building another one.
3. Read fresh official or primary-source documentation and directly relevant professional success/failure cases when the answer may affect feasibility, platform behavior, moderation, rights, safety, cost, or maintenance.
4. Compare at least three materially distinct viable alternatives using `ADOPT / ADAPT / TEST / REJECT`.
5. Map the selected option to actual scenes, nodes, resources, scripts, data/save migration, UI/input states, asset dependencies, platform/performance/safety risks, test seams, rollback, and a bounded Codex package.
6. Classify the result as `FEASIBLE | PARTIAL | BLOCKED_UNVERIFIED`.

A link list, design note, static mockup, or passing unit test is not implementation proof. Code, Scene, runtime, moderation operations, Human UX, and release evidence remain separate ceilings.

### Long-horizon quality and automation

사용자 정의 개선 루프(2026-09-13)는 테스트 반복 자체가 아니다. 유사 장르의 공식 자료·제작 사례를 조사하고, 현재 GDD의 빈틈을 구체화해 기존 시스템에 연결하며, 실행 전 구현/수정 계획을 제시한 뒤 승인 범위의 실제 구현·기계/실행 검증·교정·다음 작업 선정을 이어간다. 아래 5회 적대적 검토는 이 제품 개선 루프의 검증 단계이지 대체물이 아니다. 조사 건수·문서 수·테스트 횟수를 게임 완성 진척으로 보고하지 않는다. 핵심 의미·최종 아트 lock·고위험 작업·Human 선언 경계는 그대로 유지한다.

Prefer the minimum necessary complexity that solves the root cause and lowers total lifecycle cost. Do not choose a quick patch merely because it is faster when it leaves recurring manual work, authority drift, inaccessible recovery, or avoidable technical debt. Also do not create speculative frameworks, abstractions, services, paid dependencies, or future-only data models without a current consumer, test, owner, rollback, and measurable benefit.

Within the already approved scope, continue safe reversible work without routine reapproval:

```text
fresh-read
→ research / compare
→ prepare candidate or bounded implementation package
→ execute safe work
→ test / readback
→ adversarial review
→ correct validated findings
→ regression check
→ record incident / solution / lesson
→ project automation or Base promotion candidate
→ recalculate remaining work
```

Escalate only core player meaning, final visual lock, significant scope/cost, destructive migration/deletion/deployment, permissions/security, or direct canon conflict. Fail closed on unsafe or unverified inputs.

### Need-driven image candidate workflow

2026-09-14 사용자 제작 규칙. 앞으로 배경 제거가 필요한 캐릭터·보트·동반자·구름·섬 등 독립 요소는 이미지 모델로 단색 크로마키 배경 원본을 먼저 생성한 뒤 배경을 제거한다. 대상 색과 겹치지 않는 key 색을 선택하고 원본·프롬프트·제거 설정·RGBA 결과의 provenance와 hash를 연결한다. 실제 alpha, 가장자리 key spill/halo, 내부 색 손실, 상태군 pivot와 consumer 합성을 검사한다. 체크무늬 RGB를 투명 이미지로 취급하지 않는다. 하늘·바다처럼 배경 자체인 불투명 texture는 별도 레이어로 유지한다. 기존 승인 원본을 일괄 재생성하거나 이 지침만으로 final lock을 우회하지 않는다.

When a concrete runtime consumer, planned player-facing surface, product-distribution need, or current Blueprint planning-board purpose is established, do not stop for a routine pre-generation approval question. First read the current visual canon, approved images and mockups, actual consumer, required state family, dimensions, rights/provenance boundary, and reusable approved assets. Then generate exactly one consistent candidate with the host image model and stop for the user to decide `LOCK / REVISE / REJECT`.

```text
GENERATED_CANDIDATE != USER_LOCKED != PROJECT_ASSET_APPROVED != IMPLEMENTED != RUNTIME_VERIFIED
```

A coverage gap alone is not generation authority. Do not automatically chain to another character, screen, variant, or asset family. `LOCK` is still required before canon registration or production promotion, and Blueprint final approval is still required before a new implementation package.

### Evidence-backed adversarial review

Every material retained change requires at least five actual full-scope loops before clean exit. Each loop must re-read the full approved scope and record the exact head/state, actual reads, commands/checks, validated findings, applied correction or explicit blocker, regression/readback evidence, untouched-consumer recheck, better-alternative search, and long-term-fit result.

`검토 완료`, `5회 확인`, or `문제 없음` without those receipts is invalid. A validated finding must be corrected and reverified or remain as an explicit blocker. After five loops, continue until no new valid `MUST_FIX`, regression, authority/consumer drift, acceptance blocker, or stronger in-scope alternative remains.

## Work Style

- Inspect the actual files before editing. Use `rg` or Godot project structure instead of relying on memory.
- State assumptions when the request is ambiguous. Ask before making risky product or architecture decisions.
- Prefer the minimum necessary change that fixes the root cause and improves long-term maintainability, verification, and recovery.
- Match the existing scene, node, script, and naming style.
- Avoid speculative abstractions, large rewrites, or broad cleanup.
- Do not revert, overwrite, or reformat unrelated user changes.
- If the worktree is dirty, understand whether the dirty files are related before editing them.
- Read real error messages and logs before applying a fix.
- For every material design, visual, or implementation decision, re-read the relevant current repository owner and fresh official primary-source documentation when it can affect feasibility, platform behavior, safety, or cost.
- Run the evidence-backed adversarial lifecycle above after a material candidate. Correct only validated findings, then repeat the full scope until verified clean exit.

### Temporary Artifact Hygiene

- 사용자 작업 산출물 정리 방침(2026-09-12): 사용이 끝난 것으로 확인한 임시 산출물은 직접 삭제하지 않고 프로젝트 밖의 날짜별 `MyLittleBoat_삭제대기_YYYYMMDD` 폴더로 모아 링크를 제공한다. 사용자가 직접 삭제한다. 원래 경로·이동 사유·파일 수/용량·이동 전후 해시를 기록하고, 승인 원본·현재 consumer·검증 정본·출처 불명 파일·다른 workstream은 제외한다. 이후 아래 자동 정리 규칙은 이 사용자 방침과 충돌하지 않는 테스트 자체 teardown 등에 한해 적용한다.
- Create temporary files only in an ignored, task-scoped location and remove them as soon as their consumer or verification use is complete.
- A Git-ignored folder is still visible to Godot's importer. Keep temporary rendered rasters, PDF page previews, and build probes outside the project root. Use a narrowly scoped `.gdignore` only when a project-internal temporary folder is unavoidable and has no Godot consumer.
- Every test that writes an isolated `user://test_*` file or directory must remove that exact path during teardown. After a suite, audit and remove only any remaining `user://test_*` artifacts; never delete production saves by pattern.
- Before removing a worktree or local temporary branch, verify its exact path, confirm it is clean and merged into the current target, and preserve every dirty or unmerged worktree for its owner.
- Treat `.godot/imported`, `.godot/shader_cache`, and `*.import` as regenerable local cache. They may be removed after machine verification, but never in place of source assets, approved candidates, canonical assets, runtime evidence, or current project documentation.
- After clearing `.godot/imported`, run `Godot --headless --path . --import` before resource or scene verification. `--editor --quit` exits before import completion and is not a substitute.
- At task closeout, read back temporary artifact and worktree state. Record what was removed and keep the remaining source/provenance and verification boundaries explicit.

## Godot Rules

- Use Godot 4.7 stable.
- Use GDScript unless explicitly requested otherwise.
- Keep scene and node structures simple.
- Use clear node names such as `TakePhotoButton`, `AppreciationButton`, and `AlbumView`.
- Keep UI mobile-friendly first, with PC mouse input where it makes sense.
- Keep core rest/voyage/decor/pet systems local-first; isolate approved bottle-social networking behind dedicated interfaces.
- Do not add combat, stamina, HP, enemies, damage, death, failure conditions, or ranking systems.
- Do not add realtime/global/public social features outside the approved delayed bottle design.
- Do not add paid assets or dependency-heavy plugins without explicit approval.
- Update `README.md` when setup, controls, scenes, or test steps change.

## File Header Comments

For new source files, add a one-line Korean comment at the top explaining the file's role.

GDScript example:

```gdscript
# 항해 화면의 기본 상호작용을 관리한다.
extends Control
```

Skip header comments for generated files, Godot scene files, `.import` files, lockfiles, and simple README placeholders.

## Planning

For small tasks, work directly after reading the relevant files.

For larger tasks that touch multiple scenes, scripts, or gameplay systems, briefly state:
- What will change.
- Which files or scenes are likely involved.
- How the change will be verified.

Create `checklist.md` or `context-notes.md` only for long-running, risky, or multi-session work. Do not create extra process files for small, self-contained changes.

## Verification

If code, scenes, or project settings changed, run the smallest useful Godot check before marking the task complete.

Preferred checks:

```powershell
godot --headless --path . --quit
godot --headless --path . --scene "res://scenes/main_menu.tscn" --quit-after 1
```

Known Windows local fallback in this workspace:

```powershell
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --quit
```

For UI-only or documentation-only changes, explain what was inspected instead of claiming gameplay was tested.

Tests that read `ViewportTexture` must run on a display renderer. A headless contract may explicitly skip only that capture assertion; it must not attempt the unsupported read and report an engine error.

Final replies should include:
- What changed.
- What was verified.
- Any remaining risk or manual Godot check the user should perform.

## Commit Guidance

### Monthly AI work evidence

**2026-09-16 최신 사용자 지시가 아래 버전 증식 규칙을 대체한다.** 기존 월간 작업일지에 날짜별 요약을 누적한다. 미제출 월중 PDF는 같은 파일에 요약 페이지를 추가하고 source receipt와 갱신일을 함께 기록한다. 새 일지나 v번호를 매 작업마다 늘리지 않는다. 교체 전 원본은 복구 가능한 보관 위치에 두며 원래 페이지·해시·출처를 보존한다. 이미 제출한 문서의 정정은 별도 정정 이력을 유지한다. 실제 작업일과 사후 기록일은 계속 분리한다.

2026-09-14 사용자 요청에 따라 블루프린트와 별도로 `my little boat` 이름의 월별 「AI 활용 작업일지·증빙집」 PDF를 만든다. 9월 출력 위치는 `C:/Users/user/Documents/증빙서류/9월 증빙서류`다. `tools/build_ai_work_evidence_pdf.py`는 기존 Git·작업 검증·자산 provenance 기록의 파생 보고서만 만들며 새로운 기획 정본이 아니다. 실제 AI 작업일, Git 기록 시각, 사후 기록 작성일, 캡처일, PDF 발행일을 구분한다. 검증되지 않은 계정·모델·결제·비용 인정·협약 사실은 추정하지 않는다. 입력 원문 발췌와 실제 화면 캡처를 구분하고 부족한 원본은 누락으로 표시한다. 제출용 PDF에 비밀·원본 대화 전체·결제 원본을 자동 수록하지 않는다. 발행 파일은 덮어쓰지 않고 새 버전과 정정 이유를 남긴다. 지정 정산 양식을 대체하거나 자동 제출하지 않는다.

Commit only when one logical change is complete and the repository workflow expects it.

Good commit examples:
- `Improve AGENTS Godot guidance`
- `Add mood selection UI`
- `Fix album back button flow`

Do not mix unrelated gameplay, UI, documentation, and cleanup changes in one commit unless the user explicitly asks for a broad conversion.

## Korean Output

When replying to a Korean user, answer in Korean.

Write new human-facing project documentation in Korean. Keep Godot paths, APIs, status codes, and source identifiers in their exact original spelling where that prevents ambiguity.

Avoid ending Korean prose lines with a colon. Prefer a period, question mark, or exclamation mark. Colons are fine in code, paths, key-value examples, timestamps, and Markdown labels.

## Suggested Scene Structure

- `scenes/main_menu.tscn`
- `scenes/game.tscn`
- `scenes/album.tscn`

## Suggested Script Areas

- `scripts/core/`
- `scripts/ui/`
- `scripts/voyage/`
- `scripts/avatar/`
- `scripts/companion/`
- `scripts/album/`
- future approved social code should live behind a dedicated social/bottle boundary, not inside voyage state.
