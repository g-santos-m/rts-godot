extends Node2D

# Configuración de enemigos
@export_enum("Zombie") var enemy_type: String
@export var enemies_per_wave = [0, 0, 0]
## Seconds per enemy spawned.
@export var spawning_rate = 1.0

var _enemy_scene: PackedScene
var _wave_number: int
var _counter := 0

@onready var _spawning_timer := $SpawningTimer

func _ready() -> void:
	_spawning_timer.timeout.connect(_on_spawning_timer_timeout)

	_spawning_timer.wait_time = spawning_rate
	_set_enemy_scene()

func _set_enemy_scene() -> void:
	match enemy_type:
		"Zombie":
			_enemy_scene = preload("res://scenes/entities/enemies/zombie/zombie.tscn")

func begin_wave(wave_number: int) -> void:
	_wave_number = wave_number
	_spawning_timer.start()

func _on_spawning_timer_timeout() -> void:
	if _counter < enemies_per_wave[_wave_number - 1]:
		_spawn_enemy()
		_counter += 1
	else:
		_spawning_timer.stop()
		_counter = 0

func _spawn_enemy() -> void:
	var enemy: CharacterBody2D = _enemy_scene.instantiate()
	enemy.global_position = global_position
	enemy.name = enemy_type.to_lower() + "_" + str(enemy.id)
	get_tree().get_first_node_in_group("enemies").add_child(enemy)
