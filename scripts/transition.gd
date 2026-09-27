extends CanvasLayer
class_name Transition

@export var color_rect: ColorRect
@export var animation_player: AnimationPlayer
var isFinished = false

func _ready():
	await get_tree().physics_frame
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)
	fade_to_normal()
	
func _on_animation_finished(anim_name):
	if anim_name == "fade_to_black":
		isFinished = true
	elif anim_name == "fade_to_normal":
		isFinished = true
		
func fade_to_normal():
	isFinished = false
	animation_player.play("fade_to_normal")
	
func fade_to_black():
	isFinished = false
	color_rect.visible = true
	animation_player.play("fade_to_black")
