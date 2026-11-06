extends Node2D

var level_1_scene := preload("res://scenes/levels/level_1.tscn")
var test_level_scene := preload("res://scenes/levels/_test/test_level.tscn")

func _ready() -> void:
	#var level_1 := level_1_scene.instantiate()
	#add_child(level_1)
	var test_level := test_level_scene.instantiate()
	add_child(test_level)

func _process(_delta: float) -> void:
	pass
