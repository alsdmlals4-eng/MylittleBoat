# First Production Visual Slice Design

## Goal

Use the existing Godot BoatSpace to prove a calm `HANDPAINTED_STORYBOOK_3D_DIORAMA` presentation at the real 540×960 portrait target. This is a bounded production-visual study, not final character, pet, boat, or environment art.

## Player experience

Normal play should first read as sea and stable horizon, then a player and resting companion sharing a small personal boat, followed by quiet decoration. Appreciation Camera remains the same world with less UI emphasis; it must not alter voyage, reward, or soundscape rules.

## Scope

- Add visual-only `VisualStudy` child hierarchies below the existing player placeholder, resting-pet placeholder, and boat visual owner.
- Use a few project-owned primitive meshes with opaque, matte `StandardMaterial3D` materials and broad muted values.
- Give existing decor rendering a compatible low-noise material/proportion pass without changing catalog IDs, slot rules, actions, or saved state.
- Tune the existing sea, sky, and light through current low-cost material/environment parameters only.
- Add a structural visual-slice contract, keep it in CI, and capture normal/appreciation runtime evidence at 540×960.

## Protected behavior

- Preserve `BoatSpace`, both cameras, shared boat bob, the eight decor slot IDs, and current low-pressure interaction contracts.
- Preserve voyage duration, mood meaning, rewards, local-first behavior, and camera input isolation.
- Keep the player placeholder API explicit and the pet free of care obligation.
- Keep `pet_cushion` as three cosmetic appearances and `postcard` as one Bright Boat face; no new progression or variant system.
- PR #19 remains read-only and independent.

## Visual limits

- No external asset pack, generated image, custom shader, post-process watercolor layer, transparency-based paint overlay, or new dependency.
- No final player identity, gender, age, lore, face, exact hair/clothes, pet species, final boat model, final asset pipeline, or four-time atmosphere system.
- No sea-blocking geometry, glossy showcase materials, high-frequency surface noise, rewards, chores, failure states, rarity, economy, or social features.

## Acceptance evidence

Automated checks must prove that the three `VisualStudy` layers exist, their meshes use opaque matte `StandardMaterial3D` materials, and protected behavior contracts still pass. They must not claim visual beauty, final art, device comfort, or user approval.

Runtime evidence must show Normal and Appreciation Camera at 540×960, with player, companion, boat, decor, sea, and horizon visible according to their intended hierarchy. A later user 30-second and five-minute review determines comfort/style acceptance. Real-device touch QA remains deferred.

## Expected files

- `scenes/boat_space.tscn`
- `scenes/game.tscn`
- `scripts/decor/boat_decor_slot.gd`
- `tests/test_handpainted_visual_slice_contract.gd`
- `.github/workflows/godot-validation.yml`
- `README.md`
- `docs/GODOT_MVP_ROADMAP.md`

## Validation

Run the new visual contract, existing camera/decor/interaction/game contracts, all scene smokes, and the canonical GitHub Actions workflow. Keep the existing 540×960 target authoritative; responsive checks are non-authoritative regression probes only.
