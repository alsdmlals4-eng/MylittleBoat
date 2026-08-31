# CI Contract Coverage Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** GitHub CI가 current `test_*.gd` 계약을 빠짐없이 headless로 실행하고, display renderer가 필요한 단 하나의 material proof를 명시적으로 분리한다.

**Architecture:** workflow 내부 Bash discovery loop가 `tests/test_*.gd`를 정렬해 수집한다. 현재 정확한 51개 전체 계약 중 `test_chibi_normal_chroma_material_proof.gd`만 display renderer 전용으로 제외하고, 50개 headless 실행 수와 1개 제외 수를 모두 fail-closed로 확인한다. 별도 manifest를 만들지 않아 수동 목록 중복을 피한다.

**Tech Stack:** GitHub Actions Ubuntu runner, Bash, Godot 4.7 headless CLI, Python `unittest` 정적 workflow contract.

**Spec:** `docs/PROJECT_WORK_REUSE_HANDOFF.json`의 `MLB-FOLLOWUP-20260831-CI-CONTRACT-COVERAGE`, `AGENTS.md`의 renderer/evidence boundary, `.github/workflows/godot-validation.yml`.

## Global Constraints

- Godot 4.7 stable과 current `godot --headless --path . --import` route를 유지한다.
- normal voyage, save schema, assets, scenes, product UI, Base lock, open PR #19를 변경하지 않는다.
- `test_chibi_normal_chroma_material_proof.gd`의 `ViewportTexture` image readback은 headless PASS로 둔갑시키지 않는다.
- CI `timeout-minutes: 10`을 올리지 않고, contract 당 20초 timeout을 유지한다.
- 새 source 파일에는 역할을 설명하는 한 줄 한국어 header comment를 넣는다.

---

### Task 1: CI discovery contract를 RED로 고정한다

**Files:**
- Create: `tests/test_ci_contract_coverage.py`
- Read: `.github/workflows/godot-validation.yml`

**Interfaces:**
- Consumes: workflow의 `Run current headless behavior contracts` Bash step.
- Produces: 현재 51개, display 전용 1개, headless 실행 50개라는 fail-closed 정적 contract.

- [x] **Step 1: Write the failing test**

```python
class CiContractCoverageTests(unittest.TestCase):
    def test_workflow_discovers_the_current_contract_set_and_keeps_one_display_only_exception(self):
        workflow = WORKFLOW_PATH.read_text(encoding="utf-8")
        self.assertIn('EXPECTED_ALL_CONTRACT_COUNT=51', workflow)
        self.assertIn('DISPLAY_ONLY_CONTRACT=test_chibi_normal_chroma_material_proof.gd', workflow)
        self.assertIn("find tests -maxdepth 1 -type f -name 'test_*.gd'", workflow)
        self.assertIn('EXPECTED_HEADLESS_CONTRACT_COUNT=50', workflow)
```

- [x] **Step 2: Run test to verify it fails**

Run: `python tests/test_ci_contract_coverage.py`

Expected: FAIL because the old workflow still contains an incomplete hand-maintained command list.

- [x] **Step 3: Write minimal implementation**

Replace only the workflow’s manual behavior-contract command list with this fail-closed discovery shape.

```bash
EXPECTED_ALL_CONTRACT_COUNT=51
EXPECTED_HEADLESS_CONTRACT_COUNT=50
DISPLAY_ONLY_CONTRACT=test_chibi_normal_chroma_material_proof.gd
mapfile -t all_contracts < <(find tests -maxdepth 1 -type f -name 'test_*.gd' -printf '%f\n' | LC_ALL=C sort)
```

The loop must verify the total count, see exactly one named exception, run every other discovered path with the existing 20-second timeout, and verify the executed count before returning the aggregate status.

- [x] **Step 4: Run test to verify it passes**

Run: `python tests/test_ci_contract_coverage.py`

Expected: PASS and the test proves that a future unreviewed contract addition changes the expected-count boundary rather than being silently omitted.

- [x] **Step 5: Commit**

