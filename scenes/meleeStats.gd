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

func _ready():
	BASE_TURN_SPD = deg_to_rad(BASE_TURN_SPD)
	BASE_CRT_ANGLE = deg_to_rad(BASE_CRT_ANGLE)
	turnSpeed = BASE_TURN_SPD
	critAngle = BASE_CRT_ANGLE
	print("VALUE: ",moveSpeed," ",BASE_MOVE_SPEED," ",moveSpeed/BASE_MOVE_SPEED)
	
@abstract func takeDamage(damage: float)

func applyFactors(_heatlhFactor,_damageFactor,_moveSpeedFactor,_attackSpeedFactor,_cooldown_Factor,_turnSpeedFactor):
	health*=_heatlhFactor
	damage*=_damageFactor
	moveSpeed*=_moveSpeedFactor
	attackSpeed*=_attackSpeedFactor
	cooldown*=_cooldown_Factor
	turnSpeed*=_turnSpeedFactor
	
	
