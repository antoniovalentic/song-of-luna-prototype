shader_type spatial;
render_mode blend_sub;

uniform sampler2D noise: source_color;
uniform float darken_intensity: hint_range(0.0, 1.0, 0.025);

varying vec3 pos;

void vertex() {
	pos = VERTEX;
}
void fragment() {
	float noise_value = texture(noise, UV).x;
	ALBEDO = vec3(noise_value * darken_intensity);
}


