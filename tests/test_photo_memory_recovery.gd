# 사진 저장의 원본 보존·복구·안전한 읽기와 실제 앨범 소비 경계를 검증한다.
extends SceneTree

const OWNER = preload("res://scripts/core/photo_memory_persistence.gd")
const CLEANUP = preload("res://tests/helpers/config_store_test_cleanup.gd")
const PATH := "user://test_r07b2.cfg"
const DIR := "user://test_r07b2_images"
var failures := 0

class RejectPending extends "res://scripts/core/recoverable_config_store.gd":
	func _save(_config: ConfigFile, _path: String) -> Error:
		return ERR_FILE_CANT_WRITE

class FailedRestore extends "res://scripts/core/recoverable_config_store.gd":
	func _replace(_source: String, destination: String) -> Error:
		var file := FileAccess.open(destination, FileAccess.WRITE)
		file.store_string("[damaged]\nvalue=1\n")
		file.close()
		return ERR_FILE_CANT_WRITE
	func _copy(source: String, destination: String) -> Error:
		if source.ends_with(".last_good"):
			return ERR_FILE_CANT_WRITE
		return super._copy(source, destination)

class InterruptedPhoto extends "res://scripts/core/photo_memory_persistence.gd":
	func _write_png(path: String, bytes: PackedByteArray) -> Error:
		super._write_png(path, bytes)
		return ERR_FILE_CANT_WRITE

class UnsupportedLinkInspection extends "res://scripts/core/photo_memory_persistence.gd":
	func _supports_link_inspection() -> bool:
		return false

func _init() -> void:
	call_deferred("run")

