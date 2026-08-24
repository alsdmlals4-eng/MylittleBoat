# 실패 패널티 없이 캐스팅부터 입질까지의 낚시 상태를 관리한다.
class_name CalmFishingSession
extends RefCounted

enum State {
	IDLE,
	WAITING,
	BITE_READY,
}

var _state := State.IDLE
var _wait_remaining := 0.0


## Starts one calm fishing wait.
func cast_line(wait_seconds: float) -> void:
	_state = State.WAITING
	_wait_remaining = maxf(wait_seconds, 0.0)
	if _wait_remaining <= 0.0:
		_state = State.BITE_READY


## Advances the wait and reports true only when a new bite becomes ready.
func advance(delta: float) -> bool:
	if _state != State.WAITING:
		return false
	_wait_remaining = maxf(0.0, _wait_remaining - maxf(delta, 0.0))
	if _wait_remaining <= 0.0:
		_state = State.BITE_READY
		return true
	return false


func is_waiting() -> bool:
	return _state == State.WAITING


func is_bite_ready() -> bool:
	return _state == State.BITE_READY


## Resolves one ready bite without score, failure, or economy side effects.
func resolve_catch(fish_name: String) -> String:
	if _state != State.BITE_READY:
		return ""
	_state = State.IDLE
	_wait_remaining = 0.0
	return fish_name


## Cancels the current cast without penalty.
func cancel() -> void:
	_state = State.IDLE
	_wait_remaining = 0.0
