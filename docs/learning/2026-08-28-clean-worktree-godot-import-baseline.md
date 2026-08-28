# Clean Worktree Godot Import Baseline · 2026-08-28

## Incident

A first `Godot 4.7.2 --headless --path . --quit` in a new clean worktree exited `0` but logged PNG preload/resource-loader errors because the ignored `.godot` import cache had not yet been created.

## Solution

Run `Godot 4.7.2 --headless --path . --editor --quit` once to scan/import project files before treating a direct headless quit or Scene smoke as meaningful. The repeat direct headless quit then completed with exit `0` and only the pre-existing two-ObjectDB cleanup warning.

## Lesson and disposition

- This is an environment/bootstrap observation, not a game defect and not a source change.
- `NO_BASE_PROMOTION`: the finding is Godot-import-cache and local-toolchain specific, with one project observation only. Base keeps the generic fresh-worktree verification rule; this project handoff carries the exact Godot command.