func run() -> void:
	cleanup()
	var owner = OWNER.new(PATH, DIR)
	var image := Image.create_empty(4, 4, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.2, 0.6, 0.8))
	var first: Dictionary = owner.save_photo(image, "첫 사진", "bright")
	expect(first.get("ok", false), "normal PNG saves")
	var before_oversized_save := DirAccess.get_files_at(DIR)
	var oversized_axis := Image.create_empty(4097, 1, false, Image.FORMAT_RGBA8)
	oversized_axis.fill(Color.WHITE)
	expect(not owner.save_photo(oversized_axis, "읽을 수 없는 크기", "bright").get("ok", false), "save rejects a photo outside the Album decode boundary")
	expect(DirAccess.get_files_at(DIR) == before_oversized_save, "oversized save rejection leaves no PNG or receipt")
	var config := ConfigFile.new()
	config.load(PATH)
	var rows: Array = config.get_value("voyage_postcards", "entries")
	rows[0]["future"] = {"nested": [1, "preserve"]}
	config.set_value("voyage_postcards", "entries", rows)
	config.set_value("voyage_postcards", "future_key", 7)
	config.set_value("future_section", "opaque", ["keep"])
	config.save(PATH)
	var original := FileAccess.get_file_as_bytes(PATH)
	expect(owner.save_photo(image, "다음 사진", "night").get("ok", false), "second PNG saves")
	config.load(PATH)
	var saved: Array = config.get_value("voyage_postcards", "entries")
	expect(saved[0].get("future") == {"nested": [1, "preserve"]}, "save preserves opaque row fields")
	expect(config.get_value("voyage_postcards", "future_key", null) == 7, "save preserves unknown owner key")
	expect(config.get_value("future_section", "opaque", null) == ["keep"], "save preserves unknown section")
	expect(FileAccess.file_exists(PATH + ".last_good"), "update keeps validated backup")
	var api: bool = owner.has_method("resolve_photo_path") and owner.has_method("load_photo_image") and owner.has_method("recover_primary") and owner.has_method("get_last_storage_result")
	expect(api, "photo owner provides recovery and image boundary")
	if not api:
		cleanup()
		await finish()
		return
	expect(owner.get_last_storage_result().status == "COMMITTED", "success only follows commit")
	expect(FileAccess.get_file_as_bytes(PATH + ".last_good") == original, "backup matches exact original bytes")
	expect(owner.resolve_photo_path(first) == first.image_path, "normal user path remains unchanged")
	expect(owner.load_photo_image(first) != null, "normal PNG safely decodes")
	var unsupported := UnsupportedLinkInspection.new(PATH, DIR)
	var supported_bytes := FileAccess.get_file_as_bytes(first.image_path)
	var unsupported_files := DirAccess.get_files_at(DIR)
	expect(unsupported.resolve_photo_path(first).is_empty(), "indeterminate link inspection rejects an existing owned photo")
	expect(unsupported.load_photo_image(first) == null, "indeterminate link inspection refuses image decode")
	expect(not unsupported.save_photo(image, "지원 미확인", "bright").get("ok", false), "indeterminate link inspection rejects photo save")
	expect(FileAccess.get_file_as_bytes(first.image_path) == supported_bytes, "unsupported inspection leaves the existing photo bytes unchanged")
	expect(DirAccess.get_files_at(DIR) == unsupported_files, "unsupported inspection leaves no PNG or receipt")
	for bad_id in ["", ".", "..", "../escape", "a/b", "a\\b", "C:escape", "name.png", "name."]:
		var bad := first.duplicate(true)
		bad.id = bad_id
		expect(owner.resolve_photo_path(bad).is_empty(), "unsafe ID rejected: " + bad_id)
	for bad_path in ["user://test_r07b2_images_sibling/" + first.id + ".png", DIR + "/../" + first.id + ".png", str(first.image_path).replace("/", "\\"), ProjectSettings.globalize_path(first.image_path), "res://" + first.id + ".png"]:
		var bad := first.duplicate(true)
		bad.image_path = bad_path
		expect(owner.resolve_photo_path(bad).is_empty(), "unsafe metadata path rejected")
	var first_bytes := FileAccess.get_file_as_bytes(first.image_path)
	if OS.get_environment("MLB_R07B2_DECODER_NEGATIVE") == "1":
		var malformed_deflate := first_bytes.duplicate()
		var offset := 8
		while offset + 12 <= malformed_deflate.size():
			var length := read_u32(malformed_deflate, offset)
			if malformed_deflate.slice(offset + 4, offset + 8).get_string_from_ascii() == "IDAT":
				malformed_deflate[offset + 8] = 0
				var crc := 0xffffffff
				for index in range(offset + 4, offset + 8 + length):
					crc ^= malformed_deflate[index]
					for bit in 8:
						crc = (crc >> 1) ^ (0xedb88320 if crc & 1 else 0)
				crc ^= 0xffffffff
				for byte in 4:
					malformed_deflate[offset + 8 + length + byte] = (crc >> (24 - byte * 8)) & 255
				break
			offset += 12 + length
		write_bytes(first.image_path, malformed_deflate)
		print("EXPECTED_LIBPNG_DIAGNOSTICS_BEGIN")
		expect(owner.load_photo_image(first) == null, "valid CRC invalid compressed stream returns unavailable")
		print("EXPECTED_LIBPNG_DIAGNOSTICS_END")
		expect(FileAccess.get_file_as_bytes(first.image_path) == malformed_deflate, "invalid compressed stream preserves exact source")
		write_bytes(first.image_path, first_bytes)
	var corrupt_payload := first_bytes.duplicate()
	corrupt_payload[corrupt_payload.size() - 18] ^= 127
	write_bytes(first.image_path, corrupt_payload)
	expect(owner.load_photo_image(first) == null, "damaged compressed payload unavailable without global error suppression")
	write_bytes(first.image_path, "broken PNG".to_utf8_buffer())
	expect(owner.load_photo_image(first) == null, "malformed PNG unavailable")
	var huge := first_bytes.duplicate()
	huge[16] = 127
	write_bytes(first.image_path, huge)
	expect(owner.load_photo_image(first) == null, "huge IHDR rejected before decode")
	expect(FileAccess.get_file_as_bytes(first.image_path) == huge, "rejected image bytes preserved")
	write_bytes(first.image_path, first_bytes)
	var oversized := PackedByteArray()
	oversized.resize(32 * 1024 * 1024 + 1)
	write_bytes(first.image_path, oversized)
	expect(owner.load_photo_image(first) == null, "over 32 MiB rejected before allocation for decode")
	expect(FileAccess.get_file_as_bytes(first.image_path).size() == 33554433, "oversized source remains intact")
	write_bytes(first.image_path, first_bytes)
	if OS.get_environment("MLB_R07B2_LINK_FIXTURE") == "1":
		expect(image.save_png("user://test_r07b2_link_target/fixture.png") == OK, "junction target PNG fixture saves")
		var linked = OWNER.new(PATH, "user://test_r07b2_link")
		var link_entry := {"id": "fixture", "image_path": "user://test_r07b2_link/fixture.png"}
		expect(DirAccess.open("user://").is_link("test_r07b2_link"), "Windows junction detected by current Godot")
		expect(FileAccess.file_exists(link_entry.image_path), "junction fixture actually resolves to PNG")
		expect(linked.resolve_photo_path(link_entry).is_empty(), "junction cannot bypass owned directory")
		expect(not linked.save_photo(image, "우회", "bright").get("ok", false), "photo save cannot write through junction")
		print("WINDOWS_JUNCTION_REJECTION_EXERCISED")
		DirAccess.remove_absolute("user://test_r07b2_link_target/fixture.png")
		expect(DirAccess.remove_absolute("user://test_r07b2_link") == OK, "junction fixture removes without touching target")
		expect(DirAccess.remove_absolute("user://test_r07b2_link_target") == OK, "empty junction target fixture removes")
		expect(not DirAccess.dir_exists_absolute("user://test_r07b2_link") and not DirAccess.dir_exists_absolute("user://test_r07b2_link_target"), "junction fixtures leave no test storage behind")
	var damaged := "[voyage_postcards]\nentries=42\n".to_utf8_buffer()
	write_bytes(PATH, damaged)
	var entries: Array = owner.load_entries()
	expect(entries.size() == 1 and entries[0].has("future"), "validated backup read preserves opaque fields")
	expect(owner.get_last_storage_result().status == "RECOVERED", "backup read reports recovered")
	expect(FileAccess.get_file_as_bytes(PATH) == damaged and not FileAccess.file_exists(PATH + ".recovery.json"), "read never repairs or writes receipt")
	expect(not owner.save_photo(image, "차단", "bright").get("ok", false), "corrupt primary blocks new PNG")
	expect(owner.get_last_storage_result().status == "RECOVERY_REQUIRED", "corrupt source requires explicit recovery")
	expect(owner.recover_primary().status == "COMMITTED", "explicit recovery commits original")
	expect(FileAccess.get_file_as_bytes(PATH) == original, "explicit recovery restores exact original")
	owner._store = RejectPending.new()
	var before_files := DirAccess.get_files_at(DIR)
	expect(not owner.save_photo(image, "쓰기 실패", "bright").get("ok", false), "pending write failure rejects save")
	expect(owner.get_last_storage_result().status == "NOT_COMMITTED", "verified precommit failure explicit")
	expect(FileAccess.get_file_as_bytes(PATH) == original, "precommit failure preserves ledger")
	expect(DirAccess.get_files_at(DIR) == before_files, "only verified uncommitted PNG and own receipt cleaned")
	expect(owner.recover_primary().status == "COMMITTED", "pending failure explicit recovery")
	owner._store = FailedRestore.new()
	expect(not owner.save_photo(image, "미확정", "bright").get("ok", false), "failed restore not successful")
	expect(owner.get_last_storage_result().status == "RECOVERY_REQUIRED", "failed restore remains uncertain")
	var after_files := DirAccess.get_files_at(DIR)
	expect(after_files.size() == before_files.size() + 2, "uncertain PNG plus owner receipt preserved")
	for name in after_files:
		if name.ends_with(".photo_pending.json"):
			var receipt: Variant = JSON.parse_string(FileAccess.get_file_as_string(DIR.path_join(name)))
			expect(receipt is Dictionary, "photo-owned interruption receipt parses")
			if receipt is Dictionary:
				expect(receipt.original_hash == FileAccess.get_sha256(PATH + ".last_good"), "receipt retains pre-save ledger hash")
				expect(receipt.png_hash == FileAccess.get_sha256(receipt.image_path), "receipt binds exact created PNG hash")
				expect(receipt.image_path == DIR.path_join(receipt.id + ".png"), "receipt binds ID to expected owned filename")
	owner._store = preload("res://scripts/core/recoverable_config_store.gd").new()
	expect(owner.recover_primary().status == "COMMITTED", "uncertain ledger can explicitly recover")
	var preserved := DirAccess.get_files_at(DIR)
	expect(owner.save_photo(image, "다시 촬영", "bright").get("ok", false), "new save after recovery")
	for name in preserved:
		expect(FileAccess.file_exists(DIR.path_join(name)), "later save never erases earlier uncertain photo evidence")
	var interrupted := InterruptedPhoto.new(PATH, DIR)
	var before_interruption := FileAccess.get_file_as_bytes(PATH)
	var files_before_interruption := DirAccess.get_files_at(DIR)
	expect(not interrupted.save_photo(image, "PNG 이후 중단", "bright").get("ok", false), "PNG phase interruption never commits ledger")
	expect(interrupted.get_last_storage_result().status == "RECOVERY_REQUIRED", "uncertain PNG phase reports recovery needed")
	expect(FileAccess.get_file_as_bytes(PATH) == before_interruption, "PNG phase interruption leaves original ledger bytes")
	expect(DirAccess.get_files_at(DIR).size() == files_before_interruption.size() + 2, "pre-ledger interruption retains PNG plus durable intent")
	await check_album(first)
	check_three_full_size_photo_load_cost()
	write_bytes(PATH, damaged)
	write_bytes(PATH + ".last_good", damaged)
	expect(owner.load_entries().is_empty(), "damaged primary and backup never become valid read")
	expect(owner.get_last_storage_result().status == "CORRUPT", "damaged backup is not recovered")
	expect(owner.recover_primary().status == "RECOVERY_REQUIRED", "damaged backup cannot authorize recovery")
	cleanup()
	await finish()

