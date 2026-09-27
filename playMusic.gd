extends Node3D

@export var bgMusic: AudioStream

func _ready():
	SoundManager.playBGMusic(bgMusic)
