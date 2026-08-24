# My Little Boat Living GDD + Visual Dashboard Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild the My Little Boat Notion Home into a Project Living GDD + Visual Dashboard that exposes the game’s identity, explanatory Visual GDD layer, core loop, approved visual style, human-critical data, content meaning, and product-level development reality without mixing in engineering evidence.

**Architecture:** Reuse the existing Human Home, Detail Canon pages/databases, AI Workspace, and GitHub ownership split. Update the Visual Bible as the people-readable visual-style owner, mirror the approved style into repository planning, project a curated subset to Home, add one filtered Core System Linked View for browsable human data, and keep PR/SHA/CI/Test/IRG/schema details in the AI Workspace/GitHub.

**Tech Stack:** Notion pages + linked database views, GitHub Markdown planning mirror, existing Godot 4.7 repository evidence, Base `DOMAIN_SPLIT_CANON`, IRG/readback validation.

**Spec:** `docs/superpowers/specs/2026-08-25-living-gdd-visual-dashboard-design.md`

## Global Constraints

- Baseline repository `main`: `4afaef2bcd20a1f4ac468f84583b1192273246c3`.
- Current-task branch: `plan/living-gdd-visual-dashboard-20260825`.
- Concurrent PR #19 `Implement deterministic local social fake backend` is `READ_ONLY / NO ABSORPTION`.
- Approved visual direction: `SOFT_STORYBOOK_3D_DIORAMA`.
- `VISUAL_STYLE_DIRECTION = APPROVED` does **not** imply `REPRESENTATIVE_VISUAL_GDD_IMAGE = APPROVED`.
- Do not generate or edit any image in this task.
- Do not add gameplay rules, balance changes, Godot scripts, scenes, resources, save behavior, backend code, or dependencies.
- Do not create a new HTML dashboard or active Google Sheets workspace.
- Human Home must expose product understanding; AI Workspace must retain exact engineering/evidence detail.
- Human Home must not expose commit SHA, PR number, workflow/run ID, test path, raw IRG ledger, schema/field IDs, backend table/function names, or source mapping.
- Public `DriftBottle` remains blocked until production moderation, Terms/Community Guidelines, 16+ gating, report/block, support, and release verification are proven.
- Human mobile comfort, final visual quality, real wave listening quality, and five-minute CALM/EMPTY validation remain `NOT_RUN` until directly observed.
- Every Notion write follows `baseline fetch → smallest bounded write → exact destination fetch → stale/conflict search`.
- If a Notion database query is blocked by plan/tool quota, do not upgrade or retry blindly; use page fetch/search and existing known canonical records instead.
- Any discovered active consumer that contradicts the approved visual/social canon is in scope only when it belongs to `MY_LITTLE_BOAT` and can be corrected without inventing new gameplay.

---

## File / Surface Map

### GitHub files

- Existing spec: `docs/superpowers/specs/2026-08-25-living-gdd-visual-dashboard-design.md`
- Create in this plan step: `docs/superpowers/plans/2026-08-25-living-gdd-visual-dashboard.md`
- Modify during implementation: `docs/CONCEPT.md`
- Do **not** modify Godot source, scene, resource, test, backend, or PR #19 files.

### Notion surfaces

- Human Home: `3c41b237-eb1c-8194-8b8e-d88362cafafa` — `마이 리틀 보트 · Home`
- System Record: `3c01b237-eb1c-805f-88f3-f30623b4990b` — `마이 리틀 보트 (My Little Boat)`
- AI Workspace: `3c61b237-eb1c-812f-a9f5-f5a116a98370` — `AI · 작업 현황 · Evidence`
- Visual Bible: `3c11b237-eb1c-81ae-97f3-dc28a0905304` — `02 · 비주얼 바이블`
- Voyage Flow: `3c11b237-eb1c-81c3-8e12-d3f598113c7e` — `03 · UI · 항해 Flow Map`
- Core System Detail: `3c11b237-eb1c-8119-8378-c25d3ebbf658` — `08 · 핵심 시스템 · 상세`
- Asset Library page: `3c11b237-eb1c-8120-b7db-d48e11756146` — `04 · 에셋 라이브러리`
- Benchmark Library: `3c11b237-eb1c-8116-9c53-e3662be2e347` — `05 · Reference · Benchmark 도서관`
- Core System Master data source: `collection://b0b4e81d-2400-43f2-b02b-88f1d3c1cb79`
- Project System Record relation URL used by Core System filter: `https://app.notion.com/p/3c01b237eb1c805f88f3f30623b4990b`

### Human Home child-domain pages to preserve

Fresh-fetch the Home before any full replacement and preserve every returned `<page>` / `<database>` block. The known primary children are:

