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

@export var BASE_PUSH_FORCE: float

##critical angle doesnt need a factor
#var critAngleFactor: float

@onready var health: float = BASE_HEALTH
@onready var damage: float = BASE_DAMAGE
@onready var moveSpeed: float = BASE_MOVE_SPEED
@onready var attackSpeed: float = BASE_ATTACK_FACTOR_SPEED
@onready var attackCooldown: float = BASE_ATTACK_COOLDOWN

@export var statsDebugText: Label

func _ready():
	BASE_SICKLE_ROTATION_SPEED = deg_to_rad(BASE_SICKLE_ROTATION_SPEED)

func playerHit(damage: float):
	health -= damage
	
func _process(delta: float):
	alterDebugText()
	
func alterDebugText():
	statsDebugText.text = "STATS_DATA\nplayer_health: "+str(health) + "\nwheat: "+str(Economy.wheat)
