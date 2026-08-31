# 승인된 둘러보기 각도 원화를 결정적으로 선택한다.
class_name LookAroundPresentationRouter
extends RefCounted

const FRONT_ANGLE_ID := "front"
const RUNTIME_ANGLE_ASSET_PATHS := {
	"port": "res://assets/images/runtime/voyage/look_around/chibi_transparent/chibi-transparent-port.png",
	"starboard": "res://assets/images/runtime/voyage/look_around/chibi_transparent/chibi-transparent-starboard.png",
	"aft": "res://assets/images/runtime/voyage/look_around/chibi_transparent/chibi-transparent-aft.png",
	"overhead": "res://assets/images/runtime/voyage/look_around/chibi_transparent/chibi-transparent-overhead.png",
}


func get_display_angle_id(requested_angle_id: String) -> String:
	return requested_angle_id if RUNTIME_ANGLE_ASSET_PATHS.has(requested_angle_id) else FRONT_ANGLE_ID


func has_runtime_angle_asset(angle_id: String) -> bool:
	return RUNTIME_ANGLE_ASSET_PATHS.has(angle_id)


func get_runtime_angle_asset_path(angle_id: String) -> String:
	return str(RUNTIME_ANGLE_ASSET_PATHS.get(angle_id, ""))
