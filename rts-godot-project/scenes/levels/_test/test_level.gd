extends Node2D

signal placing_tower(is_placing_tower: bool)
signal wall_placed()

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

var _placing_entity_name: String
var _ghost_building: Sprite2D
var _is_placing_building := false
var _wall_placing_manager: WallPlacingManager

@onready var _wave_manager := $WaveManager
@onready var _hud := $Hud
@onready var _castle := $Entities/Buildings/Castle_1


func _ready() -> void:
	_hud.spawn_entity.connect(_on_spawn_entity)
	_wave_manager.last_wave_ended.connect(_on_last_wave_ended)
	#region TESTS
	#_castle.destroyed.connect(_on_castle_destroyed)
	_hud.clear_enemies.connect(_on_clear_enemies)
	#endregion


func _process(_delta: float) -> void:
	if _is_placing_building and _placing_entity_name != "wall":
		_ghost_building.global_position = get_global_mouse_position()


func _input(event: InputEvent) -> void:
	var building: PhysicsBody2D

	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		match _placing_entity_name:
			"house":
				building = house_scene.instantiate()
			"wall":
				building = wall_scene.instantiate()
			"tower":
				building = tower_scene.instantiate()
			#region TESTS
			"castle":
				_spawn_castle(get_global_mouse_position())
			"zombie":
				_spawn_zombie(get_global_mouse_position())
			"fat_zombie":
				_spawn_fat_zombie(get_global_mouse_position())
			#endregion
		if building:
			_spawn_building(building)
		_placing_entity_name = ""

	elif event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT:
		if _placing_entity_name:
			_clear_placing_state()


func _on_spawn_entity(entity_name: String) -> void:
	# Para unidades.
	if _castle:
		match entity_name:
			"worker":
				var worker := worker_scene.instantiate()
				_spawn_unit(worker)
				return
			"knight":
				var knight := knight_scene.instantiate()
				_spawn_unit(knight)
				return
			"archer":
				var archer := archer_scene.instantiate()
				_spawn_unit(archer)
				return

	# Para el resto de entidades que requieren un segundo click.
	_placing_entity_name = entity_name
	_activate_placing_building(entity_name)


func _spawn_unit(unit: BaseUnit) -> void:
	unit.global_position = _castle.global_position + UNIT_SPAWN_OFFSET + \
			Vector2(randf(), randf()) * 100
	$Entities/Units.add_child(unit)


func _spawn_building(building: BaseBuilding) -> void:
	building.global_position = _ghost_building.global_position \
			+ Vector2(0, (_ghost_building.get_rect().size.y / 2))
	building.tree_exited.connect(_rebake_navigation)
	$Entities/Buildings.add_child(building)
	if _placing_entity_name == "wall":
		building.destroyed.connect(_clean_walls_in_map_array)
		walls_in_map.append(building)
		wall_placed.emit()
	_clear_placing_state()


func _rebake_navigation() -> void:
	$NavigationRegion2D.bake_navigation_polygon()


# Esta función modifica la referencia al array contenida en walls_in_map, por lo que
# las instancias de Wall deben coger de nuevo la variable para su propio uso.
func _clean_walls_in_map_array() -> void:
	var new_walls_in_map: Array = walls_in_map.filter(
		func(wall: Wall) -> bool:
			return is_instance_valid(wall),
	)
	walls_in_map = new_walls_in_map


func _activate_placing_building(entity_name: String) -> void:
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
		_wall_placing_manager = WallPlacingManager.new(_ghost_building)
		add_child(_wall_placing_manager)
	_is_placing_building = true
	add_child(_ghost_building)


func _clear_placing_state() -> void:
	if _placing_entity_name == "tower":
		placing_tower.emit(false)
	elif _placing_entity_name == "wall":
		_wall_placing_manager.queue_free()
		_wall_placing_manager = null

	if _is_placing_building:
		_is_placing_building = false
		_ghost_building.queue_free()
		_ghost_building = null

	_placing_entity_name = ""


#region TESTS
func _spawn_castle(spawn_position: Vector2) -> void:
	# Solo puede haber un castillo a la vez.
	if _castle == null or !is_instance_valid(_castle):
		var castle: Node2D = castle_scene.instantiate()
		castle.global_position = spawn_position
		castle.tree_exited.connect(_rebake_navigation)
		$Entities/Buildings.add_child(castle)
		_castle = castle


func _spawn_zombie(spawn_position: Vector2) -> void:
	var zombie: Node2D = zombie_scene.instantiate()
	zombie.global_position = spawn_position
	$Entities/Enemies.add_child(zombie)


func _spawn_fat_zombie(spawn_position: Vector2) -> void:
	var fat_zombie: Node2D = fat_zombie_scene.instantiate()
	fat_zombie.global_position = spawn_position
	$Entities/Enemies.add_child(fat_zombie)

#func _on_castle_destroyed() -> void:
#	_hud.show_game_over()
#	self.process_mode = Node.PROCESS_MODE_DISABLED


# TODO
func _on_last_wave_ended() -> void:
	pass


func _on_clear_enemies() -> void:
	var enemies = $Entities/Enemies.get_children()
	for enemy in enemies:
		enemy._on_destroyed()
#endregion
