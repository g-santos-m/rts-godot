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

	# Componentes
	_nav_agent.velocity_computed.connect(_on_velocity_computed)
	_nav_agent.avoidance_priority = 0.2
	_attack_comp.setup(stats.attack_damage, stats.attack_rate, _printer)
	_health_comp.setup(stats.max_health, _printer)
	_health_comp.paint_bar()
	_health_comp.position.y = \
		-(_animated_sprite.sprite_frames.get_frame_texture("attack", 0).get_height() + 10)
	_health_comp.destroyed.connect(_on_destroyed)
	_attack_range_comp.setup(_printer)
	_detection_range_comp.setup(_printer)
	_detection_range_comp.body_in_range.connect(_on_body_in_detection_range)
	var detection_range_shape: CircleShape2D = _detection_range_comp.get_child(0).shape
	detection_range_shape.radius = stats.detection_range

	_printer.cprint("has spawned at ", global_position)

func _physics_process(_delta: float) -> void:
	# Si no tiene objetivo o el que tenía ha desaparecido, busca otro.
	if _current_target == null or not is_instance_valid(_current_target):
		_animated_sprite.stop()
		# Busca primero unidades en rango de detección, si no encuentra, busca el edificio más cercano.
		_set_target_unit()
		if _current_target == null:
			_set_target_building()
			# Si aún así no encuentra, se mantiene parado.
			if _current_target == null:
				_nav_agent.velocity = Vector2.ZERO
				return

	# Si el objetivo esta en rango, para y ataca.
	if _attack_range_comp.overlaps_body(_current_target):
		_nav_agent.avoidance_priority = 1
		_animated_sprite.play("attack")
		_animated_sprite.flip_h = _current_target.global_position.x < global_position.x
		_attack_comp.attack_target(_current_target)
		_nav_agent.velocity = Vector2.ZERO
		return
	# Si no esta en rango, calcula la siguiente posición y se desplaza.
	else:
		_nav_agent.avoidance_priority = 0.2
		_animated_sprite.play("attack")
		_animated_sprite.stop()
		# Si el objetivo es una unidad, se actualiza su posición al NavigationAgent, por si se ha
		# movido.
		if _current_target is BaseUnit:
			_nav_agent.target_position = _current_target.global_position
		var next_position = _nav_agent.get_next_path_position()
		var direction: Vector2 = global_position.direction_to(next_position)
		_animated_sprite.flip_h = direction.x < 0
		var desired_velocity: Vector2 = direction * stats.movement_speed
		# Con avoidance activado, le pasamos la velocidad al NavigationAgent2D, que devolverá la
		# velocidad correcta con la signal velocity_computed.
		_nav_agent.velocity = desired_velocity

func take_damage(damage: float) -> void:
	_health_comp.take_damage(damage)

func _on_velocity_computed(safe_velocity: Vector2) -> void:
	velocity = safe_velocity
	move_and_slide()

func _set_target_unit() -> void:
	if _detection_range_comp.has_overlapping_bodies():
		var entities_in_range: Array[Node2D] = \
			_detection_range_comp.get_overlapping_bodies().filter(
				func (body: Node2D) -> bool: return body is BaseUnit
			)
		if entities_in_range.size() > 0:
			_set_target(_get_nearest_target(entities_in_range))

# Busca el edificio más cercano.
func _set_target_building() -> void:
	# Recoge la lista de edificios activos en el mapa.
	var buildings := get_tree().get_first_node_in_group("buildings_node").get_children()
	# Itera sobre la lista calculando la distancia al edificio.
	if buildings:
		var closest_building: StaticBody2D = null
		var shortest_distance = INF
		for building in buildings:
			var distance := global_position.distance_to(building.global_position)
			if distance < shortest_distance:
				closest_building = building
				shortest_distance = distance
		_set_target(closest_building)

func _set_target(target: PhysicsBody2D) -> void:
	_current_target = target
	_printer.cprint("is targeting ", _current_target.name, " at ", _current_target.global_position)
	_nav_agent.target_position = _current_target.global_position
	#if target.is_class("CharacterBody2D"):
	#	_nav_agent.target_position = _current_target.global_position
	#else:
	#	_nav_agent.target_position = _get_random_target_point(_current_target)

func _get_nearest_target(entities: Array[Node2D]) -> PhysicsBody2D:
	var nearest_target: Node2D
	var shortest_distance = INF
	for entity in entities:
		var distance := global_position.distance_to(entity.global_position)
		if distance < shortest_distance:
			nearest_target = entity
			shortest_distance = distance
	return nearest_target as PhysicsBody2D

# Calcula un punto aleatorio dentro de la CollisionShape2D del objetivo para guardar como target.
# De esta manera se intenta evitar que todos los enemigos se dirijan al mismo punto exacto.
func _get_random_target_point(building: StaticBody2D) -> Vector2:
	var collision_shape: CollisionShape2D = building.get_children().filter(
		func (node: Node2D) -> bool: return node.is_class("CollisionShape2D")
	)[0]

	var random_target_point_x: int = collision_shape.global_position.x + randi_range(-10, 10)
	var random_target_point_y: int = collision_shape.global_position.y + randi_range(-10, 10)

	return Vector2(random_target_point_x, random_target_point_y)

func _on_body_in_detection_range(body: Node2D, is_in_range: bool) -> void:
	if is_in_range and _current_target is not BaseUnit:
		_current_target = body
	elif not is_in_range and body == _current_target:
		_current_target = null

func _on_destroyed() -> void:
	_printer.cprint("has been destroyed")
	destroyed.emit()
	queue_free()
