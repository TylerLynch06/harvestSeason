extends Projectile

func _physics_process(delta: float) -> void:
	if yLock:
		velocity.y = 0
	var playerLoc = player.global_position
	velocity = (playerLoc - self.global_position).normalized() * projectile_speed
	self.position += velocity * delta
	
