extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "Press F3 to load next scene\n"
	text += "\nSCENE LOADER"
	text += "\nis_loading: " + str(SeasonHandler.loadingScene)
	text += "\nloading_progress: " + str(snappedf(SeasonHandler.loadingProgress,0.01))
	text += "\nnext_to_load: " + str(SeasonHandler.nextToLoad)
	text += "\ntime_taken: " + str(snappedf(SeasonHandler.timeSinceLoadStart,0.001))
