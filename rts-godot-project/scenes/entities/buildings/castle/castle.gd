extends StaticBody2D

# Unit stats
const MAX_HEALTH := 10.0

# Unit state
var current_health := MAX_HEALTH

@onready var printer := Printer.new(name)

func _ready() -> void:
    printer.cprint("has spawned at ", global_position)

func take_damage(damage: float) -> void:
    current_health -= damage
    if current_health < 0:
        current_health = 0
    printer.cprint("has taken ", damage, " damage. Current health is ", current_health, "/", MAX_HEALTH)
    if current_health == 0:
        printer.cprint("has been destroyed")
        queue_free()
