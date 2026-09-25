extends Node

var currentSpawnPoints = 10
var BASE_WAVE_INCREMENT	= 7
var BASE_WAVE_INCREMENT_FACTOR = 1.1
var currentWave: int = 1
##0:Autumn, 1: Winter, etc...
var currentSeasonIndex = 0
@onready var spawnNodes = get_tree().get_nodes_in_group("spawnArea")

var enemies = [preload("res://assets/animations/res_files/pumpkin_head.tscn"),
			preload("res://scenes/snowman.tscn")]

var doSpawn = true
var remainingEnemyCount = 0
var WAVE_INTERMISSION_TIME = 5
var waveIntermissionTimer = WAVE_INTERMISSION_TIME
var inIntermission = false
var WAVE_FINISH_CHECK_INTERVAL = 1
var waveFinishCheckTimer = 1
var totalWaveSpawnPoints = currentSpawnPoints
var spawnPoolProbFunction = null

static var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	remainingEnemyCount = getRemainingEnemies()
	if currentSpawnPoints > 0 and doSpawn:
		spawnEnemy(enemies[0])
	if remainingEnemyCount > 0:
		waveFinishCheckTimer = WAVE_FINISH_CHECK_INTERVAL
	else:
		waveFinishCheckTimer -= delta
	if getRemainingEnemies() <= 0 and !inIntermission and waveFinishCheckTimer <= 0:
		inIntermission = true
		waveIntermissionTimer = WAVE_INTERMISSION_TIME
	if inIntermission:
		waveIntermissionTimer -= delta
		waveFinishCheckTimer = WAVE_FINISH_CHECK_INTERVAL
	if inIntermission and waveIntermissionTimer <= 0:
		inIntermission = false
		newWave()
	
func spawnEnemy(_enemy : PackedScene):
	var enemyInstance = _enemy.instantiate() as Enemy
	var spawnNode = getRandomSpawnNode()
	enemyInstance.global_position = spawnNode.getSpawnPoint()
	currentSpawnPoints -= enemyInstance.SPAWN_VALUE
	get_tree().root.add_child.call_deferred(enemyInstance)

func getRandomSpawnNode():
	var nodeIndex = rng.randi_range(0, 7)
	if !spawnNodes:
		return null
	return spawnNodes[nodeIndex]
	
func getRemainingEnemies():
	var allEnemies = get_tree().get_nodes_in_group("enemy")
	if allEnemies:
		return allEnemies.size()
	else:
		return 0
		
func newWave():
	currentSpawnPoints = totalWaveSpawnPoints + BASE_WAVE_INCREMENT
	currentSpawnPoints *= BASE_WAVE_INCREMENT_FACTOR
	currentSpawnPoints = floor(currentSpawnPoints)
	totalWaveSpawnPoints = currentSpawnPoints
	currentWave += 1
	
##Each enemy should get an equal share of spawn points
func calculateSpawnPoolProbabilities():
	var weightArray = []
	for enemy in enemies:
		var tempEnemy = enemy.instantiate()
		weightArray.append(tempEnemy.SPAWN_VALUE)
		tempEnemy.free()
	return PackedFloat32Array(weightArray)
	
