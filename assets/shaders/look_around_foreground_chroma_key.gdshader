// 둘러보기 전경 원화의 전용 마젠타 키 배경을 런타임에서 투명하게 분리한다.
shader_type spatial;
render_mode blend_mix, depth_prepass_alpha, unshaded, cull_disabled;

uniform sampler2D source_texture : source_color, filter_nearest_mipmap;

void fragment() {
	vec4 sampled_color = texture(source_texture, UV);
	float magenta_chroma = min(sampled_color.r - sampled_color.g, sampled_color.b - sampled_color.g);
	float magenta_brightness = min(sampled_color.r, sampled_color.b);
	float key_alpha = smoothstep(0.12, 0.30, magenta_chroma) * smoothstep(0.54, 0.74, magenta_brightness);
	float foreground_alpha = 1.0 - key_alpha;
	vec3 decontaminated_color = (sampled_color.rgb - key_alpha * vec3(1.0, 0.0, 1.0)) / max(foreground_alpha, 0.001);
	ALBEDO = clamp(decontaminated_color, vec3(0.0), vec3(1.0)) * COLOR.rgb;
	ALPHA = sampled_color.a * foreground_alpha * COLOR.a;
}
