extends Node

var castle_scene := preload("res://scenes/entities/buildings/castle/castle.tscn")
var house_scene := preload("res://scenes/entities/buildings/house/house.tscn")
var zombie_scene := preload("res://scenes/entities/enemies/zombie/zombie.tscn")
var basic_unit_scene := preload("res://scenes/entities/units/basic_unit2.tscn")

@onready var hud := $TestHud
@onready var entities := $Entities
@onready var printer := Printer.new(name)

var _placing_unit_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	hud.spawn_unit.connect(_on_spawn_unit)
	var selectionComponent = SelectionComponent.new()
	add_child(selectionComponent)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		match _placing_unit_name:
			"castle":
				_spawn_castle(event.global_position)
			"house":
				_spawn_house(event.global_position)
			"zombie":
				_spawn_zombie(event.global_position)
			"basic_unit":
				_spawn_basic_unit(event.global_position)
		_placing_unit_name = ""

func _on_spawn_unit(unit_name: String) -> void:
	_placing_unit_name = unit_name

func _spawn_castle(position: Vector2) -> void:
	var castle: Node2D = castle_scene.instantiate()
	castle.global_position = position
	castle.name = "castle_%d" % castle.id
	entities.get_child(0).add_child(castle)

func _spawn_house(position: Vector2) -> void:
	var house: Node2D = house_scene.instantiate()
	house.global_position = position
	house.name = "house_%d" % house.id
	entities.get_child(0).add_child(house)

func _spawn_zombie(position: Vector2) -> void:
	var zombie: Node2D = zombie_scene.instantiate()
	zombie.global_position = position
	zombie.name = "zombie_%d" % zombie.id
	entities.get_child(1).add_child(zombie)

func _spawn_basic_unit(position: Vector2) -> void:
	var basic_unit: Node2D = basic_unit_scene.instantiate()
	basic_unit.global_position = position
	basic_unit.name = "basic_unit%d" % basic_unit.id
	entities.get_child(2).add_child(basic_unit)
