extends Node

#design note: all of the bookkeeping for perks are done here, but implementation is done in the actual thing it affects.
var currentPerks = []
var perks = {
	"battery": -1, #implemented in enemyBase
	"fool bell": -1, #not implemented
	"monsterhunter charm": -1, #implemented in weaponManager
	"fishing magnet": -1, #implemented in pitchforkProjectile
	"whetstone": -1,
	"armour": -1,
	"shoes": -1
}
var progression = {
	"battery": [0.5,1,1.5],
	"monsterhunter charm": [0.1,0.2,0.3],
	"fishing magnet" : [1,2,3],
	"shoes" : [1.2,1.4,1.75]
}
var names = {
	"battery": {
		0: "9V Battery",
		1: "Car Battery",
		2: "Portable Generator"
	},
	"monsterhunter charm": {
		0: "Beast's Tooth Charm",
		1: "Monsterhunter Talisman",
		2: "Relic of the Leviathan"
	},
	"whetstone": {
		0: "Weedkiller",
		1: "3",
		2: "Herbicide"
	},
	"armour": {
		0: "Leather Jerkin",
		1: "Chainmail",
		2: "Coat of Plates"
	},
	"shoes": {
		0: "Poacher's Shoes",
		1: "Ranger Boots",
		2: "Winged Sandals"
	},
	"fishing magnet": {
		0: "fishing magnet",
		1: "electromagnet",
		2: "wire-guidance system"
	},	
}
var descriptions = {
	"battery": {
		0: "Increases stun after hit by 0.5s.",
		1: "Increases stun after hit by 1s.",
		2: "Increases stun after hit by 1.5s."
	},
	"monsterhunter charm": {
		0: "+10% damage against bosses",
		1: "+20% damage against bosses",
		2: "+30% damage against bosses"
	},
	"whetstone": {
		0: "9V Battery",
		1: "Car Battery",
		2: "Portable Generator"
	},
	"armour": {
		0: "+10% Health",
		1: "+20% Health",
		2: "+30% Health. Enemy stagger after hitting you is increased."
	},
	"shoes": {
		0: "+20% Speed",
		1: "+40% Speed",
		2: "+75% Speed"
	},
	"fishing magnet": {
		0: "fishing magnet",
		1: "electromagnet",
		2: "wire-guidance system"
	},	
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activate("battery")
	activate("whetstone")
	activate("shoes")
	upgrade("shoes")
	upgrade("shoes")
	activate("fishing magnet")
	upgrade("fishing magnet")
	upgrade("fishing magnet")
func activate(perkName):
	if perks.get(perkName) == -1:
		##Activate perks
		perks.set(perkName,0)
		if perkName == "whetstone":
			get_tree().get_nodes_in_group("player")[0].get_node("Stats").damage = 11
		if perkName == "armour":
			await get_tree().create_timer(0.01).timeout
			get_tree().get_nodes_in_group("player")[0].get_node("Stats").MAX_HEALTH = 550
			get_tree().get_nodes_in_group("player")[0].get_node("Stats").health += get_tree().get_nodes_in_group("player")[0].get_node("Stats").health*0.1
		
func upgrade(perkName):
	if perks.get(perkName) < 2:
		perks.set(perkName,perks.get(perkName)+1)
		if perkName == "whetstone":
			get_tree().get_nodes_in_group("player")[0].get_node("Stats").damage += 1
		if perkName == "armour":
			get_tree().get_nodes_in_group("player")[0].get_node("Stats").MAX_HEALTH += 50
			get_tree().get_nodes_in_group("player")[0].get_node("Stats").health += get_tree().get_nodes_in_group("player")[0].get_node("Stats").health*0.1
		
func deactivate(perkName):
	perks[perkName] = -1
	print(perkName + "DEAC")
	if perkName == "whetstone":
		get_tree().get_nodes_in_group("player")[0].get_node("Stats").damage = 10
	if perkName == "armour":
		await get_tree().create_timer(0.01).timeout
		get_tree().get_nodes_in_group("player")[0].get_node("Stats").MAX_HEALTH = 500
		if get_tree().get_nodes_in_group("player")[0].get_node("Stats").health > 500:
			get_tree().get_nodes_in_group("player")[0].get_node("Stats").health == 500
		