func check_three_full_size_photo_load_cost() -> void:
	var benchmark_path := "user://test_r07b2_load_cost.cfg"
	var benchmark_dir := "user://test_r07b2_load_cost_images"
	CLEANUP.remove_store(benchmark_path)
	var benchmark = OWNER.new(benchmark_path, benchmark_dir)
	var image := Image.create_empty(540, 960, false, Image.FORMAT_RGBA8)
	image.fill(Color(0.15, 0.55, 0.75, 1.0))
	for index in 3:
		expect(benchmark.save_photo(image, "성능 검사 %d" % index, "bright").get("ok", false), "540x960 benchmark photo saves")
	var entries := benchmark.load_entries()
	var started := Time.get_ticks_usec()
	for entry in entries:
		expect(benchmark.load_photo_image(entry) != null, "540x960 benchmark photo safely loads")
	var elapsed_usec := Time.get_ticks_usec() - started
	print("PHOTO_540X960_THREE_LOAD_USEC=%d" % elapsed_usec)
	expect(entries.size() == 3, "load-cost fixture contains exactly three photos")
	CLEANUP.remove_store(benchmark_path)
	if DirAccess.dir_exists_absolute(benchmark_dir):
		for name in DirAccess.get_files_at(benchmark_dir):
			DirAccess.remove_absolute(benchmark_dir.path_join(name))
		DirAccess.remove_absolute(benchmark_dir)

