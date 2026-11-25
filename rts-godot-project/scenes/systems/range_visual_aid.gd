class_name RangeVisualAid
extends Node2D

var _range_radius: float = ResourceLoader.load(
		"res://scenes/entities/buildings/tower_stats.tres"
).detection_range
var red: bool = false:
	set(new_value):
		red = new_value
		queue_redraw()


func _draw() -> void:
	draw_circle(
			Vector2.ZERO,
			_range_radius,
			GlobalVariables.FILL_COLOR_RED if red else GlobalVariables.FILL_COLOR_BLUE
	)
	draw_arc(
			Vector2.ZERO,
			_range_radius,
			0,
			TAU,
			64,
			GlobalVariables.BORDER_COLOR_RED if red else GlobalVariables.BORDER_COLOR_BLUE,
			2.0,
			true
	)
