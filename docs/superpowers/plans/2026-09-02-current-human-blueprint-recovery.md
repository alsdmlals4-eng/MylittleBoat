# Current Human Blueprint Recovery Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Restore a current, visual, source-bound Human Blueprint without making it a second design canon or reintroducing the obsolete pre-implementation presentation.

**Architecture:** `docs/design/PROJECT_GDD.md` remains the only human-facing design owner. Its detailed September implementation receipts remain available in its declared evidence layer; the derived PDF deliberately selects the player, screen, and presentation route rather than restating that technical log. A deterministic ReportLab builder reads current repository assets and emits a derived PDF plus a JSON receipt under `output/pdf/`; the receipt records the input GDD hash and exact image hashes.

**Tech Stack:** Python 3, ReportLab, pypdf, Poppler `pdftoppm`, Python `unittest`, existing Godot runtime captures.

**Spec:** `docs/design/PROJECT_GDD.md` and `docs/DOCUMENTATION_MAP.md`

## Global Constraints

- `docs/design/PROJECT_GDD.md` is `CURRENT_HUMAN_FACING_GDD`; the PDF is derived and never becomes a second canon.
- Preserve the current title-waiting flow, rear 3/4 chibi player, companion, boat, split fixed-sky/flowing-sea presentation, distant island lane, and local-first rest loop.
- Do not reuse the stale 2026-08-30 PDF as a current design source; it has obsolete visual and implementation states.
- Do not treat renderer or machine evidence as Human, device, accessibility, audio-comfort, or release acceptance.
- Use existing approved/runtime-evidence images only. No new product artwork is required for this recovery.
- The output must stay readable at rendered 1280 x 720 landscape pages with no clipped, overlapping, placeholder, or garbled Korean text.

---

### Task 1: Define the current-publication contract before creating it

**Files:**

- Modify: `tests/test_human_game_blueprint_profile.py`
- Modify: `docs/design/PROJECT_GDD.md`
- Modify: `docs/DOCUMENTATION_MAP.md`

**Interfaces:**

- Consumes: the current GDD, document map, and historical PDF paths.
- Produces: a testable `CURRENT_SOURCE_BOUND_DERIVED_PUBLICATION` route and a compact selected player-facing publication.

- [x] **Step 1: Write the failing test**

```python
def test_current_source_bound_blueprint_publication_and_compact_gdd_route(self) -> None:
    self.assertTrue((ROOT / CURRENT_BLUEPRINT_PDF).is_file())
    self.assertTrue((ROOT / CURRENT_BLUEPRINT_RECEIPT).is_file())
    self.assertIn("CURRENT_SOURCE_BOUND_DERIVED_PUBLICATION", self.gdd)
    self.assertIn("CURRENT_BLUEPRINT_PLAYER_FACING_SELECTION", self.gdd)
```

- [x] **Step 2: Run test to verify it fails**

Run: `python -m unittest tests/test_human_game_blueprint_profile.py -v`

Expected: FAIL because the current derived PDF, receipt, and owner-route tokens do not exist.

- [x] **Step 3: Implement the smallest owner-route correction**

```markdown
`output/pdf/MY_LITTLE_BOAT_HUMAN_GAME_BLUEPRINT_20260902.pdf` = `CURRENT_SOURCE_BOUND_DERIVED_PUBLICATION`
`BLUEPRINT_RUNTIME_RECEIPTS_MOVED_TO_HANDOFF`
```

Keep the detailed five-loop implementation evidence in GDD's existing production-evidence layer. Bind the publication to an explicit selected player-facing route so factual detail remains available without turning the first reader route into an implementation log.

- [x] **Step 4: Re-run the test after Task 2 creates its outputs**

Run: `python -m unittest tests/test_human_game_blueprint_profile.py -v`

Expected: PASS, including the source-binding and stale-publication assertions.

### Task 2: Build and bind a current visual publication

**Files:**

- Create: `tools/build_human_blueprint_pdf.py`
- Create: `output/pdf/MY_LITTLE_BOAT_HUMAN_GAME_BLUEPRINT_20260902.pdf`
- Create: `output/pdf/MY_LITTLE_BOAT_HUMAN_GAME_BLUEPRINT_20260902.receipt.json`
- Modify: `docs/design/PROJECT_GDD.md`
- Modify: `docs/DOCUMENTATION_MAP.md`

**Interfaces:**

