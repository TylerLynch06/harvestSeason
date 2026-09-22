extends GPUParticles3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func fire():
	emitting = true
	show()
	reparent($"../..")
	await get_tree().create_timer(0.1).timeout
	self.queue_free()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