- Direction · Planning: `https://app.notion.com/p/3c51b237eb1c81f2a2e0f4258b15aae3`
- Voyage · Experience · Systems: `https://app.notion.com/p/3c51b237eb1c813699e0fd12478954a2`
- Visual · UX · Assets: `https://app.notion.com/p/3c51b237eb1c810dba71f358c8a91b0c`
- Production · Validation: `https://app.notion.com/p/3c51b237eb1c8178a475e647a4bb5a30`
- Reference · Benchmark: `https://app.notion.com/p/3c51b237eb1c813bbf72ea727541132e`

---

### Task 1: Freeze Fresh Authority and Mark the Notion Sync Window

**Files / surfaces:**
- Read: repository `main`
- Read: PR #19
- Read: all Notion targets listed above
- Modify: System Record properties only
- Modify: AI Workspace operational note only

**Interfaces:**
- Consumes: approved spec and current `main`.
- Produces: a fresh baseline receipt and an explicit `REPO_UPDATE_REQUIRED` sync state before human-canon writes begin.

- [ ] **Step 1: Re-read repository `main` and verify the fork point**

Use GitHub branch fetch for `main`.

Expected before implementation: `main` is still `4afaef2bcd20a1f4ac468f84583b1192273246c3` or a newer commit that is explicitly evaluated before continuing.

If `main` changed, compare the current-task branch to new `main`; do not force-update or absorb unrelated work automatically.

- [ ] **Step 2: Re-read PR #19**

Verify:

```text
state = open or independently resolved by its own workstream
this task mutation = 0
this task absorption = 0
```

If PR #19 has merged independently, recalculate only the human `Development Reality` social row from new `main`; do not copy/rebase its implementation into this branch.

- [ ] **Step 3: Fetch every Notion target before writing**

Fetch Home, System Record, AI Workspace, Visual Bible, Flow Map, Core System Detail, Asset Library, and Benchmark Library.

Record exact current page content and child-page/database blocks needed for preservation.

- [ ] **Step 4: Set System Record to pre-sync state**

Update properties:

```text
Sync State = REPO_UPDATE_REQUIRED
Revision = current Revision + 1
Notes = Living GDD + Visual Dashboard 승인 구현 진행 중 · SOFT_STORYBOOK_3D_DIORAMA 승인 방향을 Visual Bible/Home/repository mirror에 동기화 · Human Home을 01–08 Living GDD 구조로 재편 · representative Visual GDD image는 NOT_YET_PRODUCED · PR #19는 독립 workstream / NO ABSORPTION
```

Keep `Repo Main SHA` at the actual current `main` until this task merges.

- [ ] **Step 5: Read back System Record**

Expected:

```text
Sync State = REPO_UPDATE_REQUIRED
Repo Main SHA = actual current main
Notes contains Living GDD + Visual Dashboard
```

Do not proceed if readback does not match.

- [ ] **Step 6: Add an AI Workspace current-task receipt**

Add/update a concise operations block containing:

```text
Current task = Living GDD + Visual Dashboard
Branch = plan/living-gdd-visual-dashboard-20260825
Human Home target = 01–08 Living GDD structure
Visual direction = SOFT_STORYBOOK_3D_DIORAMA / APPROVED
Representative Visual GDD asset = NOT_YET_PRODUCED
PR #19 = READ_ONLY / NO ABSORPTION
```

- [ ] **Step 7: Fetch AI Workspace and verify the receipt**

Expected: exact branch, approved style, pending representative visual, and PR #19 boundary are visible in AI Workspace only.

---

### Task 2: Promote `SOFT_STORYBOOK_3D_DIORAMA` into the People-Readable Visual Canon

**Files / surfaces:**
- Modify: Notion Visual Bible `3c11b237-eb1c-81ae-97f3-dc28a0905304`
- Read: Home, Asset Library

**Interfaces:**
- Consumes: approved visual direction from the spec.
- Produces: one explicit people-readable visual-style owner that Home and repository mirror can project.

- [ ] **Step 1: Fetch the Visual Bible immediately before editing**

Confirm the current `보호 방향` still requires visible avatar + pet + boat + sea and does not contain a newer contradictory approved style.

- [ ] **Step 2: Insert the approved style section after `보호 방향`**

Add this section without deleting existing compatible rules:

