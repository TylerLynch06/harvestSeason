extends Node3D
class_name WeaponManager
@export var playerBody: CharacterBody3D
@export var playerRig: Node3D
@onready var animTree: AnimationTree = playerRig.get_node("AnimationTree")
@onready var stateMachine: AnimationNodeStateMachinePlayback = animTree["parameters/player/playback"]
@onready var animPlayer: AnimationPlayer = playerRig.get_node("AnimationPlayer")
@export var movementManager: MovementManager
@export var comboWindowTime : float
var comboWindowTimer: float
var isAttacking = false
var comboState = 0
var inCombo = false
@export var WEAPON_DATA: WeaponData

@export var weaponHurtBox : Area3D

@export var pitchforkProjectile: PackedScene
@export var pitchforkSpawn: Node3D

@export var debugText: Label = null
@export var weaponDebugText: Label = null
@export var stats: PlayerStats
var currentWeaponName = "sword"
var microFreezeTimer = 0
@onready var currentAnimationSet = WEAPON_DATA.animationSet.get(currentWeaponName)
var bonusDamage = 0

var currentSickleCharge = 0
##Sickle damages at regular intervals, using hitboxes for the sicles would be too messy and owuldnt work well
var currentSickleDamageTimer = 0
@export var sickleHitbox: Area3D
# Called when the node enters the scene tree for the first time.

##----- THIS FUNCTION IS MESSY DUE TO ANIMATION CONSISTENCY WITH STATEMACHINES-----
##-----DO NOT TOUCH SPEAK TO TYLER BEFORE TOUCHING-----
##-----FRAGILE CODE-----
func _ready() -> void:
	for weapon in WEAPON_DATA.meshSet.values():
		if weapon:
			weapon.hide()
	changeWeapon("sword")
	weaponHurtBox.monitoring = false
	#weaponHurtBox.area_entered.connect(weapon_hit)
	#weaponHurtBox.area_exited.connect(weapon_leave)
	#postAttackMovementLockdownTimer = 0
	#attackTimer = attackDuration

func _process(delta: float):
	alterDebugText()
	if movementManager.isBeingPushed:
		movementManager.unlockMovement()
	if !isAttacking or movementManager.isBeingPushed:
		weaponHurtBox.monitoring = false
		
	if currentWeaponName == "sickles":
		sickleUpdate(delta)
	comboWindowTimer -= delta
	if comboWindowTimer <= 0:
		comboWindowTimer = 0
		#if comboState!=0:
			#print("RESET COMBO STATE")
		comboState = 0
	if microFreezeTimer > 0:
		animPlayer.speed_scale = 0.0
		microFreezeTimer -= delta
	elif microFreezeTimer <= 0:
		animTree.set("parameters/TimeScale/scale", 1)
		microFreezeTimer = 0
	animTree.advance_expression_base_node = self.get_path()
	
func _physics_process(delta):
	if weaponHurtBox.monitoring:
		for area in weaponHurtBox.get_overlapping_areas():
			if area.name == "hitbox" and area.get_parent().is_in_group("enemy"):
				weapon_hit(area)
	
func attack():
	if !isAttacking:
		isAttacking = true
		weaponHurtBox.monitoring = false 
		if WEAPON_DATA.doMovementLock.get(currentWeaponName):
			movementManager.lockMovement()
	
func canAttack():
	return !isAttacking

func _on_animation_tree_animation_finished(anim_name: StringName) -> void:
	##print(anim_name) # Replace with function body.
	if anim_name in currentAnimationSet.get("attack") and currentWeaponName != "sickles":
		#print("changed combo state")
		isAttacking = false
		#print(anim_name+ " over. Combo state: ", comboState)
		movementManager.unlockMovement()
		comboWindowTimer = comboWindowTime
		
func weapon_hit(area):
	##print(area.name == "hitbox" , area.get_parent().is_in_group("enemy"))
	if area.name == "hitbox" and area.get_parent().is_in_group("enemy"):
		bonusDamage = 0
		var enemy = area.get_parent() as Enemy
		if enemy.is_in_group("boss") and PerkHandler.perks.get("monsterhunter charm") != -1:
			bonusDamage += 10 * PerkHandler.progression.get("monsterhunter charm")[PerkHandler.perks.get("monsterhunter charm")]
		
		var pushForce = stats.BASE_PUSH_FORCE * WEAPON_DATA.pushFactor.get(currentWeaponName)
		enemy.takeDamage(WEAPON_DATA.damageOnHit.get(currentWeaponName)[comboState] + bonusDamage, 
		global_position, 
		pushForce,
		0.3)
		
		if WEAPON_DATA.isMelee.get(currentWeaponName):
			animTree.set("parameters/TimeScale/scale", stats.BASE_MICROFREEZE_SPEED_FACTOR)
			microFreezeTimer = stats.BASE_MICROFREEZE_TIME
		
