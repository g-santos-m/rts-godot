class_name BaseBuilding
extends StaticBody2D

signal destroyed

@export var stats: BaseBuildingStats

static var _next_ids_by_type = {
	"House": 1,
	"Wall": 1,
	"Tower": 1,
	"Castle": 1
}

var id: int

@onready var sprite := $Sprite2D
@onready var _health_comp := $HealthComponent
@onready var _printer: Printer


func _ready() -> void:
	id = _next_ids_by_type[stats.building_type]
	_next_ids_by_type[stats.building_type] += 1
	name = "%s_%s" % [stats.building_type, id]
	_printer = Printer.new(name)

	_health_comp.setup(stats.max_health, _printer)
	_health_comp.paint_bar()
	_health_comp.position.y = sprite.get_rect().position.y * 2 - 10
	_health_comp.destroyed.connect(_on_destroyed)

	_printer.cprint("has spawned at ", global_position)


func take_damage(damage: float) -> void:
	_health_comp.take_damage(damage)


func _on_destroyed() -> void:
	_printer.cprint("has been destroyed")
	destroyed.emit()
	queue_free()
