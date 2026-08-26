# 외형 선택의 승인된 ID와 정규화 규칙을 제공한다.
class_name IdentityVisualCatalog
extends RefCounted

const DEFAULT_PLAYER_STYLE := "c_loose_knit"
const DEFAULT_PET_TYPE := "dog"
const PLAYER_STYLES: Array[String] = ["a_soft_hooded", "b_short_cape", "c_loose_knit"]
const PET_TYPES: Array[String] = ["cat", "rabbit", "otter", "dog"]


func get_player_style_ids() -> Array[String]:
	return PLAYER_STYLES.duplicate()


func get_pet_type_ids() -> Array[String]:
	return PET_TYPES.duplicate()


func normalize_player_style(value: String) -> String:
	return value if PLAYER_STYLES.has(value) else DEFAULT_PLAYER_STYLE


func normalize_pet_type(value: String) -> String:
	return value if PET_TYPES.has(value) else DEFAULT_PET_TYPE
