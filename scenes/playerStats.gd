extends Node3D

class_name PlayerStats

@export var BASE_HEALTH: float
@export var MAX_HEALTH: float
@export var BASE_DAMAGE: float
@export var BASE_MOVE_SPEED: float
@export var BASE_ATTACK_FACTOR_SPEED: float
##Attack cooldown
@export var BASE_ATTACK_COOLDOWN: float
@export var BASE_ROLL_SPEED: float
@export var BASE_ROLL_TIME: float
@export var BASE_ROLL_COOLDOWN: float
@export var BASE_WALK_ANIM_SPD_FACTOR: float
@export var BASE_MICROFREEZE_TIME: float
@export var BASE_MICROFREEZE_SPEED_FACTOR: float
###Time to start moving/attacking after being hit
#@export var BASE_RECOVERY_TIME: float
###invinciibility time
#@export var BASE_INVUL_ON_HIT: float
##What factor he attack range increases by during an attack.
#@export var BASE_ATTACK_RANGE_INCRASE: float
@export var BASE_SICKLE_DRAIN_RATE: float
@export var BASE_SICKLE_CHARGE_RATE: float
@export var BASE_SICKLE_CHARGE_MAX: float
@export var BASE_SICKLE_ROTATION_SPEED: float
@export var BASE_SICKLE_DAMAGE_INTERVAL: float
@export var BASE_SICKLE_SPIN_MOVE_FACTOR: float

@export var BASE_PUSH_DRAG_FACTOR: float = 0.92
@export var BASE_PUSH_FORCE: float

##critical angle doesnt need a factor
#var critAngleFactor: float

@onready var health: float = BASE_HEALTH
@onready var damage: float = BASE_DAMAGE
@onready var moveSpeed: float = BASE_MOVE_SPEED
@onready var attackSpeed: float = BASE_ATTACK_FACTOR_SPEED
@onready var attackCooldown: float = BASE_ATTACK_COOLDOWN
@export var movementManager: MovementManager
@export var weaponManager: WeaponManager

@export var statsDebugText: Label

@export var isDead = false

@export var animTree: AnimationTree
@onready var stateMachine: AnimationNodeStateMachinePlayback = animTree["parameters/player/playback"]

func _ready():
	BASE_SICKLE_ROTATION_SPEED = deg_to_rad(BASE_SICKLE_ROTATION_SPEED)
	
func playerHit(damage: float, pushForce: int = 0, hitPos: Vector3 = Vector3.ZERO):
	health -= damage
	if pushForce!=0 and hitPos != Vector3.ZERO:
		movementManager.pushPlayer(pushForce, hitPos)
	get_tree().get_first_node_in_group("HUD").get_node("HEALTH/Bar").damage_health(damage)
	
func _process(delta: float):
	alterDebugText()
	if health <= 0 and !isDead:
		isDead = true
		#movementManager.queue_free()
		#weaponManager.queue_free()
		stateMachine.travel("death")
		GameoverManager.gameover()
	
func alterDebugText():
	statsDebugText.text = "STATS_DATA\nplayer_health: "+str(health) + "\nwheat: "+str(Economy.wheat)
