# My Little Boat Living GDD + Visual Dashboard Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Rebuild the My Little Boat Notion Home into a Project Living GDD + Visual Dashboard that exposes the game’s identity, explanatory Visual GDD layer, core loop, approved visual style, human-critical data, content meaning, and product-level development reality without mixing in engineering evidence.

**Architecture:** Reuse the existing Human Home, Detail Canon pages/databases, AI Workspace, and GitHub ownership split. Update the Visual Bible as the people-readable visual-style owner, mirror the approved style into repository planning, replace the old Home primary hierarchy with sections 01–08, add one filtered Core System Linked View for browsable human data, and keep PR/SHA/CI/Test/IRG/schema details in AI Workspace/GitHub.

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
- User-supplied example images are layout/information-density/Visual-GDD references only. They are not My Little Boat art canon.
- Any discovered active consumer that contradicts the approved visual/social canon is in scope only when it belongs to `MY_LITTLE_BOAT` and can be corrected without inventing new gameplay.

---

## File / Surface Map

### GitHub files

- Existing spec: `docs/superpowers/specs/2026-08-25-living-gdd-visual-dashboard-design.md`
- This implementation plan: `docs/superpowers/plans/2026-08-25-living-gdd-visual-dashboard.md`
- Modify during implementation: `docs/CONCEPT.md`
- Do **not** modify Godot source, scene, resource, test, backend, or PR #19 files.

### Notion surfaces

- Human Home: `3c41b237-eb1c-8194-8b8e-d88362cafafa` — `마이 리틀 보트 · Home`
- System Record: `3c01b237-eb1c-805f-88f3-f30623b4990b` — `마이 리틀 보트 (My Little Boat)`
- AI Workspace: `3c61b237-eb1c-812f-a9f5-f5a116a98370` — `AI · 작업 현황 · Evidence`
- Visual Bible: `3c11b237-eb1c-81ae-97f3-dc28a0905304` — `02 · 비주얼 바이블`
- Voyage Flow: `3c11b237-eb1c-81c3-8e12-d3f598113c7e` — `03 · UI · 항해 Flow Map`
- Core System Detail: `3c11b237-eb1c-8119-8378-c25d3ebbf658` — `08 · 핵심 시스템 · 상세`
- Asset Library: `3c11b237-eb1c-8120-b7db-d48e11756146` — `04 · 에셋 라이브러리`
- Benchmark Library: `3c11b237-eb1c-8116-9c53-e3662be2e347` — `05 · Reference · Benchmark 도서관`
- Core System Master: `collection://b0b4e81d-2400-43f2-b02b-88f1d3c1cb79`
- Project relation URL for filtering: `https://app.notion.com/p/3c01b237eb1c805f88f3f30623b4990b`

### Known Home child domains that must remain attached

Fresh-fetch the Home before any replacement and preserve **every** returned child `<page>` / `<database>` block. The known primary domains are:

- Direction · Planning: `https://app.notion.com/p/3c51b237eb1c81f2a2e0f4258b15aae3`
- Voyage · Experience · Systems: `https://app.notion.com/p/3c51b237eb1c813699e0fd12478954a2`
- Visual · UX · Assets: `https://app.notion.com/p/3c51b237eb1c810dba71f358c8a91b0c`
- Production · Validation: `https://app.notion.com/p/3c51b237eb1c8178a475e647a4bb5a30`
- Reference · Benchmark: `https://app.notion.com/p/3c51b237eb1c813bbf72ea727541132e`

---

### Task 1: Freeze Fresh Authority and Open the Sync Window

**Surfaces:** repository `main`, PR #19, all Notion targets, System Record, AI Workspace.

**Produces:** fresh baseline + `REPO_UPDATE_REQUIRED` before canon writes.

