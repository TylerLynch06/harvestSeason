extends Control
var materialShad = load("res://scenes/perk_menu_bg.gdshader")
var shaderScript1 = load("res://scenes/cardtilt.gdshader")
var shaderScript2 = load("res://cardtitl2.gdshader")
var shaderScript3 = load("res://cardTilt3.gdshader")
var UI
var redParts = load("res://redPart.tres")
var goldParts = load("res://goldPart.tres")
@onready var cardSlots = [
	$perkMenu/VBoxContainer/HBoxContainer/Control,
	$perkMenu/VBoxContainer/HBoxContainer/Control2,
	$perkMenu/VBoxContainer/HBoxContainer/Control3,
	$perkMenu/VBoxContainer/HBoxContainer/Control4,
	$perkMenu/VBoxContainer/HBoxContainer2/Control,
	$perkMenu/VBoxContainer/HBoxContainer2/Control2,
	$perkMenu/VBoxContainer/HBoxContainer2/Control3,
	$perkMenu/VBoxContainer/HBoxContainer2/Control4]
@onready var assetArray = [
	preload("res://assets/HUD/singleCard1.png"),
	preload("res://assets/HUD/singleCard2.png"),
	preload("res://assets/HUD/singleCard3.png"),
	preload("res://assets/HUD/singleCard4.png")
]
var skull = preload("res://assets/goldskull.png")
var wheat = preload("res://assets/HUD/MoneyBar.png")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	UI = get_tree().get_first_node_in_group("HUD")
	process_mode = PROCESS_MODE_ALWAYS
	var j = 0
	for i in cardSlots:
		i.get_node("CenterContainer/SubViewportContainer").hide()
		i.get_node("CenterContainer").pos = j
		if i.get_node("GPUParticles2D"):
			i.get_node("GPUParticles2D").speed_scale = 1/0.0001
		j = j + 1
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#print(PerkHandler.perks)
	print(PerkHandler.currentPerks)
	if Input.is_action_just_pressed("perk"):
		menuToggle()
	var current_time = Time.get_ticks_msec() / 1000.0
	$perkMenu/ColorRect.material.set_shader_parameter("real_time", current_time)
	$perkMenu/ColorRect2.material.set_shader_parameter("real_time", current_time)
	
func menuToggle():
	if get_tree().get_first_node_in_group("merchant") != null:
		if get_tree().get_first_node_in_group("merchant").playerHere == false:
			if $perkMenu.visible == true:
				$perkMenu.hide()
				UI.show()
				Engine.time_scale=1
			else:
				$perkMenu.show()
				UI.hide()
				Engine.time_scale = 0.0001
				refreshPerks()
	else:
			if $perkMenu.visible == true:
				$perkMenu.hide()
				UI.show()
				Engine.time_scale=1
			else:
				$perkMenu.show()
				UI.hide()
				Engine.time_scale = 0.0001
				refreshPerks()

func refreshPerks():
	PerkHandler.currentPerks = []
	for i in PerkHandler.perks:
		var thing = [i,PerkHandler.perks.get(i)]
		if thing[1] != -1:
			print(i)
			PerkHandler.currentPerks.append(thing)
	for i in range(len(PerkHandler.currentPerks)):
		loadPerk(PerkHandler.currentPerks[i], cardSlots[i])
	for i in range(8 - len(PerkHandler.currentPerks)):
		hidePerk(cardSlots[7-i])
		
func loadPerk(perkData,level):
	if perkData[0] in PerkHandler.images.keys():
		level.get_node("CenterContainer/SubViewportContainer/SubViewport/Control/TextureRect2").texture = PerkHandler.images[perkData[0]][perkData[1]]
	level.get_node("CenterContainer/SubViewportContainer").show()
	level.get_node("CenterContainer/SubViewportContainer/SubViewport/Control/MarginContainer/TextureRect").texture = assetArray[perkData[1]]
	level.get_node("CenterContainer/SubViewportContainer/SubViewport/Control/Label").text = PerkHandler.names.get(perkData[0]).get(perkData[1])
	level.get_node("CenterContainer/SubViewportContainer/SubViewport/Control/Label").size.y = 40
	level.get_node("CenterContainer/SubViewportContainer/SubViewport/Control/Label2").text = PerkHandler.descriptions.get(perkData[0]).get(perkData[1])
	level.get_node("CenterContainer/SubViewportContainer/SubViewport/Control/Button").text = str( ((PerkHandler.perks[perkData[0]] + 1)* (PerkHandler.perks[perkData[0]] + 1))*3 ) + " - To Sell"
	level.get_node("CenterContainer/SubViewportContainer/SubViewport/Control/Button").icon = wheat
	level.get_node("GPUParticles2D").process_material = goldParts
	if perkData[1] == 2:
		level.get_node("CenterContainer/SubViewportContainer").material.shader = shaderScript2
		level.get_node("GPUParticles2D").emitting = true
	else:
		level.get_node("CenterContainer/SubViewportContainer").material.shader = shaderScript1
		level.get_node("GPUParticles2D").emitting = false
	if perkData[1] == 3:
		level.get_node("CenterContainer/SubViewportContainer").material.shader = shaderScript3
		level.get_node("CenterContainer/SubViewportContainer/SubViewport/Control/Button").text = "CURSED"
		level.get_node("CenterContainer/SubViewportContainer/SubViewport/Control/Button").icon = skull
		
func hidePerk(level):
	level.get_node("CenterContainer/SubViewportContainer").hide()
	level.get_node("CenterContainer/SubViewportContainer").material.shader = shaderScript1
	level.get_node("GPUParticles2D").emitting = false
	$perkMenu/VBoxContainer/HBoxContainer/Control/GPUParticles2D.hide()
