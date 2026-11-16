class_name WallBuildingManager
extends Node2D

signal spawn_walls(tiles: Array[Vector2])

const _FILL_COLOR: Color = Color(0.2, 0.6, 1.0, 0.3)
const _BORDER_COLOR: Color = Color(0.2, 0.6, 1.0, 0.8)

var _base_layer: TileMapLayer
var _ghost_wall: Sprite2D
var _marked_tiles: Array[Vector2] = []
var _dragging: bool = false


func _init(ghost_wall: Sprite2D) -> void:
	_ghost_wall = ghost_wall


func _ready() -> void:
	_base_layer = get_tree().get_first_node_in_group("base_layer")

	add_child(_ghost_wall)

func _process(_delta: float) -> void:
	# Registra el tile actual.
	var current_tile: Vector2 = _base_layer.local_to_map(get_global_mouse_position())
	if _marked_tiles.any(func (tile): return tile == current_tile):
		return

	# Si es una tile nueva dibuja el sprite ghost y el indicador cuadrado.
	_ghost_wall.global_position = _base_layer.map_to_local(current_tile)
	# Si esta pulsado el botón izquierdo, se van guardando las posiciones de los muros.
	if _dragging:
		var new_ghost_wall = _ghost_wall.duplicate()
		add_child(new_ghost_wall)
		_marked_tiles.append(current_tile)
	else:
		_marked_tiles.clear()
		_marked_tiles.append(current_tile)
	queue_redraw()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			_dragging = true
			var initial_ghost_wall = _ghost_wall.duplicate()
			add_child(initial_ghost_wall)
		else:
			spawn_walls.emit(_marked_tiles)
			queue_free()

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		queue_free()


func _draw() -> void:
	for tile in _marked_tiles:
		# Borde
		draw_rect(
			Rect2(_base_layer.map_to_local(tile) + (-GlobalVariables.TILE_SIZE / 2), GlobalVariables.TILE_SIZE),
			_BORDER_COLOR,
			false,
			2,
		)
		# Relleno
		draw_rect(
			Rect2(_base_layer.map_to_local(tile) + (-GlobalVariables.TILE_SIZE / 2), GlobalVariables.TILE_SIZE),
			_FILL_COLOR,
			true,
		)
