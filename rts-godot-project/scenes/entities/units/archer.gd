extends BaseUnit

var _arrow_scene := preload("res://scenes/entities/arrow.tscn")

var _target_enemy: BaseEnemy:
	get():
		return _range_comp.target_enemy
	set(target_enemy):
		_range_comp.target_enemy = target_enemy

@onready var _range_comp := $RangeComponent
@onready var _attack_comp := $RangedAttackComponent

func _ready() -> void:
	super._ready()
	_attack_comp.setup(stats.attack_damage, stats.attack_rate, _printer)
	_attack_comp.projectile_scene = _arrow_scene
	_range_comp.setup(_printer, "BaseEnemy")
	var range_shape: CircleShape2D = _range_comp.get_child(0).shape
	range_shape.radius = stats.detection_range

func _physics_process(_delta: float) -> void:
	# Si no tiene objetivo o el que tenía ha desaparecido, busca otro.
	if _target_enemy == null or not is_instance_valid(_target_enemy):
		_animated_sprite.stop()
		_range_comp.set_target()
		if _target_enemy:
			_nav_agent.target_position = _target_enemy.global_position

	if _target_enemy and _range_comp.overlaps_body(_target_enemy):
		_nav_agent.avoidance_priority = 1
		_animated_sprite.play("animation")
		_animated_sprite.flip_h = _target_enemy.global_position.x < global_position.x
		_attack_comp.attack_target(_target_enemy)
		_nav_agent.velocity = Vector2.ZERO
		return

	if _target_enemy:
		move_destination = _target_enemy.global_position
	super._physics_process(_delta)
