class_name BuildManager
extends Node2D

signal placing_tower(is_placing_tower: bool)
signal update_walls()

var worker_scene := preload("res://scenes/entities/units/worker.tscn")
var knight_scene := preload("res://scenes/entities/units/knight.tscn")
var archer_scene := preload("res://scenes/entities/units/archer.tscn")
var house_scene := preload("res://scenes/entities/buildings/house.tscn")
var wall_scene := preload("res://scenes/entities/buildings/wall.tscn")
var tower_scene := preload("res://scenes/entities/buildings/tower.tscn")
#region TESTS
var castle_scene := preload("res://scenes/entities/buildings/castle.tscn")
var zombie_scene := preload("res://scenes/entities/enemies/zombie.tscn")
var fat_zombie_scene := preload("res://scenes/entities/enemies/fat_zombie.tscn")
#endregion

const UNIT_SPAWN_OFFSET = Vector2(0, 50)

var walls_in_map: Array[Wall] = []
var _entity_being_placed_name: String
var _ghost_building: Sprite2D
var _wall_building_manager: WallBuildingManager
var _wall_building_mode: bool = false

var _entities_node: Node2D
var _navigation_region: NavigationRegion2D
var _base_layer: TileMapLayer
var _selection_comp: SelectionComponent

@onready var _level: Node2D = get_parent()


func _ready() -> void:
	_entities_node = get_tree().get_first_node_in_group("entities_node")
	_navigation_region = get_tree().get_first_node_in_group("navigation_region")
	_base_layer = get_tree().get_first_node_in_group("base_layer")
	_selection_comp = get_tree().get_first_node_in_group("selection_component")

	get_tree().get_first_node_in_group("hud").spawn_entity.connect(_on_spawn_entity)


func _process(_delta: float) -> void:
	if _ghost_building and not _wall_building_mode:
		_ghost_building.global_position = get_global_mouse_position()


func _input(event: InputEvent) -> void:
	if _entity_being_placed_name and not _wall_building_mode:
		if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
			match _entity_being_placed_name:
				"house":
					_spawn_building(house_scene.instantiate())
				"wall":
					_spawn_building(wall_scene.instantiate())
				"tower":
					_spawn_building(tower_scene.instantiate())
				#region TESTS
				"castle":
					_spawn_castle()
				"zombie":
					_spawn_enemy(zombie_scene.instantiate())
				"fat_zombie":
					_spawn_enemy(fat_zombie_scene.instantiate())
				#endregion

			_clear_placing_state()

		elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
			_clear_placing_state()


func _on_spawn_entity(entity_name: String) -> void:
	# Para unidades.
	if _level.castle:
		match entity_name:
			"worker":
				_spawn_unit(worker_scene.instantiate())
				return
			"knight":
				_spawn_unit(knight_scene.instantiate())
				return
			"archer":
				_spawn_unit(archer_scene.instantiate())
				return

	# Para el resto de entidades que requieren un segundo click (edificios y unidades test)
	_entity_being_placed_name = entity_name
	if ["castle", "house", "wall", "tower"].any(
		func(building):
			return building == entity_name,
	):
		_attach_building_ghost(_entity_being_placed_name)


func _spawn_unit(unit: BaseUnit) -> void:
	unit.global_position = _level.castle.global_position + UNIT_SPAWN_OFFSET + \
			Vector2(randf(), randf()) * 100
	_entities_node.get_node("Units").add_child(unit)


func _spawn_building(building: BaseBuilding) -> void:
	building.global_position = _ghost_building.global_position \
			+ Vector2(0, (_ghost_building.get_rect().size.y / 2))
	building.tree_exited.connect(_rebake_navigation)
	_entities_node.get_node("Buildings").add_child(building)
	_rebake_navigation()
	_clear_placing_state()


func _attach_building_ghost(entity_name: String) -> void:
	_ghost_building = Sprite2D.new()
	var atlas = AtlasTexture.new()
	var atlas_path = "res://assets/textures/entities/buildings/" + entity_name + "_ghost.png"
	atlas.atlas = load(atlas_path)
	_ghost_building.texture = atlas

	if entity_name == "tower":
		var range_visual_aid := RangeVisualAid.new()
		range_visual_aid.position.y = _ghost_building.get_rect().size.y / 2
		_ghost_building.add_child(range_visual_aid)
		placing_tower.emit(true)
	elif entity_name == "wall":
		_wall_building_manager = WallBuildingManager.new(_ghost_building)
		_wall_building_manager.spawn_walls.connect(_on_spawn_walls)
		add_child(_wall_building_manager)
		_wall_building_mode = true
		_selection_comp.toggle_active(false)
		return

	add_child(_ghost_building)


func _clear_placing_state() -> void:
	if _entity_being_placed_name == "tower":
		placing_tower.emit(false)
	if _entity_being_placed_name == "wall":
		_wall_building_manager.queue_free()
		_wall_building_manager = null
		_selection_comp.toggle_active(true)

	if _ghost_building:
		_ghost_building.queue_free()
		_ghost_building = null

	_entity_being_placed_name = ""


func _rebake_navigation() -> void:
	_navigation_region.bake_navigation_polygon()


func _on_spawn_walls(tiles: Array[Vector2]) -> void:
	for tile in tiles:
		var wall: Wall = wall_scene.instantiate()
		wall.global_position = _base_layer.map_to_local(tile) + \
				Vector2(0, GlobalVariables.TILE_SIZE.y / 2)
		wall.tree_exited.connect(_rebake_navigation)
		_entities_node.get_node("Buildings").add_child(wall)
		walls_in_map.append(wall)
		wall.tree_exiting.connect(_on_wall_exiting.bind(wall))
	update_walls.emit()
	_rebake_navigation()
	_clear_placing_state()


func _on_wall_exiting(wall: Wall) -> void:
	walls_in_map.erase(wall)
	update_walls.emit()


#region TESTS
func _spawn_castle() -> void:
	# Solo puede haber un castillo a la vez.
	if _level.castle == null or !is_instance_valid(_level.castle):
		var castle: Castle = castle_scene.instantiate()
		_attach_building_ghost(_entity_being_placed_name)
		_spawn_building(castle)
		_level.castle = castle


func _spawn_enemy(enemy: BaseEnemy) -> void:
	enemy.global_position = get_global_mouse_position()
	_entities_node.get_node("Enemies").add_child(enemy)
#endregion
