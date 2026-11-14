class_name BaseUnit
extends CharacterBody2D

signal destroyed

@export var stats: BaseUnitStats

static var _next_ids_by_type := { "Worker": 1, "Knight": 1, "Archer": 1 }

var id: int
var move_destination: Vector2:
	set = set_move_destination
var _printer: Printer
var selected = false:
	set = set_selected
# Para cálculo de velocidad según el tipo de terreno.
var _base_layer: TileMapLayer
var _last_cell_coords: Vector2 = Vector2(-999999, -999999)
var _current_terrain_speed_mult: float = 1.0

@onready var _animated_sprite := $AnimatedSprite2D
@onready var _nav_agent := $NavigationAgent2D
@onready var _health_comp := $HealthComponent


func _ready() -> void:
	id = _next_ids_by_type[stats.unit_type]
	_next_ids_by_type[stats.unit_type] += 1
	name = "%s_%s" % [stats.unit_type, id]
	_printer = Printer.new(name)

	_nav_agent.avoidance_priority = 0.2
	_health_comp.setup(stats.max_health, _printer)
	_health_comp.paint_bar()
	_health_comp.position.y = \
			-(_animated_sprite.sprite_frames.get_frame_texture("animation", 0).get_height() + 10)
	_health_comp.destroyed.connect(_on_destroyed)

	_base_layer = get_tree().get_first_node_in_group("base_layer")

	_printer.cprint("has spawned at ", global_position)


func _physics_process(_delta) -> void:
	# Si ya llegó al final de la ruta (o no tiene una), se detiene y no hace nada más
	if _nav_agent.is_navigation_finished():
		velocity = Vector2.ZERO
		return

	_update_terrain_speed_mult()

	# Calcula el siguiente punto en el mapa de navegación
	var next_position = _nav_agent.get_next_path_position()

	# Obtiene la dirección hacia ese punto
	var direction = global_position.direction_to(next_position)
	_animated_sprite.flip_h = direction.x < 0

	# Aplica la velocidad y mueve al personaje
	velocity = direction * stats.movement_speed * _current_terrain_speed_mult
	move_and_slide()


func take_damage(damage: float) -> void:
	_health_comp.take_damage(damage)


func set_selected(value):
	selected = value
	if selected:
		_animated_sprite.self_modulate = Color.AQUA
	else:
		_animated_sprite.self_modulate = Color.WHITE


func set_move_destination(mouse_position: Vector2) -> void:
	move_destination = mouse_position
	_nav_agent.target_position = move_destination


func _update_terrain_speed_mult() -> void:
	# Convertir la posicion global a coordenadas locales de la cuadricula de tiles
	var current_cell: Vector2 = _base_layer.local_to_map(global_position)
	# Salir si la unidad sigue dentro de la misma celda
	if current_cell == _last_cell_coords:
		return
	_last_cell_coords = current_cell
	var tile_data: TileData = _base_layer.get_cell_tile_data(current_cell)
	_current_terrain_speed_mult = tile_data.get_custom_data("speed_mult_units")


func _on_destroyed() -> void:
	_printer.cprint("has been destroyed")
	destroyed.emit()
	queue_free()
