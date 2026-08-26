# C 니트 주인공 + 강아지 스토리북 디오라마 구현 계획

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 540×960 Godot 보트 디오라마에서 C 니트·긴 머리 주인공과 강아지를 명확하게 읽히는 기본 3D 모습으로 만든다.

**Architecture:** 현재 `PlayerAvatarPlaceholder`, `RestingPetPlaceholder`, `BoatBow` owner와 모든 gameplay API는 유지한다. 각 owner의 `VisualStudy` 아래에 C 기본 주인공, 강아지, 목재 보트 실루엣을 구현하고, primitive mesh와 opaque matte `StandardMaterial3D`만 사용한다. 기존 카메라와 runtime image decor consumer는 그대로 두며 540×960 캡처와 focused contract가 표현 경계와 회귀를 확인한다.

**Tech Stack:** Godot 4.7.2 stable, GDScript, `.tscn`, `StandardMaterial3D`, Compatibility renderer, GitHub Actions.

**Spec:** `docs/superpowers/specs/2026-08-26-c-storybook-dog-default-design.md`

## Global Constraints

- Current branch is based on PR #35 visual slice; keep the work logically scoped to that visual lineage.
- Preserve `PlayerAvatarPlaceholder.is_technical_placeholder() == true` and `RestingPetPlaceholder.has_care_obligation() == false`.
- Preserve current voyage timer/rewards, both cameras' state isolation, shared BoatSpace bob, 8 decor slots, existing item IDs, texture paths, local-first behavior, and all low-pressure interactions.
- Use only project-owned primitive meshes and opaque `StandardMaterial3D` materials with `metallic = 0.0` and `roughness >= 0.8`.
- Do not add a selection UI, persistence, external asset/model, image generation, final UV texture, shader, four-time behavior, economy, chores, social changes, or changes to PR #19.
- Use C and dog source boards only as silhouette/color reference; do not import them as runtime figure textures.
- Use the local Godot executable automatically for import, runtime capture, and verification. Real-device touch QA remains deferred by the user.

---

### Task 1: Make the C + dog visual boundary fail first

**Files:**
- Modify: `tests/test_handpainted_visual_slice_contract.gd`

**Interfaces:**
- Consumes: `res://scenes/game.tscn`, `VoyageWorld/BoatSpace`, and current placeholder methods.
- Produces: a contract requiring named C/dog visual groups while retaining placeholder and care-free evidence.

- [ ] **Step 1: Add named visual group assertions**

Add the following assertions after the existing `VisualStudy` assertions:

```gdscript
var c_default := avatar.get_node_or_null("VisualStudy/StorybookCDefault") as Node3D
var dog_default := pet.get_node_or_null("VisualStudy/StorybookDogDefault") as Node3D
var hull_pass := boat.get_node_or_null("VisualStudy/StorybookHullPass") as Node3D
_expect(c_default != null, "avatar needs StorybookCDefault")
_expect(dog_default != null, "pet needs StorybookDogDefault")
_expect(hull_pass != null, "boat needs StorybookHullPass")
if c_default != null:
	for node_name in ["HairMass", "KnitMass", "SkirtMass", "LeftBoot", "RightBoot", "Pendant"]:
		_expect(c_default.get_node_or_null(node_name) is MeshInstance3D, "C default missing %s" % node_name)
if dog_default != null:
	for node_name in ["DogBody", "DogHead", "LeftEar", "RightEar"]:
		_expect(dog_default.get_node_or_null(node_name) is MeshInstance3D, "dog default missing %s" % node_name)
```

- [ ] **Step 2: Run the focused contract before scene changes**

Run:

```powershell
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_handpainted_visual_slice_contract.gd
```

Expected: FAIL only for the missing `StorybookCDefault`, `StorybookDogDefault`, and `StorybookHullPass` groups and their named silhouette meshes.

- [ ] **Step 3: Commit the RED contract**

```powershell
git add tests/test_handpainted_visual_slice_contract.gd
git commit -m "Define C and dog visual contract"
```

### Task 2: Build the C default and dog silhouettes

**Files:**
- Modify: `scenes/boat_space.tscn`
- Test: `tests/test_handpainted_visual_slice_contract.gd`

