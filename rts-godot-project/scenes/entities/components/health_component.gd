extends Node2D

signal destroyed

var _max_health: float
var current_health: float
var background_painted: bool

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
	const LENGTH_MULT = 2.5		# Píxeles por punto de vida.
	const BAR_HALF_HEIGHT = 4
	visible = _max_health != current_health
	if !background_painted:
		_red_background.polygon = [
			Vector2(-_max_health / 2 * LENGTH_MULT, -BAR_HALF_HEIGHT),
			Vector2(_max_health / 2 * LENGTH_MULT, -BAR_HALF_HEIGHT),
			Vector2(_max_health / 2 * LENGTH_MULT, BAR_HALF_HEIGHT),
			Vector2(-_max_health / 2 * LENGTH_MULT, BAR_HALF_HEIGHT)
		]
		background_painted = true
	_green_bar.polygon = [
		_red_background.polygon[0],
		Vector2(_red_background.polygon[0].x + current_health * LENGTH_MULT, -BAR_HALF_HEIGHT),
		Vector2(_red_background.polygon[3].x + current_health * LENGTH_MULT, BAR_HALF_HEIGHT),
		Vector2(current_health / 2 * LENGTH_MULT, BAR_HALF_HEIGHT),
		_red_background.polygon[3],
	]
