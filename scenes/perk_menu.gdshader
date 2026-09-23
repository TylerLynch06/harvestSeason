shader_type canvas_item;

uniform sampler2D screen_tex: hint_screen_texture;
uniform bool toggle = false;
uniform float speed = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 uv = vec2(UV.x * sin(TIME * speed), UV.y * sin(TIME * speed)) ;
	
	
	
	vec4 screen = texture(screen_tex, uv);
	
	COLOR = screen;
}

//void light() {
//	// Called for every pixel for every light affecting the CanvasItem.
//	// Uncomment to replace the default light processing function with this one.
//}
