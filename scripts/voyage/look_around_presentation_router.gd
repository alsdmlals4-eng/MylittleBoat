# 승인된 둘러보기 각도 원화를 결정적으로 선택한다.
class_name LookAroundPresentationRouter
extends RefCounted

const FRONT_ANGLE_ID := "front"
const FOREGROUND_ANGLE_ASSET_PATHS := {
	"port": "res://assets/images/runtime/voyage/look_around/foreground_split/port-foreground.png",
	"starboard": "res://assets/images/runtime/voyage/look_around/foreground_split/starboard-foreground.png",
	"aft": "res://assets/images/runtime/voyage/look_around/foreground_split/aft-foreground.png",
	"overhead": "res://assets/images/runtime/voyage/look_around/foreground_split/overhead-foreground.png",
}


func get_display_angle_id(requested_angle_id: String) -> String:
	return requested_angle_id if FOREGROUND_ANGLE_ASSET_PATHS.has(requested_angle_id) else FRONT_ANGLE_ID


func has_runtime_angle_asset(angle_id: String) -> bool:
	return FOREGROUND_ANGLE_ASSET_PATHS.has(angle_id)


func get_runtime_angle_asset_path(angle_id: String) -> String:
	return str(FOREGROUND_ANGLE_ASSET_PATHS.get(angle_id, ""))
