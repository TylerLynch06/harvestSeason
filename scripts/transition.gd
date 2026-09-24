extends CanvasLayer

@export var color_rect: ColorRect
@export var animation_player: AnimationPlayer
var isFinished = false

func _ready():
	await get_tree().physics_frame
	color_rect.visible = false
	animation_player.animation_finished.connect(fade_to_normal)
	
#func _on_animation_finished(anim_name):
	#if anim_name == "fade_to_black":
		#isFinished = true
		#animation_player.play("fade_to_normal")
	#elif anim_name == "fade_to_normal":
		#color_rect.visible = false
		
func fade_to_normal():
	isFinished = true
	animation_player.play("fade_to_normal")
	
func fade_to_black():
	color_rect.visible = true
	animation_player.play("fade_to_black")
