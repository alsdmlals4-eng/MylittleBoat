# 함께한 시간을 앨범용으로만 조용하게 문장화한다.
class_name TogetherTimePresentation
extends RefCounted


func get_duration_copy(seconds: float) -> String:
	var whole_minutes := _get_whole_minutes(seconds)
	if whole_minutes <= 0:
		return "함께한 시간: 잠시"
	var hours := whole_minutes / 60
	var minutes := whole_minutes % 60
	if hours <= 0:
		return "함께한 시간: %d분" % whole_minutes
	if minutes <= 0:
		return "함께한 시간: %d시간" % hours
	return "함께한 시간: %d시간 %d분" % [hours, minutes]


func get_relation_copy(seconds: float) -> String:
	if _get_whole_minutes(seconds) <= 0:
		return "동반자와 같은 바다에 머물고 있어요."
	return "동반자와 같은 바다를 천천히 바라봤어요."


func _get_whole_minutes(seconds: float) -> int:
	if is_nan(seconds) or is_inf(seconds) or seconds <= 0.0:
		return 0
	return int(floor(seconds / 60.0))
