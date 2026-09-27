extends Node

##Handles the intermissions between seasons

@onready var seasonDictPath = {
	"autumn":"res://environment/TheSeasonEnvironments/autumn.tscn",
	"winter":"res://environment/TheSeasonEnvironments/winter.tscn",
	"spring":"res://environment/TheSeasonEnvironments/spring.tscn",
	"summer":"res://environment/TheSeasonEnvironments/summer.tscn"}
	
var seasonSequence = ["autumn","winter","spring","summer"]	
var isNextSceneLoaded = false
var loadingProgress = 0.0
var loadingScene = false
var currentSceneIndex = 1
var progress = []
var timeSinceLoadStart = 0.0
var nextToLoad = seasonSequence[currentSceneIndex]

#@onready var transition = get_tree().get_nodes_in_group("transition")[0] 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("loadScene"):
		loadNext()
	if loadingScene:
		timeSinceLoadStart += delta
		var status = ResourceLoader.load_threaded_get_status(getNextPath(), progress)
		match status:
			ResourceLoader.THREAD_LOAD_IN_PROGRESS:
				loadingProgress = progress[0]
			ResourceLoader.THREAD_LOAD_LOADED:
				isNextSceneLoaded = true
	
			
func loadNext():
	loadingScene = true
	timeSinceLoadStart = 0.0
	var newLevel = ResourceLoader.load_threaded_request(getNextPath(),"PackedScene", false)

func getNextPath():
	return seasonDictPath.get(seasonSequence[currentSceneIndex])
	
func placeScene():
	##Destrying old scene
	var currentLevel = null
	if get_tree().get_nodes_in_group("level"):
		currentLevel = get_tree().get_nodes_in_group("level")[0] 
	var seasonScene = ResourceLoader.load_threaded_get(getNextPath())
	var seasonInstance = seasonScene.instantiate()
	add_child(seasonInstance)
	loadingScene = false
	currentSceneIndex = (currentSceneIndex + 1) % 4
	nextToLoad = seasonSequence[currentSceneIndex]
	
	if currentLevel:
		currentLevel.queue_free()
	if PerkHandler.perks["pesticide"] == 3:
		Economy.wheat = Economy.wheat / 2
	

func reset():
	currentSceneIndex = 1
	nextToLoad = seasonSequence[currentSceneIndex]
	isNextSceneLoaded = false
	loadingScene = false
	timeSinceLoadStart = 0.0

		#get_tree().get_root()
	get_tree().get_first_node_in_group("merchantUI").generateNewStore()
