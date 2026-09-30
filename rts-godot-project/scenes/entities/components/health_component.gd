extends Node

signal destroyed

# Propiedades gráficas
const red_background_p0 := Vector2(0,0)
const red_background_p3 := Vector2(0,6)
const green_bar_p0 := Vector2(0,0)
const green_bar_p3 := Vector2(0,6)

var _max_health: float
var current_health: float

@onready var _red_background = $RedBackground
@onready var _green_bar = $GreenBar
@onready var _printer: Printer

func setup(max_health: float, printer: Printer) -> void:
    _max_health = max_health
    current_health = max_health
    _printer = printer

func take_damage(damage: float) -> void:
    current_health -= damage
    if current_health < 0:
        current_health = 0
    _printer.cprint("has taken ", damage, " damage. Current health is ", current_health, "/", _max_health)
    if current_health != 0:
        paint_bar()
    else:
        destroyed.emit()

func paint_bar() -> void:
    const length_mult = 5
    self.visible = _max_health != current_health
    _red_background.polygon = [
        red_background_p0,
        Vector2(_max_health * length_mult, 0),
        Vector2(_max_health * length_mult, 6),
        red_background_p3
    ]
    _green_bar.polygon = [
        green_bar_p0,
        Vector2(current_health * length_mult, 0),
        Vector2(current_health * length_mult, 6),
        green_bar_p3
    ]
