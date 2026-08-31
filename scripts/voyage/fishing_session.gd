# 실패 패널티 없이 캐스팅부터 입질까지의 낚시 상태를 관리한다.
class_name CalmFishingSession
extends RefCounted

enum State {
	IDLE,
	WAITING,
	BITE_READY,
	QUIET_READY,
}

var _state := State.IDLE
var _wait_remaining := 0.0
var _outcome_id := "catch"


## Starts one calm fishing wait with either a catch or a quiet no-catch ending.
func cast_line(wait_seconds: float, outcome_id: String = "catch") -> void:
	_state = State.WAITING
	_wait_remaining = maxf(wait_seconds, 0.0)
	_outcome_id = "quiet" if outcome_id == "quiet" else "catch"
	if _wait_remaining <= 0.0:
		_finish_wait()


## Advances the wait and reports true only when one calm result becomes ready.
func advance(delta: float) -> bool:
	if _state != State.WAITING:
		return false
	_wait_remaining = maxf(0.0, _wait_remaining - maxf(delta, 0.0))
	if _wait_remaining <= 0.0:
		_finish_wait()
		return true
	return false


func is_waiting() -> bool:
	return _state == State.WAITING


func is_bite_ready() -> bool:
	return _state == State.BITE_READY


func is_quiet_ready() -> bool:
	return _state == State.QUIET_READY


## Resolves one ready bite without score, failure, or economy side effects.
func resolve_catch(fish_name: String) -> String:
	if _state != State.BITE_READY:
		return ""
	_state = State.IDLE
	_wait_remaining = 0.0
	return fish_name


## Resolves a quiet no-catch result without a loss, score, or stored reward.
func resolve_quiet() -> bool:
	if _state != State.QUIET_READY:
		return false
	_state = State.IDLE
	_wait_remaining = 0.0
	return true


## Cancels the current cast without penalty.
func cancel() -> void:
	_state = State.IDLE
	_wait_remaining = 0.0


func _finish_wait() -> void:
	_state = State.QUIET_READY if _outcome_id == "quiet" else State.BITE_READY
