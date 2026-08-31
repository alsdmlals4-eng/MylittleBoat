// 고정 하늘과 분리된 바다 레이어에만 잔잔한 흐름을 적용한다.
shader_type spatial;
render_mode blend_mix, unshaded, cull_disabled, depth_draw_never;

uniform sampler2D source_texture : source_color, repeat_enable, filter_linear_mipmap;
uniform float flow_offset = 0.0;
uniform float sea_start = 0.42;
uniform float sea_fade = 0.08;

void fragment() {
	float sea_mask = smoothstep(sea_start, sea_start + sea_fade, UV.y);
	float foreground_weight = smoothstep(sea_start + sea_fade, 1.0, UV.y);
	float cross_ripple = (
		sin(UV.y * 58.0 + flow_offset * 22.0) * 0.0018
		+ sin(UV.y * 104.0 - flow_offset * 15.0) * 0.0009
	) * foreground_weight;
	vec2 flowing_uv = UV + vec2(flow_offset * sea_mask, cross_ripple);
	vec4 sea_color = texture(source_texture, flowing_uv);
	ALBEDO = sea_color.rgb * COLOR.rgb;
	ALPHA = sea_color.a * sea_mask * COLOR.a;
}
