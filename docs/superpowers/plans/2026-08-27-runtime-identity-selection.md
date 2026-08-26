# Runtime Identity Selection Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (- [ ]) syntax for tracking.

**Goal:** Let the player choose one approved avatar family and one approved resting companion, retain the choice locally, and visibly apply it to the boat diorama without changing game rules.

**Architecture:** IdentityVisualCatalog owns the seven stable IDs, Korean labels, and art-card paths. CosmeticIdentityProfile owns user://identity_profile_v1.cfg, while GameState exposes current normalized selections. A quiet main-menu panel writes those IDs, and IdentityVisualRouter selects BoatSpace cards; the existing C + dog full-diorama card remains the exact default route.

**Tech Stack:** Godot 4.7 stable, GDScript, ConfigFile, existing Sprite3D art-card presentation, headless contract scripts.

**Spec:** docs/superpowers/specs/2026-08-27-runtime-identity-selection-design.md

## Global Constraints

- Keep c_loose_knit + dog as the default pair and preserve its existing final composite art unchanged.
- Use only user://identity_profile_v1.cfg for identity; do not extend user://boat_decor_v1.cfg.
- Player IDs are exactly a_soft_hooded, b_short_cape, c_loose_knit. Pet IDs are exactly cat, rabbit, otter, dog.
- All selection changes are cosmetic. Do not change voyage time, speed, rewards, affection, memories, decor, or social state.
- Preserve PlayerAvatarPlaceholder, RestingPetPlaceholder, cameras, shared bob ownership, decor slots, and pet interaction APIs.
- New GDScript files begin with a one-line Korean role comment.
- New art assets are transparent 1024×1024 RGBA sRGB cards with no presentation canvas, full boat, second horizon, drop shadow, or baked directional-light appearance.
- Each new production asset is checked at native size and 540×960 runtime scale, saved locally, and recorded individually in Notion with SHA-256, provenance, and durable binary locator before implementation-ready status.
- PR #19 remains read-only/no-absorption.

---

## File structure

