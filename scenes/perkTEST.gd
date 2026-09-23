extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$MarginContainer/ColorRect.color = Color(randf_range(0,0.5),randf_range(0,0.5),randf_range(0,0.5),1)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
