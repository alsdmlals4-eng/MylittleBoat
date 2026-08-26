# 파도 중심의 authored ocean bed를 지속 재생하고 휴식 음향 우선순위를 관리한다.
extends Node

const SAMPLE_RATE := 24000
const LOOP_SECONDS := 16
const TECHNICAL_PROTOTYPE := false
const AUTHORED_OCEAN_BED := true
const OCEAN_BED_VOLUME_DB := -18.0

var ocean_bed: AudioStreamPlayer


func _ready() -> void:
	ocean_bed = get_node_or_null("OceanBed") as AudioStreamPlayer
	if ocean_bed == null:
		ocean_bed = AudioStreamPlayer.new()
		ocean_bed.name = "OceanBed"
		ocean_bed.autoplay = true
		ocean_bed.volume_db = OCEAN_BED_VOLUME_DB
		add_child(ocean_bed)

	if ocean_bed.stream == null:
		ocean_bed.stream = _build_authored_ocean_loop()
	if not ocean_bed.playing:
		ocean_bed.play()


func is_technical_prototype() -> bool:
	return TECHNICAL_PROTOTYPE


func is_authored_ocean_bed() -> bool:
	return AUTHORED_OCEAN_BED


func get_layer_priority() -> Array[String]:
	return ["OceanBed", "NearWater", "Wind", "BoatCreak", "DistantNature/PetFoley", "UI"]


# Generates a seamless sixteen-second stereo surf bed from bounded periodic components.
# Integer loop-period multiples keep the endpoints equal without abrupt fades.
# It is an authored runtime candidate; human listening comfort remains unvalidated.
func _build_authored_ocean_loop() -> AudioStreamWAV:
	var sample_count := SAMPLE_RATE * LOOP_SECONDS
	var bytes := PackedByteArray()
	bytes.resize(sample_count * 4)

	for i in range(sample_count):
		var t := float(i) / float(SAMPLE_RATE)
		var phase := TAU * t / float(LOOP_SECONDS)
		var left := _sample_surf(phase, 0.13)
		var right := _sample_surf(phase, 1.31)
		bytes.encode_s16(i * 4, int(round(left * 32767.0)))
		bytes.encode_s16(i * 4 + 2, int(round(right * 32767.0)))

	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.stereo = true
	stream.data = bytes
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_begin = 0
	stream.loop_end = sample_count
	return stream


func _sample_surf(phase: float, offset: float) -> float:
	var slow_swell := 0.52 + 0.14 * sin(phase + offset) + 0.10 * sin(phase * 2.0 + offset * 1.7)
	var wash := (
		sin(phase * 701.0 + offset)
		+ 0.71 * sin(phase * 1249.0 + offset * 1.9)
		+ 0.49 * sin(phase * 2281.0 + offset * 2.6)
		+ 0.31 * sin(phase * 4217.0 + offset * 3.2)
		+ 0.18 * sin(phase * 7927.0 + offset * 4.1)
		+ 0.10 * sin(phase * 15731.0 + offset * 5.3)
	) / 2.79
	var foam_window := pow(maxf(0.0, sin(phase * 3.0 + offset * 0.4)), 5.0)
	var foam := sin(phase * 3181.0 + offset * 4.7) * foam_window * 0.028
	return clampf((wash * slow_swell * 0.09) + foam, -0.16, 0.16)
