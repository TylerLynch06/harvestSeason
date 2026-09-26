extends Control

var lastWheat = 0
var time = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if lastWheat != Economy.wheat:
		$Label.text = str(Economy.wheat)
		self.modulate.a = 1
		$Timer.start(5)
	lastWheat = Economy.wheat
	


func _on_timer_timeout() -> void:
	var tween = create_tween()
	tween.tween_property(self, "modulate:a", 0.0, 0.21)
