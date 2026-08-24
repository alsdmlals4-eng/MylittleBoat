# 보트 꾸미기 슬롯과 소품 호환성 데이터를 관리한다.
extends RefCounted

const SLOT_IDS: Array[String] = [
	"bow_left",
	"bow_right",
	"center_left",
	"center_right",
	"rear_left",
	"rear_right",
	"rail_accent",
	"pet_corner",
]

const SLOT_LABELS := {
	"bow_left": "선수 왼쪽",
	"bow_right": "선수 오른쪽",
	"center_left": "중앙 왼쪽",
	"center_right": "중앙 오른쪽",
	"rear_left": "후미 왼쪽",
	"rear_right": "후미 오른쪽",
	"rail_accent": "난간 포인트",
	"pet_corner": "펫 자리",
}

const SLOT_CATEGORIES := {
	"bow_left": ["light", "small", "seat"],
	"bow_right": ["light", "small", "seat"],
	"center_left": ["light", "small", "seat"],
	"center_right": ["light", "small", "seat"],
	"rear_left": ["light", "small", "seat"],
	"rear_right": ["light", "small", "seat"],
	"rail_accent": ["rail"],
	"pet_corner": ["pet", "seat"],
}

const ITEM_IDS: Array[String] = [
	"lantern",
	"mug",
	"cushion",
	"plant",
	"postcard",
	"pet_cushion",
]

const ITEM_DEFINITIONS := {
	"lantern": {
		"label": "랜턴",
		"category": "light",
		"shape": "lantern",
		"actions": [
			{"id": "toggle_light", "label": "불빛 바꾸기", "message": "랜턴 불빛을 조용히 바꿨습니다.", "toggle_key": "light_on"},
		],
	},
	"mug": {
		"label": "컵",
		"category": "small",
		"shape": "mug",
		"actions": [
			{"id": "hold", "label": "컵 들어보기", "message": "따뜻한 컵을 잠시 들어봅니다.", "toggle_key": "held"},
		],
	},
	"cushion": {
		"label": "쿠션",
		"category": "seat",
		"shape": "cushion",
		"actions": [
			{"id": "sit", "label": "기대어 쉬기", "message": "쿠션에 기대어 잠시 쉽니다."},
		],
	},
	"plant": {
		"label": "작은 화분",
		"category": "small",
		"shape": "plant",
		"actions": [
			{"id": "look", "label": "바라보기", "message": "작은 잎이 바람에 흔들리는 모습을 봅니다."},
		],
	},
	"postcard": {
		"label": "엽서",
		"category": "rail",
		"shape": "postcard",
		"actions": [
			{"id": "look", "label": "엽서 보기", "message": "난간의 엽서를 천천히 바라봅니다."},
		],
	},
	"pet_cushion": {
		"label": "펫 쿠션",
		"category": "pet",
		"shape": "pet_cushion",
		"actions": [
			{"id": "rest", "label": "함께 쉬기", "message": "동반자가 익숙한 쿠션에서 편히 쉽니다."},
		],
	},
}


func get_slot_ids() -> Array[String]:
	return SLOT_IDS.duplicate()


func get_slot_label(slot_id: String) -> String:
	return str(SLOT_LABELS.get(slot_id, slot_id))


func get_item_ids() -> Array[String]:
	return ITEM_IDS.duplicate()


func get_item_definition(item_id: String) -> Dictionary:
	var definition: Dictionary = ITEM_DEFINITIONS.get(item_id, {})
	return definition.duplicate(true)


func get_compatible_item_ids(slot_id: String) -> Array[String]:
	var result: Array[String] = []
	if not SLOT_CATEGORIES.has(slot_id):
		return result
	for item_id in ITEM_IDS:
		if is_compatible(slot_id, item_id):
			result.append(item_id)
	return result


func is_compatible(slot_id: String, item_id: String) -> bool:
	if not SLOT_CATEGORIES.has(slot_id) or not ITEM_DEFINITIONS.has(item_id):
		return false
	var definition: Dictionary = ITEM_DEFINITIONS[item_id]
	var category := str(definition.get("category", ""))
	var allowed_categories: Array = SLOT_CATEGORIES[slot_id]
	return allowed_categories.has(category)
