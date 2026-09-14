extends Node3D

@export var playerBody: CharacterBody3D
@export var playerRig: Node3D
@onready var animTree: AnimationTree = playerRig.get_node("AnimationTree")
@onready var stateMachine: AnimationNodeStateMachinePlayback = animTree["parameters/playback"]
@export var movementManager: MovementManager
var isAttacking = false
var attackEnded = true
@export var attackDuration = 0.8
var attackTimer = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	attackTimer = attackDuration


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if isAttacking:
		if !movementManager.movementIsLocked:
			movementManager.lockMovement()
		attackTimer -= delta
		if attackTimer <= 0:
			attackEnded = true
			isAttacking = false
			movementManager.unlockMovement()
			attackTimer = attackDuration
		
	if Input.is_action_just_pressed("lmb"):
		##lockMovement returns false if rolling
		if movementManager.lockMovement():
			stateMachine.travel("idle")
			stateMachine.travel("attack")
			##playerAnimationPlayer.speed_scale = attackSpeedScale
			isAttacking = true
			attackEnded = false

		

	
