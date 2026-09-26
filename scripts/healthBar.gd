extends TextureProgressBar

@onready var timer: Timer = $Timer
@onready var DamageBar: TextureProgressBar = $DamageBar

var stats


func _ready() -> void:
	stats = get_tree().get_first_node_in_group("player").get_node("Stats")

	max_value = stats.MAX_HEALTH
	DamageBar.max_value = stats.MAX_HEALTH

	value = stats.health -1
	DamageBar.value = stats.health

	await get_tree().create_timer(0.45).timeout

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("perk"):
		if visible == true:
			self.hide()
		if visible == false:
			self.show()
func damage_health(damage: float) -> void:
	print("Health: ", stats.health)
	stats.health -= damage
	# Main bar immediately shows current health
	value = stats.health

	# Start the timer so the damage bar follows afterward
	timer.start()


func _on_timer_timeout() -> void:
	var tween := create_tween()
	tween.tween_property(DamageBar, "value", stats.health, 0.3)\
		.set_ease(Tween.EASE_OUT)
