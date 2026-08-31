# Clean Worktree Godot Import Baseline · 2026-08-28, corrected 2026-08-31

## Incident

A first `Godot 4.7.2 --headless --path . --quit` in a new clean worktree exited `0` but logged PNG preload/resource-loader errors because the ignored `.godot` import cache had not yet been created.

## Historical solution and correction

The original local workaround used `Godot 4.7.2 --headless --path . --editor --quit`. A later clean-cache audit showed that this command can terminate before all imports complete, so it is not a reliable cache-hydration gate.

The current required command is `Godot 4.7.2 --headless --path . --import`. Run it once after a deliberate `.godot/imported` reset and before resource, scene, or behavior verification. The project `AGENTS.md` and CI workflow now consume this corrected command.

## Lesson and disposition

- This is an environment/bootstrap correction, not a game-play defect. The workflow and test-artifact teardown changes are project operational changes; no game scene, asset, save schema, or player-facing behavior changed.
- The original `--editor --quit` record remains historical evidence for its observed machine state. It must not be used as the current command.
- `BASE_CASE_CANDIDATE_ONLY`: Base already owns the generic import/cache and evidence-separation rules. This project supplies one narrow command-level counterexample for review; it does not request a Base skill, module, registry, or activation change.
