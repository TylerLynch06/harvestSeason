extends RigidBody3D
var collected = false
var speed = 400
var acceleraition = 5
var player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.apply_impulse(Vector3(randi_range(0,4),7,randi_range(0,4)))
	self.angular_velocity.y = 7220
	await get_tree().create_timer(0.45).timeout
	self.add_to_group("wheat")

func collect():
	collected = true
	player = get_tree().get_nodes_in_group("player")[0] as CharacterBody3D
	await get_tree().create_timer(4).timeout
	cash()
	
func _physics_process(delta: float) -> void:
	if collected == true and player:
		var distanceToPlayer = (player.global_position - global_position).length()
		self.apply_force(((player.global_position) - Vector3(global_position.x+ randf_range(0,1),global_position.y - 1 + randf_range(0,1), global_position.z + randf_range(0,-01))).normalized()*speed*1)

func cash():
	if collected == true:
		Economy.wheat += 1
		$GPUParticles3D.fire()
		self.queue_free()
		
func _on_timer_timeout() -> void:
	if collected == true:
		Economy.wheat += 1
		$GPUParticles3D.fire()
		self.queue_free()
	else:
		angular_damp = 3
		for i in range(10):
			await get_tree().create_timer(0.07 - (i/70)).timeout
			$MeshInstance3D4.hide()
			await get_tree().create_timer(0.07 - (i/70)).timeout
			$MeshInstance3D4.show()
		$GPUParticles3D2.fire()
		self.queue_free()