- [ ] Re-read repository `main`. If it is newer than `4afaef2bcd20a1f4ac468f84583b1192273246c3`, compare the task branch to the new main and explicitly evaluate the delta before any write. Do not force-update or absorb unrelated work automatically.
- [ ] Re-read PR #19. Record only its current state; mutation/absorption by this task must remain `0`.
- [ ] Fetch Home, System Record, AI Workspace, Visual Bible, Flow Map, Core System Detail, Asset Library, and Benchmark Library before writing.
- [ ] Capture all Home child `<page>` / `<database>` blocks for preservation.
- [ ] Update System Record properties to:

```text
Sync State = REPO_UPDATE_REQUIRED
Revision = current Revision + 1
Repo Main SHA = actual current main
Notes = Living GDD + Visual Dashboard 승인 구현 진행 중 · SOFT_STORYBOOK_3D_DIORAMA 승인 방향을 Visual Bible/Home/repository mirror에 동기화 · Human Home을 01–08 Living GDD 구조로 재편 · representative Visual GDD image는 NOT_YET_PRODUCED · PR #19는 독립 workstream / NO ABSORPTION
```

- [ ] Fetch System Record and require exact readback of `REPO_UPDATE_REQUIRED`, actual main SHA, and the current-task note.
- [ ] Add/update an AI Workspace current-task block with:

```text
Current task = Living GDD + Visual Dashboard
Branch = plan/living-gdd-visual-dashboard-20260825
Home target = sections 01–08
Visual direction = SOFT_STORYBOOK_3D_DIORAMA / APPROVED
Representative Visual GDD asset = NOT_YET_PRODUCED
PR #19 = READ_ONLY / NO ABSORPTION
```

- [ ] Fetch AI Workspace and verify the task block exists only on the AI/System side.

---

### Task 2: Revalidate Benchmark Principles Before Canon Projection

**Surfaces:** Benchmark Library plus fresh external source checks.

**Produces:** confirmation that the approved Home/style reasoning still rests on current evidence; no new product decision without approval.

- [ ] Fetch the current Benchmark Library and confirm the existing ADOPT/ADAPT/REJECT logic for Spirit City, Bondee, Kind Words, NAIAD, A Short Hike, and related rest-first references.
- [ ] Fresh-check current official/storefront sources for these three implementation-relevant principles:
  - `Spirit City: Lofi Sessions` — ambience + companion + personal space as product value;
  - `Animal Crossing: Pocket Camp Complete` — relaxed character presence + decorating + fishing/collecting in a small personal place;
  - `Garden Galaxy` — readable stylized/isometric small-space customization.
- [ ] Treat ratings/review counts only as market-interest signals, not causal proof of design success.
- [ ] Record no new Home rule unless the external evidence merely supports the already approved `SOFT_STORYBOOK_3D_DIORAMA` and Living-GDD information hierarchy.
- [ ] If fresh evidence contradicts an approved product decision, stop and surface the conflict instead of silently reversing the user-approved canon.

---

### Task 3: Promote `SOFT_STORYBOOK_3D_DIORAMA` into the Visual Bible

**Surface:** Notion Visual Bible.

**Produces:** one explicit people-readable visual-style owner.

- [ ] Fetch Visual Bible immediately before editing and confirm visible avatar + pet + boat + sea is still current.
- [ ] Insert this section after the existing protection-direction block:

```markdown
## 2026-08-25 · 승인 그림체 정본 · `SOFT_STORYBOOK_3D_DIORAMA`
<callout icon="🎨" color="blue_bg">
	**작은 보트가 손바닥 위 동화 모형처럼 느껴지는 stylized 3D** · 형태는 둥글고 큰 덩어리로 읽히며, 과도한 사실적 PBR보다 부드러운 matte/painterly 재질을 우선합니다. 플레이어·펫·보트의 실루엣과 생활 흔적이 첫인상의 핵심입니다.
</callout>
- **형태:** 둥글고 단순화된 큰 silhouette. 세로 화면에서도 플레이어·펫·장식이 서로 겹쳐 무너지지 않음.
- **재질:** photoreal PBR 과시보다 soft matte / lightly painterly 표현.
- **바다·하늘:** 저~중간 대비, 안정적인 수평선, 넓고 부드러운 반사, 낮은 시각 소음.
- **UI:** 환경 톤과 별개로 텍스트·버튼·선택 상태는 충분한 기능 대비 유지.
- **움직임:** 느리고 bounded/predictable. 빠른 점멸·과한 bob·지속적인 attention call을 피함.
- **애착 중심:** 플레이어·펫·보트가 `내 작은 장소`로 먼저 읽히고 장식은 생활감을 더하되 바다를 가리는 인벤토리 벽이 되지 않음.
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

- [ ] Fetch Visual Bible and require all six evidence-state lines plus the approved style label.
- [ ] Search My Little Boat Notion for conflicting active phrases: `플레이어 몸은 보이지 않음`, `first-person only`, `photorealistic`, `대표 이미지 승인 완료`, `final visual pass`.
- [ ] Correct only active `MY_LITTLE_BOAT` consumers; preserve clearly historical receipts as history.

---

### Task 4: Mirror the Visual Direction into `docs/CONCEPT.md`

**File:** `docs/CONCEPT.md` only.

**Produces:** structured implementation mirror without runtime change.

- [ ] Fetch `docs/CONCEPT.md` and `AGENTS.md` on the task branch. Confirm `AGENTS.md` already protects the visible-avatar 3/4 direction and needs no unrelated edit.
- [ ] Add after the normal-presentation explanation:

````markdown
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
````

- [ ] Commit only the `docs/CONCEPT.md` mirror change with `Mirror approved storybook diorama visual direction`.
- [ ] Fetch `docs/CONCEPT.md` from the task branch and verify style/evidence wording without any runtime PASS claim.

---

### Task 5: Replace the Old Home Primary Hierarchy with Sections 01–04

**Surface:** Human Home.

**Produces:** clean first half of the Living GDD with no duplicate legacy headings.

- [ ] Fetch Home immediately before restructuring and preserve all child page/database blocks.
- [ ] Remove or absorb the old primary headings/blocks that would duplicate the new hierarchy, including legacy versions of `프로젝트 한눈에 보기`, `대표 승인 비주얼`, `전체 게임 Flow`, `핵심 감정`, `AI가 이해한 핵심`, and any repeated core-loop section. Do not delete child domain pages.
- [ ] Create `01 · PROJECT NORTH STAR` as the first major section with:

```text
핵심 판타지 = 작은 3D 보트 디오라마에서 보이는 플레이어와 펫이 함께 쉬고, 꾸미고, 작은 상호작용과 느린 병편지로 사람의 온기를 느끼는 rest-first 힐링 항해 게임
핵심 감정 = 편안함 · 안정감 · 잔잔함 · 애착 · 혼자 있지만 외롭지 않은 느낌
핵심 약속 = 목표는 이기는 것이 아니라 쉬는 것
정상 화면 = visible avatar + pet + personal boat + sea / calm 3/4 diorama
승인 그림체 = SOFT_STORYBOOK_3D_DIORAMA
대표 Visual GDD = NOT_YET_PRODUCED
```

Selling-point cluster:
- 아무것도 하지 않아도 성립하는 5분 휴식;
- 플레이어·펫·보트가 함께 만드는 `내 작은 장소`;
- 꾸미기와 기억은 최적화가 아니라 개인 흔적;
- 사람의 온기는 실시간 SNS가 아니라 느린 병편지.

- [ ] Create `02 · VISUAL GDD · WHAT THE PLAYER SEES` immediately after North Star. Until a separately produced/approved image exists, show `REPRESENTATIVE VISUAL GDD IMAGE = NOT_YET_PRODUCED`, then show the whole-game Mermaid Flow and Resting Sanctuary system diagram directly.
- [ ] Create `03 · HOW THE GAME WORKS` with canonical flow:

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

Also keep the six human stages: `오늘의 마음 / 보트 디오라마 / 보트 생활 / 바다 감상과 발견 / 병편지 / 기억 남기기`, each answering `보는 것 / 선택 / 느끼고 기억할 것`.

- [ ] Create `04 · HOW IT SHOULD LOOK` as a concise projection of Visual Bible covering 3/4 composition, silhouette hierarchy, stable horizon, soft matte/painterly material, environment/UI contrast split, slow motion, decor clutter limit, Appreciation Camera difference, and final-art evidence boundary.
- [ ] Fetch Home and require the first major headings to be exactly `01 → 02 → 03 → 04` with no legacy duplicate top-level sections before or between them.
- [ ] Scan 01–04 for PR/SHA/CI/Test/IRG/schema leakage; expected material finding count = `0`.

---

### Task 6: Add `05 · CORE GAME DATA` from Actual Owners

**Sources:** `scripts/core/game_state.gd`, `scripts/ui/main_menu.gd`, `scripts/decor/boat_decor_catalog.gd`.

- [ ] Re-fetch all three sources from actual current `main` immediately before projecting values.
- [ ] Require current source-backed values:

```text
VOYAGE_SECONDS = 300.0
moods = 평온 / 지침 / 외로움 / 설렘
boat slots = 8
starter decor = lantern / mug / cushion / plant / postcard / pet_cushion
```

If any value changed on current main, use the actual value and record the drift in AI Workspace before Home projection.

- [ ] Add this human-facing table:

| Data | Human-facing value |
| --- | --- |
| 오늘의 마음 | 평온 · 지침 · 외로움 · 설렘 |
| 기본 항해 | 300초 / 약 5분 |
| 기억 축 | 사진 · 풍경 · 로컬 Ambient 편지 · 물고기 · 항해 기록 · 보트 꾸미기 흔적 |
| 꾸미기 슬롯 | 8개 — 선수 좌/우, 중앙 좌/우, 후미 좌/우, 난간 포인트, 펫 자리 |
| Starter Decor | 랜턴 · 컵 · 쿠션 · 작은 화분 · 엽서 · 펫 쿠션 |
| 선택형 활동 | Appreciation Camera · Quiet Fishing · Ambient Discovery · Low-pressure Interaction · 사진 · 병편지 |
| 소셜 보호선 | 느린 FriendBottle/DriftBottle만 승인 범위. 실시간/공개 SNS 압력 없음. core rest는 local-first |

- [ ] Add: `이 표는 사람이 기획 판단에 필요한 현재 핵심값입니다. 실제 구현 여부·테스트 근거·정확한 source path는 GitHub/AI Workspace가 소유합니다.`
- [ ] Fetch Home and compare every number/list to the fresh repository owners. Unknown invented values = `0`.

---

### Task 7: Add `06 · CONTENT & DESIGN`

**Produces:** direct human meaning for approved systems without API/schema detail.

- [ ] Add exactly these ten domains: Avatar, Resting Pet, Personal Boat Space, Decoration, Low-pressure Interaction, Appreciation Camera, Ambient Discovery, Quiet Fishing, Album/Voyage Memory, Delayed Bottle Social.
- [ ] For every domain answer:

```text
플레이어에게 무엇인가?
무엇을 선택할 수 있는가?
왜 이 게임의 감정에 필요한가?
무엇을 하면 이 시스템을 망치는가?
```

- [ ] Preserve these boundaries:

```text
Decoration → 자기표현/기억, not stats/rarity/gacha
Pet → 함께 쉬는 존재, not hunger/cleaning/neglect obligation
Quiet Fishing → 기다림/기억, not failure/economy farming
Delayed Bottle → optional delayed warmth, not realtime chat/popularity pressure
```

- [ ] Fetch Home and cross-check against Concept, Flow, Core System Detail, and the approved bottle spec. Any unapproved system = remove rather than infer.

---

### Task 8: Add `07 · DEVELOPMENT REALITY`

**Produces:** human-understandable product state without engineering dashboard metadata.

- [ ] Recalculate implementation reality from actual current `main` and current PR inventory; never copy a stale Home status block.
- [ ] If main remains `4afaef2...` and PR #19 remains independent/open, use these rows:

| Area | Home status | Human note |
| --- | --- | --- |
| 5분 항해 / 마음 / 항해 기록 | 구현됨 | core session and memory loop exists |
| Appreciation Camera | 구현됨 | sea-focused alternate view exists |
| Quiet Fishing / Ambient Discovery / Album continuity | 구현됨 | optional calm activity and continuity exist |
| RestingSoundscape | 기술 Prototype | generated technical OceanBed, not production wave audio |
| Visible-avatar 3/4 Diorama shell | 기술 Prototype | technical avatar/camera shell; final art and Human comfort unverified |
| Local Boat Decoration / Low-pressure Interaction | 구현됨 | technical slots/interactions exist; final decor art and app-restart persistence remain incomplete |
| Delayed Bottle Social | 설계 확정 · 미구현 | real network/auth/moderation/public social is not on main |
| Final Avatar / Pet / Boat / Sea art | 최종 자산 대기 | representative visual not yet approved |
| Mobile comfort / 5분 emotional validation | Human 검증 대기 | actual device and Human experience not yet observed |

- [ ] If PR #19 merged independently before this step, show `로컬 Social Fake = 기술 Prototype` **only if** that code is on current main; keep real network/moderation as `설계 확정 · 미구현` until integrated.
- [ ] Use only these status labels: `구현됨`, `기술 Prototype`, `설계 확정 · 미구현`, `최종 자산 대기`, `Human 검증 대기`.
- [ ] Scan section 07 for `SHA`, `PR #`, `workflow`, `run #`, `CI`, source paths, test paths, raw IRG, Supabase table/function names. Expected material finding count = `0`.
- [ ] Fetch Home and verify a person can distinguish built / prototype / designed / asset-pending / Human-pending without seeing engineering evidence.

