@abstract
class_name Enemy
extends Stats

@export var navigationAgent: NavigationAgent3D
@export var pivot: Node3D
@export var animTree: AnimationTree
##we stop rotating if playing angle within [-criticalAngle,criticalAngle]
@export var animPlayer: AnimationPlayer
@onready var stateMachine: AnimationNodeStateMachinePlayback = animTree["parameters/playback"]
@export var attackRange : Area3D
@export var physBox: CollisionShape3D
var isAttacking: bool = false
var attackCooldownTimer: float = 0
var player : CharacterBody3D
var dirVector: Vector3 = Vector3.ZERO
var relativeRigForward: Vector3 = Vector3.ZERO
var isTakingDamage: bool = false
var isRecovering: bool = false
var recoveryTimer: float = 0
var isDead: bool = false
var isBeingPushed: bool = false
##Cant apply force, have to push by modifying velocity
var currentPushVelocity: Vector3 = Vector3.ZERO
var invulTimer: float = 0
##Velocity used to move player
var trackingVelocity: Vector3 = Vector3.ZERO
@onready var attackCollisionObject: CollisionShape3D = attackRange.get_child(0) as CollisionShape3D
@onready var baseAttackRange = attackCollisionObject.shape.radius
@onready var currentAttackRange = baseAttackRange
@onready var wheatScene = preload("res://scenes/wheat_pickup.tscn")

@export var movePool: EnemyMovePool
var nextMove = null


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	invulTimer = BASE_INVUL_ON_HIT
	#print(get_tree().get_nodes_in_group("player"))
	player = get_tree().get_nodes_in_group("player")[0] as CharacterBody3D
	animTree.advance_expression_base_node = get_path()

func _process(delta: float) -> void:
	animTree.set("parameters/move/TimeScale/scale", BASE_WALK_ANIM_SPD_FACTOR*moveSpeed/BASE_MOVE_SPEED)
	animTree.set("parameters/attack/TimeScale/scale", attackSpeed)
	attackCooldownTimer -= delta
	recoveryTimer -= delta
	isRecovering = recoveryTimer > 0
	if isRecovering:
		isAttacking = false
	##print(attackCooldownTimer)
	if attackCooldownTimer < 0:
		attackCooldownTimer = 0
		
	if health <= 0 and !isDead:
		isDead = true
		death()
	if invulTimer > 0:
		invulTimer -= delta
		
	if isAttacking:
		currentAttackRange = baseAttackRange * BASE_ATTACK_RANGE_INCRASE
	else:
		currentAttackRange = baseAttackRange
	attackCollisionObject.shape.radius = currentAttackRange

func _physics_process(delta: float) -> void:
	##print(!playerInRange(), !isAttacking)
	trackingVelocity = Vector3.ZERO
	if !isDead:
		
		if !isTakingDamage:
			var pos = getNextMovementPosition()
			#print(pos)
			dirVector = calculateDirVector(pos)
			rotateToTarget(delta)
			##Directly access statemachine to fix moving whiole attacking
			##Usually isnt needed
			if !isRecovering and stateMachine.get_current_node() != "attack":
				if !playerInRange() and !isAttacking:
					calcTrackingVelocity(global_position)
				else:
					if attackCooldownTimer <= 0 and !isAttacking:
						attack()
	if isBeingPushed:
		calcPushVelocity()
	move(delta)

func calculateDirVector(_position):
	return (_position - position).normalized()

func getNextMovementPosition():
	navigationAgent.target_position = player.position 
	return navigationAgent.get_next_path_position()
	
func rotateToTarget(delta):
	var flatDir = Vector3(dirVector.x, 0, dirVector.z).normalized()
	if flatDir == Vector3.ZERO:
		return
	##Forward vector of the pivot
	var forward = -pivot.global_transform.basis.z.normalized()
	relativeRigForward = forward
	var targetHeading = atan2(flatDir.x, flatDir.z)
	var currentHeading = atan2(forward.x, forward.z)
	##If angle spills over pi, it goes to -pi
	var signedAngle = wrapf(targetHeading - currentHeading, -PI, PI)

	if abs(signedAngle) > critAngle:
		#print("rotating")
		var step = clamp(signedAngle, 
		-turnSpeed * delta,
		turnSpeed * delta)
		pivot.rotation.y += step
	
func takeDamage(damage: float, hitPos: Vector3 = Vector3.ZERO, pushForce: float = 0, weaponStunFactor: float = 1):
	if invulTimer <= 0:
		invulTimer = BASE_INVUL_ON_HIT
		health -= damage
		#print(health)
		isTakingDamage = true
	if !isUnstoppable:
		recoveryTimer = (BASE_RECOVERY_TIME + (PerkHandler.progression["battery"][PerkHandler.perks["battery"]])) * weaponStunFactor
	if hitPos != Vector3.ZERO and pushForce != 0:
		isBeingPushed = true
		var pushDir = global_position - hitPos
		currentPushVelocity = pushDir * pushForce
		
func death():
	self.remove_from_group("enemy")
	for i in range(WHEAT_ON_DEATH):
		create_wheat()
		await get_tree().create_timer(0.004).timeout
	#print("add wheat equal " +str(WHEAT_ON_DEATH))
	stateMachine.travel("death")
	collision_layer = 0
	collision_mask = 0
	
	
func create_wheat():
	var wheat = wheatScene.instantiate()
	wheat.global_position = global_position
	get_tree().current_scene.add_child(wheat)
		
##might not be need since invul timer exists, keep anyway
func weaponLeftBody():
	isTakingDamage = false

func attack():
	nextMove = movePool.rollNextMove()
	if !isAttacking:
		##print("ATTACK")
		isAttacking = true
	
func playerInRange():
	var areas = attackRange.get_overlapping_areas()
	for area in areas:
		if area.get_parent() and area.get_parent() in get_tree().get_nodes_in_group("player"):	
			return true

func animation_finished(anim_name):
	if isTakingDamage:
		isTakingDamage = false
	if isAttacking:
		attackCooldownTimer = BASE_COOLDOWN
		isAttacking = false

func calcTrackingVelocity(_position):
	trackingVelocity = relativeRigForward * BASE_MOVE_SPEED

func calcPushVelocity():
	currentPushVelocity *= BASE_PUSH_DRAG_FACTOR
	if currentPushVelocity.length() < 3:
		isBeingPushed = false
		currentPushVelocity = Vector3.ZERO

func move(delta):
	velocity = (trackingVelocity + currentPushVelocity)*delta
	if currentPushVelocity.length() >= 20:
		#print(currentPushVelocity)
		pass
	move_and_slide()
