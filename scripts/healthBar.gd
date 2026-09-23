extends TextureProgressBar

@onready var timer: Timer = $Timer
@onready var damage: TextureProgressBar = $Damage

var health: float = 100.0 : set = _set_health

func init_health(start_health: float) -> void:
	max_value = start_health
	damage.max_value = start_health
	health = start_health
	damage.value = start_health

func _set_health(new_health: float) -> void:
	var prev_health := health
	health = clamp(new_health, 0.0, max_value)
	value = health

	if health < prev_health:
		timer.start()           # took damage: hold the damage bar, then catch up
	else:
		damage.value = health   # healed: damage bar snaps up immediately

func _on_timer_timeout() -> void:
	var tween := create_tween()
	tween.tween_property(damage, "value", health, 0.3).set_ease(Tween.EASE_OUT)
