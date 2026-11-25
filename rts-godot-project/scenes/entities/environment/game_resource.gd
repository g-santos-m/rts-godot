extends StaticBody2D


func has_point(point: Vector2) -> bool:
	return _get_sprite_rect_adjusted().has_point(to_local(point))

func get_rect_global() -> Rect2:
	var rect: Rect2 = _get_sprite_rect_adjusted()
	rect.position = to_global(rect.position)
	return rect

func _get_sprite_rect_adjusted() -> Rect2:
	var adjusted_sprite_rect: Rect2 = $Sprite2D.get_rect()
	adjusted_sprite_rect.position += $Sprite2D.position
	return adjusted_sprite_rect
