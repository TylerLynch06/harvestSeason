extends Node

#design note: all of the bookkeeping for perks are done here, but implementation is done in the actual thing it affects.
var thrown = false #this is terrible code.
var currentPerks = []
var perks = {
	"battery": -1, #implemented in enemyBase
	"fool bell": -1, #not implemented
	"monsterhunter charm": -1, #implemented in weaponManager
	"fishing magnet": -1, #implemented in pitchforkProjectile
	"whetstone": -1,
	"armour": -1,
	"shoes": -1,
	"wire guidance": -1,
	"platinum card": -1,
	"agricultural bank": -1
}
var progression = {
	"battery": [0.5,1,1.5],
	"monsterhunter charm": [0.1,0.2,0.3],
	"fishing magnet" : [1,2,4],
	"shoes" : [1.2,1.4,1.75],
	"agricultural bank" : [0.03, 0.06,0.15]
}

var corruptedPerks = [
	"wire guidance",
	"platinum card"
]
var names = {
	"battery": {
		0: "9V Battery",
		1: "Car Battery",
		2: "Portable Generator"
	},
	"monsterhunter charm": {
		0: "Beast's Tooth Charm",
		1: "Monsterhunter Talisman",
		2: "Relic of the Ancient"
	},
	"whetstone": {
		0: "Whetstone",
		1: "Blade Oil",
		2: "Death Hexes"
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
		0: "Fishing Magnet",
		1: "Electromagnet",
		2: "Graviton Generator"
	},
	"wire guidance": {
		3: "Wire Guidance System"
	},
	"platinum card": {
		3: "Merchant's Friendly Loan"
	},
	"agricultural bank": {
		0: "Farmer's Association",
		1: "Stocks and Shares",
		2: "PYEC Platinum Card"
	}
}
var images = {
	"armour": {
		0: load("res://CARD_IMAGES/armour0.jpg"),
		1: load("res://CARD_IMAGES/armour1.jpg"),
		2: load("res://CARD_IMAGES/armour2.jpg")
		},
	"battery": {
		0: load("res://CARD_IMAGES/battery0.JPG"),
		1: load("res://CARD_IMAGES/battery1.jpg"),
		2: load("res://CARD_IMAGES/battery2.png")
	},
	"shoes": {
		0: load("res://CARD_IMAGES/boots0.jpg"),
		1: load("res://CARD_IMAGES/boots1.jpg"),
		2: load("res://CARD_IMAGES/shoe3.jpg")
	},
	"monsterhunter charm": {
		0: load("res://CARD_IMAGES/charm0.jpg"),
		1: load("res://CARD_IMAGES/charm1.jpg"),
		2: load("res://CARD_IMAGES/charm2.jpg")
	},
	"agricultural bank": {
		0: load("res://CARD_IMAGES/bank0.png"),
		1: load("res://CARD_IMAGES/bank1.png"),
		2: load("res://CARD_IMAGES/bank2.png")
	},
	"platinum card": {
		3: load("res://CARD_IMAGES/loan3.jpg")
	},
	"wire guidance": {
		3: load("res://CARD_IMAGES/wire3.png")
	},
	"fishing magnet": {
		0: load("res://CARD_IMAGES/magnet0.jpg"),
		1:load("res://CARD_IMAGES/magnet1.jpg"),
		2:load("res://CARD_IMAGES/magnet2.jpg"),
	},
	"whetstone": {
		0: load("res://CARD_IMAGES/stone0.jpg"),
		1: load("res://CARD_IMAGES/stone1.jpg"),
		2: load("res://CARD_IMAGES/stone2.png")
	}
}
var descriptions = {
	"battery": {
		0: "Increases stun after hit by 0.5s.",
		1: "Increases stun after hit by 1s.",
		2: "Increases stun after hit by 1.5s."
	},
	"monsterhunter charm": {
		0: "+20% damage against elites",
		1: "+30% damage against elites",
		2: "+75% damage against elites"
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
		0: "Pitchfork rebounds once after a hit",
		1: "Pitchfork rebounds twice after a hit",
		2: "Pitchfork rebounds four times after a hit"
	},
	"wire guidance": {
		3: "Infinite Pitchfork Rebounding, but your camera follows it for 5 seconds."
	},
	"platinum card": {
		3: "Gain 500 Wheat, but enemies stop dropping wheat."
	},
	"agricultural bank" : {
		0: "Gain 3% of your wheat total after every round",
		1: "Gain 6% of your wheat total after every round",
		2: "Gain 15% of your wheat total after every round"
	}
}
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass
	
