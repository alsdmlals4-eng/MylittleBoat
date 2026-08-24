# My Little Boat Project Living GDD + Visual Dashboard Design

Status: **USER-APPROVED DESIGN / SPEC REVIEW GATE**  
Date: 2026-08-25  
Project: `my little boat` / `MY_LITTLE_BOAT`  
Baseline project `main`: `4afaef2bcd20a1f4ac468f84583b1192273246c3`  
Current-task branch: `plan/living-gdd-visual-dashboard-20260825`  
Concurrent PR boundary: PR #19 `Implement deterministic local social fake backend` remains **READ_ONLY / NO ABSORPTION** for this task.

## 0. Decision summary

The project Home will be refined from a general human learning page into a **Project Living GDD + Visual Dashboard**.

The final responsibility split is:

1. **Project Main Home** — one self-contained human-facing page that lets a first-time reader understand what game is being made, how it plays, how it should look, which human-facing rules/data matter, and the current implementation reality at a product level.
2. **Detail Pages / Canon Databases** — the existing people-readable detailed canon for systems, visual direction, content, references, and project-specific data.
3. **AI Workspace** — machine/agent-facing evidence, schema, IDs, source mappings, implementation status, PR/Test/IRG/provenance, unresolved conflicts, and handoff details.
4. **GitHub** — structured implementation mirror, code, JSON, scenes, resources, tests, and actual runtime evidence.

The Home is **not a link hub** and is **not a build-status dashboard**. It must show enough real project information directly that a person does not have to open many child pages just to understand the game.

The top visual priority is **Visual GDD** — explanatory visual material that communicates game structure, systems, screens, and play flow — rather than decorative concept art.

## 1. Top-level acceptance criterion

> **Main Home만 보면 무엇을 만들 게임인지와 어떻게 만들 것인지 판단할 수 있고, AI Workspace를 보면 그것을 실제로 구현·검증하는 데 필요한 세부 데이터가 하나도 부족하지 않아야 한다.**

A first-time reader scrolling the Home should understand the project in this order:

```text
게임 정체성
→ 실제 플레이 모습
→ 핵심 시스템
→ 플레이 흐름
→ UI / 비주얼 방향
→ 핵심 사람용 데이터
→ 콘텐츠 / 세부 기획
→ 사람이 이해할 수 있는 개발 현실
→ 상세 정본
```

## 2. Authority and evidence rules

Authority order:

1. latest user instruction and approvals;
2. project `AGENTS.md` and current repository/runtime constraints;
3. current Notion Human Home and approved human-facing decisions;
4. current repository planning/data/code/scenes/resources/tests and actual runtime evidence;
5. adopted Base rules and active Skill owners;
6. external benchmark evidence;
7. inference.

Evidence rules:

- Human-facing design approval does not prove runtime implementation.
- Technical placeholder art/audio does not prove final player-facing visual or emotional quality.
- Whole-game Flow may include approved future systems, but must state that it is a design map rather than an implementation checklist.
- Human mobile comfort, final representative visual quality, real wave listening quality, and five-minute CALM/EMPTY judgment remain `NOT_RUN` until directly observed.
- Home may show a product-level Development Reality summary, but exact SHA/PR/CI/Test/IRG details stay in AI Workspace/GitHub.

## 3. Reference-image interpretation

The user-supplied images are **layout / information-density / explanatory-visual references only**.

They are not:

- My Little Boat art canon;
- assets to be copied into the project;
- instructions to reproduce their characters, UI, branding, composition, or trade dress;
- permission to generate new images automatically.

The useful common pattern extracted from them is:

```text
one explanatory visual
= representative screen / scene
+ system relationships
+ play sequence
+ UI regions
+ key data
+ design intent
```

Therefore, a successful Home should prefer **one or a few information-rich explanatory visuals** over a gallery of decorative images.

## 4. Approved visual style canon

The user approved the following visual direction on 2026-08-25.

### `SOFT_STORYBOOK_3D_DIORAMA`

