# Final 2.5D Storybook Art Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** C 주인공, 강아지, 보트의 final storybook art card 세 개를 기존 Godot 디오라마에 연결한다.

**Architecture:** 각 투명 PNG는 `assets/images/runtime/storybook/`에 정본 후보로 보관하고, 기존 visual owner 아래의 `Sprite3D`가 소비한다. `StorybookArtCard`는 PNG가 유효하면 카드를 보여 주고 그렇지 않으면 현 mesh fallback을 보여 준다. 게임 데이터와 기존 owner API는 바꾸지 않는다.

**Tech Stack:** Godot 4.7, GDScript, Sprite3D, built-in image generation, PNG alpha validation.

**Spec:** `docs/superpowers/specs/2026-08-26-final-2p5d-storybook-art-design.md`

## Global Constraints

- 새 runtime PNG는 C, dog, boat 단 세 개이며 투명 배경·sRGB·문자/로고/프레임 없음이 필수다.
- 원본 시안은 visual reference로만 사용한다.
- placeholder, care-free pet, decor slots, camera semantics, PR #19를 변경하지 않는다.
- user runtime visual approval 전에는 final art/Notion registration 완료 상태를 기록하지 않는다.

---

### Task 1: Create and record three alpha art candidates

**Files:**
- Create: `assets/images/runtime/storybook/c_default_storybook.png`
- Create: `assets/images/runtime/storybook/dog_default_storybook.png`
- Create: `assets/images/runtime/storybook/boat_default_storybook.png`
- Create: `docs/evidence/2026-08-26-final-2p5d-storybook-art/asset-provenance.md`

**Interfaces:**
- Consumes: the approved C+dog visual direction.
- Produces: three project-local PNGs and their exact prompts, dimensions, alpha result, SHA-256, and provenance.

- [ ] **Step 1: Generate C character art**

Generate one 1024×1024 transparent-background storybook card of a relaxed seated 3/4 rear-side C protagonist. Require long wavy dark-brown hair, cream cable-knit sweater, muted slate-blue skirt, brown ankle boots, tiny gold pendant, neutral daylight, full body, generous transparent margin, and no boat/pet/ocean/text/frame/shadow.

- [ ] **Step 2: Generate dog art**

Generate one 1024×1024 transparent-background storybook card of a small dog resting low in a 3/4 side view. Require beige fur, floppy dark-brown ears, subtle brown back patch, rounded calm silhouette, generous transparent margin, and no cushion/boat/person/ocean/text/frame/shadow.

- [ ] **Step 3: Generate boat art**

Generate one 1536×1024 transparent-background storybook card of an empty small wooden boat in 3/4 elevated side view. Require warm dark hull, lighter deck, low rail, rounded friendly silhouette, only subtle plank seams, generous transparent margin, and no people/dog/decor/water/text/frame/shadow.

- [ ] **Step 4: Inspect and persist selected output**

Use `view_image` to reject any result with opaque background, text, frame, crop, or dropped shadow. Copy only the accepted output to the exact three project paths. Add prompts, `generated-reference-only` provenance, dimensions, alpha result, and `Get-FileHash -Algorithm SHA256` values to `asset-provenance.md`.

- [ ] **Step 5: Commit candidates**

```powershell
git add assets/images/runtime/storybook docs/evidence/2026-08-26-final-2p5d-storybook-art/asset-provenance.md
git commit -m "Add storybook art card candidates"
```

### Task 2: Add an art-card fallback boundary and its contract

**Files:**
- Create: `scripts/visual/storybook_art_card.gd`
- Create: `tests/test_storybook_art_card_contract.gd`

**Interfaces:**
- Consumes: `Sprite3D.texture` and `fallback_nodes: Array[NodePath]`.
- Produces: `refresh_visual()` that exposes the card when a texture exists and existing fallback `VisualInstance3D` nodes otherwise.

- [ ] **Step 1: Write the failing scene contract**

Load `res://scenes/boat_space.tscn`. Expect `ArtCard` `Sprite3D` nodes at the existing C, dog, and hull visual-owner paths. Assert a non-null texture, non-disabled billboard, and `refresh_visual` on each card.

- [ ] **Step 2: Run the red test**

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --script res://tests/test_storybook_art_card_contract.gd
```

Expected: failure because no `ArtCard` nodes exist.

- [ ] **Step 3: Implement the minimal script**

```gdscript
# 스토리북 아트 카드와 기존 메시 fallback의 표시 상태를 전환한다.
extends Sprite3D

@export var fallback_nodes: Array[NodePath] = []

func _ready() -> void:
	refresh_visual()

func refresh_visual() -> void:
	var has_art := texture != null
	visible = has_art
	for fallback_path in fallback_nodes:
		var fallback := get_node_or_null(fallback_path) as VisualInstance3D
		if fallback != null:
			fallback.visible = not has_art
