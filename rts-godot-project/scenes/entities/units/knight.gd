extends BaseUnit

var _target_enemy: BaseEnemy

@onready var _attack_comp := $AttackComponent
@onready var _attack_range_comp := $AttackRange
@onready var _detection_range_comp := $DetectionRange

func _ready() -> void:
	super._ready()

	_attack_comp.setup(stats.attack_damage, stats.attack_rate, _printer)
	_attack_range_comp.setup(_printer)
	_detection_range_comp.setup(_printer)
	_detection_range_comp.body_in_range.connect(_on_body_in_detection_range)
	var detection_range_shape: CircleShape2D = _detection_range_comp.get_child(0).shape
	detection_range_shape.radius = stats.detection_range

func _physics_process(_delta) -> void:
	if _target_enemy == null or not is_instance_valid(_target_enemy):
		_animated_sprite.stop()
		_set_target_enemy()

	if _target_enemy and _attack_range_comp.overlaps_body(_target_enemy):
		_nav_agent.avoidance_priority = 1
		_animated_sprite.play("animation")
		_attack_comp.attack_target(_target_enemy)
		_nav_agent.velocity = Vector2.ZERO
		return

	if _target_enemy:
		move_destination = _target_enemy.global_position
	super._physics_process(_delta)

func _set_target_enemy() -> void:
	if _detection_range_comp.has_overlapping_bodies():
		var enemies_in_range: Array[Node2D] = \
			_detection_range_comp.get_overlapping_bodies().filter(
				func (body: Node2D) -> bool: return body is BaseEnemy
			)
		if enemies_in_range.size() > 0:
			_target_enemy = enemies_in_range.pick_random()
			_printer.cprint("is targeting ", _target_enemy.name, " at ", _target_enemy.global_position)
			_nav_agent.target_position = _target_enemy.global_position

func _on_body_in_detection_range(body: Node2D, is_in_range: bool) -> void:
	if body is BaseEnemy:
		# Enemigo entra en el rango y la unidad no tiene objetivo actualmente.
		if is_in_range and _target_enemy == null:
			_target_enemy = body
		# El enemigo al que se está atacando/persiguiendo sale del rango.
		elif not is_in_range and body == _target_enemy:
			_target_enemy = null
