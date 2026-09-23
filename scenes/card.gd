extends Control

@onready var card_image = $SubViewportContainer
@export var lerp_speed : float = 10.0

var target_tilt : Vector2 = Vector2.ZERO
var current_tilt : Vector2 = Vector2.ZERO
var is_hovered : bool = false
var loaded = true
func _ready():
	process_mode = PROCESS_MODE_ALWAYS
	# Connect mouse signals to detect when the cursor is over the card
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	# Ensure the card pivot point is dead center for clean rotations
	pivot_offset = size / 2.0
func _process(delta):
	if loaded == true:
		if is_hovered:
			var mouse_pos = get_local_mouse_position()
			
			# Normalize the mouse position from -1.0 to 1.0 relative to the center
			target_tilt.x = ((mouse_pos.x / size.x) - 0.5) * 2.0
			target_tilt.y = -((mouse_pos.y / size.y) - 0.5) * 2.0 # Invert Y for standard 3D rotation
		else:
			# Snap back to center when mouse leaves
			target_tilt = Vector2.ZERO
		
		# Smoothly interpolate to the target tilt
		current_tilt = current_tilt.lerp(target_tilt, delta * (lerp_speed / Engine.time_scale))
		
		# Update the shader parameters
		var mat = card_image.material as ShaderMaterial
		if mat:
			# Shader expects tilt.x for Y-axis warp and tilt.y for X-axis warp
			mat.set_shader_parameter("tilt", Vector2(current_tilt.x, -current_tilt.y))
		
		# Optional: Slight standard 2D rotation & scaling for added juice
		rotation = current_tilt.x * 0.05
		scale = Vector2.ONE * (1.05 if is_hovered else 1.0)
	

func _on_mouse_entered():
	is_hovered = true

func _on_mouse_exited():
	is_hovered = false
