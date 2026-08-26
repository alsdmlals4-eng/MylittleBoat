# Four-Time Atmosphere Layer Design

**Status:** `APPROVED_CONTRACT_CONTINUATION / IMPLEMENTATION_READY`

## Goal

Let a player choose the light of the next voyage — `새벽`, `밝음`, `해질녘`, or `밤` — while keeping one boat, one sea, one horizon, the visible player/pet pair, the five-minute voyage, and every existing low-pressure rule unchanged.

## Player promise

Before choosing today’s mood, the player may choose a quiet light. The choice frames the same familiar place rather than creating a different level or a better/worse run. Bright remains the default. A voyage always remains calm if the player never changes the selector.

- **Meaningful choice:** emotional framing and self-expression only.
- **Trade-off:** deliberately none in mechanics. Time, rewards, affection, fishing, discoveries, decor, speed, camera behavior, and soundscape priority do not change.
- **Expected result:** Normal Diorama and Appreciation Camera share the selected atmosphere.
- **Failure/learning:** there is no failure state. An invalid or absent value safely returns to Bright.

## Confirmed inputs and reuse preflight

| Input | Decision | Consumer |
| --- | --- | --- |
| Approved four-state canon | `REUSE_AS_IS` | time-of-day labels and tone intent |
| `sea_bright_storybook.png` | `REUSE_AS_IS` | unchanged Bright base; gently modulated other states |
| C + dog default and cosmetic identity routing | `PRESERVE` | same player/pet/boat composition |
| Existing `RestingSoundscape` OceanBed | `PRESERVE` | no new audio binary or mix system in this bounded slice |
| Existing game scene cameras | `REUSE_AS_IS` | both receive the same backdrop modulation |
| Approved Dawn/Sunset postcard sources | `P2_HOLD` | no postcard variants or new consumers |

No image binary, shader, add-on, paid service, second scene/map, continuous clock, weather system, audio file, progression item, or social behavior is created by this slice.

## Alternative study

| Option | Value | Risk | Decision |
| --- | --- | --- | --- |
| A. Selected per-voyage preset with shared color/light treatment | Makes the approved four states immediately visible, retains Bright art, and has a small reversible state boundary | Human comfort still requires later mobile review | **Adopt** |
| B. Four rendered scene backdrops | Highest art specificity | Duplicates location/layout, creates more binary/provenance work, and can turn states into separate maps | Reject |
| C. Automatic real-time or continuous day-night clock | Natural-sounding discovery | Changes session meaning and adds timing/persistence/QA scope before evidence supports it | Reject |

**Differentiation:** the atmosphere is a permission to rest in a chosen light, not a time pressure, weather challenge, or collectible variant. Reconsider only after real-device comfort evidence shows that discrete selection interrupts the restful entry flow.

## Scope

### In scope

1. A `TimeOfDayCatalog` with exactly four ordered IDs: `dawn`, `bright`, `sunset`, `night`.
2. Process-lifetime `GameState.selected_time_of_day`, defaulting and normalizing to `bright`.
3. A compact Main Menu `오늘의 빛` selector. It changes no mood, identity, memory, reward, or save file.
4. One shared time-of-day visual treatment in `game.tscn` / `game_scene.gd`:
   - Environment background + ambient color/energy.
   - Directional key-light color/energy.
   - The two camera-local sea backdrop `Sprite3D` modulation colors.
   - Existing mood tint remains a subtle secondary variation over the chosen time-of-day base.
5. Automated contract tests for catalog/state, menu behavior, and visible game-scene differentiation.
6. 540×960 automated runtime captures for all four states in Normal and Appreciation modes.
7. Repository/Notion handoff and roadmap readback.

### Explicit exclusions

- Automatic/real-clock day cycle, in-voyage switcher, persistence across app restarts, or unlocks.
- Different maps, camera positions, boat layouts, props, identity defaults, or postcard variants.
- New raster images, dynamic shaders, post-processing, star particles, lantern behavior, music, or sound effects.
- Changes to voyage duration, speed, reward, affection, fishing, discovery, decor, interaction, social, or mobile UX behavior.
- Human/mobile QA. The user has deferred this; it remains clearly `NOT_RUN`.

## Technical contract

### Data boundary

`scripts/voyage/time_of_day_catalog.gd` is the single source for the allowed ID order, display labels, and visual tone definitions. `GameState` owns only the current selected ID and normalizes through the catalog.

```gdscript
func select_time_of_day(value: String) -> void
func get_selected_time_of_day() -> String
```

`bright` is the only default/fallback. The selection lasts scene transitions within the running process; it intentionally does not write a new save file.

### Scene boundary

`main_menu.tscn` adds one `OptionButton` named `TimeOfDayOption` below the identity entry and above the mood prompt. Starting any mood begins the voyage with the already selected time ID.

`game_scene.gd` applies time-of-day first, then applies the existing mood color to the environment background. Both `SeaBackdrop` nodes must receive the same modulate color, so the inactive camera never becomes stale.

### Visual values

All values are implementation-level, deliberately restrained candidates rather than final art direction approval. They must satisfy the approved intent:

| State | Visual intent | Required guardrail |
| --- | --- | --- |
| Dawn | cool teal / pale lavender, very quiet first light | horizon remains legible; no fog/rays |
| Bright | powder blue / soft aqua neutral baseline | the existing art stays unmodulated |
| Sunset | muted peach / dusty rose / amber | no orange spectacle or blown highlights |
| Night | dusty blue / deep teal with safe low contrast | sea/horizon remain visible; no pure black/neon |

## Acceptance criteria

- The catalog exposes exactly the four approved IDs in the approved order, labels each, and falls back to Bright.
- A fresh run starts at Bright and no time choice creates persistence, rewards, or penalties.
- Choosing a menu time updates only `GameState.selected_time_of_day`; mood, identity, affection, and album counts stay unchanged.
- Starting a voyage preserves that selected time across the scene change.
- Bright does not modulate the approved Bright sea backdrop.
- Dawn, Sunset, and Night visibly differ from Bright in both scene cameras while retaining the same texture, camera setup, boat, player, pet, and horizon.
- Mood still produces a small observable environment difference within a selected time state.
- Existing automated contracts and Main Menu/Game smokes pass with no task-related parser or resource-loader errors.
- Runtime captures demonstrate four states × two camera modes at 540×960. They are automation evidence only; human/mobile comfort remains `NOT_RUN`.

## Validation and rollback

Run Godot import, the new focused contracts, all existing contracts, and Main Menu/Game scene smokes. Capture the same scene in each time/camera pair after automated setup. No manual phone check is required in this slice.

Rollback is one current-task PR revert: remove the catalog, menu selector, GameState selection, visual application, tests, captures, and status documentation. Existing Bright art remains untouched.

