extends Node2D

var worker_scene := preload("res://scenes/entities/units/worker.tscn")
var house_scene := preload("res://scenes/entities/buildings/house.tscn")
var tower_scene := preload("res://scenes/entities/buildings/tower.tscn")
#region TESTS
var castle_scene := preload("res://scenes/entities/buildings/castle.tscn")
var zombie_scene := preload("res://scenes/entities/enemies/zombie.tscn")
var fat_zombie_scene := preload("res://scenes/entities/enemies/fat_zombie.tscn")
#endregion

const UNIT_SPAWN_OFFSET = Vector2(0, 50)

@onready var _wave_manager := $WaveManager
@onready var _hud := $Hud
@onready var _castle := $Entities/Buildings/Castle

var _placing_entity_name: String

func _ready() -> void:
	_hud.spawn_entity.connect(_on_spawn_entity)
	_wave_manager.last_wave_ended.connect(_on_last_wave_ended)
	var selection_component = SelectionComponent.new()
	add_child(selection_component)
	#region TESTS
	#_castle.destroyed.connect(_on_castle_destroyed)
	_hud.clear_enemies.connect(_on_clear_enemies)
	#endregion

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		match _placing_entity_name:
			"house":
				_spawn_house(get_global_mouse_position())
			"tower":
				_spawn_tower(get_global_mouse_position())
			#region TESTS
			"castle":
				_spawn_castle(get_global_mouse_position())
			"zombie":
				_spawn_zombie(get_global_mouse_position())
			"fat_zombie":
				_spawn_fat_zombie(get_global_mouse_position())
			#endregion
		_placing_entity_name = ""

func _on_spawn_entity(entity_name: String) -> void:
	if entity_name == "worker":
		if _castle:
			_spawn_worker()
	else:
		_placing_entity_name = entity_name

func _spawn_worker() -> void:
	var worker: Node2D = worker_scene.instantiate()
	worker.global_position = _castle.global_position + UNIT_SPAWN_OFFSET + \
		Vector2(randf(), randf()) * 100
	$Entities/Units.add_child(worker)

func _spawn_house(spawn_position: Vector2) -> void:
	var house: Node2D = house_scene.instantiate()
	house.global_position = spawn_position
	house.tree_exited.connect(_rebake_navigation)
	$Entities/Buildings.add_child(house)

func _spawn_tower(spawn_position: Vector2) -> void:
	var tower: Node2D = tower_scene.instantiate()
	tower.global_position = spawn_position
	tower.tree_exited.connect(_rebake_navigation)
	$Entities/Buildings.add_child(tower)

func _rebake_navigation() -> void:
	$NavigationRegion2D.bake_navigation_polygon()

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
