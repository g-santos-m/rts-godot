extends StaticBody2D

# Estadísticas
const MAX_HEALTH := 10.0

static var id := 1

# Estado
var current_health := MAX_HEALTH

@onready var _printer := Printer.new(name)

func _ready() -> void:
	id += 1
	_printer.cprint("has spawned at ", global_position)

func take_damage(damage: float) -> void:
	current_health -= damage
	if current_health < 0:
		current_health = 0
	_printer.cprint("has taken ", damage, " damage. Current health is ", current_health, "/", MAX_HEALTH)
	if current_health == 0:
		_printer.cprint("has been destroyed")
		queue_free()
