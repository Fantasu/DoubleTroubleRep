shader_type canvas_item;
render_mode unshaded;

void fragment() {
	vec4 color = textureLod(SCREEN_TEXTURE, SCREEN_UV, 0.0).rgba;
	color.r = 1.0 - color.r;
	color.g = 1.0 - color.g;
	color.b = 1.0 - color.b;
	COLOR.rgba = color;
}