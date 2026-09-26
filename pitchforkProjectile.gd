extends PlayerProjectile

class_name PitchforkProjectille

@export var simulatedGravityStrength = 2.5
@export var mesh: Node3D
@export var angleDecreasePerSecond: float
var rangeRemaining = range
var stuckInGround = false

##Used in fishing magnet
static var REBOUND_MAX_DISTANCE = 100000
var hitEnemies = []
var reboundsRemaining = 0

func _ready():
	super._ready()
	$Camera3D.make_current()
	angleDecreasePerSecond = deg_to_rad(angleDecreasePerSecond)
	get_node("Area3D").body_entered.connect(stickInGround)
	print(PerkHandler.perks.get("fishing magnet"))
	if PerkHandler.perks.get("fishing magnet") == -1:
		reboundsRemaining = 0
	else:
		reboundsRemaining = PerkHandler.progression.get("fishing magnet")[PerkHandler.perks.get("fishing magnet")]
	print(reboundsRemaining)
	
func _physics_process(delta: float) -> void:
	super._physics_process(delta)

func setStats(_damage: float = damage, _speed_factor: float = projectile_speed, _dirVector: Vector3 = Vector3.ZERO):
	super.setStats(damage, _speed_factor, _dirVector)
	
func calcVelocity(_delta):
	if !stuckInGround:
		var _velocity = dirVector* projectile_speed + Vector3.DOWN * simulatedGravityStrength
		#global_position += dirVector
		pivot.rotation.x += angleDecreasePerSecond * _delta
		
		return _velocity
	else:
		return Vector3.ZERO
		
func hit(area: Area3D):
	if area.name == "hitbox" and area.get_parent().is_in_group("enemy") and !stuckInGround:
		var enemy = area.get_parent() as Enemy
		enemy.takeDamage(damage)
		if reboundsRemaining > 0:
			hitEnemies.append(enemy)
			rebound()
			reboundsRemaining -= 1

func rebound():
	var nearestEnemy = null
	var smallestDistance = INF
	for i in get_tree().get_nodes_in_group("enemy"):
		i = i as Enemy
		if i not in hitEnemies:
			var diffVector = i.global_position - global_position
			if diffVector.length() < REBOUND_MAX_DISTANCE and diffVector.length() < smallestDistance:
				nearestEnemy = i
				smallestDistance = diffVector.length()
	if nearestEnemy:
		dirVector = (nearestEnemy.global_position - global_position).normalized()
		pivot.rotation.y = atan2(dirVector.x,dirVector.z)
		pivot.rotation.x = PI/2
		position.y += 1
		simulatedGravityStrength = 2
		if stuckInGround:
			stuckInGround = false
		
		#if i.global_position.distance_to(self.global_position) > nearestEnemy.global_position.distance_to(self.global_position): 
			#nearestEnemy = i
		#if nearestEnemy.global_position.distance_to(self.global_position) < PerkHandler.progression["fishing magnet"][PerkHandler.perks["fishing magnet"]]:
			#dirVector = (((dirVector * 6) + (nearestEnemy.global_position - self.global_position))/6).normalized()
			#self.look_at_from_position(self.position, nearestEnemy.global_position)
			#dirVector.y = 0
		
func stickInGround(area):
	print("PROJECTILE HIT ",area.name)
	if area.is_in_group("ground"):
		stuckInGround = true
