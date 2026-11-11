class_name Tower
extends BaseBuilding

var _arrow_scene := preload("res://scenes/entities/arrow.tscn")

var _current_target: BaseEnemy
var _range_visual_aid := RangeVisualAid.new()

@onready var _range_comp := $RangeComponent
@onready var _attack_comp := $RangedAttackComponent

func _ready() -> void:
	super._ready()
	_attack_comp.setup(stats.attack_damage, stats.attack_rate, _printer)
	_attack_comp.projectile_scene = _arrow_scene
	_range_comp.setup(_printer)
	var range_shape: CircleShape2D = _range_comp.get_child(0).shape
	range_shape.radius = stats.detection_range
	add_child(_range_visual_aid)
	_range_visual_aid.visible = false
	get_tree().get_first_node_in_group("levels").placing_tower.connect(_on_placing_tower)

func _physics_process(_delta: float) -> void:
	# Si no tiene objetivo o el que tenía ha desaparecido, busca otro.
	if _current_target == null or not is_instance_valid(_current_target):
		_set_target()
		if _current_target == null:
			return

	_attack_comp.attack_target(_current_target)

func _set_target() -> void:
	if _range_comp.has_overlapping_bodies():
		var enemies_in_range: Array[Node2D] = \
			_range_comp.get_overlapping_bodies().filter(
				func (body: Node2D) -> bool: return body is BaseEnemy
			)
		if enemies_in_range.size() > 0:
			_current_target = enemies_in_range.pick_random()
			_printer.cprint("is targeting ", _current_target.name, " at ", _current_target.global_position)

func _on_placing_tower(is_placing_tower: bool) -> void:
	_range_visual_aid.visible = is_placing_tower
