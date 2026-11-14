class_name SelectionComponent
extends Node2D

var dragging = false
var drag_start = Vector2.ZERO
var select_rect = RectangleShape2D.new()
var selected = []

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if selected.size() == 0:
				dragging = true
				drag_start = get_global_mouse_position()
			else:
				for item in selected:
					# Si la unidad ha sido destruida después de ser seleccionada, la quita.
					if not is_instance_valid(item.collider):
						selected.erase(item)
					else:
						item.collider.move_destination = get_global_mouse_position()
						item.collider.selected = false
				selected = []
		elif dragging:
			dragging = false
			queue_redraw()
			var drag_end = get_global_mouse_position()
			select_rect.size = abs(drag_end - drag_start)
			var space = get_world_2d().direct_space_state
			var q = PhysicsShapeQueryParameters2D.new()
			q.shape = select_rect
			q.collision_mask = 1
			q.transform = Transform2D(0, (drag_end + drag_start)/2)
			selected = space.intersect_shape(q)
			for item in selected:
				item.collider.selected = true
	if event is InputEventMouseMotion and dragging:
		queue_redraw()

func _draw():
	if dragging:
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start), Color.DIM_GRAY, false, 8.0)
		draw_rect(Rect2(drag_start, get_global_mouse_position() - drag_start), Color.FLORAL_WHITE, false, 6.0)

func toggle_active(is_active: bool) -> void:
	set_process_unhandled_input(is_active)
