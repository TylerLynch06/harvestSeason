#extends Stats
extends Node3D
class_name EnemyMovePool

static var rng = RandomNumberGenerator.new()

##TODO: consider making moves an objects rather than a state, this will allow passing move specific cooldown timers etc.

##Each entry is as [moveWeight, moveState]
##Change the move names and their weights obviously
@export var moveWeightFunction = [[1,"CHANGE_ME"],[2,["CHANGE_ME_TOO"]]]
var movePMF: PackedFloat32Array

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var weightArray = []
	for move in moveWeightFunction:
		weightArray.append(move[0])
	movePMF = PackedFloat32Array(weightArray)

func rollNextMove():
	var rolledIndex = rng.rand_weighted(movePMF)
	return moveWeightFunction[rolledIndex][1]
	
