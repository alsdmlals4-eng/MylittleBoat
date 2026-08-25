# Handpainted Storybook 3D Diorama Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Promote `HANDPAINTED_STORYBOOK_3D_DIORAMA` as My Little Boat's detailed visual-style canon across human-facing Notion and repository mirrors, record comparison B as a user-preferred reference without accidentally canonizing its generated character/pet/UI, and leave a bounded first-production-slice gate for later visual implementation.

**Architecture:** Keep the existing `SOFT_STORYBOOK_3D_DIORAMA` as the broad parent philosophy and refine only the style-detail layer. Human-facing visual meaning lives in the Notion Visual Bible/Home/Visual domain; exact branch/PR/generation/evidence details stay in AI Workspace/System Record; GitHub mirrors the approved visual contract in planning Markdown. No gameplay, scene, resource, shader, model, texture, UI-navigation, backend, or dependency mutation is part of this rollout.

**Tech Stack:** Notion human-facing pages + AI Workspace/System Record, GitHub Markdown canon, Godot 4.7 mobile-oriented repository evidence, Base Human Home / Image Approval / IRG contracts.

**Spec:** `docs/superpowers/specs/2026-08-25-handpainted-storybook-3d-diorama-design.md`

## Global Constraints

- Baseline repository `main`: `a60f3a71ce7cb03f46aa3e20da5bbb96b83cfc95`; re-read latest `main` before the first write and reconcile if it moved.
- Current-task branch: `plan/handpainted-storybook-style-20260825`.
- Concurrent PR #19 `Implement deterministic local social fake backend` is `READ_ONLY / NO ABSORPTION`.
- Broad parent visual philosophy remains `SOFT_STORYBOOK_3D_DIORAMA`.
- Detailed current visual-style canon becomes `HANDPAINTED_STORYBOOK_3D_DIORAMA`.
- Comparison B is `USER_PREFERRED_REFERENCE`, not project-asset approval, final character canon, final pet canon, or runtime integration.
- The selected direction is B+ hybrid: current 3D boat/camera/decor/interaction/runtime structure is preserved; full 2D conversion is explicitly out of scope.
- Pixel studies remain alternatives only: `DIORAMA_PIXEL = ALTERNATIVE / NOT_SELECTED`; `HD2D_COZY_PIXEL = ALTERNATIVE / NOT_SELECTED`.
- Final player identity, gender/age/lore, hairstyle, clothing, pet species, boat model, UI layout, typeface, palette values, texture resolution, shader implementation, and production asset pipeline remain intentionally undecided.
- No new image generation or image editing occurs in this implementation plan.
- Do not promote the previously generated comparison PNGs into approved project assets during this plan.
- Do not add paid assets, paid APIs, runtime generative AI, or dependency-heavy rendering plugins.
- Human Home must not expose raw commit SHA, PR number, workflow/run ID, prompt, generation ID, file path, hash, schema/field ID, or raw IRG ledger.
- AI Workspace may retain exact branch/PR/evidence/generation metadata required for traceability.
- `APPROVED_REPRESENTATIVE_VISUAL_GDD = NOT_YET_PRODUCED` remains the human-facing evidence ceiling until a later visual candidate is separately generated, reviewed, and approved.
- Generated-but-unapproved comparison/candidate images must not be described as final Visual PASS.
- Human mobile visual comfort, 30-second/5-minute viewing, motion feel, performance of the future style slice, and final-art quality remain `NOT_RUN` until directly observed.
- Every Notion write follows `baseline fetch -> smallest bounded write -> exact destination fetch -> stale/conflict search`.
- Any Notion database query blocked by workspace/tool usage limit is not retried blindly and does not trigger a paid upgrade.
- Do not rewrite historical specs/plans merely because they contain the older `SOFT_STORYBOOK_3D_DIORAMA` terminology; historical records remain historical unless they are active current-canon consumers.

---

## Surface / File Map