---

### Task 9: Add `08 · DETAIL LIBRARY` and One Curated Linked View

**Linked source:** Core System Master `collection://b0b4e81d-2400-43f2-b02b-88f1d3c1cb79`.

- [ ] Add the five drilldowns with reasons:

```text
Direction · Planning — 방향/의도/결정 근거
Voyage · Experience · Systems — 플레이 흐름·시스템 상세
Visual · UX · Assets — 그림체·UI·Asset 상세
Production · Validation — 제작/검증 상세
Reference · Benchmark — 벤치마크 근거와 ADOPT/ADAPT/REJECT
```

- [ ] Fetch `notion://docs/view-dsl-spec` and Core System data source immediately before linked-view work.
- [ ] Check whether Home already has a view named `MY_LITTLE_BOAT · Core System Canon`. Reuse/update it if present; never create a duplicate.
- [ ] If absent, create exactly one table view:

```text
data_source_id = collection://b0b4e81d-2400-43f2-b02b-88f1d3c1cb79
parent_page_id = 3c41b237-eb1c-8194-8b8e-d88362cafafa
name = MY_LITTLE_BOAT · Core System Canon
type = table
configure = FILTER "Project" = "https://app.notion.com/p/3c01b237eb1c805f88f3f30623b4990b"; SHOW "Name", "Category", "Player Meaning", "Status"; WRAP CELLS true
```

