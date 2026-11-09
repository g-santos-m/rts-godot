extends BaseUnit

var _current_resource: PhysicsBody2D = null
var _resource_manager : Node

@onready var _resource_timer := $ResourceTimer

func _ready() -> void:
	super._ready()

	_resource_manager = get_tree().get_first_node_in_group("resource_manager")
	_resource_timer.timeout.connect(_on_resource_timer_timeout)
	#_range_comp.body_exited.connect(_on_body_exited)

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
