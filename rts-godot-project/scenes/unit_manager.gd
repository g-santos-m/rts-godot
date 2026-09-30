extends Node2D
 
var selected_rect : Rect2:
	set(value):
		selected_rect = value
		check_unit()
 
var unit_selected : Array
var control_group_1 : Array
var control_group_2 : Array
var control_group_3 : Array
 
 
func _input(event):
	if event is InputEventKey:
		if event.pressed and event.keycode == KEY_1:
			if event.ctrl_pressed:
				control_group_1 = unit_selected
			else:
				select_in(control_group_1)
				unit_selected = control_group_1
		if event.pressed and event.keycode == KEY_2:
			if event.ctrl_pressed:
				control_group_2 = unit_selected
			else:
				select_in(control_group_2)
				unit_selected = control_group_2
		if event.pressed and event.keycode == KEY_3:
			if event.ctrl_pressed:
				control_group_3 = unit_selected
			else:
				select_in(control_group_3)
				unit_selected = control_group_3
 
 
func check_unit():
	unit_selected = []
	for unit in get_tree().get_nodes_in_group("Unit"):
		if selected_rect.has_point(unit.global_position):
			unit.select()
			unit_selected.append(unit)
		else:
			unit.deselect()
	print(unit_selected)
 
func get_formation(tile_pos):
	var formation = []  
	var unit_count = unit_selected.size()
	
	var formation_size = ceil(sqrt(unit_count))
	var unit_spacing = 4
 
	var index = 0
	for x in range(-formation_size / 2, formation_size / 2 + 1):
		for y in range(-formation_size / 2, formation_size / 2 + 1):
			if index < unit_count:
				formation.append(tile_pos + Vector2i(x, y) * unit_spacing)
				index += 1
			else:
				break
 
	return formation

 
func move_to_position(layer : TileMapLayer, tile_pos):
	var formation = get_formation(tile_pos)
	for i in range(unit_selected.size()):
		#unit_selected[i].global_position = layer.map_to_local(formation[i])
		unit_selected[i].move_to( layer.map_to_local(formation[i]) )
 
func select_in(group):
	for unit in get_tree().get_nodes_in_group("Unit"):
		if unit in group:
			unit.select()
		else:
			unit.deselect()