- Consumes: the unique GDD owner plus the exact runtime/evidence images named in `BLUEPRINT_IMAGE_INPUTS`.
- Produces: `build_human_blueprint_pdf.py --output <pdf> --receipt <json>` with a receipt containing `gdd_sha256`, `generator_sha256`, image path/SHA pairs, page count, and source revision.

- [x] **Step 1: Write a failing static builder/output test**

```python
def test_publication_receipt_binds_current_gdd_and_exact_visual_inputs(self) -> None:
    receipt = json.loads((ROOT / CURRENT_BLUEPRINT_RECEIPT).read_text(encoding="utf-8"))
    self.assertEqual(receipt["gdd_sha256"], sha256_file(GDD))
    self.assertEqual(receipt["page_count"], 10)
    self.assertIn("docs/evidence/2026-08-31-title-boat-flow/bright_title_idle_00_540x960.png", receipt["images"])
```

- [x] **Step 2: Run the focused test to verify it fails**

Run: `python -m unittest tests/test_human_game_blueprint_profile.py -v`

Expected: FAIL because neither the builder output nor receipt exists.

- [x] **Step 3: Implement the deterministic builder**

```python
def build_publication(output: Path, receipt_path: Path) -> None:
    # Register a bundled/Windows Korean-capable TrueType font.
    # Draw exactly ten landscape pages from a fixed page plan.
    # Use existing runtime captures only and write a source/hash receipt.
```

The page plan is cover; title wait; normal voyage; forward water; camera choices; time/sky/sea; distant scenery; voluntary actions; no-pressure boundary; status and remaining validation. It must use current runtime captures rather than obsolete pre-implementation illustration.

- [x] **Step 4: Generate publication after the PDF operation start marker**

Run: `node container_tools/mark_artifact_operation_started.mjs --operation-kind create --expected-output-count 1 --output-format pdf`, then run the builder.

Expected: one PDF and one receipt at the exact paths, with no temporary product assets.

- [x] **Step 5: Verify PDF structure and source binding**

Run: `pdfinfo <pdf>`, `pypdf` page text extraction, and focused Python tests.

Expected: exactly ten pages; readable Korean text; receipt hashes equal the repository source bytes.

### Task 3: Render, inspect, and close the regression loop

**Files:**

- Modify: `README.md`
- Modify: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`
- Modify: `docs/design/PROJECT_GDD.md`
- Modify: `docs/DOCUMENTATION_MAP.md`

**Interfaces:**

- Consumes: generated PDF, receipt, visual GDD route, and existing handoff proof.
- Produces: a reader route that distinguishes current derived publication, historical stale PDFs, and machine/runtime/Human evidence ceilings.

- [x] **Step 1: Render every page at review size**

Run: `pdftoppm -png -scale-to-x 1280 -scale-to-y -1 <pdf> <temp-prefix>`.

Expected: ten raster pages available for visual inspection without modifying project assets.

- [x] **Step 2: Inspect representative and dense pages**

Inspect: cover, title-to-voyage flow, forward-water page, camera page, action page, and final status page.

Expected: no text collision, clipped labels, old art, `구현 전` copy, outdated flow, or unqualified Human PASS claim.

- [x] **Step 3: Correct validated layout or content defects and re-render**

```text
Defect -> minimal builder/source correction -> rebuild -> rerender -> recheck.
```

- [x] **Step 4: Run documentation, PDF, and regression checks**

Run: `python -m unittest tests/test_human_game_blueprint_profile.py -v`, full Python suite, `git diff --check`, and the smallest useful Godot smoke because repository docs now reference current runtime behavior.

Expected: all checks pass; Human/device/release checks remain explicitly `NOT_RUN`.

- [x] **Step 5: Commit and synchronize the logical recovery**

Run: preflight remote, commit only this recovery, push, exact-head readback.

Expected: local and branch remote have matching head; unrelated PR #19 remains untouched.

## Self-Review

- Spec coverage: the plan restores an actual current blueprint reading surface, preserves one source owner, excludes stale pre-implementation art, reconnects exact runtime evidence, provides source binding, tests it, and renders every page before delivery.
- Placeholder scan: no open implementation placeholder remains; the PDF has a fixed ten-page plan and exact inputs/outputs.
- Interface consistency: the test and receipt use the exact `CURRENT_BLUEPRINT_PDF`, `CURRENT_BLUEPRINT_RECEIPT`, `gdd_sha256`, `generator_sha256`, `images`, `page_count`, and `source_revision` fields described above.

## Execution Handoff

The user has already selected continued autonomous execution. Execute this plan inline with `superpowers:executing-plans`; do not create or modify unrelated workstreams.