| Surface | Responsibility in this rollout | Mutation |
|---|---|---|
| Notion `02 · 비주얼 바이블` (`3c11b237-eb1c-81ae-97f3-dc28a0905304`) | People-readable visual-style owner | Bounded update |
| Notion `마이 리틀 보트 · Home` (`3c41b237-eb1c-8194-8b8e-d88362cafafa`) | Living GDD projection of current style + evidence ceiling | Bounded update |
| Notion `03 · Visual · UX · Assets` (`3c51b237-eb1c-810d-ba71-f358c8a91b0c`) | Human drilldown for B reference meaning and next production slice | Bounded update |
| Notion `04 · 에셋 라이브러리` (`3c11b237-eb1c-8120-b7db-d48e11756146`) | Approved/reference asset inventory | Read only in this task; do not add binary-less pseudo-asset row |
| Notion `AI · 작업 현황 · Evidence` (`3c61b237-eb1c-812f-a9f5-f5a116a98370`) | Exact current-task evidence + generation/reference metadata | Bounded update |
| Notion System Record (`3c01b237-eb1c-805f-88f3-f30623b4990b`) | Repo main SHA / Sync State | Properties update |
| `docs/CONCEPT.md` | Repository implementation-facing visual-style mirror | Modify |
| `docs/RESTING_EXPERIENCE_BIBLE.md` | Repository visual acceptance/protection mirror | Modify only visual-style section |
| This design spec | Durable approved design | Already created; no semantic rewrite unless contradiction found |
| This implementation plan | Execution contract | Create now |

---

### Task 1: Fresh Authority and Concurrent-Work Gate

**Files / surfaces:**
- Read: GitHub `main`
- Read: PR #19
- Read: current-task branch compare
- Read: Notion Home / Visual Bible / Visual domain / AI Workspace / System Record

**Produces:** A fresh baseline receipt before any human-facing mutation.

- [ ] **Step 1: Re-read GitHub `main`.**

Expected: exact latest main SHA is recorded. If it differs from plan baseline `a60f3a71...`, compare changed files before continuing.

- [ ] **Step 2: Re-read open PR inventory.**

Expected: PR #19 is still an independent workstream unless GitHub state proves otherwise. Do not edit, rebase, merge, close, or copy its branch content.

- [ ] **Step 3: Compare `main` against `plan/handpainted-storybook-style-20260825`.**

Expected before implementation writes: only approved spec/plan files are ahead; no gameplay/runtime files.

- [ ] **Step 4: Fetch the five Notion owners.**

Fetch exact destination contents for Home, Visual Bible, Visual/UX/Assets, AI Workspace, and System Record before mutation.

- [ ] **Step 5: Record IRG baseline in AI Workspace only.**

Use the exact current task name `Handpainted Storybook 3D Diorama Canon Rollout` and record:

```text
VISUAL_DIRECTION_USER_APPROVED = YES
WRITTEN_SPEC_USER_APPROVED = YES
NOTION_CANON_SYNC = NOT_RUN
REPOSITORY_MIRROR_SYNC = NOT_RUN
APPROVED_REPRESENTATIVE_VISUAL_GDD = NOT_YET_PRODUCED
PRODUCTION_VISUAL_SLICE = NOT_RUN
HUMAN_VISUAL_VALIDATION = NOT_RUN
PR #19 = READ_ONLY / NO_ABSORPTION
```

- [ ] **Step 6: Lower System Record sync state before cross-domain writes.**

Set `Sync State = REPO_UPDATE_REQUIRED` and increment Revision only according to the current System Record convention. Do not mark `SYNCED` until merge/new-main/readback is complete.

- [ ] **Step 7: Exact readback.**

Verify AI Workspace baseline receipt and System Record `REPO_UPDATE_REQUIRED` are durably stored.

---

### Task 2: Promote the Detailed Visual Canon in the Visual Bible

**Surface:** Notion `02 · 비주얼 바이블`

**Consumes:** Approved spec sections 0–18.

**Produces:** People-readable style owner that clearly distinguishes parent philosophy, detailed current canon, B reference, and unresolved production decisions.

- [ ] **Step 1: Preserve the existing broad parent direction.**