```markdown
## 2026-08-25 · 승인 그림체 정본 · `SOFT_STORYBOOK_3D_DIORAMA`
<callout icon="🎨" color="blue_bg">
	**작은 보트가 손바닥 위 동화 모형처럼 느껴지는 stylized 3D** · 형태는 둥글고 큰 덩어리로 읽히며, 과도한 사실적 PBR보다 부드러운 matte/painterly 재질을 우선합니다. 플레이어·펫·보트의 실루엣과 생활 흔적이 첫인상의 핵심입니다.
</callout>
- **형태:** 둥글고 단순화된 큰 silhouette. 세로 화면에서도 플레이어·펫·장식이 서로 겹쳐 무너지지 않음.
- **재질:** photoreal PBR 과시보다 soft matte / lightly painterly 표현.
- **바다·하늘:** 저~중간 대비, 안정적인 수평선, 넓고 부드러운 반사, 낮은 시각 소음.
- **UI:** 환경 톤과 별개로 텍스트·버튼·선택 상태는 충분한 기능 대비를 유지.
- **움직임:** 느리고 bounded/predictable. 빠른 점멸·과한 bob·지속적인 attention call을 피함.
- **애착 중심:** 플레이어·펫·보트가 `내 작은 장소`로 먼저 읽히고, 장식은 생활감을 더하되 바다를 가리는 인벤토리 벽이 되지 않음.
- **Appreciation Camera:** 같은 세계의 조용한 alternate view이며 바다·수평선 집중을 우선함.
- **복제 금지:** Bondee, Animal Crossing, Spirit City, Garden Galaxy 등 특정 작품의 캐릭터 비율·UI·브랜딩·trade dress를 복제하지 않음.

### 승인과 자산 상태를 분리합니다
- `VISUAL_STYLE_DIRECTION = APPROVED`
- `REPRESENTATIVE_VISUAL_GDD_IMAGE = NOT_YET_PRODUCED`
- `FINAL_AVATAR_ART = NOT_INTEGRATED`
- `FINAL_PET_ART = NOT_INTEGRATED`
- `FINAL_BOAT/SEA_ART = NOT_INTEGRATED`
- `HUMAN_VISUAL_COMFORT_VALIDATION = NOT_RUN`
```

- [ ] **Step 3: Fetch the Visual Bible**

Verify all of the following coexist:

```text
visible avatar + pet + boat + sea
SOFT_STORYBOOK_3D_DIORAMA
soft matte / painterly
stable horizon
UI readability
REPRESENTATIVE_VISUAL_GDD_IMAGE = NOT_YET_PRODUCED
```

- [ ] **Step 4: Search My Little Boat Notion for contradictory active visual phrases**

Search for:

```text
플레이어 몸은 보이지 않음
first-person only
photorealistic
대표 이미지 승인 완료
final visual pass
```

Only correct active `MY_LITTLE_BOAT` consumers that conflict with the approved canon. Historical review receipts may retain old wording when clearly labeled as history.

---

### Task 3: Mirror the Approved Visual Direction into Repository Planning

**Files:**
- Modify: `docs/CONCEPT.md`
- Read: `AGENTS.md`
- Test/readback: GitHub file fetch on current-task branch

**Interfaces:**
- Consumes: Notion Visual Bible destination readback from Task 2.
- Produces: a structured implementation mirror for future coding agents without changing runtime behavior.

- [ ] **Step 1: Fetch current `docs/CONCEPT.md` and `AGENTS.md` from the current-task branch**

Confirm `AGENTS.md` already states visible-avatar 3/4 diorama and does not need an unrelated rewrite.

- [ ] **Step 2: Add a concise `Visual Style Mirror` section to `docs/CONCEPT.md`**

Insert after the normal-presentation explanation:

```markdown
## Visual Style Mirror

The people-readable visual canon is owned by the Notion Visual Bible. The current approved direction is `SOFT_STORYBOOK_3D_DIORAMA`.

Implementation-facing summary:

- rounded, simplified, large-form stylized 3D silhouettes;
- soft matte / lightly painterly materials rather than photoreal PBR emphasis;
- stable horizon and low-to-medium environmental contrast;
- visible avatar + resting pet + personal boat + sea readable together in the normal 3/4 camera;
- readable functional contrast for text, buttons, and selection state;
- slow, bounded, predictable motion;
- decoration adds lived-in attachment without hiding the sea;
- Appreciation Camera remains the quieter sea/horizon-focused alternate view;
- do not reproduce identifiable Bondee / Animal Crossing / Spirit City / Garden Galaxy proportions, UI, branding, or trade dress.

Evidence boundary:

```text
VISUAL_STYLE_DIRECTION = APPROVED
REPRESENTATIVE_VISUAL_GDD_IMAGE = NOT_YET_PRODUCED
FINAL_AVATAR_ART = NOT_INTEGRATED
FINAL_PET_ART = NOT_INTEGRATED
FINAL_BOAT/SEA_ART = NOT_INTEGRATED
HUMAN_VISUAL_COMFORT_VALIDATION = NOT_RUN
```
```

- [ ] **Step 3: Commit only this repository mirror change**

Commit message:

```text
Mirror approved storybook diorama visual direction
```

- [ ] **Step 4: Fetch `docs/CONCEPT.md` from the branch**

Expected: style mirror exists, evidence boundary is intact, and no runtime/implementation claim was added.

---

### Task 4: Rebuild Home Sections 01–04 — North Star, Visual GDD, Flow, Visual Rules

**Surfaces:**
- Modify: Human Home
- Read: Visual Bible, Flow Map, Core System Detail

**Interfaces:**
- Consumes: Visual Bible style owner and current approved flow.
- Produces: first half of the Living GDD hierarchy.

