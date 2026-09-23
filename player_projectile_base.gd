extends Node3D

class_name PlayerProjectile

var dirVector = Vector3.ZERO
var velocity = Vector3.ZERO
var player: CharacterBody3D
@export var damage: float
@export var lifetime: float
@export var projectile_speed: float
@export var hitbox: Area3D
@export var pivot: Node3D

##BASIC PROJECTILE
##goes forward and straight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.area_entered.connect(hit)
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	velocity = calcVelocity(delta)
	#if PerkHandler.perks["fishing magnet"] != -1:
		#velocity = Vector3.ZERO
	#print(velocity)
	position += velocity * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime<=0:
		queue_free()
	
func setInitialPosAndRot(_position: Vector3, _rotation: float):
	global_position = _position
	pivot.rotation.y = _rotation
	
##Feel free to overwrite in subclass
func calcVelocity(_delta):
	return dirVector * projectile_speed
	
func setStats(_damage: float = damage, _speed_factor: float = projectile_speed, _dirVector: Vector3 = Vector3.ZERO):
	damage = _damage
	projectile_speed *= _speed_factor
	dirVector = _dirVector.normalized()
	
func hit(area: Area3D):
	if area.name == "hitbox" and area.get_parent().is_in_group("enemy"):
		var enemy = area.get_parent() as Enemy
		enemy.takeDamage(damage)
