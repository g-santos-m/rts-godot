extends Node

signal resources_updated(resources: Dictionary)

const STARTING_MAX_POPULATION = 10
const STARTGOLD = 100
const STARTWOOD = 100

var population = 0
var max_population = STARTING_MAX_POPULATION
var gold = STARTGOLD
var wood = STARTWOOD

func _update_resources():
	pass

func _increment_gold():
	gold += 100
	print("Gold: " + str(gold))

	resources_updated.emit(get_resources_dict())

func _increment_wood():
	wood += 100
	print("Wood: " + str(wood))

	resources_updated.emit(get_resources_dict())

func get_resources_dict() -> Dictionary:
	return {
		"population": population,
		"max_population": max_population,
		"gold": gold,
		"wood": wood,
	}
