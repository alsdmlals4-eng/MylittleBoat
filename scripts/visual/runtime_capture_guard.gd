# 런타임 캡처 전에 승인된 이미지 리소스의 실제 로드 가능 여부를 확인한다.
class_name RuntimeCaptureGuard
extends RefCounted

const REQUIRED_TEXTURE_PATHS: Array[String] = [
	"res://assets/images/runtime/storybook/c_default_storybook.png",
	"res://assets/images/runtime/storybook/dog_default_storybook.png",
	"res://assets/images/runtime/storybook/boat_c_dog_diorama_storybook.png",
	"res://assets/images/runtime/storybook/sea_bright_storybook.png",
	"res://assets/images/decor/pet_cushion/cushion_stripe.png",
	"res://assets/images/decor/pet_cushion/cushion_moon.png",
	"res://assets/images/decor/pet_cushion/cushion_floral.png",
	"res://assets/images/decor/postcard/postcard_boat_bright.png",
]


func get_unavailable_texture_paths(texture_paths: Array[String]) -> Array[String]:
	var unavailable_paths: Array[String] = []
	for texture_path in texture_paths:
		if not ResourceLoader.exists(texture_path) or ResourceLoader.load(texture_path, "Texture2D") is not Texture2D:
			unavailable_paths.append(texture_path)
	return unavailable_paths
