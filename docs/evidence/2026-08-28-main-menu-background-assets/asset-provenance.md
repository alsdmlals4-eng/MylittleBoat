# Main Menu Atmosphere Background Assets · Provenance

The user explicitly authorized production of the concrete P0 `MLB-SCR-001` main-menu atmosphere backgrounds on 2026-08-28. These are opaque scenic layers only. The existing boat, visible player, and companion remain separate Godot runtime layers, so no generated image hard-codes a character or pet selection.

| Asset ID | Local path | Runtime role | Output | SHA-256 |
| --- | --- | --- | --- | --- |
| `MLB_MAIN_MENU_DAWN_BACKGROUND_V1` | `assets/images/ui/main_menu/main_menu_dawn_storybook_v1.png` | selected `dawn` menu atmosphere | 1024×1536, RGB sRGB, opaque | `68b537c9815c95bf04dc0ba13ecbca5909e2bd196c9a3aa7a89e27981b89c39e` |
| `MLB_MAIN_MENU_BRIGHT_BACKGROUND_V1` | `assets/images/ui/main_menu/main_menu_bright_storybook_v1.png` | selected `bright` menu atmosphere | 1024×1536, RGB sRGB, opaque | `7ed8ca5101c803344a78bb8a39d2e7545899bc8f7a8d59ff66be346da787d0d5` |
| `MLB_MAIN_MENU_SUNSET_BACKGROUND_V1` | `assets/images/ui/main_menu/main_menu_sunset_storybook_v1.png` | selected `sunset` menu atmosphere | 1024×1536, RGB sRGB, opaque | `3e4901fdcefb771ad5200c75a26b2b74e5fced95ad01e345e00e677423d86a3a` |
| `MLB_MAIN_MENU_NIGHT_BACKGROUND_V1` | `assets/images/ui/main_menu/main_menu_night_storybook_v1.png` | selected `night` menu atmosphere | 1024×1536, RGB sRGB, opaque | `5669220c5e0f39cbb365748a2bc9883c67aa1d14c51b7c8068f51bc72e196c30` |

## Generation and review

- Tool: built-in image generation, using the approved Bright sea/boat layers and the user-approved hand-painted storybook 3D-diorama direction as visual references.
- Prompts: a Bright portrait sea/sky composition with open UI and boat-layer space, then Dawn, Sunset, and Night lighting-only variants from the Bright composition.
- Kept: stable horizon, rounded cloud/island language, matte hand-painted surface, broad quiet sea, empty upper UI zone, and empty lower-center boat layer zone.
- Excluded: boat, player, pet, lantern, foreground props, UI, title, lettering, logo, watermark, borders, drop shadows, glossy CG, and character-specific baked content.
- Runtime review: direct visual inspection confirms all four images are scene-only, distinct by time of day, and preserve compositing space. Godot import/wiring and 540×960 runtime proof are deliberately still pending the P0 UI implementation slice.

## Registration and durable locator

Each file is `USER_APPROVED / IMPLEMENTATION_READY_ASSET` on creation. Individual Notion Asset Library records, Notion-native file attachments, and immutable Git commit/blob locators are appended after the binary-only delivery commit is pushed.