Definition:

> 작은 보트가 손바닥 위 동화 모형처럼 느껴지는 stylized 3D. 형태는 둥글고 큰 덩어리로 읽히며, 재질은 과도한 사실적 PBR보다 부드러운 matte/painterly 표현을 우선한다. 바다·하늘은 저~중간 대비, UI와 선택 상태는 높은 판독성을 유지한다. 플레이어·펫·보트의 실루엣과 생활 흔적이 첫인상의 핵심이며, 특정 작품의 캐릭터 비율·UI·trade dress는 복제하지 않는다.

Required characteristics:

- calm 3/4 diorama as the normal presentation;
- visible avatar + resting pet + personal boat + sea in one readable composition;
- rounded, simplified, large-form silhouettes;
- soft matte / lightly painterly materials rather than photoreal PBR emphasis;
- stable horizon and low-to-medium environmental contrast;
- readable text/buttons/selection state with stronger functional contrast;
- slow, bounded, predictable motion;
- decoration adds lived-in character without becoming visual clutter or hiding the sea;
- character/pet/boat attachment is the primary first-impression focus;
- Appreciation Camera remains a quieter sea/horizon-focused alternate view.

Rejected current directions:

- photorealistic or high-noise water rendering as the identity;
- painterly 2D/2.5D pipeline that would fight the current 3D runtime and explode asset cost;
- generic minimal low-poly as the primary identity;
- direct imitation of Bondee, Animal Crossing, Spirit City, Garden Galaxy, or any other identifiable trade dress.

### Important evidence boundary

The **style direction is approved**, but the **representative final visual asset is not yet produced or approved**.

Current state:

```text
VISUAL_STYLE_DIRECTION = APPROVED
REPRESENTATIVE_VISUAL_GDD_IMAGE = NOT_YET_PRODUCED
FINAL_AVATAR_ART = NOT_INTEGRATED
FINAL_PET_ART = NOT_INTEGRATED
FINAL_BOAT/SEA_ART = NOT_INTEGRATED
HUMAN_VISUAL_COMFORT_VALIDATION = NOT_RUN
```

No generated visual may be presented as approved product art merely because it follows this style definition.

## 5. Current source-backed product facts to expose on Home

These values are current source-backed facts, not newly invented systems.

### Session and mood

- default voyage duration: `300 seconds`;
- mood options: `평온 / 지침 / 외로움 / 설렘`;
- the mood starts the voyage but is not a good/bad score.

### Persistent memory

Current runtime state tracks:

- photos;
- scenery;
- ambient/local bottle-letter memories;
- fish;
- voyage records;
- boat decor state for the current process lifetime.

Voyage records summarize the selected mood plus counts of photo/scenery/letter/fish memories gained during that voyage.

### Boat decoration

Current implementation has exactly 8 slot-zones:

1. `bow_left`;
2. `bow_right`;
3. `center_left`;
4. `center_right`;
5. `rear_left`;
6. `rear_right`;
7. `rail_accent`;
8. `pet_corner`.

Starter technical decor currently has exactly 6 items:

- lantern;
- mug;
- cushion;
- plant;
- postcard;
- pet cushion.

Decoration is self-expression/memory, not stats, rarity score, gacha, or optimization.

### Low-pressure interaction

Current interaction direction supports calm actions such as:

- pet / rest together / look at sea;
- lean on rail;
- hold cup;
- change lantern light;
- sit/rest on cushion;
- view album;
- quiet fishing;
- future bottle-station actions under the approved social boundary.

Ignoring an interaction must not create loss or farming disadvantage.

### Fishing / discovery / album

- quiet fishing is optional;
- failure/punishment/score/economy is not the point;
- ambient discovery appears over time rather than as a constant reward button;
- album/current voyage continuity is protected;
- memory accumulation is intended to create attachment rather than optimization pressure.

### Delayed Bottle Social

Human-facing explanation may include:

