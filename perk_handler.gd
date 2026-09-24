extends Node

#design note: all of the bookkeeping for perks are done here, but implementation is done in the actual thing it affects.
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
	"fishing magnet" : [1,2,3]
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	activate("fishing magnet")
	activate("armour")
	#upgrade("fishing magnet")

func activate(perkName):
	if perks.get(perkName) == -1:
		##Activate perks
		perks.set(perkName,0)
	if perkName == "whetstone":
		get_tree().get_nodes_in_group("player")[0].get_node("Stats").damage = 11
	if perkName == "armour":
		await get_tree().create_timer(0.01).timeout
		get_tree().get_nodes_in_group("player")[0].get_node("Stats").MAX_HEALTH = 200
		get_tree().get_nodes_in_group("player")[0].get_node("Stats").health += get_tree().get_nodes_in_group("player")[0].get_node("Stats").health*0.1
	
func upgrade(perkName):
	if perks.get(perkName) < 2:
		perks.set(perkName,perks.get(perkName)+1)
	
func deactivate(perkName):
	perks[perkName] = -1
