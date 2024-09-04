shader_type spatial;

uniform vec4 color : source_color;
uniform float morph_amount : hint_range(0, 1) = 1.0;
uniform float speed_factor : hint_range(0, 1) = 1.0;

void vertex() {
    float speed = TIME * speed_factor;
    float x = VERTEX.x;
    float y = VERTEX.y;
    float z = VERTEX.z;

    VERTEX.x += cos(y * speed) * sin(z * speed) * morph_amount;
    VERTEX.y += cos(x * speed) * sin(z * speed) * morph_amount;
    VERTEX.z += cos(x * speed) * sin(y * speed) * morph_amount;
}

void fragment() {
	ALBEDO.rgb = color.rgb;
}
