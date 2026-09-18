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
var isAttacking: bool = false
var attackCooldownTimer: float = 0
var player : CharacterBody3D
var dirVector: Vector3 = Vector3.ZERO
var relativeRigForward: Vector3 = Vector3.ZERO
var isTakingDamage: bool = false
var isRecovering: bool = false
var recoveryTimer: float = 0
var isDead: bool = false
var invulTimer: float = 0
@onready var attackCollisionObject: CollisionShape3D = attackRange.get_child(0) as CollisionShape3D
@onready var baseAttackRange = attackCollisionObject.shape.radius
@onready var currentAttackRange = baseAttackRange

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	invulTimer = BASE_INVUL_ON_HIT
	#print(get_tree().get_nodes_in_group("player"))
	player = get_tree().get_nodes_in_group("player")[0]
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
	if !isDead:
		if !isTakingDamage:
			var pos = getNextMovementPosition()
			dirVector = calculateDirVector(pos)
			rotateToTarget(delta)
			##Directly access statemachine to fix moving whiole attacking
			##Usually isnt needed
			if !isRecovering and stateMachine.get_current_node() != "attack":
				if !playerInRange() and !isAttacking:
					moveToPlayer(pos,delta)
				else:
					if attackCooldownTimer <= 0 and !isAttacking:
						print("attack")
						attack()

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
		var step = clamp(signedAngle, 
		-turnSpeed * delta,
		turnSpeed * delta)
		pivot.rotation.y += step
	
func takeDamage(damage: float):
	if invulTimer <= 0:
		invulTimer = BASE_INVUL_ON_HIT
		health -= damage
		print(health)
		isTakingDamage = true
			
@abstract
func attack()

@abstract
func playerInRange()

@abstract
func moveToPlayer(target,delta)

@abstract
func death()

@abstract 
func weaponLeftBody()
