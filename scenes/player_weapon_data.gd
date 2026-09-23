extends Node3D
class_name WeaponData

@export var swordMesh: MeshInstance3D
@export var pitchforkMesh: MeshInstance3D
@export var sickleParent: Node3D

@export var swordAnimations = {"idle":["UAL/Sword_Idle"],"attack":["UAL/Sword_Regular_A","UAL/Sword_Regular_B","UAL/Sword_Regular_C"]}
@export var pitchforkWeaponAnimations = {"idle":["UAL_A_TPose"],"attack":["UAL/OverhandThrow"]}
@export var sickleAnimations = {"idle":["UAL_A_TPose"],"attack":["Spinning"]}


var animationSet = {"sword":swordAnimations, "pitchfork":pitchforkWeaponAnimations, "sickles":sickleAnimations}
@onready var meshSet = {"sword":swordMesh,"pitchfork":pitchforkMesh,"sickles":sickleParent}
var isMelee = {"sword":true,"pitchfork":false,"sickles":true}
var doMovementLock = {"sword":true,"pitchfork":true,"sickles":false}
##weapon name and then combo state
var damageOnHit = {"sword":[10,10,20],"pitchfork":[30],"sickles":[10]}
var pushFactor =  {"sword":0.8,"pitchfork":1.2,"sickles":0.4}
