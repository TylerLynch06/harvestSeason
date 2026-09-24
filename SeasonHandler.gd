extends Node

##Handles the intermissions between seasons

var seasonSequence = ["autumn","winter","spring","summer"]
var isNextSceneLoaded = false
var currentSeasonIndex = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func loadNext():
	var path = getNextPath()
	loader = ResourceLoader.load_interactive(path)
	pass

func getNextPath():
	return ""
