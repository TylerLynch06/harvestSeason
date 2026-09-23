extends PlayerProjectile

class_name PitchforkProjectille

@export var simulatedGravityStrength = 2.5
@export var mesh: MeshInstance3D
@export var angleDecreasePerSecond: float
var rangeRemaining = range
var stuckInGround = false
var timerPopped = false
func _ready():
	super._ready()
	angleDecreasePerSecond = deg_to_rad(angleDecreasePerSecond)
	get_node("Area3D").body_entered.connect(stickInGround)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)
func calcVelocity(_delta):
	if !stuckInGround:
		if PerkHandler.perks["fishing magnet"] != -1:
			simulatedGravityStrength = 1.25
			projectile_speed = 0.5
			if timerPopped == true:
				var nearestEnemy = self
				for i in get_tree().get_nodes_in_group("enemy"):
					if i.global_position.distance_to(self.global_position) > nearestEnemy.global_position.distance_to(self.global_position): 
						nearestEnemy = i
					if nearestEnemy.global_position.distance_to(self.global_position) < PerkHandler.progression["fishing magnet"][PerkHandler.perks["fishing magnet"]]:
						dirVector = (((dirVector * 6) + (nearestEnemy.global_position - self.global_position))/6).normalized()
						self.look_at_from_position(self.position, nearestEnemy.global_position)
						dirVector.y = 0
		
		var _velocity = dirVector*projectile_speed + Vector3.DOWN * simulatedGravityStrength
		global_position += dirVector
		mesh.rotation.x += angleDecreasePerSecond * _delta
		return _velocity
	else:
		return Vector3.ZERO
		
func stickInGround(area):
	print("PROJECTILE HIT ",area.name)
	if area.is_in_group("ground"):
		stuckInGround = true


func _on_timer_timeout() -> void:
	timerPopped = true
