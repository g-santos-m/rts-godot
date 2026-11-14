class_name RangeVisualAid
extends Node2D

var _range_radius: float = ResourceLoader.load("res://scenes/entities/buildings/tower_stats.tres").detection_range
var _RING_COLOR: Color = Color(0.2, 0.6, 1.0, 0.3)
var _BORDER_COLOR: Color = Color(0.2, 0.6, 1.0, 0.8)

func _draw() -> void:
	draw_circle(Vector2.ZERO, _range_radius, _RING_COLOR)
	draw_arc(Vector2.ZERO, _range_radius, 0, TAU, 64, _BORDER_COLOR, 2.0, true)
