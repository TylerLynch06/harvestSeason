@abstract
extends CharacterBody3D
class_name Stats

@export var BASE_HEALTH: float
@export var BASE_DAMAGE: float
@export var BASE_MOVE_SPEED: float
@export var BASE_ATTACK_FACTOR_SPEED: float
@export var BASE_COOLDOWN: float
@export var BASE_TURN_SPD: float
@export var BASE_CRT_ANGLE: float
##Time to start moving/attacking after being hit
@export var BASE_RECOVERY_TIME: float
##invinciibility time
@export var BASE_INVUL_ON_HIT: float
##What factor he attack range increases by during an attack.
@export var BASE_ATTACK_RANGE_INCRASE: float
@export var BASE_WALK_ANIM_SPD_FACTOR: float
@export var WHEAT_ON_DEATH: int
##Reduction in push force
@export var BASE_PUSH_FACTOR: float = 1
##On update:
## pushVelocity *= BASE_PUSH_DRAG_FACTOR
@export var BASE_PUSH_DRAG_FACTOR: float = 1

##critical angle doesnt need a factor
#var critAngleFactor: float

@onready var health: float = BASE_HEALTH
@onready var damage: float = BASE_DAMAGE
@onready var moveSpeed: float = BASE_MOVE_SPEED
@onready var attackSpeed: float = BASE_ATTACK_FACTOR_SPEED
@onready var cooldown: float = BASE_COOLDOWN
@onready var turnSpeed: float
@onready var critAngle: float

##cant be stunned by attacks
@export var isUnstoppable: bool
var _appliedFactors = false

func _ready():
	BASE_TURN_SPD = deg_to_rad(BASE_TURN_SPD)
	BASE_CRT_ANGLE = deg_to_rad(BASE_CRT_ANGLE)
	turnSpeed = BASE_TURN_SPD
	critAngle = BASE_CRT_ANGLE
	print("VALUE: ",moveSpeed," ",BASE_MOVE_SPEED," ",moveSpeed/BASE_MOVE_SPEED)

func applyFactors(_heatlhFactor,_damageFactor,_moveSpeedFactor,_attackSpeedFactor,_cooldown_Factor,_turnSpeedFactor):
	if !_appliedFactors:
		_appliedFactors = true
		health*=_heatlhFactor
		damage*=_damageFactor
		moveSpeed*=_moveSpeedFactor
		attackSpeed*=_attackSpeedFactor
		cooldown*=_cooldown_Factor
		turnSpeed*=_turnSpeedFactor
		
	
