# 런타임 캡처가 실제로 로드 가능한 승인 이미지에서만 시작하는지 검증한다.
extends SceneTree

const GUARD_PATH := "res://scripts/visual/runtime_capture_guard.gd"
const APPROVED_TEXTURE_PATH := "res://assets/images/runtime/voyage/normal_chibi/chibi-normal-rear-chroma-key.png"
const APPROVED_LOOK_AROUND_TEXTURE_PATHS := [
	"res://assets/images/runtime/voyage/look_around/foreground_split/port-foreground.png",
	"res://assets/images/runtime/voyage/look_around/foreground_split/starboard-foreground.png",
	"res://assets/images/runtime/voyage/look_around/foreground_split/aft-foreground.png",
	"res://assets/images/runtime/voyage/look_around/foreground_split/overhead-foreground.png",
]
const APPROVED_CHIBI_DECOR_TEXTURE_PATHS := [
	"res://assets/images/runtime/chibi_alternates/avatar_a_soft_hooded_chibi.png",
	"res://assets/images/runtime/chibi_alternates/avatar_b_short_cape_chibi.png",
	"res://assets/images/runtime/chibi_alternates/pet_cat_chibi.png",
	"res://assets/images/runtime/chibi_alternates/pet_rabbit_chibi.png",
	"res://assets/images/runtime/chibi_alternates/pet_otter_chibi.png",
	"res://assets/images/decor/pet_cushion/cushion_stripe_chibi.png",
	"res://assets/images/decor/pet_cushion/cushion_moon_chibi.png",
	"res://assets/images/decor/pet_cushion/cushion_floral_chibi.png",
	"res://assets/images/decor/postcard/postcard_chibi_moonboat.png",
]
const APPROVED_AMBIENT_MOTIF_TEXTURE_PATHS := [
	"res://assets/images/runtime/voyage/ambient_motifs/dawn-sea-arch-waterfall.png",
	"res://assets/images/runtime/voyage/ambient_motifs/bright-seagrass-sandbar.png",
	"res://assets/images/runtime/voyage/ambient_motifs/bright-chalk-cliffs-birds.png",
	"res://assets/images/runtime/voyage/ambient_motifs/sunset-sandstone-cove.png",
	"res://assets/images/runtime/voyage/ambient_motifs/sunset-reed-islet.png",
	"res://assets/images/runtime/voyage/ambient_motifs/night-bioluminescent-band.png",
]
const MISSING_TEXTURE_PATH := "res://assets/images/runtime/storybook/missing.png"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(ResourceLoader.exists(GUARD_PATH), "runtime capture guard must exist")
	if ResourceLoader.exists(GUARD_PATH):
		var guard = load(GUARD_PATH).new()
		_expect(guard.has_method("get_unavailable_texture_paths"), "capture guard must expose resource availability check")
		_expect(guard.REQUIRED_TEXTURE_PATHS.has(APPROVED_TEXTURE_PATH), "capture guard must require the approved chibi normal foreground texture")
		for texture_path in APPROVED_LOOK_AROUND_TEXTURE_PATHS:
			_expect(guard.REQUIRED_TEXTURE_PATHS.has(texture_path), "capture guard must require approved Look Around texture %s" % texture_path)
		for texture_path in APPROVED_CHIBI_DECOR_TEXTURE_PATHS:
			_expect(guard.REQUIRED_TEXTURE_PATHS.has(texture_path), "capture guard must require approved chibi decor texture %s" % texture_path)
		for texture_path in APPROVED_AMBIENT_MOTIF_TEXTURE_PATHS:
			_expect(guard.REQUIRED_TEXTURE_PATHS.has(texture_path), "capture guard must require approved ambient motif texture %s" % texture_path)
		if guard.has_method("get_unavailable_texture_paths"):
			var approved_paths: Array[String] = [APPROVED_TEXTURE_PATH]
			approved_paths.append_array(APPROVED_LOOK_AROUND_TEXTURE_PATHS)
			approved_paths.append_array(APPROVED_CHIBI_DECOR_TEXTURE_PATHS)
			approved_paths.append_array(APPROVED_AMBIENT_MOTIF_TEXTURE_PATHS)
			var missing_paths: Array[String] = [MISSING_TEXTURE_PATH]
			_expect(guard.get_unavailable_texture_paths(approved_paths).is_empty(), "imported approved texture must be capture-ready")
			_expect(guard.get_unavailable_texture_paths(missing_paths) == missing_paths, "missing texture must block capture")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: runtime capture guard contract")
		quit(0)
	else:
		printerr("FAILED: %d runtime capture guard assertions" % _failures)
		quit(1)
