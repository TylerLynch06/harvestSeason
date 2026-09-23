extends Control
var materialShad = load("res://scenes/perk_menu_bg.gdshader")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("perk"):
		menuToggle()
	var current_time = Time.get_ticks_msec() / 1000.0
	print(current_time)
	$perkMenu/ColorRect.material.set_shader_parameter("real_time", current_time)
	$perkMenu/ColorRect2.material.set_shader_parameter("real_time", current_time)
func menuToggle():
	if $perkMenu.visible == true:
			$perkMenu.hide()
			Engine.time_scale=1
	else:
		$perkMenu.show()
		Engine.time_scale = 0
