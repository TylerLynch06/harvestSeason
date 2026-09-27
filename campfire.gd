extends Area3D

var playerPres = true
var stats
var eating =load("res://sounds/eating1.mp3")
var burp = [load("res://sounds/burp1.mp3"),load("res://sounds/burp2.mp3")]
@onready var audio = $AudioStreamPlayer2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	stats = get_tree().get_first_node_in_group("player").get_node("Stats")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("feed") and playerPres and $Label3D.visible:
		if stats.health < stats.MAX_HEALTH:
			$Label3D.hide()
			print("hea")
			get_tree().get_first_node_in_group("HUD").get_node("HEALTH/Bar").add_health(70)
			Economy.wheat -= 5
			if stats.health > stats.MAX_HEALTH:
				stats.health = stats.MAX_HEALTH
			audio.stream = (eating)
		else:
			audio.stream = burp.pick_random()
		audio.play()
		await get_tree().create_timer(3).timeout
		$Label3D.show()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("in")
		$Label3D.show()
		playerPres = true


func _on_body_exited(body: Node3D) -> void:
	if body.is_in_group("player"):
		playerPres = false
		$Label3D.hide()
