extends CharacterBody3D
var speed = 100
var spawn : Marker3D
var leave : Marker3D
var stop : Marker3D
var stage = "ToStop"
func _ready() -> void:
	spawn = get_tree().get_first_node_in_group("spawn")
	stop = get_tree().get_first_node_in_group("stop")
	leave = get_tree().get_first_node_in_group("leave")
func _physics_process(delta: float) -> void:
	if stage == "ToStop":
		self.global_position.move_toward(stop.global_position, delta * speed)
	if stage == "stopped":
		pass
	if stage == "toLeave":
		pass
		
func movingVisualsTrigger():
	pass
func stoppedVisualsTrigger():
	pass
