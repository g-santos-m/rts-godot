class_name WallBuildingManager
extends Node2D

signal spawn_walls(tiles: Array[Vector2])

var _base_layer: TileMapLayer
var _entities_node: Node2D
var _ghost_wall: Sprite2D
var _water_cells: Array[Vector2i]

var _current_tile: Vector2
var _marked_tiles: Array[Vector2] = []
var _marked_ghosts: Array[Sprite2D] = []
var _dragging: bool = false
var _disallow_building: bool = false:
	set(new_value):
		_attach_ghost_texture(new_value)
		_disallow_building = new_value


func _init(ghost_building: Sprite2D, entities_node: Node2D, water_cells: Array[Vector2i]) -> void:
	_ghost_wall = ghost_building
	_entities_node = entities_node
	_water_cells = water_cells

func _ready() -> void:
	_base_layer = get_tree().get_first_node_in_group("base_layer")

	add_child(_ghost_wall)


func _process(_delta: float) -> void:
	# Registra el tile actual.
	_current_tile = _base_layer.local_to_map(get_global_mouse_position())
	if _marked_tiles.any(func (tile): return tile == _current_tile):
		return

	# Si es una tile nueva, comprueba si está libre y dibuja el sprite ghost correspondiente
	# y el indicador cuadrado.
	if not _dragging or not _disallow_building:
		_check_building_overlap()
	_ghost_wall.global_position = _base_layer.map_to_local(_current_tile)
	# Si esta pulsado el botón izquierdo, se van guardando las posiciones de los muros.
	if _dragging:
		var new_ghost_wall = _ghost_wall.duplicate()
		add_child(new_ghost_wall)
		_marked_tiles.append(_current_tile)
		_marked_ghosts.append(new_ghost_wall)
	else:
		_marked_tiles.clear()
		_marked_tiles.append(_current_tile)
	queue_redraw()


func _input(event: InputEvent) -> void:
	if (event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT):
		if event.pressed and not _disallow_building:
			_dragging = true
			var initial_ghost_wall = _ghost_wall.duplicate()
			add_child(initial_ghost_wall)
			_marked_ghosts.append(initial_ghost_wall)
		elif _dragging and _disallow_building:
			_marked_ghosts.map(
				func(ghost):
					if is_instance_valid(ghost):
						ghost.queue_free()
			)
			_marked_tiles.clear()
			_disallow_building = false
			_dragging = false
		elif _dragging:
			spawn_walls.emit(_marked_tiles)
			queue_free()

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		queue_free()


func _draw() -> void:
	for tile in _marked_tiles:
		# Borde
		draw_rect(
				Rect2(
						_base_layer.map_to_local(tile) + (-GlobalVariables.TILE_SIZE / 2),
						GlobalVariables.TILE_SIZE
				),
				GlobalVariables.BORDER_COLOR_RED if _disallow_building else GlobalVariables.BORDER_COLOR_BLUE,
				false,
				2,
		)
		# Relleno
		draw_rect(
				Rect2(
						_base_layer.map_to_local(tile) + (-GlobalVariables.TILE_SIZE / 2),
						GlobalVariables.TILE_SIZE
				),
				GlobalVariables.FILL_COLOR_RED if _disallow_building else GlobalVariables.FILL_COLOR_BLUE,
				true,
		)


func _attach_ghost_texture(red: bool = false) -> void:
	var atlas = AtlasTexture.new()
	var atlas_path: String
	if red:
		atlas_path = "res://assets/textures/entities/buildings/wall_ghost_red.png"
	else:
		atlas_path = "res://assets/textures/entities/buildings/wall_ghost.png"
	atlas.atlas = load(atlas_path)
	_ghost_wall.texture = atlas


func _check_building_overlap() -> void:
	var ghost_area: Rect2 = Rect2(
		_base_layer.map_to_local(_current_tile) - GlobalVariables.TILE_SIZE / 2,
		GlobalVariables.TILE_SIZE
	)
	var obstacles: Array[Rect2]

	for resource in _entities_node.get_node("Resources").get_children():
		obstacles.append(_get_area_with_margins(resource.get_rect_global()))
	for building in _entities_node.get_node("Buildings").get_children():
		obstacles.append(_get_area_with_margins(building.get_rect_global()))
	for cell in _water_cells:
		obstacles.append(_get_area_with_margins(
				Rect2(
						_base_layer.map_to_local(cell) - GlobalVariables.TILE_SIZE / 2,
						GlobalVariables.TILE_SIZE
				)
		))

	_disallow_building = obstacles.any(func(area: Rect2) -> bool: return area.intersects(ghost_area))


func _get_area_with_margins(area: Rect2) -> Rect2:
	const AREA_MARGIN = Vector2(32, 32)
	area.position -= AREA_MARGIN
	area.size += AREA_MARGIN * 2
	return area
