shader_type canvas_item;


uniform vec4 color : source_color = vec4(0, 0, 0, 1);
uniform bool reverse = false;
uniform float opacity : hint_range(0, 1) = 0.0;

uniform bool use_texture = false;
uniform bool use_texture_color = true;
uniform sampler2D texture;

void fragment() {
	float alpha;
	if (use_texture) {
	 	alpha = texture(texture, UV).r;
	} else {
	 	alpha = texture(TEXTURE, UV).r;
	}

	if (reverse) {
		alpha = clamp(1.0 - alpha, 0.0, 1.0);
	}

	alpha = mix(0.0, 1.0, clamp(alpha - 1.0 + opacity * 2.0, 0.0, 1.0));

	if (use_texture && use_texture_color) {
		COLOR = vec4(texture(TEXTURE, UV).rgb, alpha);
	} else {
		COLOR = vec4(color.rgb, alpha);
	}
}
