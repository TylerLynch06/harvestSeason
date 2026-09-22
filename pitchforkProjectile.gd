extends PlayerProjectile

class_name PitchforkProjectille

@export var simulatedGravityStrength = 2.5
@export var mesh: MeshInstance3D
@export var angleDecreasePerSecond: float
var rangeRemaining = range
var stuckInGround = false

func _ready():
	super._ready()
	angleDecreasePerSecond = deg_to_rad(angleDecreasePerSecond)
	get_node("Area3D").body_entered.connect(stickInGround)

func _physics_process(delta: float) -> void:
	super._physics_process(delta)

func calcVelocity(_delta):
	if !stuckInGround:
		var _velocity = dirVector*projectile_speed + Vector3.DOWN * simulatedGravityStrength
		mesh.rotation.x += angleDecreasePerSecond * _delta
		return _velocity
	else:
		return Vector3.ZERO
		
func stickInGround(area):
	print("PROJECTILE HIT ",area.name)
	if area.is_in_group("ground"):
		stuckInGround = true