Do not commit in this continuation. Keep the logical CI package uncommitted with the current user-approved recovery package until the repository owner requests a commit or PR.

### Task 2: Current CI consumer and evidence documentation을 동기화한다

**Files:**
- Modify: `README.md`
- Modify: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`
- Modify: `docs/PROJECT_WORK_REUSE_HANDOFF.json`

**Interfaces:**
- Consumes: Task 1 exact discovery/exclusion constants and the current renderer proof receipt.
- Produces: reader-facing command boundary, current CI coverage count, separate display renderer evidence ceiling, and the selected/rejected alternative record.

- [x] **Step 1: Write the failing test**

Extend `tests/test_ci_contract_coverage.py` to require that the workflow’s exact current count and display-only contract appear in the recovery record, and that the current handoff says the display contract remains outside headless CI.

- [x] **Step 2: Run test to verify it fails**

Run: `python tests/test_ci_contract_coverage.py`

Expected: FAIL because the current record still calls manual partial coverage a future recommendation.

- [x] **Step 3: Write minimal implementation**

Record the three alternatives without creating another runtime system.

```text
REJECT: existing hand-maintained workflow list
ADAPT: separate static manifest duplicated from the test directory
ADOPT: sorted discovery plus exact total/exclusion/executed-count guards
```

Document that 50 contracts are headless CI consumers and the chibi material proof is separately Windows GL Compatibility machine evidence, not a skipped PASS.

- [x] **Step 4: Run test to verify it passes**

Run: `python tests/test_ci_contract_coverage.py`

Expected: PASS with complete workflow/document boundary checks.

- [x] **Step 5: Commit**

Do not commit in this continuation. Keep documentation and the CI consumer change in the same pending logical package.

### Task 3: Dynamic loop과 current runtime contracts를 회귀 검증한다

**Files:**
- Verify: `.github/workflows/godot-validation.yml`
- Verify: `tests/test_ci_contract_coverage.py`
- Verify: all current non-display `tests/test_*.gd`

**Interfaces:**
- Consumes: actual `tests/test_*.gd` file set, Godot CLI, and exact `user://test_*` teardown paths.
- Produces: local 50/50 headless result, static workflow contract result, zero exact test-local leftovers, and documented display-only boundary.

- [x] **Step 1: Run the static workflow contract**

Run: `python tests/test_ci_contract_coverage.py`

Expected: PASS.

- [x] **Step 2: Run every discovered non-display contract**

Run: a local equivalent of the selected loop using Godot 4.7.2 and the exact `test_chibi_normal_chroma_material_proof.gd` exclusion.

Expected: 50 contracts PASS; no display image assertion is attempted headlessly.

- [x] **Step 3: Re-check repository/document integrity**

Run: `git diff --check`, JSON parse for `docs/PROJECT_WORK_REUSE_HANDOFF.json`, and `python tests/test_human_game_blueprint_profile.py`.

Expected: every check PASS.

- [x] **Step 4: Audit temporary test state**

Run: inspect only `user://test_*` paths and remove only any exact leftovers created by the suite.

Expected: zero remaining test-local artifacts; preserve production saves and current machine evidence.

- [x] **Step 5: Commit**

Do not commit or push. Report the current worktree diff, remote CI boundary, and user-gated Human/device evidence separately.

## Self-Review

- **Spec coverage:** Task 1 prevents partial-manual CI drift; Task 2 preserves the renderer evidence ceiling; Task 3 proves the selected loop against the actual current test set and cleans only exact test artifacts.
- **Placeholder scan:** no TBD, TODO, or undefined implementation step remains.
- **Type consistency:** the same `EXPECTED_ALL_CONTRACT_COUNT`, `EXPECTED_HEADLESS_CONTRACT_COUNT`, and `DISPLAY_ONLY_CONTRACT` names are used by workflow, static test, and documentation checks.

## Execution Handoff

The user’s repeated `진행해` direction selects inline execution in the current recovery worktree. No commit, push, PR mutation, or change to the read-only bottle-social PR is part of this plan.
