// 고정 하늘과 분리된 바다 레이어에만 잔잔한 흐름을 적용한다.
shader_type spatial;
render_mode blend_mix, unshaded, cull_disabled, depth_draw_never;

uniform sampler2D source_texture : source_color, repeat_enable, filter_linear_mipmap;
uniform float flow_offset = 0.0;
uniform float forward_flow_offset = 0.0;
uniform float sea_start = 0.42;
uniform float sea_fade = 0.08;
// x = sideward passage, y = forward/astern projection; supplied per camera.
uniform vec2 travel_direction = vec2(0.0, 1.0);

vec4 sample_sea(vec2 uv) {
	// The painted source is not a vertical tile: never wrap its sky into the sea.
	return texture(source_texture, clamp(uv, vec2(0.002, sea_start), vec2(0.998)));
}

void fragment() {
	float sea_mask = smoothstep(sea_start, sea_start + sea_fade, UV.y);
	float depth = clamp((UV.y - sea_start) / (1.0 - sea_start), 0.0, 1.0);
	// All visible sea participates; near water passes faster than the horizon.
	float perspective = depth * depth;
	vec2 passage = vec2(
		travel_direction.x * depth * 0.42 + (UV.x - 0.5) * travel_direction.y * depth * 0.55,
		travel_direction.y * perspective * 0.62
	);
	float tide_angle = flow_offset * 6.28318530718;
	vec2 tide = vec2(sin(tide_angle), cos(tide_angle + UV.y * 28.0)) * 0.006 * depth;
	// Two bounded advection phases: the layer that resets has zero weight.
	float phase_a = fract(forward_flow_offset);
	float phase_b = fract(forward_flow_offset + 0.5);
	float weight_a = 1.0 - abs(phase_a * 2.0 - 1.0);
	vec4 layer_a = sample_sea(UV + tide - passage * (phase_a - 0.5));
	vec4 layer_b = sample_sea(UV + tide - passage * (phase_b - 0.5));
	vec4 sea_color = mix(layer_b, layer_a, weight_a);
	ALBEDO = sea_color.rgb * COLOR.rgb;
	ALPHA = sea_color.a * sea_mask * COLOR.a;
}
