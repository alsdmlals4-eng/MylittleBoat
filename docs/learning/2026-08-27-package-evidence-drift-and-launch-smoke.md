# Package Evidence Drift and Launch Smoke Lesson

## Incident

The exact current `main` Windows package had already been downloaded, SHA-256 checked, and headless-smoke launched successfully, while the five-phase receipt still described its post-merge main readback as pending.

## Root cause

The receipt retained an intermediate closeout condition after package evidence was refreshed. It did not distinguish the new automated launch proof from the still-unperformed human Windows, mobile, and audio checks.

## Solution and evidence

- Bound the evidence to current `main` commit `b6752495d121a2523f871475d4720c9fb1b2e573`, GitHub Actions run `33072278953`, and artifact `9646328971`.
- Recorded matching executable/PCK `SHA256SUMS.txt` values and a packaged `--headless --quit-after 1` exit code of `0`.
- Reworded the current receipt so machine headless smoke is `PASS` while human Windows launch, mobile comfort/touch, audio, and Phase 5 remain `NOT_RUN`.

## Recurrence guard

When a package artifact is refreshed, update every current-looking receipt in the same change with both its evidence identity and its evidence class. Never let machine headless launch proof imply human play validation.

## Base promotion disposition

`NO_BASE_PROMOTION`. The adopted Base contract already requires evidence identity, truthful runtime status, and explicit human-validation boundaries. This is a project-local application of that rule.
