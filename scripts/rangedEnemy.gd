extends Enemy
class_name RangedEnemy

@export var debugHitbox: Area3D = null
@export var projectile: PackedScene
@export var projectileSpawn: Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	animTree.animation_finished.connect(animation_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	if (debugHitbox):
		var colShape = debugHitbox.get_child(0) as CollisionShape3D
		if invulTimer > 0:
			colShape.debug_color = Color(0.245, 0.245, 0.245, 1.0)
		else:
			colShape.debug_color = Color(0x0000ffff)
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)

func launchProjectile():
	var projectileInstance = projectile.instantiate() as Projectile
	projectileInstance.global_position = projectileSpawn.global_position
	if player:
		projectileInstance.targetPlayer(player)	
	get_tree().root.add_child.call_deferred(projectileInstance)
	
	