| File | Responsibility |
| --- | --- |
| scripts/identity/identity_visual_catalog.gd | Valid IDs, labels, and art-card paths. |
| scripts/core/cosmetic_identity_profile.gd | Local profile persistence and corrupt-file fallback. |
| scripts/core/game_state.gd | Process lifetime selection and profile delegation. |
| scripts/identity/identity_visual_router.gd | Route selections to BoatSpace visual cards. |
| scripts/ui/main_menu.gd, scenes/main_menu.tscn | Quiet local cosmetic selector. |
| scenes/boat_space.tscn | Existing default composite plus selectable subject cards. |
| assets/images/runtime/storybook/*.png | Five new source cards: A, B, cat, rabbit, otter. |
| tests/test_cosmetic_identity_profile.gd | Defaults, validation, isolated persistence. |
| tests/test_identity_visual_contract.gd | Runtime assets and BoatSpace route. |
| tests/test_main_menu_identity_contract.gd | UI choices and no-gameplay-side-effect contract. |

### Task 1: Add normalized identity data and an isolated profile

**Files:**

- Create: scripts/identity/identity_visual_catalog.gd
- Create: scripts/core/cosmetic_identity_profile.gd
- Create: tests/test_cosmetic_identity_profile.gd
- Modify: scripts/core/game_state.gd

**Interfaces:**

- Produces IdentityVisualCatalog.get_player_style_ids() -> Array[String], get_pet_type_ids() -> Array[String], normalize_player_style(value: String) -> String, normalize_pet_type(value: String) -> String, get_player_label(id: String) -> String, and get_pet_label(id: String) -> String.
- Produces CosmeticIdentityProfile.save(player_style_id: String, pet_type_id: String) -> Error and load() -> Dictionary, returning {"player_style_id": String, "pet_type_id": String}.
- Produces GameState.get_selected_player_style() -> String, get_selected_pet_type() -> String, set_selected_player_style(value: String) -> void, set_selected_pet_type(value: String) -> void, and set_identity_storage_path(path: String) -> void.

- [ ] **Step 1: Write the failing profile contract**

Create tests/test_cosmetic_identity_profile.gd using the deferred runner, _expect, and temporary-file cleanup pattern from tests/test_boat_decor_persistence.gd.

~~~
# 외형 프로필의 기본값·정규화·독립 저장을 검증한다.
extends SceneTree

const CATALOG_PATH := "res://scripts/identity/identity_visual_catalog.gd"
const PROFILE_PATH := "res://scripts/core/cosmetic_identity_profile.gd"
const TEST_SAVE_PATH := "user://identity_profile_contract.cfg"

func _run() -> void:
    _remove_test_save()
    var catalog = load(CATALOG_PATH).new()
    var profile = load(PROFILE_PATH).new(TEST_SAVE_PATH)
    _expect(catalog.get_player_style_ids() == ["a_soft_hooded", "b_short_cape", "c_loose_knit"], "player IDs stay approved")
    _expect(catalog.get_pet_type_ids() == ["cat", "rabbit", "otter", "dog"], "pet IDs stay approved")
    _expect(profile.load() == {"player_style_id": "c_loose_knit", "pet_type_id": "dog"}, "missing profile uses C + dog")
    _expect(profile.save("b_short_cape", "otter") == OK, "valid identity saves")
    _expect(profile.load() == {"player_style_id": "b_short_cape", "pet_type_id": "otter"}, "saved identity restores")
    _expect(profile.save("unknown", "fox") == OK, "unknown values normalize")
    _expect(profile.load() == {"player_style_id": "c_loose_knit", "pet_type_id": "dog"}, "unknown values use defaults")
    var invalid := ConfigFile.new()
    invalid.set_value("identity", "player_style_id", 42)
    invalid.set_value("identity", "pet_type_id", [])
    _expect(invalid.save(TEST_SAVE_PATH) == OK, "test writes corrupt profile")
    _expect(profile.load() == {"player_style_id": "c_loose_knit", "pet_type_id": "dog"}, "corrupt profile falls back")
    _remove_test_save()
    _finish()
~~~

- [ ] **Step 2: Run the test to verify it fails**

Run:

~~~powershell
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_cosmetic_identity_profile.gd
~~~

Expected: FAIL because the catalog/profile scripts do not exist.

- [ ] **Step 3: Write minimal catalog, profile, and GameState bridge**

Create the catalog with a Korean header and these core declarations.

~~~gdscript
# 외형 선택의 승인된 ID·표시명·런타임 이미지 경로를 제공한다.
class_name IdentityVisualCatalog
extends RefCounted

const DEFAULT_PLAYER_STYLE := "c_loose_knit"
const DEFAULT_PET_TYPE := "dog"
const PLAYER_STYLES := ["a_soft_hooded", "b_short_cape", "c_loose_knit"]
const PET_TYPES := ["cat", "rabbit", "otter", "dog"]

func normalize_player_style(value: String) -> String:
    return value if PLAYER_STYLES.has(value) else DEFAULT_PLAYER_STYLE

func normalize_pet_type(value: String) -> String:
    return value if PET_TYPES.has(value) else DEFAULT_PET_TYPE
~~~

Create CosmeticIdentityProfile as RefCounted, defaulting to user://identity_profile_v1.cfg. It writes only normalized strings under [identity] and always returns both keys after normalizing missing, typed-wrong, and unknown values.

In GameState, preload the profile, add selected_player_style, selected_pet_type, load_identity(), save_identity(), and all five interface methods. Call load_identity() from _ready() after load_boat_decor(). set_identity_storage_path only replaces the profile with a test-path instance and reloads it; it never touches boat decor, memory, or voyage data.

- [ ] **Step 4: Run profile and decor boundary checks**

Run:

~~~powershell
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_cosmetic_identity_profile.gd
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_boat_decor_persistence.gd
~~~

Expected: both PASS.

- [ ] **Step 5: Commit the state boundary**

~~~powershell
git add scripts/identity/identity_visual_catalog.gd scripts/core/cosmetic_identity_profile.gd scripts/core/game_state.gd tests/test_cosmetic_identity_profile.gd
git commit -m "Add local cosmetic identity profile"
~~~

### Task 2: Produce and register five missing subject cards

**Files:**

- Create: assets/images/runtime/storybook/avatar_a_soft_hooded_storybook.png
- Create: assets/images/runtime/storybook/avatar_b_short_cape_storybook.png
- Create: assets/images/runtime/storybook/pet_cat_storybook.png
- Create: assets/images/runtime/storybook/pet_rabbit_storybook.png
- Create: assets/images/runtime/storybook/pet_otter_storybook.png
- Modify: scripts/identity/identity_visual_catalog.gd
- Create: tests/test_identity_visual_contract.gd
- Create: docs/evidence/2026-08-27-runtime-identity-selection/asset-provenance.md

**Interfaces:**

- Produces get_player_texture_path(id: String) -> String and get_pet_texture_path(id: String) -> String. Invalid IDs return default C/dog paths.
- C and dog resolve to existing approved paths. Only A/B/cat/rabbit/otter are new source binaries.
- Each new binary receives a Notion Asset Library record and local provenance listing path, dimensions, color mode, SHA-256, source prompt/version, Notion URL, and durable locator.

- [ ] **Step 1: Write the failing asset resolver contract**

Create tests/test_identity_visual_contract.gd with the standard asynchronous SceneTree runner. Start with these constants and checks.

~~~gdscript
const CATALOG_PATH := "res://scripts/identity/identity_visual_catalog.gd"
const EXPECTED_PLAYER_PATHS := {
    "a_soft_hooded": "res://assets/images/runtime/storybook/avatar_a_soft_hooded_storybook.png",
    "b_short_cape": "res://assets/images/runtime/storybook/avatar_b_short_cape_storybook.png",
    "c_loose_knit": "res://assets/images/runtime/storybook/c_default_storybook.png",
}
const EXPECTED_PET_PATHS := {
    "cat": "res://assets/images/runtime/storybook/pet_cat_storybook.png",
    "rabbit": "res://assets/images/runtime/storybook/pet_rabbit_storybook.png",
    "otter": "res://assets/images/runtime/storybook/pet_otter_storybook.png",
    "dog": "res://assets/images/runtime/storybook/dog_default_storybook.png",
}

func _assert_asset_paths(catalog: RefCounted) -> void:
    for id in EXPECTED_PLAYER_PATHS:
        _expect(catalog.get_player_texture_path(id) == EXPECTED_PLAYER_PATHS[id], "player path stable: %s" % id)
        _expect(ResourceLoader.exists(EXPECTED_PLAYER_PATHS[id]), "player asset exists: %s" % id)
    for id in EXPECTED_PET_PATHS:
        _expect(catalog.get_pet_texture_path(id) == EXPECTED_PET_PATHS[id], "pet path stable: %s" % id)
        _expect(ResourceLoader.exists(EXPECTED_PET_PATHS[id]), "pet asset exists: %s" % id)
~~~

- [ ] **Step 2: Run the contract to verify it fails**

Run:

~~~powershell
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_identity_visual_contract.gd
~~~

Expected: FAIL because resolver methods and five files do not exist.

- [ ] **Step 3: Generate the actual runtime assets**

Use the approved C + dog storybook art as the reference boundary. Every output is 1024×1024 transparent RGBA sRGB, 3/4 seated/resting facing right, warm matte hand-painted storybook diorama treatment, with no text, UI, border, boat, sea, horizon, lantern, shadow, or presentation canvas.

Use these exact briefs.

~~~text
A: soft-hooded small traveler, cream hooded outer layer, muted teal inner layer, dark trousers, brown boots.
B: short-cape sailor traveler, muted navy cape, warm cream shirt, dark trousers, brown boots.
Cat: quiet curled cat, warm gray/tabby-neutral fur, soft low resting silhouette.
Rabbit: tucked resting rabbit, warm cream/tan fur, relaxed ears, low silhouette.
Otter: rounded warm-brown resting otter, quiet curled low silhouette.
~~~

Inspect each at 100% and in the 540×960 BoatSpace composition. Regenerate if it has filled background, canvas edge, drop shadow, dramatic pose, shiny/plastic material, or art-direction drift.

Implement explicit path and Korean-label dictionaries in the catalog. Do not use dynamic filenames or external asset discovery.

- [ ] **Step 4: Register inspected binaries in both durable locations**

For every new file, calculate SHA-256, record dimensions/color mode and generation provenance, then create one Notion Asset Library canonical record with status IMPLEMENTATION_READY, consumer IdentityVisualRouter, SHA, provenance, and durable locator. Write the same factual metadata to docs/evidence/2026-08-27-runtime-identity-selection/asset-provenance.md.

Do not duplicate or edit existing C/dog Notion records.

- [ ] **Step 5: Run the asset test and commit assets/resolver/evidence**

Run:

~~~powershell
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_identity_visual_contract.gd
~~~

Expected: PASS for all seven paths.

~~~powershell
git add assets/images/runtime/storybook/avatar_a_soft_hooded_storybook.png assets/images/runtime/storybook/avatar_b_short_cape_storybook.png assets/images/runtime/storybook/pet_cat_storybook.png assets/images/runtime/storybook/pet_rabbit_storybook.png assets/images/runtime/storybook/pet_otter_storybook.png scripts/identity/identity_visual_catalog.gd tests/test_identity_visual_contract.gd docs/evidence/2026-08-27-runtime-identity-selection
git commit -m "Add runtime identity art cards"
~~~

Do not stage generated .import or .uid files unless an already tracked source requires it.

### Task 3: Route selected cards in the real BoatSpace

**Files:**

- Create: scripts/identity/identity_visual_router.gd
- Modify: scenes/boat_space.tscn
- Modify: tests/test_identity_visual_contract.gd

**Interfaces:**

- Produces IdentityVisualRouter.apply_selection(player_style_id: String, pet_type_id: String) -> void and get_active_visual_route() -> Dictionary.
- Default route is {"mode": "final_composite", "player_style_id": "c_loose_knit", "pet_type_id": "dog"}.
- Every other valid pair routes to {"mode": "layered_subjects", "player_style_id": normalized value, "pet_type_id": normalized value}.

- [ ] **Step 1: Add failing route assertions**

Append this helper to tests/test_identity_visual_contract.gd.

~~~gdscript
func _expect_visual_route(player_style_id: String, pet_type_id: String, expected_mode: String) -> void:
    var game_state := root.get_node_or_null("GameState")
    game_state.set_selected_player_style(player_style_id)
    game_state.set_selected_pet_type(pet_type_id)
    var scene := (load("res://scenes/boat_space.tscn") as PackedScene).instantiate()
    root.add_child(scene)
    await process_frame
    var router := scene.get_node_or_null("IdentityVisualRouter")
    _expect(router != null, "BoatSpace owns IdentityVisualRouter")
    if router != null:
        var route: Dictionary = router.get_active_visual_route()
        _expect(route.get("mode", "") == expected_mode, "selected pair uses expected route")
        _expect(route.get("player_style_id", "") == player_style_id, "router exposes player")
        _expect(route.get("pet_type_id", "") == pet_type_id, "router exposes pet")
    scene.queue_free()
    await process_frame
~~~

Call for C+dog, A+dog, and B+otter. For layered cases, assert exactly one of three avatar containers and one of four pet containers is visible and FinalDioramaCard.visible is false.

- [ ] **Step 2: Run the route test to verify it fails**

Run the Task 2 Godot test command. Expected: FAIL because IdentityVisualRouter and named cards do not exist.

- [ ] **Step 3: Implement router and named card containers**

Create scripts/identity/identity_visual_router.gd with Korean header. It preloads the catalog, reads GameState in _ready, normalizes inputs, and owns visibility only.

~~~gdscript
func apply_selection(player_style_id: String, pet_type_id: String) -> void:
    _player_style_id = _catalog.normalize_player_style(player_style_id)
    _pet_type_id = _catalog.normalize_pet_type(pet_type_id)
    var is_default := _player_style_id == "c_loose_knit" and _pet_type_id == "dog"
    _final_diorama_card.visible = is_default
    _shared_hull_pass.visible = not is_default
    for child in _avatar_cards.get_children():
        child.visible = not is_default and child.name == _player_style_id
    for child in _pet_cards.get_children():
        child.visible = not is_default and child.name == _pet_type_id
~~~

In scenes/boat_space.tscn, attach router to root child IdentityVisualRouter. Add AvatarCards below PlayerAvatarPlaceholder/VisualStudy with a_soft_hooded, b_short_cape, c_loose_knit Node3D containers. Add PetCards below RestingPetPlaceholder/VisualStudy with cat, rabbit, otter, dog containers. Move existing C/dog cards under matching containers without changing texture or fallback behavior. Add Sprite3D cards for A/B/cat/rabbit/otter using existing storybook_art_card.gd.

All containers start hidden. Router shows FinalDioramaCard only for C+dog. Any other pair shows StorybookHullPass, one avatar, and one pet. Do not rename/reparent technical placeholder nodes, alter their transforms, camera nodes, decor slots, or interaction APIs.

- [ ] **Step 4: Run route and regression contracts**

Run:

~~~powershell
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_identity_visual_contract.gd
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_diorama_avatar_camera_contract.gd
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_low_pressure_interaction_contract.gd
~~~

Expected: all PASS.

- [ ] **Step 5: Commit runtime visual routing**

~~~powershell
git add scripts/identity/identity_visual_router.gd scenes/boat_space.tscn tests/test_identity_visual_contract.gd
git commit -m "Apply selected identity to boat diorama"
~~~

### Task 4: Add the quiet main-menu selector

**Files:**

- Modify: scenes/main_menu.tscn
- Modify: scripts/ui/main_menu.gd
- Create: tests/test_main_menu_identity_contract.gd

**Interfaces:**

- Produces _show_identity_panel() -> void, _hide_identity_panel() -> void, _refresh_identity_summary() -> void, and _populate_identity_options() -> void.
- MainMenu/IdentityPanel exposes unique %PlayerStyleOption, %PetTypeOption, %IdentitySummaryLabel, and %IdentityCloseButton.

- [ ] **Step 1: Write the failing main-menu contract**

Create tests/test_main_menu_identity_contract.gd with the normal SceneTree runner and this core sequence.

~~~gdscript
var gs := root.get_node_or_null("GameState")
var before_mood := gs.selected_mood
var before_affection := gs.companion_affection
var before_photos := gs.photos.size()
var menu := (load("res://scenes/main_menu.tscn") as PackedScene).instantiate()
root.add_child(menu)
await process_frame
var identity_button := menu.get_node_or_null("Margin/Panel/VBox/IdentityButton") as Button
var panel := menu.get_node_or_null("Margin/Panel/VBox/IdentityPanel") as Control
var player_option := menu.get_node_or_null("Margin/Panel/VBox/IdentityPanel/PlayerStyleOption") as OptionButton
var pet_option := menu.get_node_or_null("Margin/Panel/VBox/IdentityPanel/PetTypeOption") as OptionButton
_expect(identity_button != null and panel != null, "menu exposes identity entry and panel")
_expect(player_option != null and player_option.item_count == 3, "three player choices")
_expect(pet_option != null and pet_option.item_count == 4, "four pet choices")
identity_button.emit_signal("pressed")
_expect(panel.visible, "entry reveals selector")
player_option.emit_signal("item_selected", 0)
pet_option.emit_signal("item_selected", 2)
_expect(gs.get_selected_player_style() == "a_soft_hooded", "menu stores player ID")
_expect(gs.get_selected_pet_type() == "otter", "menu stores pet ID")
_expect(gs.selected_mood == before_mood, "identity does not alter mood")
_expect(gs.companion_affection == before_affection and gs.photos.size() == before_photos, "identity creates no progression")
~~~

- [ ] **Step 2: Run the test to verify it fails**

Run:

~~~powershell
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_main_menu_identity_contract.gd
~~~

Expected: FAIL because menu identity nodes do not exist.

- [ ] **Step 3: Implement controls with stable ID metadata**

Add IdentityButton after title and before mood copy. Add hidden IdentityPanel in existing VBox with summary label, the two options, and close button.

Preload catalog in scripts/ui/main_menu.gd, populate options from catalog order, and save IDs from item metadata rather than label text.

~~~gdscript
func _populate_identity_options() -> void:
    %PlayerStyleOption.clear()
    for player_style_id in _catalog.get_player_style_ids():
        %PlayerStyleOption.add_item(_catalog.get_player_label(player_style_id))
        %PlayerStyleOption.set_item_metadata(%PlayerStyleOption.item_count - 1, player_style_id)

func _on_player_style_selected(index: int) -> void:
    GameState.set_selected_player_style(str(%PlayerStyleOption.get_item_metadata(index)))
    _refresh_identity_summary()
~~~

Implement symmetric pet handler. Set selected indices from GameState in _ready. Close only hides panel. Preserve all existing mood button connections and _start_voyage unchanged.

- [ ] **Step 4: Run menu and behavior regressions**

Run:

~~~powershell
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_main_menu_identity_contract.gd
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_game_scene_contract.gd
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --script res://tests/test_cosmetic_identity_profile.gd
~~~

Expected: all PASS.

- [ ] **Step 5: Commit the selector**

~~~powershell
git add scenes/main_menu.tscn scripts/ui/main_menu.gd tests/test_main_menu_identity_contract.gd
git commit -m "Add cosmetic identity selector"
~~~

### Task 5: Full validation, visual evidence, and project truth

**Files:**

- Modify: README.md
- Modify: docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md
- Modify: docs/GODOT_MVP_ROADMAP.md
- Create: docs/evidence/2026-08-27-runtime-identity-selection/normal_540x960_c_dog.png
- Create: docs/evidence/2026-08-27-runtime-identity-selection/normal_540x960_b_otter.png

**Interfaces:**

- Consumes complete profile, catalog, router, and UI.
- Produces factual evidence only; it never claims real-device mobile comfort.

- [ ] **Step 1: Run every contract plus headless smokes**

Run every tests/*.gd contract with the Godot console executable. Then run:

~~~powershell
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --quit
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --scene res://scenes/main_menu.tscn --quit-after 1
& "C:\Users\user\Downloads\Godot_v4.7.2-stable_win64.exe\Godot_v4.7.2-stable_win64_console.exe" --headless --path . --scene res://scenes/game.tscn --quit-after 1
~~~

Expected: zero exit status and no task-related parse/load errors. Diagnose actual failures before code changes; never weaken contracts merely to make them pass.

- [ ] **Step 2: Capture default and non-default evidence**

Capture 540×960 normal views for C+dog and B+otter. Verify default keeps the approved composite. Verify B+otter shows one player, one pet, shared boat, decor, and horizon. Enter/exit Appreciation Camera for both and verify it leaves selected IDs and soundscape behavior unchanged. This is runtime evidence, not real-device touch-comfort evidence.

- [ ] **Step 3: Update project truth only after evidence exists**

Update CURRENT_GODOT_IMPLEMENTATION.md with:

~~~text
COSMETIC_IDENTITY_SELECTION = IMPLEMENTED_LOCAL_FIRST
DEFAULT_IDENTITY_C_DOG = PRESERVED
IDENTITY_RUNTIME_ASSET_LOCATORS = PASS
IDENTITY_AUTOMATED_CONTRACTS = PASS
IDENTITY_REAL_DEVICE_MOBILE_QA = DEFERRED
~~~

Update GODOT_MVP_ROADMAP.md with selector/persistence implementation, retaining arbitrary editing, unlocks, and real-device QA as deferred. Add README instruction: 내 모습과 동반자 changes only the visible cosmetic pair and saves locally.

- [ ] **Step 4: Inspect scope and commit evidence**

Run git diff --check and inspect git status --short. Stage only intended source, tests, docs, captures, and evidence; do not stage unrelated Godot-generated .import or .uid files.

~~~powershell
git add README.md docs/handoffs/CURRENT_GODOT_IMPLEMENTATION.md docs/GODOT_MVP_ROADMAP.md docs/evidence/2026-08-27-runtime-identity-selection
git commit -m "Document runtime identity selection evidence"
~~~

- [ ] **Step 5: Prepare focused integration review**

Confirm the branch contains only identity-selection scope and PR #19 was neither rebased, merged, nor edited. Report changed files, asset records/locators, tests, captures, and deferred real-device mobile check.

## Plan self-review

| Spec requirement | Implementing tasks |
| --- | --- |
| Three player/four pet IDs and C+dog default | 1, 2, 3, 4 |
| Separate local persistence and corrupt-file fallback | 1 |
| Actual visible scene change | 2, 3 |
| Quiet main-menu flow | 4 |
| Preserve gameplay/camera/decor/interaction rules | 1, 3, 4, 5 |
| Local and Notion durable asset registration | 2 |
| Automated evidence and deferred real-device QA | 5 |
| PR #19 isolation | Global constraints and 5 |

Placeholder scan, scope coverage, and interface-name consistency review are complete.
