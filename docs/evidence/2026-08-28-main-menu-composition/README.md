# Main Menu Composition Runtime Evidence

Date: 2026-08-28
Issue: [#71](https://github.com/alsdmlals4-eng/MylittleBoat/issues/71)

These four 540×960 PNG files are runtime captures from `scenes/main_menu.tscn`, not presentation mockups.

| File | Selected time | Runtime proof |
| --- | --- | --- |
| `main_menu_dawn_540x960.png` | Dawn | `AtmosphereBackground` uses the approved dawn file. |
| `main_menu_bright_540x960.png` | Bright | `AtmosphereBackground` uses the approved bright file. |
| `main_menu_sunset_540x960.png` | Sunset | `AtmosphereBackground` uses the approved sunset file. |
| `main_menu_night_540x960.png` | Night | `AtmosphereBackground` uses the approved night file. |

Each capture also shows the existing `DioramaAnchor` C+dog boat composition and the unchanged identity, time, and mood entry controls. The reproducible capture runner is `tests/capture_main_menu_atmospheres.gd`; the behavior contract is `tests/test_main_menu_atmosphere_background_contract.gd`.

Human mobile comfort testing remains deferred by project decision. These captures demonstrate Godot runtime composition at the target portrait resolution only.
