extends RangedEnemy

var scaleFactor = 1
var changeScaleFactor = false
var scaleFactorDepressionRate = 2
@export var poofParticles: GPUParticles3D

func _ready():
	super._ready()
	
func _process(delta: float):
	super._process(delta)
	if changeScaleFactor:
		scaleFactor -= scaleFactorDepressionRate*delta
		scale = scale*scaleFactor
		if scaleFactor <0.03:
			poofParticles.emitting = true
			await get_tree().create_timer(0.5).timeout
			queue_free()
	

func removeBody():
	changeScaleFactor = true
