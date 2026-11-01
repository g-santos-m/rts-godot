extends Node

var worker_scene := preload("res://scenes/entities/units/basic_unit2.tscn")
var house_scene := preload("res://scenes/entities/buildings/house/house.tscn")

@onready var _hud := $Hud
@onready var _castle := $Entities/Buildings/Castle
@onready var _printer := Printer.new(name)

var _placing_entity_name: String

func _ready() -> void:
	_hud.spawn_entity.connect(_on_spawn_entity)
	_castle.destroyed.connect(_on_castle_destroyed)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		match _placing_entity_name:
			"worker":
				_spawn_worker(event.global_position)
			"house":
				_spawn_house(event.global_position)
		_placing_entity_name = ""

func _on_spawn_entity(entity_name: String) -> void:
	_placing_entity_name = entity_name

func _spawn_worker(position: Vector2) -> void:
	var worker: Node2D = worker_scene.instantiate()
	worker.global_position = position
	worker.name = "Worker_%d" % worker.id
	$Entities/Buildings.add_child(worker)

func _spawn_house(position: Vector2) -> void:
	var house: Node2D = house_scene.instantiate()
	house.global_position = position
	house.name = "house_%d" % house.id
	$Entities/Buildings.add_child(house)

func _on_castle_destroyed() -> void:
	_hud.show_game_over()
	self.process_mode = Node.PROCESS_MODE_DISABLED
