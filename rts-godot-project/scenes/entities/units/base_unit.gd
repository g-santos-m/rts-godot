class_name BaseUnit
extends CharacterBody2D

signal destroyed

@export var stats: BaseUnitStats

static var _next_ids_by_type := {
	"Worker": 1,
	"Knight": 1,
	"Archer": 1,
}

var id: int
var _target: Vector2
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
@onready var _range_comp := $RangeComponent

func _ready() -> void:
	id = _next_ids_by_type[stats.enemy_type]
	_next_ids_by_type[stats.enemy_type] += 1
	name = "%s_%s" % [stats.enemy_type, id]
	_printer = Printer.new(name)

	_health_comp.setup(stats.max_health, _printer)
	_health_comp.paint_bar()
	_health_comp.position.y = \
		-(_animated_sprite.sprite_frames.get_frame_texture("work", 0).get_height() + 10)
	_health_comp.destroyed.connect(_on_destroyed)
	_range_comp.setup(_printer)
	_range_comp.body_in_range.connect(_on_body_in_range)

	_base_layer = get_tree().get_first_node_in_group("base_layer")
	
	_printer.cprint("has spawned at ", global_position)

func take_damage(damage: float) -> void:
	_health_comp.take_damage(damage)

func set_selected(value):
	selected = value
	if selected:
		_animated_sprite.self_modulate = Color.AQUA;
	else:
		_animated_sprite.self_modulate = Color.WHITE;

func set_target():
	if selected:
		_nav_agent.target_position = get_global_mouse_position()
		_target = get_global_mouse_position()

# Cuando el recurso entra en rango, se guarda,se comienza a recolectar y se
# inicia el ResourceTimer
func _on_body_in_range(body: Node2D, is_in_range: bool) -> void:
	if is_in_range:
		if body.is_in_group("gold_resource") or body.is_in_group("wood_resource"):
			_current_resource = body
			_farm_resource()
			_resource_timer.start()
	else:
		if body == _current_resource:
			_current_resource = null
			_resource_timer.stop()
			_animated_sprite.stop()

func _input(event: InputEvent) -> void:
	if selected and event.is_action_pressed("set_target"):
		_nav_agent.target_position = get_global_mouse_position()

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
