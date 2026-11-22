class_name Worker
extends BaseUnit

var _current_target: StaticBody2D
var _current_resource: StaticBody2D
var _resources: Array[Node]

@onready var _resource_timer := $ResourceTimer
@onready var _range_comp := $RangeComponent


func _ready() -> void:
	super._ready()

	_resource_timer.timeout.connect(_on_resource_timer_timeout)
	_range_comp.setup(_printer)
	_range_comp.body_in_range.connect(_on_body_in_range)
	_resources = get_tree().get_first_node_in_group("resources_node").get_children()


func _physics_process(_delta) -> void:
	if (
			_current_target
			and global_position.distance_to(_current_target.global_position) < 100
	):
		_disable_resource_collision(true)
	super._physics_process(_delta)


func set_target_position(position: Vector2) -> void:
	if _set_overlapping_resource(position):
		_disable_resource_collision(false)
		# El objetivo es el centro de la CollisionShape.
		super.set_target_position(_current_target.get_node("CollisionShape2D").get_global_position())
	else:
		_disable_resource_collision(false)
		super.set_target_position(position)


# Cuando el recurso entra en rango, se guarda,se comienza a recolectar y se
# inicia el ResourceTimer
func _on_body_in_range(body: Node2D, is_in_range: bool) -> void:
	if body == _current_target and is_in_range:
		_nav_agent.velocity = Vector2.ZERO
		_nav_agent.avoidance_priority = 1
		_current_resource = _current_target
		_farm_resource()
		_resource_timer.start()
	elif body == _current_resource and not is_in_range:
		_nav_agent.avoidance_priority = 0.2
		_current_resource = null
		_resource_timer.stop()
		_animated_sprite.stop()


# Lógica de recolectar
func _farm_resource() -> void:
	_animated_sprite.play("animation")
	# Hay que comprobar _current_target otra vez para evitar condiciones de carrera.
	if _current_target and _current_target.is_in_group("gold_resource"):
		_resource_manager.increment_gold()
	elif _current_target and _current_target.is_in_group("wood_resource"):
		_resource_manager.increment_wood()


# Recolectar cada vez que el ResourceTimer llega a 0
func _on_resource_timer_timeout() -> void:
	if _current_target != null:
		_farm_resource()


func _set_overlapping_resource(mouse_position: Vector2) -> bool:
	for resource in _resources:
		if resource.has_point(mouse_position):
			_current_target = resource
			return true
	_current_target = null
	return false


func _disable_resource_collision(is_disabled: bool) -> void:
	_nav_agent.set_navigation_layer_value(1, !is_disabled)
	_nav_agent.set_navigation_layer_value(2, is_disabled)
