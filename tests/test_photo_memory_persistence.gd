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
	# 누락 PNG 자체는 손상이 아니다. 읽기에서 제외된 잘못된 행은 별도 보존 검사로 다룬다.
	var valid_missing_config := ConfigFile.new()
	valid_missing_config.set_value("voyage_postcards", "entries", missing_entries)
	valid_missing_config.save(CONFIG_PATH)
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
	for damaged_contents in ["[voyage_postcards]\nentries=42\n", "[unrecognized]\noriginal=\"보존해야 하는 기록\"\n", "[voyage_postcards]\nentries=[{\"id\":\"recoverable-partial-row\"}]\n"]:
		_write_raw_config(damaged_contents)
		var before_bytes := FileAccess.get_file_as_bytes(CONFIG_PATH)
		var before_files := DirAccess.get_files_at(IMAGE_DIRECTORY)
		var rejected: Dictionary = persistence.save_photo(image, "덮어쓰면 안 되는 사진", "bright")
		_expect(not rejected.get("ok", false), "unrecognized postcard ledger must reject writes rather than reset the album")
		_expect(FileAccess.get_file_as_bytes(CONFIG_PATH) == before_bytes, "rejected save must preserve the exact damaged ledger for recovery")
		_expect(DirAccess.get_files_at(IMAGE_DIRECTORY) == before_files, "rejected ledger must not leave a new orphan photo")
	for invalid_field in ["id", "label", "atmosphere_id", "image_path"]:
		var invalid_entry := {"id": "retained", "label": "원본 기억", "atmosphere_id": "bright", "image_path": "user://missing.png"}
		invalid_entry[invalid_field] = 123
		var invalid_config := ConfigFile.new()
		invalid_config.set_value("voyage_postcards", "entries", [invalid_entry])
		_expect(invalid_config.save(CONFIG_PATH) == OK, "typed-invalid fixture must save")
		_expect_rejected_unchanged(persistence, image)
	_write_raw_config("[voyage_postcards]\nentries=[{\"id\":\n")
	# 알려진 파서 오류만 동기적으로 검사하며 이후 오류 출력 설정을 즉시 복구한다.
	var previous_error_output := Engine.print_error_messages
	Engine.print_error_messages = false
	var parse_error := ConfigFile.new().load(CONFIG_PATH)
	var malformed_bytes := FileAccess.get_file_as_bytes(CONFIG_PATH)
	var malformed_files := DirAccess.get_files_at(IMAGE_DIRECTORY)
	var malformed_result: Dictionary = persistence.save_photo(image, "새 사진", "bright")
	Engine.print_error_messages = previous_error_output
	_expect(parse_error == ERR_PARSE_ERROR, "malformed fixture must exercise parser failure")
	_expect(not malformed_result.get("ok", false), "parser failure must reject photo save")
	_expect(FileAccess.get_file_as_bytes(CONFIG_PATH) == malformed_bytes, "parser failure must preserve ledger bytes")
	_expect(DirAccess.get_files_at(IMAGE_DIRECTORY) == malformed_files, "parser failure must not create a photo")
	print("EXPECTED_CONFIG_PARSE_FAILURE_EXERCISED")
	_cleanup_storage()
	_finish()


func _expect_rejected_unchanged(persistence: Variant, image: Image) -> void:
	var before_bytes := FileAccess.get_file_as_bytes(CONFIG_PATH)
	var before_files := DirAccess.get_files_at(IMAGE_DIRECTORY)
	var rejected: Dictionary = persistence.save_photo(image, "보존 검사", "bright")
	_expect(not rejected.get("ok", false), "non-string metadata must reject writes")
	_expect(FileAccess.get_file_as_bytes(CONFIG_PATH) == before_bytes, "typed-invalid ledger must retain exact bytes")
	_expect(DirAccess.get_files_at(IMAGE_DIRECTORY) == before_files, "typed-invalid ledger must not create an orphan")


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
