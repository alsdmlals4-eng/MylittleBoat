# Generated WAV Shutdown Baseline Lesson

## Incident

Local Godot 4.7.2 headless quit for the current project exited `0` but reported one `AudioStreamWAV` and one `AudioStreamPlaybackWAV` ObjectDB leak.

## Investigation

- The project warning was reproduced after the persistent authored ocean bed was initialized.
- Stopping, clearing, and explicitly freeing its `AudioStreamPlayer` did not remove the two leak lines.
- A temporary empty Godot 4.7.2 project exited without warnings.
- The same temporary project, containing only a generated `AudioStreamWAV`, one `AudioStreamPlayer`, `play()`, `stop()`, and `free()`, reproduced exactly the same two leak lines and still exited `0`.

## Disposition

This is a Godot 4.7.2 generated-WAV shutdown baseline, not a project-owned leak. No production script, scene, resource, asset, or workflow change is warranted. The trial cleanup and its test were removed before commit.

## Recurrence guard

When a local engine shutdown warning appears after a generated-audio change, first reproduce it in a minimal project on the same engine version. Do not alter project lifecycle code merely to hide an engine-level exit diagnostic. Treat nonzero exit, user-visible runtime failure, or a project-only reproduction as a separate actionable incident.

## Base promotion disposition

`NO_BASE_PROMOTION`. The adopted Base debugging contract already requires a root-cause reproduction before a fix. This is a version-specific Godot observation rather than a reusable workflow rule.
