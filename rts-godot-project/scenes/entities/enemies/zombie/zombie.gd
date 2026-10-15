extends CharacterBody2D

signal destroyed

# Estadísticas
const UNIT_SPEED = 200.0
const ATTACK_DAMAGE = 4.0
const ATTACK_RATE = 1.0      # Segundos entre ataques
const MAX_HEALTH = 10.0

static var id := 1

# Estado
var _current_target: PhysicsBody2D
var _is_target_in_range := false

@onready var _nav_agent := $NavigationAgent2D
@onready var _attack_comp := $AttackComponent
@onready var _range_comp := $RangeComponent
@onready var _health_comp := $HealthComponent

@onready var _printer := Printer.new(name)

func _ready() -> void:
	id += 1
	_attack_comp.setup(ATTACK_DAMAGE, ATTACK_RATE, _printer)
	_range_comp.setup(_printer)
	_range_comp.body_in_range.connect(_on_body_in_range)
	_health_comp.setup(MAX_HEALTH, _printer)
	_health_comp.destroyed.connect(_on_destroyed)

	_printer.cprint("has spawned at ", global_position)
	_set_closest_building()

func _physics_process(delta: float) -> void:
	# Actualiza el objetivo actual. Si no hay objetivo válido, se para.
	if _current_target == null or not is_instance_valid(_current_target):
		# Resetea el estado de ataque.
		_is_target_in_range = false
		$AnimatedSprite2D.stop()
		_set_closest_building()
	if _current_target == null:
		velocity = Vector2.ZERO
		move_and_slide()
		return

	# Pasa la posición del objetivo a NavigationAgent2D.
	_nav_agent.target_position = _current_target.global_position

	# Si el objetivo esta en rango, para y ataca.
	if _is_target_in_range == true:
		velocity = Vector2.ZERO
		$AnimatedSprite2D.play("attack")
		_attack_comp.attack_target(_current_target)
		move_and_slide()
		return

	# Calcula la siguiente posición.
	var next_position = _nav_agent.get_next_path_position()
	var direction: Vector2 = (next_position - global_position).normalized()
	$AnimatedSprite2D.flip_h = direction.x < 0
	velocity = direction * UNIT_SPEED
	move_and_slide()

# Busca el edificio más cercano.
func _set_closest_building() -> void:

	# Recoge la lista de edificios activos en el mapa.
	var buildings := get_tree().get_first_node_in_group("buildings").get_children()

	# Itera sobre la lista calculando la distancia al edificio.
	var closest_building: StaticBody2D = null
	var shortest_distance = INF
	for building in buildings:
		var distance := global_position.distance_to(building.global_position)
		if distance < shortest_distance:
			closest_building = building
			shortest_distance = distance

	# Asigna el edificio más cercano como objetivo.
	_current_target = closest_building
	if _current_target:
		_printer.cprint("is targeting ", _current_target.name, " at ", _current_target.global_position)

func _on_body_in_range(body: PhysicsBody2D) -> void:
	if body == _current_target:
		_is_target_in_range = true

func _on_destroyed() -> void:
	_printer.cprint("has been destroyed")
	destroyed.emit()
	queue_free()
