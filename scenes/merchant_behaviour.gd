extends CharacterBody3D
@export var critAngle = 5
@export var turnSpeed = 150
@export var stop: Node3D
@export var navigationAgent : NavigationAgent3D
@export var pivot: Node3D
var dirVector: Vector3 = Vector3.ZERO
var relativeRigForward = Vector3.ZERO
@export var BASE_MOVE_SPEED = 150

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	critAngle = deg_to_rad(critAngle)
	turnSpeed = deg_to_rad(turnSpeed)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _physics_process(delta: float) -> void:
	##print(!playerInRange(), !isAttacking)
	var pos = getNextMovementPosition()
	dirVector = calculateDirVector(pos)
	rotateToTarget(delta)
	moveToPlayer(pos,delta)
	#moveTo(pos,delta)

func getNextMovementPosition():
	navigationAgent.target_position = stop.position 
	return navigationAgent.get_next_path_position()
	
#func moveTo(pos,delta):
	#var dirVector = (pos - position).normalized()
	#
	#pivot.rotation.y = atan2(dirVector.x, dirVector.z)
	#velocity = dirVector * delta * BASE_MOVE_SPEED
	#move_and_slide()
	##
func calculateDirVector(_position):
	return (_position - position).normalized()
	
func rotateToTarget(delta):

	var flatDir = Vector3(dirVector.x, 0, dirVector.z).normalized()
	if flatDir == Vector3.ZERO:
		return
	##Forward vector of the pivot
	var forward = -pivot.global_transform.basis.z.normalized()
	var targetHeading = atan2(flatDir.x, flatDir.z)
	var currentHeading = atan2(forward.x, forward.z)
	##If angle spills over pi, it goes to -pi
	var signedAngle = wrapf(targetHeading - currentHeading, -PI, PI)
	if abs(signedAngle) > critAngle:
		var step = clamp(signedAngle, 
		-turnSpeed * delta,
		turnSpeed * delta)
		pivot.rotation.y += step
		
		
func moveToPlayer(_position,delta):
	velocity = -pivot.global_transform.basis.z.normalized() * BASE_MOVE_SPEED * delta
	move_and_slide()