- [ ] **Step 1: Fetch Home immediately before restructuring**

Capture every child `<page>` and `<database>` block. Prefer targeted `update_content` for section replacement. If a full `replace_content` is necessary, include every existing child block exactly so no child page/database is deleted or moved unintentionally.

- [ ] **Step 2: Make `01 · PROJECT NORTH STAR` the first major section**

The first viewport must directly contain:

```text
핵심 판타지 = 본디에서 원리만 참고한 작은 3D 보트 디오라마에서 보이는 플레이어와 펫이 함께 쉬고, 꾸미고, 작은 상호작용과 느린 병편지로 사람의 온기를 느끼는 rest-first 힐링 항해 게임
핵심 감정 = 편안함 · 안정감 · 잔잔함 · 애착 · 혼자 있지만 외롭지 않은 느낌
핵심 약속 = 목표는 이기는 것이 아니라 쉬는 것
정상 화면 = visible avatar + pet + personal boat + sea / calm 3/4 diorama
승인 그림체 = SOFT_STORYBOOK_3D_DIORAMA
대표 Visual GDD = NOT_YET_PRODUCED
```

Also include a compact selling-point cluster:

- 아무것도 하지 않아도 성립하는 5분 휴식;
- 플레이어·펫·보트가 함께 만드는 `내 작은 장소`;
- 꾸미기와 기억은 최적화가 아니라 개인 흔적;
- 사람의 온기는 실시간 SNS가 아니라 느린 병편지.

- [ ] **Step 3: Make `02 · VISUAL GDD · WHAT THE PLAYER SEES` the next section**

Until a representative image is separately generated and approved, show:

```text
REPRESENTATIVE VISUAL GDD IMAGE = NOT_YET_PRODUCED
```

Then directly display the explanatory Mermaid whole-game Flow and Resting Sanctuary system diagram. Keep the section explicit that these diagrams explain the intended game structure and do not prove every node is implemented.

- [ ] **Step 4: Make `03 · HOW THE GAME WORKS` the whole-game player flow section**

Use this canonical flow text:

```text
오늘의 마음 선택
→ 3/4 보트 디오라마
→ 그냥 머물기
↔ 보트 꾸미기 / 작은 상호작용
↔ Appreciation Camera
↔ 조용한 낚시 / Ambient Discovery
↔ 선택형 FriendBottle / DriftBottle
→ 항해 기록 / 앨범 / 보트 흔적
→ 계속 머물기 또는 다음 항해
```

Keep the current six-stage human table concept:

```text
오늘의 마음 / 보트 디오라마 / 보트 생활 / 바다 감상과 발견 / 병편지 / 기억 남기기
```

Each row answers `보는 것 / 선택 / 느끼고 기억할 것`.

- [ ] **Step 5: Make `04 · HOW IT SHOULD LOOK` a concise Home projection of Visual Bible**

Show these human-readable rules directly:

- 3/4 diorama composition;
- avatar/pet/boat silhouette hierarchy;
- stable horizon and quiet sea readability;
- soft matte / lightly painterly material direction;
- low-to-medium environment contrast + stronger UI functional contrast;
- slow/bounded motion;
- decor clutter limit;
- Appreciation Camera difference;
- final-art evidence boundary.

Do not reproduce the entire Visual Bible.

- [ ] **Step 6: Fetch Home and verify 01–04 ordering**

Expected order begins exactly:

```text
01 · PROJECT NORTH STAR
02 · VISUAL GDD · WHAT THE PLAYER SEES
03 · HOW THE GAME WORKS
04 · HOW IT SHOULD LOOK
```

Verify no PR/SHA/CI/Test metadata appears in these sections.

---

### Task 5: Add Home Section 05 — Core Game Data from Actual Owners

**Surfaces / files:**
- Modify: Human Home
- Read: `scripts/core/game_state.gd`, `scripts/ui/main_menu.gd`, `scripts/decor/boat_decor_catalog.gd`, current Concept mirror

**Interfaces:**
- Consumes: repository runtime/structured facts.
- Produces: compact human decision data with no fake precision and no schema leakage.

- [ ] **Step 1: Re-fetch the three source files from current `main`**

Verify the values still are:

```text
VOYAGE_SECONDS = 300.0
moods = 평온 / 지침 / 외로움 / 설렘
boat slots = 8
starter decor = lantern / mug / cushion / plant / postcard / pet_cushion
```

If current `main` differs, use actual values and record the drift in AI Workspace before Home projection.

- [ ] **Step 2: Add `05 · CORE GAME DATA` with a compact source-backed table**

Required rows:

