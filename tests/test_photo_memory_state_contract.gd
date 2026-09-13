# GameState가 실제 포스트카드를 저장하되 항해 진행과 분리하는지 검증한다.
extends SceneTree

const CONFIG_PATH := "user://test_photo_memory_state.cfg"
const IMAGE_DIRECTORY := "user://test_photo_memory_state_images"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	var state := root.get_node_or_null("GameState")
	_expect(state != null, "GameState autoload must exist")
	if state == null:
		_finish()
		return
	_cleanup_storage()
	_expect(state.has_method("set_photo_memory_storage"), "GameState must expose isolated postcard storage")
	_expect(state.has_method("record_photo_memory"), "GameState must expose a durable postcard writer")
	_expect(state.has_method("load_photo_memories"), "GameState must restore durable postcard memories")
	if state.has_method("set_photo_memory_storage") and state.has_method("record_photo_memory") and state.has_method("load_photo_memories"):
		state.set_photo_memory_storage(CONFIG_PATH, IMAGE_DIRECTORY)
		var together_before: float = float(state.together_time_seconds)
		var ambient_before: Array = state.ambient_memories.duplicate(true)
		var speed_before: int = int(state.speed_index)
		var image := Image.create_empty(4, 4, false, Image.FORMAT_RGBA8)
		image.fill(Color(0.18, 0.26, 0.62, 1.0))
		_expect(state.record_photo_memory(image, "밤의 물결", "night"), "GameState must store a real postcard")
		_expect(state.photo_memories.size() == 1, "one stored postcard appears in durable GameState ledger")
		_expect(state.photos == ["밤의 물결"], "postcard rebuilds the legacy quiet photo summary")
		if state.photo_memories.size() == 1:
			_expect(FileAccess.file_exists(str(state.photo_memories[0].get("image_path", ""))), "GameState postcard must point to a real local image")
		_expect(is_equal_approx(state.together_time_seconds, together_before), "postcard does not grant together time")
		_expect(state.ambient_memories == ambient_before, "postcard does not change ambient discoveries")
		_expect(state.speed_index == speed_before, "postcard does not change drift speed")
		state.photo_memories.clear()
		state.photos.clear()
		state.load_photo_memories()
		_expect(state.photo_memories.size() == 1 and state.photos == ["밤의 물결"], "new GameState load restores postcard ledger and legacy summary")
		var before_memories: Array = state.photo_memories.duplicate(true)
		var before_photos: Array = state.photos.duplicate()
		var damaged := "[voyage_postcards]\nentries=42\n"
		var file := FileAccess.open(CONFIG_PATH, FileAccess.WRITE)
		file.store_string(damaged)
		file.close()
		_expect(not state.record_photo_memory(image, "저장되지 않은 사진", "bright"), "damaged disk ledger must not produce a successful GameState photo")
		_expect(state.photo_memories == before_memories and state.photos == before_photos, "failed disk save must preserve in-memory album and legacy summary")
		_expect(FileAccess.get_file_as_string(CONFIG_PATH) == damaged, "failed GameState save must retain recoverable source bytes")
	_cleanup_storage()
	_finish()


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
		print("PASS: photo-memory state contract")
		quit(0)
	else:
		printerr("FAILED: %d photo-memory state assertions" % _failures)
		quit(1)
