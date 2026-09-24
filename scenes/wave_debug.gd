extends Label


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	text = "WAVE DEBUG"
	text += "\nenemies_remaining: "+str(WaveSystem.getRemainingEnemies())
	text += "\nis_intermission: "+str(WaveSystem.inIntermission)
	text += "\nintermission_time_remaining: "+str(snappedf(WaveSystem.waveIntermissionTimer,0.001))
	text += "\ntime_without_enemies: "+str(snappedf(WaveSystem.waveFinishCheckTimer,0.001))
	text += "\nwave_points "+str(WaveSystem.totalWaveSpawnPoints)
	text += "\nwave_num "+str(WaveSystem.currentWave)
