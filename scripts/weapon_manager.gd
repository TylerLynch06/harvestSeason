extends Node3D
class_name WeaponManager
@export var playerBody: CharacterBody3D
@export var playerRig: Node3D
@onready var animTree: AnimationTree = playerRig.get_node("AnimationTree")
@onready var stateMachine: AnimationNodeStateMachinePlayback = animTree["parameters/playback"]
@export var movementManager: MovementManager
@export var comboWindowTime : float
var comboWindowTimer: float
var isAttacking = false
var comboState = 0
var inCombo = false

@export var weaponHurtBox : Area3D

# Called when the node enters the scene tree for the first time.

##----- THIS FUNCTION IS MESSY DUE TO ANIMATION CONSISTENCY WITH STATEMACHINES-----
##-----DO NOT TOUCH SPEAK TO TYLER BEFORE TOUCHING-----
##-----FRAGILE CODE-----
func _ready() -> void:
	weaponHurtBox.area_entered.connect(sword_hit)
	#postAttackMovementLockdownTimer = 0
	#attackTimer = attackDuration

func _process(delta: float):
	weaponHurtBox.monitoring = isAttacking
	comboWindowTimer -= delta
	if comboWindowTimer <= 0:
		comboWindowTimer = 0
		#if comboState!=0:
			#print("RESET COMBO STATE")
		comboState = 0
	animTree.advance_expression_base_node = self.get_path()
	
func attack():
	if !isAttacking:
		isAttacking = true
		comboState = comboState % 3
		movementManager.lockMovement()
	##print(comboState,isAttacking)
	#isAttacking = false
	
func canAttack():
	return !isAttacking

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	##print(anim_name) # Replace with function body.
	if anim_name in ["UAL/Sword_Regular_A","UAL/Sword_Regular_B","UAL/Sword_Regular_C","UAL/sword_heavy_1"]:
		#print("changed combo state")
		isAttacking = false
		comboState += 1
		movementManager.unlockMovement()
		comboWindowTimer = comboWindowTime
		
func sword_hit(area):
	print(area.name == "hitbox" , area.get_parent().is_in_group("enemy"))
	if area.name == "hitbox" and area.get_parent().is_in_group("enemy"):
		print("PLAYER ATTACK SUCCESS")
		var enemy = area.get_parent() as Enemy
		enemy.takeDamage(10)
	
