# 항해 시간대의 승인 ID와 절제된 시각 톤을 제공한다.
class_name TimeOfDayCatalog
extends RefCounted

const DEFAULT_TIME_OF_DAY := "bright"
const TIME_OF_DAY_IDS: Array[String] = ["dawn", "bright", "sunset", "night"]
const DEFINITIONS := {
	"dawn": {
		"label": "새벽",
		"background_color": Color(0.47, 0.57, 0.74, 1.0),
		"ambient_color": Color(0.72, 0.76, 0.88, 1.0),
		"ambient_energy": 0.66,
		"light_color": Color(0.88, 0.82, 0.80, 1.0),
		"light_energy": 0.66,
		"backdrop_modulate": Color(0.75, 0.82, 0.96, 1.0),
	},
	"bright": {
		"label": "밝음",
		"background_color": Color(0.58, 0.76, 0.86, 1.0),
		"ambient_color": Color(0.84, 0.91, 0.95, 1.0),
		"ambient_energy": 0.74,
		"light_color": Color(1.0, 1.0, 1.0, 1.0),
		"light_energy": 0.9,
		"backdrop_modulate": Color.WHITE,
	},
	"sunset": {
		"label": "해질녘",
		"background_color": Color(0.73, 0.56, 0.55, 1.0),
		"ambient_color": Color(0.88, 0.74, 0.73, 1.0),
		"ambient_energy": 0.70,
		"light_color": Color(1.0, 0.74, 0.58, 1.0),
		"light_energy": 0.76,
		"backdrop_modulate": Color(0.86, 0.91, 0.96, 1.0),
	},
	"night": {
		"label": "밤",
		"background_color": Color(0.12, 0.23, 0.35, 1.0),
		"ambient_color": Color(0.48, 0.61, 0.78, 1.0),
		"ambient_energy": 0.52,
		"light_color": Color(0.50, 0.64, 0.86, 1.0),
		"light_energy": 0.48,
		"backdrop_modulate": Color(0.45, 0.59, 0.78, 1.0),
	},
}


func get_time_of_day_ids() -> Array[String]:
	return TIME_OF_DAY_IDS.duplicate()


func normalize_time_of_day(value: String) -> String:
	return value if TIME_OF_DAY_IDS.has(value) else DEFAULT_TIME_OF_DAY


func get_label(value: String) -> String:
	var normalized := normalize_time_of_day(value)
	return str(DEFINITIONS[normalized]["label"])


func get_visual_tone(value: String) -> Dictionary:
	var normalized := normalize_time_of_day(value)
	return (DEFINITIONS[normalized] as Dictionary).duplicate(true)
