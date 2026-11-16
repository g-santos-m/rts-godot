class_name ResourceManager
extends Node

signal resources_updated(resources: Dictionary)

@export var starting_max_population: int = 10
@export var starting_gold: int = 100
@export var starting_wood: int = 100

var _population: int = 0
var _max_population: int = starting_max_population
var _gold: int = starting_gold
var _wood: int = starting_wood


func increment_gold():
	_gold += 10
	resources_updated.emit(get_resources_dict())


func increment_wood():
	_wood += 10
	resources_updated.emit(get_resources_dict())


func increment_max_population() -> void:
	_max_population += 5
	resources_updated.emit(get_resources_dict())


func decrement_max_population() -> void:
	_max_population -= 5
	resources_updated.emit(get_resources_dict())


func decrement_population() -> void:
	_population -= 1
	resources_updated.emit(get_resources_dict())


func decrement_resources(resources_needed: Array[int], is_unit: bool) -> bool:
	if (
			_gold >= resources_needed[0]
			and _wood >= resources_needed[1]
			and (!is_unit or _population < _max_population)
	):
		_gold -= resources_needed[0]
		_wood -= resources_needed[1]
		if is_unit:
			_population += 1
		resources_updated.emit(get_resources_dict())
		return true
	else:
		return false


func get_resources_dict() -> Dictionary:
	return {
		"population": _population,
		"max_population": _max_population,
		"gold": _gold,
		"wood": _wood,
	}
