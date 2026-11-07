extends BaseUnit

@export var stats: BaseUnitStats

static var id := 1

var _current_resource: PhysicsBody2D = null
var _resource_manager : Node
var av = Vector2.ZERO
var avoid_weight = 0.1
var selected = false:
	set = set_selected
var target = null

# Para cálculo de velocidad según el tipo de terreno.
var _base_layer: TileMapLayer
var _last_cell_coords: Vector2 = Vector2(-999999, -999999)
var _current_terrain_speed_mult: float = 1.0

@onready var _animated_sprite := $AnimatedSprite2D
@onready var _nav_agent := $NavigationAgent2D
@onready var _health_comp := $HealthComponent
@onready var _resource_timer := $ResourceTimer
@onready var _range_comp := $RangeComponent
@onready var _printer: Printer

func _ready() -> void:
	name = "%s_%s" % [stats.unit_type, id]
	id += 1
	_printer = Printer.new(name)

	_printer.cprint("has spawned at ", global_position)
	_range_comp.setup(_printer)
	_range_comp.body_in_range.connect(_on_body_in_range)
	_health_comp.setup(stats.max_health, _printer)
	# Hay que llamar a paint_bar() al principio para que la barra de vida tome
	# tamaño correcto y poder posicionarla adecuadamente después.
	_health_comp.paint_bar()
	# Posiciona la barra centrada horizontalmente y 10 píxeles sobre el sprite
	# de la entidad.
	_health_comp.position = Vector2(
		-(_health_comp.get_child(0).polygon[1].x / 2 - 5),
		-(_animated_sprite.sprite_frames.get_frame_texture("work", 0).get_height() + 10)
	)
	_health_comp.destroyed.connect(_on_destroyed)

	_resource_manager = get_tree().get_first_node_in_group("resource_manager")
	# Conectar señales
	_resource_timer.timeout.connect(_on_resource_timer_timeout)
	#_range_comp.body_exited.connect(_on_body_exited)
	_base_layer = get_tree().get_first_node_in_group("base_layer")

func take_damage(damage: float) -> void:
	_health_comp.take_damage(damage)

# Cuando el recurso entra en rango, se guarda,se comienza a recolectar y se inicia el ResourceTimer
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

# Lógica de recolectar
func _farm_resource() -> void:
	_animated_sprite.play("work")
	if _current_resource.is_in_group("gold_resource"):
		_resource_manager._increment_gold()
	elif _current_resource.is_in_group("wood_resource"):
		_resource_manager._increment_wood()

# Recolectar cada vez que el ResourceTimer llega a 0
func _on_resource_timer_timeout() -> void:
	if _current_resource != null:
		_farm_resource()

func set_selected(value):
	selected = value
	if selected:
		_animated_sprite.self_modulate = Color.AQUA;
	else:
		_animated_sprite.self_modulate = Color.WHITE;

func set_target():
	if selected:
		_nav_agent.target_position = get_global_mouse_position()
		target = get_global_mouse_position()

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
	queue_free()
