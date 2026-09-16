extends Enemy

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
func attack():
	pass
	
func playerInRange():
	return false
	
func moveToPlayer(_position,delta):
	dirVector = (_position - position).normalized()
	##print(dirVector)
	velocity = dirVector * moveSpeed * delta
	move_and_slide()
