// 불투명 표면 패턴을 최종 디오라마의 부드러운 쿠션 실루엣 안에만 표시한다.
shader_type spatial;
render_mode unshaded, cull_disabled, depth_draw_never;

uniform sampler2D source_texture : source_color;

void fragment() {
	vec4 surface_color = texture(source_texture, UV);
	vec2 normalized_uv = (UV - vec2(0.5)) / vec2(0.5, 0.38);
	float radial_distance = length(normalized_uv);
	float soft_edge = 1.0 - smoothstep(0.9, 1.0, radial_distance);
	ALBEDO = surface_color.rgb;
	ALPHA = surface_color.a * soft_edge;
}
