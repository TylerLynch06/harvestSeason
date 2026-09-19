extends RigidBody3D
var collected = false

@export var hitbox: RigidBody3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	self.apply_impulse(Vector3(randi_range(0,2)*10,25,randi_range(0,2)*10))
	hitbox.body_entered.connect(_on_body_entered)
	self.angular_velocity.y = 7220
#func _process(delta: float):
	#print(hitbox.sleeping)

func collect():
	collected = true
	print("GNOG")
	
func _physics_process(delta: float) -> void:
	if collected == true:
		global_position.move_toward(get_tree().get_nodes_in_group("player")[0].global_position, 5 * delta)



func _on_body_entered(body: Node) -> void:
	if body.is_in_group("player"):
		Economy.wheat += 1
		$GPUParticles3D.emitting = true
		self.queue_free()


func _on_timer_timeout() -> void:
	angular_damp = 3
	for i in range(10):
		await get_tree().create_timer(0.07 - (i/70)).timeout
		$MeshInstance3D4.hide()
		await get_tree().create_timer(0.07 - (i/70)).timeout
		$MeshInstance3D4.show()
	$GPUParticles3D2.emitting = true
	self.hide()
	$GPUParticles3D2.show()
	await get_tree().create_timer(3.0).timeout
	self.queue_free()