func resetPerks():
	thrown = false #this is terrible code.
	currentPerks = []
	perks = {
		"battery": -1, #implemented in enemyBase
		"fool bell": -1, #not implemented
		"monsterhunter charm": -1, #implemented in weaponManager
		"fishing magnet": -1, #implemented in pitchforkProjectile
		"whetstone": -1,
		"armour": -1,
		"shoes": -1,
		"wire guidance": -1,
		"platinum card": -1,
		"agricultural bank": -1
	}
	progression = {
		"battery": [0.5,1,1.5],
		"monsterhunter charm": [0.1,0.2,0.3],
		"fishing magnet" : [1,2,4],
		"shoes" : [1.2,1.4,1.75],
		"agricultural bank" : [0.03, 0.06,0.15]
	}

	corruptedPerks = [
		"wire guidance",
		"platinum card"
	]
	names = {
		"battery": {
			0: "9V Battery",
			1: "Car Battery",
			2: "Portable Generator"
		},
		"monsterhunter charm": {
			0: "Beast's Tooth Charm",
			1: "Monsterhunter Talisman",
			2: "Relic of the Ancient"
		},
		"whetstone": {
			0: "Whetstone",
			1: "Blade Oil",
			2: "Death Hexes"
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
			0: "Fishing Magnet",
			1: "Electromagnet",
			2: "Graviton Generator"
		},
		"wire guidance": {
			3: "Wire Guidance System"
		},
		"platinum card": {
			3: "Merchant's Friendly Loan"
		},
		"agricultural bank": {
			0: "Farmer's Association",
			1: "Stocks and Shares",
			2: "PYEC Platinum Card"
		}
	}
	images = {
		"armour": {
			0: load("res://CARD_IMAGES/armour0.jpg"),
			1: load("res://CARD_IMAGES/armour1.jpg"),
			2: load("res://CARD_IMAGES/armour2.jpg")
			},
		"battery": {
			0: load("res://CARD_IMAGES/battery0.JPG"),
			1: load("res://CARD_IMAGES/battery1.jpg"),
			2: load("res://CARD_IMAGES/battery2.png")
		},
		"shoes": {
			0: load("res://CARD_IMAGES/boots0.jpg"),
			1: load("res://CARD_IMAGES/boots1.jpg"),
			2: load("res://CARD_IMAGES/shoe3.jpg")
		},
		"monsterhunter charm": {
			0: load("res://CARD_IMAGES/charm0.jpg"),
			1: load("res://CARD_IMAGES/charm1.jpg"),
			2: load("res://CARD_IMAGES/charm2.jpg")
		},
		"agricultural bank": {
			0: load("res://CARD_IMAGES/bank0.png"),
			1: load("res://CARD_IMAGES/bank1.png"),
			2: load("res://CARD_IMAGES/bank2.png")
		},
		"platinum card": {
			3: load("res://CARD_IMAGES/loan3.jpg")
		},
		"wire guidance": {
			3: load("res://CARD_IMAGES/wire3.png")
		},
		"fishing magnet": {
			0: load("res://CARD_IMAGES/magnet0.jpg"),
			1:load("res://CARD_IMAGES/magnet1.jpg"),
			2:load("res://CARD_IMAGES/magnet2.jpg"),
		},
		"whetstone": {
			0: load("res://CARD_IMAGES/stone0.jpg"),
			1: load("res://CARD_IMAGES/stone1.jpg"),
			2: load("res://CARD_IMAGES/stone2.png")
		}
	}
	descriptions = {
		"battery": {
			0: "Increases stun after hit by 0.5s.",
			1: "Increases stun after hit by 1s.",
			2: "Increases stun after hit by 1.5s."
		},
		"monsterhunter charm": {
			0: "+20% damage against elites",
			1: "+30% damage against elites",
			2: "+75% damage against elites"
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
			0: "Pitchfork rebounds once after a hit",
			1: "Pitchfork rebounds twice after a hit",
			2: "Pitchfork rebounds four times after a hit"
		},
		"wire guidance": {
			3: "Infinite Pitchfork Rebounding, but your camera follows it for 5 seconds."
		},
		"platinum card": {
			3: "Gain 500 Wheat, but enemies stop dropping wheat."
		},
		"agricultural bank" : {
			0: "Gain 3% of your wheat total after every round",
			1: "Gain 6% of your wheat total after every round",
			2: "Gain 15% of your wheat total after every round"
		}
	}
func activate(perkName):
	if perks.get(perkName) == -1 and  !(perkName in corruptedPerks):
		##Activate perks
		perks.set(perkName,0)
		if perkName == "whetstone":
			get_tree().get_nodes_in_group("player")[0].get_node("Stats").damage = 11
		if perkName == "armour":
			await get_tree().create_timer(0.01).timeout
			get_tree().get_nodes_in_group("player")[0].get_node("Stats").MAX_HEALTH = 550
			get_tree().get_nodes_in_group("player")[0].get_node("Stats").health += get_tree().get_nodes_in_group("player")[0].get_node("Stats").health*0.1
	elif perkName in corruptedPerks:
			perks.set(perkName, 3)
			if perkName == "platinum card":
				Economy.wheat += 500
func upgrade(perkName):
	if perks.get(perkName) < 2 and !(perkName in corruptedPerks):
		perks.set(perkName,perks.get(perkName)+1)
		if perkName == "whetstone":
			get_tree().get_nodes_in_group("player")[0].get_node("Stats").damage += 1
		if perkName == "armour":
			get_tree().get_nodes_in_group("HUD")[0].get_node("HEALTH/Bar").add_max_health(50)
			get_tree().get_nodes_in_group("HUD")[0].get_node("HEALTH/Bar").add_health(50)
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
		