- [ ] Do **not** create an approved-visual gallery: baseline known approved representative My Little Boat visuals = `0`.
- [ ] Fetch Home/view and require only MY_LITTLE_BOAT rows and only `Name / Category / Player Meaning / Status` visible. If project filtering cannot be verified, remove/disable the view rather than showing cross-project data.

---

### Task 10: Reconcile AI Workspace and Preserve Exact Evidence

- [ ] Fetch final Home candidate and confirm exact engineering facts intentionally absent from it.
- [ ] Ensure AI Workspace retains: actual main SHA, current-task branch/PR, workflow/test receipts, IRG, source mappings, schema/IDs, blockers/NOT_RUN, same-goal/open PR inventory, provenance/handoff, exact technical next work.
- [ ] Add a new task receipt:

```text
Home architecture = Project Living GDD + Visual Dashboard
Home sections = 01–08
Visual canon = SOFT_STORYBOOK_3D_DIORAMA / APPROVED
Representative Visual GDD = NOT_YET_PRODUCED
Core System linked view = created/reused/removed with exact verification reason
Human Development Reality = Home summary only; exact evidence remains in AI Workspace/GitHub
```

- [ ] Preserve previous historical receipts; do not rewrite them as current narrative.
- [ ] Fetch AI Workspace and verify it does not duplicate the full Living GDD.

