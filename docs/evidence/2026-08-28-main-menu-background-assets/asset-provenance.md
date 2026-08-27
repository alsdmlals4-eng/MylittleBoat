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

Each file is `USER_APPROVED / IMPLEMENTATION_READY_ASSET`. Each Notion record contains its native PNG attachment, source/rights, SHA-256, exact runtime path, and the immutable Git locator below.

| Asset ID | Notion Asset Library record | Durable Git locator |
| --- | --- | --- |
| `MLB_MAIN_MENU_DAWN_BACKGROUND_V1` | [Dawn](https://app.notion.com/p/3c91b237eb1c81499ffafe1b03c534d9?pvs=204) | commit `e60d93f1337d1026820f7608dc35709dd873c36f`, blob `14342d8646f8534ec8b932ec298fd7b52afdafdd` |
| `MLB_MAIN_MENU_BRIGHT_BACKGROUND_V1` | [Bright](https://app.notion.com/p/3c91b237eb1c81b7b205c91781db9a73?pvs=204) | commit `e60d93f1337d1026820f7608dc35709dd873c36f`, blob `56d567abe54d80b3a106030cb46b9f12b4b3bdfe` |
| `MLB_MAIN_MENU_SUNSET_BACKGROUND_V1` | [Sunset](https://app.notion.com/p/3c91b237eb1c813bace7e6c6561b2378?pvs=204) | commit `e60d93f1337d1026820f7608dc35709dd873c36f`, blob `c165921669df2f2ec9a183427d383f1770f0c818` |
| `MLB_MAIN_MENU_NIGHT_BACKGROUND_V1` | [Night](https://app.notion.com/p/3c91b237eb1c81df8688f0e3854f1378?pvs=204) | commit `e60d93f1337d1026820f7608dc35709dd873c36f`, blob `10fd53fddc54ab879633b7b182de9640d49c3300` |
