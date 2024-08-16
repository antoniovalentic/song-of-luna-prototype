shader_type spatial;
render_mode blend_sub;

uniform sampler2D noise: source_color;
uniform float darken_intensity: hint_range(0.0, 1.0, 0.025);

varying vec3 pos;

void vertex() {
	pos = VERTEX;
}

float wave(vec2 position){
  position += texture(noise, position / 10.0).x * 2.0 - 1.0;
  vec2 wv = 1.0 - abs(sin(position));
  return pow(1.0 - pow(wv.x * wv.y, 0.65), 4.0);
}

float height(vec2 position, float time) {
  float d = wave((position + time) * 0.4) * 0.3;
  d += wave((position - time) * 0.3) * 0.3;
  d += wave((position + time) * 0.5) * 0.2;
  d += wave((position - time) * 0.6) * 0.2;
  return d;
}

void fragment() {
	float offset_uv_x = height(UV, TIME * 0.02);
	float offset_uv_y = height(UV, TIME * 0.05);
	float noise_value = texture(noise, vec2(offset_uv_x, offset_uv_y)).x;
	ALBEDO = vec3(noise_value * darken_intensity);
}