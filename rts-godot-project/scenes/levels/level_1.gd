extends Node

var house_scene := preload("res://scenes/entities/buildings/house/house.tscn")

@onready var _hud := $Hud
@onready var _castle := $Entities/Buildings/Castle
@onready var _printer := Printer.new(name)

var _placing_unit_name: String

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    _hud.spawn_unit.connect(_on_spawn_unit)
    _castle.destroyed.connect(_on_castle_destroyed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        match _placing_unit_name:
            "house":
                _spawn_house(event.global_position)
        _placing_unit_name = ""

func _on_spawn_unit(unit_name: String) -> void:
    _placing_unit_name = unit_name

func _spawn_house(position: Vector2) -> void:
    var house: Node2D = house_scene.instantiate()
    house.global_position = position
    house.name = "house_%d" % house.id
    $Entities/Buildings.add_child(house)

func _on_castle_destroyed() -> void:
    _hud.show_game_over()
    self.process_mode = Node.PROCESS_MODE_DISABLED
