extends Node3D

@export var degreesPerSecond: float

func _ready():
	degreesPerSecond = deg_to_rad(degreesPerSecond)

func _process(delta: float) -> void:
	rotation.y += degreesPerSecond * delta
