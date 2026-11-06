class_name BaseEnemy
extends CharacterBody2D

signal destroyed

@export var stats: BaseEnemyStats

static var _next_ids_by_type := {
	"Zombie": 1,
	"FatZombie": 1,
}

var id: int
var _current_target: PhysicsBody2D
var _is_target_in_range := false

var _printer: Printer

@onready var _animated_sprite := $AnimatedSprite2D
@onready var _nav_agent := $NavigationAgent2D
@onready var _attack_comp := $AttackComponent
@onready var _health_comp := $HealthComponent
@onready var _attack_range_comp := $AttackRange
@onready var _detection_range_comp := $DetectionRange

func _ready() -> void:
	id = _next_ids_by_type[stats.enemy_type]
	_next_ids_by_type[stats.enemy_type] += 1
	name = "%s_%s" % [stats.enemy_type, id]
	_printer = Printer.new(name)

	_nav_agent.velocity_computed.connect(_on_velocity_computed)
	_nav_agent.avoidance_priority = 0.2

	# Componentes
	_attack_comp.setup(stats.attack_damage, stats.attack_rate, _printer)
	_health_comp.setup(stats.max_health, _printer)
	_health_comp.destroyed.connect(_on_destroyed)
	_attack_range_comp.setup(_printer)
	_attack_range_comp.body_in_range.connect(_on_body_in_attack_range)
	_detection_range_comp.setup(_printer)
	_detection_range_comp.body_in_range.connect(_on_body_in_detection_range)
	var detection_range_shape: CircleShape2D = _detection_range_comp.get_child(0).shape
	detection_range_shape.radius = stats.detection_range

	_printer.cprint("has spawned at ", global_position)
	_set_closest_building()

func _physics_process(_delta: float) -> void:
	# Si no tiene objetivo el que tenía desaparece, busca otro.
	if _current_target == null or not is_instance_valid(_current_target):
		# Resetea el estado de ataque.
		_set_closest_building()

	# Si no encuentra, se mantiene parado.
	if _current_target == null:
		_animated_sprite.stop()
		_nav_agent.velocity = Vector2.ZERO
		return

	# Si el objetivo esta en rango, para y ataca.
	if _is_target_in_range == true:
		_animated_sprite.play("attack")
		_attack_comp.attack_target(_current_target)
		_nav_agent.velocity = Vector2.ZERO
		return
	# Si no esta en rango, calcula la siguiente posición y se desplaza.
	else:
		_animated_sprite.stop()
		var next_position = _nav_agent.get_next_path_position()
		var direction: Vector2 = global_position.direction_to(next_position)
		_animated_sprite.flip_h = direction.x < 0
		var desired_velocity: Vector2 = direction * stats.movement_speed
		# Con avoidance activado, le pasamos la velocidad al NavigationAgent2D, que devolverá la
		# velocidad correcta con la signal velocity_computed.
		_nav_agent.velocity = desired_velocity

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

# Busca el edificio más cercano.
func _set_closest_building() -> void:
	# Recoge la lista de edificios activos en el mapa.
	var buildings := get_tree().get_first_node_in_group("buildings_node").get_children()

	# Itera sobre la lista calculando la distancia al edificio.
	var closest_building: StaticBody2D = null
	var shortest_distance = INF
	for building in buildings:
		# Cogemos como referencia el centro de su CollisionShape2D, en lugar de la global_position
		# del nodo raíz, que está en los pies del edificio.
		var distance := global_position.distance_to(building.global_position)
		if distance < shortest_distance:
			closest_building = building
			shortest_distance = distance

	if closest_building:
		_set_target(closest_building)

func _set_target(target: PhysicsBody2D) -> void:
	_current_target = target
	_printer.cprint("is targeting ", _current_target.name, " at ", _current_target.global_position)
	_nav_agent.target_position = _current_target.global_position
	#if target.is_class("CharacterBody2D"):
	#	_nav_agent.target_position = _current_target.global_position
	#else:
	#	_nav_agent.target_position = _get_random_target_point(_current_target)

# Calculates a random point within the building's collision shape to direct the enemy to. Avoids
# every enemy piling up on a side of the building.
func _get_random_target_point(building: StaticBody2D) -> Vector2:
	var collision_shape: CollisionShape2D = building.get_children().filter(
		func (node: Node2D) -> bool: return node.is_class("CollisionShape2D")
	)[0]

	var random_target_point_x: int = collision_shape.global_position.x + randi_range(-10, 10)
	var random_target_point_y: int = collision_shape.global_position.y + randi_range(-10, 10)

	return Vector2(random_target_point_x, random_target_point_y)

func _on_body_in_attack_range(body: Node2D, is_in_range: bool) -> void:
	if body == _current_target or _current_target == null:
		_is_target_in_range = is_in_range
		_nav_agent.avoidance_priority = 1 if is_in_range else 0.2

func _on_body_in_detection_range(body: Node2D, is_in_range: bool) -> void:
	if is_in_range and _current_target is not CharacterBody2D:
		_set_target(body)
	else:
		_current_target = null

func _on_destroyed() -> void:
	_printer.cprint("has been destroyed")
	destroyed.emit()
	queue_free()