Do not delete the existing `SOFT_STORYBOOK_3D_DIORAMA` principles. Reframe them as the parent visual philosophy.

- [ ] **Step 2: Add the current detailed canon directly below the parent direction.**

Required human-facing copy must carry this meaning:

```text
현재 상세 그림체 정본 = HANDPAINTED_STORYBOOK_3D_DIORAMA
3D 구조는 유지하고, 최종 프레임은 glossy CG보다 움직이는 그림책처럼 보이게 한다.
```

- [ ] **Step 3: Add concise Character rules.**

Include at minimum:

```text
실루엣 우선 / 얼굴 디테일 절제 / 머리카락 2~4개 큰 덩어리 / 큰 옷 형태 / 과도한 AI형 유리눈·매끈한 피부·미세 머리카락 금지
```

Do not decide final gender, age, hairstyle, or costume.

- [ ] **Step 4: Add concise Pet rules.**

State that the pet is a quiet companion; species remains undecided; resting poses and low-frequency animation are preferred; mascot-scale head and attention-demanding motion are rejected.

- [ ] **Step 5: Add Boat/Sea/Material/Lighting rules.**

Required meaning:

```text
3D geometry + hand-painted surface authorship
matte-biased materials
painted albedo > PBR micro-detail
stable horizon
broad painted sky/water shapes
low-frequency reflections
soft broad lighting
```

- [ ] **Step 6: Record B comparison status without promoting it.**

Human-facing status:

```text
비교 시안 B = 사용자가 선호한 스타일 Reference
B 이미지의 캐릭터/펫/UI/보트 세부 = 정본 아님
```

- [ ] **Step 7: Preserve evidence ceiling.**

Use explicit states:

```text
VISUAL_STYLE_DIRECTION = APPROVED
DETAILED_VISUAL_STYLE_CANON = HANDPAINTED_STORYBOOK_3D_DIORAMA
APPROVED_REPRESENTATIVE_VISUAL_GDD = NOT_YET_PRODUCED
FINAL_AVATAR_ART = NOT_INTEGRATED
FINAL_PET_ART = NOT_INTEGRATED
FINAL_BOAT_SEA_ART = NOT_INTEGRATED
HUMAN_VISUAL_COMFORT_VALIDATION = NOT_RUN
```

- [ ] **Step 8: Exact destination readback.**

Verify the Visual Bible does not imply full 2D conversion or asset completion.

---

### Task 3: Update the Human Home Without Turning It Into an Art Log

**Surface:** Notion `마이 리틀 보트 · Home`

**Produces:** Living GDD reflects the refined style while preserving the current 01–08 hierarchy and human/AI boundary.

- [ ] **Step 1: Fetch Home immediately before edit.**

Preserve current 01–08 hierarchy, Mermaid Flow/System diagrams, Core Data, Development Reality, Detail Library, child pages, and linked Core System view.

- [ ] **Step 2: Replace only the style projection in `01 · PROJECT NORTH STAR`.**

Use the current detailed style name `HANDPAINTED_STORYBOOK_3D_DIORAMA`, with one short explanation that it is a 3D moving-storybook treatment.

- [ ] **Step 3: Clarify the parent relationship in `04 · HOW IT SHOULD LOOK`.**

Home should explain that the older soft-storybook direction remains the broad philosophy and the handpainted style is the current detailed production direction.

- [ ] **Step 4: Correct representative-image wording.**

Do not say no visual experiments ever existed. Use this evidence-safe wording:

```text
승인된 대표 Visual GDD = 아직 없음.
기존 생성 후보와 비교 시안은 방향 검토용 Reference이며 프로젝트 승인 자산이 아니다.
```

- [ ] **Step 5: Keep engineering metadata out.**

After write, search Home content for:

```text
PR #
SHA
workflow
run #
IRG
.gd
Supabase
gen_id
prompt
file_
```

Expected: zero material engineering/generation metadata matches in Home narrative.

- [ ] **Step 6: Exact destination readback.**

