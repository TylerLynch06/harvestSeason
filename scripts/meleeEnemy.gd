extends Enemy

@export var debugHitbox: Area3D = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	animTree.animation_finished.connect(animation_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	if (debugHitbox):
		var colShape = debugHitbox.get_child(0) as CollisionShape3D
		if invulTimer > 0:
			colShape.debug_color = Color(0.245, 0.245, 0.245, 1.0)
		else:
			colShape.debug_color = Color(0x0000ffff)
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
func attack():
	if !isAttacking:
		##print("ATTACK")
		isAttacking = true
	
func playerInRange():
	var areas = attackRange.get_overlapping_areas()
	for area in areas:
		if area.get_parent() and area.get_parent() in get_tree().get_nodes_in_group("player"):	
			return true
	
func moveToPlayer(_position,delta):
	velocity = relativeRigForward * BASE_MOVE_SPEED * delta
	move_and_slide()

func animation_finished(anim_name):
	print("anim finished ",isAttacking)
	##print(anim_name)
	if isTakingDamage:
		#recoveryTimer = BASE_RECOVERY_TIME	
		isTakingDamage = false
	if isAttacking:
		attackCooldownTimer = BASE_COOLDOWN
		#recoveryTimer = BASE_RECOVERY_TIME	
		#attackCooldownTimer = stats.BASE_VALUES.get("COOLDOWN")
		isAttacking = false
	print(isAttacking)
	
	
