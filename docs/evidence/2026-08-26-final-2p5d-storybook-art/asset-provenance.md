# Final 2.5D Storybook Art Candidate Provenance

These are generated candidate assets for runtime review, not final approved Asset Library records. The user-provided C/player-pet and boat/sea boards were used only as high-level silhouette, clothing, palette, and cozy-storybook references. No source board was copied into the game.

| Asset | Local path | Normalized output | Alpha result | SHA-256 |
| --- | --- | --- | --- | --- |
| C protagonist | `assets/images/runtime/storybook/c_default_storybook.png` | 1024×1024 RGBA sRGB | PASS, four corners alpha 0 | `847A2520937E0D7581545A1531F96C57A574BC0EE1C10DFB7366954A04FD97AC` |
| Resting dog | `assets/images/runtime/storybook/dog_default_storybook.png` | 1024×1024 RGBA sRGB | PASS, four corners alpha 0 | `0EE3481BD7FFFB2B7263F4B95EB1D3A14E30C34A7EFF03F0D4B933F9EDCC33E5` |
| Wooden boat | `assets/images/runtime/storybook/boat_default_storybook.png` | 1536×1024 RGBA sRGB | PASS, four corners alpha 0 | `B678F36490B323E94DCB1D4F6C30885935A2262A27444AB96E8999544E67D512` |

## Generation provenance

- Tool: built-in image generation.
- Asset role: `generated-reference-only` candidate for a camera-facing 2.5D `Sprite3D` layer in the current Godot boat diorama.
- C prompt summary: seated 3/4 rear-side C protagonist with long dark-brown hair, cream cable-knit sweater, muted slate-blue skirt, brown boots, tiny gold pendant, matte storybook watercolor-gouache; transparent exterior; no scenery, props, text, frame, glow, or shadow.
- Dog prompt summary: calm low resting full-body dog with warm beige fur, floppy dark-brown ears, and a subtle brown back patch; matte storybook watercolor-gouache; transparent exterior; no scenery, props, text, frame, glow, or shadow.
- Boat prompt summary: empty rounded small wooden boat in elevated 3/4 view with dark walnut hull, honey deck, and low rail; matte storybook watercolor-gouache; transparent exterior; no waterline, scenery, text, frame, glow, or shadow.
- Normalization: C and dog were composited without background onto centered 1024×1024 transparent RGBA canvases, preserving aspect ratio. Boat was retained at its native 1536×1024 RGBA size.

## Approval gate

The SHA-256 values above are candidate provenance only. After runtime captures receive explicit user approval, each asset must be independently registered in Notion Asset Library with its final SHA-256, project locator, runtime consumer, provenance, and durable binary locator.
