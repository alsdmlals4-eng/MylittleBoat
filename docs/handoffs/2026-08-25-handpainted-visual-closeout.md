# My Little Boat — Handpainted Visual Closeout Handoff

## Receiver acknowledgement contract

새 채팅/새 작업자는 이 문서를 읽은 뒤 아래 5개를 fresh-read하고 작업을 시작한다.

1. `AGENTS.md`
2. 현재 `main`
3. open PR inventory, 특히 PR #19
4. Notion `마이 리틀 보트 · Home` / `02 · 비주얼 바이블` / `04 · 에셋 라이브러리` / `06 · Production · Handoff`
5. 최신 Base completed main과 현재 작업에 필요한 owner

첫 응답에서 이 문서의 값만 믿고 구현하지 말고, 위 항목의 현재 readback이 일치하는지 확인한다. 불일치하면 최신 권위가 우선한다.

## Durable resume identity

- project: `MY_LITTLE_BOAT`
- repository: `alsdmlals4-eng/MylittleBoat`
- handoff baseline main: `e312f9f764051c8a4b25bd6206174498f5353c8e`
- current detailed visual canon: `HANDPAINTED_STORYBOOK_3D_DIORAMA`
- parent visual philosophy: `SOFT_STORYBOOK_3D_DIORAMA`
- normal presentation: visible avatar + resting pet + personal boat + sea in calm 3/4 diorama
- alternate view: `Appreciation Camera`
- current approved background time-of-day set: `새벽 / 밝음 / 해질녘 / 밤`
- runtime engine baseline: Godot 4.7 stable / GDScript

## Approved visual evidence

### Visual Proof 01

- state: `APPROVED_PRODUCTION_VISUAL_PROOF`
- generation locator: `3dec443c-e61f-40e9-aaf6-470d35c7fde0`
- role: overall handpainted storybook 3D style, Normal/Appreciation/material language proof
- Notion: Asset Library native attachment readback PASS
- proves: style/emotion/material language accepted by user
- does not prove: final avatar/pet identity, final UI, runtime geometry/shader, mobile/Human runtime quality

### Visual Proof 02

- state: `APPROVED_PRODUCTION_VISUAL_PROOF_02`
- generation locator: `d9b1a3a9-ae11-4873-b8b2-69264236b38a`
- original PNG: `1536x1024`
- original PNG SHA-256: `b79004f60cb79241dca16c0d4eaf367c9e6a1e9f38aaaae1bc043e275d2d518e`
- role: player silhouette / pet companion / boat living-space & decor exploration
- Notion delivery: preview-only Notion-native attachment + original provenance metadata
- proves: user accepts the exploration board as production visual proof
- does not canonize: final player gender/age/hair/clothing, final pet species, final decor set, exact palette/UI/shader/runtime geometry

## Visual canon details to preserve

- 3D architecture remains; do not convert the project to full 2D.
- final frame should read closer to a moving illustrated storybook than glossy CG.
- silhouette before face.
- minimal face details at mobile gameplay distance.
- hair in 2–4 broad painted masses rather than glossy strands.
- hand-painted albedo, matte-biased materials, broad value grouping, restrained specular.
- sea/horizon remains more important than character beauty, prop density, or UI decoration.
- pet is a quiet resting companion, not a chore system or attention-seeking mascot.
- decor should make the boat feel personal and memory-bearing without turning into inventory optimization.
- no runtime generative AI.

## Background time-of-day canon

Four approved states:

1. `DAWN / 새벽` — cool teal / pale lavender, restrained first light, very quiet.
2. `BRIGHT / 밝음` — powder blue + soft aqua, clearest neutral default.
3. `SUNSET / 해질녘` — muted coral / peach / amber, reflective but not saturated spectacle.
4. `NIGHT / 밤` — dusty blue / deep teal with small warm lantern/cabin light; avoid pure black/neon contrast.

These are atmosphere layers on the same boat/sea/horizon space, not separate maps. Exact clock behavior, selection/automatic rules, palette values, shader parameters, and sound mix are still undecided.

## Current runtime/product state

Merged technical slices before this handoff:

- Calm Voyage + optional Fishing
- Resting Core technical prototype
- visible Avatar + 3/4 Diorama + Appreciation Camera
- BoatSpace + 8-slot Boat Decoration
- reusable Low-pressure Interactable

