# 실제 계정 없이 병편지 eligibility 계약만 재현하는 로컬 fake 세션이다.
extends RefCounted

var _social_status := "local_only"
var _age_bucket := "unknown"
var _terms_accepted := false
var _account_age_seconds := 0.0
var _completed_voyages := 0


func configure(
	social_status: String,
	age_bucket: String,
	terms_accepted: bool,
	account_age_seconds: float,
	completed_voyages: int
) -> void:
	_social_status = social_status
	_age_bucket = age_bucket
	_terms_accepted = terms_accepted
	_account_age_seconds = maxf(account_age_seconds, 0.0)
	_completed_voyages = maxi(completed_voyages, 0)


func can_use_friend_bottle() -> bool:
	return (
		_social_status == "linked_social"
		and _age_bucket == "16plus"
		and _terms_accepted
	)


func can_use_drift_bottle() -> bool:
	return (
		(_social_status == "anonymous_social" or _social_status == "linked_social")
		and _age_bucket == "16plus"
		and _terms_accepted
		and _account_age_seconds >= 600.0
		and _completed_voyages >= 1
	)


func get_social_status() -> String:
	return _social_status
