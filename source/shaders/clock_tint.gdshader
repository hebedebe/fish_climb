shader_type canvas_item;

uniform vec4 base_tint : source_color;
uniform vec4 clock_tint : source_color;
uniform float threshold;
uniform float offset;

uniform vec2 centerCoordinat  = vec2(0.5, 0.5);
uniform float radial_scale : hint_range(0.0, 5.0) = 1.0;
uniform float length_scale : hint_range(0.0, 5.0) = 1.0;

vec2 UVPolarCoordinates(vec2 uv, vec2 center, float radialScale, float lengthScale) {
	vec2 m_delta = uv - center;
	float m_radius = length(m_delta) * 2.0 * radialScale;
	float m_Pi = 6.28318530718;
	float m_angle = atan(m_delta.y, m_delta.x) / (m_Pi * lengthScale);
	return vec2(m_radius, m_angle);
}

void fragment() {
	vec2 uv = UV;
	vec2 polar_uv = UVPolarCoordinates(vec2(1)-uv, centerCoordinat, radial_scale, length_scale);
	
	vec4 color;
	if (polar_uv.y + offset < 1.0-((1.0-threshold) + 0.5)){
		color = clock_tint;
	} else {
		color = base_tint;
	}
	
	COLOR = texture(TEXTURE, uv) * color;
}
