shader_type canvas_item;

uniform vec2 max_rotation = vec2(0.1, 0.1); // Controls max tilt intensity
uniform vec2 tilt = vec2(0.0, 0.0);         // Passed from the GDScript (-1.0 to 1.0)
uniform float shine_intensity : hint_range(0.0, 1.0) = 0.2;

void vertex() {
    // Fake 3D perspective distortion by modifying vertex positions based on tilt
    VERTEX.y += tilt.x * max_rotation.x * (UV.x - 0.5) * VERTEX.y;
    VERTEX.x += tilt.y * max_rotation.y * (UV.y - 0.5) * VERTEX.x;
}

void fragment() {
    vec4 tex_color = texture(TEXTURE, UV);
    
    // Create a dynamic foil/glint highlight based on the tilt direction
    float shine = clamp(1.0 - abs((UV.x + UV.y) - (tilt.x + tilt.y + 1.0)), 0.0, 1.0);
    vec4 shine_color = vec4(0.7, 1, 1, 1.0) * shine * shine_intensity;
    
    COLOR = tex_color + shine_color;
    COLOR.a = tex_color.a; // Maintain original transparency/rounded corners
}
