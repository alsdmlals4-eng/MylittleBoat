// 기존 쿠션 패턴을 새 조립 화면의 동반자 좌석 안에만 표시한다.
shader_type canvas_item;
void fragment() {
	vec4 surface = COLOR;
	float radius = length((UV - vec2(0.5)) / vec2(0.5, 0.38));
	COLOR = vec4(surface.rgb, surface.a * (1.0 - smoothstep(0.9, 1.0, radius)));
}