**Interfaces:**
- Consumes: the existing `PlayerAvatarPlaceholder` and `RestingPetPlaceholder` transforms/scripts, `SphereMesh_character`, and `VisualStudy` owner hierarchy.
- Produces: `VisualStudy/StorybookCDefault` and `VisualStudy/StorybookDogDefault`, all under the existing gameplay owners.

- [ ] **Step 1: Add matte material resources for the approved default**

Add `StandardMaterial3D` subresources with these names and values:

```text
Material_c_knit     albedo Color(0.82, 0.76, 0.63, 1), metallic 0.0, roughness 0.92
Material_c_skirt    albedo Color(0.32, 0.43, 0.48, 1), metallic 0.0, roughness 0.90
Material_c_hair     albedo Color(0.22, 0.14, 0.09, 1), metallic 0.0, roughness 0.90
Material_c_boot     albedo Color(0.27, 0.17, 0.10, 1), metallic 0.0, roughness 0.88
Material_c_pendant  albedo Color(0.62, 0.48, 0.24, 1), metallic 0.0, roughness 0.86
Material_dog_fur    albedo Color(0.72, 0.57, 0.38, 1), metallic 0.0, roughness 0.94
Material_dog_ear    albedo Color(0.34, 0.22, 0.13, 1), metallic 0.0, roughness 0.92
```

- [ ] **Step 2: Replace generic avatar study meshes with `StorybookCDefault`**

Keep the existing `PlayerAvatarPlaceholder` node, transform, scale, and script. Under `VisualStudy`, create `StorybookCDefault` and these `MeshInstance3D` children using existing sphere primitives plus a new low-sided `CylinderMesh` for the skirt:

```text
HairMass   = broad brown rear/side hair mass behind the head
KnitMass   = cream rounded torso at local y 0.0
SkirtMass  = muted-blue low cylinder below the knit torso
LeftBoot   = brown low mass at local x -0.18, y -0.62
RightBoot  = brown low mass at local x  0.18, y -0.62
Pendant    = small gold/wood matte sphere in front of the knit torso
```

Hide or remove only the generic visual-study meshes being replaced. Do not rename or remove `PlayerAvatarPlaceholder`, its script, or its technical-placeholder method.

- [ ] **Step 3: Replace generic companion study meshes with `StorybookDogDefault`**

Keep `RestingPetPlaceholder` and its script. Under `VisualStudy`, create `StorybookDogDefault` with elongated warm-fur `DogBody`, smaller `DogHead`, and two flattened dark-brown ear masses named `LeftEar` and `RightEar`. The silhouette rests low on the deck and uses no food, timer, meter, action, species selection state, or reward behavior.

- [ ] **Step 4: Run the focused contract and preserve behavior evidence**

Run:

```powershell
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_handpainted_visual_slice_contract.gd
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_diorama_avatar_camera_contract.gd
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_resting_core_contract.gd
```

Expected: all pass; C/dog visual groups exist, avatar remains technical placeholder, and dog remains care-free.

- [ ] **Step 5: Commit the visual-default geometry**

```powershell
git add scenes/boat_space.tscn tests/test_handpainted_visual_slice_contract.gd
git commit -m "Add C and dog storybook defaults"
```

### Task 3: Make the boat read as a personal wooden place

**Files:**
- Modify: `scenes/boat_space.tscn`
- Test: `tests/test_handpainted_visual_slice_contract.gd`

**Interfaces:**
- Consumes: `BoatBow`, the current `VisualStudy` hierarchy, `BoatDecorSlots`, and the existing material contract.
- Produces: `VisualStudy/StorybookHullPass` that remains visually separate from all decor slots.

- [ ] **Step 1: Add the named hull group and opaque wood forms**

Create `BoatBow/VisualStudy/StorybookHullPass`. Move or replace current boat visual-study meshes so this group contains `HullMass`, `DeckMass`, `LeftRailMass`, and `RightRailMass`. Use the existing warm deck material and dark wood material; keep every material opaque, non-metallic, and roughness `>= 0.8`.

- [ ] **Step 2: Preserve decor slots structurally**

Do not change these node names, their parents, positions, or `slot_id` values:

```text
BowLeft, BowRight, CenterLeft, CenterRight,
RearLeft, RearRight, RailAccent, PetCorner
```

- [ ] **Step 3: Run boat, decor, and image regression**

Run:

```powershell
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_boat_decoration_contract.gd
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_boat_life_scene_contract.gd
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_runtime_image_asset_contract.gd
```

