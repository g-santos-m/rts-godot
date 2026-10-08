extends Node

signal last_wave_ended

const NUMBER_OF_WAVES = 3
const ENEMY_COUNTING_INTERVAL = 3

## In minutes.
@export var time_between_waves := 3

var _wave_number := 1
var number_of_active_enemies: int
var _enemy_spawners: Array[Node]

@onready var _wave_timer := $WaveTimer
@onready var _count_enemies_timer := $CountEnemiesTimer
@onready var _printer := Printer.new(name)

func _ready() -> void:
	_wave_timer.timeout.connect(_on_wave_timer_timeout)
	_count_enemies_timer.timeout.connect(_on_count_enemies_timer_timeout)

	_wave_timer.wait_time = time_between_waves * 5
	_wave_timer.one_shot = true
	_wave_timer.start()

	_count_enemies_timer.wait_time = ENEMY_COUNTING_INTERVAL

	_enemy_spawners = get_children().filter(func(child: Node): return child.is_class("Node2D"))

func _on_wave_timer_timeout() -> void:
	_begin_wave()

func _begin_wave() -> void:
	_printer.cprint("wave number %d has begun" % _wave_number)
	for spawner in _enemy_spawners:
		spawner.begin_wave(_wave_number)
	_count_enemies_timer.start()

func _end_wave() -> void:
	_count_enemies_timer.stop()
	_printer.cprint("wave number %d has ended" % _wave_number)
	if _wave_number == NUMBER_OF_WAVES:
		_printer.cprint("last wave has ended")
		last_wave_ended.emit()
	else:
		_wave_timer.start()
		_wave_number += 1

func _on_count_enemies_timer_timeout() -> void:
	number_of_active_enemies = get_tree().get_first_node_in_group("enemies").get_child_count()
	if number_of_active_enemies == 0:
		_end_wave()
