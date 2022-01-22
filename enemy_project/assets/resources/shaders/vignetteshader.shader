shader_type canvas_item;

uniform vec4 color: hint_color;
uniform float multiplier = 0.2;
uniform float softness = 0.2;

void fragment()
{
	float value = distance(UV, vec2(0.5, 0.5));
	COLOR = vec4(color.rgb, smoothstep(multiplier, softness, value));
}