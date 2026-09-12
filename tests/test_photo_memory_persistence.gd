# 실제 항해 포스트카드 PNG와 메타데이터가 로컬에서 함께 복원되는지 검증한다.
extends SceneTree

const PERSISTENCE_PATH := "res://scripts/core/photo_memory_persistence.gd"
const CONFIG_PATH := "user://test_photo_memory_persistence.cfg"
const IMAGE_DIRECTORY := "user://test_photo_memory_images"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_cleanup_storage()
	_expect(ResourceLoader.exists(PERSISTENCE_PATH), "photo-memory persistence owner must exist")
	if not ResourceLoader.exists(PERSISTENCE_PATH):
		_finish()
		return
	var persistence: Variant = (load(PERSISTENCE_PATH) as Script).new(CONFIG_PATH, IMAGE_DIRECTORY)
	_expect(persistence.load_entries().is_empty(), "missing postcard storage must restore an empty ledger")
	var image := Image.create_empty(4, 4, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.2, 0.6, 0.8, 1.0))
	var result: Dictionary = persistence.save_photo(image, "밝은 바다의 물결", "bright")
	_expect(bool(result.get("ok", false)), "real postcard image must save successfully")
	_expect(FileAccess.file_exists(str(result.get("image_path", ""))), "saved postcard must create a local PNG")
	var restored: Array[Dictionary] = persistence.load_entries()
	_expect(restored.size() == 1, "one valid postcard metadata entry must restore")
	if restored.size() == 1:
		_expect(str(restored[0].get("label", "")) == "밝은 바다의 물결", "restored postcard keeps its quiet label")
		_expect(str(restored[0].get("atmosphere_id", "")) == "bright", "restored postcard keeps actual atmosphere id")
		_expect(FileAccess.file_exists(str(restored[0].get("image_path", ""))), "restored postcard points to an existing local image")
	_write_raw_config("[voyage_postcards]\nentries=[{\"id\":\"missing\",\"label\":\"사라진 그림\",\"atmosphere_id\":\"night\",\"image_path\":\"user://does_not_exist.png\"},{\"id\":\"blank\",\"label\":\"  \",\"atmosphere_id\":\"night\",\"image_path\":\"user://does_not_exist.png\"}]\n")
	var missing_entries: Array = persistence.load_entries()
	_expect(missing_entries.size() == 1, "missing PNG must retain its caption while blank metadata stays invalid")
	persistence.save_photo(image, "다음 물결", "bright")
	var reloaded = (load(PERSISTENCE_PATH) as Script).new(CONFIG_PATH, IMAGE_DIRECTORY)
	_expect(reloaded.load_entries().size() == 2, "saving another photo must not erase an unavailable memory")
	var reserved_id := "postcard_%d" % int(Time.get_unix_time_from_system())
	var reserved_path := IMAGE_DIRECTORY.path_join(reserved_id + ".png")
	if FileAccess.file_exists(reserved_path):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(reserved_path))
	var config := ConfigFile.new()
	config.set_value("voyage_postcards", "entries", [{"id": reserved_id, "label": "남아 있는 기억", "atmosphere_id": "bright", "image_path": IMAGE_DIRECTORY.path_join(reserved_id + ".png")}])
	config.save(CONFIG_PATH)
	var replacement: Dictionary = reloaded.save_photo(image, "새 사진", "bright")
	_expect(replacement.get("id") != reserved_id, "new photo must not reuse the ID of a missing image")
	_cleanup_storage()
	_finish()


func _write_raw_config(contents: String) -> void:
	var file := FileAccess.open(CONFIG_PATH, FileAccess.WRITE)
	_expect(file != null, "test must be able to write isolated postcard metadata")
	if file != null:
		file.store_string(contents)


func _cleanup_storage() -> void:
	if FileAccess.file_exists(CONFIG_PATH):
		DirAccess.remove_absolute(ProjectSettings.globalize_path(CONFIG_PATH))
	var absolute_directory := ProjectSettings.globalize_path(IMAGE_DIRECTORY)
	if not DirAccess.dir_exists_absolute(absolute_directory):
		return
	var directory := DirAccess.open(absolute_directory)
	if directory != null:
		for file_name in directory.get_files():
			DirAccess.remove_absolute(absolute_directory.path_join(file_name))
	DirAccess.remove_absolute(absolute_directory)


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: photo-memory persistence contract")
		quit(0)
	else:
		printerr("FAILED: %d photo-memory persistence assertions" % _failures)
		quit(1)
