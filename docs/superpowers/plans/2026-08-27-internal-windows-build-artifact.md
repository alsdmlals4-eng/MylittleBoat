# Internal Windows Build Artifact Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Produce a reproducible, user-downloadable internal Windows package for the current My Little Boat slice without changing the game.

**Architecture:** A version-controlled Godot Windows export preset is the sole package definition. The existing validation workflow gains template-enabled Windows export, archive validation, and an Actions artifact only after the ordinary contracts pass. Documentation records the exact evidence boundary.

**Tech Stack:** Godot 4.7, GDScript, GitHub Actions, `chickensoft-games/setup-godot@v2.4.1`, Windows x86_64 export.

**Spec:** `docs/superpowers/specs/2026-08-27-internal-windows-build-artifact-design.md`

## Global Constraints

- Keep the current gameplay, art, save data, social boundary, and PR #19 untouched.
- Define only the Windows x86_64 internal debug route; no Android, signing, store, or public release work.
- Upload no external data; the package remains a GitHub Actions artifact for repository users.
- Treat machine package success and Human/mobile QA as separate statuses.

---

### Task 1: Lock the export contract

**Files:**
- Create: `export_presets.cfg`
- Create: `tests/test_windows_export_contract.gd`
- Modify: `.github/workflows/godot-validation.yml`

**Interfaces:**
- Consumes: `project.godot` and the existing Godot 4.7 validation workflow.
- Produces: a `Windows Desktop` preset with `build/my_little_boat.exe` as its defined output and a focused contract test that rejects missing or non-x86_64 configuration.

- [ ] **Step 1: Write the failing export configuration test**

```gdscript
var preset_text := FileAccess.get_file_as_string("res://export_presets.cfg")
assert(not preset_text.is_empty())
assert(preset_text.contains('name="Windows Desktop"'))
assert(preset_text.contains('platform="Windows Desktop"'))
assert(preset_text.contains('binary_format/architecture="x86_64"'))
```

- [ ] **Step 2: Run the focused test to confirm failure**

Run:

```powershell
& $godot --headless --path . --script res://tests/test_windows_export_contract.gd
```

Expected: failure because `export_presets.cfg` does not yet exist.

- [ ] **Step 3: Add the minimal preset and CI inclusion**

```ini
[preset.0]
name="Windows Desktop"
platform="Windows Desktop"
export_path="build/my_little_boat.exe"

[preset.0.options]
binary_format/architecture="x86_64"
```

Add the focused contract to the existing run list; keep all existing checks unchanged.

- [ ] **Step 4: Run the focused test to confirm pass**

Run the same command and require exit code 0.

- [ ] **Step 5: Commit**

```powershell
git add export_presets.cfg tests/test_windows_export_contract.gd .github/workflows/godot-validation.yml
git commit -m "Add Windows export contract"
```

### Task 2: Produce and preserve the internal package

**Files:**
- Modify: `.github/workflows/godot-validation.yml`
- Modify: `README.md`
- Modify: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`

**Interfaces:**
- Consumes: the Task 1 preset named `Windows Desktop`.
- Produces: `my-little-boat-windows-internal.zip` as a GitHub Actions artifact with executable and PCK contents.

- [ ] **Step 1: Add the failing archive-content check**

```bash
test -f build/my_little_boat.exe
test -f build/my_little_boat.pck
unzip -l build/my-little-boat-windows-internal.zip | grep -q 'my_little_boat.exe'
unzip -l build/my-little-boat-windows-internal.zip | grep -q 'my_little_boat.pck'
```

- [ ] **Step 2: Confirm failure before export exists**

Run the commands above from a clean `build/` directory.

Expected: failure because no artifact has been exported.

- [ ] **Step 3: Add template-enabled export and artifact upload**

```yaml
with:
  include-templates: true
run: godot --headless --path . --export-debug "Windows Desktop" build/my_little_boat.exe
uses: actions/upload-artifact@v4
with:
  name: my-little-boat-windows-internal
  path: build/my-little-boat-windows-internal.zip
```

Trigger it for pull requests, pushes to `main`, and manual dispatch. Run it only after the existing contracts and scene smokes.

- [ ] **Step 4: Document the artifact and evidence ceiling**

Add the GitHub Actions download path to `README.md`. Update the current handoff with exact machine-package wording, retaining `Human/mobile = NOT_RUN`.

- [ ] **Step 5: Verify and commit**

Run the focused export contract, all existing contracts, all three scene smokes, `git diff --check`, and inspect the archive listing. Commit the workflow and documentation only after each command succeeds.

### Task 3: PR evidence and merge closeout

**Files:**
- No additional production files.

**Interfaces:**
- Consumes: the CI artifact from Task 2.
- Produces: a current-task PR with passing validation and a post-merge `main` workflow artifact link.

- [ ] **Step 1: Create a current-task PR linked to GitHub Issue #58**

Use a PR body that lists the Windows-only scope, excluded Android/public-release work, exact commands run, and `Closes #58`.

- [ ] **Step 2: Inspect CI evidence**

Require the ordinary validation job and the export/artifact job to pass. Inspect the artifact listing for the executable and PCK before merging.

- [ ] **Step 3: Squash merge and verify main**

Squash merge only this current task after a clean merge state and no unresolved review items. Fetch `origin/main`, read the merged commit, and confirm the push-to-main run exposes the same artifact.

- [ ] **Step 4: Record the evidence ceiling**

Report the artifact URL and its checksum if available. Keep Windows runtime launch and Human/mobile checks explicitly `NOT_RUN` unless fresh evidence exists.

## Self-review

- Spec coverage: Tasks 1–3 map one-to-one to preset, CI artifact, documentation, validation, PR and post-merge evidence requirements.
- Placeholder scan: no unresolved implementation placeholders are used; platform and file names are fixed.
- Type consistency: the preset name is exactly `Windows Desktop`; executable and PCK names are exactly `my_little_boat.exe` and `my_little_boat.pck`.