- `FriendBottle` and `DriftBottle` are delayed correspondence, not instant messaging;
- no typing/presence/read receipt/public feed/follower/ranking/global chat;
- core rest/voyage/decor/pet/album/fishing/soundscape remains local-first;
- public stranger UGC stays disabled until production moderation, Terms/Community Guidelines, 16+ gating, report/block, support, and release verification are proven.

The Home must not show fake-backend class names, polling methods, exact PR evidence, Supabase schema, or test harness details.

## 6. Main Home information architecture

The Home will use eight primary sections.

### 01 · PROJECT NORTH STAR

Purpose: answer within the first viewport:

1. What is this game?
2. What does the player repeatedly do?
3. What are we actually trying to build?
4. What should the final experience look and feel like?

Show directly:

- one-line fantasy;
- emotional North Star;
- product boundary: **the goal is to rest, not win**;
- visible-avatar + pet + boat + sea 3/4 diorama statement;
- short selling-point cluster;
- approved visual-style badge: `SOFT_STORYBOOK_3D_DIORAMA`;
- representative visual state badge: `VISUAL GDD IMAGE PENDING` until an approved asset exists.

Do not show PR numbers, SHA, CI, or technical PASS matrices here.

### 02 · VISUAL GDD · WHAT THE PLAYER SEES

This is the highest-priority visual explanation section.

When an approved explanatory visual exists, it should be displayed directly on Home and should ideally explain several of the following in one frame:

- normal 3/4 boat diorama;
- avatar/pet/boat/sea relationship;
- personal-space decoration zones;
- low-pressure interaction affordances;
- Appreciation Camera transition;
- quiet fishing / discovery / bottle-letter access points;
- major UI regions;
- flow from staying/resting into memories.

Until such an image is explicitly produced and approved, use:

- current Mermaid whole-game Flow;
- current Resting Sanctuary system diagram;
- concise visual-style specification;
- explicit `REPRESENTATIVE VISUAL GDD = NOT_YET_PRODUCED` notice.

Do not fill this gap with unrelated concept art.

### 03 · HOW THE GAME WORKS

Show the full approved player experience directly:

```text
오늘의 마음 선택
→ 3/4 보트 디오라마
→ 그냥 머물기
↔ 꾸미기 / 작은 상호작용
↔ Appreciation Camera
↔ 조용한 낚시 / Ambient Discovery
↔ 선택형 FriendBottle / DriftBottle
→ 항해 기록 / 앨범 / 보트 흔적
→ 계속 머물기 또는 다음 항해
```

Also show the system relationship centered on **Resting Sanctuary**:

```text
Resting Sanctuary
├─ Sea / Horizon / Weather / Light
├─ Wave-first Soundscape
├─ Visible Avatar
├─ Resting Pet
├─ Personal Boat Space
│  ├─ Decoration
│  └─ Low-pressure Interaction
├─ Appreciation Camera
├─ Quiet Fishing / Ambient Discovery
├─ Voyage Record / Album / Boat Memory
└─ Delayed Bottle Social
```

The diagrams are design communication tools, not implementation-completion claims.

### 04 · HOW IT SHOULD LOOK

Expose the approved visual canon directly rather than hiding it only in Visual Bible.

Show concise human-readable rules for:

- 3/4 composition;
- avatar/pet/boat silhouette hierarchy;
- horizon and sea readability;
- matte/painterly material direction;
- environment contrast versus UI contrast;
- motion density;
- decor clutter limit;
- Appreciation Camera difference;
- explicit final-art evidence boundary.

The detailed Visual Bible remains the owner for expanded visual rules.

### 05 · CORE GAME DATA

This section is for **human decision data**, not machine schema.

Directly show current essential data such as:

- 4 moods;
- 300-second default voyage;
- 8 decoration slots;
- 6 starter decor items;
- memory categories;
- optional activity list;
- current social protection rules;
- other project-critical data discovered during implementation audit.

Data-display rule:

- if the value is a stable small product rule, a compact Home table is acceptable;
- if the data already lives in a Notion canonical database and benefits from browsing/filtering, use a Linked View rather than copying rows;
- Home must not duplicate a full database solely for presentation.