| Data | Human-facing value |
| --- | --- |
| 오늘의 마음 | 평온 · 지침 · 외로움 · 설렘 |
| 기본 항해 | 300초 / 약 5분 |
| 기억 축 | 사진 · 풍경 · 로컬 Ambient 편지 · 물고기 · 항해 기록 · 보트 꾸미기 흔적 |
| 꾸미기 슬롯 | 8개 — 선수 좌/우, 중앙 좌/우, 후미 좌/우, 난간 포인트, 펫 자리 |
| Starter Decor | 랜턴 · 컵 · 쿠션 · 작은 화분 · 엽서 · 펫 쿠션 |
| 선택형 활동 | Appreciation Camera · Quiet Fishing · Ambient Discovery · Low-pressure Interaction · 사진 · 병편지 |
| 소셜 보호선 | 느린 FriendBottle/DriftBottle만 승인 범위. 실시간/공개 SNS 압력 없음. core rest는 local-first |

- [ ] **Step 3: Add a note separating stable product rules from runtime evidence**

Use:

```text
이 표는 사람이 기획 판단에 필요한 현재 핵심값입니다. 실제 구현 여부·테스트 근거·정확한 source path는 GitHub/AI Workspace가 소유합니다.
```

- [ ] **Step 4: Fetch Home and verify the values**

Expected values must match the freshly fetched repository owners. No unknown number may be introduced.

---

### Task 6: Add Home Section 06 — Content & Design Meaning

**Surfaces:**
- Modify: Human Home
- Read: existing Detail Canon pages

**Interfaces:**
- Consumes: approved project systems only.
- Produces: people-readable system meaning without API/schema detail.

- [ ] **Step 1: Add `06 · CONTENT & DESIGN`**

Create concise cards/table rows for exactly these domains:

1. Avatar
2. Resting Pet
3. Personal Boat Space
4. Decoration
5. Low-pressure Interaction
6. Appreciation Camera
7. Ambient Discovery
8. Quiet Fishing
9. Album / Voyage Memory
10. Delayed Bottle Social

- [ ] **Step 2: Make every domain answer the same four questions**

For each domain provide:

```text
플레이어에게 무엇인가?
무엇을 선택할 수 있는가?
왜 이 게임의 감정에 필요한가?
무엇을 하면 이 시스템을 망치는가?
```

Examples that must remain true:

```text
Decoration → 자기표현/기억, not stats/rarity/gacha
Pet → 함께 쉬는 존재, not hunger/cleaning/neglect obligation
Quiet Fishing → 기다림/기억, not failure/economy farming
Delayed Bottle → optional delayed warmth, not realtime chat/popularity pressure
```

- [ ] **Step 3: Fetch Home and verify no new system was invented**

Cross-check against Concept, Flow, Core System Detail, and approved bottle spec. Any domain without existing approval is removed rather than inferred.

---

### Task 7: Add Home Section 07 — Human Development Reality

**Surfaces:**
- Modify: Human Home
- Read: current `main`, current PR inventory, AI Workspace

**Interfaces:**
- Consumes: implementation evidence, but exposes only product-level status.
- Produces: a human-understandable reality table that does not become an engineering dashboard.

- [ ] **Step 1: Recalculate current implementation reality immediately before writing**

Do not copy old Home status. Inspect current `main` and current PR state.

Baseline expected rows if main remains `4afaef2...` and PR #19 remains open:

| Area | Home status | Human note |
| --- | --- | --- |
| 5분 항해 / 마음 / 항해 기록 | 구현됨 | core session and memory loop exists |
| Appreciation Camera | 구현됨 | sea-focused alternate view exists |
| Quiet Fishing / Ambient Discovery / Album continuity | 구현됨 | optional calm activity and continuity exist |
| RestingSoundscape | 기술 Prototype | generated technical OceanBed, not production wave audio |
| Visible-avatar 3/4 Diorama shell | 기술 Prototype | technical avatar/camera shell, final art and Human comfort not verified |
| Local Boat Decoration / Low-pressure Interaction | 구현됨 | technical slots/interactions exist; final decor art and app-restart persistence remain incomplete |
| Delayed Bottle Social | 설계 확정 · 미구현 | real network/auth/moderation/public social not on main; fake backend work in another workstream does not become Home evidence until merged and recalculated |
| Final Avatar / Pet / Boat / Sea art | 최종 자산 대기 | representative visual not yet approved |
| Mobile comfort / 5분 emotional validation | Human 검증 대기 | actual device and Human experience not yet observed |

If PR #19 merged before this task reaches Step 1, use a human row such as `로컬 Social Fake = 기술 Prototype` only if that implementation is on current `main`; real network/moderation remains `설계 확정 · 미구현` until actually integrated.

- [ ] **Step 2: Add `07 · DEVELOPMENT REALITY` using only allowed status language**

Allowed labels:

```text
구현됨
기술 Prototype
설계 확정 · 미구현
최종 자산 대기
Human 검증 대기
```

- [ ] **Step 3: Scan the section for prohibited engineering metadata**

The section must contain zero instances of:

```text
SHA
PR #
workflow
run #
CI
*.gd path
test file
IRG ledger
Supabase table/function name
```

- [ ] **Step 4: Fetch Home and verify a human can distinguish built / prototype / designed / pending / unvalidated**

