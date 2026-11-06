extends Node2D

var worker_scene := preload("res://scenes/entities/units/worker.tscn")
var house_scene := preload("res://scenes/entities/buildings/house/house.tscn")
#region TESTS
var castle_scene := preload("res://scenes/entities/buildings/castle/castle.tscn")
var zombie_scene := preload("res://scenes/entities/enemies/zombie.tscn")
var fat_zombie_scene := preload("res://scenes/entities/enemies/fat_zombie.tscn")
#endregion

@onready var _wave_manager := $WaveManager
@onready var _hud := $Hud
#region TESTS
#@onready var _castle := $Entities/Buildings/Castle
#endregion

var _placing_entity_name: String

func _ready() -> void:
	_hud.spawn_entity.connect(_on_spawn_entity)
	_wave_manager.last_wave_ended.connect(_on_last_wave_ended)
	# TODO Corregir el nombre de la variable y añadir el nodo directamente en el árbol.
	var selectionComponent = SelectionComponent.new()
	add_child(selectionComponent)
	#region TESTS
	#_castle.destroyed.connect(_on_castle_destroyed)
	_hud.clear_enemies.connect(_on_clear_enemies)
	#endregion

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		match _placing_entity_name:
			"worker":
				_spawn_worker(get_global_mouse_position())
			"house":
				_spawn_house(get_global_mouse_position())
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
	_placing_entity_name = entity_name

func _spawn_worker(spawn_position: Vector2) -> void:
	var worker: Node2D = worker_scene.instantiate()
	worker.global_position = spawn_position
	worker.name = "Worker_%d" % worker.id
	$Entities/Units.add_child(worker)

func _spawn_house(spawn_position: Vector2) -> void:
	var house: Node2D = house_scene.instantiate()
	house.global_position = spawn_position
	house.name = "house_%d" % house.id
	house.tree_exited.connect(_rebake_navigation)
	$Entities/Buildings.add_child(house)

#region TESTS
func _spawn_castle(spawn_position: Vector2) -> void:
	var castle: Node2D = castle_scene.instantiate()
	castle.global_position = spawn_position
	castle.name = "Castle_%d" % castle.id
	castle.tree_exited.connect(_rebake_navigation)
	$Entities/Buildings.add_child(castle)

func _spawn_zombie(spawn_position: Vector2) -> void:
	var zombie: Node2D = zombie_scene.instantiate()
	zombie.global_position = spawn_position
	$Entities/Enemies.add_child(zombie)

func _spawn_fat_zombie(spawn_position: Vector2) -> void:
	var fat_zombie: Node2D = fat_zombie_scene.instantiate()
	fat_zombie.global_position = spawn_position
	$Entities/Enemies.add_child(fat_zombie)

func _rebake_navigation() -> void:
	$NavigationRegion2D.bake_navigation_polygon()

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
