extends Node2D
 
@onready var ground = $Ground
 
var drawing : bool = false
var start_position = Vector2.ZERO
var end_position = Vector2.ZERO
var selection_rect : Rect2
var width = 0
 
func _draw():
	var rect_position = start_position
	var rect_size = end_position - start_position
	if rect_size.x < 0:
		rect_position.x += rect_size.x
		rect_size.x = abs(rect_size.x)
	if rect_size.y < 0:
		rect_position.y += rect_size.y
		rect_size.y = abs(rect_size.y)
 
	selection_rect = Rect2(rect_position,rect_size)
	draw_rect(selection_rect, Color.RED, false, width)
 
 
func _input(event):
	if event is InputEventMouseButton:
		if event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			width = 2
			drawing = true
			start_position = event.position
			end_position = event.position
		if event.is_released() and event.button_index == MOUSE_BUTTON_LEFT:
			width = 0
			drawing = false
			start_position = Vector2.ZERO
			end_position = Vector2.ZERO
			queue_redraw()
		if event.pressed and event.button_index == MOUSE_BUTTON_RIGHT:
			UnitManager.move_to_position(ground,get_tile_pos(get_global_mouse_position()))
 
	if event is InputEventMouseMotion and drawing:
		end_position = event.position
		queue_redraw()
		UnitManager.selected_rect = selection_rect
 
func get_tile_pos(global_pos):
	var local_pos = ground.to_local(global_pos)
	var tile_pos = ground.local_to_map(local_pos)
 
	return tile_pos
