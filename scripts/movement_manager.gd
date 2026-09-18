extends Node3D
class_name MovementManager

@export var playerBody: CharacterBody3D
@export var playerRig: Node3D

@onready var stats = get_node("../Stats") as PlayerStats

@onready var animTree: AnimationTree = playerRig.get_node("AnimationTree")
@onready var stateMachine: AnimationNodeStateMachinePlayback = animTree["parameters/playback"]
var directionVector: Vector3 = Vector3.ZERO
var rollDirection: Vector3 = Vector3.ZERO

@export var weaponManager: WeaponManager

var rollTimer: float = 0
var rollCooldownTimer: float = 0

##Used for animation queuing
var stoppedMoving: bool = false
var isMoving: bool = false
var movementIsLocked: bool = false

var stoppedRolling: bool = true
var isRolling: bool = false
var isRecovering: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_priority = -1
	rollTimer = stats.BASE_ROLL_TIME

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	animTree.set("parameters/conditions/is_rolling", isRolling)
	animTree.set("parameters/conditions/is_running", !isRolling and playerBody.velocity.length() > 2)
	animTree.set("parameters/conditions/is_idle", !weaponManager.isAttacking and playerBody.velocity.length() < 2)

	if !movementIsLocked and !isRolling:
		rollCooldownTimer -= delta
		if isMoving and !weaponManager.isAttacking:
			#stateMachine.travel("run")
			stoppedMoving = false
		elif !isMoving and !stoppedMoving and !weaponManager.isAttacking:
			#stateMachine.travel("idle")
			stoppedMoving = true
	elif isRolling:
		if rollTimer > 0:
			rollTimer -= delta
		if rollTimer <= 0:
			endRoll()
		
func _physics_process(delta: float) -> void:
	##print(movementIsLocked)
	if !movementIsLocked:
		directionVector = Vector3.ZERO
		if Input.is_action_pressed("up"):
			directionVector.x -= 1
			directionVector.z -= 1
		if Input.is_action_pressed("down"):
			directionVector.x += 1
			directionVector.z += 1
		if Input.is_action_pressed("left"):
			directionVector.x -= 1
			directionVector.z += 1
		if Input.is_action_pressed("right"):
			directionVector.x += 1
			directionVector.z -= 1
			
		directionVector = directionVector.normalized()
		if !isRolling and directionVector!= Vector3.ZERO:
			rollDirection = directionVector
		##LOCK DIRECTION ON ROLL
		if Input.is_action_pressed("space") and canRoll():
			isRolling = true	

		movementCheck()
		movePlayer(delta)
		rotatePlayer()
	else:
		playerBody.velocity = Vector3.ZERO

func movementCheck():
	if !isRolling:
		isMoving = playerBody.velocity.length() >= 3 
	else:
		isMoving = true

func movePlayer(delta):
	var velocity
	if !isRolling:
		velocity = directionVector * stats.BASE_MOVE_SPEED * delta
	elif isRolling:
		velocity = rollDirection * stats.BASE_ROLL_SPEED * delta
		
	if !isRecovering:
		playerBody.velocity = velocity
		playerBody.move_and_slide()

func rotatePlayer():
	if !isRolling:
		if directionVector!= Vector3.ZERO:
			playerRig.rotation.y = atan2(directionVector.x,directionVector.z)
	else: 
		playerRig.rotation.y = atan2(rollDirection.x,rollDirection.z)

func canRoll():
	return !movementIsLocked and !isRolling and rollCooldownTimer <= 0 

func lockMovement():
	if isRolling:
		return false
	movementIsLocked = true
	return true

func unlockMovement():
	movementIsLocked = false

func endRoll():
	rollCooldownTimer = stats.BASE_ROLL_COOLDOWN
	isRolling = false
	rollTimer = stats.BASE_ROLL_TIME	
	#stateMachine.travel("idle")
