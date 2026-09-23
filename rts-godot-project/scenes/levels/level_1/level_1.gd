extends Node2D

var zombie_scene := preload("res://scenes/entities/enemies/zombie/zombie.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    var zombie_1 := zombie_scene.instantiate()
    zombie_1.name = "zombie_1"
    zombie_1.global_position = Vector2(128, 128)
    add_child(zombie_1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    pass
