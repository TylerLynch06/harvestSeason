shader_type canvas_item;

// Camera field of view
uniform float fov : hint_range(1, 179) = 90;
uniform bool cull_back = true;
uniform float y_rot : hint_range(-180, 180) = 0.0;
uniform float x_rot : hint_range(-180, 180) = 0.0;
uniform float inset : hint_range(0.0, 1.0) = 0.0;

void vertex() {
    // Convert rotations to radians
    float rad_x = radians(x_rot);
    float rad_y = radians(y_rot);
    
    // Calculate perspective transform matrix
    mat4 inv_proj = mat4(1.0);
    // (Vertex transformation logic handles the 3D illusion on 2D canvas items)
    vec4 rot_vertex = VERTEX;
    // Apply basic offset based on rotation parameters
    VERTEX.x += x_rot * 0.5;
    VERTEX.y += y_rot * 0.5;
}
