# 항해에서 쌓인 사진·풍경·편지·물고기·항해 기록을 보여준다.
extends Control

const TIME_OF_DAY_CATALOG_SCRIPT = preload("res://scripts/voyage/time_of_day_catalog.gd")
const REAL_TIME_ATMOSPHERE_RESOLVER_SCRIPT = preload("res://scripts/voyage/real_time_atmosphere_resolver.gd")
const TOGETHER_TIME_PRESENTATION_SCRIPT = preload("res://scripts/companion/together_time_presentation.gd")
const ATMOSPHERE_BACKGROUNDS := {
	"dawn": preload("res://assets/images/ui/main_menu/main_menu_dawn_storybook_v1.png"),
	"bright": preload("res://assets/images/ui/main_menu/main_menu_bright_storybook_v1.png"),
	"sunset": preload("res://assets/images/ui/main_menu/main_menu_sunset_storybook_v1.png"),
	"night": preload("res://assets/images/ui/main_menu/main_menu_night_storybook_v1.png"),
}

var _time_of_day_catalog = TIME_OF_DAY_CATALOG_SCRIPT.new()
var _real_time_atmosphere_resolver = REAL_TIME_ATMOSPHERE_RESOLVER_SCRIPT.new()
var _together_time_presentation = TOGETHER_TIME_PRESENTATION_SCRIPT.new()


func _ready() -> void:
	%BackButton.pressed.connect(_back_to_sea)
	refresh_album()


## Refreshes the album from the player's actual local voyage memories.
func refresh_album() -> void:
	_refresh_atmosphere_background()
	_refresh_summary()
	_refresh_recent_memory()
	_refresh_postcards()


func _refresh_atmosphere_background() -> void:
	var current_time_of_day := _time_of_day_catalog.normalize_time_of_day(_real_time_atmosphere_resolver.resolve_system_time())
	%AtmosphereBackground.texture = ATMOSPHERE_BACKGROUNDS[current_time_of_day] as Texture2D


func _refresh_summary() -> void:
	%SummaryLabel.text = "\n".join([
		"사진 앨범: %d장 · 풍경 앨범: %d개" % [GameState.photos.size(), GameState.sceneries.size()],
		"편지 보관함: %d개 · 물고기 앨범: %d마리" % [GameState.letters.size(), GameState.fish.size()],
		"항해 기록: %d회" % GameState.voyage_records.size(),
		_together_time_presentation.get_duration_copy(GameState.together_time_seconds),
		_together_time_presentation.get_relation_copy(GameState.together_time_seconds),
	])


func _refresh_recent_memory() -> void:
	if _has_memories():
		%RecentMemoryLabel.text = "\n".join([
		"최근 사진: %s" % _last_or_empty(GameState.photos),
		"최근 풍경: %s" % _last_or_empty(GameState.sceneries),
		"최근 편지: %s" % _last_or_empty(GameState.letters),
		"최근 물고기: %s" % _last_or_empty(GameState.fish),
		"최근 항해: %s" % _last_or_empty(GameState.voyage_records)
	])
		return
	%RecentMemoryLabel.text = "아직 모아 둔 기억이 없어요.\n첫 항해의 작은 장면을 만나면 이곳에 남아요."


func _refresh_postcards() -> void:
	for child in %PostcardRow.get_children():
		child.queue_free()
	var postcard_entries := GameState.photo_memories
	var card_count := 0
	for offset in range(mini(3, postcard_entries.size())):
		var entry: Dictionary = postcard_entries[postcard_entries.size() - 1 - offset]
		var image_path := str(entry.get("image_path", ""))
		var image := Image.load_from_file(image_path)
		if image == null or image.is_empty():
			continue
		_add_postcard_card(image, str(entry.get("label", "조용한 항해")))
		card_count += 1
	%PostcardRow.visible = card_count > 0
	%PostcardEmptyLabel.visible = card_count == 0


func _add_postcard_card(image: Image, caption: String) -> void:
	var card := VBoxContainer.new()
	card.name = "PostcardCard"
	card.custom_minimum_size = Vector2(122.0, 150.0)
	card.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	card.mouse_filter = Control.MOUSE_FILTER_IGNORE

	var image_rect := TextureRect.new()
	image_rect.name = "Image"
	image_rect.custom_minimum_size = Vector2(0.0, 108.0)
	image_rect.size_flags_vertical = Control.SIZE_EXPAND_FILL
	image_rect.texture = ImageTexture.create_from_image(image)
	image_rect.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	image_rect.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_COVERED
	image_rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(image_rect)

	var caption_label := Label.new()
	caption_label.name = "Caption"
	caption_label.text = caption
	caption_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	caption_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	caption_label.add_theme_color_override("font_color", Color(0.96, 0.94, 0.84, 1.0))
	caption_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	card.add_child(caption_label)
	%PostcardRow.add_child(card)


func _has_memories() -> bool:
	return not GameState.photos.is_empty() or not GameState.sceneries.is_empty() or not GameState.letters.is_empty() or not GameState.fish.is_empty() or not GameState.voyage_records.is_empty()


func _last_or_empty(items: Array[String]) -> String:
	if items.is_empty():
		return "아직 없음"
	return items.back()


func _back_to_sea() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
