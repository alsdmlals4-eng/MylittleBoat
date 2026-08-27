# 항해에서 쌓인 사진·풍경·편지·물고기·항해 기록을 보여준다.
extends Control

const TIME_OF_DAY_CATALOG_SCRIPT = preload("res://scripts/voyage/time_of_day_catalog.gd")
const ATMOSPHERE_BACKGROUNDS := {
	"dawn": preload("res://assets/images/ui/main_menu/main_menu_dawn_storybook_v1.png"),
	"bright": preload("res://assets/images/ui/main_menu/main_menu_bright_storybook_v1.png"),
	"sunset": preload("res://assets/images/ui/main_menu/main_menu_sunset_storybook_v1.png"),
	"night": preload("res://assets/images/ui/main_menu/main_menu_night_storybook_v1.png"),
}

var _time_of_day_catalog = TIME_OF_DAY_CATALOG_SCRIPT.new()


func _ready() -> void:
	%BackButton.pressed.connect(_back_to_sea)
	refresh_album()


## Refreshes the album from the player's actual local voyage memories.
func refresh_album() -> void:
	_refresh_atmosphere_background()
	_refresh_summary()
	_refresh_recent_memory()


func _refresh_atmosphere_background() -> void:
	var selected_time_of_day := _time_of_day_catalog.normalize_time_of_day(GameState.get_selected_time_of_day())
	%AtmosphereBackground.texture = ATMOSPHERE_BACKGROUNDS[selected_time_of_day] as Texture2D


func _refresh_summary() -> void:
	%SummaryLabel.text = "\n".join([
		"사진 앨범: %d장 · 풍경 앨범: %d개" % [GameState.photos.size(), GameState.sceneries.size()],
		"편지 보관함: %d개 · 물고기 앨범: %d마리" % [GameState.letters.size(), GameState.fish.size()],
		"항해 기록: %d회 · 동반자 호감도: Lv %d" % [GameState.voyage_records.size(), GameState.companion_affection],
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


func _has_memories() -> bool:
	return not GameState.photos.is_empty() or not GameState.sceneries.is_empty() or not GameState.letters.is_empty() or not GameState.fish.is_empty() or not GameState.voyage_records.is_empty()


func _last_or_empty(items: Array[String]) -> String:
	if items.is_empty():
		return "아직 없음"
	return items.back()


func _back_to_sea() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
