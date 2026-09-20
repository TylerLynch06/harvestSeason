extends RigidBody3D
var collected = false
var speed = 300
var acceleraition = 5

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.apply_impulse(Vector3(randi_range(0,2),5,randi_range(0,2)))
	self.angular_velocity.y = 7220
	await get_tree().create_timer(0.2).timeout
	self.add_to_group("wheat")

func collect():
	collected = true
	await get_tree().create_timer(2).timeout
	cash()
	
func _physics_process(delta: float) -> void:
	if collected == true:
		var player = get_tree().get_nodes_in_group("player")[0] as CharacterBody3D
		var distanceToPlayer = (player.global_position - global_position).length()
		self.apply_force(((player.global_position) - global_position).normalized()*speed*1/distanceToPlayer)


func cash():
	Economy.wheat += 1
	$GPUParticles3D.emitting = true
	
	self.queue_free()



func _on_timer_timeout() -> void:
	if collected == true:
		Economy.wheat += 1
		$GPUParticles3D.emitting = true
		self.queue_free()
	else:
		angular_damp = 3
		for i in range(10):
			await get_tree().create_timer(0.07 - (i/70)).timeout
			$MeshInstance3D4.hide()
			await get_tree().create_timer(0.07 - (i/70)).timeout
			$MeshInstance3D4.show()
		$GPUParticles3D2.emitting = true
		$GPUParticles3D2.show()
		self.hide()
		await get_tree().create_timer(3.0).timeout
		self.queue_free()
