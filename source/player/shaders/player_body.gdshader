shader_type canvas_item;

uniform sampler2D pattern;
uniform vec4 pattern_tint : source_color = vec4(1,1,1,1);
uniform vec4 base_tint : source_color = vec4(1,1,1,1);
uniform float pattern_strength;

void fragment() {
	vec4 base_colour = texture(TEXTURE, UV) * base_tint;
	vec4 pattern_colour = texture(pattern, UV) * pattern_tint;
	
	COLOR = mix(base_colour, pattern_colour, pattern_strength);
}