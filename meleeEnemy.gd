extends Enemy

@export var attackRange : Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	animTree.animation_finished.connect(animation_finished)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
func attack():
	print("ATTACK")
	isAttacking = true
	
func playerInRange():
	var areas = attackRange.get_overlapping_areas()
	for area in areas:
		if area.get_parent() and area.get_parent() in get_tree().get_nodes_in_group("player"):	
			return true
	
func moveToPlayer(_position,delta):
	
	##print(dirVector)
	velocity = dirVector * moveSpeed * delta
	move_and_slide()

func animation_finished(anim_name):
	print(anim_name)
	if isAttacking:
		isAttacking = false
		
		
