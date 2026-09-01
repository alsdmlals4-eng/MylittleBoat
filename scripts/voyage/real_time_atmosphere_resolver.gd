# 현지 현실 시간을 승인된 항해 분위기 ID로 바꾼다.
class_name RealTimeAtmosphereResolver
extends RefCounted


func resolve_hour(hour: int) -> String:
	if hour < 0 or hour > 23:
		return "bright"
	if hour <= 4 or hour >= 21:
		return "night"
	if hour <= 8:
		return "dawn"
	if hour <= 16:
		return "bright"
	return "sunset"


func resolve_system_time() -> String:
	var local_time := Time.get_time_dict_from_system(false)
	return resolve_hour(int(local_time.get("hour", -1)))


## Resolves the local calendar only into a visual bucket; it never owns gameplay time or persistence.
func resolve_season_for_month(month: int) -> String:
	return "spring" if month >= 3 and month <= 5 else ""


func resolve_system_season() -> String:
	var local_date := Time.get_date_dict_from_system(false)
	return resolve_season_for_month(int(local_date.get("month", -1)))
