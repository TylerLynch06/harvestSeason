extends CharacterBody3D
var speed = 400
var spawn : Marker3D
var leave : Marker3D
var stop : Marker3D
var stage = "ToStop"
func _ready() -> void:
	spawn = get_tree().get_first_node_in_group("spawn")
	stop = get_tree().get_first_node_in_group("stop")
	leave = get_tree().get_first_node_in_group("leave")
	self.global_position = spawn.global_position
func _physics_process(delta: float) -> void:
	if stage == "ToStop":
		$GPUParticles3D.emitting = true
		velocity = (stop.global_position - self.global_position).normalized() * speed * delta
		look_at(stop.global_position)
		if (self.global_position - stop.global_position).length() < 1:
			stage = "stopped"
	if stage == "stopped":
		stage = "waiting"
		$GPUParticles3D.emitting = false
		velocity = Vector3.ZERO
		$Node3D/ArmaturePuller.get_node("AnimationPlayer").play("humanoid_animations/Zombie_Idle")
		$Node3D/ArmaturePuller2.get_node("AnimationPlayer").play("humanoid_animations/Zombie_Idle")
		$Node3D/ArmaturePuller3.get_node("AnimationPlayer").play("humanoid_animations/Zombie_Idle")
		await get_tree().create_timer(5).timeout
		$Node3D/ArmaturePuller.get_node("AnimationPlayer").play("humanoid_animations/Zombie_Walk_Fwd")
		$Node3D/ArmaturePuller2.get_node("AnimationPlayer").play("humanoid_animations/Zombie_Walk_Fwd")
		$Node3D/ArmaturePuller3.get_node("AnimationPlayer").play("humanoid_animations/Zombie_Walk_Fwd")
		print($Node3D/ArmaturePuller.get_node("AnimationPlayer"))
		stage = "toLeave"
	if stage == "toLeave":
		$GPUParticles3D.emitting = true
		velocity = (leave.global_position - self.global_position).normalized() * speed * delta
		look_at(leave.global_position)
		if (self.global_position - leave.global_position).length() < 1:
			queue_free()
	move_and_slide()
func movingVisualsTrigger():
	pass
func stoppedVisualsTrigger():
	pass
