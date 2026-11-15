extends Node2D

const _SPEED: int = 220
const _CHASER_OFFSET: Vector2 = Vector2(100, 0)

var _animated_units: Array[Node] = []
var _direction: Vector2
var _chaser_offset_dir: int
var _spawn_point: Vector2
var _end_point: Vector2
var _flip_h: bool
var _is_waiting: bool = false

var _animation_number: int = -1
var _animations: Array[Callable] = [
	_worker,
	_zombie_worker,
	_knight_zombie,
	_fat_zombie_knight,
	_units_fat_zombie,
	_horde_units,
	_reset_animation,
]

@onready var _right_spawn := $RightSpawn
@onready var _left_spawn := $LeftSpawn
@onready var _units := $Units


func _ready() -> void:
	_reset_animation()

func _physics_process(delta: float) -> void:
	if not _is_waiting:
		if _animated_units.size() == 0:
			_animation_number += 1
			_setup_next_animation()
			return

		for unit in _animated_units:
			unit.position += delta * _SPEED * _direction

			if (
					_direction == Vector2.LEFT
					and unit.position.x < _end_point.x
					or
					_direction == Vector2.RIGHT
					and unit.position.x > _end_point.x
			):
				_animated_units.erase(unit)
				unit.queue_free()

func _setup_next_animation() -> void:
	if _animation_number % 2 == 0:
		_direction = Vector2.LEFT
		_chaser_offset_dir = 1
		_spawn_point = _right_spawn.position
		_end_point = _left_spawn.position
		_flip_h = true
	else:
		_direction = Vector2.RIGHT
		_chaser_offset_dir = -1
		_spawn_point = _left_spawn.position
		_end_point = _right_spawn.position
		_flip_h = false

	_animations[_animation_number].call()

	for unit in _animated_units:
		unit.flip_h = _flip_h


func _worker() -> void:
	var worker = Sprite2D.new()
	worker.texture = load("res://assets/textures/entities/units/worker0.png")
	worker.position = _spawn_point
	_units.add_child(worker)
	_animated_units = _units.get_children()


func _zombie_worker() -> void:
	var worker = Sprite2D.new()
	var zombie = Sprite2D.new()
	worker.texture = load("res://assets/textures/entities/units/worker0.png")
	zombie.texture = load("res://assets/textures/entities/enemies/zombie0.png")
	worker.position = _spawn_point
	zombie.position = _spawn_point + _CHASER_OFFSET * _chaser_offset_dir
	_units.add_child(worker)
	_units.add_child(zombie)
	_animated_units = _units.get_children()


func _knight_zombie() -> void:
	var zombie = Sprite2D.new()
	var knight = Sprite2D.new()
	zombie.texture = load("res://assets/textures/entities/enemies/zombie0.png")
	knight.texture = load("res://assets/textures/entities/units/knight0.png")
	zombie.position = _spawn_point
	knight.position = _spawn_point + _CHASER_OFFSET * _chaser_offset_dir
	_units.add_child(zombie)
	_units.add_child(knight)
	_animated_units = _units.get_children()


func _fat_zombie_knight() -> void:
	var knight = Sprite2D.new()
	var fat_zombie = Sprite2D.new()
	knight.texture = load("res://assets/textures/entities/units/knight0.png")
	fat_zombie.texture = load("res://assets/textures/entities/enemies/fat-zombie0.png")
	knight.position = _spawn_point
	fat_zombie.position = _spawn_point + _CHASER_OFFSET * _chaser_offset_dir
	_units.add_child(knight)
	_units.add_child(fat_zombie)
	_animated_units = _units.get_children()


func _units_fat_zombie() -> void:
	var fat_zombie = Sprite2D.new()
	var knight = Sprite2D.new()
	var archer1 = Sprite2D.new()
	var archer2 = Sprite2D.new()
	fat_zombie.texture = load("res://assets/textures/entities/enemies/fat-zombie0.png")
	knight.texture = load("res://assets/textures/entities/units/knight0.png")
	archer1.texture = load("res://assets/textures/entities/units/archer2.png")
	archer2.texture = load("res://assets/textures/entities/units/archer2.png")
	fat_zombie.position = _spawn_point
	knight.position = _spawn_point + _CHASER_OFFSET * _chaser_offset_dir
	archer1.position = _spawn_point + _CHASER_OFFSET * _chaser_offset_dir + Vector2(30, -30)
	archer2.position = _spawn_point + _CHASER_OFFSET * _chaser_offset_dir + Vector2(30, 30)
	_units.add_child(fat_zombie)
	_units.add_child(archer1)
	_units.add_child(knight)
	_units.add_child(archer2)
	_animated_units = _units.get_children()


func _horde_units() -> void:
	var knight = Sprite2D.new()
	var archer1 = Sprite2D.new()
	var archer2 = Sprite2D.new()
	knight.texture = load("res://assets/textures/entities/units/knight0.png")
	archer1.texture = load("res://assets/textures/entities/units/archer2.png")
	archer2.texture = load("res://assets/textures/entities/units/archer2.png")
	knight.position = _spawn_point
	archer1.position = _spawn_point + Vector2(-30, -30)
	archer2.position = _spawn_point + Vector2(-30, 30)
	_units.add_child(archer1)
	_units.add_child(knight)
	_units.add_child(archer2)

	for i in range(20):
		var zombie = Sprite2D.new()
		if randi_range(0, 1) == 0:
			zombie.texture = load("res://assets/textures/entities/enemies/zombie0.png")
		else:
			zombie.texture = load("res://assets/textures/entities/enemies/fat-zombie0.png")
		zombie.position = _spawn_point + _CHASER_OFFSET * 1.7 * _chaser_offset_dir \
				+ Vector2(randi_range(-60, 60), (-60 + i * 5))
		_units.add_child(zombie)

	_animated_units = _units.get_children()

func _reset_animation() -> void:
	_is_waiting = true
	await get_tree().create_timer(3).timeout
	_is_waiting = false
	_animation_number = 0
	_setup_next_animation()
