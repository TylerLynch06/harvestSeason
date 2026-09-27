extends Control

var tween
var current_time
var last_time
var priceMod = 1
@onready var perksToChoose = [
	"whetstone",
	"shoes",
	"fishing magnet",
	"armour",
	"monsterhunter charm",
	"battery"
]
const perkBackup = [
	"whetstone",
	"shoes",
	"fishing magnet",
	"armour",
	"monsterhunter charm",
	"battery"
]
@onready var currentStorePerks = []
@onready var slots = [
	$Store/VBoxContainer/HBoxContainer/Control2,
	$Store/VBoxContainer/HBoxContainer/Control3,
	$Store/VBoxContainer/HBoxContainer/Control4
]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	await get_tree().create_timer(0.45).timeout


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func generateNewStore():
	perksToChoose = perkBackup
	priceMod = 1
	currentStorePerks = []
	for i in range(3):
		var perkPicked = perksToChoose.pick_random()
		perksToChoose.remove_at(perksToChoose.find(perkPicked))
		slots[i].get_node("CenterContainer/SubViewportContainer/SubViewport/Control").setTo(perkPicked)
		slots[i].show()
		currentStorePerks.append(perkPicked)
		#print(currentStorePerks)
	#print(currentStorePerks)
	#print(perksToChoose)
	#print(perkBackup)
	
func slideAcross():
	$Store.global_position = Vector2(-1100,100)
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_CUBIC)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property($Store, "global_position", Vector2(175,100), 1.0)
	tween.set_ignore_time_scale(true)
	
func killTween():
	tween = create_tween()
	tween.kill()
	
func reloadStore():
	for i in range(len(currentStorePerks)):
		slots[i].get_node("CenterContainer/SubViewportContainer/SubViewport/Control").setTo(currentStorePerks[i])


func _on_button_button_down1() -> void:
	print((((PerkHandler.perks[currentStorePerks[2]]+1)*10)+10) * priceMod)
	if Economy.wheat >= (((PerkHandler.perks[currentStorePerks[0]]+1)*10)+10) * priceMod:
		if 	PerkHandler.perks[currentStorePerks[0]]+1 < 3:
			$Store/VBoxContainer/HBoxContainer/Control2.hide()
			$Store/VBoxContainer/HBoxContainer/Control3/CenterContainer/SubViewportContainer/SubViewport/Control.doublePrice()
			$Store/VBoxContainer/HBoxContainer/Control4/CenterContainer/SubViewportContainer/SubViewport/Control.doublePrice()
			priceMod = priceMod*2
			if PerkHandler.perks[currentStorePerks[0]] == -1:
				PerkHandler.activate(currentStorePerks[0])
				#print((((PerkHandler.perks[currentStorePerks[0]]+1)*10)+10) * priceMod)
				Economy.wheat -= (((PerkHandler.perks[currentStorePerks[0]]+1)*10)+10) * priceMod
				priceMod = priceMod*2
			else:
				PerkHandler.upgrade(currentStorePerks[0])
				Economy.wheat -= (((PerkHandler.perks[currentStorePerks[0]]+1)*10)+10) * priceMod
	reloadStore()
			

func _on_button_button_down2() -> void:
	print((((PerkHandler.perks[currentStorePerks[2]]+1)*10)+10) * priceMod)
	if Economy.wheat >= (((PerkHandler.perks[currentStorePerks[1]]+1)*10)+10) * priceMod:
		if 	PerkHandler.perks[currentStorePerks[1]]+1 < 3:
			$Store/VBoxContainer/HBoxContainer/Control3.hide()
			$Store/VBoxContainer/HBoxContainer/Control2/CenterContainer/SubViewportContainer/SubViewport/Control.doublePrice()
			$Store/VBoxContainer/HBoxContainer/Control4/CenterContainer/SubViewportContainer/SubViewport/Control.doublePrice()
			priceMod = priceMod*2
			if PerkHandler.perks[currentStorePerks[1]] == -1:
				PerkHandler.activate(currentStorePerks[1])
				Economy.wheat -= (((PerkHandler.perks[currentStorePerks[1]]+1)*10)+10) * priceMod
			else:
				PerkHandler.upgrade(currentStorePerks[1])
				Economy.wheat -= (((PerkHandler.perks[currentStorePerks[1]]+1)*10)+10) * priceMod
	reloadStore()

func _on_button_button_down3() -> void:
	print((((PerkHandler.perks[currentStorePerks[2]]+1)*10)+10) * priceMod)
	if Economy.wheat >= (((PerkHandler.perks[currentStorePerks[2]]+1)*10)+10) * priceMod:
		if 	PerkHandler.perks[currentStorePerks[2]]+1 < 3:
			$Store/VBoxContainer/HBoxContainer/Control2/CenterContainer/SubViewportContainer/SubViewport/Control.doublePrice()
			$Store/VBoxContainer/HBoxContainer/Control3/CenterContainer/SubViewportContainer/SubViewport/Control.doublePrice()
			priceMod = priceMod*2
			$Store/VBoxContainer/HBoxContainer/Control4.hide()
			if PerkHandler.perks[currentStorePerks[2]] == -1:
				PerkHandler.activate(currentStorePerks[2])
				Economy.wheat -= (((PerkHandler.perks[currentStorePerks[2]]+1)*10)+10) * priceMod
			else:
				PerkHandler.upgrade(currentStorePerks[2])
				Economy.wheat -= (((PerkHandler.perks[currentStorePerks[2]]+1)*10)+10) * priceMod
	reloadStore()