Verify `PROJECT NORTH STAR -> VISUAL GDD -> HOW THE GAME WORKS -> HOW IT SHOULD LOOK -> CORE DATA -> CONTENT -> DEVELOPMENT REALITY -> DETAIL LIBRARY` remains intact.

---

### Task 4: Record B as a Human Reference in Visual / UX / Assets

**Surface:** Notion `03 · Visual · UX · Assets`

**Produces:** Human-accessible reference meaning without creating a fake approved asset.

- [ ] **Step 1: Fetch current Visual/UX/Assets page.**

Preserve its existing child pages and projection rules.

- [ ] **Step 2: Add a compact `Style Reference Decision · B -> B+` section.**

Required content:

```text
B 손그림 동화책 2D SD = USER_PREFERRED_REFERENCE
B+ HANDPAINTED_STORYBOOK_3D_DIORAMA = SELECTED DIRECTION
```

Explain that B contributes warmth, hand-painted surface language, reduced CG gloss, restrained face treatment, and character/pet/boat emotional relationship.

- [ ] **Step 3: Explicitly list non-canon details.**

State that B does not determine player gender/age/hair/clothes, pet species, exact boat, UI, typeface, or palette.

- [ ] **Step 4: Record pixel alternatives as fallback references.**

```text
DIORAMA_PIXEL = ALTERNATIVE / NOT_SELECTED
HD2D_COZY_PIXEL = ALTERNATIVE / NOT_SELECTED
```

Revisit only if B+ production validation fails cost/performance/authorship goals or the user explicitly reopens pixel direction.

- [ ] **Step 5: Do not create an Asset Library row in this task.**

Reason: the B PNG is a conversation-generated reference, not an approved project asset, and the current connector path does not provide a verified durable local-binary upload route for this artifact. Do not create a binary-less pseudo-asset just to make the database look complete.

- [ ] **Step 6: Exact destination readback.**

Verify reference status is human-readable and does not imply runtime integration.

---

### Task 5: Mirror the Detailed Canon in `docs/CONCEPT.md`

**File:** `docs/CONCEPT.md`

**Produces:** Repository implementation-facing mirror of the current detailed visual style.

- [ ] **Step 1: Fetch current branch version of `docs/CONCEPT.md`.**

Use the exact blob SHA for the update.

- [ ] **Step 2: Replace the old `Visual Style Mirror` wording with parent + detailed-canon hierarchy.**

Required structure:

```text
SOFT_STORYBOOK_3D_DIORAMA = broad parent visual philosophy
HANDPAINTED_STORYBOOK_3D_DIORAMA = current detailed visual-style canon
```

- [ ] **Step 3: Add implementation-facing anti-AI-look principles.**

Keep concise:

```text
silhouette before face
large authored masses
minimal face detail at gameplay distance
matte / hand-painted albedo
controlled irregularity
sea/horizon remains higher priority than character beauty
```

- [ ] **Step 4: Preserve evidence boundary.**

Update to:

```text
VISUAL_STYLE_DIRECTION = APPROVED
DETAILED_VISUAL_STYLE_CANON = HANDPAINTED_STORYBOOK_3D_DIORAMA
APPROVED_REPRESENTATIVE_VISUAL_GDD = NOT_YET_PRODUCED
FINAL_AVATAR_ART = NOT_INTEGRATED
FINAL_PET_ART = NOT_INTEGRATED
FINAL_BOAT/SEA_ART = NOT_INTEGRATED
HUMAN_VISUAL_COMFORT_VALIDATION = NOT_RUN
```

- [ ] **Step 5: Commit this file separately.**

Commit message:

```text
Mirror handpainted storybook visual canon
```

- [ ] **Step 6: Fetch branch file after commit.**

Verify exact text and no unrelated gameplay change.

---

### Task 6: Extend `RESTING_EXPERIENCE_BIBLE.md` Visual Acceptance Contract

**File:** `docs/RESTING_EXPERIENCE_BIBLE.md`

**Produces:** Runtime/asset implementers get the new style constraints without changing gameplay rules.

