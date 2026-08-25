shader_type spatial;

uniform vec4 water_color : source_color = vec4(0.1, 0.4, 0.8, 0.8);
uniform float wave_speed : hint_range(0.1, 5.0) = 1.0;
uniform float wave_amplitude : hint_range(0.01, 0.5) = 0.05;

void vertex() {
	float wave = sin(TIME * wave_speed + VERTEX.x * 2.0 + VERTEX.z * 2.0) * wave_amplitude;
	VERTEX.y += wave;
}

void fragment() {
	ALBEDO = water_color.rgb;
	ALPHA = water_color.a;
	ROUGHNESS = 0.1;
	METALLIC = 0.8;
}
