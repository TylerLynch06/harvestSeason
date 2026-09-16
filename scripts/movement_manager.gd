extends Node3D
class_name MovementManager

@export var playerBody: CharacterBody3D
@export var playerRig: Node3D
@export var PLAYER_SPEED: float = 5
@onready var animTree: AnimationTree = playerRig.get_node("AnimationTree")
@onready var stateMachine: AnimationNodeStateMachinePlayback = animTree["parameters/playback"]
var directionVector: Vector3 = Vector3.ZERO
var rollDirection: Vector3 = Vector3.ZERO

@export var rollSpeed: float = 500
@export var weaponManager: WeaponManager
##How many times faster the animation should play, directly correlates to rill time
var rollAnimationSpeedFactor = 1
##This is the time it takes for the roll animation to play
@export var rollTime: float = 1.1 / rollAnimationSpeedFactor
var rollTimer: float 
var rollRecoveryTime: float = 0.1
var rollRecoveryTimer: float = 1

var rollCooldown: float = 0.1
var rollCooldownTimer: float = rollCooldown

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
	rollTimer = rollTime
	rollRecoveryTimer = rollRecoveryTime

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	print(weaponManager.isAttacking)
	if !movementIsLocked and !isRolling:
		rollCooldownTimer -= delta
		if isMoving and !weaponManager.isAttacking:
			stateMachine.travel("run")
			stoppedMoving = false
		elif !isMoving and !stoppedMoving and !weaponManager.isAttacking:
			stateMachine.travel("idle")
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
			stateMachine.travel("roll")

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
		velocity = directionVector * PLAYER_SPEED * delta
	elif isRolling:
		velocity = rollDirection * rollSpeed * delta
		
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
	rollCooldownTimer = rollCooldown
	isRolling = false
	rollTimer = rollTime	
	stateMachine.travel("idle")
