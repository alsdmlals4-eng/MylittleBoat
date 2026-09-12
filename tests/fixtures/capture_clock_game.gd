# 실제 항해 코드를 상속하되 촬영 시 지정한 시각을 유지하는 검사 전용 fixture다.
extends "res://scripts/voyage/game_scene.gd"

func refresh_real_time_atmosphere() -> String:
	return get_active_atmosphere_id()
