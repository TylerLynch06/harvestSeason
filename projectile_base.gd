extends Node

class_name Projectile

var dirVector = Vector3.ZERO
var velocity = Vector3.ZERO
var player: CharacterBody3D
@export var lifetime: float
@export var projectile_speed: float
@export var hitbox: Area3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hitbox.area_entered.connect(hit)
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	self.position += velocity * delta

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	lifetime -= delta
	if lifetime<=0:
		queue_free()
	
func targetPlayer(_player: CharacterBody3D):
	player = _player
	dirVector = (player.get_node("target").global_position - self.position).normalized() 
	velocity = dirVector * projectile_speed

func hit(area: Area3D):
	if area.name == "hurtbox" and area.get_parent().is_in_group("player"):
		var player = area.get_parent() as CharacterBody3D
		var stats = player.get_node("Stats") as PlayerStats
		stats.playerHit(10)
		queue_free()
