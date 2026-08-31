# 승인 자연 명소가 정식 runtime 경로와 공통 배경 규격을 갖는지 검증한다.
extends SceneTree

const EXPECTED_ASSETS := {
	"MLB-AMB-MOTIF-001": "res://assets/images/runtime/voyage/ambient_motifs/dawn-sea-arch-waterfall.png",
	"MLB-AMB-MOTIF-002": "res://assets/images/runtime/voyage/ambient_motifs/bright-seagrass-sandbar.png",
	"MLB-AMB-MOTIF-003": "res://assets/images/runtime/voyage/ambient_motifs/bright-chalk-cliffs-birds.png",
	"MLB-AMB-MOTIF-004": "res://assets/images/runtime/voyage/ambient_motifs/sunset-sandstone-cove.png",
	"MLB-AMB-MOTIF-005": "res://assets/images/runtime/voyage/ambient_motifs/sunset-reed-islet.png",
	"MLB-AMB-MOTIF-006": "res://assets/images/runtime/voyage/ambient_motifs/night-bioluminescent-band.png",
}

var _failures := 0


func _init() -> void:
	call_deferred("_run")


func _run() -> void:
	for motif_id in EXPECTED_ASSETS:
		var asset_path := str(EXPECTED_ASSETS[motif_id])
		_expect(ResourceLoader.exists(asset_path), "%s must exist at its canonical runtime path" % motif_id)
		if not ResourceLoader.exists(asset_path):
			continue
		var texture := load(asset_path) as Texture2D
		_expect(texture != null, "%s must load as a Texture2D" % motif_id)
		if texture == null:
			continue
		_expect(texture.get_width() == 1672 and texture.get_height() == 941, "%s must match the shared water-only landscape geometry" % motif_id)
	_finish()


func _expect(condition: bool, message: String) -> void:
	if condition:
		return
	_failures += 1
	printerr("FAIL: %s" % message)


func _finish() -> void:
	if _failures == 0:
		print("PASS: ambient motif asset contract")
		quit(0)
	else:
		printerr("FAILED: %d ambient motif asset assertions" % _failures)
		quit(1)