Do not claim `PASS` for player comfort, final art, or social usability.

---

### Task 8: Add Home Section 08 and One Curated Core-System Linked View

**Surfaces:**
- Modify: Human Home
- Create/update: one linked view from Core System Master
- Read: View DSL documentation and Core System data source schema

**Interfaces:**
- Consumes: Detail Canon ownership and Core System Master relation.
- Produces: meaningful drilldown plus one non-duplicated browsable people-facing data projection.

- [ ] **Step 1: Add `08 · DETAIL LIBRARY` with the five primary domains**

Show the five existing detail destinations with a one-line reason to open each:

```text
Direction · Planning — 방향/의도/결정 근거
Voyage · Experience · Systems — 플레이 흐름·시스템 상세
Visual · UX · Assets — 그림체·UI·Asset 상세
Production · Validation — 제작/검증 상세
Reference · Benchmark — 벤치마크 근거와 ADOPT/ADAPT/REJECT
```

The Home content above this section must remain sufficient without opening them.

- [ ] **Step 2: Fetch `notion://docs/view-dsl-spec` and Core System data source**

Confirm relation filtering and visible property names before creating a view.

- [ ] **Step 3: Check whether Home already contains a linked Core System view for this project**

If one already exists, update/reuse it. Do not create a duplicate.

Desired view name:

```text
MY_LITTLE_BOAT · Core System Canon
```

- [ ] **Step 4: Create the linked view only if absent**

Use:

```text
data_source_id = collection://b0b4e81d-2400-43f2-b02b-88f1d3c1cb79
parent_page_id = 3c41b237-eb1c-8194-8b8e-d88362cafafa
type = table
name = MY_LITTLE_BOAT · Core System Canon
configure = FILTER "Project" = "https://app.notion.com/p/3c01b237eb1c805f88f3f30623b4990b"; SHOW "Name", "Category", "Player Meaning", "Status"; WRAP CELLS true
```

This linked view may be appended after section 08. It is a drilldown projection, not a replacement for the direct Home summaries.

- [ ] **Step 5: Do not create an Approved Visual gallery in this task**

Reason:

```text
MY_LITTLE_BOAT approved representative visual assets = 0 known at baseline
```

An empty gallery would imply a visual deliverable exists when it does not.

- [ ] **Step 6: Fetch Home and inspect the linked view**

Verify:

```text
only MY_LITTLE_BOAT rows
visible fields = Name / Category / Player Meaning / Status
no schema IDs / Source SHA / Source Path / machine fields shown
```

If the filter cannot be verified, remove or disable the view rather than showing cross-project data.

---

### Task 9: Reconcile AI Workspace with the New Human/AI Boundary

**Surfaces:**
- Modify: AI Workspace
- Read: Human Home

**Interfaces:**
- Consumes: final Home candidate.
- Produces: exact operational/evidence surface without becoming a duplicate GDD.

- [ ] **Step 1: Fetch Human Home and list all engineering facts intentionally absent from it**

Required AI-side retained categories:

```text
exact main SHA
current-task branch / PR
workflow/test evidence
IRG layer status
source mappings
schema/IDs
blockers / NOT_RUN
same-goal/open PR inventory
provenance / handoff
exact technical next work
```

- [ ] **Step 2: Update AI Workspace current-task section**

Record:

```text
Home architecture = Project Living GDD + Visual Dashboard
Home sections = 01–08
Visual canon = SOFT_STORYBOOK_3D_DIORAMA / APPROVED
Representative Visual GDD = NOT_YET_PRODUCED
Core System linked view = created/reused/omitted with exact reason
Human Development Reality = Home summary only; exact evidence remains here
```

- [ ] **Step 3: Remove no historical receipts**

Keep prior merge/adversarial receipts as history. Add the new task receipt instead of rewriting old evidence.

- [ ] **Step 4: Fetch AI Workspace**

Verify exact evidence remains accessible and there is no second copy of the full Living GDD narrative.

---

### Task 10: Full Consumer Audit and Bounded Canon Corrections

**Surfaces:**
- Search/fetch Notion workspace for My Little Boat consumers
- Read repository planning mirror

**Interfaces:**
- Consumes: final Home/Visual candidate.
- Produces: no active known consumer contradicting the approved style or Home boundary in audited scope.

- [ ] **Step 1: Search active My Little Boat visual consumers**

Search terms:

```text
플레이어 몸은 보이지 않음
first-person only
photorealistic
low-poly
대표 이미지 승인
final visual pass
```

- [ ] **Step 2: Search active Home/AI responsibility consumers**

Search terms:

```text
PR #
current main
CI
다음 최우선
작업 현황
```

For Home, operational metadata is a violation unless it appears only inside explicit historical/evidence-limit explanation. For AI/System pages, it is expected.

- [ ] **Step 3: Search active online/social consumers**

Search terms:

