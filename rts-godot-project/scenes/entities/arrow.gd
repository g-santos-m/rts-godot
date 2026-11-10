class_name Arrow
extends Node2D

var SPEED: float = 700			# Píxeles/segundo
var MAX_DISTANCE: float = 500	# Píxeles

# Parámetros
var _damage: float
var _direction: Vector2
var _printer: Printer

var _initial_position: Vector2

@onready var _area_2d := $Area2D

func setup(direction: Vector2, damage: float, printer: Printer) -> void:
	_damage = damage
	_direction = direction
	_printer = printer

func _ready() -> void:
	_initial_position = global_position
	z_index = 1
	_area_2d.body_entered.connect(_on_body_entered)

func _physics_process(delta: float) -> void:
	global_position += _direction.normalized() * SPEED * delta
	if global_position.distance_to(_initial_position) > MAX_DISTANCE:
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	body.take_damage(_damage)
	_printer.cprint("deals ", _damage, " damage to ", body.name)
	queue_free()