---

### Task 11: Full Consumer Audit and Bounded Corrections

- [ ] Search active My Little Boat visual consumers for: `플레이어 몸은 보이지 않음`, `first-person only`, `photorealistic`, `low-poly`, `대표 이미지 승인`, `final visual pass`.
- [ ] Search Home/AI responsibility consumers for: `PR #`, `current main`, `CI`, `다음 최우선`, `작업 현황`.
- [ ] Search social consumers for: `온라인 편지 공유 금지`, `온라인 금지`, `FriendBottle`, `DriftBottle`, `실시간 채팅`.
- [ ] Correct only active `MY_LITTLE_BOAT` contradictions by `fetch owner → smallest edit → destination fetch → search again`.
- [ ] Do not rewrite historical incident/review receipts that clearly describe superseded state.
- [ ] Re-fetch Home, Visual Bible, Flow Map, Core System Detail, System Record, and AI Workspace before adversarial loops.

---

### Task 12: Run Whole-State Adversarial Review Loops

Run at least five **full-candidate** loops. A correction in any loop requires another whole-state re-attack.

- [ ] **Loop 1 — authority/canon:** Home vs Visual Bible vs Flow vs Core System vs `docs/CONCEPT.md`; approved style vs final-art evidence.
- [ ] **Loop 2 — human/AI boundary:** human-critical data hidden only in AI; engineering metadata leaked into Home; AI Workspace duplicating narrative GDD.
- [ ] **Loop 3 — data drift:** `300 seconds`, `4 moods`, `8 slots`, `6 decor`, social protection, visual-style label. Every Home value must match its owner.
- [ ] **Loop 4 — visual overclaim:** supplied examples not treated as project art; representative visual not claimed to exist; style direction not treated as finished asset; no decorative art substituted for explanatory Visual GDD.
- [ ] **Loop 5 — Development Reality/safety/maintainability:** statuses distinguish built/prototype/designed/asset-pending/Human-pending; Delayed Bottle remains non-realtime and safety-gated; Home is not a database wall; linked view does not leak cross-project/machine fields; PR #19 remains independent.
- [ ] If Loops 1–5 produce any correction, run Loop 6+ until one complete re-attack yields:

```text
new blocking findings = 0
REQUIRED_WORK_REMAINING for pre-merge candidate = 0
PRE_MERGE_CLEAN_REVIEW_EXIT
```

- [ ] Record each loop finding/correction and the final clean loop in AI Workspace, not Human Home.

---

### Task 13: Create Current-Task PR and Verify Exact HEAD

**Expected GitHub files only:**

```text
docs/superpowers/specs/2026-08-25-living-gdd-visual-dashboard-design.md
docs/superpowers/plans/2026-08-25-living-gdd-visual-dashboard.md
docs/CONCEPT.md
```

- [ ] Compare task branch to actual main; Godot/runtime/PR #19 files must be absent.
- [ ] Create PR with exact title: `Refine My Little Boat Home into a Living GDD`.
- [ ] PR body states: Home 01–08 Living GDD; `SOFT_STORYBOOK_3D_DIORAMA`; representative image pending; human Development Reality restored; Core System view filtered to project; no gameplay/runtime/image generation; PR #19 independent.
- [ ] Record exact PR HEAD SHA.
- [ ] Require any GitHub Actions run associated with exact PR HEAD to complete successfully before merge; repository checks do not raise final-art/Human evidence.
- [ ] Require blocking reviews = `0` and unresolved blocking threads = `0`.
- [ ] Re-read PR #19 and confirm mutation/absorption = `0`.

---

