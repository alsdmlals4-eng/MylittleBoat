# Incident / Solution / Lesson — Handpainted Visual Production & Notion Delivery

## Scope

Project: `MY_LITTLE_BOAT`
Date: 2026-08-25
Baseline main: `e312f9f764051c8a4b25bd6206174498f5353c8e`

## Incident 1 — Generic AI 3D look risk

### Problem

Early cozy 3D visual direction risked reading as a generic generated 3D doll: smooth materials, familiar cute-girl archetype, polished beauty render, realistic-ish pet, and decorative detail competing with the sea.

### Root cause

The visual language was specified mainly by broad mood words (`cozy`, `storybook`, `Bondee-like`) rather than production-facing constraints for silhouette, face density, material response, composition hierarchy, and repeatability.

### Alternatives considered

1. keep matte stylized 3D
2. move to full 2D handpainted game
3. keep 3D architecture but adopt handpainted storybook surface/character language
4. pixel/HD-2D alternatives

### Solution

Selected `HANDPAINTED_STORYBOOK_3D_DIORAMA` as detailed canon while preserving `SOFT_STORYBOOK_3D_DIORAMA` as parent philosophy.

Key constraints:

- 3D camera/boat/decor/interaction architecture remains
- silhouette before face
- minimal eyes/mouth at gameplay distance
- hair as broad painted masses
- hand-painted albedo and matte response
- sea/horizon remains the dominant visual priority
- pet remains a quiet resting companion

Two user-approved visual proofs were produced and preserved as approval evidence without over-canonizing final player/pet identity.

### Verification

- PR #22 merged visual canon docs to main
- Godot 4.7 validation #142 SUCCESS on exact reviewed head
- Notion Home / Visual Bible / Asset Library / AI Evidence readback
- user explicitly approved Visual Proof 01 and Visual Proof 02

### Evidence ceiling

This proves visual direction and proof approval, not final runtime art quality, mobile comfort, animation/motion quality, shader performance, or final character/pet identity.

### Lesson

For AI-assisted game visuals, “make it cozy/stylized” is too weak. The durable anti-generic contract should specify **what must dominate, what must be simplified, what must remain irregular/authored, and what is forbidden from becoming a beauty-render focal point**.

Project-only aspects such as exact boat, palette, pet candidate set, and player clothing remain project canon, not Base rules.

## Incident 2 — Batch preference vs one-result approval gate

### Problem

The user prefers working on images three at a time, while the project/Base visual generation policy requires text brief → explicit approval → exactly one result.

### Solution

Use one generated result containing up to three clearly separated study panels when the studies form one coherent approval question. Do not silently produce three independent generated outputs under one approval.

### Lesson

Batch preference can be satisfied at the **composition level** without weakening the one-result approval/evidence gate. This should be revisited if a future tool natively tracks multiple result approvals independently.

## Incident 3 — Notion local binary upload gap

### Problem

Generated PNG existed locally but current Notion `create-attachment` surface accepted UTF-8 content or public HTTPS source URL, not an arbitrary local binary path.

### Existing solution search

Base BCP-2026-032 already defines `NOTION_INLINE_SVG_RASTER_PREVIEW_FALLBACK` from another project. Therefore no duplicate workflow or new tool was built.

### Solution used

For low-resolution human-facing preview only:

`approved PNG -> downscale/compress derivative -> embed JPEG data URI in SVG -> create-attachment(content=<svg>) -> attach returned file-upload:// -> destination fetch/readback`

Original PNG provenance remained separate:

- Visual Proof 02 original: 1536x1024 PNG
- SHA-256: `b79004f60cb79241dca16c0d4eaf367c9e6a1e9f38aaaae1bc043e275d2d518e`
- generation locator: `d9b1a3a9-ae11-4873-b8b2-69264236b38a`

### Evidence ceiling

- Notion server-side attachment/readback: PASS when destination returns Notion-owned file
- high-resolution original delivery: NOT_PROVEN by preview fallback
- Android/iOS/browser human-visible rendering: NOT_RUN unless directly observed

### Lesson

Preview transport and source-asset preservation are different responsibilities. A fallback must never overwrite the original provenance or be described as high-resolution delivery.

## Incident 4 — Human Home stale status after visual approval

### Problem

After approving the first production visual proof, Human Home still said all generated candidates were reference-only.

### Solution

Updated only the human-facing status line to distinguish:

- approved production visual proof exists
- final Visual GDD/runtime asset bundle still not finalized

Raw generation IDs/hashes remain in Asset Library / AI Evidence instead of Home.

### Lesson

Every approval-state change should trigger a small **consumer drift scan**: Human Home summary, domain page, Asset Library, Production Handoff, AI Evidence, repository mirror if product meaning changed.

## Reuse / Base promotion disposition

- `NOTION_INLINE_SVG_RASTER_PREVIEW_FALLBACK`: **REUSED_EXISTING_BASE_CANDIDATE** — corroborates BCP-2026-032; do not create duplicate BCP.
- batch composition under one-result image gate: `BASE_PROMOTION_CANDIDATE`, but current evidence is one project and does not require an active Base rule change yet.
- handpainted anti-generic art language: mostly `PROJECT_ONLY`; generic principle may inform visual review guidance but exact style rules must not homogenize other projects.
- consumer drift scan after approval-state change: generalizable, but existing Base post-change/readback rules already cover the responsibility; no new Skill needed.

## Recurrence guards

1. preserve approved proof metadata separately from final runtime asset status
2. always fresh-read Home after Asset Library approval changes
3. keep Notion preview fallback explicitly preview-only
4. search Base reuse/cases before inventing a new upload bridge
5. do not let image batch preference bypass explicit approval/result count policy
6. new chats must fresh-read handoff + current main + open PR inventory before resuming
