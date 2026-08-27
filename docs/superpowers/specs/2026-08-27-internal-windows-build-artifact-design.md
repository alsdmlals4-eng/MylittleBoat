# Internal Windows Build Artifact Design

## Decision

Ship one zero-cost, repository-internal Windows x86_64 debug package route for the already merged slice. GitHub Actions produces a ZIP artifact after validation. A repository user can download that artifact from the successful workflow run.

## Why this route

The current main branch has no `export_presets.cfg`, no export templates on the local host, and no Android SDK or JDK configuration. Windows desktop is the smallest reproducible path on the current host and does not claim a mobile test that has not occurred.

## Player impact

No player-facing game rule, visual, asset, input, save format, reward, or social behavior changes. The package is only a delivery route for the existing slice.

## In scope

- A single `Windows Desktop` x86_64 debug export preset.
- CI trigger on pull requests to `main`, pushes to `main`, and manual dispatch.
- GitHub Actions ZIP artifact containing the executable and matching PCK.
- Machine checks for export configuration and package contents.
- README and current handoff evidence updates.

## Out of scope

- Android, iOS, public store/release upload, signing, telemetry, analytics, new gameplay, new art/audio, and PR #19.
- Any claim of Human/mobile comfort or five-minute emotional validation.

## Acceptance criteria

1. `export_presets.cfg` contains the documented Windows-only preset with x86_64 output.
2. CI installs Godot templates and executes `--export-debug "Windows Desktop"`.
3. A successful push-to-main run exposes a `my-little-boat-windows-internal` ZIP artifact.
4. The ZIP contains `my_little_boat.exe` and `my_little_boat.pck`.
5. Existing behavior contracts and the three scene smokes remain green.
6. Documentation labels this as machine/package evidence, not Human/mobile QA.

## Risks and controls

- Export template availability: CI explicitly requests templates; local template absence is reported instead of hidden.
- Windows output on Linux CI: artifact is checked structurally only. Runtime execution remains a Windows-host verification step.
- Workflow cost/scope: one debug artifact, only current branches and manual runs; no releases or uploads outside GitHub Actions artifacts.