- [ ] **Step 1: Fetch latest branch version and locate `## 5. 바다·디오라마 비주얼 정본`.**

Do not restructure unrelated Audio/Pet/Interaction sections.

- [ ] **Step 2: Add a subsection named `### 상세 그림체 정본 · HANDPAINTED_STORYBOOK_3D_DIORAMA`.**

Include these exact categories:

```text
Character
Pet
Boat / Props
Sea / Sky
Materials
Lighting
Motion
Evidence Gate
```

- [ ] **Step 3: State implementation preservation.**

Explicitly protect normal 3/4 diorama camera, Appreciation Camera, BoatSpace, slot-zone decor, low-pressure interaction, shared avatar/pet/boat relationship, mobile portrait presentation, and local-first core.

- [ ] **Step 4: Add the first production validation slice boundary.**

The bible should state that the first proof is limited to:

```text
1 neutral test player
1 temporary resting-pet test treatment without species canonization
existing boat material pass
sea/sky color treatment
1 small decor cluster
normal + Appreciation camera comparison
```

Do not instruct broad asset replacement.

- [ ] **Step 5: Add evidence states for the future slice.**

```text
HANDPAINTED_3D_RUNTIME_SLICE = NOT_RUN
MOBILE_30S_VISUAL_REVIEW = NOT_RUN
MOBILE_5M_VISUAL_REVIEW = NOT_RUN
HANDPAINTED_MOTION_REVIEW = NOT_RUN
HANDPAINTED_PERFORMANCE_REVIEW = NOT_RUN
HUMAN_STYLE_APPROVAL = NOT_RUN
```

- [ ] **Step 6: Commit this file separately.**

Commit message:

```text
Add handpainted visual acceptance contract
```

- [ ] **Step 7: Fetch after commit and verify no combat/social/economy semantics changed.**

---

### Task 7: Preserve Exact Reference / Generation Evidence in AI Workspace

**Surface:** `AI · 작업 현황 · Evidence`

**Produces:** Machine-facing traceability without polluting Home.

- [ ] **Step 1: Update current-task identity.**

Record:

```text
Current task = Handpainted Storybook 3D Diorama Canon Rollout
Branch = plan/handpainted-storybook-style-20260825
Baseline main = fresh main SHA
Written spec = USER_APPROVED
```

- [ ] **Step 2: Record comparison lifecycle.**

At minimum:

```text
Comparison B = USER_PREFERRED_REFERENCE
B+ hybrid = APPROVED
B project asset approval = NO
B runtime integration = NO
B final character canon = NO
Pixel C/D = ALTERNATIVE / NOT_SELECTED
```

- [ ] **Step 3: Record generation locator only in AI Workspace if durable/available.**

Known conversation generation locator for comparison B may be recorded as:

```text
gen_id = 26431ea7-f8e2-4df3-8458-e4f365209878
```

Do not put this in Human Home or Visual Bible.

- [ ] **Step 4: Record binary delivery state honestly.**

```text
BINARY_REFERENCE_PROMOTION_TO_ASSET_LIBRARY = NOT_RUN
reason = reference-only + no verified durable local-binary attachment path in current connector workflow
```

- [ ] **Step 5: Read back exact AI Workspace destination.**

Verify current-task evidence and older historical receipts remain distinguishable.

---

### Task 8: Active-Consumer / Stale-Term Audit

**Surfaces:** GitHub + Notion active My Little Boat consumers.

**Produces:** No current canon consumer treats the parent style as the detailed current style or treats B as final asset.

- [ ] **Step 1: Search GitHub for `SOFT_STORYBOOK_3D_DIORAMA`.**

Expected behavior:

- `docs/CONCEPT.md` should be updated.
- historical 2026-08-25 Living GDD spec/plan may retain the old terminology as historical context.
- do not rewrite historical evidence simply to remove the phrase.

- [ ] **Step 2: Search GitHub for `HANDPAINTED_STORYBOOK_3D_DIORAMA`.**

Expected current consumers after Tasks 5–6:

