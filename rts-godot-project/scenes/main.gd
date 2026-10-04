extends Node2D

var level_1_scene := preload("res://scenes/levels/level_1.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var level_1 := level_1_scene.instantiate()
    add_child(level_1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
