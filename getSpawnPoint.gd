extends Area3D
class_name SpawnPoint

var xSize: float
var zSize: float
@onready var spawnShape: CollisionShape3D = get_node("CollisionShape3D") 
@export var corner: Marker3D

static var SPAWN_Y_LEVEL = 0
static var rng = RandomNumberGenerator.new()

func _ready():
	xSize = spawnShape.shape.size.x
	zSize = spawnShape.shape.size.z

##Finds the x and z size of the area 3d and returns a random point within it
func getSpawnPoint():
	var x = xSize * rng.randf()
	var z = zSize * rng.randf()
	var spawnOffset = Vector3(x,0,z)
	var spawnpoint = corner.global_position + spawnOffset
	spawnpoint.y = SPAWN_Y_LEVEL
	return spawnpoint
	
