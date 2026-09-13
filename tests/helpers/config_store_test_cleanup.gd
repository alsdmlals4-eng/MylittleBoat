# 격리 테스트 설정 경로의 저장 및 복구 파생 파일만 정리한다.
extends RefCounted

static func remove_store(path: String) -> void:
	assert(path.begins_with("user://test_"))
	var directory := path.get_base_dir()
	var base := path.get_file()
	for name in DirAccess.get_files_at(directory):
		if name == base or name in [base + ".pending", base + ".last_good", base + ".recovery.json"] or name.begins_with(base + ".recovery.") or name.begins_with(base + ".pending.recovery.") or name.begins_with(base + ".last_good.recovery."):
			DirAccess.remove_absolute(ProjectSettings.globalize_path(directory.path_join(name)))
