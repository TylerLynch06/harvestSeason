extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func doublePrice():
		$Label3.text = str(int($Label3.text)*2)
func setTo(picked):
	if PerkHandler.perks[picked] < 2:
		$Label.text = PerkHandler.names[picked][PerkHandler.perks[picked]+1]
		$Label2.text = PerkHandler.descriptions[picked][PerkHandler.perks[picked]+1]
		$Label3.text = str(((PerkHandler.perks[picked]+1) * 10) + 10)
		self.modulate.a = 1
	else:
		$Label.text = PerkHandler.names[picked][PerkHandler.perks[picked]]
		$Label2.text = PerkHandler.descriptions[picked][PerkHandler.perks[picked]]
		$Label3.text = str(PerkHandler.perks[picked] * 10)
		self.modulate.a = 0.5
