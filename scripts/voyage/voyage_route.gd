# 보트의 직선 항해 경로를 다음 구간으로 이어 이동 위치가 되감기지 않게 한다.
extends Path3D

const SEGMENT_LENGTH := 128.0

@onready var _progress := $BoatProgress as PathFollow3D

func _ready() -> void:
	curve = Curve3D.new()
	curve.add_point(Vector3.ZERO)
	curve.add_point(Vector3(0.0, 0.0, SEGMENT_LENGTH))
	_progress.loop = false
	# 현재 직선 구간은 선형 샘플링으로 거리와 세계 이동량을 일치시킨다.
	_progress.cubic_interp = false
	_progress.rotation_mode = PathFollow3D.ROTATION_NONE

func advance_distance(distance: float) -> void:
	if not is_finite(distance) or distance <= 0.0:
		return
	var next_distance := _progress.progress + distance
	var crossed_segments := floorf(next_distance / SEGMENT_LENGTH)
	# 구간 원점과 구간 내 진행을 함께 옮겨 세계 위치의 연속성을 유지한다.
	position.z += crossed_segments * SEGMENT_LENGTH
	_progress.progress = fposmod(next_distance, SEGMENT_LENGTH)
