extends Control
var materialShad = load("res://scenes/perk_menu_bg.gdshader")
var perks = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("perk"):
		menuToggle()
	var current_time = Time.get_ticks_msec() / 1000.0
	$perkMenu/ColorRect.material.set_shader_parameter("real_time", current_time)
	$perkMenu/ColorRect2.material.set_shader_parameter("real_time", current_time)
	perks = 0
	for i in PerkHandler.perks:
		if PerkHandler.perks[i] != -1:
			perks += 1
	print(str(perks) + " perks")
func menuToggle():
	print(get_tree().get_nodes_in_group("shaderTogglers"))
	if $perkMenu.visible == true:
		$perkMenu.hide()
		Engine.time_scale=1
	else:
		$perkMenu.show()
		Engine.time_scale = 0.0001