- approved handpainted design spec;
- implementation plan;
- `docs/CONCEPT.md`;
- `docs/RESTING_EXPERIENCE_BIBLE.md`.

- [ ] **Step 3: Search Notion for the old/new style terms under My Little Boat.**

Classify every hit as:

```text
ACTIVE_CURRENT_CONSUMER
HISTORICAL_RECORD
REFERENCE_ONLY
```

- [ ] **Step 4: Search for accidental canonization phrases.**

Search:

```text
B 시안 확정 캐릭터
강아지 확정
최종 UI 확정
풀 2D
픽셀 확정
```

Any active current-canon hit unsupported by the approved spec is a finding and must be corrected before PR.

- [ ] **Step 5: Re-read Home / Visual Bible / Visual domain after any correction.**

No active current consumer may exceed the evidence ceiling.

---

### Task 9: Pre-Merge Adversarial Review — Minimum Five Full Loops

**Scope:** Entire final candidate state, not one lens per loop.

Each loop rechecks Home, Visual Bible, Visual domain, repository mirrors, AI/System state, PR #19 boundary, stale consumer search, and evidence ceiling.

- [ ] **Loop 1: Authority / semantic conflict attack.**

Attack parent-vs-detailed style hierarchy, full-2D ambiguity, and current 3D architecture protection.

- [ ] **Loop 2: Accidental asset/character canon attack.**

Attack B image for accidental player gender/age/hair/clothes, pet species, exact UI, exact boat, palette, or final-asset promotion.

- [ ] **Loop 3: AI-look / art-direction completeness attack.**

Check whether character/pet/boat/sea/material/lighting/motion rules are concrete enough to review future candidates consistently.

- [ ] **Loop 4: Human/AI boundary and evidence-overclaim attack.**

Home must remain people-readable; AI generation/PR/SHA metadata stays out; future runtime/Human evidence remains `NOT_RUN`.

- [ ] **Loop 5: Cost / implementation reality / long-term fit attack.**

Check zero-extra-cost default, mobile renderer compatibility, bounded first slice, and no premature mass asset conversion.

- [ ] **Correction rule.**

If any loop finds a valid blocking or material `SHOULD_FIX`, correct it and run another full loop. Do not count a correction-only check as a clean exit.

- [ ] **Clean exit rule.**

Proceed only when a full corrected-state loop finds zero new blocking findings. Record the loop table in AI Workspace.

---

### Task 10: Pre-PR Repository Scope Verification

**Files:** Current-task branch vs latest `main`.

- [ ] **Step 1: Compare branch to latest `main`.**

Allowed current-task files:

```text
docs/superpowers/specs/2026-08-25-handpainted-storybook-3d-diorama-design.md
docs/superpowers/plans/2026-08-25-handpainted-storybook-3d-diorama.md
docs/CONCEPT.md
docs/RESTING_EXPERIENCE_BIBLE.md
```

No `.gd`, `.tscn`, `.tres`, texture, model, shader, dependency, social, or backend file is allowed in this PR.

- [ ] **Step 2: Re-read PR #19.**

Expected: no mutation/absorption from this task.

- [ ] **Step 3: Recalculate IRG pre-merge.**

Required status:

```text
Notion visual canon write/readback = PASS
Repository mirror on branch = IMPLEMENTED
Representative approved Visual GDD = NOT_YET_PRODUCED
Production runtime slice = NOT_RUN
Human visual QA = NOT_RUN
GitHub current-task integration = NOT_YET_MERGED
```

---

### Task 11: PR / Exact-Head Validation / Merge

**Produces:** Durable repository integration only after exact-head evidence.

- [ ] **Step 1: Create a current-task PR to `main`.**

Suggested title:

```text
Refine My Little Boat visual canon to handpainted storybook 3D
```

PR body must explicitly say:

- parent style retained;
- B+ selected;
- B image remains reference-only;
- no gameplay/runtime/image generation in PR;
- production slice still NOT_RUN;
- PR #19 independent.

