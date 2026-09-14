extends Node3D

@export var playerBody: CharacterBody3D
@export var playerRig: Node3D
@onready var animTree: AnimationTree = playerRig.get_node("AnimationTree")
@onready var stateMachine: AnimationNodeStateMachinePlayback = animTree["parameters/playback"]
##this is a nested statemachine, not sure how to ready it by default
@onready var attackStateMachine: AnimationNodeStateMachinePlayback = animTree["parameters/attackSM/playback"]
@export var movementManager: MovementManager
var isAttacking = false
var attackEnded = true
#@export var attackDuration = 0.8
#var attackTimer = 0
##after an attack ends anmd recovery begins, a user has this long to attack again to continue their combo
@export var successiveAttackRecoveryTime = 0.5
var successiveAttackTimer = successiveAttackRecoveryTime
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	#attackTimer = attackDuration

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isAttacking:
		if !movementManager.movementIsLocked:
			movementManager.lockMovement()
		#attackTimer -= delta
		#if attackTimer <= 0:
		if attackStateMachine.get_current_node() == "End":
			attackEnded = true
			isAttacking = false
			movementManager.unlockMovement()
			#attackTimer = attackDuration
		if attackStateMachine.get_current_node() == "recovery1" or attackStateMachine.get_current_node() == "recovery2":
			successiveAttackTimer -= delta
		
	if Input.is_action_just_pressed("lmb"):
		##lockMovement returns false if rolling
		if movementManager.lockMovement():
			successiveAttackTimer = successiveAttackRecoveryTime
			stateMachine.travel("idle")
			stateMachine.travel("attackSM")
			print(stateMachine.get_current_node()," ", attackStateMachine.get_current_node() )
			##playerAnimationPlayer.speed_scale = attackSpeedScale
			isAttacking = true
			attackEnded = false
			
		##---COMBO STATES---
		if successiveAttackTimer > 0:
			if attackStateMachine.get_current_node() == "recovery1":
				attackStateMachine.travel("attack2")
				successiveAttackTimer = successiveAttackRecoveryTime
			if attackStateMachine.get_current_node() == "recovery2":
				attackStateMachine.travel("attack3")
				successiveAttackTimer = successiveAttackRecoveryTime

		#if isAttacking:
			#stateMachine.travel("attack2")
		#elif stateMachine.get_current_node() == "attack2":
			#stateMachine.travel("attack3")



		

	