```

- [ ] **Step 4: Run the script contract**

Run the focused test again. Expected: parser/script failure is gone and only missing scene-card assertions remain.

- [ ] **Step 5: Commit the boundary**

```powershell
git add scripts/visual/storybook_art_card.gd tests/test_storybook_art_card_contract.gd
git commit -m "Add storybook art card fallback contract"
```

### Task 3: Wire C, dog, and boat cards into BoatSpace

**Files:**
- Modify: `scenes/boat_space.tscn`
- Modify: `tests/test_storybook_art_card_contract.gd`
- Test: `tests/test_handpainted_visual_slice_contract.gd`
- Test: `tests/test_diorama_avatar_camera_contract.gd`
- Test: `tests/test_runtime_image_asset_contract.gd`

**Interfaces:**
- Consumes: three asset paths and `StorybookArtCard`.
- Produces: textured `ArtCard` Sprite3D consumers within existing C/dog/hull owners.

- [ ] **Step 1: Extend the red test**

Require these exact paths:

```gdscript
"res://assets/images/runtime/storybook/c_default_storybook.png"
"res://assets/images/runtime/storybook/dog_default_storybook.png"
"res://assets/images/runtime/storybook/boat_default_storybook.png"
```

Also require the current mesh children to remain present as fallbacks.

- [ ] **Step 2: Run the red test**

Run `test_storybook_art_card_contract.gd`. Expected: missing-card and texture-path failures.

- [ ] **Step 3: Add three `Sprite3D` nodes**

Add three ext-resource textures and the script resource to `boat_space.tscn`. Under each `StorybookCDefault`, `StorybookDogDefault`, and `StorybookHullPass`, add `ArtCard` with its exact texture, enabled billboard, tuned pixel size, no new gameplay owner, and fallback paths only to sibling mesh nodes.

- [ ] **Step 4: Run focused regressions**

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --script res://tests/test_storybook_art_card_contract.gd
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --script res://tests/test_handpainted_visual_slice_contract.gd
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --script res://tests/test_diorama_avatar_camera_contract.gd
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --headless --path . --script res://tests/test_runtime_image_asset_contract.gd
```

Expected: all pass without changing the existing decor image paths.

- [ ] **Step 5: Commit integration**

```powershell
git add scenes/boat_space.tscn tests/test_storybook_art_card_contract.gd
git commit -m "Render final storybook art cards"
```

### Task 4: Capture runtime evidence and preserve the human asset gate

**Files:**
- Modify: `tests/capture_first_production_visual_slice.gd`
- Create: `docs/evidence/2026-08-26-final-2p5d-storybook-art/normal_540x960.png`
- Create: `docs/evidence/2026-08-26-final-2p5d-storybook-art/appreciation_540x960.png`
- Modify: `README.md`
- Modify: `docs/GODOT_MVP_ROADMAP.md`
- Modify: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`

**Interfaces:**
- Consumes: the three scene art-card consumers and existing capture driver.
- Produces: reproducible images and a runtime-capture status only.

- [ ] **Step 1: Set only the capture evidence directory**

Set `res://docs/evidence/2026-08-26-final-2p5d-storybook-art` as the output directory; retain existing normal/appreciation inputs and 540×960 window size.

- [ ] **Step 2: Import and capture**

```powershell
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --editor --headless --path . --quit
& "C:\Users\user\Downloads\Godot_v4.7-stable_win64.exe\Godot_v4.7-stable_win64_console.exe" --path . --resolution 540x960 --script res://tests/capture_first_production_visual_slice.gd
```

Expected: normal and appreciation PNG evidence is created in the new directory.

- [ ] **Step 3: Run the full Godot gate**

Run every `tests/test_*.gd` script followed by main menu, game, and album headless scene smokes. Run `git diff --check`. Expected: all contract scripts and three smokes pass.

- [ ] **Step 4: Record only pending-approval status**

Record the capture directory and set all three `FINAL_*_ART` fields to `RUNTIME_CAPTURE_AWAITING_HUMAN_APPROVAL`. Keep `REAL_DEVICE_TOUCH_QA = DEFERRED_BY_USER`. Do not create Notion final records in this task.

- [ ] **Step 5: Commit and push reviewable evidence**

```powershell
git add tests/capture_first_production_visual_slice.gd docs/evidence/2026-08-26-final-2p5d-storybook-art README.md docs/GODOT_MVP_ROADMAP.md docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md
git commit -m "Capture final storybook art pass"
git push -u origin codex/final-2p5d-art-pass
```

### Task 5: Register only user-approved final assets

**Files:**
- Modify after approval only: `docs/evidence/2026-08-26-final-2p5d-storybook-art/asset-provenance.md`
- Modify after approval only: `README.md`, `docs/GODOT_MVP_ROADMAP.md`, `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`

**Interfaces:**
- Consumes: explicit visual approval of both runtime captures and the three project-local PNGs.
- Produces: individual Notion Asset Library records with SHA-256, provenance, exact consumer path, and a durable binary locator.

- [ ] **Step 1: Obtain visual approval from the two captures**

If a visual change is requested, return to Task 1 or Task 3. Do not create final asset records first.

- [ ] **Step 2: Fresh-read and register approved assets in Notion**

Create one final record per accepted image with exact local path, SHA-256, generation provenance, runtime consumer, and a retrievable durable binary locator.

- [ ] **Step 3: Set post-registration status**

After all three records and locators pass, set each of `FINAL_AVATAR_ART`, `FINAL_PET_ART`, and `FINAL_BOAT_SEA_ART` to `USER_APPROVED_NOTION_REGISTERED_LOCATOR_PASS`. Keep real-device QA deferred.
