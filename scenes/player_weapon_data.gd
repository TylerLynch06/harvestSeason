extends Node3D
class_name WeaponData


@export var swordAnimations = {"idle":["UAL/Sword_Idle"],"attack":["UAL/Sword_Regular_A","UAL/Sword_Regular_B","UAL/Sword_Regular_C"]}
@export var placeholderWeaponAnimations = {"idle":["UAL_A_TPose"],"attack":["UAL/Shield_Dash"]}
var animationSet = {"sword":swordAnimations, "placeholder":placeholderWeaponAnimations}

var isMelee = {"sword":true,"placeholder":false}
