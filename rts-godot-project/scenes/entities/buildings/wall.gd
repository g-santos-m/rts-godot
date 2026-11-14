class_name Wall
extends BaseBuilding

# "Código de tiles adjacentes": [Posición en el atlas, invertido en eje Y]
const _ATLAS_REGION_CODES: Dictionary = {
	"0000": [Vector2(2, 0), false],
	"0001": [Vector2(1, 1), false],
	"0010": [Vector2(2, 1), true],
	"0011": [Vector2(3, 0), true],
	"0100": [Vector2(1, 0), false],
	"0101": [Vector2(0, 1), false],
	"0110": [Vector2(3, 1), false],
	"0111": [Vector2(0, 0), false],
	"1000": [Vector2(2, 1), false],
	"1001": [Vector2(3, 0), false],
	"1010": [Vector2(2, 2), false],
	"1011": [Vector2(0, 2), false],
	"1100": [Vector2(3, 1), true],
	"1101": [Vector2(0, 0), true],
	"1110": [Vector2(1, 2), false],
	"1111": [Vector2(3, 2), false],
}

# [right, down, left, up]
var _adjacent_tiles_map_coor: Array[Vector2i]
var _base_layer: TileMapLayer
var _build_manager: BuildManager


func _ready() -> void:
	super._ready()
	_base_layer = get_tree().get_first_node_in_group("base_layer")
	_build_manager = get_tree().get_first_node_in_group("build_manager")
	var map_position: Vector2i = _base_layer.local_to_map(global_position)
	_adjacent_tiles_map_coor = _base_layer.get_surrounding_cells(map_position)

	_build_manager.update_walls.connect(_on_update_walls)
	_on_update_walls()


func _on_update_walls() -> void:
	# "right, down, left, up"
	var adjacent_tiles_code: String = "0000"

	for wall in _build_manager.walls_in_map:
		var wall_map_position: Vector2i = _base_layer.local_to_map(wall.global_position)
		for tile in _adjacent_tiles_map_coor:
			if tile == wall_map_position:
				adjacent_tiles_code[_adjacent_tiles_map_coor.find(tile)] = "1"
	# Modifica la textura.
	sprite.texture.region = Rect2(
			_ATLAS_REGION_CODES[adjacent_tiles_code][0] * GlobalVariables.TILE_SIZE,
			GlobalVariables.TILE_SIZE,
	)
	sprite.flip_h = _ATLAS_REGION_CODES[adjacent_tiles_code][1]
