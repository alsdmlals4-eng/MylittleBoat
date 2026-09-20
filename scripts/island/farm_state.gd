# 섬 농장의 순수 상태 검증·성장·명령 후보 계산을 담당한다.
extends RefCounted

const MAX_COUNTER := 9007199254740991
const PLOT_IDS := ["plot_01", "plot_02", "plot_03", "plot_04", "plot_05", "plot_06"]
var _crops: Dictionary

func _init(crops: Dictionary) -> void:
	_crops = crops.duplicate(true)

static func _number(value: Variant) -> bool:
	return (typeof(value) == TYPE_FLOAT or typeof(value) == TYPE_INT) and is_finite(float(value))

static func _keys(value: Variant, keys: Array) -> bool:
	return value is Dictionary and value.size() == keys.size() and value.has_all(keys)

static func load_catalog(path: String) -> Dictionary:
	var invalid := {"status": "INVALID_CATALOG", "crops": {}}
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null: return invalid
	var json := JSON.new()
	if json.parse(file.get_as_text()) != OK: return invalid
	var data: Variant = json.data
	if not _keys(data, ["schema_version", "crops"]): return invalid
	if not _number(data.schema_version) or data.schema_version != 1: return invalid
	if not _keys(data.crops, ["radish", "tomato"]): return invalid
	for crop in data.crops.values():
		if not _keys(crop, ["growth_seconds", "care_credit_ratio", "young_threshold", "visual_id"]): return invalid
		if not _number(crop.growth_seconds) or crop.growth_seconds <= 0: return invalid
		if not _number(crop.care_credit_ratio) or crop.care_credit_ratio < 0 or crop.care_credit_ratio > 0.25: return invalid
		if not _number(crop.young_threshold) or crop.young_threshold <= 0 or crop.young_threshold >= 1: return invalid
		if not crop.visual_id is String or crop.visual_id.strip_edges().is_empty(): return invalid
	return {"status": "OK", "crops": data.crops.duplicate(true)}

func new_snapshot(now_utc: float) -> Dictionary:
	if not is_finite(now_utc) or now_utc < 0: return {}
	var plots := {}
	for id in PLOT_IDS:
		plots[id] = {"crop_id": "", "generation": 0, "elapsed_seconds": 0.0, "cared": false}
	return {"schema_version": 1, "revision": 0, "saved_at_utc": now_utc, "plots": plots,
		"last_harvest_crop": "", "player": {"x": 0.0, "z": 0.0, "yaw": 0.0}}

func validate_snapshot(value: Variant) -> bool:
	if not _keys(value, ["schema_version", "revision", "saved_at_utc", "plots", "last_harvest_crop", "player"]): return false
	if typeof(value.schema_version) != TYPE_INT or value.schema_version != 1: return false
	if not _counter(value.revision): return false
	if not _number(value.saved_at_utc) or value.saved_at_utc < 0: return false
	if not _keys(value.plots, PLOT_IDS): return false
	if not value.last_harvest_crop is String: return false
	if value.last_harvest_crop != "" and not _crops.has(value.last_harvest_crop): return false
	if not _keys(value.player, ["x", "z", "yaw"]): return false
	for position in value.player.values():
		if not _number(position): return false
	for plot in value.plots.values():
		if not _valid_plot(plot): return false
	return true

func _valid_plot(plot: Variant) -> bool:
	if not _keys(plot, ["crop_id", "generation", "elapsed_seconds", "cared"]): return false
	if not plot.crop_id is String or not _counter(plot.generation): return false
	if typeof(plot.cared) != TYPE_BOOL or not _number(plot.elapsed_seconds) or plot.elapsed_seconds < 0: return false
	if plot.crop_id == "": return plot.elapsed_seconds == 0 and not plot.cared
	return _crops.has(plot.crop_id) and plot.elapsed_seconds <= _crops[plot.crop_id].growth_seconds

static func _counter(value: Variant) -> bool:
	return typeof(value) == TYPE_INT and value >= 0 and value <= MAX_COUNTER

func phase(plot: Dictionary) -> String:
	if not _valid_plot(plot): return "INVALID"
	if plot.crop_id == "": return "EMPTY"
	var crop: Dictionary = _crops[plot.crop_id]
	if plot.elapsed_seconds >= crop.growth_seconds: return "MATURE"
	return "YOUNG" if plot.elapsed_seconds >= crop.growth_seconds * crop.young_threshold else "SEEDLING"

func advance_elapsed(state: Dictionary, seconds: float) -> Dictionary:
	var next := state.duplicate(true)
	if not validate_snapshot(state) or not is_finite(seconds) or seconds < 0: return next
	for plot in next.plots.values():
		if plot.crop_id != "":
			plot.elapsed_seconds = minf(_crops[plot.crop_id].growth_seconds, plot.elapsed_seconds + seconds)
	return next

func preview_command(state: Dictionary, plot_id: String, action: String, crop_id: String, expected_generation: int, expected_revision: int) -> Dictionary:
	var result := {"status": "INVALID_STATE", "snapshot": state.duplicate(true)}
	if not validate_snapshot(state): return result
	result.status = "INVALID_COMMAND"
	if not PLOT_IDS.has(plot_id) or not action in ["plant", "care", "harvest"]: return result
	if action != "plant" and crop_id != "": return result
	var plot: Dictionary = result.snapshot.plots[plot_id]
	result.status = "STALE_COMMAND"
	if plot.generation != expected_generation or state.revision != expected_revision: return result
	if action == "plant" and not _crops.has(crop_id):
		result.status = "INVALID_CROP"
		return result
	result.status = "INVALID_PHASE"
	var current_phase := phase(plot)
	if action == "plant" and current_phase != "EMPTY": return result
	if action == "harvest" and current_phase != "MATURE": return result
	if action == "care":
		if not current_phase in ["SEEDLING", "YOUNG"]: return result
		if plot.cared:
			result.status = "ALREADY_CARED"
			return result
	result.status = "COUNTER_LIMIT"
	if state.revision == MAX_COUNTER or (action == "plant" and plot.generation == MAX_COUNTER): return result
	match action:
		"plant":
			plot.crop_id = crop_id
			plot.generation += 1
			plot.elapsed_seconds = 0.0
			plot.cared = false
		"care":
			var crop: Dictionary = _crops[plot.crop_id]
			plot.elapsed_seconds = minf(crop.growth_seconds, plot.elapsed_seconds + crop.growth_seconds * crop.care_credit_ratio)
			plot.cared = true
		"harvest":
			result.snapshot.last_harvest_crop = plot.crop_id
			plot.crop_id = ""
			plot.elapsed_seconds = 0.0
			plot.cared = false
	result.snapshot.revision += 1
	result.status = "APPLIED"
	return result