Expected: all pass; the three cushion surface variants and the single Bright Boat postcard face still resolve at their original paths.

- [ ] **Step 4: Commit the hull pass**

```powershell
git add scenes/boat_space.tscn
git commit -m "Refine storybook boat hull pass"
```

### Task 4: Prove C + dog in the actual 540×960 runtime

**Files:**
- Modify: `tests/capture_first_production_visual_slice.gd`
- Create: `docs/evidence/2026-08-26-c-storybook-dog-default/normal_540x960.png`
- Create: `docs/evidence/2026-08-26-c-storybook-dog-default/appreciation_540x960.png`
- Modify: `README.md`
- Modify: `docs/GODOT_MVP_ROADMAP.md`
- Modify: `docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md`

**Interfaces:**
- Consumes: current main scene, `AppreciationButton`, active cameras, existing capture script, and all runtime image consumers.
- Produces: reproducible Normal/Appreciation evidence and a human-facing status that remains below user visual approval.

- [ ] **Step 1: Capture runtime evidence automatically**

Run:

```powershell
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --path . --resolution 540x960 --rendering-driver opengl3 --script res://tests/capture_first_production_visual_slice.gd
```

Copy or parameterize the capture target so the C/dog pair is saved at:

```text
docs/evidence/2026-08-26-c-storybook-dog-default/normal_540x960.png
docs/evidence/2026-08-26-c-storybook-dog-default/appreciation_540x960.png
```

- [x] **Step 2: Inspect both PNGs before documenting status**

Confirm the Normal image shows C silhouette + dog + boat + sea, and Appreciation is sea/horizon-first with only the compact exit action. If either fails, adjust only camera/visual values required by the spec, then recapture.

- [x] **Step 3: Update current status without overstating approval**

Set these values in the roadmap and current handoff:

```text
C_DOG_DEFAULT_RUNTIME_CAPTURE = PASS
C_DOG_HUMAN_VISUAL_APPROVAL = NOT_RUN
REAL_DEVICE_TOUCH_QA = DEFERRED_BY_USER
```

Add the capture directory and `test_handpainted_visual_slice_contract.gd` to README’s implementation evidence list. Do not mark final art, production asset bundle, or real-device QA complete.

- [x] **Step 4: Run final local verification**

Run:

```powershell
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --editor --headless --path . --quit
Get-ChildItem tests -Filter 'test_*.gd' | Sort-Object Name | ForEach-Object { & "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script ("res://tests/" + $_.Name); if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE } }
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --scene res://scenes/main_menu.tscn --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --scene res://scenes/game.tscn --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --scene res://scenes/album.tscn --quit-after 1
git diff --check
```

- [x] **Step 5: Commit and push the complete bounded slice**

```powershell
git add scenes/boat_space.tscn tests/test_handpainted_visual_slice_contract.gd tests/capture_first_production_visual_slice.gd docs/evidence/2026-08-26-c-storybook-dog-default README.md docs/GODOT_MVP_ROADMAP.md docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md
git commit -m "Implement C and dog storybook diorama"
git push -u origin codex/c-storybook-dog-default
```

### Task 5: Open a stacked review and retain the human visual gate

**Files:**
- No repository file changes required.

**Interfaces:**
- Consumes: the pushed `codex/c-storybook-dog-default` branch and parent PR #35 branch.
- Produces: a reviewable stacked PR with CI evidence; no automatic merge while user visual approval remains outstanding.

- [x] **Step 1: Create the stacked PR**

```powershell
gh pr create --base codex/first-production-visual-slice-impl --head codex/c-storybook-dog-default --title "Add C and dog storybook defaults" --body "C 니트·긴 머리 주인공과 강아지 기본 3D diorama를 추가합니다. PR #35를 기반으로 하며, gameplay/보상/돌봄/소셜/PR #19에는 변경이 없습니다. 540×960 runtime capture와 focused contract를 포함합니다."
```

- [x] **Step 2: Verify the exact PR head CI result**

Run:

```powershell
gh pr checks --watch
```

Expected: `Godot 4.7 validation` passes on the exact stacked PR head.

- [x] **Step 3: Request only the remaining user visual decision**

Provide the two runtime captures and ask whether C+dog, boat, and sea read as the intended moving storybook. Keep real-device touch QA explicitly deferred and do not merge either visual PR until the user chooses the merge path.
