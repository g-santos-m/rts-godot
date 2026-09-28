extends Node

var zombie_scene := preload("res://scenes/entities/enemies/zombie/zombie.tscn")
var castle_scene := preload("res://scenes/entities/buildings/castle/castle.tscn")

@onready var hud := $Hud
@onready var entities := $Entities
@onready var printer := Printer.new(name)

var _is_placing_castle := false
var _is_placing_zombie := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    hud.spawn_unit.connect(_on_spawn_unit)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass

func _unhandled_input(event: InputEvent) -> void:
    if event is InputEventMouseButton:
        if _is_placing_castle:
            _spawn_castle(event.global_position)
            _is_placing_castle = false
        if _is_placing_zombie:
            _spawn_zombie(event.global_position)
            _is_placing_zombie = false

func _on_spawn_unit(unit_name: String) -> void:
    match unit_name:
        "castle":
            _is_placing_castle = true
        "zombie":
            _is_placing_zombie = true

func _spawn_castle(position: Vector2) -> void:
    var castle: Node2D = castle_scene.instantiate()
    castle.global_position = position
    castle.name = "castle_%d" % castle.id
    entities.get_child(0).add_child(castle)

func _spawn_zombie(position: Vector2) -> void:
    var zombie: Node2D = zombie_scene.instantiate()
    zombie.global_position = position
    zombie.name = "zombie_%d" % zombie.id
    entities.get_child(1).add_child(zombie)
