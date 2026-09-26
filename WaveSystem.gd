extends Node

var currentSpawnPoints = 0
var BASE_WAVE_INCREMENT	= 5
var BASE_WAVE_INCREMENT_FACTOR = 1.1
var currentWave: int = 0
##0:Autumn, 1: Winter, etc...
var currentSeasonIndex = 0
@onready var spawnNodes = get_tree().get_nodes_in_group("spawnArea")

var enemies = [preload("res://assets/animations/res_files/pumpkin_head.tscn"),
			preload("res://scenes/snowman.tscn")]
var merchant = preload("res://scenes/merchant.tscn")
var doSpawn = true
var remainingEnemyCount = 0
var WAVE_INTERMISSION_TIME = 5
var waveIntermissionTimer = WAVE_INTERMISSION_TIME
var inIntermission = false
var WAVE_FINISH_CHECK_INTERVAL = 1
var waveFinishCheckTimer = 1
var totalWaveSpawnPoints = currentSpawnPoints
var spawnPoolWeights= null
var changingSeason = false
var WAVES_BEFORE_SEASON_CHANGE = 3
var isFading = false

var MAX_ENEMIES_ON_SCREEN = 20

var transitionHandler: Transition

static var rng = RandomNumberGenerator.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	newWave()
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if !transitionHandler:
		if get_tree().get_nodes_in_group("transition"):
			transitionHandler = get_tree().get_nodes_in_group("transition")[0]
	print(isFading, changingSeason, transitionHandler.isFinished)
	if changingSeason and SeasonHandler.isNextSceneLoaded and !isFading:
		transitionHandler.fade_to_black()
		isFading = true
		
	if isFading and transitionHandler.isFinished:
		print("PLACED")
		SeasonHandler.placeScene()
		transitionHandler.fade_to_normal()
		changingSeason = false
		isFading = false
		newWave()
	
	if spawnNodes and !changingSeason:
		if currentWave % 3 == 0:
			changingSeason = true
			SeasonHandler.loadNext()
			return
		remainingEnemyCount = getRemainingEnemies()
		if currentSpawnPoints > 0 and doSpawn and remainingEnemyCount < MAX_ENEMIES_ON_SCREEN:
			spawnRandomEnemy()
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
		
func spawnRandomEnemy():
	var enemyPointValue = INF
	var enemyIndex = 0
	##Reroll until we get one we cna place
	print(spawnPoolWeights)
	while enemyPointValue > currentSpawnPoints:
		enemyIndex = rng.rand_weighted(spawnPoolWeights)
		var tempEnemy = enemies[enemyIndex].instantiate() as Enemy
		enemyPointValue = tempEnemy.SPAWN_VALUE
		tempEnemy.free()
	spawnEnemy(enemies[enemyIndex])
	
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
	merchantArrives()
	currentSpawnPoints = totalWaveSpawnPoints + BASE_WAVE_INCREMENT
	currentSpawnPoints *= BASE_WAVE_INCREMENT_FACTOR
	currentSpawnPoints = floor(currentSpawnPoints)
	totalWaveSpawnPoints = currentSpawnPoints
	currentWave += 1
	spawnPoolWeights = calculateSpawnPoolProbabilities()
	
##Each enemy should get an equal share of spawn points
func calculateSpawnPoolProbabilities():
	var weightArray = []
	for enemy in enemies:
		var tempEnemy = enemy.instantiate()
		weightArray.append((1.0/tempEnemy.SPAWN_VALUE) * tempEnemy.SPAWN_PROBABILITY_FACTOR)
		tempEnemy.free()
	return PackedFloat32Array(weightArray)

func merchantArrives():
	var merchantInstance = merchant.instantiate()
	get_tree().root.add_child.call_deferred(merchantInstance)
