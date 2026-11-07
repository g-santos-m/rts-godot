class_name BaseBuilding
extends Node2D

signal destroyed

@export var stats: BaseBuildingStats

static var _next_ids_by_type := {
	"House": 1,
	"Wall": 1,
	"Tower": 1,
}

var id: int

@onready var _sprite := $Sprite2D
@onready var _health_comp := $HealthComponent
@onready var _printer: Printer

func _ready() -> void:
	id = _next_ids_by_type[stats.building_type]
	_next_ids_by_type[stats.building_type] += 1
	name = "%s_%s" % [stats.building_type, id]
	_printer = Printer.new(name)

	_health_comp.setup(stats.max_health, _printer)
	# Hay que llamar a paint_bar() al principio para que la barra de vida tome
	# tamaño correcto y poder posicionarla adecuadamente después.
	_health_comp.paint_bar()
	# Posiciona la barra centrada horizontalmente y 10 píxeles sobre el sprite
	# de la entidad.
	_health_comp.position = Vector2(
		-(_health_comp.get_child(0).polygon[1].x / 2),
		_sprite.get_rect().position.y * 2 - 10
	)
	_health_comp.destroyed.connect(_on_destroyed)

	get_tree().get_first_node_in_group("navigation_region").bake_navigation_polygon()
	_printer.cprint("has spawned at ", global_position)

func take_damage(damage: float) -> void:
	_health_comp.take_damage(damage)

func _on_destroyed() -> void:
	_printer.cprint("has been destroyed")
	destroyed.emit()
	queue_free()
