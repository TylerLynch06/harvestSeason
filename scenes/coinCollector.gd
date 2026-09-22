extends Area3D

var things
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("wheat"):
		body.collect()


func _on_timer_timeout() -> void:
	things = get_overlapping_bodies()
	for i in things:
		if i.is_in_group("wheat"):
			i.collect()
