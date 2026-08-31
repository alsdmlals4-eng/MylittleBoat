// 치비 정상 원화의 기술용 녹색 matte를 투명 foreground alpha로 바꾼다.
shader_type spatial;
render_mode blend_mix, depth_prepass_alpha, unshaded, cull_disabled;

uniform sampler2D matte_texture : source_color;
uniform float green_key_start : hint_range(0.0, 1.0) = 0.12;
uniform float green_key_end : hint_range(0.0, 1.0) = 0.28;

void fragment() {
	vec4 sampled_color = texture(matte_texture, UV);
	float green_dominance = sampled_color.g - max(sampled_color.r, sampled_color.b);
	float matte_strength = smoothstep(green_key_start, green_key_end, green_dominance);
	ALBEDO = sampled_color.rgb;
	ALPHA = sampled_color.a * (1.0 - matte_strength);
}
