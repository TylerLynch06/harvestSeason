extends Enemy

@export var debugHitbox: Area3D = null
##can only hit player once per attack
var hasHitPlayer = false
var damaging = false

@export var DO_PUSH_PLAYER = false
@export var PUSH_FORCE = 1000

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	super._ready()
	damaging = false
	animTree.animation_finished.connect(animation_finished)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	super._process(delta)
	damageInHitbox()
	if (debugHitbox):
		var colShape = debugHitbox.get_child(0) as CollisionShape3D
		if invulTimer > 0:
			colShape.debug_color = Color(0.245, 0.245, 0.245, 1.0)
		else:
			colShape.debug_color = Color(0x0000ffff)
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	
func takeDamage(damage: float, hitPos: Vector3 = Vector3.ZERO, pushForce: float = 0, weaponStunFactor: float = 1):
	super.takeDamage(damage,hitPos,pushForce,weaponStunFactor)
	if invulTimer<0:
		if damaging:
			toggleDamaging()

func attack():
	super.attack()
	hasHitPlayer = false

func toggleDamaging():
	damaging = !damaging

func damageInHitbox():
	if playerInRange() and !hasHitPlayer and damaging:
		var playerStats = player.get_node("Stats") as PlayerStats
		hasHitPlayer = true
		if DO_PUSH_PLAYER:
			playerStats.playerHit(BASE_DAMAGE, PUSH_FORCE, global_position)
		else:
			playerStats.playerHit(BASE_DAMAGE)