### 06 · CONTENT & DESIGN

Show human-facing summaries of the major content domains directly:

- Avatar;
- Pet;
- Boat Space;
- Decoration;
- Low-pressure Interaction;
- Ambient Discovery;
- Quiet Fishing;
- Album / Memory;
- Delayed Bottle Social;
- relevant future content already approved in canon.

Each summary should answer:

```text
플레이어에게 무엇인가?
무엇을 선택할 수 있는가?
왜 이 게임의 감정에 필요한가?
무엇을 하면 이 시스템을 망치는가?
```

Do not turn this into an implementation API reference.

### 07 · DEVELOPMENT REALITY

This section restores a **human-understandable product reality summary** without polluting Home with engineering metadata.

Allowed status language:

- `구현됨`;
- `기술 Prototype`;
- `설계 확정 · 미구현`;
- `최종 자산 대기`;
- `Human 검증 대기`.

Recommended rows for this project:

- 5-minute voyage / mood / record core;
- Appreciation Camera;
- quiet fishing / discovery / album continuity;
- RestingSoundscape technical prototype;
- visible-avatar diorama technical shell;
- local boat decoration / low-pressure interaction;
- Delayed Bottle design / fake-backend / real network distinction at a human level;
- final avatar/pet/boat/sea art;
- mobile comfort / five-minute emotional validation.

Do **not** show here:

- exact commit SHA;
- PR number;
- workflow/run number;
- test file/path;
- raw IRG ledger;
- backend schema/table/function names;
- internal source mapping.

Those remain in AI Workspace/GitHub.

### 08 · DETAIL LIBRARY

End with meaningful drilldowns, not a wall of links.

Primary detail domains remain:

- Direction · Planning;
- Voyage · Experience · Systems;
- Visual · UX · Assets;
- Production · Validation;
- Reference · Benchmark.

Detail links supplement Home. They must not be required just to understand the game's core identity, loop, appearance, or critical data.

## 7. Linked View strategy

### Principle

**Same data, one owner.** Home may project canonical data but should not create a second manually maintained copy.

Use Linked Views only where they improve human understanding.

Likely good candidates:

- approved Visual/Asset items for `MY_LITTLE_BOAT` once such items exist;
- curated Core System records relevant to the current project;
- project-specific benchmark/reference rows where direct comparison matters;
- other existing canonical datasets discovered during the implementation audit.

Do not add Linked Views merely because a database exists.

### Current asset limitation

At design time, the project Asset Library does **not** contain an approved representative My Little Boat visual. Current project-linked discovered entries are unapproved audio candidates/references.

Therefore:

- do not create an empty "approved visual gallery" and pretend the visual work is complete;
- show the explicit pending state on Home;
- when an approved explanatory visual is later created/imported, place the canonical asset in the Asset Library and project it to Home through the existing owner/view model.

## 8. AI Workspace responsibility

`AI · 작업 현황 · Evidence` remains the operational/evidence surface.

It must retain or link to:

- exact GitHub main SHA;
- current-task and same-goal PR inventory;
- CI/test receipts;
- IRG evidence layers and ceilings;
- source mappings;
- IDs / schema / machine-readable structures;
- implementation and runtime status;
- blockers / `NOT_RUN`;
- assumptions;
- unresolved conflicts;
- handoff / provenance;
- exact technical next work.

The AI Workspace must not become a second narrative GDD.

The Home must not become a second AI Workspace.

## 9. Detail canon responsibility

Detail pages/databases remain people-readable owners for expanded design knowledge.

Examples:

- Visual Bible owns expanded art/composition/accessibility rules;
- UI / Voyage Flow Map owns expanded experience-flow detail;
- Core System detail/database owns expanded system records;
- Asset Library owns actual asset approval/provenance state;
- Benchmark Library owns detailed benchmark evidence and ADOPT/ADAPT/REJECT reasoning;
- Production/Validation owns human-facing production and validation detail below the Home summary level.