func check_album(entry: Dictionary) -> void:
	var state := root.get_node("GameState")
	state.set_photo_memory_storage(PATH, DIR)
	var bad := entry.duplicate(true)
	bad.id = "different_id"
	state.photo_memories.assign([bad])
	var album: Node = load("res://scenes/album.tscn").instantiate()
	root.add_child(album)
	await process_frame
	var card: Node = album.get_node("%PostcardRow").get_child(0)
	expect(card.get_node("Image").texture == null and card.has_node("UnavailableLabel"), "actual Album rejects existing PNG with forged basename")
	state.photo_memories.assign([entry])
	album.refresh_album()
	card = album.get_node("%PostcardRow").get_child(0)
	expect(card.get_node("Image").texture != null, "actual Album loads approved owner path through GameState")
	var capture_path := OS.get_environment("MLB_R07B2_ALBUM_CAPTURE")
	if not capture_path.is_empty():
		await RenderingServer.frame_post_draw
		var capture := root.get_viewport().get_texture().get_image()
		expect(not capture.is_empty() and capture.save_png(capture_path) == OK, "GPU Album evidence capture saves outside the project")
		print("ALBUM_GPU_CAPTURE=" + capture_path)
	album.queue_free()
	await process_frame

func write_bytes(path: String, bytes: PackedByteArray) -> void:
	var file := FileAccess.open(path, FileAccess.WRITE)
	file.store_buffer(bytes)
	file.close()

func read_u32(bytes: PackedByteArray, offset: int) -> int:
	return (int(bytes[offset]) << 24) | (int(bytes[offset + 1]) << 16) | (int(bytes[offset + 2]) << 8) | int(bytes[offset + 3])

func cleanup() -> void:
	CLEANUP.remove_store(PATH)
	if DirAccess.dir_exists_absolute(DIR):
		for name in DirAccess.get_files_at(DIR):
			DirAccess.remove_absolute(DIR.path_join(name))
		DirAccess.remove_absolute(DIR)

func expect(condition: bool, message: String) -> void:
	if not condition:
		failures += 1
		printerr("FAIL: " + message)

func finish() -> void:
	var soundscape := root.get_node_or_null("RestingSoundscape")
	if soundscape != null and soundscape.has_method("release_ocean_bed_for_shutdown"):
		soundscape.call("release_ocean_bed_for_shutdown")
	await process_frame
	await process_frame
	print("PHOTO_MEMORY_RECOVERY_FAILURES=%d" % failures)
	quit(1 if failures else 0)
