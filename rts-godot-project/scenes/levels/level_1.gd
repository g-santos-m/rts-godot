extends Node

var worker_scene := preload("res://scenes/entities/units/basic_unit2.tscn")
var house_scene := preload("res://scenes/entities/buildings/house/house.tscn")

@onready var _hud := $Hud
@onready var _wave_manager := $WaveManager
@onready var _castle := $Entities/Buildings/Castle

var _placing_entity_name: String

func _ready() -> void:
	_hud.spawn_entity.connect(_on_spawn_entity)
	_wave_manager.last_wave_ended.connect(_on_last_wave_ended)
	_castle.destroyed.connect(_on_castle_destroyed)
	# TODO Corregir el nombre de la variable y añadir el nodo directamente en el árbol.
	var selectionComponent = SelectionComponent.new()
	add_child(selectionComponent)

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
	$Entities/Units.add_child(worker)

func _spawn_house(position: Vector2) -> void:
	var house: Node2D = house_scene.instantiate()
	house.global_position = position
	house.name = "House_%d" % house.id
	$Entities/Buildings.add_child(house)

func _on_castle_destroyed() -> void:
	_hud.show_game_over()
	get_tree().paused = true

# TODO
func _on_last_wave_ended() -> void:
	pass
