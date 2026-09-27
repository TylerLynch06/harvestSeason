extends Node3D
class_name MovementManager

@export var playerBody: CharacterBody3D
@export var playerRig: Node3D

@onready var stats = get_node("../Stats") as PlayerStats

@onready var animTree: AnimationTree = playerRig.get_node("AnimationTree")
@onready var stateMachine: AnimationNodeStateMachinePlayback = animTree["parameters/player/playback"]
var directionVector: Vector3 = Vector3.ZERO
var rollDirection: Vector3 = Vector3.ZERO

@export var weaponManager: WeaponManager
@export var inputManager: InputManager
@export var debugText: Label
@export var hurtbox: Area3D

var isBeingPushed = false
var currentPushVelocity = Vector3.ZERO

var rollTimer: float = 0
var rollCooldownTimer: float = 0

##Used for animation queuing
var stoppedMoving: bool = false
var isMoving: bool = false
var movementIsLocked: bool = false

var stoppedRolling: bool = true
var isRolling: bool = false
var isRecovering: bool = false

var isInvincible = false
var currentMoveSpeedFactor = 1

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_priority = -1
	rollTimer = stats.BASE_ROLL_TIME

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	alterDebugText()
	animTree.set("parameters/player/conditions/is_rolling", isRolling)
	animTree.set("parameters/player/conditions/is_running", !isRolling and playerBody.velocity.length() > 2)
	animTree.set("parameters/player/conditions/is_idle", !weaponManager.isAttacking and playerBody.velocity.length() < 2)

	hurtbox.monitorable = !isRolling
	hurtbox.monitoring = !isRolling

	if !movementIsLocked and !isRolling:
		if rollCooldownTimer>0:
			rollCooldownTimer -= delta
		else:
			rollCooldownTimer = 0
		if isMoving and !weaponManager.isAttacking:
			#stateMachine.travel("run")
			stoppedMoving = false
		elif !isMoving and !stoppedMoving and !weaponManager.isAttacking:
			#stateMachine.travel("idle")
			stoppedMoving = true
	elif isRolling:
		inputManager.sickleChargeAccumulation = 0
		if rollTimer > 0:
			rollTimer -= delta
		if rollTimer <= 0:
			endRoll()

func _physics_process(delta: float) -> void:
	##print(movementIsLocked)
	if !movementIsLocked:
		directionVector = Vector3.ZERO
		
		##PAUSE FLAG HERE
		calcDirectionVector()
		directionVector = directionVector.normalized()
		if !isRolling and directionVector!= Vector3.ZERO:
			rollDirection = directionVector
		##LOCK DIRECTION ON ROLL
		if Input.is_action_pressed("space") and canRoll():
			isRolling = true	

		movementCheck()
		movePlayer()
		if !isBeingPushed:
			rotatePlayer(delta)
	else:
		playerBody.velocity = Vector3.ZERO

func movementCheck():
	if !isRolling:
		isMoving = playerBody.velocity.length() >= 3 
	else:
		isMoving = true

func movePlayer():
	var velocity
	if !isRolling:
		if PerkHandler.perks["shoes"] != -1:
			velocity = directionVector * stats.BASE_MOVE_SPEED * PerkHandler.progression["shoes"][PerkHandler.perks["shoes"]]
		else:
			velocity = directionVector * stats.BASE_MOVE_SPEED		
		if weaponManager.currentSickleCharge > 0:
			velocity *= stats.BASE_SICKLE_SPIN_MOVE_FACTOR
	elif isRolling:
		velocity = rollDirection * stats.BASE_ROLL_SPEED * PerkHandler.progression["bells"][PerkHandler.perks["bells"]+1]
		
	if !isRecovering:
		if !isBeingPushed:
			playerBody.velocity = velocity
		else:
			calcPushVelocity()
			playerBody.velocity = currentPushVelocity
			playerRig.rotation.y = PI+atan2(currentPushVelocity.x,currentPushVelocity.z)
		playerBody.move_and_slide()

func pushPlayer(pushForce: int = 0, hitPos: Vector3 = Vector3.ZERO):
	if hitPos == Vector3.ZERO:
		return
	isBeingPushed = true
	var pushDir = global_position - hitPos
	currentPushVelocity = pushDir * pushForce	
	
func calcPushVelocity():
	currentPushVelocity *= stats.BASE_PUSH_DRAG_FACTOR
	if currentPushVelocity.length() < 3:
		currentPushVelocity = Vector3.ZERO

func calcDirectionVector():
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

func rotatePlayer(_delta: float):
	if weaponManager.currentSickleCharge > 0:
		playerRig.rotation.y += stats.BASE_SICKLE_ROTATION_SPEED
	elif !isRolling:
		if directionVector!= Vector3.ZERO:
			playerRig.rotation.y = atan2(directionVector.x,directionVector.z)
	else: 
		playerRig.rotation.y = atan2(rollDirection.x,rollDirection.z)

func canRoll():
	return !movementIsLocked and !isRolling and rollCooldownTimer <= 0 and weaponManager.currentSickleCharge <= 0

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
	
func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	if anim_name == "UAL/LayToIdle":
		isBeingPushed = false 
	
func alterDebugText():
	if debugText:
		var rollData = "can_roll: "+str(canRoll())+"\nroll_cooldown_timer: "+str(snapped(rollCooldownTimer, 0.001))+"\nis_rolling: "+str(isRolling)+"\nis_invincible: "+str(!hurtbox.monitorable)
		var locomotionData = "\nis_moving: "+str(isMoving)+"\nmovement_is_locked: "+str(movementIsLocked)
		debugText.text = "MOVEMENT DATA\n"+rollData+locomotionData
		
