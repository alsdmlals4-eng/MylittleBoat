# 런타임 캡처 전에 승인된 이미지 리소스의 실제 로드 가능 여부를 확인한다.
class_name RuntimeCaptureGuard
extends RefCounted

const REQUIRED_TEXTURE_PATHS: Array[String] = [
	"res://assets/images/runtime/storybook/c_default_storybook.png",
	"res://assets/images/runtime/storybook/dog_default_storybook.png",
	"res://assets/images/runtime/voyage/normal_chibi/chibi-normal-rear-chroma-key.png",
	"res://assets/images/runtime/storybook/sea_bright_storybook.png",
	"res://assets/images/runtime/voyage/split/bright-static-sky.png",
	"res://assets/images/runtime/voyage/split/bright-flowing-sea.png",
	"res://assets/images/runtime/voyage/split/dawn-static-sky.png",
	"res://assets/images/runtime/voyage/split/dawn-flowing-sea.png",
	"res://assets/images/runtime/voyage/split/sunset-static-sky.png",
	"res://assets/images/runtime/voyage/split/sunset-flowing-sea.png",
	"res://assets/images/runtime/voyage/split/night-static-sky.png",
	"res://assets/images/runtime/voyage/split/night-flowing-sea.png",
	"res://assets/images/runtime/voyage/bright-open-sea-water-only.png",
	"res://assets/images/runtime/voyage/dawn-arches-waterfall-water-only.png",
	"res://assets/images/runtime/voyage/bright-clear-seagrass-lagoon.png",
	"res://assets/images/runtime/voyage/ambient_motifs/dawn-sea-arch-waterfall.png",
	"res://assets/images/runtime/voyage/ambient_motifs/bright-seagrass-sandbar.png",
	"res://assets/images/runtime/voyage/ambient_motifs/bright-chalk-cliffs-birds.png",
	"res://assets/images/runtime/voyage/ambient_motifs/sunset-sandstone-cove.png",
	"res://assets/images/runtime/voyage/ambient_motifs/sunset-reed-islet.png",
	"res://assets/images/runtime/voyage/ambient_motifs/night-bioluminescent-band.png",
	"res://assets/images/runtime/voyage/sunset-sandstone-cove-water-only.png",
	"res://assets/images/runtime/voyage/night-indigo-rain-bay-water-only.png",
	"res://assets/images/runtime/voyage/boat-water-contact-ripple.png",
	"res://assets/images/runtime/voyage/look_around/foreground_split/port-foreground.png",
	"res://assets/images/runtime/voyage/look_around/foreground_split/starboard-foreground.png",
	"res://assets/images/runtime/voyage/look_around/foreground_split/aft-foreground.png",
	"res://assets/images/runtime/voyage/look_around/foreground_split/overhead-foreground.png",
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


func get_unavailable_texture_paths(texture_paths: Array[String]) -> Array[String]:
	var unavailable_paths: Array[String] = []
	for texture_path in texture_paths:
		if not ResourceLoader.exists(texture_path) or ResourceLoader.load(texture_path, "Texture2D") is not Texture2D:
			unavailable_paths.append(texture_path)
	return unavailable_paths
