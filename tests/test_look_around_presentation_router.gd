# 승인된 둘러보기 각도 이미지가 결정적으로 runtime 경로를 선택하는지 검증한다.
extends SceneTree

const ROUTER_PATH := "res://scripts/voyage/look_around_presentation_router.gd"
const APPROVED_ANGLE_PATHS := {
	"port": "res://assets/images/runtime/voyage/look_around/foreground_split/port-foreground.png",
	"starboard": "res://assets/images/runtime/voyage/look_around/foreground_split/starboard-foreground.png",
	"aft": "res://assets/images/runtime/voyage/look_around/foreground_split/aft-foreground.png",
	"overhead": "res://assets/images/runtime/voyage/look_around/foreground_split/overhead-foreground.png",
}

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var router_script := load(ROUTER_PATH)
	_expect(router_script != null, "Look Around presentation router must load")
	if router_script == null:
		_finish()
		return

	var router = router_script.new()
	_expect(str(router.get_display_angle_id("front")) == "front", "front composition must retain the approved normal view")
	_expect(router.has_method("get_runtime_angle_asset_path"), "approved angle router must expose an exact runtime texture path")
	for angle_id in APPROVED_ANGLE_PATHS:
		var expected_path := str(APPROVED_ANGLE_PATHS[angle_id])
		_expect(str(router.get_display_angle_id(angle_id)) == angle_id, "%s must retain its approved camera angle" % angle_id)
		_expect(bool(router.has_runtime_angle_asset(angle_id)), "%s must resolve as an approved runtime asset" % angle_id)
		if router.has_method("get_runtime_angle_asset_path"):
			_expect(str(router.get_runtime_angle_asset_path(angle_id)) == expected_path, "%s must use its registered exact texture path" % angle_id)
		_expect(ResourceLoader.exists(expected_path), "%s runtime texture must exist" % angle_id)
	_expect(str(router.get_display_angle_id("unknown")) == "front", "unknown angle must safely fall back to front")
	_expect(not bool(router.has_runtime_angle_asset("unknown")), "unknown angle must not resolve as a runtime asset")
	if router.has_method("get_runtime_angle_asset_path"):
		_expect(str(router.get_runtime_angle_asset_path("unknown")).is_empty(), "unknown angle must not expose a runtime texture path")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: look around presentation router contract")
		quit(0)
	else:
		printerr("FAILED: %d Look Around router assertions" % _failures)
		quit(1)
