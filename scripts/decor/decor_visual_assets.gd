# 승인된 장식 런타임 이미지의 경로·외형 선택·안전한 로드를 관리한다.
extends RefCounted

const CUSHION_TEXTURE_PATHS := {
	"stripe": "res://assets/images/decor/pet_cushion/cushion_stripe_chibi.png",
	"moon": "res://assets/images/decor/pet_cushion/cushion_moon_chibi.png",
	"floral": "res://assets/images/decor/pet_cushion/cushion_floral_chibi.png",
}
const CUSHION_APPEARANCE_LABELS := {
	"stripe": "줄무늬",
	"moon": "달",
	"floral": "꽃",
}
const DEFAULT_CUSHION_APPEARANCE := "stripe"
const POSTCARD_TEXTURE_PATH := "res://assets/images/decor/postcard/postcard_chibi_moonboat.png"


func get_cushion_appearance_ids() -> Array[String]:
	return ["stripe", "moon", "floral"]


func normalize_cushion_appearance(appearance_id: String) -> String:
	return appearance_id if CUSHION_TEXTURE_PATHS.has(appearance_id) else DEFAULT_CUSHION_APPEARANCE


func get_cushion_appearance_label(appearance_id: String) -> String:
	var normalized := normalize_cushion_appearance(appearance_id)
	return str(CUSHION_APPEARANCE_LABELS.get(normalized, normalized))


func get_cushion_texture_path(appearance_id: String) -> String:
	var normalized := normalize_cushion_appearance(appearance_id)
	return str(CUSHION_TEXTURE_PATHS.get(normalized, ""))


func get_postcard_texture_path() -> String:
	return POSTCARD_TEXTURE_PATH


func load_texture_if_available(texture_path: String) -> Texture2D:
	if texture_path.is_empty() or not ResourceLoader.exists(texture_path):
		return null
	return load(texture_path) as Texture2D
