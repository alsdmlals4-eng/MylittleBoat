// 승인된 분리 자산의 자홍색 키 잔여색만 렌더 단계에서 제거한다.
shader_type canvas_item;

void fragment() {
	vec4 source = COLOR;
	float spill = max(min(source.r, source.b) - source.g - 0.05, 0.0);
	source.r -= spill;
	source.b -= spill;
	COLOR = source;
}
