extends Node

var currentSpawnPoints = 20
var currentWave: int
##0:Autumn, 1: Winter, etc...
var currentSeasonIndex = 0
@onready var spawnNodes = get_tree().get_nodes_in_group("spawnArea")
var enemy: PackedScene = preload("res://assets/animations/res_files/pumpkin_head.tscn")

var remainingEnemyCount = 0

static var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print(spawnNodes)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if currentSpawnPoints > 0:
		spawnEnemy(enemy)
	
func spawnEnemy(_enemy : PackedScene):
	var enemyInstance = _enemy.instantiate() as Enemy
	var spawnNode = getRandomSpawnNode()
	enemyInstance.global_position = spawnNode.getSpawnPoint()
	currentSpawnPoints -= enemyInstance.SPAWN_VALUE
	get_tree().root.add_child.call_deferred(enemyInstance)

func getRandomSpawnNode():
	var nodeIndex = rng.randi_range(0, 3)
	return spawnNodes[nodeIndex]
	
func getRemainingEnemies():
	var allEnemies = get_tree().get_nodes_in_group("enemy")
	if allEnemies:
		remainingEnemyCount = allEnemies.size()
