# 내부 Windows 빌드 export 설정을 검증한다.
extends SceneTree

func _init() -> void:
	var preset_text := FileAccess.get_file_as_string("res://export_presets.cfg")
	assert(not preset_text.is_empty(), "export_presets.cfg must exist")
	assert(preset_text.contains('name="Windows Desktop"'), "Windows Desktop preset is required")
	assert(preset_text.contains('platform="Windows Desktop"'), "Windows Desktop platform is required")
	assert(preset_text.contains('export_path="build/my_little_boat.exe"'), "internal Windows export path is required")
	assert(preset_text.contains('binary_format/architecture="x86_64"'), "x86_64 Windows export is required")
	print("Windows export contract passed")
	quit()
