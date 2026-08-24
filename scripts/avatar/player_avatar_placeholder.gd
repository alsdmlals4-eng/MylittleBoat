# 보이는 플레이어 캐릭터의 기술용 외형·커스터마이즈 슬롯 계약을 제공한다.
extends Node3D

const TECHNICAL_PLACEHOLDER := true
const CUSTOMIZATION_SLOTS: Array[String] = [
	"body",
	"hair",
	"top",
	"bottom",
	"head_accessory",
	"accessory",
	"color",
]


func is_technical_placeholder() -> bool:
	return TECHNICAL_PLACEHOLDER


func get_customization_slots() -> Array[String]:
	return CUSTOMIZATION_SLOTS.duplicate()
