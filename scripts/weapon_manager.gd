extends Node3D
class_name WeaponManager
@export var playerBody: CharacterBody3D
@export var playerRig: Node3D
@onready var animTree: AnimationTree = playerRig.get_node("AnimationTree")
@onready var stateMachine: AnimationNodeStateMachinePlayback = animTree["parameters/playback"]
@export var movementManager: MovementManager
@export var postAttackMovementLockdownTime: float
var postAttackMovementLockdownTimer: float = postAttackMovementLockdownTime
var isPostAttack: bool = false

var isAttacking = false
var attackEnded = true
#@export var attackDuration = 0.8
#var attackTimer = 0
##after an attack ends anmd recovery begins, a user has this long to attack again to continue their combo
@export var successiveAttackRecoveryTime = 2
var successiveAttackTimer = successiveAttackRecoveryTime
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animTree.set("parameters/conditions/is_attacking", isAttacking)
	process_priority = -2
	postAttackMovementLockdownTimer = 0
	pass
	#attackTimer = attackDuration

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#if isPostAttack:
		#print(postAttackMovementLockdownTimer)
	postAttackMovementLockdownTimer -= delta
	if postAttackMovementLockdownTimer <= 0:
		movementManager.unlockMovement()
		isPostAttack = false
	if isAttacking:
		movementManager.lockMovement()
		if stateMachine.get_current_node() != "idle":
			successiveAttackTimer = successiveAttackRecoveryTime
		elif stateMachine.get_current_node() == "idle" and postAttackMovementLockdownTimer < 0:
			isAttacking = false
			movementManager.unlockMovement()
			#attackTimer = attackDuration
			stateMachine.get_current_node() == "idle"
			successiveAttackTimer -= delta
		
	if Input.is_action_just_pressed("lmb"):
		##lockMovement returns false if rolling
		if movementManager.lockMovement():
			if !isAttacking:
				successiveAttackTimer = successiveAttackRecoveryTime
			stateMachine.travel("attack_1")
			postAttackMovementLockdownTimer = postAttackMovementLockdownTime
			isAttacking = true
			
		##---COMBO STATES---
		if successiveAttackTimer > 0:
			if stateMachine.get_current_node() == "recovery1":
				stateMachine.travel("attack_2")
				successiveAttackTimer = successiveAttackRecoveryTime
			if stateMachine.get_current_node() == "recovery2":
				stateMachine.travel("attack_3")
				successiveAttackTimer = successiveAttackRecoveryTime




		

	