```text
온라인 편지 공유 금지
온라인 금지
FriendBottle
DriftBottle
실시간 채팅
```

Keep the current rule: delayed bottle is the only approved online social exception; realtime/global/public pressure remains forbidden.

- [ ] **Step 4: Correct only active `MY_LITTLE_BOAT` contradictions**

For every correction:

```text
fetch exact owner
smallest edit
fetch destination
search again
```

Do not rewrite historical incident/review receipts that clearly describe old state.

- [ ] **Step 5: Re-fetch Home, Visual Bible, Flow Map, Core System Detail, System Record, AI Workspace**

Verify semantic alignment before adversarial loops.

---

### Task 11: Run Minimum Five Whole-State Adversarial Review Loops

**Surfaces:**
- Human Home
- Visual Bible
- Flow Map
- Core System Detail / Core System linked view
- Asset Library
- Benchmark Library
- AI Workspace
- System Record
- GitHub branch + PR #19 boundary

**Interfaces:**
- Consumes: full pre-merge candidate.
- Produces: `PRE_MERGE_CLEAN_REVIEW_EXIT` only after a full re-attack returns no new blocking finding.

- [ ] **Loop 1: Authority / canon conflict attack**

Recheck:

```text
Home vs Visual Bible
Home vs Flow
Home vs Core System
Home vs docs/CONCEPT.md
approved style vs final-art evidence
```

Correct any conflict, then restart a whole-state loop count from the corrected state as necessary.

- [ ] **Loop 2: Human / AI responsibility attack**

Try to find:

```text
human-critical data hidden only in AI
PR/SHA/CI/Test/schema leaked into Home
AI Workspace duplicating the full narrative GDD
```

- [ ] **Loop 3: Data duplication / drift attack**

Check:

```text
300 seconds
4 moods
8 slots
6 decor items
social protection rule
visual-style label
```

Every duplicated small Home value must have a clear owner and match it. Large datasets must stay linked rather than copied.

- [ ] **Loop 4: Visual overclaim / reference-image attack**

Verify:

```text
user example images are not treated as project art canon
no representative visual is claimed to exist
SOFT_STORYBOOK_3D_DIORAMA is a direction, not a finished asset
no unrelated decorative concept art substitutes for Visual GDD
```

- [ ] **Loop 5: Development Reality / safety / maintainability attack**

Verify:

```text
built vs technical prototype vs designed vs final-asset pending vs Human pending are distinguishable
Delayed Bottle remains non-realtime and safety-gated
Home remains readable instead of becoming a database wall
linked view does not leak cross-project or machine fields
PR #19 remains independent
```

- [ ] **Loop 6+ if any correction occurred in Loops 1–5**

After every correction, re-attack the whole candidate. Stop only when one full loop produces:

```text
new blocking findings = 0
REQUIRED_WORK_REMAINING for pre-merge candidate = 0
PRE_MERGE_CLEAN_REVIEW_EXIT
```

- [ ] **Record the loop receipt in AI Workspace**

Record each finding, correction, and final clean loop. Do not put this review ledger on Human Home.

---

### Task 12: Create Current-Task PR and Verify Exact HEAD

**Files:**
- Spec
- Plan
- `docs/CONCEPT.md`

**Interfaces:**
- Consumes: pre-merge clean Notion state and current-task branch.
- Produces: one isolated PR containing only durable repository planning/mirror changes.

- [ ] **Step 1: Compare branch to `main`**

Expected repository scope:

```text
docs/superpowers/specs/2026-08-25-living-gdd-visual-dashboard-design.md
docs/superpowers/plans/2026-08-25-living-gdd-visual-dashboard.md
docs/CONCEPT.md
```

No Godot/runtime/PR #19 file may appear.

- [ ] **Step 2: Create the current-task PR**

Suggested title:

```text
Refine My Little Boat Home into a Living GDD
```

PR body must state:

```text
Home = Living GDD + Visual Dashboard
Visual style = SOFT_STORYBOOK_3D_DIORAMA
Representative image = NOT_YET_PRODUCED
Human Development Reality restored without engineering metadata
Core System linked view filtered to MY_LITTLE_BOAT
No gameplay/runtime/image generation change
PR #19 = independent / no absorption
```

- [ ] **Step 3: Record exact PR HEAD SHA**

Do not use branch name as verification evidence after this point.

- [ ] **Step 4: Wait for the exact-head GitHub Actions run**

If the repository starts `Godot 4.7 validation`, require the run associated with exact PR HEAD to complete successfully before merge.

This repository validation does not raise final-art or Human-experience evidence.

- [ ] **Step 5: Check review submissions and unresolved review threads**

Required before merge:

```text
blocking reviews = 0
unresolved blocking threads = 0
```

- [ ] **Step 6: Re-read PR #19**

Confirm this task did not modify, close, merge, rebase, or absorb it.

---

### Task 13: Merge Current-Task PR and Perform Post-Merge Readback

