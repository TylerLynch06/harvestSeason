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
	"battery",
	"agricultural bank"
]
const perkBackup = [
	"whetstone",
	"shoes",
	"fishing magnet",
	"armour",
	"monsterhunter charm",
	"battery",
	"agricultural bank"
]
const merchantDialogue = [
	"Welcome to my humble travelling storefront, tiller of the soil... \n let me know if anything here strikes your fancy, eh?",
	"This weather, huh?",
	"Sometimes when I'm travelling I find strange things. Cursed things. Perhaps you could be trusted with one...",
	"I once saw a hiker wander off the road and immediately get brutally torn apart by a swarm of ravenous pumpkinheads."
	
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
		slots[i].get_node("CenterContainer/SubViewportContainer/SubViewport/Button").disabled = false
		currentStorePerks.append(perkPicked)
	$Control/PanelContainer/Label2.text = merchantDialogue.pick_random()
	if len(PerkHandler.currentPerks) >= 8:
		$Control/PanelContainer/Label2.text = "Your greed sickens me. Do not come to me again until you get rid of some of those perks."
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
		if Economy.wheat >= (((PerkHandler.perks[currentStorePerks[0]]+1)*10)+10) * priceMod * 0.5 :
			if 	PerkHandler.perks[currentStorePerks[0]]+1 < 3:
				$Store/VBoxContainer/HBoxContainer/Control2.hide()
				if PerkHandler.perks[currentStorePerks[0]] == -1:
					PerkHandler.activate(currentStorePerks[0])
				else:
					PerkHandler.upgrade(currentStorePerks[0])
				Economy.wheat -= (((PerkHandler.perks[currentStorePerks[0]]+1)*10)+10) * priceMod  * 0.5
				priceMod = priceMod*2
	else:
		if !(currentStorePerks[0] in PerkHandler.currentPerks):
			$Store/VBoxContainer/HBoxContainer/Control2.hide()
			PerkHandler.activate(currentStorePerks[0])
	reloadStore()
			

func _on_button_button_down2() -> void:
	print("BUTTONPRESS")
	$Store/VBoxContainer/HBoxContainer/Control3/CenterContainer/SubViewportContainer/SubViewport/Button.disabled = true
	if !(currentStorePerks[1] in PerkHandler.corruptedPerks):
		if Economy.wheat >= (((PerkHandler.perks[currentStorePerks[1]]+1)*10)+10) * priceMod  * 0.5:
			if 	PerkHandler.perks[currentStorePerks[1]]+1 < 3:
				$Store/VBoxContainer/HBoxContainer/Control3.hide()
				if PerkHandler.perks[currentStorePerks[1]] == -1:
					PerkHandler.activate(currentStorePerks[1])
				else:
					PerkHandler.upgrade(currentStorePerks[1])
				Economy.wheat -= (((PerkHandler.perks[currentStorePerks[1]]+1)*10)+10) * priceMod  * 0.5
				priceMod = priceMod*2
	else:
		if !(currentStorePerks[1] in PerkHandler.currentPerks):
			$Store/VBoxContainer/HBoxContainer/Control3.hide()
			PerkHandler.activate(currentStorePerks[1])
	reloadStore()

func _on_button_button_down3() -> void:
	print("BUTTONPRESS")
	$Store/VBoxContainer/HBoxContainer/Control4/CenterContainer/SubViewportContainer/SubViewport/Button.disabled = true
	if !(currentStorePerks[2] in PerkHandler.corruptedPerks):
		if Economy.wheat >= (((PerkHandler.perks[currentStorePerks[2]]+1)*10)+10) * priceMod  * 0.5:
			if 	PerkHandler.perks[currentStorePerks[2]]+1 < 3:
				$Store/VBoxContainer/HBoxContainer/Control4.hide()
				if PerkHandler.perks[currentStorePerks[2]] == -1:
					PerkHandler.activate(currentStorePerks[2])
				else:
					PerkHandler.upgrade(currentStorePerks[2])
				Economy.wheat -= (((PerkHandler.perks[currentStorePerks[2]]+1)*10)+10) * priceMod  * 0.5
				priceMod = priceMod*2
	else:
		if !(currentStorePerks[2] in PerkHandler.currentPerks):
			$Store/VBoxContainer/HBoxContainer/Control4.hide()
			PerkHandler.activate(currentStorePerks[2])
	reloadStore()
