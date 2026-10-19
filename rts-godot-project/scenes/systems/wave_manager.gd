extends Node

signal last_wave_ended

const NUMBER_OF_WAVES = 3

## In minutes.
@export var time_between_waves := 3

var wave_number := 1
var _total_enemies_per_wave := [0, 0, 0]
var number_of_active_enemies: int
var _enemy_spawners: Array[Node]

@onready var _wave_timer := $WaveTimer
@onready var _printer := Printer.new(name)

func _ready() -> void:
	_wave_timer.timeout.connect(_on_wave_timer_timeout)

	_wave_timer.wait_time = time_between_waves * 60
	_wave_timer.one_shot = true
	_wave_timer.start()

	_enemy_spawners = get_children().filter(func(child: Node): return child.is_in_group("enemy_spawners"))
	for spawner in _enemy_spawners:
		# Calcula el total de enemigos de cada oleada sumando todos los spawners.
		for wave_index in spawner.enemies_per_wave.size():
			_total_enemies_per_wave[wave_index] += spawner.enemies_per_wave[wave_index]
		# Registra las señales que indican que un enemigo ha sido destruido.
		spawner.enemy_destroyed.connect(_on_enemy_destroyed)
	number_of_active_enemies = _total_enemies_per_wave[wave_number - 1]

func _on_wave_timer_timeout() -> void:
	_begin_wave()

func _begin_wave() -> void:
	_printer.cprint("wave number %d has begun" % wave_number)
	for spawner in _enemy_spawners:
		spawner.begin_wave(wave_number)

func _end_wave() -> void:
	_printer.cprint("wave number %d has ended" % wave_number)
	if wave_number == NUMBER_OF_WAVES:
		_printer.cprint("last wave has ended")
		last_wave_ended.emit()
	else:
		_wave_timer.start()
		wave_number += 1
		number_of_active_enemies = _total_enemies_per_wave[wave_number - 1]

func _on_enemy_destroyed() -> void:
	number_of_active_enemies -= 1
	if number_of_active_enemies == 0:
		_end_wave()