Evidence ceiling remains strict:

- final handpainted runtime slice: `NOT_RUN`
- final Avatar art: `NOT_INTEGRATED`
- final Pet art: `NOT_INTEGRATED`
- final Boat/Sea art: `NOT_INTEGRATED`
- 30s/5m Human visual comfort: `NOT_RUN`
- real mobile portrait/input QA: `NOT_RUN`
- motion/performance human QA: `NOT_RUN`
- app-restart decor persistence: `NOT_IMPLEMENTED`

## Open PR boundary

PR #19 `Implement deterministic local social fake backend` is a pre-existing independent workstream.

- state at handoff: `OPEN`
- head: `1dc768485ece548c01589d9814851b862ac50e10`
- base lineage predates current main
- final recorded CI: run #139 SUCCESS
- policy: `READ_ONLY / NO ABSORPTION` unless a future user explicitly authorizes PR #19 work

Do not rebase, merge, close, modify, or absorb PR #19 as part of visual work.

## Next visual work

User prefers image work in groups of three, but project image policy still requires an explicit text brief approval before each generated result. Use one approved result containing up to three clearly separated studies when that satisfies the user’s “3 at a time” preference without bypassing the one-result approval gate.

Next recommended visual batch after fresh-read:

1. time-of-day comparison — `새벽 / 밝음 / 해질녘`
2. follow-up night + lantern/lived-in lighting study
3. player silhouette narrowing / pet species narrowing / decor memory-language refinement as decisions become ready

Do not generate final production assets in bulk before the current visual proof is translated into a small Godot production slice and checked at target mobile scale.

## Next production slice

Bounded implementation proof:

- one neutral handpainted test player
- temporary resting-pet treatment without species canonization
- existing boat material pass
- sea/sky treatment
- one small decor cluster
- Normal vs Appreciation Camera comparison
- then add four time-of-day lighting states as a separate bounded layer

Success question is not merely “is it pretty?” It is whether the runtime still looks authored/handpainted at 540x960, preserves sea-first composition, survives bob/idle motion, and is feasible for one developer to repeat.

## Notion durable surfaces

- Human Home: `3c41b237-eb1c-8194-8b8e-d88362cafafa`
- Visual Bible: `3c11b237-eb1c-81ae-97f3-dc28a0905304`
- Asset Library: `3c11b237-eb1c-8120-b7db-d48e11756146`
- Production Handoff: `3c11b237-eb1c-81b0-b281-ec54d67c9552`
- AI Evidence: `3c61b237-eb1c-812f-a9f5-f5a116a98370`

Human Home should remain readable and free of raw PR/SHA/tool/debug metadata except when it directly helps a human understand project status. Exact evidence belongs in AI/System or Production surfaces.

## Notion image delivery rule learned here

When connector-native local binary upload is unavailable and a low-resolution human-facing preview is sufficient:

`approved raster -> downscale/compress preview -> embed preview as data URI in UTF-8 SVG -> create-attachment(content) -> consume returned file-upload:// -> destination fetch -> Notion-owned prod-files-secure readback`

Always preserve original raster provenance separately and mark the SVG path as preview-only. `SERVER_READBACK_PASS != HUMAN_VISIBLE_CLIENT_PASS` and preview delivery is not high-resolution source delivery.

This pattern already exists in Base BCP-2026-032; My Little Boat is an independent corroborating project case, not a reason to create a duplicate BCP.

## Resume idempotency

If a future chat sees that Visual Proof 01/02 and the four time-of-day canon already exist, do not recreate or re-upload them. Fresh-read the durable surfaces, then continue from the first still-unapproved/NOT_RUN gate.

## Pending decisions

Do not infer these without user approval or runtime evidence:

- final player identity
- final pet species
- exact day-cycle behavior (real clock / voyage-selected / player-selected / hybrid)
- exact palette/shader implementation
- exact UI treatment
- final representative Visual GDD hero
- production audio selection
- real social backend provider/security rollout

## Receiver ack template

A new chat can start with:

`Handoff readback complete: main=<fresh SHA>, PR19=<fresh state/head>, visual canon=HANDPAINTED_STORYBOOK_3D_DIORAMA, approved proofs=<fresh count>, time-of-day canon=새벽/밝음/해질녘/밤. No stale conflict found / conflicts listed below. I will continue from <first unresolved gate>.`
