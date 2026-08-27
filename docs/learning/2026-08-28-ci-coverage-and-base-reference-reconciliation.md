# Incident / Solution / Lesson — CI Coverage and Base Reference Reconciliation

## Incident

At project `main` `2f5c989fc70f9bf1fc305fc5492601a961902b2a`, the current main-menu atmosphere and album-composition contracts existed but were absent from `.github/workflows/godot-validation.yml`. The workflow therefore could not provide exact-head CI evidence for those two current surfaces. Separately, the project visual inventory retained an earlier finding that Base's screen-surface matrix was absent, while Base latest `main` `7cfc75d607d1ed4d0f8323d4389e64da93df00c8` contains that file.

Classification: `CURRENT_CANON_DRIFT / VALIDATION_COVERAGE_GAP`.

## Solution

- The existing validation workflow invokes `test_main_menu_atmosphere_background_contract.gd` and `test_album_composition_contract.gd` alongside the established focused contract suite.
- The project inventory now treats Base's `GAME_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_MATRIX.md` as the current subordinate screen-first companion and keeps the project inventory as the local consumer record.
- The correction does not alter player-facing rules, assets, social scope, or the independent open PR #19.

## Lesson

When a new current screen has a dedicated contract, merge verification must add that contract to the existing exact-head workflow before documentation describes the surface as CI-covered. Base-path availability is time-sensitive: preserve an earlier absence finding as history, but re-resolve the Base latest `main` before using it as a current routing constraint.

## Base promotion assessment

`NO_BASE_PROMOTION`: this is a project-specific correction of two omitted test entries and a changed Base-path fact. Base already owns the reusable screen-first and canonical-reference policies.
