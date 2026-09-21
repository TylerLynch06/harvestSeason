extends Node

class_name PlayerProjectile

var dirVector = Vector3.ZERO
var velocity = Vector3.ZERO
var player: CharacterBody3D
@export var damage: float
@export var lifetime: float
@export var projectile_speed: float
@export var hitbox: Area3D

##BASIC PROJECTILE
##goes forward and straight

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.area_entered.connect(hit)
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	velocity = dirVector * projectile_speed
	self.position += velocity * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime<=0:
		queue_free()
		
func setDamage(_damage: float = damage):
	damage = _damage
	
func setSpeed(speed: float = projectile_speed):
	projectile_speed = speed
	
func setRotation(rotation: Vector3 = Vector3.ZERO):
	dirVector = rotation
	
func hit(area: Area3D):
	print("HIT ",area.name)
	if area.name == "hitbox" and area.get_parent().is_in_group("enemy"):
		var enemy = area.get_parent() as Enemy
		enemy.takeDamage(damage)
