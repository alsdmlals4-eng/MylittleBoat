# 승인된 후면 분리 자산을 좌석 접점으로 조립하고 항해 위상에 맞춰 반응시킨다.
extends Sprite3D

const PARTS = preload("res://assets/images/runtime/voyage/stern_parts/stern-motion-parts-rgba-v1.png")
const DESPILL = preload("res://assets/shaders/stern_parts_despill.gdshader")
const PLAYER_REST := Vector2(326, 590)
const PET_REST := Vector2(502, 636)
var player: Sprite2D
var pet: Sprite2D
var cushion: Sprite2D

func _ready() -> void:
	var view := SubViewport.new()
	view.name = "PartsViewport"
	view.size = Vector2i(768, 1024)
	view.transparent_bg = true
	view.disable_3d = true
	view.render_target_update_mode = SubViewport.UPDATE_WHEN_VISIBLE
	add_child(view)
	_add_part(view, "Hull", Rect2(60, 12, 752, 988), Vector2(384, 512), 0.78)
	cushion = Sprite2D.new()
	cushion.name = "Cushion"
	cushion.position = Vector2(502, 669)
	var cushion_material := ShaderMaterial.new()
	cushion_material.shader = preload("res://assets/shaders/stern_cushion_surface.gdshader")
	cushion.material = cushion_material
	view.add_child(cushion)
	player = _add_part(view, "Player", Rect2(835, 92, 632, 476), PLAYER_REST, 0.60)
	pet = _add_part(view, "Pet", Rect2(945, 670, 465, 300), PET_REST, 0.46)
	# 동일 선체 원본의 앞 난간을 재사용해 하체가 난간을 관통하지 않게 한다.
	_add_part(view, "SternRail", Rect2(60, 730, 752, 270), Vector2(384, 794.36), 0.78)
	texture = view.get_texture()
	material_override = null
	pixel_size = 0.0038
	apply_motion(0.0, 0.0)

func apply_cushion(selected_texture: Texture2D) -> void:
	if cushion == null:
		return
	cushion.texture = selected_texture
	cushion.visible = selected_texture != null
	if selected_texture != null:
		cushion.scale = Vector2(180.0, 80.0) / selected_texture.get_size()

func _add_part(view: SubViewport, part_name: String, region: Rect2, at: Vector2, size_scale: float) -> Sprite2D:
	var sprite := Sprite2D.new()
	sprite.name = part_name
	var atlas := AtlasTexture.new()
	atlas.atlas = PARTS
	atlas.region = region
	atlas.filter_clip = true
	sprite.texture = atlas
	var material := ShaderMaterial.new()
	material.shader = DESPILL
	sprite.material = material
	sprite.position = at
	sprite.scale = Vector2.ONE * size_scale
	view.add_child(sprite)
	return sprite

func apply_motion(phase: float, comfort: float) -> void:
	if player == null or pet == null:
		return
	# 선체와 같은 주파수에 짧은 위상차만 두어 제각각 떠다니는 동작을 피한다.
	player.rotation = sin(phase * 0.82 - 0.12) * 0.009 * comfort
	player.position = PLAYER_REST + Vector2(0.0, sin(phase * 1.05 - 0.12) * 1.8 * comfort)
	pet.rotation = sin(phase * 0.82 - 0.28) * 0.007 * comfort
	pet.position = PET_REST + Vector2(0.0, sin(phase * 1.05 - 0.28) * 1.1 * comfort)
