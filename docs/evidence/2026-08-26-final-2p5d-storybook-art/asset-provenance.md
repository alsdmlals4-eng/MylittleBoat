# Final 2.5D Storybook Art Provenance

The two visible runtime assets below are user-approved, registered in Notion Asset Library, and have durable Git binary locators. The earlier separate C/player/dog/boat cards remain local candidate source material only. User-provided boards were used only as high-level silhouette, clothing, palette, and cozy-storybook references. No source board was copied into the game.

| Asset | Local path | Normalized output | Alpha result | SHA-256 |
| --- | --- | --- | --- | --- |
| C protagonist | `assets/images/runtime/storybook/c_default_storybook.png` | 1024×1024 RGBA sRGB | PASS, four corners alpha 0 | `847A2520937E0D7581545A1531F96C57A574BC0EE1C10DFB7366954A04FD97AC` |
| Resting dog | `assets/images/runtime/storybook/dog_default_storybook.png` | 1024×1024 RGBA sRGB | PASS, four corners alpha 0 | `0EE3481BD7FFFB2B7263F4B95EB1D3A14E30C34A7EFF03F0D4B933F9EDCC33E5` |
| Wooden boat | `assets/images/runtime/storybook/boat_default_storybook.png` | 1536×1024 RGBA sRGB | PASS, four corners alpha 0 | `B678F36490B323E94DCB1D4F6C30885935A2262A27444AB96E8999544E67D512` |
| Bright sea backdrop | `assets/images/runtime/storybook/sea_bright_storybook.png` | 1536×1024 RGB sRGB | opaque background asset | `2B174E0F66C98672F5527411EA0CA43FDE9DBB93957696614158FCB895A3BDEC` |
| C + dog boat diorama | `assets/images/runtime/storybook/boat_c_dog_diorama_storybook.png` | 1536×1024 RGBA sRGB | PASS, four corners alpha 0 | `E6A197C68F08BCE6E1EABC37A5390598BA19174124C5B0E4EDA4C2000F5481FD` |

## Final asset registration

| Asset | Notion Asset ID | Notion record | Durable Git locator |
| --- | --- | --- | --- |
| C + dog boat diorama | `MLB_FINAL_2P5D_C_DOG_BOAT_RUNTIME_V1` | `https://app.notion.com/p/3c81b237eb1c81f68a10c697b597a1e1` | commit `0b423b30b3520225ce4472b0a5c532c1e79426cf`, blob `1ee78b0159c8f799ab65d14f384e45729e3083e5`, `assets/images/runtime/storybook/boat_c_dog_diorama_storybook.png` |
| Bright sea backdrop | `MLB_FINAL_2P5D_BRIGHT_SEA_RUNTIME_V1` | `https://app.notion.com/p/3c81b237eb1c810b8febc80842357348` | commit `0b423b30b3520225ce4472b0a5c532c1e79426cf`, blob `febffc1db94639638b5c93b532497c36f0d58d2f`, `assets/images/runtime/storybook/sea_bright_storybook.png` |

## Generation provenance

- Tool: built-in image generation.
- Asset role: `generated-reference-only` candidate for a camera-facing 2.5D `Sprite3D` layer in the current Godot boat diorama.
- C prompt summary: seated 3/4 rear-side C protagonist with long dark-brown hair, cream cable-knit sweater, muted slate-blue skirt, brown boots, tiny gold pendant, matte storybook watercolor-gouache; transparent exterior; no scenery, props, text, frame, glow, or shadow.
- Dog prompt summary: calm low resting full-body dog with warm beige fur, floppy dark-brown ears, and a subtle brown back patch; matte storybook watercolor-gouache; transparent exterior; no scenery, props, text, frame, glow, or shadow.
- Boat prompt summary: empty rounded small wooden boat in elevated 3/4 view with dark walnut hull, honey deck, and low rail; matte storybook watercolor-gouache; transparent exterior; no waterline, scenery, text, frame, glow, or shadow.
- Normalization: C and dog were composited without background onto centered 1024×1024 transparent RGBA canvases, preserving aspect ratio. Boat was retained at its native 1536×1024 RGBA size.
- Reference-aligned revision: the final runtime candidate is the transparent C + dog boat diorama card plus the opaque Bright sea backdrop. The earlier separate C, dog, and boat cards remain local candidate source material and are not the visible final composition.

## Approval and locator gate

User approval, individual Notion registration, SHA-256 provenance, runtime consumer mapping, and durable project/Git locators all passed on 2026-08-26. The raw binary URLs are pinned to the immutable commit above; after PR merge, the same project-local paths are also reachable from `main`.
