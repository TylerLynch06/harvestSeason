extends Control
var card1 = preload("res://assets/HUD/singleCard1.png")
var card2 = preload("res://assets/HUD/singleCard2.png")
var card3 = preload("res://assets/HUD/singleCard3.png")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
	$GPUParticles2D.speed_scale = 1/0.0001

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func doublePrice():
		$Label3.text = str(int($Label3.text)*2)
		
func setTo(picked):
	if picked:
		if PerkHandler.perks[picked] < 2:
			$Label.text = PerkHandler.names[picked][PerkHandler.perks[picked]+1]
			$Label2.text = PerkHandler.descriptions[picked][PerkHandler.perks[picked]+1]
			$Label3.text = str(((PerkHandler.perks[picked]+1) * 10) + 10)
			self.modulate.a = 1
			if PerkHandler.perks[picked] == -1:
				$MarginContainer/TextureRect.texture = card1
				$GPUParticles2D.emitting = false
			if PerkHandler.perks[picked] == 0:
				$MarginContainer/TextureRect.texture = card2
				$GPUParticles2D.emitting = false
			if PerkHandler.perks[picked] == 1:
				$MarginContainer/TextureRect.texture = card3
				$GPUParticles2D.emitting = true
			if PerkHandler.perks[picked] > -1:
				$Label4.text = "<upgrades " + str(PerkHandler.names[picked][PerkHandler.perks[picked]]) + ">"
			else:
				$Label4.text = ""
		else:
			$Label.text = PerkHandler.names[picked][PerkHandler.perks[picked]]
			$Label2.text = PerkHandler.descriptions[picked][PerkHandler.perks[picked]]
			$Label3.text = str(PerkHandler.perks[picked] * 10)
			self.modulate.a = 0.5
			$Label4.text = "<upgrades " + str(PerkHandler.names[picked][PerkHandler.perks[picked]-1]) + ">"
	else:
		$Label.text = "Error Card"
		$Label2.text = "Legends tell of a card only encountered by those with errors in their game. You shouldn't see this."
