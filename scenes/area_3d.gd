extends Area3D
var playerHere = false
var MerchantUI 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	MerchantUI = get_tree().get_first_node_in_group("merchantUI")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("perk") and playerHere:
		if !MerchantUI.visible:
			MerchantUI.show()
			MerchantUI.slideAcross()
			Engine.time_scale = 0.0001
		else:
			MerchantUI.hide()
			MerchantUI.killTween()
			Engine.time_scale = 1



func _on_area_entered(area: Node3D) -> void:
	print(area)
	if area.is_in_group("hurtbox"):
		playerHere = true


func _on_area_exited(area: Node3D) -> void:
	if area.is_in_group("hurtbox"):
		playerHere = false
		MerchantUI.hide()
		Engine.time_scale = 1
