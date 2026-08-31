# 확정 타이틀 로고가 정본 자산으로 등록되고 실제 보트 대기 화면에 소비되는지 검증한다.
extends SceneTree

const TITLE_LOGO_PATH := "res://assets/images/brand/my_little_boat_title_lockup_v1.png"
const TITLE_LOGO_REPOSITORY_PATH := "assets/images/brand/my_little_boat_title_lockup_v1.png"
const GAME_SCENE_PATH := "res://scenes/game.tscn"
const VISUAL_INVENTORY_PATH := "res://docs/visual/CURRENT_SCREEN_SURFACE_INVENTORY_AND_VISUAL_ASSET_COVERAGE.md"
const PROJECT_GDD_PATH := "res://docs/design/PROJECT_GDD.md"
const BRAND_ASSET_ID := "MLB-BRAND-TITLE-001"
const EXPECTED_WIDTH := 2172
const EXPECTED_HEIGHT := 724

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(ProjectSettings.get_setting("application/config/name", "") == "MY LITTLE BOAT", "project window title must use the locked game title")
	_expect(ProjectSettings.get_setting("application/run/main_scene", "") == GAME_SCENE_PATH, "title branding must open the actual boat title entry")
	_expect(ResourceLoader.exists(TITLE_LOGO_PATH), "locked title logo must be available as a canonical project asset")
	if ResourceLoader.exists(TITLE_LOGO_PATH):
		var title_texture := load(TITLE_LOGO_PATH) as Texture2D
		_expect(title_texture != null, "locked title logo must load through Godot's imported texture path")
		if title_texture != null:
			_expect(title_texture.get_width() == EXPECTED_WIDTH and title_texture.get_height() == EXPECTED_HEIGHT, "title logo must retain its approved 3:1 presentation dimensions")
	if ResourceLoader.exists(GAME_SCENE_PATH):
		var scene := (load(GAME_SCENE_PATH) as PackedScene).instantiate()
		var title_logo := scene.get_node_or_null("TitleOverlay/TitleLayout/BrandLogo") as TextureRect
		_expect(title_logo != null and title_logo.texture != null, "actual title entry must consume the locked brand logo")
		if title_logo != null:
			_expect(title_logo.texture.resource_path == TITLE_LOGO_PATH, "title entry must consume the canonical logo file directly")
		scene.queue_free()

	var visual_inventory := FileAccess.get_file_as_string(VISUAL_INVENTORY_PATH)
	_expect(visual_inventory.contains(BRAND_ASSET_ID), "visual inventory must register the locked title asset id")
	_expect(visual_inventory.contains("TITLE_ENTRY_RUNTIME_CONSUMER"), "visual inventory must state the approved title-entry runtime consumer")
	_expect(visual_inventory.contains(TITLE_LOGO_REPOSITORY_PATH), "visual inventory must map the title asset to its canonical file")

	var project_gdd := FileAccess.get_file_as_string(PROJECT_GDD_PATH)
	_expect(project_gdd.contains(BRAND_ASSET_ID), "project GDD must record the approved world-setting title treatment")
	_expect(project_gdd.contains("파도 위에서, 함께 쉬는 시간"), "project GDD must preserve the approved title promise")
	_expect(project_gdd.contains("타이틀 대기"), "project GDD must describe the approved title waiting flow")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: title brand asset contract")
		quit(0)
	else:
		printerr("FAILED: %d title brand asset assertions" % _failures)
		quit(1)
