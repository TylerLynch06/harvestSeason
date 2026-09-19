extends Node3D

@export var weaponManager: WeaponManager
@export var weaponDict = {1: "sword",2: "placeholder"}

##Doesnt include movement manager, movement manager's code cannot be applied to both player and enemy
#@export var movementMangaer: MovementManager
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("lmb") and weaponManager.canAttack():
		weaponManager.attack()
	if Input.is_action_just_pressed("1"):
		weaponManager.changeWeapon(weaponDict.get(1))
	if Input.is_action_just_pressed("2"):
		weaponManager.changeWeapon(weaponDict.get(2))
