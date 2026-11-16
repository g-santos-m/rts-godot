class_name BuildCosts
extends Resource

# Estadisticas de los enemigos
@export var worker_gold: int = 0
@export var worker_wood: int = 0
@export var knight_gold: int = 0
@export var knight_wood: int = 0
@export var archer_gold: int = 0
@export var archer_wood: int = 0
@export var house_gold: int = 0
@export var house_wood: int = 0
@export var wall_gold: int = 0
@export var wall_wood: int = 0
@export var tower_gold: int = 0
@export var tower_wood: int = 0

func get_costs(unit_name: String) -> Array[int]:
	match unit_name:
		"Worker":
			return [worker_gold, worker_wood]
		"Knight":
			return [knight_gold, knight_wood]
		"Archer":
			return [archer_gold, archer_wood]
		"House":
			return [house_gold, house_wood]
		"Wall":
			return [wall_gold, wall_wood]
		"Tower":
			return [tower_gold, tower_wood]
		"Castle":
			return [0, 0]

	return []