**Surfaces:**
- GitHub `main`
- System Record
- AI Workspace
- Human Home
- Visual Bible
- Core System linked view

**Interfaces:**
- Consumes: exact-head green PR.
- Produces: synced new `main` + Notion durable readback.

- [ ] **Step 1: Squash merge the current-task PR using expected head SHA**

Do not merge PR #19 as part of this action.

- [ ] **Step 2: Fetch new `main`**

Record exact new main SHA.

- [ ] **Step 3: Fetch the merged spec, plan, and `docs/CONCEPT.md` from new `main`**

Verify all three are present and the visual evidence boundary survived merge.

- [ ] **Step 4: Update System Record after new-main readback**

Set:

```text
Repo Main SHA = new main SHA
Sync State = SYNCED
Revision = current Revision + 1
Last Synced = current date
Notes = Living GDD + Visual Dashboard 완료 · SOFT_STORYBOOK_3D_DIORAMA 승인 정본 동기화 · Home 01–08 구조 + human Development Reality + filtered Core System projection readback 완료 · representative Visual GDD image remains NOT_YET_PRODUCED · PR #19 independent
```

- [ ] **Step 5: Update AI Workspace merge receipt**

Record:

```text
current-task PR
exact reviewed HEAD
validation run/result
merge method
new main SHA
review/thread state
postmerge Home/System/Visual readback state
remaining Human evidence = NOT_RUN
```

- [ ] **Step 6: Fetch System Record and AI Workspace**

Expected:

```text
System Record Sync State = SYNCED
Repo Main SHA = actual new main
AI Workspace current identity = actual new main
```

---

### Task 14: Post-Merge Adversarial Review and Completion Gate

**Surfaces:** all Home/Detail/AI/System/GitHub owners.

**Interfaces:**
- Consumes: merged/synced state.
- Produces: final `CLEAN_REVIEW_EXIT` or an explicit correction loop.

- [ ] **Postmerge Loop 1: Drift attack**

Check for stale branch/main/build status in AI Workspace and System Record.

- [ ] **Postmerge Loop 2: Human Home attack**

Verify first-scroll order:

```text
게임 정체성
→ Visual GDD explanation
→ 핵심 시스템 / Flow
→ visual direction
→ core data
→ content meaning
→ Development Reality
→ detail library
```

- [ ] **Postmerge Loop 3: Canon / consumer attack**

Re-search active My Little Boat pages for old visual or blanket-online prohibitions and for duplicated/stale core values.

- [ ] **Postmerge Loop 4: Evidence-ceiling attack**

Verify none of these were accidentally upgraded:

```text
REPRESENTATIVE_VISUAL_GDD_IMAGE = NOT_YET_PRODUCED
FINAL_AVATAR_ART = NOT_INTEGRATED
FINAL_PET_ART = NOT_INTEGRATED
FINAL_BOAT/SEA_ART = NOT_INTEGRATED
HUMAN_VISUAL_COMFORT_VALIDATION = NOT_RUN
HUMAN_MOBILE_COMFORT = NOT_RUN
FIVE_MINUTE_CALM_EMPTY = NOT_RUN
```

- [ ] **Postmerge Loop 5: Remaining-work recalculation**

Completion for this contract requires:

```text
Living GDD Home restructure = durable readback PASS
Visual style canon = durable readback PASS
Core human data = owner-aligned PASS
Human Development Reality = PASS
AI exact evidence = preserved PASS
Core System linked view = project-filtered PASS or removed if verification failed
current-task PR = merged
new main = read back
System Record = SYNCED
new blocking findings = 0
```

If any postmerge correction is made, rerun the whole postmerge review until one full re-attack yields zero new blocking findings.

- [ ] **Record final completion receipt in AI Workspace**

Final state wording:

```text
REQUIRED_WORK_REMAINING: 0
CLEAN_REVIEW_EXIT
```

Only use those words after fresh destination and new-main evidence supports them.

---

## Plan Self-Review Checklist

Before execution, verify this plan covers the full spec:

- [ ] first viewport answers the four required project questions;
- [ ] Visual GDD is the first major explanatory visual layer;
- [ ] approved style is visible and final image remains pending;
- [ ] whole-game flow and system relationships are directly visible;
- [ ] 4 moods / 300 seconds / 8 slots / 6 decor are source-backed;
- [ ] human-critical content meaning is directly visible;
- [ ] human Development Reality is restored;
- [ ] PR/SHA/CI/Test/IRG/schema remain outside Home;
- [ ] one useful filtered Core System Linked View is reused or created without duplication;
- [ ] no empty approved-visual gallery is created;
- [ ] AI Workspace retains exact evidence;
- [ ] PR #19 remains independent;
- [ ] no image is generated;
- [ ] no gameplay/runtime file changes;
- [ ] minimum five whole-state adversarial loops plus postmerge loops;
- [ ] exact-head validation and postmerge readback precede completion.
