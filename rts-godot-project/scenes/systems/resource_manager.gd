extends Node

const STARTGOLD = 100
const STARTWOOD = 100

var gold = STARTGOLD
var wood = STARTWOOD

func _update_resources():
	pass
	
func _increment_gold():
	gold += 100

func _increment_wood():
	wood += 100
