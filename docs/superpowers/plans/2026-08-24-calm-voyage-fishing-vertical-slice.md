# Calm Voyage + Fishing Vertical Slice Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Turn the current button-driven Godot MVP into a small calm-voyage vertical slice with preserved memories, ambient discoveries, meaningful appreciation/speed controls, one voyage record, and optional low-friction fishing.

**Architecture:** Keep `GameState` as the single autoload owner for state that must survive Scene changes, split fishing timing into a small `FishingSession` RefCounted state machine, and keep presentation/orchestration in `game_scene.gd`. Reuse existing scenes and nodes where possible, making the smallest changes that satisfy the player-meaning contracts.

**Tech Stack:** Godot 4.7 stable, GDScript, GitHub Actions, chickensoft-games/setup-godot v2.4.1.

**Spec:** `docs/superpowers/specs/2026-08-24-calm-voyage-fishing-vertical-slice-design.md`

## Global Constraints

- Godot 4.7 stable + GDScript only.
- Mobile portrait first; preserve PC mouse camera support.
- No combat, HP, damage, death, failure conditions, competitive score, payments, ads, online letter sharing, runtime generative AI, paid dependencies, or fishing economy in this slice.
- Human/player emotion evidence remains `NOT_RUN` until directly observed.
- Do not vendor Base RM-VIS helpers unless this slice proves an actual consumer need.

---

### Task 1: Add executable RED behavior contracts and CI

**Files:**
- Create: `.github/workflows/godot-validation.yml`
- Create: `tests/test_calm_voyage_state.gd`
- Create: `tests/test_fishing_session.gd`

**Interfaces:**
- Consumes: existing `scripts/core/game_state.gd`.
- Produces: executable behavior contracts for transient reset vs accumulated memory, voyage completion, fish memory, and fishing state transitions.

- [ ] **Step 1: Add Godot 4.7 PR validation workflow**

Use `chickensoft-games/setup-godot@v2.4.1` with `version: 4.7.0`, `use-dotnet: false`, then run project smoke, focused state test, focused fishing test, and scene smoke.

- [ ] **Step 2: Write failing GameState behavior test**

The test must prove that `reset_session()` keeps accumulated photos/scenery/letters, require `begin_voyage`, require one-time `complete_voyage`, and require `add_fish`/fish collection.

- [ ] **Step 3: Write failing FishingSession test**

Require a `scripts/voyage/fishing_session.gd` state machine with `cast_line`, `advance`, `is_bite_ready`, `resolve_catch`, and `cancel` behavior.

- [ ] **Step 4: Open PR and observe RED**

The exact PR HEAD must fail for missing/incorrect product behavior, not workflow syntax.

---

### Task 2: Make GameState own session continuity and accumulated memory

**Files:**
- Modify: `scripts/core/game_state.gd`
- Modify: `scripts/ui/main_menu.gd`

**Interfaces:**
- Produces: `begin_voyage(mood: String)`, `tick_voyage(delta: float)`, `complete_voyage()`, `add_fish(entry: String)`, persistent-in-process arrays `fish` and `voyage_records`, transient voyage fields.

- [ ] **Step 1: Implement minimal GREEN state model**

Keep existing arrays and APIs, change `reset_session()` to transient-only reset, and add the required fields/methods.

- [ ] **Step 2: Start voyages through `begin_voyage`**

Update main menu so mood selection starts a new transient voyage without clearing accumulated memory.

- [ ] **Step 3: Re-run focused behavior test**

Expected: GameState behavior test GREEN; fishing test still RED until Task 3.

---

### Task 3: Implement minimal calm fishing state machine

**Files:**
- Create: `scripts/voyage/fishing_session.gd`

**Interfaces:**
- Produces: `cast_line(wait_seconds: float)`, `advance(delta: float) -> bool`, `is_waiting() -> bool`, `is_bite_ready() -> bool`, `resolve_catch(fish_name: String) -> String`, `cancel()`.

- [ ] **Step 1: Implement only the tested state transitions**

`IDLE → WAITING → BITE_READY → IDLE`, with no failure/score/economy state.

- [ ] **Step 2: Re-run fishing behavior test**

Expected: focused fishing test GREEN.

---

### Task 4: Convert the voyage screen from reward buttons to calm interactions

**Files:**
- Modify: `scripts/voyage/game_scene.gd`
- Modify: `scenes/game.tscn`

**Interfaces:**
- Consumes: GameState active voyage state and `FishingSession`.
- Produces: actual appreciation UI reduction, speed-dependent bob rhythm, timed ambient discoveries, optional fishing UI.

- [ ] **Step 1: Read active voyage state instead of recreating local timer state**

Use `GameState.remaining_seconds`, `GameState.speed_index`, `GameState.appreciation_mode`, and `GameState.voyage_record_created` so Album round trips preserve the session.

- [ ] **Step 2: Make Appreciation Mode semantic**

Hide non-essential controls/status while keeping the appreciation toggle visible and reversible.

- [ ] **Step 3: Make speed observable**

Apply speed multipliers to a subtle `CameraRig`/boat bob phase without changing reward amount or session duration.

- [ ] **Step 4: Convert scenery/letter buttons to ambient discovery consumers**

Hide both by default. Schedule a discovery, expose only the relevant record action while pending, then hide it again after recording.

- [ ] **Step 5: Add Fishing button/status**

First press casts, waiting advances in `_process`, bite changes the button to catch, catch records one fish via `GameState.add_fish` and returns to idle.

- [ ] **Step 6: Complete one voyage record**

When remaining time reaches zero, call `GameState.complete_voyage()` exactly once and continue idle appreciation.

---

### Task 5: Make Album show the full memory loop

**Files:**
- Modify: `scripts/ui/album_view.gd`
- Modify: `scenes/album.tscn` only if required for readable layout.

**Interfaces:**
- Consumes: photos, sceneries, letters, fish, voyage_records, companion_affection.
- Produces: readable summary proving the vertical slice leaves memories rather than score.

- [ ] **Step 1: Add fish and voyage record counts/recent entries**

Keep the current simple text summary; do not build tabs or image persistence yet.

- [ ] **Step 2: Preserve return-to-sea continuity**

Return to `game.tscn`; state continuity is provided by GameState rather than rebuilding a session.

---

### Task 6: Synchronize docs and verify exact PR HEAD

**Files:**
- Modify: `README.md`
- Modify: `docs/MVP_SCOPE.md`
- Modify: `docs/GODOT_MVP_ROADMAP.md`

**Interfaces:**
- Produces: repository structured canon matching implemented behavior and verification boundary.

- [ ] **Step 1: Update scope and test checklist**

Document ambient discovery, preserved in-process memory, one voyage record, optional minimal fishing, and explicitly defer fishing economy/save-file persistence.

- [ ] **Step 2: Reconcile exact HEAD with latest main**

If main moved, re-read changes and reconcile without force push.

- [ ] **Step 3: Run/observe GitHub Actions on exact HEAD**

All focused tests + project/scene smoke must be GREEN.

- [ ] **Step 4: Perform minimum five full adversarial loops**

Attack canon drift, session reset, accidental failure/economy, UI dead-end, duplicate voyage records, discovery vending behavior, fishing scope creep, mobile layout risk, and evidence overclaim.

- [ ] **Step 5: Update Notion human-facing system/benchmark/production surfaces**

Only after exact implementation behavior is known; keep Human/player evidence NOT_RUN.

- [ ] **Step 6: Merge only if current-task PR gates are clean**

Verify exact HEAD, checks, review/thread state, merge safely, then read back new main and Notion registry.