extends Node

var path = "res://SFX/chimimin-a-goofy-and-silly-medieval-song-161310.mp3"
var file = FileAccess.open(path, FileAccess.READ)
var playingBgMusic = false

func playSfx(stream: AudioStream, position: Vector2 = Vector2.ZERO, volume : float = 0):
	var player = AudioStreamPlayer2D.new()
	player.stream = stream
	player.global_position = position
	get_tree().current_scene.add_child(player)
	##Create and then detroy a player
	player.volume_db = volume
	player.play()
	player.finished.connect(player.queue_free)

func playBGMusic(stream: AudioStream):
	playingBgMusic = true
	playSfx(stream,Vector2.ZERO,-0.5)
