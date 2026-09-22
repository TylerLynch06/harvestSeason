
extends Node

#design note: all of the bookkeeping for perks are done here, but implementation is done in the actual thing it affects.
var perks = {
	"battery": -1, #implemented in enemyBase
	"fool bell": -1, #not implemented
	"monsterhunter charm": 2, #implemented in weaponManager
	"fishing magnet": 2, #implemented in pitchforkProjectile
	"whetstone": -1
}
var progression = {
	"battery": [0.5,1,1.5],
	"monsterhunter charm": [0.1,0.2,0.3],
	"fishing magnet" : [15,25,50]
}
# Called when the node enters the scene tree for the first time.
func activate(perkName):
	if perks[perkName] != -1:
		perks[perkName] = 0
	if perkName == "whetstone":
		get_tree().get_nodes_in_group("player")[0].get_node("Stats").BASE_DAMAGE = 11
	
func upgrade(perkName):
	if perks[perkName] < 2:
		perks[perkName] += 1
	
func deactivate(perkName):
	perks[perkName] = -1
