extends Control

var tween
var current_time
var last_time
var priceMod = 1
@onready var perksToChoose = [
	"shoes",
	"fishing magnet",
	"armour",
	"monsterhunter charm",
	"battery",
	"agricultural bank"
]
const perkBackup = [
	"shoes",
	"fishing magnet",
	"armour",
	"monsterhunter charm",
	"battery",
	"agricultural bank"
]
const merchantDialogue = [
	"Welcome to my humble travelling storefront, tiller of the soil... \n Let me know if anything here strikes your fancy, eh?",
	"This weather, huh?",
	"Sometimes when I'm travelling I find strange things. Cursed things. Perhaps you could be trusted with one...",
	"I once saw a hiker wander off the road and immediately get brutally torn apart by a swarm of ravenous pumpkinheads.",
	"How's the harvest?",
	"All the other farms are harvesting nothing at all, but you have so much.",
	"I hope you're enjoying this Harvest Season, farmer.",
	"Do you think the world is better served by discord or harmony? If you ask me, a balance of both is the best.",
	"One day I'll work out how to put a bridle on a Pumpking, and then I'll be unstoppable.",
	"Looking for anything in particular? No? I'll just bring whatever I find then"
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
		if randi_range(1,10) == 10:
			perkPicked = PerkHandler.corruptedPerks.pick_random()
		slots[i].get_node("CenterContainer/SubViewportContainer/SubViewport/Control").setTo(perkPicked, priceMod)
		slots[i].show()
		slots[i].get_node("CenterContainer/SubViewportContainer/SubViewport/Control").show()
		slots[i].get_node("CenterContainer/SubViewportContainer/SubViewport/Button").disabled = false
		currentStorePerks.append(perkPicked)
		#print(currentStorePerks)
	#print(currentStorePerks)
	#print(perksToChoose)
	#print(perkBackup)
	
	$Control/PanelContainer/Label2.text = merchantDialogue.pick_random()
	if $Control/PanelContainer/Label2.text == "Your greed sickens me. Do not come to me again until you get rid of some of those perks." and len(PerkHandler.currentPerks) < 8:
		$Control/PanelContainer/Label2.text = "Good."
	if len(PerkHandler.currentPerks) >= 8:
		$Control/PanelContainer/Label2.text = "Your greed sickens me. Do not come to me again until you get rid of some of those perks."
		$Store/VBoxContainer/HBoxContainer/Control2/CenterContainer/SubViewportContainer/SubViewport/Control.hide()
		$Store/VBoxContainer/HBoxContainer/Control3/CenterContainer/SubViewportContainer/SubViewport/Control.hide()
		$Store/VBoxContainer/HBoxContainer/Control4/CenterContainer/SubViewportContainer/SubViewport/Control.hide()
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
	PerkHandler.currentPerks = []
	for i in PerkHandler.perks:
		var thing = [i,PerkHandler.perks.get(i)]
		if thing[1] != -1:
			print(i)
			PerkHandler.currentPerks.append(thing)
	for i in range(3):
		slots[i].get_node("CenterContainer/SubViewportContainer/SubViewport/Control").setTo(currentStorePerks[i], priceMod)


func _on_button_button_down1() -> void:
	print("BUTTONPRESS")
	$Store/VBoxContainer/HBoxContainer/Control2/CenterContainer/SubViewportContainer/SubViewport/Button.disabled = true
	if !(currentStorePerks[0] in PerkHandler.corruptedPerks):
		if Economy.wheat >= (((PerkHandler.perks[currentStorePerks[0]]+1)*10)+10) * priceMod :
			if 	PerkHandler.perks[currentStorePerks[0]]+1 < 3:
				Economy.wheat -= (((PerkHandler.perks[currentStorePerks[0]]+1)*10)+10) * priceMod
				if PerkHandler.perks[currentStorePerks[0]] == -1:
					PerkHandler.activate(currentStorePerks[0])
				else:
					PerkHandler.upgrade(currentStorePerks[0])
				priceMod = priceMod*2
				reloadStore()
				$Store/VBoxContainer/HBoxContainer/Control2/CenterContainer/SubViewportContainer/SubViewport/Control.hide()
	else:
		if PerkHandler.perks[currentStorePerks[2]] != 3:
			PerkHandler.activate(currentStorePerks[0])
			reloadStore()
			$Store/VBoxContainer/HBoxContainer/Control2/CenterContainer/SubViewportContainer/SubViewport/Control.hide()
			

func _on_button_button_down2() -> void:
	print("BUTTONPRESS")
	$Store/VBoxContainer/HBoxContainer/Control3/CenterContainer/SubViewportContainer/SubViewport/Button.disabled = true
	if !(currentStorePerks[1] in PerkHandler.corruptedPerks):
		if Economy.wheat >= (((PerkHandler.perks[currentStorePerks[1]]+1)*10)+10) * priceMod:
			if 	PerkHandler.perks[currentStorePerks[1]]+1 < 3:
				Economy.wheat -= (((PerkHandler.perks[currentStorePerks[1]]+1)*10)+10) * priceMod
				if PerkHandler.perks[currentStorePerks[1]] == -1:
					PerkHandler.activate(currentStorePerks[1])
				else:
					PerkHandler.upgrade(currentStorePerks[1])
				priceMod = priceMod*2
				reloadStore()
				$Store/VBoxContainer/HBoxContainer/Control3/CenterContainer/SubViewportContainer/SubViewport/Control.hide()
	else:
		if PerkHandler.perks[currentStorePerks[2]] != 3:
			PerkHandler.activate(currentStorePerks[1])
			reloadStore()
			$Store/VBoxContainer/HBoxContainer/Control3/CenterContainer/SubViewportContainer/SubViewport/Control.hide()
func _on_button_button_down3() -> void:
	print("BUTTONPRESS")
	$Store/VBoxContainer/HBoxContainer/Control4/CenterContainer/SubViewportContainer/SubViewport/Button.disabled = true
	if !(currentStorePerks[2] in PerkHandler.corruptedPerks):
		if Economy.wheat >= (((PerkHandler.perks[currentStorePerks[2]]+1)*10)+10) * priceMod:
			if 	PerkHandler.perks[currentStorePerks[2]]+1 < 3:
				Economy.wheat -= (((PerkHandler.perks[currentStorePerks[2]]+1)*10)+10) * priceMod
				if PerkHandler.perks[currentStorePerks[2]] == -1:
					PerkHandler.activate(currentStorePerks[2])
				else:
					PerkHandler.upgrade(currentStorePerks[2])
				priceMod = priceMod*2
				reloadStore()
				$Store/VBoxContainer/HBoxContainer/Control4/CenterContainer/SubViewportContainer/SubViewport/Control.hide()
	else:
		if PerkHandler.perks[currentStorePerks[2]] != 3:
			PerkHandler.activate(currentStorePerks[2])
			reloadStore()
			$Store/VBoxContainer/HBoxContainer/Control4/CenterContainer/SubViewportContainer/SubViewport/Control.hide()
