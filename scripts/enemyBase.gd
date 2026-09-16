@abstract
class_name Enemy
extends CharacterBody3D

@export var attackCooldown: float
@export var navigationAgent: NavigationAgent3D
@export var baseMoveSpeed: float
var moveSpeed: float = baseMoveSpeed
@export var moveSpeedFactor: float
@export var pivot: Node3D
@export var animTree: AnimationTree
@export var turnSpeed: float
##we stop rotating if playing angle within [-criticalAngle,criticalAngle]
@export var criticalAngle: float
@export var animPlayer: AnimationPlayer
var attackCooldownTimer: float
var player : CharacterBody3D
var dirVector: Vector3 = Vector3.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	turnSpeed = deg_to_rad(turnSpeed)
	criticalAngle = deg_to_rad(criticalAngle)
	print("RUNNING")
	print(get_tree().get_nodes_in_group("player"))
	player = get_tree().get_nodes_in_group("player")[0]
	animTree.advance_expression_base_node = get_path()

func _process(delta: float) -> void:
	animTree.set("parameters/BlendTree/TimeScale/scale", moveSpeedFactor)
	moveSpeed = baseMoveSpeed * moveSpeedFactor
	if attackCooldownTimer > 0:
		attackCooldownTimer = 0
	animPlayer.speed_scale = 50

func _physics_process(delta: float) -> void:
	if !playerInRange():
		##CONSIDER REFORMATTING, THIS IS QUITE INEFFICIENT
		##CALCUALTES PATH EVERY FRAME
		var pos = getNextMovementPosition()
		moveToPlayer(pos,delta)
		rotateToTarget(pos,delta)
	else:
		if attackCooldownTimer < 0:
			attack()
			attackCooldown = attackCooldownTimer
	
func getNextMovementPosition():
	navigationAgent.target_position = player.position 
	return navigationAgent.get_next_path_position()
	
func rotateToTarget(pos, delta):
	var flatDir = Vector3(dirVector.x, 0, dirVector.z).normalized()
	if flatDir == Vector3.ZERO:
		return
	##Forward vector of the pivot
	var forward = -pivot.global_transform.basis.z.normalized()
	var targetHeading = atan2(flatDir.x, flatDir.z)
	var currentHeading = atan2(forward.x, forward.z)
	##If angle spills over pi, it goes to -pi
	var signedAngle = wrapf(targetHeading - currentHeading, -PI, PI)

	if abs(signedAngle) > criticalAngle:
		var step = clamp(signedAngle, -turnSpeed * delta, turnSpeed * delta)
		pivot.rotation.y += step
		
@abstract
func attack()

@abstract
func playerInRange()

@abstract
func moveToPlayer(target,delta)
