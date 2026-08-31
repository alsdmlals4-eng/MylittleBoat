# 외형 선택의 승인된 ID와 정규화 규칙을 제공한다.
class_name IdentityVisualCatalog
extends RefCounted

const DEFAULT_PLAYER_STYLE := "c_loose_knit"
const DEFAULT_PET_TYPE := "dog"
const PLAYER_STYLES: Array[String] = ["a_soft_hooded", "b_short_cape", "c_loose_knit"]
const PET_TYPES: Array[String] = ["cat", "rabbit", "otter", "dog"]
const PLAYER_LABELS := {
	"a_soft_hooded": "A · 포근한 후드",
	"b_short_cape": "B · 짧은 세일러 케이프",
	"c_loose_knit": "C · 느슨한 니트",
}
const PET_LABELS := {
	"cat": "고양이",
	"rabbit": "토끼",
	"otter": "수달",
	"dog": "강아지",
}
const PLAYER_TEXTURE_PATHS := {
	"a_soft_hooded": "res://assets/images/runtime/chibi_alternates/avatar_a_soft_hooded_chibi.png",
	"b_short_cape": "res://assets/images/runtime/chibi_alternates/avatar_b_short_cape_chibi.png",
	"c_loose_knit": "res://assets/images/runtime/storybook/c_default_storybook.png",
}
const PET_TEXTURE_PATHS := {
	"cat": "res://assets/images/runtime/chibi_alternates/pet_cat_chibi.png",
	"rabbit": "res://assets/images/runtime/chibi_alternates/pet_rabbit_chibi.png",
	"otter": "res://assets/images/runtime/chibi_alternates/pet_otter_chibi.png",
	"dog": "res://assets/images/runtime/storybook/dog_default_storybook.png",
}


func get_player_style_ids() -> Array[String]:
	return PLAYER_STYLES.duplicate()


func get_pet_type_ids() -> Array[String]:
	return PET_TYPES.duplicate()


func normalize_player_style(value: String) -> String:
	return value if PLAYER_STYLES.has(value) else DEFAULT_PLAYER_STYLE


func normalize_pet_type(value: String) -> String:
	return value if PET_TYPES.has(value) else DEFAULT_PET_TYPE


func get_player_label(player_style_id: String) -> String:
	var normalized := normalize_player_style(player_style_id)
	return str(PLAYER_LABELS.get(normalized, PLAYER_LABELS[DEFAULT_PLAYER_STYLE]))


func get_pet_label(pet_type_id: String) -> String:
	var normalized := normalize_pet_type(pet_type_id)
	return str(PET_LABELS.get(normalized, PET_LABELS[DEFAULT_PET_TYPE]))


func get_player_texture_path(player_style_id: String) -> String:
	var normalized := normalize_player_style(player_style_id)
	return str(PLAYER_TEXTURE_PATHS.get(normalized, PLAYER_TEXTURE_PATHS[DEFAULT_PLAYER_STYLE]))


func get_pet_texture_path(pet_type_id: String) -> String:
	var normalized := normalize_pet_type(pet_type_id)
	return str(PET_TEXTURE_PATHS.get(normalized, PET_TEXTURE_PATHS[DEFAULT_PET_TYPE]))
