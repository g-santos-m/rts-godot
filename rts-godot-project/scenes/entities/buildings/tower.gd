class_name Tower
extends BaseBuilding

var _arrow_scene := preload("res://scenes/entities/arrow.tscn")

var _current_target: BaseEnemy:
	get():
		return _range_comp.target_enemy
	set(target_enemy):
		_range_comp.target_enemy = target_enemy
var _range_visual_aid := RangeVisualAid.new()

@onready var _range_comp := $RangeComponent
@onready var _attack_comp := $RangedAttackComponent

func _ready() -> void:
	super._ready()
	_attack_comp.setup(stats.attack_damage, stats.attack_rate, _printer)
	_attack_comp.projectile_scene = _arrow_scene
	_range_comp.setup(_printer, "BaseEnemy")
	var range_shape: CircleShape2D = _range_comp.get_child(0).shape
	range_shape.radius = stats.detection_range
	add_child(_range_visual_aid)
	_range_visual_aid.visible = false
	get_tree().get_first_node_in_group("levels").placing_tower.connect(_on_placing_tower)

func _physics_process(_delta: float) -> void:
	# Si no tiene objetivo o el que tenía ha desaparecido, busca otro.
	if _current_target == null or not is_instance_valid(_current_target):
		_range_comp.set_target()
		if _current_target == null:
			return

	_attack_comp.attack_target(_current_target)

func _on_placing_tower(is_placing_tower: bool) -> void:
	_range_visual_aid.visible = is_placing_tower
