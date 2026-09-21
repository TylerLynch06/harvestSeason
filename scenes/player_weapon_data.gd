extends Node3D
class_name WeaponData


@export var swordAnimations = {"idle":["UAL/Sword_Idle"],"attack":["UAL/Sword_Regular_A","UAL/Sword_Regular_B","UAL/Sword_Regular_C"]}
@export var placeholderWeaponAnimations = {"idle":["UAL_A_TPose"],"attack":["UAL/OverhandThrow"]}
var animationSet = {"sword":swordAnimations, "pitchfork":placeholderWeaponAnimations}
var isMelee = {"sword":true,"pitchfork":false}
##weapon name and then combo state
var damageOnHit = {"sword":[10,10,20],"pitchfork":[30]}