- [ ] **Step 2: Capture exact PR HEAD SHA.**

- [ ] **Step 3: List changed files.**

Expected: only four allowed Markdown files from Task 10.

- [ ] **Step 4: Check reviews / unresolved threads.**

Expected: no blocking unresolved thread.

- [ ] **Step 5: Wait for exact-head repository validation.**

Use actual workflow returned by GitHub; do not assume check names. If `Godot 4.7 validation` runs, require completed/success on the exact PR HEAD.

- [ ] **Step 6: Inspect workflow jobs if available.**

For a docs-only change, existing headless import/contracts/smokes may still run. Report actual steps; do not claim Human visual validation.

- [ ] **Step 7: Merge with normal repository-supported squash flow.**

Use `expected_head_sha` when supported. No force, bypass, or direct-main rewrite.

- [ ] **Step 8: Fetch new `main`.**

Record exact new main SHA.

---

### Task 12: Post-Merge Sync and Full-State Reattack

**Surfaces:** System Record, AI Workspace, Human Home, Visual Bible, Visual domain, GitHub main.

- [ ] **Step 1: Promote System Record to `SYNCED`.**

Update `Repo Main SHA` to the actual new main and set `Sync State = SYNCED` only after GitHub main readback.

- [ ] **Step 2: Update AI Workspace current task to `MERGED / SYNCED`.**

Record exact PR, exact reviewed HEAD, validation run, new main, and remaining evidence ceiling.

- [ ] **Step 3: Fetch Home, Visual Bible, Visual domain, System Record, AI Workspace, `docs/CONCEPT.md`, and `docs/RESTING_EXPERIENCE_BIBLE.md` fresh.**

- [ ] **Step 4: Postmerge Loop 1 — identity / sync drift attack.**

Find stale branch/main/PR/task status in AI/System surfaces.

- [ ] **Step 5: Postmerge Loop 2 — visual canon consistency attack.**

Ensure current active human/repository consumers agree on parent/detailed style hierarchy.

- [ ] **Step 6: Postmerge Loop 3 — accidental B canon attack.**

Ensure B remains preferred reference only.

- [ ] **Step 7: Postmerge Loop 4 — evidence ceiling attack.**

Ensure no one claims approved representative image, final art, runtime slice, mobile QA, 30s/5m Human validation, motion validation, or performance validation.

- [ ] **Step 8: Postmerge Loop 5 — remaining-work / PR #19 / cost attack.**

Recalculate required work for this approved canon-rollout contract only; PR #19 remains independent; additional paid cost remains zero.

- [ ] **Step 9: If a finding is corrected, run one additional full-state loop.**

Final state may be `CLEAN_REVIEW_EXIT` only after a corrected-state loop yields zero new blocking findings.

---

### Task 13: Close This Rollout and Open the Next Visual Gate Without Implementing It

**Produces:** Clear handoff to the later production visual slice.

- [ ] **Step 1: Record the next visual work item in AI Workspace, not Home.**

Exact next hypothesis:

```text
FIRST_PRODUCTION_VISUAL_SLICE
= neutral handpainted 3D test player
+ temporary resting-pet style treatment without species canonization
+ existing boat material pass
+ sea/sky color treatment
+ one decor cluster
+ normal/Appreciation camera comparison
```

- [ ] **Step 2: Keep its state honest.**

```text
FIRST_PRODUCTION_VISUAL_SLICE = NOT_RUN
IMAGE_BRIEF = NOT_APPROVED_FOR_NEXT_GENERATION
RUNTIME_ASSET_IMPLEMENTATION = NOT_RUN
```

- [ ] **Step 3: Do not auto-generate the next image.**

A later visual-candidate generation requires its own text brief and a separate explicit user message under the image conversation approval gate.

- [ ] **Step 4: Final completion report for this contract.**

Report only what is proven:

```text
visual canon rollout / Notion / repository merge / sync
```

Do not report:

```text
final character art success
final pet art success
runtime handpainted style success
Human visual comfort success
```

unless those later tasks have separately executed and produced evidence.
