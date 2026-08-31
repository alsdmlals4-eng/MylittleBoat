// 수평선 아래 바다 표면에만 느린 전진 흐름을 적용한다.
shader_type spatial;
render_mode unshaded, cull_disabled;

uniform sampler2D source_texture : source_color, repeat_enable, filter_linear_mipmap;
uniform float flow_offset = 0.0;
uniform float horizon_start = 0.42;
uniform float horizon_fade = 0.16;

void fragment() {
	float water_mask = smoothstep(horizon_start, horizon_start + horizon_fade, UV.y);
	float cross_ripple = sin(UV.y * 66.0 + flow_offset * 30.0) * 0.0025 * water_mask;
	vec2 flowing_uv = UV + vec2(flow_offset * water_mask, cross_ripple);
	vec4 still_color = texture(source_texture, UV);
	vec4 flowing_color = texture(source_texture, flowing_uv);
	ALBEDO = mix(still_color.rgb, flowing_color.rgb, water_mask) * COLOR.rgb;
}
