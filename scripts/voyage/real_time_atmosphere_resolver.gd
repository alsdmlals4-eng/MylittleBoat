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
<<<<<<< HEAD
	var local_time := Time.get_time_dict_from_system(false)
	return resolve_hour(int(local_time.get("hour", -1)))
=======
	var time_dict := Time.get_time_dict_from_system(false)
	return resolve_hour(int(time_dict.get("hour", -1)))
>>>>>>> 8b78f8cba74d198a668ea2edcb77900d8b781564
