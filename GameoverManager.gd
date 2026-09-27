extends Node

var isInMainMenu =  true
var isGameover = false
var preparingGameReset = false
var transitionHandler: Transition
@export var mainScene = preload("res://enemySpawnNodes.tscn")
var gameoverScene = preload("res://scenes/gameoverScene.tscn")
var gameoverInstance

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !transitionHandler and get_tree().get_nodes_in_group("transition"):
		transitionHandler = get_tree().get_nodes_in_group("transition")[0] 
		
	if isInMainMenu:
		if Input.is_action_just_pressed("space"):
			isInMainMenu = false
			print("loading game")
			restartGame()		
		
	if isGameover:
		if !preparingGameReset:
			prepareGameReset()
			
		if Input.is_action_just_pressed("R"):
			restartGame()

func gameover():
	isGameover = true

func prepareGameReset():
	preparingGameReset = true
	await get_tree().create_timer(1).timeout
	transitionHandler.fade_to_black()
	placeGameoverScene()

func restartGame():
	enemyWipe()
	merchantWipe()
	isGameover = false
	preparingGameReset = false
	var target_scene = mainScene
	get_tree().change_scene_to_packed(target_scene)
	while get_tree().current_scene == null or not get_tree().current_scene.scene_file_path == target_scene.resource_path:
		await get_tree().process_frame
	if gameoverInstance:
		gameoverInstance.free()
	SeasonHandler.reset()
	WaveSystem.reset()
	##RESET PERKS
	
func enemyWipe():
	for enemy in get_tree().get_nodes_in_group("enemy"):
		enemy.queue_free()
	
func merchantWipe():
	for merchant in get_tree().get_nodes_in_group("merchant"):
		merchant.queue_free()

func placeGameoverScene():
	gameoverInstance = gameoverScene.instantiate() as Control
	get_tree().root.add_child(gameoverInstance)
	
