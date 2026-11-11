extends Area2D

signal body_in_range(body: Node2D, is_in_range: bool)

var _target_type: String
var target_enemy: CharacterBody2D

@onready var _printer: Printer

func setup(printer: Printer, target_type: String = "") -> void:
	_printer = printer
	_target_type = target_type

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func set_target() -> void:
	if has_overlapping_bodies():
		var entities_in_range: Array[Node2D] = \
			get_overlapping_bodies().filter(
				func (body: PhysicsBody2D) -> bool: return _get_base_type(body) == _target_type
			)
		if entities_in_range.size() > 0:
			target_enemy = _get_nearest_target(entities_in_range)
			_printer.cprint("is targeting ", target_enemy.name, " at ", target_enemy.global_position)

func _get_nearest_target(entities: Array[Node2D]) -> CharacterBody2D:
	var nearest_target: Node2D
	var shortest_distance = INF
	for entity in entities:
		var distance := global_position.distance_to(entity.global_position)
		if distance < shortest_distance:
			nearest_target = entity
			shortest_distance = distance
	return nearest_target as CharacterBody2D

func _on_body_entered(body: Node2D) -> void:
	body_in_range.emit(body, true)
	_printer.cprint("has detected ", body.name, " in range")
	if _get_base_type(body) == _target_type:
		if target_enemy == null:
			target_enemy = body

func _on_body_exited(body: Node2D) -> void:
	body_in_range.emit(body, false)
	if _get_base_type(body) == _target_type:
		if body == target_enemy:
			target_enemy = null

func _get_base_type(entity: PhysicsBody2D) -> String:
	if entity != null:
		return entity.get_script().get_base_script().get_global_name()
	else:
		return ""
