extends Control

var _wave_manager: Node
var _next_wave_timer: Timer

@onready var _wave_number_label := $Padding/LayoutHBox/WaveNumberVBox/WaveNumber
@onready var _next_wave_timer_label := $Padding/LayoutHBox/NextWaveTimerVBox/NextWaveTimer
@onready var _enemy_number_label := $Padding/LayoutHBox/EnemyNumberVBox/EnemyNumber

func _ready() -> void:
	_wave_manager = get_tree().get_first_node_in_group("wave_manager")
	# Asume que el WaveTimer es el primer hijo de WaveManager.
	_next_wave_timer = _wave_manager.get_child(0)


func _process(delta: float) -> void:
	_next_wave_timer_label.text = _format_time(_next_wave_timer.time_left)
	_wave_number_label.text = str(_wave_manager.wave_number)
	_enemy_number_label.text = str(_wave_manager.number_of_active_enemies)

func _format_time(time: float) -> String:
	var time_rounded: int = floor(time)
	var minutes: int = time_rounded / 60
	var seconds: int = time_rounded % 60
	return ("%d:%02d" % [minutes, seconds])
