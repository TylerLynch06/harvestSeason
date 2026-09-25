extends Node3D

class_name InputManager

@export var weaponManager: WeaponManager
@export var weaponDict = {1: "sword",2: "pitchfork",3:"sickles"}
@export var stats: PlayerStats
var sickleChargeAccumulation: float
@export var debugText: Label = null

##Doesnt include movement manager, movement manager's code cannot be applied to both player and enemy
#@export var movementMangaer: MovementManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("lmb") and weaponManager.canAttack():
		if weaponManager.currentWeaponName != "sickles" :
			weaponManager.attack()
	if Input.is_action_pressed("lmb") and weaponManager.currentSickleCharge<=0 and weaponManager.currentWeaponName == "sickles":
		if stats.BASE_SICKLE_CHARGE_MAX>sickleChargeAccumulation:
			sickleChargeAccumulation += stats.BASE_SICKLE_CHARGE_RATE * delta
		else:
			sickleChargeAccumulation = stats.BASE_SICKLE_CHARGE_MAX
	if Input.is_action_just_released("lmb"):
		if weaponManager.currentWeaponName == "sickles" and weaponManager.canAttack():
			weaponManager.chargeSickles(sickleChargeAccumulation)
			sickleChargeAccumulation = 0
			weaponManager.attack()
	if Input.is_action_just_pressed("1"):
		weaponManager.changeWeapon(weaponDict.get(1))
	if Input.is_action_just_pressed("2"):
		weaponManager.changeWeapon(weaponDict.get(2))
	if Input.is_action_just_pressed("3"):
		weaponManager.changeWeapon(weaponDict.get(3))
		sickleChargeAccumulation = 0
	debugText.text = "INPUT_DATA\nsickle_charge: "+str(sickleChargeAccumulation)