Home should summarize/project these owners, not replace them.

## 10. Data ownership matrix

| Information | Human Home | Detail Canon | AI Workspace | GitHub |
|---|---|---|---|---|
| Game fantasy / selling point | primary | expanded | reference | structured mirror as needed |
| Whole-game player flow | primary visual summary | expanded | source locator | mirror if implementation consumes it |
| Visual style canon | primary summary | **owner: Visual Bible** | source/evidence | implementation mirror as needed |
| Actual approved visual asset | display/project | **owner: Asset Library** | provenance | runtime resource if integrated |
| Core product rules / human values | direct essential values | detailed owner | mapping | structured/runtime truth |
| Large browsable human data | Linked View | **canonical DB owner** | schema/mapping | mirror/runtime owner where applicable |
| Human development reality | concise status | Production/Validation detail | exact evidence | code/test/runtime truth |
| PR / SHA / CI / test receipt | prohibited | normally no | **primary** | **primary evidence** |
| schema / field IDs / source mapping | prohibited | normally no | **primary** | implementation truth |
| unresolved conflict / handoff | prohibited | only if product decision relevant | **primary** | issue/PR when applicable |

## 11. Benchmark synthesis guiding this structure

External examples are used as **principle evidence**, not templates to copy.

### Adopt / adapt

- `Spirit City: Lofi Sessions` — ambient place + companion + personalization can itself be product value; reject productivity-pressure as My Little Boat's core.
- `Animal Crossing: Pocket Camp Complete` — a small personal place, character presence, collecting, fishing, and decorating can coexist in a relaxed loop; do not copy Nintendo character proportions, UI, or content structure.
- `Garden Galaxy` — stylized/isometric small-space customization supports readable personal-space attachment; do not adopt its exact visual language.
- user-supplied Visual GDD examples — information-rich explanatory boards can communicate screen, flow, data, and design simultaneously; use the communication pattern, not the art style.

### Warning

- a beautiful concept-art gallery without system explanation fails the Home acceptance criterion;
- a database-heavy dashboard with no player-facing visual hierarchy also fails;
- duplicating full canon into Home creates drift and maintenance cost;
- hiding all implementation reality in AI Workspace leaves the human unable to judge what is actually built.

## 12. Three implementation approaches considered

### A. Text-first Home + detail links

Pros:

- cheapest;
- easy maintenance.

Cons:

- weak Visual GDD function;
- repeats the current failure mode where important material is hidden behind drilldowns;
- poor first-time comprehension.

Decision: **REJECT**.

### B. Full database dashboard Home

Pros:

- high data visibility;
- strong filtering.

Cons:

- risks becoming an operator console;
- visual/player hierarchy becomes weak;
- too much schema leakage and maintenance complexity for a solo project.

Decision: **REJECT**.

### C. Visual GDD + Living GDD + selective Linked Views

Pros:

- explanatory visual hierarchy first;
- human-critical data remains visible;
- single-source ownership preserved;
- can grow with approved assets without forcing a new system;
- matches the user's reference-image communication goal.

Cons:

- requires careful curation of what is direct summary versus linked data;
- representative Visual GDD asset still needs a separate later image-production gate.

Decision: **SELECTED**.

## 13. Non-goals

This task does not:

- change Godot gameplay, scenes, scripts, resources, save behavior, or balancing;
- implement/merge/rebase/modify PR #19;
- implement real social networking or Supabase;
- generate or edit a representative image automatically;
- create a new HTML dashboard;
- create a new Google Sheets workspace;
- invent new gameplay systems;
- convert all detailed data into new Home-only databases;
- claim final art or Human experience validation.

## 14. Visual-asset production gate

After this Home-structure task is implemented, creating the actual representative Visual GDD image remains a **separate image task**.

That future task must:

1. re-read current Visual Bible and approved `SOFT_STORYBOOK_3D_DIORAMA` canon;
2. select the exact explanatory content for the board;
3. present the text brief;
4. require an explicit user request to generate/edit the image;
5. create only the approved image scope;
6. store/provenance it in the canonical Asset Library;
7. mark it approved only after user review;
8. then project it to Home.

No placeholder/generated image receives approval implicitly.

## 15. Implementation Reality Gate for this Home task

Completion levels:

```text
DISCOVERED
→ CALLABLE / IMPLEMENTED
→ INVOKED / EXECUTED
→ DURABLE EFFECT / DESTINATION READBACK
→ HUMAN / RUNTIME OBSERVATION where applicable
```

For this Notion/document architecture task, the normal completion ceiling is **DURABLE EFFECT / DESTINATION READBACK**.

A completed Home restructure does not prove:

- final art quality;
- smartphone comfort;
- five-minute emotional success;
- social usability;
- audio production quality.

Those remain separate evidence layers.

## 16. Adversarial review requirements

Before merge, perform at least five full-state loops and continue until a full re-attack finds no new blocking issue.

Every loop rechecks the **whole candidate**, not just the last edit.

Attack dimensions must include:

1. authority/canon conflict — Home vs Visual Bible vs Flow vs Core System vs repository;
2. human/AI responsibility leakage — product data accidentally hidden in AI or engineering metadata leaked into Home;
3. data duplication/drift — duplicated values or copied databases;
4. visual evidence overclaim — pending/generated/placeholder art presented as approved;
5. Development Reality accuracy — implementation status understandable but not overclaimed;
6. safety/social boundary — Delayed Bottle does not become realtime/open social;
7. maintainability — Home remains readable and not an oversized wall of data;
8. consumer completeness — active database/page records with stale visual/social rules are found and corrected when in scope.

After every correction, rerun the whole review. Stop only on a clean full-state pass.

## 17. Implementation sequencing after spec approval

After the user approves this written spec:

1. use `writing-plans` to create the implementation plan;
2. fresh-read current `main`, open PR inventory, Home, System Record, AI Workspace, Visual Bible, Flow Map, Core System, Asset Library, and relevant detail pages;
3. create/update the approved visual-style canon in the correct people-readable owner;
4. reorganize Home into sections 01–08;
5. add only useful Linked Views from existing owners;
6. add the human-level Development Reality summary;
7. preserve exact operational evidence in AI Workspace;
8. destination-readback every Notion change;
9. search for stale consumers and duplicated canon;
10. run adversarial loops to clean exit;
11. open current-task PR containing durable spec/plan/mirror changes only as required;
12. verify exact HEAD checks and review threads;
13. merge only the current-task PR;
14. read back new `main`, Notion Home, AI Workspace, and System Record;
15. re-run postmerge adversarial review and correct drift before claiming completion.

## 18. Final success checklist

The implementation is successful only when all are true:

- [ ] first viewport answers the four required project questions;
- [ ] Visual GDD is the first major explanatory visual layer;
- [ ] no decorative image is used as a substitute for system explanation;
- [ ] `SOFT_STORYBOOK_3D_DIORAMA` is visible as the approved visual direction;
- [ ] representative Visual GDD asset is clearly pending unless separately produced and approved;
- [ ] whole-game player flow is visible directly on Home;
- [ ] system relationships are visible directly on Home;
- [ ] essential human product data is visible directly or through useful Linked Views;
- [ ] large canonical datasets are not manually duplicated for Home;
- [ ] human-readable Development Reality is visible;
- [ ] SHA/PR/CI/Test/IRG/schema/internal IDs are absent from Home;
- [ ] AI Workspace retains exact implementation/evidence detail;
- [ ] detail canon remains navigable and authoritative;
- [ ] no new gameplay rule is invented;
- [ ] no representative image is generated without explicit user request;
- [ ] PR #19 remains independent and untouched;
- [ ] destination readback passes;
- [ ] stale/conflict search passes;
- [ ] minimum five full adversarial loops are performed and final re-attack is clean;
- [ ] postmerge Home/System/AI/main readback passes.
