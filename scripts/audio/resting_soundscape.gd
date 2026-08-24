# Resting Core technical audio prototype.
# This creates a deterministic, low-level loop so playback/loop architecture can be tested
# without pretending a final natural-ocean recording has been approved.
extends Node

const SAMPLE_RATE := 16000
const LOOP_SECONDS := 4
const TECHNICAL_PROTOTYPE := true

@onready var ocean_bed: AudioStreamPlayer = $OceanBed


func _ready() -> void:
	if ocean_bed.stream == null:
		ocean_bed.stream = _build_technical_ocean_loop()
	if not ocean_bed.playing:
		ocean_bed.play()


func is_technical_prototype() -> bool:
	return TECHNICAL_PROTOTYPE


func get_layer_priority() -> Array[String]:
	return ["OceanBed", "NearWater", "Wind", "BoatCreak", "DistantNature/PetFoley", "UI"]


# Generates a seamless four-second technical bed from periodic sine components.
# Frequencies are exact multiples of the loop period, so the waveform closes cleanly.
# This is intentionally synthetic and must never be promoted as production ocean audio.
func _build_technical_ocean_loop() -> AudioStreamWAV:
	var sample_count := SAMPLE_RATE * LOOP_SECONDS
	var bytes := PackedByteArray()
	bytes.resize(sample_count * 2)

	for i in range(sample_count):
		var t := float(i) / float(SAMPLE_RATE)
		var phase := TAU * t / float(LOOP_SECONDS)
		var slow_swell := 0.62 + 0.16 * sin(phase) + 0.08 * sin(phase * 2.0 + 0.8)
		var texture := (
			sin(phase * 173.0 + 0.4)
			+ 0.72 * sin(phase * 251.0 + 1.7)
			+ 0.48 * sin(phase * 337.0 + 2.8)
			+ 0.31 * sin(phase * 421.0 + 0.9)
			+ 0.22 * sin(phase * 509.0 + 2.1)
		) / 2.73
		var sample_value := clampf(texture * slow_swell * 0.12, -0.18, 0.18)
		var encoded := int(round(sample_value * 32767.0))
		bytes.encode_s16(i * 2, encoded)

	var stream := AudioStreamWAV.new()
	stream.format = AudioStreamWAV.FORMAT_16_BITS
	stream.mix_rate = SAMPLE_RATE
	stream.stereo = false
	stream.data = bytes
	stream.loop_mode = AudioStreamWAV.LOOP_FORWARD
	stream.loop_begin = 0
	stream.loop_end = sample_count
	return stream
