# Headless import 중 editor 보조 플러그인이 서버를 만들지 않는지 검증한다.
extends SceneTree

const HERA_PLUGIN_PATH := "res://addons/hera_agent_godot/hera_agent_plugin.gd"

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	_expect(FileAccess.file_exists(HERA_PLUGIN_PATH), "Hera editor plugin source must exist")
	if FileAccess.file_exists(HERA_PLUGIN_PATH):
		var source := FileAccess.get_file_as_string(HERA_PLUGIN_PATH)
		_expect(source.contains("func _enter_tree() -> void:\n\tif DisplayServer.get_name() == \"headless\":\n\t\treturn"), "Hera plugin must return before registering editor resources in headless mode")
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: headless editor plugin guard contract")
		quit(0)
	else:
		printerr("FAILED: %d headless editor plugin guard assertions" % _failures)
		quit(1)
