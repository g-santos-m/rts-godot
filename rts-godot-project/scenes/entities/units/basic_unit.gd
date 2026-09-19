extends CharacterBody2D


@export var speed: float = 300.0
var selected: bool = false
var destiny_position: Vector2

func _ready() -> void:
	destiny_position = global_position