func weapon_leave(area):
	if area.name == "hitbox" and area.get_parent().is_in_group("enemy"):
		var enemy = area.get_parent() as Enemy
		enemy.weaponLeftBody()
		
func toggleHurtbox():
	weaponHurtBox.monitoring = !weaponHurtBox.monitoring
	
func setComboState(_comboState: int):
	comboState = _comboState

func changeWeapon(weaponName: String):
	if !isAttacking:
		##Resets combo state and reassings attack animations
		comboState = 0
		##This has an extremletyty short cool down, resetting when weaponn changed will not lead to abuse
		currentSickleDamageTimer = 0
		#print(currentWeaponName)
		#print( WEAPON_DATA.meshSet.values())
		#print( WEAPON_DATA.meshSet.get(currentWeaponName) )
		var oldWeapon = WEAPON_DATA.meshSet.get(currentWeaponName) as Node3D
		oldWeapon.hide()
		currentWeaponName = weaponName
		var newWeapon = WEAPON_DATA.meshSet.get(currentWeaponName) as Node3D
		newWeapon.show()
		currentAnimationSet = WEAPON_DATA.animationSet.get(currentWeaponName)
		#print(currentAnimationSet," ",currentAnimationSet.values())
		for i in range(3):
			if i >= len(currentAnimationSet.get("attack")):
				break
			print(currentAnimationSet.get("attack")[i])	
			#print(animTree.get_tree_root()..get_node().get_node("attack_"+str(i+1))," ","attack_"+str(i+1))
			#print(animTree.get_tree_root().get_node("attack_"+str(i+1)).animation)
			animTree.get_tree_root().get_node("player").get_node("attack_"+str(i+1)).animation = StringName(currentAnimationSet.get("attack")[i])


func alterDebugText():
	if debugText:
		var attackStateData = "is_attacking: "+str(isAttacking)+"\ncombo_window_timer: "+str(str(snapped(comboWindowTimer, 0.001)))+"\ncan_follow_up: "+str(comboWindowTimer>0)+"\ncombo_state: "+str(comboState)
		var hitboxData = "hitbox_monitoring: "+str(weaponHurtBox.monitoring)+"\nmicrofreeze: "+str(microFreezeTimer>0)
		debugText.text = "ATTACK DATA\n"+attackStateData+"\n"+hitboxData
		
	if weaponDebugText:
		var currentWeaponData = "current_weapon: "+str(currentWeaponName)
		if currentWeaponName == "sickles":
			currentWeaponData+="\nsickle_charge: "+str(currentSickleCharge)
		weaponDebugText.text = "WEAPON_DATA\n"+currentWeaponData
		
##unfortunate this has to be here
##Is called by the throw animation
func throwPitchfork():
	var projectileInstance = pitchforkProjectile.instantiate() as PitchforkProjectille
	var TEMP_SPEED_FACTOR = 1
	projectileInstance.setInitialPosAndRot(pitchforkSpawn.global_position, 
	playerRig.rotation.y)
	projectileInstance.setStats(WEAPON_DATA.damageOnHit.get("pitchfork")[0],
	TEMP_SPEED_FACTOR,
	playerRig.global_transform.basis.z.normalized())
	get_tree().root.add_child.call_deferred(projectileInstance)
	
func chargeSickles(charge: float):
	currentSickleCharge = charge
	
func sickleUpdate(delta):
	if currentSickleCharge > 0:
		currentSickleCharge -= stats.BASE_SICKLE_DRAIN_RATE * delta
		if currentSickleDamageTimer < 0:
			sickleDamagePulse()
			currentSickleDamageTimer = stats.BASE_SICKLE_DAMAGE_INTERVAL
		currentSickleDamageTimer -= delta
	elif currentSickleCharge <= 0:
		isAttacking = false

func sickleDamagePulse():
	var overlappingAreas = sickleHitbox.get_overlapping_areas()
	for area in overlappingAreas:
		if area.name == "hitbox" and area.get_parent().is_in_group("enemy"):
			var enemy = area.get_parent() as Enemy
			var pushForce = stats.BASE_PUSH_FORCE * WEAPON_DATA.pushFactor.get("sickles")
			enemy.takeDamage(WEAPON_DATA.damageOnHit.get("sickles")[0], 
			global_position, 
			pushForce,
			0)