### Task 14: Merge, Sync, and Read Back New Main

- [ ] Squash merge only the current-task PR using expected head SHA.
- [ ] Fetch new main and record exact SHA.
- [ ] Fetch merged spec, plan, and `docs/CONCEPT.md` from new main; require all present.
- [ ] Update System Record:

```text
Repo Main SHA = new main SHA
Sync State = SYNCED
Revision = current Revision + 1
Last Synced = current date
Notes = Living GDD + Visual Dashboard 완료 · SOFT_STORYBOOK_3D_DIORAMA 승인 정본 동기화 · Home 01–08 구조 + human Development Reality + filtered Core System projection readback 완료 · representative Visual GDD image remains NOT_YET_PRODUCED · PR #19 independent
```

- [ ] Update AI Workspace merge receipt with current-task PR, exact reviewed HEAD, validation run/result, merge method, new main SHA, review/thread state, and postmerge Home/System/Visual readback.
- [ ] Fetch System Record and AI Workspace; require `Sync State = SYNCED`, `Repo Main SHA = actual new main`, AI current identity = actual new main.

---

### Task 15: Post-Merge Adversarial Completion Gate

- [ ] **Postmerge Loop 1 — drift:** stale branch/main/build status in AI Workspace/System Record.
- [ ] **Postmerge Loop 2 — Home order:** `게임 정체성 → Visual GDD explanation → 핵심 시스템/Flow → visual direction → core data → content meaning → Development Reality → detail library`.
- [ ] **Postmerge Loop 3 — canon/consumer:** old visual rules, blanket-online prohibitions, duplicated/stale core values.
- [ ] **Postmerge Loop 4 — evidence ceiling:** require all remain exactly:

```text
REPRESENTATIVE_VISUAL_GDD_IMAGE = NOT_YET_PRODUCED
FINAL_AVATAR_ART = NOT_INTEGRATED
FINAL_PET_ART = NOT_INTEGRATED
FINAL_BOAT/SEA_ART = NOT_INTEGRATED
HUMAN_VISUAL_COMFORT_VALIDATION = NOT_RUN
HUMAN_MOBILE_COMFORT = NOT_RUN
FIVE_MINUTE_CALM_EMPTY = NOT_RUN
```

- [ ] **Postmerge Loop 5 — remaining work:** require durable Home readback, Visual canon readback, owner-aligned core data, Human Development Reality, preserved AI evidence, project-filtered Core System view or verified removal, current-task PR merged, new main read back, System Record synced, new blocking findings = `0`.
- [ ] If any postmerge correction occurs, rerun the whole postmerge review until one complete re-attack yields zero new blocking findings.
- [ ] Record final AI Workspace receipt only after fresh evidence supports:

```text
REQUIRED_WORK_REMAINING: 0
CLEAN_REVIEW_EXIT
```

---

## Plan Self-Review Result

Spec coverage was checked against the written design. This plan explicitly covers:

- first viewport answers the four required project questions;
- Visual GDD is the first major explanatory layer;
- approved style is visible while final image remains pending;
- old Home primary sections are removed/absorbed so 01–08 is not duplicated;
- whole-game flow and system relationships are directly visible;
- 4 moods / 300 seconds / 8 slots / 6 decor are source-backed;
- human-critical content meaning is directly visible;
- human Development Reality is restored;
- PR/SHA/CI/Test/IRG/schema stay outside Home;
- one filtered Core System Linked View is reused or created without duplicate rows/views;
- no empty approved-visual gallery is created;
- AI Workspace retains exact evidence;
- benchmark principles are freshly revalidated without silently overriding approvals;
- PR #19 remains independent;
- no image is generated;
- no gameplay/runtime file changes;
- minimum five whole-state adversarial loops plus postmerge loops;
- exact-head validation and postmerge readback precede completion.

Placeholder scan: no `TBD`, `TODO`, `implement later`, or unspecified test step is permitted by this plan. Runtime-dependent values are explicitly re-fetched from their owners before projection rather than guessed.
