@abstract
class_name Enemy
extends Stats

@export var navigationAgent: NavigationAgent3D
@export var pivot: Node3D
@export var animTree: AnimationTree
##we stop rotating if playing angle within [-criticalAngle,criticalAngle]
@export var animPlayer: AnimationPlayer
var isAttacking: bool = false
var attackCooldownTimer: float = 0
var player : CharacterBody3D
var dirVector: Vector3 = Vector3.ZERO
var relativeRigForward: Vector3 = Vector3.ZERO
var takingDamage: bool = false
##cannot be interrupted during attacks
##@onready var stats : Stats = get_node("Stats") 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	print(get_tree().get_nodes_in_group("player"))
	player = get_tree().get_nodes_in_group("player")[0]
	animTree.advance_expression_base_node = get_path()

func _process(delta: float) -> void:
	print(moveSpeed/BASE_MOVE_SPEED)
	animTree.set("parameters/move/TimeScale/scale", moveSpeed/BASE_MOVE_SPEED)
	animTree.set("parameters/attack/TimeScale/scale", attackSpeed)
	attackCooldownTimer -= delta
	##print(attackCooldownTimer)
	if attackCooldownTimer < 0:
		attackCooldownTimer = 0

func _physics_process(delta: float) -> void:
	print(velocity.length()>0.2 and !isAttacking and not playerInRange(), !isAttacking or attackCooldownTimer>0)
	if !takingDamage:
		var pos = getNextMovementPosition()
		dirVector = calculateDirVector(pos)
		rotateToTarget(pos,delta)
		if !playerInRange() and !isAttacking:
			moveToPlayer(pos,delta)
		else:
			if attackCooldownTimer <= 0 and !isAttacking:
				print("attack")
				attack()
	else:
		isAttacking = false
		attackCooldownTimer = 0

func calculateDirVector(_position):
	return (_position - position).normalized()

func getNextMovementPosition():
	navigationAgent.target_position = player.position 
	return navigationAgent.get_next_path_position()
	
func rotateToTarget(pos, delta):
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
		
@abstract
func attack()

@abstract
func playerInRange()

@abstract
func moveToPlayer(target,delta)

@abstract
func takeDamage(damage: float)
