extends StaticBody2D


func has_point(point: Vector2) -> bool:
	var adjusted_sprite_rect: Rect2 = $Sprite2D.get_rect()
	adjusted_sprite_rect.position += $Sprite2D.position
	return adjusted_sprite_rect.has_point(to_local(point))
